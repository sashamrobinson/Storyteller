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
    @State private var showDeleteAccountAlert = false
    @State private var logoutUser = false
    @ObservedObject var speechRecognizer: SpeechRecognizer
    
    // User details
    @State private var fullName: String = "Full Name"
    @State private var username: String = "Username"
    @State private var email: String = "Email@email.com"
    
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
                            FirebaseHelper.logoutUser(completion: {
                                
                                // Move to other view
                                logoutUser.toggle()
                            })
                        },
                        secondaryButton: .cancel(Text("No"))
                    )
                }
                Button("Permanently delete account?") {
                    showDeleteAccountAlert.toggle()
                }
                .padding()
                .font(.system(size: Constants.SUBTEXT_FONT_SIZE, weight: .regular))
                .foregroundColor(.red)
                .alert(isPresented: $showDeleteAccountAlert) {
                    Alert(
                        title: Text("Are you sure you want to permanently delete your account?"),
                        message: Text("All of your data will be permanently lost and will be not recoverable"),
                        primaryButton: .default(Text("Yes")) {
                            
                            print("Deleting account")
                            
                            // Delete account
                            FirebaseHelper.deleteUser(completion: {
                                
                                // Move to other view
                                logoutUser.toggle()
                            })  
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
                }
            }
        }
        .background(
            EmptyView()
                .fullScreenCover(isPresented: $logoutUser) {
                    NavigationView {
                        RootView()
                            .navigationBarBackButtonHidden(true)
                            .onAppear() {
                                speechRecognizer.stopTranscribing()

                            }
                    }
                    .navigationViewStyle(.stack)
                }
        )
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(speechRecognizer: SpeechRecognizer())
    }
}
