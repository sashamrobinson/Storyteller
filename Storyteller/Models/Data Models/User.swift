//
//  User.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-08.
//

import Foundation

class User: Identifiable, ObservableObject {
    
    var id: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var birthDate: String = ""
    var gender: String = ""
    var username: String = ""
    var stories: [Story] = []
    
    init(id: String, firstName: String, lastName: String, email: String, birthDate: String, gender: String, username: String, stories: [Story]) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.birthDate = birthDate
        self.gender = gender
        self.username = username
        self.stories = stories
    }
}
