import Foundation
import AuthenticationServices

final class AppleLoginViewModel: NSObject {
    
    // NotificationCenter를 사용한 이벤트 발송
    static let signInCompletedNotification = Notification.Name("AppleLoginViewModelSignInCompleted")
    static let signInFailedNotification = Notification.Name("AppleLoginViewModelSignInFailed")
    
    // 애플 로그인
    func performAppleSignIn() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }
}

extension AppleLoginViewModel: ASAuthorizationControllerDelegate {
    
    // 애플 로그인 성공
        func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                // PersonNameComponents를 String으로 변환
                let fullName = [appleIDCredential.fullName?.givenName, appleIDCredential.fullName?.familyName]
                    .compactMap { $0 }
                    .joined(separator: " ")
                
                let user = AppleUser(
                    userIdentifier: appleIDCredential.user,
                    fullName: fullName, // 여기에 String으로 변환된 fullName 사용
                    email: appleIDCredential.email ?? ""
                )
                
                NotificationCenter.default.post(name: AppleLoginViewModel.signInCompletedNotification, object: user)
            }
            // 로그인 성공 후
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
        }
    
    // 애플 로그인 실패
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        NotificationCenter.default.post(name: AppleLoginViewModel.signInFailedNotification, object: error)
        print("Apple Sign In Error: \(error.localizedDescription)")
    }
}

