//
//  SearchGenreTableViewCell.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-08-15.
//

import SwiftUI

struct SearchGenreTableViewCell: View {
    
    @State var genre: Genre
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(genre.rawValue.prefix(1).capitalized + genre.rawValue.dropFirst())
                .font(.system(size: Constants.REGULAR_FONT_SIZE, weight: .medium))
                .foregroundColor(.white)
                .padding()
        }
        .frame(width: UIScreen.screenWidth / 2 - 20, height: 100)
//        .frame(width: 150, height: 96)
        .background(Color(genre.color))
        .cornerRadius(12.5)
    }
}

struct SearchGenreTableViewCell_Previews: PreviewProvider {
    static var previews: some View {
        SearchGenreTableViewCell(genre: .heartwarming)
    }
}
