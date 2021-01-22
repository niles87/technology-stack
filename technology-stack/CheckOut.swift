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
                Button(action: {
                    self.signIn.toggle()
                }, label: {
                    Text("Sign in to Checkout")
                }).sheet(isPresented: $signIn, content: {
                    SignInForm()
                })
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
}
