//
//  MoonGlowingAnimation.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-08-25.
//

import SwiftUI

struct BeginMoonGlowingAnimation: View {
    
    @State private var xOffset: CGFloat = 30
    @State private var yOffset: CGFloat = -25
    @State private var initialSize: CGFloat = 150
    @State private var blurRadius: CGFloat = 0.0
    
    var body: some View {
        ZStack {
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
                initialSize = 180
                blurRadius = 12.0
            }
            withAnimation(.easeInOut(duration: 1.5)) {
                xOffset = 150
                yOffset = -150
            }
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: true)) {
                    blurRadius = 5.0
                }
            }
        }
    }
}

struct MoonGlowingAnimation_Previews: PreviewProvider {
    static var previews: some View {
        BeginMoonGlowingAnimation()
    }
}
