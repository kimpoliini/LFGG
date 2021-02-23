//
//  LoginManager.swift
//  LFGG
//
//  Created by Kim Hellman on 2021-02-23.
//

import Foundation
import Firebase

class LoginManager: ObservableObject{
    @Published var isLoggedIn = false
    @Published var currentUser: User? = nil
    let db = Firestore.firestore()
    
    func updateCurrentUser(){
        db.collection("users")
            .document(Auth.auth()
            .currentUser!.uid)
            .getDocument(){ document, err in
                
                if let err = err {
                    print(err)
                } else {
                    let username = document!["username"] as! String
                    let email = document!["email"] as! String
                    
                    self.currentUser = User(uid: Auth.auth().currentUser?.uid, username: username, email: email)
                }
            }
    }
}
