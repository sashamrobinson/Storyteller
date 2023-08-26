//
//  BirthDateGenderView.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-06.
//

import SwiftUI
import Combine

struct BirthDateGenderView: View {
    
    private let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    @State private var placeholderMonth: String = "Month"
    @Binding var month: String
    @Binding var day: String
    @Binding var year: String
    @Binding var gender: String
    
    var body: some View {
        VStack {
            Text("What's your date of birth?")
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 80)
                .padding(.horizontal)
            
            HStack {
                Menu(placeholderMonth) {
                    ForEach(months, id: \.self) { month in
                        Button(action: {
                            self.month = month
                            self.placeholderMonth = month
                            
                        }) {
                            Text(month)
                        }
                    }
                }
                .padding()
                .frame(width: UIScreen.screenWidth / 2.5)
                .background(Color("#292929"))
                .foregroundColor(.white)
                .cornerRadius(5)
                .padding(.leading)
                
                TextField(text: $day) {
                    Text("DD")
                        .foregroundColor(.gray)
                }
                .padding()
                .frame(width: UIScreen.screenWidth / 5)
                .multilineTextAlignment(.center)
                .onReceive(Just($day)) { _ in limitText(2, 0)}
                .keyboardType(.decimalPad)
                .background(Color("#292929"))
                .cornerRadius(5)
                .foregroundColor(.white)
                
                TextField(text: $year) {
                    Text("YYYY")
                        .foregroundColor(.gray)
                }
                .padding()
                .multilineTextAlignment(.center)
                .onReceive(Just($year)) { _ in limitText(4, 1)}
                .keyboardType(.decimalPad)
                .background(Color("#292929"))
                .cornerRadius(5)
                .padding(.trailing)
                .foregroundColor(.white)
            }
            
            Text("What's your gender")
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .foregroundColor(.gray)
            
            TextField(text: $gender) {
                Text("Gender")
                    .foregroundColor(.gray)
                
            }
            .padding()
            .background(Color("#292929"))
            .cornerRadius(5)
            .padding(.horizontal)
            .foregroundColor(.white)
            
        }
        .transition(.slide)
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    func limitText(_ upper: Int, _ variable: Int) {
        if (variable == 0) {
            if day.count > upper {
                day = String(day.prefix(upper))
            }
        }
        else if (variable == 1) {
            if year.count > upper {
                year = String(year.prefix(upper))
            }
        }
    }
}

struct BirthDateGenderView_Previews: PreviewProvider {
    static var previews: some View {
        BirthDateGenderView(month: .constant("Month"), day: .constant("DD"), year: .constant("YYYY"), gender: .constant("Gender"))
    }
}
