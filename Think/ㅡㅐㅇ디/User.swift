struct User: Codable {
    var id: Int?
    var email: String?
    var name: String?
    var studentsListSimple: [Class]?

    struct Class: Codable {
        var id: Int
    }
}
//thinkthink
