import Vapor

extension Droplet {
    func setupRoutes() throws {
        let userController = UserController()
        resource("users", userController)
    }
}
