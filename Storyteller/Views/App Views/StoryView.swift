//
//  StoryView.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-07.
//

import SwiftUI

struct StoryView: View {
    
    @State private var showIntro = false
    @State private var offsetMoonY: CGFloat = -UIScreen.screenHeight
    @State private var offsetMoonY2: CGFloat = -130
    @State private var offsetTextY: CGFloat = 400
    
    var body: some View {
        
        // Display begin information to user
        if showIntro {
            VStack {
                Image("Storyteller Background Icon Big", bundle: .main)
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: 70, height: 70)
                    .offset(x: 0, y: offsetMoonY)
                    .transition(.move(edge: .top))
                
                Spacer()
                Spacer()
                Spacer()
                
                Button("Begin") {
                    
                    withAnimation(.easeInOut(duration: 1)) {
                        offsetTextY = 400
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        
                        // Transition screens
                        showIntro.toggle()
                    }
                }
                .font(.system(size: 60, weight: .semibold))
                .foregroundColor(.black)
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
                withAnimation(.easeInOut(duration: 3.0)) {
                    offsetMoonY = -130
                }
                
                withAnimation(.easeInOut(duration: 2.5)) {
                    offsetTextY = 0
                }
            }
        }
        
        // Display interactive moon part to user
        else if !showIntro {
            ZStack {
                GeometryReader { geometry in
                    Image("Storyteller Stars Background", bundle: .main)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                }
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Button(action: {
                        print("Button working")
                    }) {
                        Image("Storyteller Background Icon Big", bundle: .main)
                            .edgesIgnoringSafeArea(.all)
                            .frame(width: 70, height: 70)
                            .offset(x: 0, y: offsetMoonY)
                    }
                    
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    Button {
                        print("Test")
                    } label: {
                        Text("Test")
                    }
                    
                    Text("Test2")
                    
                    Spacer()

                }
            }
        }
            
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
