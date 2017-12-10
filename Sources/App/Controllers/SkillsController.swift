//
//  SkillsController.swift
//  App
//
//  Created by ShengHua Wu on 25/11/2017.
//

import Foundation

final class SkillsController {
    private func getAll(request: Request) throws -> ResponseRepresentable {
        let user = try request.authedUser()
        return try user.skills.all().makeJSON()
    }
    
    private func getOne(request: Request, skill: Skill) throws -> ResponseRepresentable {
        return skill
    }
    
    private func create(request: Request) throws -> ResponseRepresentable {
        let skill = try request.skill()
        try skill.save()
        return skill
    }
    
    private func update(request: Request, skill: Skill) throws -> ResponseRepresentable {
        let newSkill = try request.skill()
        skill.title = newSkill.title
        try skill.save()
        return skill
    }
    
    private func delete(request: Request, skill: Skill) throws -> ResponseRepresentable {
        try skill.delete()
        return skill
    }
}

extension SkillsController: ResourceRepresentable {
    typealias Model = Skill
    
    func makeResource() -> Resource<SkillsController.Model> {
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
    fileprivate func skill() throws -> Skill {
        guard let json = json else { throw Abort.badRequest }
        
        return try Skill(json: json)
    }
}
