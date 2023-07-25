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
    
    // OpenAI AI Constants
    static let MAX_TOKENS = 60
    static let MAX_CHAT_MESSAGES = 8
    static let INTRODUCTION_PROMPT = "You are having a friendly conversation and the user is telling a story. Your job is to ask the user short questions about their story and interject with small comments. Do not answer questions unrelated to their story. Try to stay on the topic of their conversation."
    static let INTRODUCTION_STRING = "Hello, I'm Storyteller. Tap to begin speaking."
    
}
