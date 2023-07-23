//
//  StoryView.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-07.
//

import SwiftUI

struct StoryView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Stories")
                .font(.system(size: 60, weight: .semibold))
            
            Text("Hear about others stories")
                .font(.system(size: 30, weight: .light))
                .foregroundColor(Color("#3A3A3A"))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding()


    }
}

struct StoryView_Provider: PreviewProvider {
    static var previews: some View {
        StoryView()
    }
}
