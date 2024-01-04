//
//  LoginResponse.swift
//  Think
//
//  Created by 이신원 on 12/26/23.
//

struct User: Codable {
    var id: Int?
    var email: String?
    var name: String?
    var studentsListSimple: [Class]?

    struct Class: Codable {
        var id: Int
    }
}
