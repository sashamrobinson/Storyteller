//
//  CreateView.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-14.
//

import SwiftUI

struct CreateView: View {
    
    // Animation
    @State private var talkingCurrently = false
    @State private var animationOpacity: CGFloat = 0
    @State private var offsetMoonY: CGFloat = -UIScreen.screenHeight
    @State private var bgOpacity: CGFloat = 0
    
    @State private var isInfoViewVisible = false
    
    @ObservedObject var speechUtterance = SpeechUtterance()
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Image("Storyteller Stars Background", bundle: .main)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(bgOpacity)
            }
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Spacer()
                    Button {
                        isInfoViewVisible.toggle()
                    } label: {
                        Image(systemName: "info.circle")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                            
                    }
                    .padding()
                }
                Spacer()
            }

            VStack {
                ZStack {
                    if speechUtterance.isSpeaking {
                        SpeakingPulseAnimation()
                            .opacity(self.animationOpacity)
                            .onAppear {
                                withAnimation(.easeInOut(duration: 3.0)) {
                                    self.animationOpacity = 1.0
                                }
                            }
                            .onDisappear() {
                                withAnimation(.easeInOut(duration: 3.0)) {
                                    self.animationOpacity = 0
                                }
                            }
                    }
                    Image("Storyteller Background Icon Big", bundle: .main)
                        .resizable()
                        .scaledToFit()
                        .offset(x: 0, y: offsetMoonY)
                        .transition(.move(edge: .top))
                        .frame(width: 300, height: 300)
                    
                        // When the user taps the moon (intro dialogue)
                        .onTapGesture {
                            
                            print("Tap")
                            speechUtterance.speak(text: "Hi, I'm Storyteller. I'd love to hear what you have to say. Hold down on me to begin speaking with me.")

                            
                        }
                    
                        // When the user holds the moon (begin speaking)
                        .onLongPressGesture(minimumDuration: 0.1) {
                            
                            print("Hold")
                        }
                }
            }
        }
        .background(Color("#171614"))
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0)) {
                offsetMoonY = 0
            }
            
            withAnimation(.easeInOut(duration: 2.0)) {
                bgOpacity = 1.0
            }
            
        }
        
        .sheet(isPresented: $isInfoViewVisible) {
            SpeakingInfoView()
        }
    }

}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView()
    }
}
