//
//  SignUpView.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-06.
//

import SwiftUI

struct SignUpView: View {
    
    @State private var authViewToShowIndex = 1
    @State private var errorMessage = ""
    @State private var loginUser = false
    
    // Animation
    @State private var fadeOut: Bool = false
    @State private var showLoading: Bool = false
    
    // User information
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var username: String = ""
    
    var body: some View {
        ZStack {
            Color("#171717").ignoresSafeArea()
            if showLoading {
                VStack {
                    HStack {
                        LoadingCircleAnimation()
                    }
                }
            }
            VStack(spacing: 10) {
                ZStack {
                    VStack {
                        Text("Storyteller")
                            .font(.system(size: Constants.TITLE_FONT_SIZE, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text("Tell us your story")
                            .font(.system(size: Constants.REGULAR_FONT_SIZE, weight: .light))
                            .foregroundColor(.gray)
                    }
                    .offset(x: 0, y: 30)
                }
                
                // Depending on the current increment, display a different field for users to fill out information
                // Not using switch case to avoid View handling error
                if authViewToShowIndex == 1 {
                    FirstLastNameView(firstName: $firstName, lastName: $lastName)
                }
                else if authViewToShowIndex == 2 {
                    EmailPasswordView(email: $email, password: $password)
                }
                else if authViewToShowIndex == 3 {
                    UsernameView(username: $username)
                }
                else {
                    UsernameView(username: $username)
                }
                
                Text(errorMessage)
                    .foregroundColor(.red)
                
                Spacer()
                
                // Display next button or sign up button and process logic for verifying text fields are correct
                if authViewToShowIndex < 3 {
                    Button("Next") {
                        errorMessage = ""
                        if authViewToShowIndex == 1 {
                            if (firstName.count <= 0 || lastName.count <= 0) {
                                errorMessage = "Invalid name"
                            }
                            
                            if errorMessage.count == 0 {
                                withAnimation {
                                    authViewToShowIndex += 1
                                    return
                                }
                            }
                        }
                        
                        else if authViewToShowIndex == 2 {
                            errorMessage = filterEmail(email: email)
                            if (password.count <= 0) {
                                errorMessage = "Invalid password"
                            }
                            FirebaseHelper.checkIfEmailExists(email: email) { emailExists in
                                if emailExists {
                                    errorMessage = "Email already in use"
                                }
                                
                                if errorMessage.count == 0 {
                                    withAnimation {
                                        authViewToShowIndex += 1
                                        return
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .frame(width: UIScreen.screenWidth / 2)
                    .font(.system(size: 20, weight: .regular))
                    .foregroundColor(.white)
                    .background(Color("#292929"))
                    .cornerRadius(12.5)
                    .padding()
                    
                    Spacer()
                    Spacer()
                }
                
                else {
                    Button("Sign Up") {
                        
                        // Take away keyboad
                        hideKeyboard()
                        
                        errorMessage = ""
                        if (username.profanityFilter() || username.containsWhitespaceAndNewlines()) {
                            errorMessage = "Invalid username"
                        }
                        
                        // No errors
                        if errorMessage.count == 0 {
                            
                            // Make sure there is valid data for every field
                            if firstName.count > 0 && lastName.count > 0 && password.count > 0 && email.count > 0 && username.count > 0 {
                                
                            }
                            
                            // Beginning of signing user up and moving them
                            withAnimation(.easeInOut(duration: 2.0)) {
                                fadeOut = true
                            }
                            
                            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
                                Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
                                    if !loginUser {
                                        showLoading = true
                                    }
                                }
                                
                                // Package user
                                let user = User(id: "NULL", firstName: firstName,
                                    lastName: lastName,
                                    email: email,
                                    username: username,
                                    stories: [],
                                    likedStories: [],
                                    genresLiked: [:]
                                )
                                
                                // Create auth object and firebase object
                                FirebaseHelper.createUserInAuth(email: email, password: password, user: user, completion: { error in
                                    if let error = error {
                                        // TODO: Show error to user
                                        print(error.localizedDescription)
                                        return
                                    }
                                            
                                    UINavigationBar.setAnimationsEnabled(false)
                                    loginUser = true
                                })
                            }
                        }
                    }
                    .padding()
                    .frame(width: UIScreen.screenWidth / 2)
                    .font(.system(size: Constants.REGULAR_FONT_SIZE, weight: .regular))
                    .foregroundColor(.white)
                    .background(Color("#292929"))
                    .cornerRadius(12.5)
                    .padding()
                    .navigationDestination(isPresented: $loginUser) {
                        TutorialView().navigationBarBackButtonHidden(true)
                    }
                }
                
                NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true)) {                Text("Already have an account? Log in")
                        .foregroundColor(Color(.white))
                }
            }
            .padding()
            .opacity(fadeOut ? 0.0 : 1.0)
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
