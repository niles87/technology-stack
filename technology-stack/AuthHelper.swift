//
//  AuthHelper.swift
//  technology-stack
//
//  Created by Niles Bingham on 1/20/21.
//

import Foundation

struct User {
    var firstName: String
    var lastName: String
    var email: String
    var password: String
}

struct ExistingUser: Codable {
    var id: Int
    var email: String
    var name: String
}

class Auth {
    
    static var main = Auth()
    
    private init () {}
    
    func newUser(user: User) -> ExistingUser {
        let url = URL(string: "http://localhost:5000/auth/register")
        var request = URLRequest(url: url!)
        var ruser: ExistingUser!
        let parameters: [String: Any] = [
            "name": "\(user.firstName) \(user.lastName)",
            "email": user.email,
            "password": user.password
        ]
        guard let jsonData = try?
                JSONSerialization.data(withJSONObject: parameters, options: []) else {
            print("couldnt serialize jsonData")
            return ruser
        }
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let semaphore = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else {
                return
            }
            do {
                let res = try JSONDecoder().decode(ExistingUser.self, from: data)
                ruser = res
            } catch let error {
                print(error)
            }
            semaphore.signal()
        }.resume()
        semaphore.wait()
        return ruser
    }
    
    func getUser(email: String, password: String) -> ExistingUser {
        var exUser: ExistingUser!
        let url = URL(string: "http://localhost:5000/auth/login")
        var request = URLRequest(url: url!)
        
        let parameters: [String:Any] = [
            "email": email,
            "password": password
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            print("json serialization failed")
            return exUser
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        let semaphore = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else {
                return
            }
            do {
                let user = try JSONDecoder().decode(ExistingUser.self, from: data)
                exUser = user
            } catch let error {
                print(error)
            }
            semaphore.signal()
        }.resume()
        
        semaphore.wait()
        return exUser
    }
}
