//
//  SearchView.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-14.
//

import SwiftUI

struct SearchView: View {
    
    @ObservedObject var speechRecognizer: SpeechRecognizer
    @State private var searchText: String = ""
    @State private var isTyping: Bool = false
    let allGenres = Genre.allCases
    
    // Scroll animations
    @Binding var hideTab: Bool
    var bottomEdge: CGFloat
    var topEdge: CGFloat

    var body: some View {
        ZStack {
            Color("#171717").ignoresSafeArea()
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("Search")
                        .font(.system(size: Constants.HEADER_FONT_SIZE, weight: .semibold))
                        .foregroundColor(.white)
                    HStack {
                        TextField("", text: $searchText, prompt: Text("What are you looking for?").foregroundColor(.gray))
                            .foregroundColor(.white)
                            .padding()
                            .onChange(of: searchText) { newValue in
                                isTyping = true
                            }
                        
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .padding()
                    }
                    .background(Color("#292929"))
                    .cornerRadius(12.5)
                    
                    Text("Genres")
                        .font(.system(size: Constants.SUBTEXT_FONT_SIZE, weight: .semibold))
                        .foregroundColor(.gray)
                        .padding(.top)
                    
                    if !isTyping {
                        ScrollView(showsIndicators: false) {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2)) {
                                ForEach(allGenres) { genre in
                                    NavigationLink(destination: GenreStoriesView(genre: genre, hideTab: $hideTab, bottomEdge: bottomEdge, topEdge: topEdge).navigationBarBackButtonHidden(true)) {
                                        SearchGenreTableViewCell(genre: genre)

                                    }
                                }
                            }
                        }
                        .ignoresSafeArea()
                    }
                }
                .padding()
//                .background(
//                    RoundedRectangle(cornerRadius: 12)
//                        .foregroundColor(Color("#171717"))
//                        .shadow(color: .black, radius: 5, x: 0, y: 2)
//                )
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(speechRecognizer: SpeechRecognizer(), hideTab: .constant(false), bottomEdge: 0.0, topEdge: 0.0)
    }
}
