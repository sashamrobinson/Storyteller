//
//  TabBarControllerView.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-14.
//

import SwiftUI

struct TabBarControllerView: View {
        
    @ObservedObject var speechRecognizer = SpeechRecognizer()
    
    
    /// Holds Story objects to populate BiographyView, sourced from fetch request
    @State var myStories: [Story] = []
    @State var selectedTab: String = "house.fill"
    @State private var hideBar: Bool = false
    
//    init() {
//        UITabBar.appearance().backgroundColor = UIColor.black
//    }
    var bottomEdge: CGFloat
    var topEdge: CGFloat
    init(bottomEdge: CGFloat, topEdge: CGFloat) {
        UITabBar.appearance().isHidden = true
        self.bottomEdge = bottomEdge
        self.topEdge = topEdge
    }
    
    var body: some View {
        ZStack {
            // TODO: - Change to custom TabView
            TabView(selection: $selectedTab) {
                StoryView(speechRecognizer: speechRecognizer, hideTab: $hideBar, bottomEdge: bottomEdge, topEdge: topEdge)
//                    .tabItem {
//                        Image(systemName: "house.fill")
//                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.primary.opacity(0.05))
                    .tag("house.fill")
                
                SearchView(speechRecognizer: speechRecognizer, hideTab: $hideBar, bottomEdge: bottomEdge, topEdge: topEdge)
//                    .tabItem {
//                        Image(systemName: "magnifyingglass")
//                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.primary.opacity(0.05))
                    .tag("magnifyingglass")
                
                BiographyView(speechRecognizer: speechRecognizer, stories: myStories, hideTab: $hideBar, bottomEdge: bottomEdge, topEdge: topEdge)
//                    .tabItem {
//                        Image(systemName: "books.vertical.fill")
//                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.primary.opacity(0.05))
                    .tag("books.vertical.fill")
            }
            .overlay(
                CustomTabBarView(currentTab: $selectedTab, bottomEdge: bottomEdge).offset(y: hideBar ? (50 + bottomEdge) : 0), alignment: .bottom
            )
//            .tint(Color.white)
//            .onChange(of: selectedTab) { newValue in
//
//            }
            
        }
        .onAppear() {
            // Fetch table data to populate views
            if let id = LocalStorageHelper.retrieveUser() {
                FirebaseHelper.fetchStoriesFromUserDocument(id: id) { fetchedStories in
                    if let fetchedStories = fetchedStories {
                        self.myStories = fetchedStories
                    }
                }
            }
        }
    }
}

struct TabBarControllerView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarControllerView(bottomEdge: 0.0, topEdge: 0.0)
    }
}
