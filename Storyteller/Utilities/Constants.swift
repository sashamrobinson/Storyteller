//
//  Constants.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-15.
//

import Foundation

class Constants {
    
    // Design
    static let HEADER_FONT_SIZE = 30.0
    static let REGULAR_FONT_SIZE = 20.0
    static let SUBTEXT_FONT_SIZE = 15.0
    
    // User Key
    static let userKey = "storedUserObject"
    
    // Specific Queries
    static let BEGIN_SPEAKING_STORYTELLER = ["hey storyteller", "hi storyteller", "hello storyteller", "storyteller", "story teller", "story tell her"]
    static let BEGIN_STORY_STRINGS = ["can i tell you a story", "let me tell you a story", "tell you a story", "can i tell you the story", "can you tell your story", "test"]
    static let END_STORY_STRINGS = ["end story", "end of story", "the end", "that is the end", "that's the end", "that is the end of my story"]
    static let AFFIRMATIVE_STRINGS = ["yes", "yeah", "sure", "absolutely", "definitely", "certainly", "indeed", "OK", "okay", "right", "of course", "affirmative", "positive", "agreed", "true", "correct", "affirm", "confirm", "confirmative", "yep", "yup", "aye", "exactly", "totally", "affirmation"]
    static let NEGATING_STRINGS = ["no", "nope", "not really", "never", "negative", "denied", "reject", "refuse", "decline", "disagree", "false", "incorrect", "untrue", "unconfirmed", "unverified", "nay", "nah"]
    
    // OpenAI
    static let MAX_TOKENS_FOR_CHAT = 60
    static let MAX_TOKENS_FOR_SUMMARY = 800 // TODO: - Very this depending on length of conversation
    static let MAX_TOKENS_FOR_TITLE = 20
    static let MAX_TOKENS_FOR_GENRES = 100
    static let MAX_CHAT_MESSAGES = 8
    static let INTRODUCTION_PROMPT = "You are having a friendly conversation and the user is telling a story. Your job is to ask the user short questions about their story and interject with small comments. Do not answer questions unrelated to their story. Try to stay on the topic of their conversation."
    static let SUMMARIZATION_PROMPT = "In a previous conversation, you were a biographer listening and asking questions to another person as they told you a story. Now, your job is to retell and summarize that conversation from your perspective. Avoid overelaborating on things. Use conversational language. Summarize the conversation as if it was a story."
    static let TITLE_PROMPT = "In a previous conversation, you were a biographer listening and asking questions to another person as they told you a story. Now, your job is to create an appropriate title based on what the user said for that story. Avoid cliches and try to keep it concise, appealing and allow for a little bit of creativity. Do not add any extra text or quotation marks, just provide the title alone."
    static let GENRES_PROMPT = "In a previous conversation, you were a biographer listening and asking questions to another person as they told you a story. Now, given a list of several genres, determine which genres you believe are applicable to the story. Return only the genres you believe applicable in a comma-seperated list with no additional text. The genres are: heartwarming, sad, scary, adventure, romance, funny, historical, struggle, love, slice of life, exciting and wow."
    
    // Conversation Strings
    static let INTRODUCTION_STRING = "Whenever you're ready, I'd love to hear your story."
    static let END_STORY_CONFIRMATION = "Are you sure you're finished?"
    static let APOLOGIZE_CONTINUE_STORY = "Oh, I'm sorry. Please continue your story."
    static let PUBLICIZE_CONFIRMATION = "Great. Would you also like to publicize your story so others can see it? You can always change this later on."
    static let FINISHED_STORY = "Thanks for telling me your story. Whenever you want to talk again I'm always here. Bye"
    
    // Speech
    // TODO: Different timing for conversation delay and calling AI
    static let SPEECH_DELAY_TIME_IN_SECONDS = 1.5
    
}
