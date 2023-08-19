//
//  SplashScreenView.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-08-16.
//

import SwiftUI

struct SplashScreenView: View {
    
    @State private var isActive: Bool = false
    @State private var size = 0.7
    @State private var opacity = 0.5
    
    var body: some View {
        if isActive {
            RootView()
        } else {
            ZStack {
                Color("#171717").ignoresSafeArea()
                VStack {
                    VStack {
                        Image("Storyteller Background Icon Big", bundle: .main)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                    }
                    .scaleEffect(size)
                    .opacity(opacity)
                    .onAppear() {
                        withAnimation(.easeIn(duration: 1.2)) {
                            self.size = 0.9
                            self.opacity = 1.0
                        }
                    }
                }
                .onAppear() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation {
                            self.isActive = true
                        }
                    }
                }
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
