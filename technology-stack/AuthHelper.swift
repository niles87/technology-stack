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

struct ExistingUser {
    var email: String
    var name: String
}

class Auth {
    
    static var main = Auth()
    
    private init () {}
    
    func newUser(user: User) -> Bool {
        var success = false
        let url = URL(string: "http://localhost:5000/auth/register")
        var request = URLRequest(url: url!)
        
        let parameters: [String: Any] = [
            "name": "\(user.firstName) \(user.lastName)",
            "email": user.email,
            "password": user.password
        ]
        guard let jsonData = try?
                JSONSerialization.data(withJSONObject: parameters, options: []) else {
            print("couldnt serialize jsonData")
            return success
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        let semaphore = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            semaphore.signal()
            if let error = error {
                print("Error posting new user: \(error)")
                return
            }
            if let response = response {
                let res = response as! HTTPURLResponse
                
                if res.statusCode == 200 {
                    success = true
                }
            }
        }.resume()
        semaphore.wait()
        return success
    }
    
    func getUser(email: String, password: String) -> ExistingUser {
        var exUser = ExistingUser(email: "", name: "")
        let url = URL(string: "http://localhost:5000/auth/login")
        var request = URLRequest(url: url!)
        
        let parameters: [String:Any] = [
            "email": email,
            "password": password
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return exUser
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        let semaphore = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            semaphore.signal()
            if let error = error {
                print("error \(error)")
                return
            }
            if let data = data {
                print(data)
            }
            if let response = response {
                let res = response as! HTTPURLResponse
                
                if res.statusCode == 200 {
                    print(response)
                    exUser.name = ""
                    exUser.email = ""
                }
            }
        }.resume()
        
        semaphore.wait()
        return exUser
    }
}
