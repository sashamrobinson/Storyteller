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
            Color("#171717").ignoresSafeArea()
            VStack(alignment: .leading) {
                // TODO: - Put stories in its own top view that disappears as you scroll down and appears as you scroll up
                Text("Stories")
                    .font(.system(size: Constants.HEADER_FONT_SIZE, weight: .semibold))
                    .foregroundColor(.white)
                
                Button("Test") {
                    let inputString = "Sad, Funny, Slice of Life, dkamwkdma, kamdkamd, Exciting"
                    print(extractGenres(inputString))
                }
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
