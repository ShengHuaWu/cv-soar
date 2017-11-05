//
//  User.swift
//  App
//
//  Created by ShengHua Wu on 28/10/2017.
//

import PostgreSQLProvider

final class User: Model {
    static let idKey = "id"
    static let lastNameKey = "lastName"
    static let firstNameKey = "firstName"
    static let emailKey = "email"
    static let avatarKey = "avatar"
    
    let storage = Storage()
    
    var lastName: String
    var firstName: String
    var email: String
    var avatar: String?
    
    init(lastName: String, firstName: String, email: String, avatar: String?) {
        self.lastName = lastName
        self.firstName = firstName
        self.email = email
        self.avatar = avatar
    }
    
    init(row: Row) throws {
        self.lastName = try row.get(User.lastNameKey)
        self.firstName = try row.get(User.firstNameKey)
        self.email = try row.get(User.emailKey)
        self.avatar = try row.get(User.avatarKey)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(User.lastNameKey, lastName)
        try row.set(User.firstNameKey, firstName)
        try row.set(User.emailKey, email)
        try row.set(User.avatarKey, avatar)
        
        return row
    }
}

extension User: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { (creator) in
            creator.id()
            creator.string(User.lastNameKey)
            creator.string(User.firstNameKey)
            creator.string(User.emailKey)
        }
        
        try database.modify(self) { (modifier) in
            modifier.string(User.avatarKey, optional: true)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension User: JSONConvertible {
    convenience init(json: JSON) throws {
        let lastName: String = try json.get(User.lastNameKey)
        let firstName: String = try json.get(User.firstNameKey)
        let email: String = try json.get(User.emailKey)
        let avatar: String? = try json.get(User.avatarKey)
        self.init(lastName: lastName, firstName: firstName, email: email, avatar: avatar)
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(User.idKey, id?.string)
        try json.set(User.lastNameKey, lastName)
        try json.set(User.firstNameKey, firstName)
        try json.set(User.emailKey, email)
        try json.set(User.avatarKey, avatar ?? "")
        
        return json
    }
}

extension User: ResponseRepresentable {}