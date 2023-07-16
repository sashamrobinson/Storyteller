//
//  SettingsView.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-14.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var showLogOutAlert = false
    
    var body: some View {
        Button("Sign Out") {
            showLogOutAlert.toggle()
        }
        .alert(isPresented: $showLogOutAlert) {
            Alert(
                title: Text("Are you sure you want to sign out?"),
                message: Text("You will need to reauthenticate to sign back in"),
                primaryButton: .default(Text("Yes")) {
                    
                    print("Logging out")
                },
                secondaryButton: .cancel(Text("No"))
            )
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
