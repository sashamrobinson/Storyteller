//
//  SpeechUtterance.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-15.
//

import Foundation
import SwiftUI
import AVFoundation

class SpeechUtterance: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    
    let speaker = AVSpeechSynthesizer()
    let voice = AVSpeechSynthesisVoice.speechVoices().first { $0.identifier == "com.apple.voice.compact.en-US.Samantha"}
    @Published var isSpeaking = false
        
    // Method for uttering speech
    func speak(text: String) {
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = voice
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        utterance.volume = 1
        
        speaker.delegate = self
        
        if !isSpeaking {
            isSpeaking = true
            speaker.speak(utterance)
        }
    }
    
    // Delegate method called when speaker done speaking
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isSpeaking = false
    }
}
