import UIKit

class UserViewModel {
    static let shared = UserViewModel()

    var user: User = User()

    func loadUserData(userId: Int, completion: @escaping (Bool, User?) -> Void) {
        let urlString = "http://13.125.210.242:8080/api/v1/users/\(userId)"
                guard let url = URL(string: urlString) else {
                    completion(false, nil)
                    return
                }

                var request = URLRequest(url: url)
                request.httpMethod = "GET" // GET 요청 명시
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")

                // 토큰 매니저에서 액세스 토큰 불러오기
                if let accessToken = TokenManager.shared.getAccessToken() {
                    request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
                } else {
                    print("Error: Access token is not available.")
                    completion(false, nil) // 토큰 없을 경우 콜백 호출
                    return
                }
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in // 'request' 사용
            guard error == nil else {
                print("오류 발생: \(error!.localizedDescription)")
                completion(false, nil)
                return
            }

            guard let data = data else {
                print("데이터 없음")
                completion(false, nil)
                return
            }

            if let dataString = String(data: data, encoding: .utf8) {
                print("받은 데이터: \(dataString)")
            }

            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                self?.user = user
                completion(true, user)
            } catch {
                print("JSON 디코딩 실패: \(error)")
                completion(false, nil)
            }
        }
        task.resume()
       
    }
}

