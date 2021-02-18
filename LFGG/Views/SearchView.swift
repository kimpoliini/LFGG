//
//  SearchView.swift
//  LFGG
//
//  Created by Kim Hellman on 2021-02-18.
//

import SwiftUI
import Firebase

struct SearchView: View {
    var query: String
    let db = Firestore.firestore()
    @State var users = [User]()
    
    var body: some View {
        List(){
            ForEach(users, id: \.self){ user in
                RowViewUser(user: user)
            }
            
            
        }.onAppear(){
//            users = getUsers()
            //placeholder for a function because i cant seem to figure out how to do it otherwise
            
            db.collection("users")
                .whereField("username", isGreaterThanOrEqualTo: query)
                .whereField("username", isLessThanOrEqualTo: query + "\u{f8ff}")
                .getDocuments() { (snapshot, err) in
                    if let err = err{
                        print("Error getting documents: \(err)")
                    } else {
                        for document in snapshot!.documents {
                            let username = document["username"] as! String
                            let user = User(uid: document.documentID, username: username)
                            
                            users.append(user)
                            print(user)
                            
                        }
                    }
                }
        }
    }
    
//    func getUsers() -> [String]{
//        var userList = [String]()
//
//        db.collection("users")
//            .whereField("username", isGreaterThanOrEqualTo: query)
//            .getDocuments() { (snapshot, err) in
//                if let err = err{
//                    print("Error getting documents: \(err)")
//                } else {
//                    for document in snapshot!.documents {
//                        let username = document["username"] as! String
//                        let user = User(uid: document.documentID, username: username)
//
////                        userList.append(user)
//                    }
//                }
//            }
        
        
//        return userList
//    }
    
}

struct RowViewUser: View {
    var user: User
    @State var isButtonDisabled = false
    
    var body: some View {
        HStack{
            Text(user.username!)
            Spacer()
            
            Button(action: {
                addFriend(user: user)
                isButtonDisabled = false
                
            }, label: {
                
                if isButtonDisabled {
                    Image(systemName: "person.fill.checkmark")
                } else {
                    Image(systemName: "person.fill.badge.plus")
                }
            }).disabled(isButtonDisabled)
            
        }
    }
}

func addFriend(user: User){
    let db = Firestore.firestore()
    
    db.collection("users").document(Auth.auth().currentUser!.uid).collection("friends").document(user.uid!).setData(["username" : user.username!], merge: true)
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(query: "test")
    }
}

