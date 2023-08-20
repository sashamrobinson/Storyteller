//
//  GenreStoriesView.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-08-15.
//

import SwiftUI

struct GenreStoriesView: View {
    @Environment(\.dismiss) private var dismiss
    @State var genre: Genre
    @State var stories: [Story] = []
    @State var presentingTableViewCell: Bool = false
    @State private var selectedStory: Story? = nil
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color("#171717").ignoresSafeArea()
            VStack(alignment: .leading) {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    }
                    .frame(width: 30, height: 30)
                    .padding()
                }
                VStack(alignment: .leading) {
                    Text(genre.name)
                        .font(.system(size: Constants.HEADER_FONT_SIZE, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(genre.description)
                        .font(.system(size: Constants.SUBTEXT_FONT_SIZE, weight: .medium))
                        .foregroundColor(.gray)
                    
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
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.leading)
            }
            .sheet(item: self.$selectedStory) { story in
                StoryDetailView(story: story, allowedToEdit: false)
            }
        }
        .onAppear() {
            FirebaseHelper.genreSpecificStoryGenerationAlgorithm(numberOfPostsToReturn: 10, genre: self.genre, currentStories: stories, maxLoadSize: .light, completion: { stories in
                
                self.stories.append(contentsOf: stories)
            })
        }
    }
}

struct GenreStoriesView_Previews: PreviewProvider {
    static var previews: some View {
        GenreStoriesView(genre: .heartwarming)
    }
}
