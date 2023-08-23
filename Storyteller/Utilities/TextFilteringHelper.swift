//
//  TextFilteringHelper.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-07.
//

import Foundation
import SwiftUI

/// Function for filtering out emails that do not fit a specific regex
/// - Parameter email: a String representing the users email
/// - Returns: a String that essentially represents if the given email satisfies the regex
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

/// Function for parsing text to see if a certain command is in it
/// - Parameters:
///   - transcript: a String of information containing what the user said
///   - commands: an array of String commands to check for in the transcript
/// - Returns: a Boolean representing if a specific command was found
func parseTextForCommand(_ transcript: String, _ commands: [String]) -> Bool {
    for command in commands {
        if transcript.contains(command) {
            return true
        }
    }
    
    return false
}

/// Function for formatting date to MMM d, yyyy
/// - Parameter date: a Date object containing a specific time (usually the current)
/// - Returns: a String of the format MMM d, yyyy that represents the inputted date
func formatDate(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM d, yyyy"
    return dateFormatter.string(from: date)
}

/// Function for generating an array of genres given an input String of comma-seperated genre titles from OpenAI
/// - Parameter input: a comma-seperated, GPT generated String that says which genres it believes a story to be in
/// - Returns: an array of Genre enums that were found within the input
func extractGenres(_ input: String) -> [Genre] {
    let allGenres = Genre.allCases
    let inputGenres = input.lowercased().replacingOccurrences(of: " ", with: "").split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
    
    var selectedGenres: [Genre] = []
    
    for inputGenre in inputGenres {
        if let matchedGenre = allGenres.first(where: {
            $0.rawValue.lowercased() == inputGenre || inputGenre.contains($0.rawValue.lowercased())
        }) {
            selectedGenres.append(matchedGenre)
        }
    }
    
    return selectedGenres
}

/// Function for generating a random verification code for verifying user email
/// - Parameter length: the length of the code
/// - Returns: the code in a String
func generateRandomCharacterVerificationCode(length: Int) -> String {
    let characters: [String] = ["ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"]
    var code: String = ""
    for _ in 0...(length - 1) {
        let randomInt = Int.random(in: 0...(characters.count - 1))
        code.append(characters[randomInt])
    }
    
    return code
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
