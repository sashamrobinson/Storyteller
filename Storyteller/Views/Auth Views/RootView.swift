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
            if LocalStorageHelper.retrieveUser() != nil {
                                
                // Move to main app
                GeometryReader { proxy in
                    let bottomEdge = proxy.safeAreaInsets.bottom
                    let topEdge = proxy.safeAreaInsets.top
                    TabBarControllerView(bottomEdge: (bottomEdge == 0 ? 15 : bottomEdge), topEdge: (topEdge == 0 ? 15 : topEdge))
                        .ignoresSafeArea(.all, edges: .bottom)
                }
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
