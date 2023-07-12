//
//  UsernameView.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-07.
//

import SwiftUI

struct UsernameView: View {
    
    @Binding var username: String

    var body: some View {
        
        VStack {
            Text("What should we call you?")
                .foregroundColor(Color("#8A8A8A"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 80)
                .padding(.horizontal)
            
            TextField(text: $username) {
                Text("Username")
                    .foregroundColor(.white.opacity(0.5))
                
            }
            .padding()
            .background(Color("#8A8A8A"))
            .cornerRadius(5)
            .padding(.horizontal)
            .padding(.bottom, 5)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(true)
        }
    }
}

struct UsernameView_Previews: PreviewProvider {
    static var previews: some View {
        UsernameView(username: .constant("Username"))
    }
}

