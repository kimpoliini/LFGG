//
//  FirebaseAuthManager.swift
//  LFGG
//
//  Created by Kim Hellman on 2021-02-17.
//

import Foundation
import Firebase
import FirebaseAuth

class FirebaseAuthManager {
    let db = Firestore.firestore()
    
    func createUser(user: User, password: String, completionBlock: @escaping (_ success: Bool) -> Void){
        Auth.auth().createUser(withEmail: user.email!, password: password) { [self] (authResult, err) in
            if let auth = authResult?.user{
                
                //add user to database
                db.collection("users")
                    .document(auth.uid)
                    .setData(["displayName" : user.displayName!,
                              "username" : user.username!.lowercased(),
                              "email" : user.email!.lowercased()], merge: true){ err in
                        
                        //add a profile
                        db.collection("users")
                            .document(auth.uid)
                            .collection("profile")
                            .document("profile")
                            .setData(["description" : "",
                                      "backgroundColor" : "default"]){ err in
                                
                                completionBlock(true)
                            }
                              }
            } else {
                print(err!)
                completionBlock(false)
            }
        }
    }
    
    
    func signInUser(email: String, password: String, completionBlock: @escaping (_ success: Bool, _ err: Error?) -> Void){
        Auth.auth().signIn(withEmail: email, password: password){ (result, err) in
            if let err = err, let _ = AuthErrorCode(rawValue: err._code){
                print(err)
                completionBlock(false, err)
            } else {
                completionBlock(true, nil)
            }
        }
    }
}
