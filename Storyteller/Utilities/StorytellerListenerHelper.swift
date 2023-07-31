//
//  StorytellerListenerHelper.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-29.
//

import SwiftUI

struct StorytellerListenerHelper: View {
    
    // Speech Logic Variables
    @ObservedObject var speechUtterance = SpeechUtterance()
    @ObservedObject var speechRecognizer: SpeechRecognizer
    @State private var isListening = false
    @State private var listeningForCall = true
    @State private var listeningForStory = false
    @Binding var listenerOpacity: Double
    
    // Animations Variables
    @State private var popUpOpacity = 0.0
    @State private var scale = 0.2
    @State private var displayCreateView = false
    
    init(speechRecognizer: SpeechRecognizer, listenerOpacity: Binding<Double>) {
        self.speechRecognizer = speechRecognizer
        self._listenerOpacity = listenerOpacity
        startListening()
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            
            Image("Storyteller Background Icon Big", bundle: .main)
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .scaleEffect(scale)
                .animation(.easeInOut(duration: 0.25), value: scale)
        }
        .onAppear() {
            scale = 1
            listeningForCall = true
            listeningForStory = false
            startListening()
        }
        .onTapGesture {
            popUpOpacity = 0.0
        }
        .opacity(popUpOpacity)
        .animation(.easeInOut(duration: 0.25))
        .navigationDestination(isPresented: $displayCreateView) {
            CreateView().navigationBarBackButtonHidden(true)
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
        let transcript = speechRecognizer.transcript.lowercased()
        isListening = false
        print(transcript)
        if !transcript.isEmpty {
            
            // Check all predetermined commands
            if listeningForCall {
                for command in Constants.BEGIN_SPEAKING_STORYTELLER {
                    if transcript.contains(command) {
                        
                        listeningForCall = false
                        listeningForStory = true
                        listenerOpacity = 1.0

                        popUpOpacity = 1.0
                        
                        print("detected")
                    
                    }
                }
                
                startListening()
            }
            
            else if listeningForStory {
                for command in Constants.BEGIN_STORY_STRINGS {
                    if transcript.contains(command) {
                        
                        listeningForCall = false
                        listeningForStory = false
                        listenerOpacity = 1.0

                        print("detected story")
                        
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
    
    // Method for resetting the listener variables
    private func resetView() {
        
    }
}

struct StorytellerListenerHelper_Previews: PreviewProvider {
    static var previews: some View {
        StorytellerListenerHelper(speechRecognizer: SpeechRecognizer(), listenerOpacity: .constant(0.0))
    }
}
