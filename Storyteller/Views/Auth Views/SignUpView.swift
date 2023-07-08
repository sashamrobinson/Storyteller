//
//  SignUpView.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-06.
//

import SwiftUI

struct SignUpView: View {
    
    @State private var authViewToShowIndex = 1
    @State private var error = ""
    @State private var error2 = ""
    
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
                HStack {
                    Spacer()
                    Image("Storyteller Background Icon")
                        .frame(width: 116, height: 116)
                        .opacity(0.3)
                }
                .edgesIgnoringSafeArea(.all)
                .ignoresSafeArea(.all)
                
                VStack {
                    Text("Storyteller")
                        .font(.system(size: 60, weight: .semibold))
                    
                    Text("Tell us your story")
                        .font(.system(size: 30, weight: .light))
                        .foregroundColor(Color("#3A3A3A"))
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
                BirthDateGenderView(month: $month, day: $day, year: $year, gender: $gender)
            }
            else if authViewToShowIndex == 4 {
                UsernameView(username: $username)
            }
            else {
                UsernameView(username: $username)
            }
            
            Text(error)
                .foregroundColor(.red)
            Text(error2)
                .foregroundColor(.red)
            
            Spacer()
            
            // Display next button or sign up button
            // TODO: - Refractor code, not very pretty
            if authViewToShowIndex < 4 {
                Button("Next") {
                    error = ""
                    error2 = ""
                    if authViewToShowIndex == 2 {
                        error = filterEmail(email: email)
                        // TODO: - Add regex checker for password
                    }
                    
                    else if authViewToShowIndex == 3 {
                        // TODO: - Add age / date verifier
                    }
                    
                    else if authViewToShowIndex == 4 {
                        error = filterUsername(username: username)
                    }
                    
                    if error.count == 0 {
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
                    
                    // Verify information (send to utility for each variable)
                    
                    // if, Create auth object
                    // Create user object in FirebaseHelper
                    
                    
                }
                .padding()
                .frame(width: UIScreen.screenWidth / 1.5)
                .font(.system(size: 35, weight: .regular))
                .foregroundColor(.white)
                .background(.black)
                .cornerRadius(12.5)
                .padding()
            }
            
            NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true)) {
                Text("Already have an account? Log in")
                    .foregroundColor(Color("#8A8A8A"))
            }
        }
        .padding()
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
