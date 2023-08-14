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
    @Published var label: NSAttributedString?
    
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
        if isSpeaking {
            speaker.speak(utterance)
            
            // Allows us to only call completion when utterance finishes speaking (to avoid overlap)
            let storedCompletion = completion
            storedCompletions[utterance] = storedCompletion
        }
    }
    
    // Method for pausing speech
    func pause() {
        if !isSpeaking {
            speaker.pauseSpeaking(at: .immediate)
        }
    }
    
    // Method for resuming speech
    func resumeSpeaking() {
        if isSpeaking {
            speaker.continueSpeaking()
        }
    }
    
    // Method for toggling isSpeaking variable
    func toggleSpeaking() {
        isSpeaking.toggle()
    }
    
    // Delegate method called when speaker done speaking
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        label = NSAttributedString(string: utterance.speechString)
        isSpeaking = false
        if let storedCompletion = storedCompletions[utterance] {
            storedCompletion()
            storedCompletions[utterance] = nil
        }
    }
    
    // TODO: - Delegate method for capturing the current word being uttered
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        let mutableAttributedString = NSMutableAttributedString(string: utterance.speechString)
            mutableAttributedString.addAttribute(.foregroundColor, value: UIColor.red, range: characterRange)
        label = mutableAttributedString
    }
}
