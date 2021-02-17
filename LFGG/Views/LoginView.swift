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
    
    var body: some View {
        NavigationView(){
            VStack{
                Spacer()
                TextField("Email", text: $email)
                    .padding(.vertical)
                TextField("Password", text: $password)
                    .textContentType(.password)
                    .padding(.vertical)
                
                NavigationLink(destination: ContentView()){
                    Text("Sign in")
                        .foregroundColor(.blue)
                }
                Spacer()
                
                NavigationLink(destination: CreateAcountView()){
                    Text("Create an account")
                        .foregroundColor(.blue)
                }
            }.padding()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
