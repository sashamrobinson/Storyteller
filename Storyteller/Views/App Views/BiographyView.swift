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
    @State var displaySettings: Bool = false
    @State private var secondsTillDisplayEmpty: Int = 3
    @State private var displayEmpty: Bool = false
    
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
                            Text("You have no stories yet. Create your first story to see it here")
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
                                StoryTableViewCell(allowedToEdit: true, story: story)
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
            SettingsView(speechRecognizer: speechRecognizer)
        }
    }
}

struct BiographyView_Previews: PreviewProvider {
    static var previews: some View {
        BiographyView(speechRecognizer: SpeechRecognizer(), listenerOpacity: 0.0, hideTab: .constant(false), bottomEdge: 0.0, topEdge: 0.0)
    }
}
