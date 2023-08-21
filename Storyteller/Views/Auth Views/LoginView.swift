//
//  LoginView.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-05.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var rememberMe: Bool = false
    @State private var errorMessage: String = ""
    @State private var loginUser: Bool = false
    
    @State private var isMoonVisible = false
    
    var body: some View {
        ZStack {
            Color("#171717").ignoresSafeArea()
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
                            .font(.system(size: Constants.TITLE_FONT_SIZE, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text("Tell us your story")
                            .font(.system(size: Constants.REGULAR_FONT_SIZE, weight: .light))
                            .foregroundColor(.gray)
                    }
                    .offset(x: 0, y: 30)
                }
                .onAppear {
                    withAnimation(.easeInOut(duration: 2.5)) {
                        isMoonVisible = true
                    }
                }
                
                Group {
                    Text("Email")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 80)
                        .padding(.horizontal)
                    
                    TextField( text: $email) {
                        Text("Email")
                            .foregroundColor(.white.opacity(0.5))
                        
                    }
                    .padding()
                    .background(Color("#292929"))
                    .cornerRadius(5)
                    .padding(.horizontal)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    
                    Text("Password")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top)
                        .padding(.horizontal)
                    
                    SecureField(text: $password) {
                        Text("Password")
                            .foregroundColor(.white.opacity(0.5))
                    }
                    .padding()
                    .background(Color("#292929"))
                    .cornerRadius(5)
                    .padding(.horizontal)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    
                    //MARK: -- Get remember me working (or just remove it)
                    HStack() {
                        Toggle("", isOn: $rememberMe)
                            
                        Text("Remember Me")
                            .foregroundColor(rememberMe ? .white : .gray)
                    }
                    
                }
                
                Text(errorMessage)
                    .foregroundColor(.red)
                
                Spacer()
                Spacer()
                
                Button("Login") {
                    hideKeyboard()
                    errorMessage = ""
                    if email.count > 0 && password.count > 0 {
                        FirebaseHelper.login(email: email, password: password) { error in
                            
                            // Error occured logging in user
                            if error != nil {
                                errorMessage = "Incorrect information"
                            }
                            
                            // No error, continue
                            else {
                                                            
                                // Move to StoryView
                                loginUser = true
                                
                            }
                        }
                    }
                }
                .padding()
                .frame(width: UIScreen.screenWidth / 1.5)
                .font(.system(size: 35, weight: .regular))
                .foregroundColor(.white)
                .background(Color("#292929"))
                .cornerRadius(12.5)
                .padding()
                .navigationDestination(isPresented: $loginUser) {
                    TabBarControllerView().navigationBarBackButtonHidden(true)
                }
                
                
                NavigationLink(destination: SignUpView().navigationBarBackButtonHidden(true)) {
                    Text("Don't have an account? Sign up")
                        .foregroundColor(.white)
                }
            }
            .padding()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

