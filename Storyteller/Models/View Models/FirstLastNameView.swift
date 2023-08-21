//
//  FirstLastNameView.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-06.
//

import SwiftUI

struct FirstLastNameView: View {
    @Binding var firstName: String
    @Binding var lastName: String
    
    var body: some View {
        VStack {
            Text("What's your name?")
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 80)
                .padding(.horizontal)
            
            TextField(text: $firstName) {
                Text("First Name")
                    .foregroundColor(.white.opacity(0.5))
                
            }
            
            .padding()
            .background(Color("#292929"))
            .cornerRadius(5)
            .padding(.horizontal)
            .padding(.bottom, 5)
            .autocorrectionDisabled(true)
            .foregroundColor(.gray)
            
            TextField(text: $lastName) {
                Text("Last Name")
                    .foregroundColor(.white.opacity(0.5))
                
            }
            .padding()
            .background(Color("#292929"))
            .cornerRadius(5)
            .padding(.horizontal)
            .autocorrectionDisabled(true)
            .foregroundColor(.gray)
            
        }
        .transition(.slide)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

struct FirstLastNameView_Previews: PreviewProvider {
    static var previews: some View {
        FirstLastNameView(firstName: .constant("First Name"), lastName: .constant("Last Name"))
    }
}
