//
//  SearchView.swift
//  LFGG
//
//  Created by Kim Hellman on 2021-02-18.
//

import SwiftUI
import Firebase
import URLImage

struct SearchView: View {
    var query: String
    let db = Firestore.firestore()
    @State var users = [User]()
    @State var listGames = [RawgGame]()
    
    var body: some View {
        VStack{
            List(){
                Text("Users").bold()
                ForEach(users, id: \.self){ user in
                    RowViewUser(user: user)
                    //                RowViewUser(user: User(displayName: user.name))
                }
                Text("Games").bold()
                ForEach(listGames, id: \.self){ game in
                    RowViewGame(game: game)
                    
                }
            }
            
        }.onAppear(){
            let rawg = Rawg()
            rawg.requestGames(){ games in
                if let games = games {
                    for game in games{
                        listGames.append(game)
                    }
                }
            }
            
            getUsers(){ users in
                if !users.isEmpty {
                    for user in users {
                        self.users.append(user)
                    }
                }
            }
        }
    }
    
    func getUsers(completion: @escaping (_ listUsers: [User]) -> Void){
        var userList = [User]()

        db.collection("users")
            .whereField("username", isGreaterThanOrEqualTo: query)
            .getDocuments() { (snapshot, err) in
                if let err = err{
                    print("Error getting documents: \(err)")
                } else {
                    for document in snapshot!.documents {
                        let displayName = document["displayName"] as! String
                        let username = document["username"] as! String
                        let user = User(uid: document.documentID, displayName: displayName, username: username)
                        
                        userList.append(user)
                    }
                    completion(userList)
                }
            }
        }
    
}

struct RowViewUser: View {
    var user: User
    @State var isButtonDisabled = false
    
    var body: some View {
        HStack{
            Text(user.displayName!)
            
            Spacer()
            
            Button(action: {
                addFriend(user: user)
                isButtonDisabled = true
                
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

struct RowViewGame: View {
    var game: RawgGame
    
    var body: some View{
        VStack(spacing: 0){
            ZStack{
                Color(red: 20.0/256, green: 80.0/256, blue: 70.0/256)
                
                HStack{
                    Text(game.name)
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .padding(.horizontal)
            }
            .frame(height: 30)
                        
            URLImage(url: URL(string: game.background_image)!) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    
                
            }
            
        }
        .frame(width: 320, height: 160, alignment: .top)
        .cornerRadius(8.0)
        .padding(4.0)
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

