//
//  Token.swift
//  App
//
//  Created by ShengHua Wu on 03/12/2017.
//

import PostgreSQLProvider

final class Token: Model {
    static let idKey = "id"
    static let tokenKey = "token"
    static let userIDKey = "user_id"
    
    let storage = Storage()
    
    let token: String
    let userID: Identifier
    
    init(token: String, userID: Identifier) {
        self.token = token
        self.userID = userID
    }
    
    init(row: Row) throws {
        self.token = try row.get(Token.tokenKey)
        self.userID = try row.get(Token.userIDKey)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Token.tokenKey, token)
        try row.set(Token.userIDKey, userID)
        
        return row
    }
}

extension Token: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { (creator) in
            creator.id()
            creator.string(Token.tokenKey)
            creator.parent(User.self, optional: false)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension Token: JSONConvertible {
    convenience init(json: JSON) throws {
        let token: String = try json.get(Token.tokenKey)
        let userID: Identifier = try json.get(Token.userIDKey)
        self.init(token: token, userID: userID)
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Token.idKey, id)
        try json.set(Token.tokenKey, token)
        try json.set(Token.userIDKey, userID)
        
        return json
    }
}

extension Token: ResponseRepresentable {}

extension Token {
    var user: Parent<Token, User> {
        return parent(id: userID)
    }
}

