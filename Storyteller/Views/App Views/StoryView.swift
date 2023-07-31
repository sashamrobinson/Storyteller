//
//  StoryView.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-07.
//

import SwiftUI
import AVFoundation
import OpenAISwift

struct StoryView: View {
        
    @ObservedObject var speechRecognizer: SpeechRecognizer
    @State var listenerOpacity: Double = 0.0
        
    var body: some View {
        ZStack {
            StorytellerListenerHelper(speechRecognizer: speechRecognizer, listenerOpacity: $listenerOpacity)
                .opacity(listenerOpacity)

            VStack(alignment: .leading) {
                Text("Stories")
                    .font(.system(size: 60, weight: .semibold))
                
                Text("Hear about others stories")
                    .font(.system(size: 30, weight: .light))
                    .foregroundColor(Color("#3A3A3A"))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding()
        }
        .onDisappear() {
            listenerOpacity = 0.0
        }
    }
}

struct StoryView_Provider: PreviewProvider {
    static var previews: some View {
        StoryView(speechRecognizer: SpeechRecognizer(), listenerOpacity: 1.0)
    }
}
