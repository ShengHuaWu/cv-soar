import Vapor

extension Droplet {
    func setupRoutes() throws {
        let usersController = UsersController()
        resource("users", usersController)
        usersController.addRoutes(self)
    }
}
