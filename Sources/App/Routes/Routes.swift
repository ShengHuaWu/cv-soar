import Vapor
import AuthProvider

extension Droplet {
    func setupRoutes() throws {
        let tokenMiddleware = TokenAuthenticationMiddleware(User.self)
        let userTokenMatchMiddleware = UserTokenMatchMiddleware()
        let authed = grouped([tokenMiddleware, userTokenMatchMiddleware])
        let usersController = UsersController()
        authed.resource("users", usersController)
        usersController.addRoutes(authed)
        
        let unauthed = grouped("users")
        unauthed.post("signup", handler: usersController.signup)
        unauthed.post("login", handler: usersController.login)
    }
}
