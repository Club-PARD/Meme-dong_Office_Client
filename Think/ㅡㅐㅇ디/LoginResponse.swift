//
//  LoginResponse.swift
//  Think
//
//  Created by 이신원 on 12/26/23.
//

import Foundation

struct LoginResponse: Codable {
    var accessToken: String
    var tokenType: String
    var refreshToken: String
    var exprTime: Int
    var userId: Int
}
