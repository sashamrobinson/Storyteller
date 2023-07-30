//
//  PopUpMoonView.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-25.
//

import SwiftUI

struct PopUpMoonView: View {
    
    @Binding var popUpViewAppear: Bool
    @State private var scale = 0.2
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.white.opacity(0.5)
            
            Image("Storyteller Background Icon Big", bundle: .main)
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .scaleEffect(scale)
                .animation(.easeInOut(duration: 0.25), value: scale)
        }
        .onAppear() {
            scale = 1
        }
        .onTapGesture {
            print("Test")
            popUpViewAppear = false
        }
    }
}

struct PopUpMoonView_Previews: PreviewProvider {
    static var previews: some View {
        PopUpMoonView(popUpViewAppear: .constant(true))
    }
}
