//
//  StudentModel.swift
//  Think
//
//  Created by 이신원 on 1/2/24.
//

import UIKit

struct Student: Codable {
    var id: Int?
    var name: String?
    var imageURL: String?
    var birthday: String?
    var allergy: String?
    var studyLevel: String?
    var etc: String?
    var caution: Bool?
}
