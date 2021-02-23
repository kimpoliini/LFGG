//
//  LoginView.swift
//  LFGG
//
//  Created by Kim Hellman on 2021-02-17.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    let authManager = FirebaseAuthManager()
    
    @State private var showingAlert = false
    @State private var alert: Alert? = nil
    
    @StateObject var loginManager = LoginManager()
    
    
    var body: some View {
        NavigationView(){
        if loginManager.isLoggedIn {
            ContentView()
        } else {
                VStack{
                    Spacer()
                    TextField("Email", text: $email)
                        .padding(.vertical)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    SecureField("Password", text: $password)
                        .textContentType(.password)
                        .padding(.vertical)
                    
                    
                    Button("Sign in"){
                        signInUser()
                    }
                    
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
            .environmentObject(loginManager)
            .onAppear(){
                if let uid = Auth.auth().currentUser?.uid {
                    print(uid)
                    loginManager.isLoggedIn = true
                }
        }
    }
    
    func signInUser(){
        if !email.isEmpty || !password.isEmpty {
            //try signing in user if both fields are populated
            authManager.signInUser(email: email, password: password){ (success, err) in
                
                if (success) {
                    loginManager.isLoggedIn = true
                    email = ""
                    password = ""
                } else {
                    
                    let errorMessage: String = "\(err)"
                    
                    alert = Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("Ok")))
                    showingAlert = true
                    
                }
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
