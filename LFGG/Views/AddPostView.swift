//
//  AddPostView.swift
//  LFGG
//
//  Created by Kim Hellman on 2021-03-03.
//

import SwiftUI
import Firebase

struct AddPostView: View {
    let db = Firestore.firestore()
    
    var platforms = ["xbox","playstation","switch","pc"]
    var visibilities = ["friends", "everyone"]
    var actions = ["against someone","with someone","in a group","free for all"]
    
    @State var platform: String = "xbox"
    @State var visibility: String = "friends"
    @State var action: String = "against someone"
    @State var optionalText: String = ""
    
    @EnvironmentObject var loginManager: LoginManager
    @Environment(\.presentationMode) var presentationMode

    
    var body: some View {
        ScrollView{
            
        VStack{
            if loginManager.selectedGame != nil {
                
                ZStack{
                    AppColor.appRed
                    Text(loginManager.selectedGame!.title!)
                }
                .frame(height: 50)
                .cornerRadius(8.0)
                .padding()
                
//                NavigationLink(
//                    destination: listGames(lm: loginManager, listGames: loginManager.ownedGames),
//                    label: {
//                        HStack{
//                            Text("Change game")
//                            Spacer()
//                            Image(systemName: "chevron.right")
//                        }.padding()
//                    })
            } else {
                NavigationLink(
                    destination: listGames(lm: loginManager, listGames: loginManager.ownedGames),
                    label: {
                        HStack{
                            Text("Choose a game")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }.padding()
                    })
            }
            
            Spacer().frame(height: 40)
            
            HStack{
                Text("Choose platform")
                Spacer()
            }.padding(.horizontal)

            Picker("Choose platform", selection: $platform){
                ForEach(platforms, id: \.self){
                    Text($0)
                }
            }
            .frame(height: 120)
            .clipped()
            
            HStack{
                Text("Choose visibility")
                Spacer()
            }.padding(.horizontal)
            
            Picker("Choose platform", selection: $visibility){
                ForEach(visibilities, id: \.self){
                    Text($0)
                }
            }
            .frame(height: 80)
            .clipped()
            
            HStack{
                Text("I want to play -")
                Spacer()
            }.padding(.horizontal)
            
            Picker("Choose platform", selection: $action){
                ForEach(actions, id: \.self){
                    Text($0)
                }
            }
            .frame(height: 120)
            .clipped()
            
            HStack{
                Text("Additional notes (optional)")
                Spacer()
            }.padding(.horizontal)
            
            TextField("", text: $optionalText).padding()
            
            
        }
        }
        .navigationTitle("New post")
        .navigationBarItems(trailing: Button(action: {
            //send post
            
//            let post = Post(currentUser: loginManager.currentUser!,
//                            timestamp: Date(),
//                            game: game,
//                            visibility: visibility,
//                            action: action,
//                            platform: platform,
//                            text: optionalText.isEmpty ? nil : optionalText)
            
            db.collection("users")
                .document(Auth.auth().currentUser!.uid)
                .collection("posts")
                .addDocument(data: ["date" : Date(),
                                    "game" : loginManager.selectedGame!.slug,
                                    "visibility" : visibility,
                                    "action" : action,
                                    "platform" : platform,
                                    "text" : optionalText,
                                    "user" : loginManager.currentUser!.username!]){err in
                    presentationMode.wrappedValue.dismiss()
                }
            
            
            
        }, label: {
            Text("Send")
        }))
    }
}

struct listGames: View {
    var lm: LoginManager
    @State var listGames: [Game]
    
    var body: some View {
        List(){
            ForEach(listGames, id: \.self){ game in
                HStack{
                    Text(game.title!)
                    Spacer()
                }.onTapGesture {
                    lm.selectedGame = game
                    print(game.title!)
                }
            }
        }
    }
}

struct AddPostView_Previews: PreviewProvider {
    static var previews: some View {
        AddPostView()
    }
}
