//
//  SignUpView.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-06.
//

import SwiftUI

struct SignUpView: View {
    @State private var test = false
    
    var body: some View {
        VStack {
            Button("Press to slide") {
                withAnimation {
                    test.toggle()
                }
            }
            
            if test {
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                    .font(.title)
                    .transition(.slide)
                    .frame(maxWidth: .infinity, alignment: .center)
        
            }
        }
        
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
