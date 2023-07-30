//
//  StoryView.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-07.
//

import SwiftUI
import AVFoundation
import OpenAISwift

struct StoryView: View {
    
    // Animations
    @State private var displayCreateView = false
    
    @Binding var tabViewIsVisible: Bool
        
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text("Stories")
                    .font(.system(size: 60, weight: .semibold))
                
                Text("Hear about others stories")
                    .font(.system(size: 30, weight: .light))
                    .foregroundColor(Color("#3A3A3A"))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding()
            .navigationDestination(isPresented: $displayCreateView) {
                CreateView().navigationBarBackButtonHidden(true)
            }
        }
    }
}

struct StoryView_Provider: PreviewProvider {
    static var previews: some View {
        StoryView(tabViewIsVisible: .constant(true))
    }
}
