//
//  MoonPopUpAnimation.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-08-25.
//

import SwiftUI

struct MoonPopUpAnimation: View {
    
    @State private var rotationAngle: Double = 0
    @State private var initialSize: CGFloat = 120
    @State private var opacity: CGFloat = 0
    
    var body: some View {
        ZStack {
            Color("#171717").ignoresSafeArea()
            VStack {
                HStack {
                    Image("Storyteller Moon Icon", bundle: .main)
                        .resizable()
                        .scaledToFit()
                        .frame(width: initialSize, height: initialSize)
                        .rotationEffect(.degrees(rotationAngle))
                }
            }
        }
        .onAppear() {
            withAnimation(.easeInOut(duration: 0.5)) {
                opacity = 1.0
            }
            withAnimation(.easeInOut(duration: 1.0)) {
                initialSize = 150
                rotationAngle -= 30
            }
        }
    }
}

struct MoonPopUpAnimation_Previews: PreviewProvider {
    static var previews: some View {
        MoonPopUpAnimation()
    }
}
