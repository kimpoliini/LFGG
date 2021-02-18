//
//  LoginView.swift
//  LFGG
//
//  Created by Kim Hellman on 2021-02-17.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    let authManager = FirebaseAuthManager()
    
    @State private var showingAlert = false
    @State private var alert: Alert? = nil
    
    @State private var isLoggedIn = false
    
    var body: some View {
        NavigationView(){
            VStack{
                Spacer()
                TextField("Email", text: $email)
                    .padding(.vertical)
                TextField("Password", text: $password)
                    .textContentType(.password)
                    .padding(.vertical)
                
                
                Button("Sign in"){
                    signInUser()
                }
                NavigationLink(destination: ContentView(), isActive: $isLoggedIn) { EmptyView() }

                Spacer()
                
                NavigationLink(destination: CreateAcountView()){
                    Text("Create an account")
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .alert(isPresented: $showingAlert){
                alert!
            }
        }
    }
    
    func signInUser(){
        if !email.isEmpty || !password.isEmpty {
            //try signing in user if both fields are populated
            authManager.signInUser(email: email, password: password){ (success, err) in
                
                if (success) {
                    isLoggedIn = true
                    
                } else {
                    
                    let errorMessage: String = "\(err)"
                    
                    alert = Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("Ok")))
                    showingAlert = true                }
            }
            
        } else {
            alert = Alert(title: Text("Error"), message: Text("Fields can't be empty"), dismissButton: .default(Text("Ok")))
            showingAlert = true
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
