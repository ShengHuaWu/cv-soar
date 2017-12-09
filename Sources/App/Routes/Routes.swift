import Vapor
import AuthProvider

extension Droplet {
    func setupRoutes() throws {
        let tokenMiddleware = TokenAuthenticationMiddleware(User.self)
        let authed = grouped(tokenMiddleware)
        let usersController = UsersController()
        authed.resource("users", usersController)
        usersController.addRoutes(authed)
        
        let unauthed = grouped("users")
        unauthed.post("signup", handler: usersController.signup)
        unauthed.post("login", handler: usersController.login)
    }
}
