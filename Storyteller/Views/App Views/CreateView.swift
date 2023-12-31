//
//  CreateView.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-14.
//

import SwiftUI
import OpenAISwift

struct CreateView: View {
    
    /// Dismiss variable for closing sheet
    @Environment(\.dismiss) var dismiss

    // Animation
    @State private var speakingStatus: SpeakingStatus = .willSpeak
    @State private var errorType: ErrorHelper.AppErrorType?
    @Binding var storyFinishedUploading: Bool
    
    // TTS / STT
    @ObservedObject var speechUtterance = SpeechUtterance()
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State var transcript: String = ""
    
    @State private var currentChatMessages: [ChatMessage] = []
    @State private var uid: String?
    @State private var user: User?
        
    var body: some View {
        ZStack {
            Color("#171717").ignoresSafeArea()
            VStack {
                switch speakingStatus {
                case .willSpeak:
                    MoonPresentingAnimation()
                case .currentlySpeaking:
                    BeginMoonGlowingAnimation()
                case .stoppedSpeaking:
                    EndMoonGlowingAnimation()
                }
            }
        }
        .onAppear {
            
            // Reset data
            currentChatMessages = []
            transcript = ""
            
            // Fetch user data
            uid = LocalStorageHelper.retrieveUser()
            guard uid != nil else {
                errorType = .reauth
                return
            }
            FirebaseHelper.fetchUserById(id: uid!) { user in
                guard user != nil else {
                    errorType = .reauth
                    return
                }
                self.user = user!
                
                // Begin speaking
                speechUtterance.toggleSpeaking()
                speakingStatus = .currentlySpeaking
                speechUtterance.speak(text: "Hi \(user!.firstName), " + Constants.INTRODUCTION_STRING, completion: {
                    startConversation()
                })
            }
        }
        .onDisappear() {
            speechRecognizer.resetTranscript()
            speechRecognizer.stopTranscribing()
            speechUtterance.pause()
        }
        .alert(item: $errorType) { errorType in
            ErrorHelper.alert(for: errorType)
        }
    }
    
    // Method for beginning to take in user voice input
    private func startConversation() {
            
        // Reset speech recognizer, begin transcribing and begin recording
        speakingStatus = .stoppedSpeaking
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
    // TODO: Potentially rework some logic so its a bit cleaner
    private func endStory() {
        speechUtterance.toggleSpeaking()
        speechUtterance.speak(text: Constants.END_STORY_CONFIRMATION) {

            // Custom startConversation for handling end of story
            speechRecognizer.resetTranscript()
            speechRecognizer.startTranscribing {
                speechRecognizer.stopTranscribing()
                transcript = speechRecognizer.transcript.lowercased()
                if !transcript.isEmpty {
                    
                    // YES / NO
                    if parseTextForCommand(transcript, Constants.AFFIRMATIVE_STRINGS) {
                        
                        // User finished telling story
                        speechUtterance.toggleSpeaking()
                        speechUtterance.speak(text: Constants.FINISHED_STORY + " \(user!.firstName).") {
                            
                            // Add conversation to database
                            FirebaseHelper.saveStoryToDocumentAndUser(chatMessages: currentChatMessages, completion: {
                                // If reached completion, user successfully updated
                                storyFinishedUploading = true
                            })
                            
                            dismiss()
                        }
                    }
                    
                    else if parseTextForCommand(transcript, Constants.NEGATING_STRINGS) {
                        
                        // User is not finished telling story, loop back
                        speechUtterance.toggleSpeaking()
                        speechUtterance.speak(text: Constants.APOLOGIZE_CONTINUE_STORY) {
                            startConversation()
                        }
                    }
                    
                    else {
                        
                        // Didn't catch what user said
                        speechUtterance.toggleSpeaking()
                        speechUtterance.speak(text: Constants.APOLOGIZE_DIDNT_HEAR) {
                            startConversation()
                        }
                    }
                }
                
                else {
                    
                    // Didn't catch what user said
                    speechUtterance.toggleSpeaking()
                    speechUtterance.speak(text: Constants.APOLOGIZE_DIDNT_HEAR) {
                        startConversation()
                    }
                }
            }
        }
    }
    
    
    /// Method for sending a series of ChatMessage objects containing a conversation the user had to a GPT model for performing a generative response based on the prior conversation
    /// - Parameter chat: an array of ChatMessage objects representing a conversation
    private func sendToOpenAI(chat: [ChatMessage]) {
        OpenAIHelper.shared.getResponse(chat: chat) { result in
            switch result {
            case .success(let output):
                DispatchQueue.main.async {
                    currentChatMessages.append(ChatMessage(role: .assistant, content: output))
                    speechUtterance.toggleSpeaking()
                    speakingStatus = .currentlySpeaking
                    speechUtterance.speak(text: output, completion: {
                        startConversation()
                    })
                }
            case .failure:
                print("Failed")
            }
        }
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView(storyFinishedUploading: .constant(false))
    }
}
