//
//  CircularProgressView.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-08-29.
//

import SwiftUI

struct CircularProgressView: View {
    @Binding var progress: Double
    
    var body: some View {
        VStack {
            Text("Generating your story...")
                .font(.system(size: Constants.SUBTEXT_FONT_SIZE, weight: .medium))
                .foregroundColor(.white)
                .padding(.leading)
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
            .padding(.bottom)
            .padding(.top)
            Text(String(format: "%.0f", progress * 100) + "%")
                .font(.system(size: Constants.REGULAR_FONT_SIZE, weight: .medium))
                .foregroundColor(.white)
                .padding(.leading)
        }
    }
}

struct CircularProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressView(progress: .constant(0.2))
    }
}
