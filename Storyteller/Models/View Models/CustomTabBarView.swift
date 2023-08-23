//
//  CustomTabBarView.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-08-23.
//

import SwiftUI

struct CustomTabBarView: View {
    
    @Binding var currentTab: String
    var bottomEdge: CGFloat
    var body: some View {
        HStack(spacing: 0) {
            ForEach(["house.fill", "magnifyingglass", "books.vertical.fill"], id: \.self) { image in
                TabButton(image: image, currentTab: $currentTab)
            }
        }
        .padding(.top, 15)
        .padding(.bottom, bottomEdge)
        .background(.black)
    }
}

struct CustomTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBarView(currentTab: .constant("Stories"), bottomEdge: 0.0)
    }
}

struct TabButton: View {
    var image: String
    @Binding var currentTab: String
    
    var body: some View {
        Button {
            withAnimation{currentTab = image}
        } label: {
            Image(systemName: image)
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
                .foregroundColor(currentTab == image ? .blue : Color.gray.opacity(0.7))
                .frame(maxWidth: .infinity)
        }
    }
}
