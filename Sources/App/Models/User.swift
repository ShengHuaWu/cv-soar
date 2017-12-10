//
//  User.swift
//  App
//
//  Created by ShengHua Wu on 28/10/2017.
//

import PostgreSQLProvider
import Foundation
import AuthProvider

final class User: Model {
    static let userKey = "user"
    static let idKey = "id"
    static let lastNameKey = "last_name"
    static let firstNameKey = "first_name"
    static let emailKey = "email"
    static let passwordKey = "password"
    static let avatarKey = "avatar"
    static let tokenKey = "token"
    
    let storage = Storage()
    
    var lastName: String
    var firstName: String
    let email: String
    var password: String
    var avatar: String?
    
    init(lastName: String, firstName: String, email: String, password: String, avatar: String?) {
        self.lastName = lastName
        self.firstName = firstName
        self.email = email
        self.password = password
        self.avatar = avatar
    }
    
    init(row: Row) throws {
        self.lastName = try row.get(User.lastNameKey)
        self.firstName = try row.get(User.firstNameKey)
        self.email = try row.get(User.emailKey)
        self.password = try row.get(User.passwordKey)
        self.avatar = try row.get(User.avatarKey)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(User.lastNameKey, lastName)
        try row.set(User.firstNameKey, firstName)
        try row.set(User.emailKey, email)
        try row.set(User.passwordKey, password)
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
            creator.string(User.passwordKey)
            creator.string(User.avatarKey, optional: true)
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
        let password: String = json[User.passwordKey]?.string ?? ""
        let avatar: String? = try json.get(User.avatarKey)
        self.init(lastName: lastName, firstName: firstName, email: email, password: password, avatar: avatar)
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(User.idKey, id?.string)
        try json.set(User.lastNameKey, lastName)
        try json.set(User.firstNameKey, firstName)
        try json.set(User.emailKey, email)
        try json.set(User.avatarKey, avatar ?? "")
        
        if let token = try token() {
            try json.set(User.tokenKey, token.token)
        }
        
        return try JSON(node: [User.userKey: json])
    }
}

extension User: ResponseRepresentable {}

extension Droplet {
    static var publicDirectoryURL: URL {
        return URL(fileURLWithPath: workingDirectory()).appendingPathComponent("Public", isDirectory: true)
    }
}

extension User {
    var avatarURL: URL? {
        guard let avatar = avatar, !avatar.isEmpty else {
            return nil
        }
        
        return Droplet.publicDirectoryURL.appendingPathExtension(avatar)
    }
    
    func avatarURL(with fileName: String) -> URL {
        return Droplet.publicDirectoryURL.appendingPathComponent(fileName)
    }
}

extension User {
    static func find(with email: String) throws -> User? {
        return try makeQuery().filter(User.emailKey, email).first()
    }
    
    var experiences: Children<User, Experience> {
        return children()
    }
    
    var educations: Children<User, Education> {
        return children()
    }
    
    var skills: Children<User, Skill> {
        return children()
    }
    
    func token() throws -> Token? {
        return try children().first()
    }
}

extension User: TokenAuthenticatable {
    typealias TokenType = Token
}
