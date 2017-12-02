//
//  Experience.swift
//  App
//
//  Created by ShengHua Wu on 19/11/2017.
//

import PostgreSQLProvider

final class Experience: Model {
    static let idKey = "id"
    static let titleKey = "title"
    static let companyKey = "company"
    static let locationKey = "location"
    static let descriptionKey = "description"
    static let linksKey = "links"
    static let startDateKey = "start_date"
    static let endDateKey = "end_date"
    static let userIDKey = "user_id"
    
    let storage = Storage()

    var title: String
    var company: String
    var location: String
    var description: String?
    var links: String?
    var startDate: Date
    var endDate: Date?
    let userID: Identifier
    
    init(title: String, company: String, location: String, description: String?, links: String?, startDate: Date, endDate: Date?, userID: Identifier) {
        self.title = title
        self.company = company
        self.location = location
        self.description = description
        self.links = links
        self.startDate = startDate
        self.endDate = endDate
        self.userID = userID
    }
    
    init(row: Row) throws {
        self.title = try row.get(Experience.titleKey)
        self.company = try row.get(Experience.companyKey)
        self.location = try row.get(Experience.locationKey)
        self.description = try row.get(Experience.descriptionKey)
        self.links = try row.get(Experience.linksKey)
        self.startDate = try row.get(Experience.startDateKey)
        self.endDate = try row.get(Experience.endDateKey)
        self.userID = try row.get(Experience.userIDKey)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Experience.titleKey, title)
        try row.set(Experience.companyKey, company)
        try row.set(Experience.locationKey, location)
        try row.set(Experience.descriptionKey, description)
        try row.set(Experience.linksKey, links)
        try row.set(Experience.startDateKey, startDate)
        try row.set(Experience.endDateKey, endDate)
        try row.set(Experience.userIDKey, userID)
        
        return row
    }
}

extension Experience: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { (creator) in
            creator.id()
            creator.string(Experience.titleKey)
            creator.string(Experience.companyKey)
            creator.string(Experience.locationKey)
            creator.string(Experience.descriptionKey, optional: true)
            creator.string(Experience.linksKey, optional: true)
            creator.date(Experience.startDateKey)
            creator.date(Experience.endDateKey, optional: true)
            creator.parent(User.self, optional: false)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension Experience: JSONConvertible {
    convenience init(json: JSON) throws {
        let title: String = try json.get(Experience.titleKey)
        let company: String = try json.get(Experience.companyKey)
        let location: String = try json.get(Experience.locationKey)
        let description: String? = try json.get(Experience.descriptionKey)
        let links: String? = try json.get(Experience.linksKey)
        let startDate: Date = try json.get(Experience.startDateKey)
        let endDate: Date? = try json.get(Experience.endDateKey)
        let userID: Identifier = try json.get(Experience.userIDKey)
        
        self.init(title: title, company: company, location: location, description: description, links: links, startDate: startDate, endDate: endDate, userID: userID)
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Experience.idKey, id?.string)
        try json.set(Experience.titleKey, title)
        try json.set(Experience.companyKey, company)
        try json.set(Experience.locationKey, location)
        try json.set(Experience.descriptionKey, description ?? "")
        try json.set(Experience.linksKey, links ?? "")
        try json.set(Experience.startDateKey, startDate)
        try json.set(Experience.endDateKey, endDate)
        try json.set(Experience.userIDKey, userID)
        
        return json
    }
}

extension Experience: ResponseRepresentable {}

extension Experience {
    var user: Parent<Experience, User> {
        return parent(id: userID)
    }
}
