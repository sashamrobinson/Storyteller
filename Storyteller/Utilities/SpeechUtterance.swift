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
    @Published var isSpeaking: Bool = false
    
    init(isSpeaking: Bool = false) {
        self.isSpeaking = isSpeaking
    }
    
    var storedCompletions: [AVSpeechUtterance: () -> Void] = [:]
        
    // Method for uttering speech
    func speak(text: String, completion: @escaping () -> Void) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = voice
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        utterance.volume = 1
        speaker.delegate = self
        
        if !isSpeaking {
            isSpeaking = true
            speaker.speak(utterance)
            
            // Allows us to only call completion when utterance finishes speaking (to avoid overlap)
            let storedCompletion = completion
            storedCompletions[utterance] = storedCompletion
        }
    }
    
    // Delegate method called when speaker done speaking
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isSpeaking = false
        
        if let storedCompletion = storedCompletions[utterance] {
            storedCompletion()
            storedCompletions[utterance] = nil
        }
    }
}
