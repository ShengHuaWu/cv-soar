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
    static let startDateKey = "startDate"
    static let endDateKey = "endDate"
    
    let storage = Storage()
    
    var school: String
    var degree: String
    var description: String?
    var links: String?
    var startDate: Date
    var endDate: Date?
    
    init(school: String, degree: String, description: String?, links: String?, startDate: Date, endDate: Date?) {
        self.school = school
        self.degree = degree
        self.description = description
        self.links = links
        self.startDate = startDate
        self.endDate = endDate
    }
    
    init(row: Row) throws {
        self.school = try row.get(Education.schoolKey)
        self.degree = try row.get(Education.degreeKey)
        self.description = try row.get(Education.descriptionKey)
        self.links = try row.get(Education.linksKey)
        self.startDate = try row.get(Education.startDateKey)
        self.endDate = try row.get(Education.endDateKey)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Education.schoolKey, school)
        try row.set(Education.degreeKey, degree)
        try row.set(Education.descriptionKey, description)
        try row.set(Education.linksKey, links)
        try row.set(Education.startDateKey, startDate)
        try row.set(Education.endDateKey, endDate)
        
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
        
        self.init(school: school, degree: degree, description: description, links: links, startDate: startDate, endDate: endDate)
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
        
        return json
    }
}

extension Education: ResponseRepresentable {}
