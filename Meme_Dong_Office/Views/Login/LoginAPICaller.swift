////
////  LoginAPICaller.swift
////  Meme_Dong_Office
////
////  Created by 김민섭 on 12/28/23.
////
//
//import UIKit
//
//let urlLink = "http://13.125.210.242:8080/" // 서버 주소
//
//// MARK: - Create _ 데이터를 서버에 추가하는 함수
//func makeSignUpPostRequest(with email: String, password: String, name: String) {
//    // 서버 링크가 유요한지 확인
//    guard let url = URL(string: urlLink + "api/v1/auth/users") else {
//        print("🚨 Invalid URL")
//        return
//    }
//    // request 생성하기
//    var request = URLRequest(url: url)
//    request.httpMethod = "POST"
//    // json 형식으로 데이터 전송할 것임
//    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//    // POST로 요청할 경우 : json 형식으로 데이터 넘기기
//    let body:[String: AnyHashable] = [
//        "email": "string",
//        "password": "string",
//        "name": "string"
//    ]
//    request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
//
//    // data task 생성하기
//    let task = URLSession.shared.dataTask(with: request) { data, _, error in
//        // 응답 처리하기
//        guard let data = data, error == nil else {
//            print("🚨 Error: \(error?.localizedDescription ?? "Unknown error")")
//            return
//        }
//        do {
//            // 데이터를 성공적으로 받은 경우, 해당 데이터를 JSON으로 파싱하기
//            let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//            // 정상적으로 response를 받은 경우, notification center를 사용하여 알림 보내기
//            print("✅ success: \(response)")
//        } catch {
//            print("🚨 ", error)
//        }
//    }
//    // 시작하기. 꼭 적어줘야 함 !
//    task.resume()
//}
//
//// MARK: - Login -> 로그인 정보를 구현하는 함수
//func makeLoginRequest(with idName: String, name: String, age: Int, part: String, imgUrl: String) {
//    guard let encodedName = idName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
//        print("Encoding failed")
//        return
//    }
//
//    let urlString = "http://3.35.236.83/pard/update/\(encodedName)"
//
//    guard let url = URL(string: urlString) else {
//        print("🚨 Invalid URL")
//        return
//    }
//
//    var request = URLRequest(url: url)
//    request.httpMethod = "PATCH"
//    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//    
//    let body: [String: Any] = [
//        "email": "string",
//        "password": "string"
//    ]
//
//    request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
//
//    let task = URLSession.shared.dataTask(with: request) { data, _, error in
//        guard let data = data, error == nil else {
//            print("🚨 \(error?.localizedDescription ?? "Unknown error")")
//            return
//        }
//        do {
//            let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//            print("✅ success: \(response)")
//            DispatchQueue.main.async {
//                DispatchQueue.main.async {
//                    NotificationCenter.default.post(name: .addNotification, object: nil)
//                }
//            }
//        } catch {
//            print("🚨 ", error)
//        }
//    }
//    task.resume()
//}
//
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
