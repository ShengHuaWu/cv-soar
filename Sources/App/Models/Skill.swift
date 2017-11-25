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
    
    let storage = Storage()
    
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    init(row: Row) throws {
        self.title = try row.get(Skill.titleKey)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Skill.titleKey, title)
        return row
    }
}

extension Skill: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { (creator) in
            creator.id()
            creator.string(Skill.titleKey)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension Skill: JSONConvertible {
    convenience init(json: JSON) throws {
        let title: String = try json.get(Skill.titleKey)
        
        self.init(title: title)
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Skill.idKey, id?.string)
        try json.set(Skill.titleKey, title)
        
        return json
    }
}

extension Skill: ResponseRepresentable {}
