//
//  StoryView.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-07.
//

import SwiftUI

struct StoryView: View {
    
    @State private var loginUser = false
    @State private var fadeIn = false
    @State private var offsetMoonY: CGFloat = -300
    @State private var offsetTextY: CGFloat = 300
    
    var body: some View {
        VStack {
            Image("Storyteller Background Icon Big", bundle: .main)
                .edgesIgnoringSafeArea(.all)
                .frame(width: 70, height: 70)
                .offset(x: 0, y: offsetMoonY)
                .transition(.move(edge: .top))
            
            Spacer()
            Spacer()
            Spacer()
            
            Text("Begin")
                .font(.system(size: 60, weight: .semibold))
                .padding()
                .offset(x: 0, y: offsetTextY)
                .transition(.move(edge: .bottom))
            
            Text("You will be prompted to grant access to your microphone and answer several short verbal questions")
                .foregroundColor(Color("#8A8A8A"))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 50)
                .transition(.move(edge: .bottom))
                .offset(x: 0, y: offsetTextY)

            Spacer()

        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0)) {
                fadeIn = true
            }
            
            withAnimation(.easeInOut(duration: 1.5)) {
                offsetMoonY = -130
            }
            
            withAnimation(.easeInOut(duration: 1.5)) {
                offsetTextY = 0
            }
        }
        .opacity(fadeIn ? 1.0 : 0.0)
    }
}

struct StoryView_Previews: PreviewProvider {
    static var previews: some View {
        StoryView()
    }
}

//NavigationLink(destination: SignUpView().navigationBarBackButtonHidden(true)) {
//                Button("Don't have an account? Sign up") {
//                    UINavigationBar.setAnimationsEnabled(true)
//                    loginUser = true
//                }
//                .foregroundColor(Color("#8A8A8A"))
//            }
//            .navigationDestination(isPresented: $loginUser) {
//                HomeView().navigationBarBackButtonHidden(true)
//            }
