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
    @Binding var listenerOpacity: Double
    @State private var isProcessingAudio = false
    @State private var shouldListenForCommands = true
    
    // Animations Variables
    @State private var scale = 0.2
    @State private var displayCreateView = false
    
    init(speechRecognizer: SpeechRecognizer, listenerOpacity: Binding<Double>) {
        self.speechRecognizer = speechRecognizer
        self._listenerOpacity = listenerOpacity
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            Image("Storyteller Background Icon Big", bundle: .main)
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .scaleEffect(scale)
                .animation(.easeInOut(duration: 0.25), value: scale)
                // Temporary
                .padding(.bottom, 100)
            
        }
        .onAppear() {
            scale = 1
            startListening()
            shouldListenForCommands = true
        }
        .onTapGesture {
            // Reset storyteller
            withAnimation(.easeInOut(duration: 0.25)) {
                listenerOpacity = 0.0
            }
            
            listeningForCall = true
            isProcessingAudio = false
            shouldListenForCommands = true
            
        }
        .opacity(listenerOpacity)
        .animation(.easeInOut(duration: 0.25))
        .sheet(isPresented: $displayCreateView) {
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
        
        // Check for overlapping recursion
        if isProcessingAudio {
            return
        }
        isProcessingAudio = true
        
        // Stop transcribing and stop recording
        speechRecognizer.stopTranscribing()
        let transcript = speechRecognizer.transcript.lowercased()
        isListening = false
        
        print(transcript)
        
        if !transcript.isEmpty {
            
            // Creating talking view logic
            if !listeningForCall {
                if parseTextForCommand(transcript, Constants.BEGIN_STORY_STRINGS) {
                    shouldListenForCommands = false
                    listeningForCall = true
                    listenerOpacity = 0.0
                    
                    // Transition to create view
                    displayCreateView = true
                }
            }
            
            // Listening for Storyteller logic
            else {
                if parseTextForCommand(transcript, Constants.BEGIN_SPEAKING_STORYTELLER) {
                    shouldListenForCommands = true
                    listeningForCall = false
                    listenerOpacity = 1.0
                }
            }
        }
        
        // If we need to take in another input from the user, recursively start listening
        if shouldListenForCommands {
            print("shouldListenForCommands: " + String(shouldListenForCommands))
            startListening()
        }
        isProcessingAudio = false
    }
}

struct StorytellerListenerHelper_Previews: PreviewProvider {
    static var previews: some View {
        StorytellerListenerHelper(speechRecognizer: SpeechRecognizer(), listenerOpacity: .constant(0.0))
    }
}
