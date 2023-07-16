//
//  TabBarControllerView.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-14.
//

import SwiftUI

struct TabBarControllerView: View {
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.black
    }
    
    var body: some View {
        // TODO: - Change to custom TabView
        TabView {
            StoryView()
                .tabItem {
                    Image(systemName: "house")
                }
            
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
            
            CreateView()
                .tabItem {
                    Image(systemName: "pencil")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "person")
                }
        }
        .tint(Color.white)
        
    }
}

struct TabBarControllerView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarControllerView()
    }
}
