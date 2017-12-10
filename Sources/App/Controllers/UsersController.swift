//
//  UsersController.swift
//  App
//
//  Created by ShengHua Wu on 25/11/2017.
//

import Foundation

final class UsersController {
    static let emailKey = "email"
    static let passwordKey = "password"
    static let avatarKey = "avatar"
    static let extensionKey = "extension"
    
    private let fileManager: StaticFileManager
    
    init(fileManager: StaticFileManager = StaticFileManager()) {
        self.fileManager = fileManager
    }
    
    func signup(request: Request) throws -> ResponseRepresentable {
        let user = try request.user()
        guard try User.find(with: user.email) == nil else {
            throw Abort.badRequest
        }
        
        try user.save()
        guard let userID = user.id else {
            throw Abort.serverError
        }
        
        let token = Token(token: UUID().uuidString, userID: userID)
        try token.save()
        
        return user
    }
    
    func login(request: Request) throws -> ResponseRepresentable {
        guard let email = request.json?[UsersController.emailKey]?.string,
            let password = request.json?[UsersController.passwordKey]?.string,
            let user = try User.find(with: email),
            password == user.password else {
            throw Abort.badRequest
        }
        
        return user
    }
    
    func getOne(request: Request, user: User) throws -> ResponseRepresentable {
        return user
    }
    
    func update(request: Request, user: User) throws -> ResponseRepresentable {
        let newUser = try request.user()
        user.lastName = newUser.lastName
        user.firstName = newUser.firstName
        user.password = newUser.password
        user.avatar = newUser.avatar
        try user.save()
        
        return user
    }
}

extension UsersController: ResourceRepresentable {
    typealias Model = User
    
    func makeResource() -> Resource<UsersController.Model> {
        return Resource(
            show: getOne,
            update: update
        )
    }
}

extension UsersController {
    func addAuthedRoutes(_ authedRoute: RouteBuilder) {
        let authedUserRoute = authedRoute.grouped("users", User.parameter)
        authedUserRoute.post("avatar", handler: uploadAvatar)
        
        let experiencesController = ExperiencesController()
        authedUserRoute.resource("experiences", experiencesController)
        
        let educationsController = EducationsController()
        authedUserRoute.resource("educations", educationsController)
        
        let skillsController = SkillsController()
        authedUserRoute.resource("skills", skillsController)
    }
    
    func uploadAvatar(request: Request) throws -> ResponseRepresentable {
        guard let fileBytes = request.formData?[UsersController.avatarKey]?.part.body,
            let fileExtension = request.data[UsersController.extensionKey]?.string else {
                throw Abort.badRequest
        }
        
        let user = try request.authedUser()
        // Remove previous avatar image
        if let avatarURL = user.avatarURL, fileManager.fileExist(at: avatarURL) {
            try fileManager.removeFile(at: avatarURL)
        }
        
        // Save new avatar image
        let fileName = UUID().uuidString + "." + fileExtension
        try fileManager.save(bytes: fileBytes, to: user.avatarURL(with: fileName))
        user.avatar = fileName
        try user.save()
        
        return try user.makeJSON()
    }
}

extension Request {
    func authedUser() throws -> User {
        return try auth.assertAuthenticated()
    }
    
    fileprivate func user() throws -> User {
        guard let json = json else { throw Abort.badRequest }
        return try User(json: json)
    }
}
