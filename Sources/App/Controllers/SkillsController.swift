//
//  SkillsController.swift
//  App
//
//  Created by ShengHua Wu on 25/11/2017.
//

import Foundation

final class SkillsController {
    static let skillsKey = "skills"
    static let skillKey = "skill"
    
    private func getAll(request: Request) throws -> ResponseRepresentable {
        let user = try request.authedUser()
        return try JSON(node: [SkillsController.skillsKey: user.skills.all()])
    }
    
    private func getOne(request: Request, skill: Skill) throws -> ResponseRepresentable {
        return try JSON(node: [SkillsController.skillKey: skill])
    }
    
    private func create(request: Request) throws -> ResponseRepresentable {
        let skill = try request.skill()
        try skill.save()
        return try JSON(node: [SkillsController.skillKey: skill])
    }
    
    private func update(request: Request, skill: Skill) throws -> ResponseRepresentable {
        let newSkill = try request.skill()
        skill.title = newSkill.title
        try skill.save()
        return try JSON(node: [SkillsController.skillKey: skill])
    }
    
    private func delete(request: Request, skill: Skill) throws -> ResponseRepresentable {
        try skill.delete()
        return try JSON(node: [SkillsController.skillKey: skill])
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
