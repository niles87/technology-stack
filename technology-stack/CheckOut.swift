//
//  CheckOut.swift
//  technology-stack
//
//  Created by Niles Bingham on 1/17/21.
//

import SwiftUI

struct CheckoutView: View {
    @State private var signIn = false
    var total: Double
    var body: some View {
        VStack {
            if !signIn {
                HStack {
                    Button(action: {
                        self.signIn.toggle()
                    }, label: {
                        Text("Sign in to Checkout")
                    })
                    Button(action: {}, label: {
                        Text("New Member")
                    })
                }
            } else {
                Text(String(format: "$%.2f", total))
                Button(action: {
                    
                }, label: {
                    Image(systemName: "banknote")
                    Text("Apple Pay")
                })
            }
        }.navigationTitle("Checkout")
    }
}

struct SignInForm: View {
    @Environment(\.presentationMode) var presentation
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack {
            TextField("Email", text: $email)
            SecureField("Password", text: $password)
            Button(action: {
                
            }, label: {
                Text("Submit")
            })
        }
    }
    
    func checkUser(email: String, password: String) -> Bool {
        let user = Auth.main.getUser(email: email, password: password)
        if user.email == email {
            return true
        }
        return false
    }
}
