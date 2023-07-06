//
//  LoginView.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-05.
//

import SwiftUI

struct LoginView: View {
    
    @State private var emailOrUsername: String = ""
    @State private var password: String = ""
    @State private var rememberMe: Bool = false
    
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
            
            Spacer()
            
            Group {
                Text("Email or username")
                    .foregroundColor(Color("#8A8A8A"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 20)
                
                TextField( text: $emailOrUsername) {
                    Text("Email or username")
                        .foregroundColor(.white.opacity(0.5))
                    
                }
                .padding()
                .background(Color("#8A8A8A"))
                .cornerRadius(5)
                
                Text("Password")
                    .foregroundColor(Color("#8A8A8A"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
                
                SecureField(text: $password) {
                    Text("Password")
                        .foregroundColor(.white.opacity(0.5))
                }
                .padding()
                .background(Color("#8A8A8A"))
                .cornerRadius(5)
                
                HStack {
                    Toggle("", isOn: $rememberMe)
                    Text("Remember me?")
                        .foregroundColor(Color("#8A8A8A"))
                    Spacer()
                }
                
            }
            
            Spacer()
            Spacer()
            
            Button("Login") {
                print("Login")
            }
            .padding()
            .frame(width: UIScreen.screenWidth / 1.5)
            .font(.system(size: 35, weight: .regular))
            .foregroundColor(.white)
            .background(.black)
            .cornerRadius(12.5)
            .padding()
            
            
            NavigationLink(destination: SignUpView().navigationBarBackButtonHidden(true)) {
                Text("Don't have an account? Sign up")
                    .foregroundColor(Color("#8A8A8A"))
            }
            
            
        }
        .padding()
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

