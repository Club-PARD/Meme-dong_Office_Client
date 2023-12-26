import AuthenticationServices

class AppleLoginViewModel: NSObject {
    func performAppleSignIn() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }

    private func processUserSignIn(_ user: AppleUser) {
        NetworkManager.shared.sendAppleUserData(user) { success, error in
            if success {
                NotificationCenter.default.post(name: .userDidLogin, object: nil)
            } else {
                NotificationCenter.default.post(name: .userLoginFailed, object: error)
            }
        }
    }
}

extension AppleLoginViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
           let tokenData = credential.identityToken,
           let token = String(data: tokenData, encoding: .utf8) {
            let user = AppleUser(identityToken: token, email: credential.email ?? "", name: credential.fullName?.givenName ?? "")
            print(user)
            processUserSignIn(user)
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        NotificationCenter.default.post(name: .userLoginFailed, object: error)
    }
}

extension Notification.Name {
    static let userDidLogin = Notification.Name("userDidLogin")
    static let userLoginFailed = Notification.Name("userLoginFailed")
}
