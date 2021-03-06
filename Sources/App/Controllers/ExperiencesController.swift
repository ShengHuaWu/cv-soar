//
//  ExperiencesController.swift
//  App
//
//  Created by ShengHua Wu on 25/11/2017.
//

import Foundation

final class ExperiencesController {
    static let experiencesKey = "experiences"
    static let experienceKey = "experience"
    
    private func getAll(request: Request) throws -> ResponseRepresentable {
        let user = try request.authedUser()
        return try JSON(node: [ExperiencesController.experiencesKey: user.experiences.all()])
    }
    
    private func getOne(request: Request, experience: Experience) throws -> ResponseRepresentable {
        return try JSON(node: [ExperiencesController.experienceKey: experience])
    }
    
    private func create(request: Request) throws -> ResponseRepresentable {
        let experience = try request.experience()
        try experience.save()
        return try JSON(node: [ExperiencesController.experienceKey: experience])
    }
    
    private func update(request: Request, experience: Experience) throws -> ResponseRepresentable {
        let newExperience = try request.experience()
        experience.title = newExperience.title
        experience.company = newExperience.company
        experience.location = newExperience.location
        experience.description = newExperience.description
        experience.links = newExperience.links
        experience.startDate = newExperience.startDate
        experience.endDate = newExperience.endDate
        try experience.save()
        return try JSON(node: [ExperiencesController.experienceKey: experience])
    }
    
    func delete(request: Request, experience: Experience) throws -> ResponseRepresentable {
        try experience.delete()
        return try JSON(node: [ExperiencesController.experienceKey: experience])
    }
}

extension ExperiencesController: ResourceRepresentable {
    typealias Model = Experience
    
    func makeResource() -> Resource<ExperiencesController.Model> {
        return Resource(
            index: getAll,
            store: create,
            show: getOne,
            update: update,
            destroy: delete
        )
    }
}

extension Request {
    fileprivate func experience() throws -> Experience {
        guard let json = json else { throw Abort.badRequest }
        
        return try Experience(json: json)
    }
}
