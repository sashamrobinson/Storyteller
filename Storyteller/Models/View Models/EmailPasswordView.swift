//
//  EmailPasswordView.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-06.
//

import SwiftUI

struct EmailPasswordView: View {
    
    @Binding var email: String
    @Binding var password: String
    
    var body: some View {
        VStack {
            Text("What's your email")
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 80)
                .padding(.horizontal)
            
            TextField(text: $email) {
                Text("Email")
                    .foregroundColor(.white.opacity(0.5))
                
            }
            .padding()
            .background(Color("#292929"))
            .cornerRadius(5)
            .padding(.horizontal)
            .padding(.bottom, 5)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(true)
            .foregroundColor(.gray)
            
            Text("What's your password")
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            SecureField(text: $password) {
                Text("Password")
                    .foregroundColor(.white.opacity(0.5))
                
            }
            .padding()
            .background(Color("#292929"))
            .cornerRadius(5)
            .padding(.horizontal)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(true)
            .foregroundColor(.gray)
            
        }
        .transition(.slide)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

struct EmailPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        EmailPasswordView(email: .constant("Email"), password: .constant("Password"))
    }
}
