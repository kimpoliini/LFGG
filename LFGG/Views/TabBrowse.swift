//
//  TabBrowse.swift
//  LFGG
//
//  Created by Kim Hellman on 2021-02-10.
//

import SwiftUI
import Firebase

struct TabBrowse: View {
    let db = Firestore.firestore()
    @State var searchText: String = ""
    
    var body: some View {
            VStack{
                //Search field
                HStack{
                    NavigationLink(
                        destination: SearchView(query: searchText),
                        label: {
                            Image(systemName: "magnifyingglass")
                        })
                    
                    TextField("Search for @users, games etc", text: $searchText)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.vertical)
                }
                
                Spacer()
                
                Text("Choose console")
                VStack{
                    //Row 1
                    HStack{
                        //Xbox logo
                        NavigationLink(
                            destination: FindGameBy(platform: "xbox"),
                            label: {
                                ZStack{
                                    AppColor.xboxGreen
                                        .frame(width: 160, height: 160, alignment: .center)
                                    Image("xboxlogo")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(.white)
                                        .scaledToFit()
                                        .frame(width: 120, height: 120, alignment: .center)
                                }.cornerRadius(12.0)
                            })
                        
                        //PS logo
                        NavigationLink(
                            destination: FindGameBy(platform: "playstation"),
                            label: {
                                ZStack{
                                    AppColor.psBlue
                                        .frame(width: 160, height: 160, alignment: .center)
                                    
                                    Image("playstationlogo")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(.white)
                                        .scaledToFit()
                                        .frame(width: 120, height: 120, alignment: .center)
                                        .padding(20)
                                    
                                }.cornerRadius(12.0)
                            })
                    }
                    //Row 2
                    
                    HStack{
                        //Switch logo
                        NavigationLink(
                            destination: FindGameBy(platform: "switch"),
                            label: {
                                ZStack{
                                    AppColor.switchRed
                                        .frame(width: 160, height: 160, alignment: .center)
                                    
                                    Image("switchlogo")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(.white)
                                        .scaledToFit()
                                        .frame(width: 120, height: 120, alignment: .center)
                                        .padding()
                                    
                                }.cornerRadius(12.0)
                            })
                        //PC logo
                        NavigationLink(
                            destination: FindGameBy(platform: "pc"),
                            label: {
                                ZStack{
                                    
                                    AppColor.windowsBlue
                                        .frame(width: 160, height: 160, alignment: .center)
                                    Image("pcicon")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(.white)
                                        .scaledToFit()
                                        .frame(width: 110, height: 110, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                        .padding(25)
                                }
                                .cornerRadius(12.0)
                            })
                    }
                    Spacer()
                }
            }
            .navigationTitle("Browse")
            .padding()
    }
    
}

func getGames(mode: String) -> [String]{
    let db = Firestore.firestore()
    
    var gameList = [String]()
    db.collection("games").getDocuments(){ (snapshot, err) in
        if let err = err{
            print("Error getting documents: \(err)")
        } else {
            for document in snapshot!.documents {
                let game = document["title"] as! String
                gameList.append(game)
            }
        }
    }
    return gameList
}

struct TabBrowse_Previews: PreviewProvider {
    static var previews: some View {
        TabBrowse()
    }
}

struct FindGameBy: View {
    var platform: String
    var platformColor: Color {
        switch platform {
        case "xbox":
            return AppColor.xboxGreen
        case "playstation":
            return AppColor.psBlue
        case "switch":
            return AppColor.switchRed
        case "pc":
            return AppColor.windowsBlue
        default:
            return .white
        }
    }
    var platformImage: String {
        switch platform {
        case "xbox":
            return "xboxlogo"
        case "playstation":
            return "playstationlogo"
        case "switch":
            return "switchlogo"
        case "pc":
            return "pcicon"
        default:
            return ""
        }
    }
    
    var body: some View {
        VStack{
            //placeholder image
            ZStack{
                platformColor
                
                Image(platformImage)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.white)
                    .scaledToFit()
                    .padding()
                
            }
            .frame(height: 120, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .cornerRadius(12.0)
            
            
            HStack{
                Text("Find game by:")
                Spacer()
            }
            
            List(){
                RowViewOrderBy(platform: platform, mode: "alphabetical")
                RowViewOrderBy(platform: platform, mode: "genre")
                RowViewOrderBy(platform: platform, mode: "owned")
            }
            .navigationTitle(platform)
        }
        .padding()
    }
}

struct RowViewOrderBy: View {
    var platform: String
    var mode: String
    var text: String {
        switch mode {
        case "alphabetical":
            return "Alphabetical order"
        case "genre":
            return "Genre"
        case "owned":
            return "Owned games"
        default:
            return "Alphabetically"
        }
    }
    var body: some View {
        if mode == "genre"{
            NavigationLink(
                destination: GenreList(platform: platform),
                label: {
                    Text(text)
                })
        } else {
            NavigationLink(
                destination: GameList(platform: platform, mode: mode),
                label: {
                    Text(text)
                })
        }
    }
    
}

struct GenreList: View{
    var platform: String
    var body: some View {
        VStack{
            Text("Choose genre")
            List(){
                ForEach(Genre.genres.sorted(by: >), id: \.key) { key, value in
                    NavigationLink(
                        destination: GameList(platform: platform, mode: value),
                        label: {
                            Text(value)
                        })
                }
            }.navigationTitle("Genre")
        }
    }
}

struct GameList: View {
    var platform: String
    var mode: String
    let db = Firestore.firestore()
    
    @State var games = [String]()
    
    var body: some View {
        VStack{
            List(){
                ForEach(games, id: \.self){ game in
                    Text(game)
                }
            }
        }.onAppear(){
            let genre = mode != "alphabetical" && mode != "owned" ? mode : ""

            var printy = "searching \(platform) games"
            printy += genre != "" ? " under \(genre)" : ""
            print(printy)
            
            db.collection("games")
                .whereField("platforms", arrayContains: platform)
                .getDocuments() { (snapshot, err) in
                    if let err = err{
                        print("Error getting documents: \(err)")
                    } else {
                        for document in snapshot!.documents {
                            let genres = document["genres"] as! [String]
                            
                            if !genre.isEmpty{
                                if genres.contains(genre) && !genres.isEmpty{
                                    let game = document["title"] as! String
                                    games.append(game)
                                }
                            } else if mode == "alphabetical"{
                                let game = document["title"] as! String
                                games.append(game)
                            }
                        }
                        games = games.sorted(by: <)
                        print(games)
                    }
                }
        }
        .navigationTitle(mode)
    }
}
