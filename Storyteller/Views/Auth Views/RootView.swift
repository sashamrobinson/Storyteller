//
//  ContentView.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-06.
//

import SwiftUI
import AVFoundation

struct RootView: View {
    
    // Optional User object for accessing current user properties throughout the entire app
    
    var body: some View {
        NavigationStack {
            if let userId = LocalStorageHelper.retrieveUser() {
                
                // Populate currentUser
                
                // Move to main app
                TabBarControllerView()
            }
            
            else {
                HomeView()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
