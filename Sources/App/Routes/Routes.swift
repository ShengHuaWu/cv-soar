import Vapor

extension Droplet {
    func setupRoutes() throws {
        let userController = UserController()
        resource("users", userController)
        userController.addRoutes(self)
        
        let experienceController = ExperienceController()
        resource("experiences", experienceController)
    }
}
