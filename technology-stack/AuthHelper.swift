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
    var password: String?
}

class Auth {
    
    static var main = Auth()
    
    private init () {}
    
    func newUser(user: User) -> Bool {
        var success = false
        let url = URL(string: "")
        var request = URLRequest(url: url!)
        
        let parameters: [String: Any] = [
            "name": "\(user.firstName) \(user.lastName)",
            "email": user.email,
            "password": user.password!
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
            if let error = error {
                print("Error posting new user: \(error)")
            }
            semaphore.signal()
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
}
