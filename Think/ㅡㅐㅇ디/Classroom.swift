//
//  Class.swift
//  Think
//
//  Created by 이신원 on 1/4/24.
//

struct Classroom: Codable {
    var id: Int?
    var createdAt:String?
    var name: String?
    var listRow: Int?
    var listCol: Int?
    var seatSpacing: Bool?
    var studentsCount: Int?
    var studentsList: [Student]?
}
