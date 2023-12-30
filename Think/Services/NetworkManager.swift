import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let session = URLSession.shared

    private init() {}

    func sendAppleUserData(_ user: AppleUser, completion: @escaping (Bool, Error?) -> Void) {
        print(user.name)
        guard let url = URL(string: "http://13.125.210.242:8080/api/v1/auth/token") else {
            completion(false, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let userData: [String: Any] = ["identityToken": user.identityToken, "email": user.email, "name": user.name]
        request.httpBody = try? JSONSerialization.data(withJSONObject: userData, options: [])

        let task = session.dataTask(with: request) { data, response, error in
                    if let error = error {
                        completion(false, error)
                        return
                    }

                    guard let data = data else {
                        completion(false, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"]))
                        return
                    }

                    do {
                        let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                                        print("Response received: \(loginResponse)") // Print the decoded response
                                        completion(true, nil)
                    } catch {
                        completion(false, error)
                    }
                }
                task.resume()
    }
}

