//
//  LoadingCircleAnimation.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-08-22.
//

import SwiftUI

struct LoadingCircleAnimation: View {
    @State private var spin: Bool = false
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Circle()
                    .trim(from: 1/4, to: 1)
                    .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                    .foregroundColor(.blue)
                    .frame(width: 32, height: 32)
                    .rotationEffect(.degrees(spin ? 360 : 0))
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                    .onAppear {
                        self.spin.toggle()
                    }
                Spacer()
            }
            Spacer()
        }
    }
}

struct LoadingCircleAnimation_Previews: PreviewProvider {
    static var previews: some View {
        LoadingCircleAnimation()
    }
}
