//
//  ClassroomViewModel.swift
//  Think
//
//  Created by 이신원 on 1/4/24.
//

import UIKit
import Foundation

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
    
    func modifyStudentDetail(index:Int, completion: @escaping (Bool) -> Void){
        
        guard let studentId = classroom.studentsList?[index].id else {
            print("Invalid student ID")
            completion(false)
            return
        }
        guard let allergy = classroom.studentsList?[index].allergy else {
            print("Invalid student allergy")
            completion(false)
            return
        }
        
        guard let birthday = classroom.studentsList?[index].birthday else {
            print("Invalid student birth")
            completion(false)
            return
        }
        
        guard let etc = classroom.studentsList?[index].etc else {
            print("Invalid student etc")
            completion(false)
            return
        }
        
        guard let url = URL(string: "http://13.125.210.242:8080/api/v1/students/\(studentId)") else {
            fatalError("Invalid URL")
            completion(false)
            return
        }
        print("url")
        print(url)
        print(birthday)
        print(allergy)
        print(etc)
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        
        let updateData: [String: Any] = [
            "id": studentId,
            "birthday" : birthday,
            "allergy": allergy,
            "etc": etc
        ]
        
        do {
            
            let jsonData = try? JSONSerialization.data(withJSONObject: updateData, options: .fragmentsAllowed)
            
            request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
        } catch {
            print("JSON Data encoding error: \(error)")
            completion(false)
            return
        }

        
        // 토큰 매니져에서 불러주기
        if let accessToken = TokenManager.shared.getAccessToken() {
            print(accessToken)
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        } else {
            print("Error: Access token is not available.")
            completion(false)
            return
        }
        
        // URLSession을 사용하여 요청을 전송합니다.
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // 오류 확인
            if let error = error {
                print("Error: \(error)")
                return
            }

            // HTTP 응답 상태 코드 확인
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                print("HTTP Error: \(httpResponse.statusCode)")
                return
            }

            // 응답 데이터 처리
            if let data = data {
                // 데이터를 처리하는 로직을 작성합니다. 예: JSON 파싱
                print("Received data: \(data)")
                completion(true)
            }
        }

        // 요청 시작
        task.resume()
        
    }
}


//var id: Int?
//var name: String?
//var imageURL: String?
//var birthday: String?
//var allergy: String?
//var studyLevel: String?
//var etc: String?
//var caution: Bool?
