//
//  StorytellerApp.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-02.
//

import SwiftUI

@main
struct StorytellerApp: App {
    
    init() {
        APICaller.shared.setup()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
