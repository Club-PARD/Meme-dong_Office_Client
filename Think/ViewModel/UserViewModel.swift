////
////  UserViewModel.swift
////  Meme_Dong_Office
////
////  Created by hyungjin kim on 12/22/23.
////
//
//import UIKit
//
//class UserViewModel {
//    private var user: User?
//    var userName: String {
//        return user?.name ?? "Loading..."
//    }
//
//    var userId: String {
//        return user?.id ?? "Loading..."
//    }
//
//    func fetchUserData(completion: @escaping () -> Void) {
//        guard let url = URL(string: "http://119.202.40.16:8080/api/v1/users/1") else { return }
//        print("visit")
//        NetworkManager.shared.fetchData(from: url) { [weak self] data, response, error in
//            guard let data = data, error == nil else { return }
//            
//            do {
//                let user = try JSONDecoder().decode(User.self, from: data)
//                self?.user = user
//                print(self?.userId ?? "null")
//                completion()
//            } catch {
//                print("Error decoding User: \(error)")
//            }
//        }
//    }
//}
//
////class UserViewModel {
////    private var users = [AppleUser]()
////
////    var numberOfUsers: Int {
////        return users.count
////    }
////
////    func userName(at index: Int) -> String {
////        return users.indices.contains(index) ? users[index].fullName : "Unknown"
////    }
////
////    func fetchUsersData(completion: @escaping () -> Void) {
////        guard let url = URL(string: "http://119.202.40.16:8080/api/v1/users/1") else { return }
////        NetworkManager.shared.fetchData(from: url) { [weak self] data, _, error in
////            guard let data = data, error == nil else { return }
////            
////            do {
////                print("visit")
////                let decodedUsers = try JSONDecoder().decode([User].self, from: data)
////                self?.users = decodedUsers
////                print(decodedUsers)
////                print("visit")
////                completion()
////            } catch {
////                print("Error decoding Users: \(error)")
////            }
////        }
////    }
////}
