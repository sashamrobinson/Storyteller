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
    @State var selectedStory: Story? = nil
    @State var displaySettings: Bool = false
    @State private var secondsTillDisplayEmpty: Int = 3
    @State private var displayEmpty: Bool = false
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
                        displaySettings.toggle()
                    }) {
                        Image(systemName: "person.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .padding()
                    }
                }
                if stories.isEmpty && !displayEmpty {
                    LoadingCircleAnimation()
                } else if stories.isEmpty && displayEmpty {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Text("You have no stories yet. Please check your available connection if you believe this is an error")
                                .font(.system(size: Constants.SUBTEXT_FONT_SIZE, weight: .semibold))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding()
                            Spacer()
                        }
                        Spacer()
                    }
                }
                
                else {
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
//                if stories.isEmpty {
//                    VStack {
//                        Spacer()
//                        HStack {
//                            Spacer()
//                            Text("You have no stories yet")
//                                .font(.system(size: Constants.SUBTEXT_FONT_SIZE, weight: .semibold))
//                                .foregroundColor(.gray)
//                            Spacer()
//                        }
//                        Spacer()
//                    }
//                } else {
//                    List {
//                        ForEach(stories) { story in
//                            StoryTableViewCell(story: story)
//                                .listRowInsets(EdgeInsets())
//                                .onTapGesture {
//                                    self.selectedStory = story
//                                    listener.canListen.toggle()
//                                    presentingTableViewCell.toggle()
//                                }
//                        }
//                        .listRowBackground(Color.clear)
//                        .listRowSeparator(.hidden)
//                    }
//                    .listStyle(.plain)
//                    .scrollContentBackground(.hidden)
//                    .background(Color.clear)
//                }
            }
            .sheet(item: self.$selectedStory) { story in
                StoryDetailView(story: story, allowedToEdit: true)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding()
            
            listener
                .opacity(listenerOpacity)
        }
        .onAppear {
            secondsTillDisplayEmpty = 3
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
                secondsTillDisplayEmpty -= 1
                if secondsTillDisplayEmpty == 0 {
                    timer.invalidate()
                    displayEmpty = true
                }
            })
            if let id = LocalStorageHelper.retrieveUser() {
                FirebaseHelper.fetchStoriesFromUserDocument(id: id) { fetchedStories in
                    if let fetchedStories = fetchedStories {
                        self.stories = fetchedStories
                    }
                }
            }
        }
        .sheet(isPresented: $displaySettings) {
            SettingsView()
        }
    }
}

struct BiographyView_Previews: PreviewProvider {
    static var previews: some View {
        BiographyView(speechRecognizer: SpeechRecognizer(), selectedStory: Story(storyId: "StoryID", author: "", authorUid: "", dateCreated: "", title: "", published: false, conversation: [], summary: "", genres: [], numberOfLikes: 5, imageUrl: ""))
    }
}