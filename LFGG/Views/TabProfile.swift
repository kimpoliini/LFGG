//
//  TabProfile.swift
//  LFGG
//
//  Created by Kim Hellman on 2021-02-10.
//

import SwiftUI
import Firebase

struct TabProfile: View {
//    let db = Firestore.firestore()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let db = Firestore.firestore()
    @State var currentUser = User(username: "username")
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
                            Text(currentUser.username!)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        HStack{
                            Text("Title?")
                                .foregroundColor(.white)
                            Spacer()
                        }
                    }.padding(.leading)
                    Spacer()
                }
                
                Text("\"Short description about or quote from this user, can be several lines long if needed.\"")
                    .fontWeight(.light)
                    .foregroundColor(.white)
                    .padding(.vertical)
            }
            .padding()
            .background(Color.blue)
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
                do {
                    try Auth.auth().signOut()
                    loginManager.isLoggedIn = false
                }
                catch { print("already logged out") }
                
//                self.presentationMode.wrappedValue.dismiss()
            }
            
        }
        .navigationTitle("Profile")
        .padding()
        .onAppear(){
            db.collection("users")
                .document(Auth.auth()
                .currentUser!.uid)
                .getDocument(){ document, err in
                    if let err = err {
                        print(err)
                    } else {
                        let dbUsername = document!["username"] as! String
                        
                        currentUser = User(uid: Auth.auth().currentUser!.uid, username: dbUsername)
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
