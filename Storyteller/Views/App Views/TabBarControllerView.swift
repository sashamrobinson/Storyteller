//
//  TabBarControllerView.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-14.
//

import SwiftUI

struct TabBarControllerView: View {
        
    @ObservedObject var speechRecognizer = SpeechRecognizer()
    @State var tabViewIsVisible = true
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.black
    }
    
    var body: some View {
        ZStack {
            // TODO: - Change to custom TabView
            TabView {
                StoryView(tabViewIsVisible: $tabViewIsVisible)
                    .tabItem {
                        Image(systemName: "house")
                    }
                
                SearchView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                    }
                
                SettingsView()
                    .tabItem {
                        Image(systemName: "person")
                    }
            }
            .tint(Color.white)
            
            StorytellerListenerHelper(speechRecognizer: speechRecognizer)
        }
    }
}

struct TabBarControllerView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarControllerView()
    }
}
