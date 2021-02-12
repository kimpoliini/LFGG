//
//  TabFeed.swift
//  LFGG
//
//  Created by Kim Hellman on 2021-02-10.
//

import SwiftUI

struct TabFeed: View {

    var body: some View {
            NavigationView(){
                VStack{
                    List(){
                        RowViewFeed(playerName: "friend 4", action: "challenges you to a 1v1", game: "in Smash Bros Ultimate", console: "Nintendo Switch", gameImage: "smashbrosultimate", background: AppColor.switchRed, textColor: Color.white)
                        
                        RowViewFeed(playerName: "friend 9", action: "needs 4 other players", game: "in CS:GO", console: "PC", gameImage: "csgo", background: Color.black, textColor: Color.white)
                        
                        RowViewFeed(playerName: "friend 200", action: "wants to play", game: "Minecraft", console: "PlayStation 4", gameImage: "minecraft", background: AppColor.psBlue, textColor: Color.white)
                        
                        
                        
                    }
                }.navigationTitle("Feed")
            }
            .tabItem {
                Image(systemName: "gamecontroller")
                Text("Feed")
            }
        }
}
    
    struct TabFeed_Previews: PreviewProvider {
        static var previews: some View {
            TabFeed()
        }
    }
    
    struct RowViewFeed: View {
        
        var playerName: String = "username"
        var action: String
        var game: String
        var console: String
        var gameImage: String
        var background: Color = Color.blue
        var textColor: Color = Color.black
        
        
        var body: some View {
            VStack{
                HStack{
                    Image(systemName: "person.fill")
                        .resizable()
                        .frame(width: 15, height: 15, alignment: .center)
                        .padding(8)
                        .background(Color.gray)
                        .cornerRadius(100.0)
                    
                    
                    Text("\(playerName) \(action) \(game) on \(console)")
                        .foregroundColor(textColor)
                    Spacer()
                }
                Divider().background(Color.black)
                Image(gameImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 280, height: 170, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .clipped()
            }
            .padding()
            .background(background)
            .cornerRadius(12.0)
        }
    }
