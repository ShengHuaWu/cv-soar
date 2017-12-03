import Vapor
import AuthProvider

extension Droplet {
    func setupRoutes() throws {
        let tokenMiddleware = TokenAuthenticationMiddleware(User.self)
        let authed = grouped(tokenMiddleware)
        let usersController = UsersController()
        authed.resource("users", usersController)
        usersController.addRoutes(authed)
        
        post("users", "signup", handler: usersController.signup)
//        post("users", "login", handler: )
    }
}
