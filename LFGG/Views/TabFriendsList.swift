//
//  TabFriendsList.swift
//  LFGG
//
//  Created by Kim Hellman on 2021-02-10.
//

import SwiftUI
import Firebase

struct TabFriendsList: View {
    let db = Firestore.firestore()
    @State var friends = [User]()
    @State var hasFriends = true
    @EnvironmentObject var loginManager: LoginManager
    
    
    var body: some View {
        List(){
            ForEach(friends, id: \.self){ friend in
                RowViewFriend(name: friend.displayName!)
            }
            
            if friends.isEmpty {
                Text("You have no friends :(")
            }
        }
        .navigationTitle("Friends")
        .onAppear(){
            loginManager.updateFriends(friends: friends) { success in
                
                print("updatefriends? \(success)")
            }
            
            getFriends() { friends in
                if !friends.isEmpty {
                    self.friends.removeAll()
                    for friend in friends {
                        self.friends.append(friend)
                    }
                }
            }
        }
    }
        
    func getFriends(completion: @escaping (_ listFriends: [User]) -> Void){
        var listFriends = [User]()
        
        if loginManager.isLoggedIn{
            db.collection("users").document(Auth.auth().currentUser!.uid).collection("friends").getDocuments(){ (snapshot, err) in
                if let err = err{
                    print(err)
                } else {
                    for document in snapshot!.documents {
                        let uid = document.documentID
                        let displayName = document["displayName"] as! String
                        let username = document["username"] as! String
                        
                        let friend = User(uid: uid, displayName: displayName, username: username)
                        listFriends.append(friend)
                    }
                    completion(listFriends)
                }
            }
        }
    }
}


struct TabFriendsList_Previews: PreviewProvider {
    static var previews: some View {
        TabFriendsList()
    }
}

struct RowViewFriend: View {
    var name: String
    
    var body: some View {
        HStack{
            Image(systemName: "person.fill")
                .resizable()
                .frame(width: 20, height: 20, alignment: .center)
                .padding(12)
                .background(Color.gray)
                .cornerRadius(100.0)
            
            Text(name)
                .font(.title2)
            
            Spacer()
        }
    }
}
