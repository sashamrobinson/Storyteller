//
//  EndMoonGlowingAnimation.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-08-25.
//

import SwiftUI

struct EndMoonGlowingAnimation: View {
    @State private var xOffset: CGFloat = 150
    @State private var yOffset: CGFloat = -150
    @State private var initialSize: CGFloat = 180
    @State private var blurRadius: CGFloat = 12.0
    
    var body: some View {
        ZStack {
            Color("#171717").ignoresSafeArea()
            VStack {
                HStack {
                    Circle()
                        .frame(width: initialSize, height: initialSize)
                        .foregroundColor(.white)
                        .blur(radius: blurRadius)
                }
            }
            
            VStack {
                HStack {
                    Circle()
                        .frame(width: initialSize, height: initialSize)
                        .foregroundColor(Color("#171717"))
                }
            }
            
            VStack {
                HStack {
                    Circle()
                        .frame(width: initialSize, height: initialSize)
                        .foregroundColor(.white)
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
            withAnimation(.easeInOut(duration: 1.0)) {
                initialSize = 150
                blurRadius = 0
            }
            withAnimation(.easeInOut(duration: 1.5)) {
                xOffset = 30
                yOffset = -25
            }
        }
    }
}

struct EndMoonGlowingAnimation_Previews: PreviewProvider {
    static var previews: some View {
        EndMoonGlowingAnimation()
    }
}
