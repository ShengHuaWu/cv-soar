//
//  SkillsController.swift
//  App
//
//  Created by ShengHua Wu on 25/11/2017.
//

import Foundation

final class SkillsController {
    func getAll(request: Request) throws -> ResponseRepresentable {
        return try Skill.all().makeJSON()
    }
    
    func getOne(request: Request, skill: Skill) throws -> ResponseRepresentable {
        return skill
    }
    
    func create(request: Request) throws -> ResponseRepresentable {
        let skill = try request.skill()
        try skill.save()
        return skill
    }
    
    func update(request: Request, skill: Skill) throws -> ResponseRepresentable {
        let newSkill = try request.skill()
        skill.title = newSkill.title
        try skill.save()
        return skill
    }
    
    func delete(request: Request, skill: Skill) throws -> ResponseRepresentable {
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
