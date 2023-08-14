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
            let listener = StorytellerListenerHelper(speechRecognizer: speechRecognizer, listenerOpacity: $listenerOpacity)
            StorytellerListenerHelper(speechRecognizer: speechRecognizer, listenerOpacity: $listenerOpacity)
                .opacity(listenerOpacity)

            VStack(alignment: .leading) {
                Text("Stories")
                    .font(.system(size: 40, weight: .semibold))
                
                Text("Hear about others stories")
                    .font(.system(size: 20, weight: .light))
                    .foregroundColor(Color("#3A3A3A"))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding()
            
            listener
                .opacity(listenerOpacity)

        }
    }
}

struct StoryView_Provider: PreviewProvider {
    static var previews: some View {
        StoryView(speechRecognizer: SpeechRecognizer(), listenerOpacity: 0.0)
    }
}
