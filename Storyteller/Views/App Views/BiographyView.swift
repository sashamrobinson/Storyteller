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
    
    @State var stories: [Story] = []

    var body: some View {
        ZStack {
            StorytellerListenerHelper(speechRecognizer: speechRecognizer, listenerOpacity: $listenerOpacity)
                .opacity(listenerOpacity)
            
            Color("#171717").ignoresSafeArea()
            
            VStack(alignment: .leading) {
                HStack {
                    Text("My Stories")
                        .font(.system(size: Constants.HEADER_FONT_SIZE, weight: .semibold))
                        .foregroundColor(.white)
                    Spacer()
                    Button(action: {
                        print("Search")
                    }) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    }
                }
                List(stories) { story in
                    StoryTableViewCell(story: story)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding()
        }
        .onAppear {
            // Get local user id
            if let id = LocalStorageHelper.retrieveUser() {
                FirebaseHelper.fetchStoriesFromUserDocument(id: id) { fetchedStories in
                    if let fetchedStories = fetchedStories {
                        self.stories = fetchedStories
                    }
                }
            }
        }
    }
}

struct BiographyView_Previews: PreviewProvider {
    static var previews: some View {
        BiographyView(speechRecognizer: SpeechRecognizer(), listenerOpacity: 0.0)
    }
}
