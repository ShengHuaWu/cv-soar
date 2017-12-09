//
//  EducationsController.swift
//  App
//
//  Created by ShengHua Wu on 26/11/2017.
//

import Foundation

final class EducationsController {
    func getAll(request: Request) throws -> ResponseRepresentable {
        let user = try request.authedUser()
        return try user.educations.all().makeJSON()
    }
    
    func getOne(request: Request, education: Education) throws -> ResponseRepresentable {
        return education
    }
    
    func create(request: Request) throws -> ResponseRepresentable {
        let education = try request.education()
        try education.save()
        return education
    }
    
    func update(request: Request, education: Education) throws -> ResponseRepresentable {
        let newEducation = try request.education()
        education.school = newEducation.school
        education.degree = newEducation.degree
        education.description = newEducation.description
        education.links = newEducation.links
        education.startDate = newEducation.startDate
        education.endDate = newEducation.endDate
        try education.save()
        return education
    }
    
    func delete(request: Request, education: Education) throws -> ResponseRepresentable {
        try education.delete()
        return education
    }
}

extension EducationsController: ResourceRepresentable {
    typealias Model = Education
    
    func makeResource() -> Resource<EducationsController.Model> {
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
    fileprivate func education() throws -> Education {
        guard let json = json else { throw Abort.badRequest }
        
        return try Education(json: json)
    }
}
