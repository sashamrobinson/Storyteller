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
    @State private var isMoonVisible = false
    @State private var fadeOut = false
    
    // User information
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var month: String = ""
    @State private var day: String = ""
    @State private var year: String = ""
    @State private var gender: String = ""
    @State private var username: String = ""
    
    var body: some View {
        
        VStack(spacing: 10) {
            ZStack {
                if isMoonVisible {
                    HStack {
                        Spacer()
                        Image("Storyteller Background Icon")
                            .frame(width: 116, height: 116)
                            .opacity(0.3)
                    }
                    .edgesIgnoringSafeArea(.all)
                    .ignoresSafeArea(.all)
                    .transition(.move(edge: .trailing))
                }

                VStack {
                    Text("Storyteller")
                        .font(.system(size: 60, weight: .semibold))
                    
                    Text("Tell us your story")
                        .font(.system(size: 30, weight: .light))
                        .foregroundColor(Color("#3A3A3A"))
                }
                .offset(x: 0, y: 30)
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 2.5)) {
                    isMoonVisible = true
                }
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
                BirthDateGenderView(month: $month, day: $day, year: $year, gender: $gender)
            }
            else if authViewToShowIndex == 4 {
                UsernameView(username: $username)
            }
            else {
                UsernameView(username: $username)
            }
            
            Text(errorMessage)
                .foregroundColor(.red)
            
            Spacer()
            
            // Display next button or sign up button and process logic for verifying text fields are correct
            if authViewToShowIndex < 4 {
                Button("Next") {
                    errorMessage = ""
                    if authViewToShowIndex == 1 {
                        if (firstName.count <= 0 || lastName.count <= 0) {
                            errorMessage = "Invalid name"
                        }
                    }
                    
                    else if authViewToShowIndex == 2 {
                        errorMessage = filterEmail(email: email)
                        if (password.count <= 0) {
                            errorMessage = "Invalid password"
                        }
                        
                    }
                    
                    else if authViewToShowIndex == 3 {
                        if (month.count <= 0 || day.count <= 0 || year.count <= 0 || gender.count <= 0 || day.contains(".") || year.contains(".")) {
                            errorMessage = "Invalid date of birth or gender"
                        }
                    }
                    
                    if errorMessage.count == 0 {
                        withAnimation {
                            authViewToShowIndex += 1
                        }
                    }
                }
                .padding()
                .frame(width: UIScreen.screenWidth / 3)
                .font(.system(size: 20, weight: .regular))
                .foregroundColor(.white)
                .background(.black)
                .cornerRadius(12.5)
                .padding()
                
                Spacer()
                Spacer()
            }
            
            else {
                Button("Sign Up") {
                    
                    errorMessage = ""
                    if (username.profanityFilter() || username.containsWhitespaceAndNewlines()) {
                        errorMessage = "Invalid username"
                    }
                    
                    // No errors
                    if errorMessage.count == 0 {
                        
                        // Make sure there is valid data for every field
                        if firstName.count > 0 && lastName.count > 0 && password.count > 0 && email.count > 0 && month.count > 0 && day.count > 0 && year.count > 0 && username.count > 0 {
                            
                        }
                        
                        // Take away keyboad
                        hideKeyboard()
                        
                        // Beginning of signing user up and moving them
                        withAnimation(.easeInOut(duration: 2.0)) {
                            fadeOut = true
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            // Package date
                            let birthDate = "\(month)-\(day)-\(year)"
                            
                            // Package user
                            let user = User(firstName: firstName,
                                            lastName: lastName,
                                            email: email,
                                            birthDate: birthDate,
                                            gender: gender,
                                            username: username,
                                            stories: [])
                            
                            // Create auth object in Auth
//                            FirebaseHelper.createUserInAuth(email: email, password: password)
//
//                            // Create user object in Firebase
//                            FirebaseHelper.createUserInDatabase(user: user)
                            
                            // TODO: - Transition to next page
                            UINavigationBar.setAnimationsEnabled(false)
                            loginUser = true
                        }
                    }
                }
                .padding()
                .frame(width: UIScreen.screenWidth / 1.5)
                .font(.system(size: 35, weight: .regular))
                .foregroundColor(.white)
                .background(.black)
                .cornerRadius(12.5)
                .padding()
                .navigationDestination(isPresented: $loginUser) {
                    StoryView().navigationBarBackButtonHidden(true)
                }
            }
            
            NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true)) {                Text("Already have an account? Log in")
                    .foregroundColor(Color("#8A8A8A"))
            }
        }
        .padding()
        .opacity(fadeOut ? 0.0 : 1.0)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
