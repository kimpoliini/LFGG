//
//  EditProfileView.swift
//  LFGG
//
//  Created by Kim Hellman on 2021-02-26.
//

import SwiftUI
import Firebase

struct EditProfileView: View {
    let db = Firestore.firestore()
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var loginManager: LoginManager
    
    @State private var displayName = ""
    @State private var profileDescription = ""

    
    var body: some View {
        VStack{
            HStack{
                Text("Display name").bold()
                Spacer()
            }.padding(.vertical)
            
            TextField("Display name", text: $displayName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            HStack{
                Text("Profile description").bold()
                Spacer()
            }.padding(.vertical)
            
            TextField("Profile description", text: $profileDescription)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Spacer()
        }
        .navigationBarItems(trailing: Button(action: {
            //save changes to db and close page when done
            
            let userRef = db.collection("users").document(loginManager.currentUser!.uid!)
                
            userRef
                .collection("profile").document("profile")
                .setData(["description" : profileDescription, "backgroundColor" : "lightBlue"], merge: true){ _ in
                
                presentationMode.wrappedValue.dismiss()
            }
            
            userRef.setData(["displayName" : displayName], merge: true)
        }, label: {
            Image(systemName: "checkmark")
        }))
        .navigationTitle("Edit profile")
        .padding()
        .onAppear(){
            loginManager.updateCurrentUser()
            
            //make these fields update after doing updateCurrentUser()
            displayName = loginManager.currentUser!.displayName!
            profileDescription = loginManager.currentUserProfile!.description!
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
