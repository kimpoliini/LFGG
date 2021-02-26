//
//  TabProfile.swift
//  LFGG
//
//  Created by Kim Hellman on 2021-02-10.
//

import SwiftUI
import Firebase

struct TabProfile: View {
    let db = Firestore.firestore()
    @State var currentUser = User()
    @State var currentUserProfile = Profile()
    @EnvironmentObject var loginManager: LoginManager
    
    var body: some View {
        VStack{
            VStack{
                HStack(){
                    Image(systemName: "person.fill")
                        .resizable()
                        .frame(width: 60, height: 60, alignment: .leading)
                        .padding(20)
                        .background(Color.gray)
                        .cornerRadius(100.0)
                    
                    VStack{
                        HStack{
                            Text(loginManager.currentUser != nil ? loginManager.currentUser!.displayName! : "display name")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        HStack{
                            Text(loginManager.currentUser != nil ? "@"  + loginManager.currentUser!.username! : "username")
                                .foregroundColor(.white)
                            Spacer()
                        }
                    }.padding(.leading)
                    Spacer()
                }
                
                Text(loginManager.currentUserProfile != nil ? loginManager.currentUserProfile!.description! : "description")
                    .fontWeight(.light)
                    .foregroundColor(.white)
                    .padding(.vertical)
            }
            .padding()
            .background(loginManager.currentUserProfile != nil ? loginManager.currentUserProfile!.backgroundColor! : Color(.systemBlue))
            .cornerRadius(12.0)
            .shadow(radius: 8)
            
            
            HStack{
                Text("Favorite games")
                    .font(.title)
                Spacer()
            }.padding(.vertical)
            
            HStack{
                Text("Connected platforms")
                    .font(.title)
                Spacer()
            }.padding(.vertical)
            
            HStack{
                Text("Friends")
                    .font(.title)
                Spacer()
            }.padding(.vertical)
            
            Spacer()
            
            Button("Log out"){
                if !loginManager.isGettingData{
                    do {
                        try Auth.auth().signOut()
                        loginManager.isLoggedIn = false
                    }
                    catch { print("already logged out") }
                }
            }
        }
        .navigationBarItems(trailing:
            NavigationLink(
                destination: EditProfileView(),
                label: {
                    Image(systemName: "pencil")
                }))
        
        .navigationTitle("Profile")
        .padding()
        .onAppear(){
            let userRef = db.collection("users")
                .document(Auth.auth()
                .currentUser!.uid)
            
            userRef.getDocument(){ document, err in
                if let err = err {
                    print(err)
                } else {
                    let dbDisplayName = document!["displayName"] as! String
                    let dbUsername = document!["username"] as! String
                    
                    currentUser = User(uid: Auth.auth().currentUser!.uid, displayName: dbDisplayName, username: dbUsername)
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
                    currentUserProfile = Profile(description: description, backgroundColor: backgroundColor)
                    
                }
            }
            
        }
    }
}

struct TabProfile_Previews: PreviewProvider {
    static var previews: some View {
        TabProfile()
    }
}
