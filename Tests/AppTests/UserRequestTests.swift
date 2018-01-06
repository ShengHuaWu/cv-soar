//
//  UserRequestTests.swift
//  AppTests
//
//  Created by ShengHua Wu on 25/12/2017.
//

import XCTest
import HTTP
import Vapor

@testable import App

class UserRequestTests: TestCase {
    // MARK: Properties
    let droplet = try! Droplet.testable()
    let header = [HeaderKey.contentType: "application/json"]
    
    // MARK: Override Methods
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: Enabled Tests
    func testSignupWithSuccess() throws {
        let parameters = ["first_name": "ShengHua", "last_name": "Wu", "email": "shenghua.wu@conichi.com", "password": "0987654321"]
        let body = try Body(JSON(node: parameters))
        let request = Request(method: .post, uri: "/users/signup", headers: header, body: body)
        try droplet.testResponse(to: request)
            .assertStatus(is: .ok)
            .assertJSON("user") { json in
                return json["first_name"] == "ShengHua"
        }
    }
    
    func testSignupWithFailureIfUserAlreadyExists() throws {
        let parameters = ["first_name": "Joseph", "last_name": "Tseng", "email": "joseph.tseng@conichi.com", "password": "0987654321"]
        let body = try Body(JSON(node: parameters))
        let request = Request(method: .post, uri: "/users/signup", headers: header, body: body)
        try droplet.testResponse(to: request)
            .assertStatus(is: .ok)
        try droplet.testResponse(to: request)
            .assertStatus(is: .badRequest)
    }
    
    func testLoginWithSuccess() throws {
        let signupParameters = ["first_name": "Jessica", "last_name": "Lin", "email": "jessica.lin@conichi.com", "password": "0987654321"]
        let signupBody = try Body(JSON(node: signupParameters))
        let signupRequest = Request(method: .post, uri: "/users/signup", headers: header, body: signupBody)
        try droplet.testResponse(to: signupRequest)
            .assertStatus(is: .ok)
        
        let loginParameters = ["email": "jessica.lin@conichi.com", "password": "0987654321"]
        let loginBody = try Body(JSON(node: loginParameters))
        let loginRequest = Request(method: .post, uri: "/users/login", headers: header, body: loginBody)
        try droplet.testResponse(to: loginRequest)
            .assertStatus(is: .ok)
            .assertJSON("user") { json in
                return json["first_name"] == "Jessica"
        }
    }
    
    func testLoginWithFailureIfUserDoesntExist() throws {
        let parameters = ["email": "alex.chang@conichi.com", "password": "0987654321"]
        let body = try Body(JSON(node: parameters))
        let request = Request(method: .post, uri: "/users/login", headers: header, body: body)
        try droplet.testResponse(to: request)
            .assertStatus(is: .badRequest)
    }
    
    func testGetUserWithSuccess() throws {
        let signUpParameters = ["first_name": "David", "last_name": "Henner", "email": "david.henner@conichi.com", "password": "0987654321"]
        let signUpBody = try! Body(JSON(node: signUpParameters))
        let signUpRequest = Request(method: .post, uri: "/users/signup", headers: [HeaderKey.contentType: "application/json"], body: signUpBody)
        var userID = 0
        var userToken = ""
        try! Droplet.testable().testResponse(to: signUpRequest)
            .assertStatus(is: .ok)
            .assertJSON("user") { json in
                guard let id = json["id"]?.int, let token = json["token"]?.string else {
                    return false
                }
                
                userID = id
                userToken = token
                return true
        }
        
        var authedHeader = header
        authedHeader["Authorization"] = "Bearer \(userToken)"
        let getUserRequest = Request(method: .get, uri: "/users/\(userID)", headers: authedHeader)
        try droplet.testResponse(to: getUserRequest)
            .assertStatus(is: .ok)
            .assertJSON("user") { json in
                return json["first_name"] == "David"
        }
    }
}
extension UserRequestTests {
    static let allTests = [
        ("testSignupWithSuccess", testSignupWithSuccess),
        ("testSignupWithFailureIfUserAlreadyExists", testSignupWithFailureIfUserAlreadyExists),
        ("testLoginWithSuccess", testLoginWithSuccess),
        ("testLoginWithFailureIfUserDoesntExist", testLoginWithFailureIfUserDoesntExist)
    ]
}
