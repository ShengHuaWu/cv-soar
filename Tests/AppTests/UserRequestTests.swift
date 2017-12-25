//
//  UserRequestTests.swift
//  AppTests
//
//  Created by ShengHua Wu on 25/12/2017.
//

import XCTest
import HTTP
import Vapor

class UserRequestTests: TestCase {
    // MARK: Properties
    let droplet = try! Droplet.testable()
    
    // MARK: Override Methods
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: Enabled Tests
    func testSignup() throws {
        let parameters = ["first_name": "Jesscia", "last_name": "Lin", "email": "jessica.lin@conichi.com", "password": "0987654321"]
        let header = [HeaderKey.contentType: "application/json"]
        let body = try Body(JSON(node: parameters))
        let request = Request(method: .post, uri: "/users/signup", headers: header, body: body)
        try droplet.testResponse(to: request)
            .assertStatus(is: .ok)
        // TODO: Validate more ...
    }
}

extension UserRequestTests {
    static let allTests = [
        ("testSignup", testSignup)
    ]
}
