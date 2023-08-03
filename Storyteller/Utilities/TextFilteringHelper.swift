//
//  TextFilteringHelper.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-07.
//

import Foundation
import SwiftUI

// Function for filtering a users email to fit a specific regex
func filterEmail(email: String) -> String {
    let regex = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" +
        "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
        "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" +
        "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" +
        "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
        "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
        "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
    let emailPredicate = NSPredicate(format: "SELF MATCHES[c] %@", regex)
    print(emailPredicate.evaluate(with: email))
    if emailPredicate.evaluate(with: email) {
        return ""
    }
    
    return "Invalid email"
}

// Function for parsing text to see if it fits into a variety of strings
func parseTextForCommand(_ transcript: String, _ commands: [String]) -> Bool {
    for command in commands {
        if transcript.contains(command) {
            return true
        }
    }
    
    return false
}

extension String {
    func containsWhitespaceAndNewlines() -> Bool {
        return rangeOfCharacter(from: .whitespacesAndNewlines) != nil
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif


