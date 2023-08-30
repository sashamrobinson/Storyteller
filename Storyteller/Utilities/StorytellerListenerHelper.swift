//
//  StorytellerListenerHelper.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-29.
//

import SwiftUI

class StorytellerState: ObservableObject {
    @Published var progress: Double = 0.0
    // Add other necessary state properties here
}

struct StorytellerListenerHelper: View {
    
    // Speech Logic Variables
    @ObservedObject var speechUtterance = SpeechUtterance()
    @ObservedObject var speechRecognizer: SpeechRecognizer
    @Binding var listenerOpacity: Double
    @ObservedObject var storytellerState = StorytellerState()
    @State private var listeningForCall = true
    @State private var isProcessingAudio = false
    @State private var shouldListenForCommands = true
    @State var canListen: Bool = true
    
    // Animations Variables
    @State private var displayCreateView = false
    @State private var rotationAngle: Double = 0
    @State private var initialSize: CGFloat = 40
    @State private var opacity: CGFloat = 0
    
    init(speechRecognizer: SpeechRecognizer, listenerOpacity: Binding<Double>) {
        self.speechRecognizer = speechRecognizer
        self._listenerOpacity = listenerOpacity
    }
    
    var body: some View {
        ZStack() {
            if listenerOpacity == 1.0 {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        Image("Storyteller Moon Icon", bundle: .main)
                            .resizable()
                            .scaledToFit()
                            .opacity(opacity)
                            .frame(width: initialSize, height: initialSize)
                            .rotationEffect(.degrees(rotationAngle))
                    }
                }
                .onAppear() {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        opacity = 1.0
                    }
                    withAnimation(.easeInOut(duration: 1.0)) {
                        initialSize = 150
                        rotationAngle -= 30
                    }
                }
            }
            
            if storytellerState.progress > 0.0 {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                CircularProgressView(progress: storytellerState.progress)
                    .onAppear() {
                         
                    }
            }
            
        }
        .onAppear() {
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
        .fullScreenCover(isPresented: $displayCreateView, onDismiss: {
            storytellerState.progress = 0.01
        }) {
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
    }
    
    // Method for ending user voice input and calling to OpenAI
    private func endListening() {
        // Check for overlapping recursion
        if isProcessingAudio {
            return
        }
        
        if !canListen {
            startListening()
            return
        }
        
        isProcessingAudio = true
        speechRecognizer.stopTranscribing()
        let transcript = speechRecognizer.transcript.lowercased()
        
        print(transcript)
        
        if !transcript.isEmpty {
            
            // Creating talking view logic
            if !listeningForCall {
                if parseTextForCommand(transcript, Constants.BEGIN_STORY_STRINGS) {
                    shouldListenForCommands = false
                    listeningForCall = true
                    
                    // Transition to create view
                    withAnimation(.easeInOut(duration: 0.5)) {
                        initialSize = 0
                    }
                    Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                        listenerOpacity = 0.0
                        displayCreateView = true
                    }
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
