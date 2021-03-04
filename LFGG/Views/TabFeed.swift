//
//  TabFeed.swift
//  LFGG
//
//  Created by Kim Hellman on 2021-02-10.
//

import SwiftUI
import Firebase

struct TabFeed: View {
    let db = Firestore.firestore()
    @State var posts = [Post]()
    @EnvironmentObject var loginManager: LoginManager
    
    var body: some View {
        List(){
            ForEach(posts, id: \.self) { post in
                RowViewPost(post: post)
            }
            if posts.isEmpty {
                Text("No posts yet")
            }
        }
        .navigationBarItems(trailing:
                                NavigationLink(
                                    destination: AddPostView(),
                                    label: {
                                        Image(systemName: "pencil")
                                    }))
        .navigationTitle("Feed")
        .onAppear(){
            //get posts from yourself and friends
            if loginManager.isLoggedIn{
                posts.removeAll()

                //yourself
                db.collection("users").document(Auth.auth().currentUser!.uid).collection("posts").addSnapshotListener() { (snapshot, err) in
                    if let err = err{
                        print("error getting posts: \(err)")
                    } else {
                        for document in snapshot!.documents{
                            let timestamp = document["date"] as! Timestamp
                            let date = timestamp.dateValue()
                            let user = document["user"] as! String
                            let game = document["game"] as! String
                            let platform = document["platform"] as! String
                            let action = document["action"] as! String
                            let text = document["text"] as! String
                            
                            let NewPost = Post(user: User(username: user), date: date, game: game, action: action, platform: platform, text: text)
                            posts.append(NewPost)
                        }
                    }
                }
                
                //friends
                for friend in loginManager.friends {
                    db.collection("users").document(friend.uid!).collection("posts").addSnapshotListener() { (snapshot, err) in
                        if let err = err{
                            print("error getting friends' posts: \(err)")
                        } else {
                            for document in snapshot!.documents{
                                let timestamp = document["date"] as! Timestamp
                                let date = timestamp.dateValue()
                                let user = document["user"] as! String
                                let game = document["game"] as! String
                                let platform = document["platform"] as! String
                                let action = document["action"] as! String
                                let text = document["text"] as! String
                                
                                let NewPost = Post(user: User(username: user), date: date, game: game, action: action, platform: platform, text: text)
                                posts.append(NewPost)
                            }
                        }
                    }
                }
            }
        }
    }
    
    struct TabFeed_Previews: PreviewProvider {
        static var previews: some View {
            TabFeed()
        }
    }
    
    struct RowViewPost: View {
        var post: Post
        
        var actionIcon: Image {
            switch post.action{
            case "with someone":
                return Image(systemName: "person.2.fill")
            case "against someone":
                return Image(systemName: "person.crop.circle.fill.badge.exclamationmark")
            case "free for all":
                return Image(systemName: "person.3.fill")
            default:
                return Image(systemName: "person.fill.questionmark")
            }
        }
        
        var body: some View {
            VStack(spacing: 0){
                HStack{
                    Image(systemName: "person.crop.circle.fill")
                    Text("\(post.user.username!) wants to play")
                    Spacer()
                }
                .padding()
                Divider()
                
                HStack{
                    Text(post.game).bold()
                    Text("on \(post.platform!)")
                    Spacer()
                }.padding()
                .background(Color(.gray))
                .cornerRadius(8.0)
                .padding(.horizontal)
                
                HStack{
                    actionIcon
                    Text(post.action)
                    Spacer()
                }
                .padding()
                
            }
            .background(AppColor.windowsBlue)
            .cornerRadius(8.0)
            .padding(4.0)
        }
        
    }
    
    //struct RowViewFeed: View {
    //
    //    var playerName: String = "username"
    //    var action: String
    //    var game: String
    //    var console: String
    //    var gameImage: String
    //    var background: Color = Color.blue
    //    var textColor: Color = Color.black
    //
    //
    //    var body: some View {
    //        VStack{
    //            HStack{
    //                Image(systemName: "person.fill")
    //                    .resizable()
    //                    .frame(width: 15, height: 15, alignment: .center)
    //                    .padding(8)
    //                    .background(Color.gray)
    //                    .cornerRadius(100.0)
    //
    //
    //                Text("\(playerName) \(action) \(game) on \(console)")
    //                    .foregroundColor(textColor)
    //                Spacer()
    //            }
    //            Divider().background(Color.black)
    //            Image(gameImage)
    //                .resizable()
    //                .scaledToFill()
    //                .frame(width: 280, height: 170, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    //                .clipped()
    //        }
    //        .padding()
    //        .background(background)
    //        .cornerRadius(12.0)
    //    }
}
