//
//  TabProfile.swift
//  LFGG
//
//  Created by Kim Hellman on 2021-02-10.
//

import SwiftUI

struct TabProfile: View {
    var body: some View {
        NavigationView(){
            VStack{
                VStack{
                    
                    HStack(){
                        Image(systemName: "person.fill")
                            .resizable()
                            .frame(width: 60, height: 60, alignment: .leading)
                            .padding(20)
                            .background(Color.gray)
                            .cornerRadius(100.0)
                        
                        VStack{
                            HStack{
                                Text("username")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            HStack{
                                Text("Title?")
                                    .foregroundColor(.white)
                                Spacer()
                            }
                        }.padding(.leading)
                        Spacer()
                    }
                    
                    Text("\"Short description about or quote from this user, can be several lines long if needed.\"")
                        .fontWeight(.light)
                        .foregroundColor(.white)
                        .padding(.vertical)
                }
                .padding()
                .background(Color.blue)
                .cornerRadius(12.0)
                .shadow(radius: 8)
                
                
                HStack{
                    Text("Favorite games")
                        .font(.title)
                    Spacer()
                }.padding(.vertical)
                
                HStack{
                    Text("Connected platforms")
                        .font(.title)
                    Spacer()
                }.padding(.vertical)
                
                HStack{
                    Text("Friends")
                        .font(.title)
                    Spacer()
                }.padding(.vertical)
                
                Spacer()
                
            }
            .navigationTitle("Profile")
            .padding()
        }.tabItem {
            Image(systemName: "person")
            Text("Profile")
        }
    }
}

struct TabProfile_Previews: PreviewProvider {
    static var previews: some View {
        TabProfile()
    }
}
