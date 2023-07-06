//
//  SignUpView.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-06.
//

import SwiftUI

struct SignUpView: View {
    
    @State private var test = false
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var testNumber = 5
    
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
            
            Group {
                Text("What's your name?")
                    .foregroundColor(Color("#8A8A8A"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 80)
                    .padding(.horizontal)
                
                TextField( text: $firstName) {
                    Text("First Name")
                        .foregroundColor(.white.opacity(0.5))
                    
                }
                .padding()
                .background(Color("#8A8A8A"))
                .cornerRadius(5)
                .padding(.horizontal)
                .padding(.bottom, 5)
                
                TextField( text: $lastName) {
                    Text("Last Name")
                        .foregroundColor(.white.opacity(0.5))
                    
                }
                .padding()
                .background(Color("#8A8A8A"))
                .cornerRadius(5)
                .padding(.horizontal)
                
            }
            
            Spacer()
            NavigationLink(destination: SignUpView2().navigationBarBackButtonHidden(true)) {
                NextButtonModel(test: $testNumber)
            }
            
            Spacer()
            Spacer()
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
