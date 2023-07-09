//
//  HomeView.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-05.
//

import SwiftUI

struct HomeView: View {
    
    @State private var isMoonVisible = false
    @State private var offsetY: CGFloat = -400
    
    var body: some View {
        VStack {
            Image("Storyteller Background Icon Big", bundle: .main)
                .edgesIgnoringSafeArea(.all)
                .frame(width: 70, height: 70)
                .offset(x: 0, y: offsetY)
                .transition(.move(edge: .top))
            
            Spacer()
            
            Text("Welcome to")
                .font(.system(size: 30, weight: .light))
                .foregroundColor(Color("#8A8A8A"))
            
            Text("Storyteller")
                .font(.system(size: 60, weight: .semibold))
            
            Spacer()
            
            NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true)) {
                Text("Login")
                .padding()
                .frame(width: UIScreen.screenWidth / 1.75)
                .font(.system(size: 25, weight: .regular))
                .foregroundColor(.white)
                .background(.black)
                .cornerRadius(12.5)
                
            }
            
            NavigationLink(destination: SignUpView().navigationBarBackButtonHidden(true)) {
                Text("Sign Up")
                .padding()
                .frame(width: UIScreen.screenWidth / 1.75)
                .font(.system(size: 25, weight: .regular))
                .foregroundColor(.white)
                .background(.black)
                .cornerRadius(12.5)
                .padding()
                
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2.5)) {
                offsetY = -130
            }
        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
