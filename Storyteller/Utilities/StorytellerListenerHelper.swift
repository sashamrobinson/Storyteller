//
//  StorytellerListenerHelper.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-29.
//

import SwiftUI

struct StorytellerListenerHelper: View {
    
    @ObservedObject var speechUtterance = SpeechUtterance()
    @ObservedObject var speechRecognizer: SpeechRecognizer
    @State var transcript : String = ""
    @State private var isListening = false
    @State private var listeningForCall = true
    @State private var listeningForStory = false
    
    @State private var popUpViewAppear = false
    @State private var displayCreateView = false

    init(speechRecognizer: SpeechRecognizer) {
        self.speechRecognizer = speechRecognizer
        startListening()
    }
    
    var body: some View {
        
        if popUpViewAppear {
            PopUpMoonView(popUpViewAppear: $popUpViewAppear)
                .onAppear() {
                    listeningForCall = false
                    listeningForStory = true
                    startListening()
                }
        }
        else if !popUpViewAppear {
            Text("Fake Text")
                .opacity(0)
                .onAppear() {
                    listeningForCall = true
                    listeningForStory = false
                }
        }
    }
    
    // Method for beginning to take in user voice input
    private func startListening() {
            
        // Reset speech recognizer, begin transcribing and begin recording
        speechRecognizer.resetTranscript()
        speechRecognizer.startTranscribing(completion: {
            endListening()
        })
        
        isListening = true
    }
    
    // Method for ending user voice input and calling to OpenAI
    private func endListening() {
        
        // Stop transcribing and stop recording
        speechRecognizer.stopTranscribing()
        transcript = speechRecognizer.transcript.lowercased()
        isListening = false
        
        if !transcript.isEmpty {
            
            // Check all predetermined commands
            if listeningForCall {
                for command in Constants.BEGIN_SPEAKING_STORYTELLER {
                    if transcript.contains(command) {
                        
                        // Make icon appear
                        popUpViewAppear = true
                        return
                    
                    }
                }
                
                // No call detected
                startListening()
            }
            
            else if listeningForStory {
                for command in Constants.BEGIN_STORY_STRINGS {
                    if transcript.contains(command) {
                        
                        listeningForCall = true
                        listeningForStory = false
                        
                        // Transition to create view
                        displayCreateView = true
                        
                    }
                }
                
                // No story detected
                startListening()
            }
        }
        
        else {
            startListening()
        }
    }
}

struct StorytellerListenerHelper_Previews: PreviewProvider {
    static var previews: some View {
        StorytellerListenerHelper(speechRecognizer: SpeechRecognizer())
    }
}
