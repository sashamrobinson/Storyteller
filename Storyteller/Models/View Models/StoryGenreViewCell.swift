//
//  StoryGenreViewCell.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-08-16.
//

import SwiftUI

struct StoryGenreViewCell: View {
    
    @State var genre: Genre
    var body: some View {
        VStack() {
            Text(genre.name)
                .font(.system(size: Constants.DETAIL_FONT_SIZE, weight: .semibold))
                .foregroundColor(.white)
                .padding()
        }
        .frame(width: CGFloat(genre.rawValue.count) * 10 + 50, height: 30)
        .background(Color(genre.color))
        .cornerRadius(12.5)
    }
}

struct StoryGenreViewCell_Previews: PreviewProvider {
    static var previews: some View {
        StoryGenreViewCell(genre: .wow)
    }
}
