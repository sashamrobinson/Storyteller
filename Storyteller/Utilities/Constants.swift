//
//  Constants.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-15.
//

import Foundation

class Constants {
    
    // Design
    static let TITLE_FONT_SIZE = 50.0
    static let HEADER_FONT_SIZE = 30.0
    static let REGULAR_FONT_SIZE = 20.0
    static let SUBTEXT_FONT_SIZE = 15.0
    static let DETAIL_FONT_SIZE = 12.0
    
    // User Key
    static let userKey = "storedUserObject"
    
    // Specific Queries
    static let BEGIN_SPEAKING_STORYTELLER = ["hey storyteller", "hi storyteller", "hello storyteller", "storyteller", "story teller", "story tell her", "sorry taylor", "three dollar", "storytelling"]
    static let BEGIN_STORY_STRINGS = ["can i tell you a story", "let me tell you a story", "tell you a story", "can i tell you the story", "can you tell your story", "test"]
    static let END_STORY_STRINGS = ["end story", "end of story", "the end", "that is the end", "that's the end", "that is the end of my story", "and of story", "and story"]
    static let AFFIRMATIVE_STRINGS = ["yes", "yeah", "sure", "absolutely", "definitely", "certainly", "indeed", "OK", "okay", "right", "of course", "affirmative", "positive", "agreed", "true", "correct", "affirm", "confirm", "confirmative", "yep", "yup", "aye", "exactly", "totally", "affirmation"]
    static let NEGATING_STRINGS = ["no", "nope", "not really", "never", "negative", "denied", "reject", "refuse", "decline", "disagree", "false", "incorrect", "untrue", "unconfirmed", "unverified", "nay", "nah"]
    
    // OpenAI
    static let MAX_TOKENS_FOR_CHAT = 60
    static let MAX_TOKENS_FOR_SUMMARY = 300 // TODO: - Very this depending on length of conversation
    static let MAX_TOKENS_FOR_TITLE = 20
    static let MAX_TOKENS_FOR_GENRES = 100
    static let MAX_CHAT_MESSAGES = 8
    static let INTRODUCTION_PROMPT = "You are having a friendly conversation and the user is telling a story. Your job is to ask the user short questions about their story and interject with small comments. Avoid low level questions that require simple yes/no answers; Instead, focus on asking questions about details to enhance the story. Do not answer questions unrelated to their story. Try to stay on the topic of their conversation."
    static let SUMMARIZATION_PROMPT = "In a previous conversation, you were a biographer listening and asking questions to another person as they told you a story. Now, your job is to retell and summarize that conversation from your perspective. Avoid overelaborating on things. Use conversational language. Summarize the conversation as if it was a story."
    static let TITLE_PROMPT = "In a previous conversation, you were a biographer listening and asking questions to another person as they told you a story. Now, your job is to create an appropriate title based on what the user said for that story. Avoid cliches and try to keep it concise, appealing and allow for a little bit of creativity. Do not add any extra text or quotation marks, just provide the title alone. Do not put quotations or title: ."
    static let GENRES_PROMPT = "In a previous conversation, you were a biographer listening and asking questions to another person as they told you a story. Now, given a list of several genres, determine which genres you believe are applicable to the story. Return only the genres you believe applicable in a comma-seperated list with no additional text. The genres are: heartwarming, sad, scary, adventure, romance, funny, historical, struggle, love, slice of life, exciting and wow."
    
    // Conversation Strings
    static let INTRODUCTION_STRING = "Whenever you're ready, I'd love to hear your story."
    static let END_STORY_CONFIRMATION = "Are you sure you're finished?"
    static let APOLOGIZE_CONTINUE_STORY = "Oh, I'm sorry. Please continue your story."
    static let APOLOGIZE_DIDNT_HEAR = "I'm sorry, I didn't get that. Can you please repeat?"
    static let PUBLICIZE_CONFIRMATION = "Great. Would you also like to publicize your story so others can see it?"
    static let FINISHED_STORY = "Thanks for telling me your story. Whenever you want to talk again I'm always here. Bye"
    static let WELCOME_PROMPT = "Welcome to Storyteller. It's great to get to meet you. In order for me to be able to hear your stories, I need to explain some commands to you."
    static let WELCOME_PROMPT_2 = "To get my attention, you can say, Hey Storyteller. To begin telling me your story, you can say, Let me tell you a story. And once you are done your story, to let me know, you can say, The end."
    static let WELCOME_PROMPT_3 = "Now that you know how everything works, to get to know each other better, I'd like you to tell me a story. Are you ready to create your first story?"
    
    // Speech
    // TODO: Different timing for conversation delay and calling AI
    static let SPEECH_DELAY_TIME_IN_SECONDS = 1.5
    
}
