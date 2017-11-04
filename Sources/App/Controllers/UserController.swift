//
//  UserController.swift
//  App
//
//  Created by ShengHua Wu on 28/10/2017.
//

import PostgreSQLProvider
import Foundation

extension Droplet {
    static var publicDirectoryURL: URL {
        return URL(fileURLWithPath: workingDirectory()).appendingPathComponent("Public", isDirectory: true)
    }
    
    static var resourcesDirectory: String {
        return "Resources"
    }
}

final class UserController {
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
        
        let fileName = UUID().uuidString + "." + fileExtension
        let fileURL = Droplet.publicDirectoryURL.appendingPathComponent(Droplet.resourcesDirectory, isDirectory: true).appendingPathComponent(fileName)
        
        do {
            let data = Data(bytes: fileBytes)
            try data.write(to: fileURL)
        } catch {
            throw Abort.serverError
        }
        
        // TODO: Save to User property before returning
        let port = request.uri.port ?? 80
        let avatarURLString = request.uri.scheme + "://" + request.uri.hostname + ":\(port)" + "/" + Droplet.resourcesDirectory + "/" + fileName
        return try JSON(node: ["avatar" : avatarURLString])
    }
}

extension Request {
    fileprivate func user() throws -> User {
        guard let json = json else { throw Abort.badRequest }
        
        return try User(json: json)
    }
}
