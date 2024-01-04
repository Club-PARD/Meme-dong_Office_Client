//
//  LoginAPICaller.swift
//  Think
//
//  Created by 김민섭 on 12/28/23.
//

import UIKit

let urlLink = "http://13.125.210.242:8080/" // 서버 주소

// MARK: - Create _ 데이터를 서버에 추가하는 함수
class LoginAPICaller {
    static let shared = LoginAPICaller()
    
    func makeSignUpPostRequest(with email: String, password: String, name: String)-> Bool {
        // 서버 링크가 유효한지 확인
        guard let url = URL(string: "http://13.125.210.242:8080/api/v1/auth/users") else {
            print("🚨 Invalid URL")
            return false
        }
        // request 생성하기
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        // json 형식으로 데이터 전송할 것임
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // POST로 요청할 경우 : json 형식으로 데이터 넘기기
        let body:[String: AnyHashable] = [
            "email": email,
            "password": password,
            "name": name
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                print("🚨 Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                    // 토큰 추출
                    let accessToken = jsonResponse["accessToken"] as? String
//                    let refreshToken = jsonResponse["refreshToken"] as? String
                    print("✅ success: \(jsonResponse)")
                    print("✅ success: \(accessToken)")
//                    print("✅ success: \(refreshToken)")
                    
                    // 추출된 토큰을 TokenManager를 통해 저장
                    if let accessToken = accessToken {
                        TokenManager.shared.saveTokens(accessToken: accessToken)
                    }
                    
                    
                }
            } catch {
                print("🚨 ", error)
            }
        }
        task.resume()
        return true
    }
    
    // MARK: - Login -> 로그인 정보를 구현하는 함수
    func makeLoginRequest(with email: String, password: String, completion: @escaping (Bool) -> Void){
        print("here")
        guard let encodedName = email.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            print("Encoding failed")
            completion(false)
            return
        }
        
        let urlString = "http://13.125.210.242:8080/api/v1/auth/token"
        
        guard let url = URL(string: urlString) else {
            print("🚨 Invalid URL")
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        print(email)
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                print("🚨 \(error?.localizedDescription ?? "Unknown error")")
                completion(false)
                return
            }
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                    // 토큰 추출
                    let accessToken = jsonResponse["accessToken"] as? String
                    
                    print("✅ success: \(jsonResponse)")
                    print("✅ success: \(accessToken)")
                    
                    // 추출된 토큰을 TokenManager를 통해 저장
                    if let accessToken = accessToken {
                        TokenManager.shared.saveTokens(accessToken: accessToken)
                    }
                    
                    let userId = jsonResponse["userId"] as? Int
                    if let id = userId {
                        print(id)
                        UserViewModel.shared.user.id = id
                        print(UserViewModel.shared.user.id)
                    }
                    completion(true)
                }
            } catch {
                print("🚨 ", error)
                completion(false)
            }
        }
        task.resume()
    }
}
    //func deleteRequest(name: String) {
    //    let urlString = "http://3.35.236.83/pard/delete/\(name)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    //
    //    guard let url = URL(string: urlString!) else {
    //        print("🚨 Invalid URL")
    //        return
    //    }
    //
    //    var request = URLRequest(url: url)
    //    request.httpMethod = "DELETE"
    //
    //    let task = URLSession.shared.dataTask(with: request) { data, response, error in
    //        if let error = error {
    //            print("🚨 Error: \(error.localizedDescription)")
    //        } else if let data = data {
    //            do {
    //                let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
    //                print("✅ Delete success: \(response)")
    //                NotificationCenter.default.post(name: .addNotification, object: nil)
    //            } catch {
    //                print("🚨 Error during JSON serialization: \(error.localizedDescription)")
    //            }
    //        }
    //    }
    //    task.resume()
    //}

