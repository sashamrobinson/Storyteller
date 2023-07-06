//
//  ContentView.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-06.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            HomeView()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
