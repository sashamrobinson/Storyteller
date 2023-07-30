//
//  Constants.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-15.
//

import Foundation

class Constants {
    
    // User key
    static let userKey = "storedUserObject"
    
    // Specific query commands
    static let BEGIN_SPEAKING_STORYTELLER = ["hey storyteller", "hi storyteller", "hello storyteller", "storyteller"]
    static let BEGIN_STORY_STRINGS = ["can i tell you a story", "let me tell you a story", "tell you a story", ]
    
    // OpenAI
    static let MAX_TOKENS = 60
    static let MAX_CHAT_MESSAGES = 8
    static let INTRODUCTION_PROMPT = "You are having a friendly conversation and the user is telling a story. Your job is to ask the user short questions about their story and interject with small comments. Do not answer questions unrelated to their story. Try to stay on the topic of their conversation."
    static let INTRODUCTION_STRING = "I'm Storyteller. Let me hear your story."
    
}
