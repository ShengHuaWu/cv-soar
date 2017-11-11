//
//  UserController.swift
//  App
//
//  Created by ShengHua Wu on 28/10/2017.
//

import PostgreSQLProvider
import Foundation

final class UserController {
    private let fileManager: StaticFileManager
    
    init(fileManager: StaticFileManager = StaticFileManager()) {
        self.fileManager = fileManager
    }
    
    func getAll(request: Request) throws -> ResponseRepresentable {
        return try User.all().makeJSON()
    }
    
    func getOne(request: Request, user: User) throws -> ResponseRepresentable {
        return user
    }
    
    func create(request: Request) throws -> ResponseRepresentable {
        let user = try request.user()
        try user.save()
        return user
    }
    
    func update(request: Request, user: User) throws -> ResponseRepresentable {
        let newUser = try request.user()
        user.lastName = newUser.lastName
        user.firstName = newUser.firstName
        user.email = newUser.email
        user.avatar = newUser.avatar
        try user.save()
        return user
    }
    
    func delete(request: Request, user: User) throws -> ResponseRepresentable {
        try user.delete()
        return user
    }
}

extension UserController: ResourceRepresentable {
    typealias Model = User
    
    func makeResource() -> Resource<UserController.Model> {
        return Resource(
            index: getAll,
            store: create,
            show: getOne,
            update: update,
            destroy: delete
        )
    }
}

extension UserController {
    func addRoutes(_ droplet: Droplet) {
        let usersGroup = droplet.grouped("users")
        usersGroup.post(User.parameter, "avatar", handler: uploadAvatar)
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
    fileprivate func user() throws -> User {
        guard let json = json else { throw Abort.badRequest }
        
        return try User(json: json)
    }
}
