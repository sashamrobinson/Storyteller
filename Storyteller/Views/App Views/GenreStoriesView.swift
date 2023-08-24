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
    
    // Scroll animations
    @Binding var hideTab: Bool
    @State var offset: CGFloat = 0
    @State var lastOffset: CGFloat = 0
    var bottomEdge: CGFloat
    var topEdge: CGFloat
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color("#171717").ignoresSafeArea()
            VStack {
                VStack(alignment: .leading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    }
                    .frame(width: 30, height: 30)
                    
                    Text(genre.name)
                        .font(.system(size: Constants.HEADER_FONT_SIZE, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.leading)
                        
                    Text(genre.description)
                        .font(.system(size: Constants.SUBTEXT_FONT_SIZE, weight: .medium))
                        .foregroundColor(.gray)
                        .padding(.leading)

                    
                }
                .padding(.top)
                .offset(y: hideTab ? -topEdge - 50 :     0)

                VStack(alignment: .leading) {
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
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(alignment: .leading, spacing: 10) {
                                ForEach(stories) { story in
                                    StoryTableViewCell(allowedToEdit: false, story: story)
                                }
                            }
                            .overlay(
                                GeometryReader { proxy -> Color in
                                    
                                    let minY = proxy.frame(in: .named("SCROLL")).minY
                                    
                                    let durationOffset: CGFloat = 35
                                    
                                    DispatchQueue.main.async {
                                        if minY < offset {
                                            if offset < 0 && -minY > (lastOffset + durationOffset) {
                                                withAnimation(.easeOut.speed(1.5)) {
                                                    hideTab = true
                                                }
                                                lastOffset = -offset
                                            }
                                        }
                                        if minY > offset {
                                            if offset < 0 && -minY > (lastOffset - durationOffset) {
                                                withAnimation(.easeOut.speed(1.5)) {
                                                    hideTab = false
                                                }
                                                lastOffset = -offset
                                            }
                                        }
                                        
                                        self.offset = minY
                                    }
                                    
                                    return Color.clear
                                }
                            )
                            .padding(.bottom, 50 + bottomEdge)
                        }
                        .coordinateSpace(name: "SCROLL")
                    }
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.leading)
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
        GenreStoriesView(genre: .heartwarming, hideTab: .constant(false), bottomEdge: 0.0, topEdge: 0.0)
    }
}
