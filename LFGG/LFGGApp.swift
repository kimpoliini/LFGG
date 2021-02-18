//
//  LFGGApp.swift
//  LFGG
//
//  Created by Kim Hellman on 2021-02-06.
//

import SwiftUI
import Firebase


@main
struct LFGGApp: App {
    
    var isLoggedIn = false
    
    init() {
        FirebaseApp.configure()
        
        if let uid = Auth.auth().currentUser?.uid {
            print(uid)
            isLoggedIn = true
        }
    }
    
    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                ContentView()
            } else {
                LoginView()
            }
        }
    }
}
