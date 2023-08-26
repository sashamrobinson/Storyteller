//
//  SplashScreenView.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-08-16.
//

import SwiftUI

struct SplashScreenView: View {
    
    @State private var isActive: Bool = false
    
    var body: some View {
        if isActive {
            RootView()
        } else {
            ZStack {
                Color("#171717").ignoresSafeArea()
                MoonPresentingAnimation()
                .onAppear() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
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
