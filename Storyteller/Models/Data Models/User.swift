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
    var username: String = ""
    var stories: [String] = []
    var likedStories: [String] = []
    var genresLiked: [Genre: Int] = [:]
    
    init(id: String, firstName: String, lastName: String, email: String, username: String, stories: [String], likedStories: [String], genresLiked: [Genre: Int]) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.username = username
        self.stories = stories
        self.likedStories = likedStories
        self.genresLiked = genresLiked
    }
}
