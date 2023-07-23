//
//  SearchView.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-14.
//

import SwiftUI

struct SearchView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Search")
                .font(.system(size: 60, weight: .semibold))
            
            Text("Find other people")
                .font(.system(size: 30, weight: .light))
                .foregroundColor(Color("#3A3A3A"))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding()
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
