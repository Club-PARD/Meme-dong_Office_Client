//
//  ClassroomViewModel.swift
//  Think
//
//  Created by 이신원 on 1/4/24.
//

import UIKit

class ClassroomViewModel{
    static let shared = ClassroomViewModel()
    
    var classroom: Classroom = Classroom()
    
    func loadClassroomData(classId: Int, completion: @escaping (Bool) -> Void) {
        let urlString = "http://13.125.210.242:8080/api/v1/students/list/\(classId)"
        guard let url = URL(string: urlString) else {
            completion(false)
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
            completion(false)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in // 'request' 사용
            guard error == nil else {
                print("오류 발생: \(error!.localizedDescription)")
                completion(false)
                return
            }
            
            guard let data = data else {
                print("데이터 없음")
                completion(false)
                return
            }
            
            if let dataString = String(data: data, encoding: .utf8) {
                print("받은 데이터: \(dataString)")
            }
            
            do {
                let classroom = try JSONDecoder().decode(Classroom.self, from: data)
                self?.classroom = classroom
                completion(true)
            } catch {
                print("JSON 디코딩 실패: \(error)")
                completion(false)
            }
        }
        task.resume()
    }
    
    
    func sendClassroomData(jsonData: Data,completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://13.125.210.242:8080/api/v1/students/list") else {
            completion(false)
            return
        }
        //guard let jsonData = convertDataToJSON() else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 토큰 매니져에서 불러주기
        if let accessToken = TokenManager.shared.getAccessToken() {
            print(accessToken)
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        } else {
            print("Error: Access token is not available.")
            completion(false)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending data to server: \(error)")
                completion(false)
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 && httpResponse.statusCode != 201 {
                    print("HTTP Error: \(httpResponse.statusCode)")
                    completion(false)
                    return
                }
                // Handle response data if needed
                print("Data sent successfully with status code: \(httpResponse.statusCode)")
                completion(true)
            } else {
                print("No HTTP response received.")
                completion(false)
            }
        }

        task.resume()


    }
}
