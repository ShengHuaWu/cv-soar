import Vapor

extension Droplet {
    func setupRoutes() throws {
        let usersController = UsersController()
        resource("users", usersController)
        usersController.addRoutes(self)
        
        let experiencesController = ExperiencesController()
        resource("experiences", experiencesController)
        
        let skillsController = SkillsController()
        resource("skills", skillsController)
    }
}
