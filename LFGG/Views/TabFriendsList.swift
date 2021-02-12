//
//  TabFriendsList.swift
//  LFGG
//
//  Created by Kim Hellman on 2021-02-10.
//

import SwiftUI

struct TabFriendsList: View {
    var friends = addMockFriends(20)
    
    var body: some View {
        NavigationView(){
            List(){
                ForEach(friends, id: \.self){ friend in
                    NavigationLink(
                        destination: Text(friend)){
                        RowViewFriend(name: friend)
                    }
                }
            }
            .navigationTitle("Friends")
        }
        .tabItem {
            Image(systemName: "person.2")
            Text("Friends")
        }
    }
}

func addMockFriends(_ count: Int) -> [String] {
    var friendsList = [String]()
    
    for i in 1...count{
        friendsList.append("Friend \(i)")
    }
    return friendsList
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
