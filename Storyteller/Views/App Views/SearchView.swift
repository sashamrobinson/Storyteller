//
//  SearchView.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-14.
//

import SwiftUI

struct SearchView: View {
    
    @ObservedObject var speechRecognizer: SpeechRecognizer

    var body: some View {
        ZStack {
            Color("#171717").ignoresSafeArea()
            VStack(alignment: .leading) {
                Text("Search")
                    .font(.system(size: Constants.HEADER_FONT_SIZE, weight: .semibold))
                    .foregroundColor(.white)
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding()
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(speechRecognizer: SpeechRecognizer())
    }
}
