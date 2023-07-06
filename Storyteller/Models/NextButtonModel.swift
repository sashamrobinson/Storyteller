//
//  NextButtonModel.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-06.
//

import SwiftUI

struct NextButtonModel: View {
    
    @Binding var test: Int
    
    var body: some View {
        Button("Next") {
            print($test.wrappedValue)
        }
        .padding()
        .frame(width: UIScreen.screenWidth / 3)
        .font(.system(size: 20, weight: .regular))
        .foregroundColor(.white)
        .background(.black)
        .cornerRadius(12.5)
        .padding()
        
    }
}

struct NextButtonModel_Previews: PreviewProvider {
    static var previews: some View {
        NextButtonModel(test: .constant(10))
    }
}
