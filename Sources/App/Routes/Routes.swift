import Vapor
import AuthProvider

extension Droplet {
    func setupRoutes() throws {
        let unauthed = grouped("users")
        let usersController = UsersController()
        unauthed.post("signup", handler: usersController.signup)
        unauthed.post("login", handler: usersController.login)
        
        let tokenMiddleware = TokenAuthenticationMiddleware(User.self)
        let userTokenMatchMiddleware = UserTokenMatchMiddleware()
        let authed = grouped([tokenMiddleware, userTokenMatchMiddleware])
        authed.resource("users", usersController)
        usersController.addAuthedRoutes(authed)
    }
}
