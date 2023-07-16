//
//  SpeakingPulseAnimation.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-15.
//

import SwiftUI

struct SpeakingPulseAnimation: View {
    
    @State private var wave = false
    @State private var wave2 = false
    
    var body: some View {
        // TODO: - Rework animation (This is temporary)
        // Adapted from: https://www.youtube.com/watch?v=vreaXP4HUoE&ab_channel=DevTechie
        ZStack {
            Circle()
                .stroke(lineWidth: 40)
                .frame(width: 300, height: 300)
                .foregroundColor(.black)
                .scaleEffect(wave ? 2 : 1)
                .opacity(wave ? 0 : 1)
                .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: false).speed(0.5))
                .onAppear() {
                    self.wave.toggle()
                }
            
            Circle()
                .stroke(lineWidth: 40)
                .frame(width: 300, height: 300)
                .foregroundColor(.black)
                .scaleEffect(wave2 ? 2 : 1)
                .opacity(wave ? 0 : 1)
                .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: false).speed(0.7))
                .onAppear {
                    self.wave2.toggle()
                }
        }
    }
}

struct SpeakingPulseAnimation_Previews: PreviewProvider {
    static var previews: some View {
        SpeakingPulseAnimation()
    }
}
