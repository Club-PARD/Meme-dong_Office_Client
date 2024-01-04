//
//  ClassModel.swift
//  Think
//
//  Created by 이신원 on 1/2/24.
//

import UIKit

struct ClassModel{
    let id: Int
    let createdDate: String
    let row:Int
    let col:Int
    let seatSpacing: String
    let studentCount: Int
    var studentList: [Student]
}

