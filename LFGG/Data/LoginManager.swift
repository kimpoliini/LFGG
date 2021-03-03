//
//  LoginManager.swift
//  LFGG
//
//  Created by Kim Hellman on 2021-02-23.
//

import Foundation
import Firebase
import SwiftUI

class LoginManager: ObservableObject{
    @Published var isLoggedIn = false
    @Published var currentUser: User? = nil
    @Published var currentUserProfile: Profile? = nil
    @Published var isGettingData = false
    @Published var ownedGames = [Game]()
    @Published var favouriteGames = [Game]()

    
    let db = Firestore.firestore()
    let userRef: DocumentReference
    
    init() {
        userRef = db.collection("users").document(Auth.auth().currentUser!.uid)
    }
    
    func updateCurrentUser(completionBlock: @escaping (_ success: Bool) -> Void){
        self.isLoggedIn = true
        var dbOperations = 2
        
        userRef.getDocument(){ document, err in
            if let err = err {
                print(err)
            } else {
                let displayName = document!["displayName"] as! String
                let username = document!["username"] as! String
                let email = document!["email"] as! String
                
                self.currentUser = User(uid: Auth.auth().currentUser?.uid,
                                        displayName: displayName,
                                        username: username, email: email)
                dbOperations -= 1
                if dbOperations == 0 {
                    completionBlock(true)
                }
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
                            return AppColor.windowsBlue
                        case "default":
                            return Color(.systemBlue)
                        default:
                            return Color(.systemBlue)
                        }
                    }
                    self.currentUserProfile = Profile(description: description,
                                                      backgroundColor: backgroundColor)
                    
                    dbOperations -= 1
                    if dbOperations == 0 {
                        completionBlock(true)
                    }
                }
            }
    }
    
    func updateFriends(friends: [User], completion: @escaping (_ success: Bool) -> Void){
        
        var friendsLeft = friends.count
        
        for friend in friends {
            var currentFriend = User()
            
            db.collection("users")
                .document(friend.uid!)
                .getDocument { document, err in
                    if let err = err {
                        print(err)
                    } else {
                        let displayname = document!["displayName"] as! String
                        currentFriend = User(displayName: displayname)
                        
                        self.db.collection("users")
                            .document(Auth.auth().currentUser!.uid)
                            .collection("friends")
                            .document(friend.uid!)
                            .setData(["displayName" : currentFriend.displayName!], merge: true){ err in
                                
                                friendsLeft -= 1
                                
                                if friendsLeft == 0 {
                                    completion(true)
                                }
                            }
                    }
                }
        }
    }
    
    
    func getOwnedandFavouriteGames(completion: @escaping(_ success: Bool) -> Void){
        var dbOperations = 2
        
        userRef.collection("owned").getDocuments { (snapshot, err) in
            if let err = err{
                print("error when getting owned games: \(err)")
                completion(false)
            } else {
                for document in snapshot!.documents {
                    let slug = document.documentID
                    let name = document["name"] as! String
                    let imageUrl = document["background_image"] as! String
                    
                    self.ownedGames.append(Game(title: name, slug: slug, backgroundImageUrl: imageUrl))                }
                
                dbOperations -= 1
                if dbOperations == 0 {
                    completion(true)
                }
            }
        }
        
        userRef.collection("favourites").getDocuments { (snapshot, err) in
            if let err = err{
                print("error when getting favourite games: \(err)")
                completion(false)
            } else {
                for document in snapshot!.documents {
                    let slug = document.documentID
                    let name = document["name"] as! String
                    let imageUrl = document["background_image"] as! String
                    
                    self.favouriteGames.append(Game(title: name, slug: slug, backgroundImageUrl: imageUrl))
                }
                
                dbOperations -= 1
                if dbOperations == 0 {
                    completion(true)
                }
            }
        }
    }
    
    func addGameTo(owned: Bool, favourites: Bool, game: RawgGame){
        if owned {
            userRef.collection("owned").document(game.slug).setData(["name" : game.name, "background_image" : game.background_image!])
            
            if ownedGames.contains(where: { $0.slug == game.slug }){
                ownedGames.append(Game(title: game.name, slug: game.slug, backgroundImageUrl: game.background_image))
            }
        }
        
        if favourites {
            userRef.collection("favourites").document(game.slug).setData(["name" : game.name, "background_image" : game.background_image!])
            
            if favouriteGames.contains(where: { $0.slug == game.slug }){
                favouriteGames.append(Game(title: game.name, slug: game.slug, backgroundImageUrl: game.background_image))
            }
        }
    }
    
    func removeGameFrom(owned: Bool, favourites: Bool, game: RawgGame){
        if owned {
            userRef.collection("owned").document(game.slug).delete()
            
            if ownedGames.contains(where: { $0.slug == game.slug }){
                ownedGames.append(Game(title: game.name, slug: game.slug, backgroundImageUrl: game.background_image))
            }
        }
        
        if favourites {
            userRef.collection("favourites").document(game.slug).delete()
            
            if favouriteGames.contains(where: { $0.slug == game.slug }){
                favouriteGames.append(Game(title: game.name, slug: game.slug, backgroundImageUrl: game.background_image))
            }
        }
    }
    
}
