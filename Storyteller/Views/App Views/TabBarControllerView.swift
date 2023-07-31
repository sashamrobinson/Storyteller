//
//  TabBarControllerView.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-14.
//

import SwiftUI

struct TabBarControllerView: View {
        
    @ObservedObject var speechRecognizer = SpeechRecognizer()
    @State var selectedTab = 1
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.black
    }
    
    var body: some View {
        ZStack {
            // TODO: - Change to custom TabView
            TabView(selection: $selectedTab) {
                StoryView(speechRecognizer: speechRecognizer)
                    .tabItem {
                        Image(systemName: "house")
                    }
                    .tag(1)
                
                SearchView(speechRecognizer: speechRecognizer)
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                    }
                    .tag(2)
                
                SettingsView()
                    .tabItem {
                        Image(systemName: "person")
                    }
                    .tag(3)
            }
            .tint(Color.white)
            .onChange(of: selectedTab) { newValue in
                
            }
            
        }
    }
}

struct TabBarControllerView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarControllerView()
    }
}
