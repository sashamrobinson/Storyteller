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
    @State var presentingTableViewCell = false
    
    var body: some View {
        ZStack {
            let listener = StorytellerListenerHelper(speechRecognizer: speechRecognizer, listenerOpacity: $listenerOpacity)
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
                List {
                    ForEach(stories) { story in
                        StoryTableViewCell(story: story)
                            .listRowInsets(EdgeInsets())
                            .onTapGesture {
                                listener.canListen.toggle()
                                presentingTableViewCell.toggle()
                            }
                            .sheet(isPresented: $presentingTableViewCell) {
                                StoryDetailView(story: story)
                            }
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding()
            
            listener
                .opacity(listenerOpacity)
        }
        .onAppear {
            // TODO: - Replace this call with a scroll up load functionality that will call this so as to limit resources wasted
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
        BiographyView(speechRecognizer: SpeechRecognizer())
    }
}
