//
//  TabFriendsList.swift
//  LFGG
//
//  Created by Kim Hellman on 2021-02-10.
//

import SwiftUI
import Firebase

struct TabFriendsList: View {
//    var friends = addMockFriends(20)
    let db = Firestore.firestore()
    @State var friends = [String]()
    
    var body: some View {
        List(){
            ForEach(friends, id: \.self){ friend in
                    RowViewFriend(name: friend)
            }
        }
        .onAppear(){
            
            
            db.collection("users").document(Auth.auth().currentUser!.uid).collection("friends").getDocuments(){ (snapshot, err) in
                if let err = err{
                    print(err)
                } else {
                    friends.removeAll()

                    for document in snapshot!.documents {
                        let friend = document["username"] as! String
                        friends.append(friend)
                    }
                }
            }
            
        }
        .navigationTitle("Friends")

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
            
            Spacer()
            
            Text(name)
                .font(.title2)
        }
    }
}
