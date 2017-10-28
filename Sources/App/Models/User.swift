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
    
    let storage = Storage()
    
    var lastName: String
    var firstName: String
    var email: String
    
    init(lastName: String, firstName: String, email: String) {
        self.lastName = lastName
        self.firstName = firstName
        self.email = email
    }
    
    init(row: Row) throws {
        self.lastName = try row.get(User.lastNameKey)
        self.firstName = try row.get(User.firstNameKey)
        self.email = try row.get(User.emailKey)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(User.lastNameKey, lastName)
        try row.set(User.firstNameKey, firstName)
        try row.set(User.emailKey, email)
        
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
        self.init(lastName: lastName, firstName: firstName, email: email)
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(User.idKey, id?.string)
        try json.set(User.lastNameKey, lastName)
        try json.set(User.firstNameKey, firstName)
        try json.set(User.emailKey, email)
        
        return json
    }
}

extension User: ResponseRepresentable {}
