//
//  CircularProgressView.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-08-29.
//

import SwiftUI

struct CircularProgressView: View {
    @State var progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.blue.opacity(0.5),
                    lineWidth: 10
                )
                .frame(width: 64, height: 64)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.blue,
                    style: StrokeStyle(
                        lineWidth: 10,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)
                .frame(width: 64, height: 64)
        }
    }
}

struct CircularProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressView(progress: 0.2)
    }
}
