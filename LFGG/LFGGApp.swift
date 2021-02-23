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
    
    
    @EnvironmentObject var loginManager: LoginManager
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
