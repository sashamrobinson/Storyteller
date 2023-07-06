//
//  TestView.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-02.
//

import SwiftUI
import OpenAISwift
import AVFoundation

struct TestView: View {
    
    // Speech to text
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State var transcript : String = ""
    @State private var isRecording = false
    @State private var input = ""
    
    // Text to speech
    @State private var name: String = ""
    
    let synthesizer = AVSpeechSynthesizer()
    
    var body: some View {
        VStack {
            
            Button("Start transcribing text") {
                startConversation()
            }
            Button("Stop transcribing text") {
                endConversation()
            }
            .padding()
            Text(transcript)
            TextField("Name", text: $name)
            Button("Greet") {
                let utterance = AVSpeechUtterance(string: "Hello \(name). How are you doing today? I hope your day is going well and that my voice is crystal clear.")
                utterance.voice = AVSpeechSynthesisVoice(language: "en-AU")
                utterance.rate = 0.5
                
                synthesizer.speak(utterance)
            }
            
        }
    }
    
    private func startConversation() {
        
        // Reset speech recognizer, begin transcribing and begin recording
        speechRecognizer.resetTranscript()
        speechRecognizer.startTranscribing()
        isRecording = true
    }
    
    private func endConversation() {
        
        // Stop transcribing and stop recording
        speechRecognizer.stopTranscribing()
        transcript = speechRecognizer.transcript
        isRecording = false
        sendToOpenAI(input: transcript)
    }
    
    private func sendToOpenAI(input: String) {
        if !input.isEmpty {
            APICaller.shared.getResponse(input: input) { result in
                switch result {
                case .success(let output):
                    
                    do {
                        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.duckOthers, .allowBluetooth])
                        try AVAudioSession.sharedInstance().setActive(true)
                    }
                    catch {
                        
                    }
                    let utterance = AVSpeechUtterance(string: output)
                    utterance.voice = AVSpeechSynthesisVoice(language: "en-AU")
                    utterance.rate = 0.5
                    utterance.volume = 1
                    
                    synthesizer.speak(utterance)
                case .failure:
                    print("Failed")
                }
            }
        }
    }
    
    
}



struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
