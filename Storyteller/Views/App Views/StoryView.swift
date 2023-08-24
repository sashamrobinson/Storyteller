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
    @State private var secondsTillDisplayEmpty: Int = 3
    @State private var displayEmpty: Bool = false
    @State private var presentingTableViewCell: Bool = false
    
    // Scroll animations
    @Binding var hideTab: Bool
    @State var offset: CGFloat = 0
    @State var lastOffset: CGFloat = 0
    var bottomEdge: CGFloat
    var topEdge: CGFloat

    var body: some View {
        ZStack {
            let listener = StorytellerListenerHelper(speechRecognizer: speechRecognizer, listenerOpacity: $listenerOpacity)
            Color("#171717").ignoresSafeArea()
            .foregroundColor(.white)
            VStack(alignment: .leading) {
                // TODO: - Put stories text in its own top view that disappears as you scroll down and appears as you scroll up
                Text("Stories")
                    .font(.system(size: Constants.HEADER_FONT_SIZE, weight: .semibold))
                    .foregroundColor(.white)
                    .offset(y: hideTab ? -topEdge - 50 :     0)
                
                if stories.isEmpty && !displayEmpty {
                    LoadingCircleAnimation()
                } else if stories.isEmpty && displayEmpty {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Text("There are no available stories. Please check your connection if this problem persists")
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
            FirebaseHelper.userSpecificStoryGenerationAlgorithm(numberOfPostsToReturn: 20, currentStories: stories, completion: { stories in
                self.stories = stories
            })
        }
    }
}

struct StoryView_Provider: PreviewProvider {
    static var previews: some View {
        StoryView(speechRecognizer: SpeechRecognizer(), listenerOpacity: 0.0, hideTab: .constant(false), bottomEdge: 0.0, topEdge: 0.0)
    }
}
