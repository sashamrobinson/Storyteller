//
//  GenreStoriesView.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-08-15.
//

import SwiftUI

struct GenreStoriesView: View {
    @Environment(\.dismiss) private var dismiss
    @State var genre: Genre
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color("#171717").ignoresSafeArea()
            VStack(alignment: .leading) {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    }
                    .frame(width: 30, height: 30)
                    .padding()
                }
                VStack(alignment: .leading) {
                    Text(genre.rawValue.prefix(1).capitalized + genre.rawValue.dropFirst())
                        .font(.system(size: Constants.HEADER_FONT_SIZE, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(genre.description.prefix(1).capitalized + genre.description.dropFirst())
                        .font(.system(size: Constants.SUBTEXT_FONT_SIZE, weight: .medium))
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.leading)
            }
            
//            Button(action: {
//                dismiss()
//            }) {
//                Image(systemName: "chevron.left")
//                    .foregroundColor(.white)
//                    .font(.system(size: 20))
//            }
//            .frame(width: 30, height: 30)
//            .position(x: 0, y: 0)
//            .padding()
//            .padding()
        }
    }
}

struct GenreStoriesView_Previews: PreviewProvider {
    static var previews: some View {
        GenreStoriesView(genre: .heartwarming)
    }
}
