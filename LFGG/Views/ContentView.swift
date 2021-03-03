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
                .navigationViewStyle(StackNavigationViewStyle())
                
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
        } else {
            NavigationView(){
                LoginView()
            }
        }
            
        }
        .environmentObject(loginManager)
        .onAppear(){
            if (Auth.auth().currentUser?.uid) != nil {
                loginManager.updateCurrentUser(){ (success) in }
                loginManager.getOwnedandFavouriteGames { (success) in }

            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

