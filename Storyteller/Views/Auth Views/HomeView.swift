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
        ZStack {
            Color("#171717").ignoresSafeArea()
            VStack {
                Spacer()
                MoonPresentingAnimation()
                Spacer()
                
                Text("Welcome to")
                    .font(.system(size: Constants.REGULAR_FONT_SIZE, weight: .light))
                    .foregroundColor(Color(.gray))
                
                Text("Storyteller")
                    .font(.system(size: Constants.TITLE_FONT_SIZE, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true)) {
                    Text("Login")
                    .padding()
                    .frame(width: UIScreen.screenWidth / 2)
                    .font(.system(size: Constants.REGULAR_FONT_SIZE, weight: .regular))
                    .foregroundColor(.white)
                    .background(Color("#292929"))
                    .cornerRadius(12.5)
                    
                }
                
                NavigationLink(destination: SignUpView().navigationBarBackButtonHidden(true)) {
                    Text("Sign Up")
                    .padding()
                    .frame(width: UIScreen.screenWidth / 2)
                    .font(.system(size: Constants.REGULAR_FONT_SIZE, weight: .regular))
                    .foregroundColor(.white)
                    .background(Color("#292929"))
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
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
