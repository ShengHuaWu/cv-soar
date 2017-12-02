//
//  Skill.swift
//  App
//
//  Created by ShengHua Wu on 25/11/2017.
//

import PostgreSQLProvider

final class Skill: Model {
    static let idKey = "id"
    static let titleKey = "title"
    static let userIDKey = "user_id"
    
    let storage = Storage()
    
    var title: String
    let userID: Identifier
    
    init(title: String, userID: Identifier) {
        self.title = title
        self.userID = userID
    }
    
    init(row: Row) throws {
        self.title = try row.get(Skill.titleKey)
        self.userID = try row.get(Skill.userIDKey)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Skill.titleKey, title)
        try row.set(Skill.userIDKey, userID)
        
        return row
    }
}

extension Skill: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { (creator) in
            creator.id()
            creator.string(Skill.titleKey)
            creator.parent(User.self, optional: false)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension Skill: JSONConvertible {
    convenience init(json: JSON) throws {
        let title: String = try json.get(Skill.titleKey)
        let userID: Identifier = try json.get(Skill.userIDKey)
        
        self.init(title: title, userID: userID)
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Skill.idKey, id?.string)
        try json.set(Skill.titleKey, title)
        try json.set(Skill.userIDKey, userID)
        
        return json
    }
}

extension Skill: ResponseRepresentable {}

extension Skill {
    var user: Parent<Skill, User> {
        return parent(id: userID)
    }
}
