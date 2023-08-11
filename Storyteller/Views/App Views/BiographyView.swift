//
//  BiographyView.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-08-10.
//

import SwiftUI

struct BiographyView: View {
    
    @ObservedObject var speechRecognizer: SpeechRecognizer
    @State var listenerOpacity: Double = 0.0

    var body: some View {
        ZStack {
            StorytellerListenerHelper(speechRecognizer: speechRecognizer, listenerOpacity: $listenerOpacity)
                .opacity(listenerOpacity)
            
            Color("#171717").ignoresSafeArea()

            VStack(alignment: .leading) {
                Text("My Stories")
                    .font(.system(size: Constants.HEADER_FONT_SIZE, weight: .semibold))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding()
        }
    }
}

struct BiographyView_Previews: PreviewProvider {
    static var previews: some View {
        BiographyView(speechRecognizer: SpeechRecognizer(), listenerOpacity: 0.0)
    }
}
