//
//  UserTokenMatchMiddleware.swift
//  App
//
//  Created by ShengHua Wu on 09/12/2017.
//

import HTTP

final class UserTokenMatchMiddleware: Middleware {
    func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        let authedUser = try request.authedUser()
        let user = try request.parameters.next(User.self)
        
        guard authedUser.id == user.id else {
            throw Abort.unauthorized
        }
        
        return try next.respond(to: request)
    }
}
