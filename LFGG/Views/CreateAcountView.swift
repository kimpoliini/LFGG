//
//  CreateAcountView.swift
//  LFGG
//
//  Created by Kim Hellman on 2021-02-17.
//

import SwiftUI

struct CreateAcountView: View {
    
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State private var showingAlert = false
    @State private var alert: Alert? = nil

    let authManager = FirebaseAuthManager()
    
    var body: some View {
        VStack{
            Spacer()
            TextField("Username", text: $username)
                .padding(.vertical)
            TextField("Email", text: $email)
                .padding(.vertical)
            SecureField("Password", text: $password)
                .padding(.vertical)
            
            Button("Create") {
                createUser()
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Create an account")
        .alert(isPresented: $showingAlert){
            alert!
        }
    }
    
    func createUser(){
        if !email.isEmpty || !password.isEmpty {
            //creates a new User then sends it to a helper class to make authenticate it in firebase
            let newUser = User(username: username, email: email)
            
            authManager.createUser(user: newUser, password: password){ success in
                
                var message: String = ""
                if (success) {
                    message = "User was sucessfully created"
                    username = ""
                    email = ""
                    password = ""
                    
                } else {
                    message = "There was an error."
                }
                                
                alert = Alert(title: Text(""), message: Text(message), dismissButton: .default(Text("ok")))
                showingAlert = true
            }
        }
    }
}

struct CreateAcountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAcountView()
    }
}
