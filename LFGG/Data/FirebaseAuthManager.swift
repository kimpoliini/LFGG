//
//  FirebaseAuthManager.swift
//  LFGG
//
//  Created by Kim Hellman on 2021-02-17.
//

import Foundation
import SwiftUI
import FirebaseAuth

class FirebaseAuthManager {
    func createUser(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void){
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, err) in
            if let user = authResult?.user{
                print(user)
                completionBlock(true)
            } else {
                print(err)
                completionBlock(false)
            }
        }
    }
}
