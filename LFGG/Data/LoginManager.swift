//
//  LoginManager.swift
//  LFGG
//
//  Created by Kim Hellman on 2021-02-23.
//

import Foundation
import Firebase
import SwiftUI

class LoginManager: ObservableObject{
    @Published var isLoggedIn = false
    @Published var currentUser: User? = nil
    @Published var currentUserProfile: Profile? = nil
    @Published var isGettingData = false
    let db = Firestore.firestore()
    
    func updateCurrentUser(){
        self.isLoggedIn = true
        
        let userRef = db.collection("users")
            .document(Auth.auth()
            .currentUser!.uid)
        
        userRef.getDocument(){ document, err in
            if let err = err {
                print(err)
            } else {
                let displayName = document!["displayName"] as! String
                let username = document!["username"] as! String
                let email = document!["email"] as! String
                
                self.currentUser = User(uid: Auth.auth().currentUser?.uid,
                                        displayName: displayName,
                                        username: username, email: email)
            }
        }
        
        userRef.collection("profile")
            .document("profile")
            .getDocument(){ document, err in
                if let err = err {
                    print(err)
                } else {
                    let description = document!["description"] as! String
                    let backgroundColorString = document!["backgroundColor"] as! String
                    var backgroundColor: Color {
                        switch backgroundColorString {
                        case "lightBlue":
                            return Color(.systemBlue)
                        default:
                            return Color(.systemBlue)
                        }
                    }
                    self.currentUserProfile = Profile(description: description,
                                                      backgroundColor: backgroundColor)
                }
            }
    }
}
