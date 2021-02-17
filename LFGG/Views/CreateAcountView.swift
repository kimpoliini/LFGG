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
            
            Button(action: {
                createUser()
                print("button pressed")
            }, label: {
                Text("Create")
            })
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
            authManager.createUser(email: email, password: password){ success in
                
                var message: String = ""
                if (success) {
                    message = "User was sucessfully created"
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
