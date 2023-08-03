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
    @State var transcript: String = ""
    
    @State private var currentChatMessages: [ChatMessage] = []
    @State private var uid: String?
    @State private var user: User?
        
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
                }
            }
        }
        .background(Color("#171614"))
        .onAppear {
            
            // Reset data
            currentChatMessages = []
            transcript = ""
            
            // Fetch user data
            uid = LocalStorageHelper.retrieveUser()
            guard uid != nil else {
                // TODO: -- Add reauth
                print("User not logged in. Please reauthenticate.")
                return
            }
            FirebaseHelper.fetchUserById(id: uid!) { user in
                guard user != nil else {
                    // TODO: -- Add reauth
                    print("User not logged in. Please reauthenticate.")
                    return
                }
                self.user = user!
                
                // Begin speaking
                speechUtterance.speak(text: "Hi \(user!.firstName), " + Constants.INTRODUCTION_STRING, completion: {
                    startConversation()
                })
            }
            
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
    }
    
    // Method for ending user voice input and calling to OpenAI
    private func endConversation() {
        
        // Stop transcribing and stop recording
        speechRecognizer.stopTranscribing()
        transcript = speechRecognizer.transcript.lowercased()
        print(transcript)
        if !transcript.isEmpty {
            
            // End story command
            if parseTextForCommand(transcript, Constants.END_STORY_STRINGS) {
                endStory()
                return
            }
            currentChatMessages.append(ChatMessage(role: .user, content: transcript))
            sendToOpenAI(chat: currentChatMessages)
        }
        else {
            startConversation()
        }
    }
    
    // Method for parsing when the user would like to end a story
    // TODO: Potentially rework some logic so its a bit cleaner and rework containing common words like 'yes' / 'no'
    private func endStory() {
        speechUtterance.speak(text: Constants.END_STORY_CONFIRMATION) {
            
            // Custom startConversation for handling end of story
            speechRecognizer.resetTranscript()
            speechRecognizer.startTranscribing {
                speechRecognizer.stopTranscribing()
                transcript = speechRecognizer.transcript.lowercased()
                if !transcript.isEmpty {
                    
                    // YES / NO
                    if parseTextForCommand(transcript, Constants.AFFIRMATIVE_STRINGS) {
                        speechUtterance.speak(text: Constants.PUBLICIZE_CONFIRMATION) {
                            speechRecognizer.resetTranscript()
                            speechRecognizer.startTranscribing {
                                speechRecognizer.stopTranscribing()
                                transcript = speechRecognizer.transcript.lowercased()
                                if !transcript.isEmpty {
                                    
                                    // YES / NO
                                    if parseTextForCommand(transcript, Constants.AFFIRMATIVE_STRINGS) {
                                        
                                        // Finished telling story, publicize
                                    }
                                    
                                    else if parseTextForCommand(transcript, Constants.NEGATING_STRINGS) {
                                        
                                        // Finished telling story, do not publicize
                                        
                                    }
                                }
                            }
                        }
                    }
                    
                    else if parseTextForCommand(transcript, Constants.NEGATING_STRINGS) {
                        
                        // User is not finished telling story, loop back
                        speechUtterance.speak(text: Constants.APOLOGIZE_CONTINUE_STORY) {
                            startConversation()
                        }
                    }
                }
            }
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
                speechUtterance.speak(text: output, completion: {
                    startConversation()
                })
                
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