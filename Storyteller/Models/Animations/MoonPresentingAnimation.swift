//
//  MoonRadiatingAnimation.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-08-25.
//

import SwiftUI

struct MoonPresentingAnimation: View {
    
    @State private var xOffset: CGFloat = 150
    @State private var yOffset: CGFloat = -150
    @State private var initialSize: CGFloat = 120
    @State private var opacity: CGFloat = 0.0

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Circle()
                        .frame(width: initialSize, height: initialSize)
                        .foregroundColor(.white)
                        .opacity(opacity)
                }
            }
            VStack {
                HStack {
                    Circle()
                        .frame(width: 151, height: 151)
                        .foregroundColor(Color("#171717"))
                        .offset(x: xOffset, y: yOffset)
                }
            }
        }
        .onAppear() {
            withAnimation(.easeInOut(duration: 0.5)) {
                opacity = 1.0
            }
            withAnimation(.easeInOut(duration: 1.0)) {
                initialSize = 150
            }
            withAnimation(.easeInOut(duration: 2.0)) {
                xOffset = 30
                yOffset = -25
            }
        }
    }
}

struct MoonRadiatingAnimation_Previews: PreviewProvider {
    static var previews: some View {
        MoonPresentingAnimation()
    }
}
