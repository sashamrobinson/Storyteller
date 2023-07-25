//
//  CreateView.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-14.
//

import SwiftUI
import AVFoundation
import OpenAISwift

struct CreateView: View {
    
    // Animation
    @State private var talkingCurrently = false
    @State private var animationVisible = false
    @State private var offsetMoonY: CGFloat = -UIScreen.screenHeight
    @State private var bgOpacity: CGFloat = 0
    
    @State private var isInfoViewVisible = false
    
    // TTS / STT
    @ObservedObject var speechUtterance = SpeechUtterance()
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State var transcript : String = ""
    @State private var isRecording = false
    
    @State private var currentChatMessages: [ChatMessage] = []
    
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
                            .opacity(animationVisible ? 1 : 0)
                            .onAppear() {
                                withAnimation(.easeInOut(duration: 1.0)) {
                                    animationVisible.toggle()
                                }
                            }
                        
                    }
                    
                    Image("Storyteller Background Icon Big", bundle: .main)
                        .resizable()
                        .scaledToFit()
                        .offset(x: 0, y: offsetMoonY)
                        .transition(.move(edge: .top))
                        .frame(width: 300, height: 300)
                    
                        // When the user taps the moon
                        .onTapGesture {
                            
                            print("Tap")
                            startConversation()
                            
                        }
                }
            }
        }
        .background(Color("#171614"))
        .onAppear {
            
            // Begin speaking
            speechUtterance.speak(text: Constants.INTRODUCTION_STRING)
            
            // Animations
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
    
    // Method for beginning to take in user voice input
    private func startConversation() {
            
        // Reset speech recognizer, begin transcribing and begin recording
        speechRecognizer.resetTranscript()
        speechRecognizer.startTranscribing(completion: {
            endConversation()
        })
        
        isRecording = true
    }
    
    // Method for ending user voice input and calling to OpenAI
    private func endConversation() {
        
        // Stop transcribing and stop recording
        speechRecognizer.stopTranscribing()
        transcript = speechRecognizer.transcript
        
        if !transcript.isEmpty {
            currentChatMessages.append(ChatMessage(role: .user, content: transcript))
            
            isRecording = false
            sendToOpenAI(chat: currentChatMessages)
        }
    }
    
    // Method for sending user voice input to OpenAI
    private func sendToOpenAI(chat: [ChatMessage]) {
        OpenAIHelper.shared.getResponse(chat: chat) { result in
            switch result {
            case .success(let output):
                
                do {
                    try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.duckOthers, .allowBluetooth])
                    try AVAudioSession.sharedInstance().setActive(true)
                }
                catch {
                    
                }
                
                // Add message to ChatMessage array
                currentChatMessages.append(ChatMessage(role: .assistant, content: output))
                speechUtterance.speak(text: output)
                
            case .failure:
                print("Failed")
            }
        }
    }

}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView()
    }
}
