//
//  User.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-08.
//

import Foundation

struct User: Identifiable {
    
    let id = UUID()
    let firstName: String
    let lastName: String
    let email: String
    let birthDate: String
    let gender: String
    let username: String
    let stories: [Story]
}
