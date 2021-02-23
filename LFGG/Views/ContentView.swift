//
//  ContentView.swift
//  LFGG
//
//  Created by Kim Hellman on 2021-02-06.
//

import SwiftUI
import Firebase

struct ContentView: View {
    var db = Firestore.firestore()
    @StateObject var loginManager = LoginManager()
    
    var body: some View {
        ZStack{
            if loginManager.isLoggedIn {
            
            TabView{
                NavigationView(){
                    TabFeed()
                }.tabItem {
                    Image(systemName: "gamecontroller")
                    Text("Feed")
                }
                
                NavigationView(){
                    TabBrowse()
                }.tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Browse")
                }
                
                NavigationView(){
                    TabFriendsList()
                }.tabItem {
                    Image(systemName: "person.2")
                    Text("Friends")
                }
                
                NavigationView(){
                    TabProfile()
                }.tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
            }
            .onAppear(){
                createExampleGames()
            }
        } else {
            NavigationView(){
                LoginView()
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
    
    func createExampleGames(){
        db.collection("games").document("Minecraft").setData(
            ["title" : "Minecraft",
             "platforms" :["pc","switch","xbox","playstation"],
             "genres": [Genre.adventure, Genre.openworld, Genre.sandbox]], merge: true)
        
        db.collection("games").document("Smash Bros Ultimate").setData(
            ["title" : "Smash Bros Ultimate",
             "platforms" : ["switch"],
             "genres" : [Genre.fighting, Genre.competitive]], merge: true)
        
        db.collection("games").document("Example Console Exclusive").setData(
            ["title" : "Example Console Exclusive",
             "platforms" : ["xbox", "playstation"],
             "genres" : [Genre.action, Genre.adventure, Genre.rpg]], merge: true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

