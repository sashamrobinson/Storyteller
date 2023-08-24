//
//  SearchView.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-14.
//

import SwiftUI

struct SearchView: View {
    
    @ObservedObject var speechRecognizer: SpeechRecognizer
    @State private var searchText: String = ""
    @State var stories: [Story] = []
    @State private var timer: Timer?
    @State private var currentDisplay: SearchStatus = .displayGenres
    let allGenres = Genre.allCases
    
    // Scroll animations
    @Binding var hideTab: Bool
    @State var offset: CGFloat = 0
    @State var lastOffset: CGFloat = 0
    var bottomEdge: CGFloat
    var topEdge: CGFloat
    

    var body: some View {
        ZStack {
            Color("#171717").ignoresSafeArea()
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("Search")
                        .font(.system(size: Constants.HEADER_FONT_SIZE, weight: .semibold))
                        .foregroundColor(.white)
                    HStack {
                        TextField("", text: $searchText, prompt: Text("What are you looking for?").foregroundColor(.gray))
                            .foregroundColor(.white)
                            .padding()
                            .onChange(of: searchText) { newValue in
                                timer?.invalidate()
                                if newValue.isEmpty {
                                    currentDisplay = .displayGenres
                                } else {
                                    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
                                        currentDisplay = .displayLoading
                                        FirebaseHelper.queryStoriesWithKeyword(query: newValue) { stories in
                                            if stories.isEmpty {
                                                currentDisplay = .displayEmpty
                                            } else {
                                                self.stories = stories
                                                currentDisplay = .displayStories
                                            }
                                        }
                                    })
                                }
                            }
                        
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .padding()
                    }
                    .background(Color("#292929"))
                    .cornerRadius(12.5)
                    
//                    if !stories.isEmpty {
//                        // Show stories
//                    } else if stories.isEmpty {
//                        if !isTyping {
//                            // Show genres
//                        } else if isTyping {
//                            if displayEmpty {
//                                // Show error
//                            } else {
//                                // Show loading
//                            }
//                        }
//                    }
                    switch currentDisplay {
                    case .displayGenres:
                        // Show genres
                        Text("Genres")
                            .font(.system(size: Constants.SUBTEXT_FONT_SIZE, weight: .semibold))
                            .foregroundColor(.gray)
                            .padding(.top)
                        
                        ScrollView(showsIndicators: false) {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2)) {
                                ForEach(allGenres) { genre in
                                    NavigationLink(destination: GenreStoriesView(genre: genre, hideTab: $hideTab, bottomEdge: bottomEdge, topEdge: topEdge).navigationBarBackButtonHidden(true)) {
                                        SearchGenreTableViewCell(genre: genre)

                                    }
                                }
                            }
                        }
                        .ignoresSafeArea()
                        
                    case .displayLoading:
                        // Show loading
                        LoadingCircleAnimation()
                        
                    case .displayStories:
                        // Show stories
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
                        
                    case .displayEmpty:
                        // Show empty text
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
                    
                    
//                    if !isTyping || searchText.isEmpty {
//                        Text("Genres")
//                            .font(.system(size: Constants.SUBTEXT_FONT_SIZE, weight: .semibold))
//                            .foregroundColor(.gray)
//                            .padding(.top)
//
//                        ScrollView(showsIndicators: false) {
//                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2)) {
//                                ForEach(allGenres) { genre in
//                                    NavigationLink(destination: GenreStoriesView(genre: genre, hideTab: $hideTab, bottomEdge: bottomEdge, topEdge: topEdge).navigationBarBackButtonHidden(true)) {
//                                        SearchGenreTableViewCell(genre: genre)
//
//                                    }
//                                }
//                            }
//                        }
//                        .ignoresSafeArea()
//                    } else if isTyping && stories.isEmpty {
//                        LoadingCircleAnimation()
//                    } else if isTyping && !stories.isEmpty {
//                        ScrollView(.vertical, showsIndicators: false) {
//                            VStack(alignment: .leading, spacing: 10) {
//                                ForEach(stories) { story in
//                                    StoryTableViewCell(allowedToEdit: false, story: story)
//                                }
//                            }
//                            .overlay(
//                                GeometryReader { proxy -> Color in
//
//                                    let minY = proxy.frame(in: .named("SCROLL")).minY
//
//                                    let durationOffset: CGFloat = 35
//
//                                    DispatchQueue.main.async {
//                                        if minY < offset {
//                                            if offset < 0 && -minY > (lastOffset + durationOffset) {
//                                                withAnimation(.easeOut.speed(1.5)) {
//                                                    hideTab = true
//                                                }
//                                                lastOffset = -offset
//                                            }
//                                        }
//                                        if minY > offset {
//                                            if offset < 0 && -minY > (lastOffset - durationOffset) {
//                                                withAnimation(.easeOut.speed(1.5)) {
//                                                    hideTab = false
//                                                }
//                                                lastOffset = -offset
//                                            }
//                                        }
//
//                                        self.offset = minY
//                                    }
//
//                                    return Color.clear
//                                }
//                            )
//                            .padding(.bottom, 50 + bottomEdge)
//                        }
//                        .coordinateSpace(name: "SCROLL")
//                    }
                }
                .padding()
//                .background(
//                    RoundedRectangle(cornerRadius: 12)
//                        .foregroundColor(Color("#171717"))
//                        .shadow(color: .black, radius: 5, x: 0, y: 2)
//                )
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(speechRecognizer: SpeechRecognizer(), hideTab: .constant(false), bottomEdge: 0.0, topEdge: 0.0)
    }
}

enum SearchStatus {
    case displayGenres
    case displayStories
    case displayLoading
    case displayEmpty
}
