//
//  SettingsView.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-14.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var showLogOutAlert = false
    @State private var logoutUser = false
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Settings")
                    .font(.system(size: 60, weight: .semibold))
                
                Text("Configure your profile")
                    .font(.system(size: 30, weight: .light))
                    .foregroundColor(Color("#3A3A3A"))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding()
            
            Button("Sign Out") {
                showLogOutAlert.toggle()
                
            }
            .foregroundColor(.black)
            .alert(isPresented: $showLogOutAlert) {
                Alert(
                    title: Text("Are you sure you want to sign out?"),
                    message: Text("You will need to reauthenticate to sign back in"),
                    primaryButton: .default(Text("Yes")) {
                        
                        print("Logging out")
                        
                        // Logout user from Auth and Local Storage
                        FirebaseHelper.logoutUser()
                        
                        // Move to other view
                        logoutUser.toggle()
                    },
                    secondaryButton: .cancel(Text("No"))
                )
            }
            .navigationDestination(isPresented: $logoutUser) {
                HomeView().navigationBarBackButtonHidden(true)
            }
            
            Spacer()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
