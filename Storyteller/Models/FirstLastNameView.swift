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
                .foregroundColor(Color("#8A8A8A"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 80)
                .padding(.horizontal)
            
            TextField(text: $firstName) {
                Text("First Name")
                    .foregroundColor(.white.opacity(0.5))
                
            }
            .padding()
            .background(Color("#8A8A8A"))
            .cornerRadius(5)
            .padding(.horizontal)
            .padding(.bottom, 5)
            
            TextField(text: $lastName) {
                Text("Last Name")
                    .foregroundColor(.white.opacity(0.5))
                
            }
            .padding()
            .background(Color("#8A8A8A"))
            .cornerRadius(5)
            .padding(.horizontal)
            
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
