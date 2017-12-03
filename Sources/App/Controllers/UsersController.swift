//
//  UsersController.swift
//  App
//
//  Created by ShengHua Wu on 25/11/2017.
//

import Foundation

final class UsersController {
    private let fileManager: StaticFileManager
    
    init(fileManager: StaticFileManager = StaticFileManager()) {
        self.fileManager = fileManager
    }
    
    func getOne(request: Request, user: User) throws -> ResponseRepresentable {
        return user
    }
    
    func signup(request: Request) throws -> ResponseRepresentable {
        // TODO: Check if user is duplicated
        let user = try request.user()
        try user.save()
        
        guard let userID = user.id else {
            throw Abort.serverError
        }
        
        // Create a bearer token
        let token = Token(token: UUID().uuidString, userID: userID)
        try token.save()
        
        return try JSON(node: ["user": user.makeJSON(), "token": token.makeJSON()])
    }
    
    // TODO: Implement login feature
//    func login(request: Request) throws -> ResponseRepresentable {
//
//    }
    
    func update(request: Request, user: User) throws -> ResponseRepresentable {
        let newUser = try request.user()
        user.lastName = newUser.lastName
        user.firstName = newUser.firstName
        user.avatar = newUser.avatar
        try user.save()
        return user
    }
    
    func delete(request: Request, user: User) throws -> ResponseRepresentable {
        try user.delete()
        return user
    }
}

extension UsersController: ResourceRepresentable {
    typealias Model = User
    
    func makeResource() -> Resource<UsersController.Model> {
        return Resource(
            show: getOne,
            update: update,
            destroy: delete
        )
    }
}

extension UsersController {
    func addRoutes(_ routeBuilder: RouteBuilder) {
        let usersGroup = routeBuilder.grouped("users")
        usersGroup.post(User.parameter, "avatar", handler: uploadAvatar)
        
        let userExperiencesGroup = usersGroup.grouped(User.parameter)
        let experiencesController = ExperiencesController()
        userExperiencesGroup.resource("experiences", experiencesController)
        
        let userEducationsGroup = usersGroup.grouped(User.parameter)
        let educationsController = EducationsController()
        userEducationsGroup.resource("educations", educationsController)
        
        let userSkillsGroup = usersGroup.grouped(User.parameter)
        let skillsController = SkillsController()
        userSkillsGroup.resource("skills", skillsController)
    }
    
    func uploadAvatar(request: Request) throws -> ResponseRepresentable {
        guard let fileBytes = request.formData?["avatar"]?.part.body,
            let fileExtension = request.data["extension"]?.string else {
                throw Abort.badRequest
        }
        
        let user = try request.parameters.next(User.self)
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
    fileprivate func authedUser() throws -> User {
        return try auth.assertAuthenticated()
    }
    
    fileprivate func user() throws -> User {
        guard let json = json else { throw Abort.badRequest }
        return try User(json: json)
    }
}
