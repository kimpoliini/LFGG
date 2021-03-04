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
    @EnvironmentObject var loginManager: LoginManager
    
    var body: some View {
        VStack{
            List(){
                Text("Users").bold()
                ForEach(users, id: \.self){ user in
                    RowViewUser(lm: loginManager, user: user)
                }
                if users.isEmpty {
                    Text("No users found for \(query)")
                }
                
                VStack{}
                
                Text("Games").bold()
                ForEach(listGames, id: \.self){ game in
                    RowViewGame(game: game, lm: loginManager,
                                owned: loginManager.ownedGames.contains(where: { $0.slug == game.slug }),
                                favourite: loginManager.favouriteGames.contains(where: { $0.slug == game.slug }))
                }
                if listGames.isEmpty {
                    Text("No games found for \(query)")
                }
            }
        }.onAppear(){
            users.removeAll()
            listGames.removeAll()
            
            getUsers(){ users in
                if !users.isEmpty {
                    for user in users {
                        self.users.append(user)
                    }
                }
            }
            
            let rawg = Rawg()
            rawg.requestGames(query: query){ games in
                if let games = games {
                    for game in games{
                        listGames.append(game)
                    }
                }
            }
            
            loginManager.getOwnedandFavouriteGames { (success) in }
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
    var lm: LoginManager
    var user: User
    @State var isButtonDisabled = false
    
    var body: some View {
        HStack{
            Text(user.displayName!)
            
            Spacer()
            
            Button(action: {
                addFriend(lm: lm,user: user)
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
    var lm: LoginManager
    @State var owned: Bool
    @State var favourite: Bool
    
    var body: some View{
        VStack(spacing: 0){
            ZStack{
                AppColor.appRed
                
                HStack{
                    Text(game.name)
                    Spacer()

                    //owned button
                    Button {
                        if owned {
                            lm.removeGameFrom(owned: true, favourites: false, game: game)
                            lm.getOwnedandFavouriteGames { (success) in print(lm.ownedGames)}

                        } else {
                            lm.addGameTo(owned: true, favourites: false, game: game)
                            lm.getOwnedandFavouriteGames { (success) in print(lm.ownedGames)}
                        }
                        owned.toggle()
                        
                    } label: {
                        Image(systemName: owned ? "checkmark.square.fill" : "checkmark.square")
                    }.buttonStyle(PlainButtonStyle())
                    
                    //favourite button
                    Button {
                        if favourite {
                            lm.removeGameFrom(owned: false, favourites: true, game: game)
                            lm.getOwnedandFavouriteGames { (success) in print(lm.ownedGames)}
                        } else {
                            lm.addGameTo(owned: false, favourites: true, game: game)
                            lm.getOwnedandFavouriteGames { (success) in print(lm.favouriteGames)}
                        }
                        favourite.toggle()
                        
                    } label: {
                        Image(systemName: favourite ? "heart.fill" : "heart")
                    }.buttonStyle(PlainButtonStyle())
                    
                }
                .padding(.horizontal)
            }
            .frame(height: 35)
            
            if game.background_image != nil{
                URLImage(url: URL(string: game.background_image != nil ? game.background_image! : "")!) { image in
                    image
                        .resizable()
                        .scaledToFill()
                }
            } else {
                Image(systemName: "gamecontroller.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            
        }
        .frame(width: 340, height: 160, alignment: .top)
        .cornerRadius(8.0)
        .padding(4.0)
        .onAppear(){
        }
    }
}

func addFriend(lm: LoginManager, user: User){
    let db = Firestore.firestore()
    
    db.collection("users")
        .document(Auth.auth().currentUser!.uid)
        .collection("friends")
        .document(user.uid!)
        .setData(["displayName" : user.displayName!, "username" : user.username!], merge: true)
    
    db.collection("users")
        .document(user.uid!)
        .collection("friends")
        .document(Auth.auth().currentUser!.uid)
        .setData(["displayName" : lm.currentUser!.displayName!, "username" : lm.currentUser!.username!], merge: true)
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(query: "test")
    }
}

