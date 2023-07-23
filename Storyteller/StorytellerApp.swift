//
//  StorytellerApp.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-02.
//

import SwiftUI
import Firebase

@main
struct StorytellerApp: App {
    
    init() {
        
        // Firebase set up
        FirebaseApp.configure()
        
        // Get API Key to OpenAI
        APICaller.shared.setup()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
