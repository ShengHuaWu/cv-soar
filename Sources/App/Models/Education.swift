//
//  Education.swift
//  App
//
//  Created by ShengHua Wu on 26/11/2017.
//

import PostgreSQLProvider

final class Education: Model {
    static let idKey = "id"
    static let schoolKey = "school"
    static let degreeKey = "degree"
    static let descriptionKey = "description"
    static let linksKey = "links"
    static let startDateKey = "start_date"
    static let endDateKey = "end_date"
    static let userIDKey = "user_id"
    
    let storage = Storage()
    
    var school: String
    var degree: String
    var description: String?
    var links: String?
    var startDate: Date
    var endDate: Date?
    let userID: Identifier
    
    init(school: String, degree: String, description: String?, links: String?, startDate: Date, endDate: Date?, userID: Identifier) {
        self.school = school
        self.degree = degree
        self.description = description
        self.links = links
        self.startDate = startDate
        self.endDate = endDate
        self.userID = userID
    }
    
    init(row: Row) throws {
        self.school = try row.get(Education.schoolKey)
        self.degree = try row.get(Education.degreeKey)
        self.description = try row.get(Education.descriptionKey)
        self.links = try row.get(Education.linksKey)
        self.startDate = try row.get(Education.startDateKey)
        self.endDate = try row.get(Education.endDateKey)
        self.userID = try row.get(Education.userIDKey)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Education.schoolKey, school)
        try row.set(Education.degreeKey, degree)
        try row.set(Education.descriptionKey, description)
        try row.set(Education.linksKey, links)
        try row.set(Education.startDateKey, startDate)
        try row.set(Education.endDateKey, endDate)
        try row.set(Education.userIDKey, userID)
        
        return row
    }
}

extension Education: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { (creator) in
            creator.id()
            creator.string(Education.schoolKey)
            creator.string(Education.degreeKey)
            creator.string(Education.descriptionKey, optional: true)
            creator.string(Education.linksKey, optional: true)
            creator.date(Education.startDateKey)
            creator.date(Education.endDateKey, optional: true)
            creator.parent(User.self, optional: false)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension Education: JSONConvertible {
    convenience init(json: JSON) throws {
        let school: String = try json.get(Education.schoolKey)
        let degree: String = try json.get(Education.degreeKey)
        let description: String? = try json.get(Education.descriptionKey)
        let links: String? = try json.get(Education.linksKey)
        let startDate: Date = try json.get(Education.startDateKey)
        let endDate: Date? = try json.get(Education.endDateKey)
        let userID: Identifier = try json.get(Education.userIDKey)
        
        self.init(school: school, degree: degree, description: description, links: links, startDate: startDate, endDate: endDate, userID: userID)
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Education.idKey, id)
        try json.set(Education.schoolKey, school)
        try json.set(Education.degreeKey, degree)
        try json.set(Education.descriptionKey, description ?? "")
        try json.set(Education.linksKey, links ?? "")
        try json.set(Education.startDateKey, startDate)
        try json.set(Education.endDateKey, endDate)
        try json.set(Education.userIDKey, userID)
        
        return json
    }
}

extension Education: ResponseRepresentable {}

extension Education {
    var user: Parent<Education, User> {
        return parent(id: userID)
    }
}
