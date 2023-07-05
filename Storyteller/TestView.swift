//
//  TestView.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-02.
//

import SwiftUI
import AVFoundation

struct TestView: View {
    
    // Speech to text
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State var transcript : String = ""
    @State private var isRecording = false
    
    // Text to speech
    @State private var name : String = ""
    
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
        print("This is working")
        print(transcript)
        isRecording = false
    }
}



struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
