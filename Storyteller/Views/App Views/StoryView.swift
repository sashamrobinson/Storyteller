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
    @State var stories: [Story] = []
    @State private var presentingTableViewCell: Bool = false
    @State private var selectedStory: Story? = nil

    var body: some View {
        ZStack {
            let listener = StorytellerListenerHelper(speechRecognizer: speechRecognizer, listenerOpacity: $listenerOpacity)
            Color("#171717").ignoresSafeArea()
            VStack(alignment: .leading) {
                // TODO: - Put stories in its own top view that disappears as you scroll down and appears as you scroll up
                Text("Stories")
                    .font(.system(size: Constants.HEADER_FONT_SIZE, weight: .semibold))
                    .foregroundColor(.white)
                
                if stories.isEmpty {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Text("There are no available stories. Please check your connection")
                                .font(.system(size: Constants.SUBTEXT_FONT_SIZE, weight: .semibold))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding()
                            Spacer()
                        }
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(stories) { story in
                            StoryTableViewCell(story: story)
                                .listRowInsets(EdgeInsets())
                                .onTapGesture {
                                    self.selectedStory = story
                                    presentingTableViewCell.toggle()
                                }
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                }
                
            }
            .sheet(item: self.$selectedStory) { story in
                StoryDetailView(story: story, allowedToEdit: false)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding()
            
            listener
                .opacity(listenerOpacity)

        }
        .onAppear {
            FirebaseHelper.userSpecificStoryGenerationAlgorithm(numberOfPostsToReturn: 20, currentStories: stories, completion: { stories in
                self.stories = stories
            })
        }
    }
}

struct StoryView_Provider: PreviewProvider {
    static var previews: some View {
        StoryView(speechRecognizer: SpeechRecognizer(), listenerOpacity: 0.0)
    }
}
