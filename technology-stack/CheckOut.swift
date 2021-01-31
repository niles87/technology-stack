//
//  CheckOut.swift
//  technology-stack
//
//  Created by Niles Bingham on 1/17/21.
//

import SwiftUI

struct CheckoutView: View {
    @State private var signIn = false
    @State private var newMember = false
    @State private var isSignedIn = false

    var total: Double
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.signIn.toggle()
                }, label: {
                    Text("Sign in to Checkout")
                }).fullScreenCover(isPresented: $signIn, content: SignInForm.init)
                Button(action: {
                    self.newMember.toggle()
                }, label: {
                    Text("New Member")
                }).fullScreenCover(isPresented: $newMember, content: NewMemberForm.init)
            }
            
        }.navigationTitle("Checkout")
    }
}

struct NewMemberForm: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack {
            TextField("First Name", text: $firstName)
            TextField("Last Name", text: $lastName)
            TextField("Email", text: $email)
            SecureField("Password", text: $password)
            Button(action: {
            
            }, label: {
                Text("Submit")
            })
        }
    }
    
    func addUser(firstName: String, lastName: String, email: String, password: String) {
        let res = Auth.main.newUser(user: User(firstName: firstName, lastName: lastName, email: email, password: password))
        print(res)
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
    
    private func checkUser(email: String, password: String) {
        let res = Auth.main.getUser(email: email, password: password)
        print(res)
        
    }
}
