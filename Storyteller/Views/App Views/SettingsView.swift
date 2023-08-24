//
//  SettingsView.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-14.
//

import SwiftUI
import Firebase

struct SettingsView: View {
    
    @State private var showLogOutAlert = false
    @State private var logoutUser = false
    
    // User details
    @State private var fullName: String = "Full Name"
    @State private var username: String = "Username"
    @State private var email: String = "Email@email.com"
    @State private var birthDate: String = "Jan 01, 1970"
    
    var body: some View {
        ZStack {
            Color("#171717").ignoresSafeArea()
            VStack {
                VStack(alignment: .leading) {
                    Text("Settings")
                        .font(.system(size: Constants.HEADER_FONT_SIZE, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.bottom)
                    
                    Text("Name")
                        .foregroundColor(.gray)
                        .font(.system(size: Constants.SUBTEXT_FONT_SIZE, weight: .regular))
                    TextField(fullName, text: $fullName)
                        .foregroundColor(.white)
                        .font(.system(size: Constants.REGULAR_FONT_SIZE, weight: .regular))
                        .padding(.bottom)
                    
                    Text("Username")
                        .foregroundColor(.gray)
                        .font(.system(size: Constants.SUBTEXT_FONT_SIZE, weight: .regular))
                    TextField(username, text: $username)
                        .foregroundColor(.white)
                        .font(.system(size: Constants.REGULAR_FONT_SIZE, weight: .regular))
                        .padding(.bottom)

                    
                    Text("Email")
                        .foregroundColor(.gray)
                        .font(.system(size: Constants.SUBTEXT_FONT_SIZE, weight: .regular))
                    TextField(email, text: $email)
                        .foregroundColor(.white)
                        .font(.system(size: Constants.REGULAR_FONT_SIZE, weight: .regular))
                        .padding(.bottom)

                    
                    Text("Birth Date")
                        .foregroundColor(.gray)
                        .font(.system(size: Constants.SUBTEXT_FONT_SIZE, weight: .regular))
                    TextField(birthDate, text: $birthDate)
                        .foregroundColor(.white)
                        .font(.system(size: Constants.REGULAR_FONT_SIZE, weight: .regular))
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding()
                Button("Sign Out") {
                    showLogOutAlert.toggle()
                }
                .padding()
                .frame(width: UIScreen.screenWidth / 2)
                .font(.system(size: Constants.REGULAR_FONT_SIZE, weight: .regular))
                .foregroundColor(.white)
                .background(Color("#292929"))
                .cornerRadius(12.5)
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

                Spacer()
            }

        }
        .onAppear {
            if let id = LocalStorageHelper.retrieveUser() {
                FirebaseHelper.fetchUserById(id: id) { user in
                    guard user != nil else {
                        print("Error getting user")
                        return
                    }
                    
                    self.fullName = user!.firstName + " " + user!.lastName
                    self.username = user!.username
                    self.email = user!.email
                    self.birthDate = user!.birthDate
                }
            }
        }
        .background(
            EmptyView()
                .fullScreenCover(isPresented: $logoutUser) {
                    NavigationView {
                        RootView()
                            .navigationBarBackButtonHidden(true)
                    }
                    .navigationViewStyle(.stack)
                }
        )
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
