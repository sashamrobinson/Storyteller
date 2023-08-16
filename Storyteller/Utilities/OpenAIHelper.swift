//
//  OpenAIHelper.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-20.
//

import Foundation
import OpenAISwift

final class OpenAIHelper {
    
    static let shared = OpenAIHelper()
    private var client: OpenAISwift?
    
    private init() {}
    
    public func setup() {
        self.client = OpenAISwift(authToken: SensitiveInformation.API_KEY)
    }
    
    /// Method for getting a response from GPT Model to continue conversation when provided an array of ChatMessage objects representing a conversation between the user and Storyteller
    /// - Parameters:
    ///   - chat: array of ChatMessage objects representing the conversation
    ///   - completion: completion handler for external use of GPT Model response
    public func getResponse(chat: [ChatMessage], completion: @escaping (Result<String, Error>) -> Void) {
        var chatCopy = chat
        if chatCopy.count > Constants.MAX_CHAT_MESSAGES {
            print("Chat too long")
            chatCopy.removeFirst(chatCopy.count - Constants.MAX_CHAT_MESSAGES)
        }
        
        // Add system context before sending chat
        chatCopy.insert(ChatMessage(role: .system, content: Constants.INTRODUCTION_PROMPT), at: 0)
        
        client?.sendChat(with: chatCopy, model: .chat(.chatgpt), maxTokens: Constants.MAX_TOKENS_FOR_CHAT, completionHandler: { result in
            switch result {
            case .success(let model):
                let output = model.choices?.first?.message.content ?? ""
                completion(.success(output))
                
            case .failure(let error):
                print("OpenAI Failure Case: Response")
                completion(.failure(error))
            }
        })
    }
    
    /// Method for generating a summarization of a conversation provided as an array of ChatMessage objects.
    /// - Parameters:
    ///   - chat: array of ChatMessage objects representing the conversation
    ///   - username: the username of the user creating the story
    ///   - completion: completion handler for external use of GPT Model response
    public func generateSummarization(chat: [ChatMessage], name: String, completion: @escaping (Result<String, Error>) -> Void) {
        var chatCopy = chat
        
        // Add system context before sending chat
        chatCopy.insert(ChatMessage(role: .system, content: Constants.SUMMARIZATION_PROMPT + " You were speaking with " + name), at: 0)
        
        client?.sendChat(with: chatCopy, model: .chat(.chatgpt), maxTokens: Constants.MAX_TOKENS_FOR_SUMMARY, completionHandler: { result in
            switch result {
            case .success(let model):
                let output = model.choices?.first?.message.content ?? ""
                print(output)
                completion(.success(output))
                
            case .failure(let error):
                print("OpenAI Failure Case: Summary")
                completion(.failure(error))
            }
        })
    }
    
    /// Method for generating a summarization of a conversation provided as an array of ChatMessage objects.
    /// - Parameters:
    ///   - chat: array of ChatMessage objects representing the conversation
    ///   - completion: completion handler for external use of GPT Model response
    public func generateTitle(chat: [ChatMessage], completion: @escaping (Result<String, Error>) -> Void) {
        var chatCopy = chat
        
        // Add system context before sending chat
        chatCopy.insert(ChatMessage(role: .system, content: Constants.TITLE_PROMPT), at: 0)
        client?.sendChat(with: chatCopy, model: .chat(.chatgpt), maxTokens: Constants.MAX_TOKENS_FOR_TITLE, completionHandler: { result in
            switch result {
            case .success(let model):
                let output = model.choices?.first?.message.content ?? ""
                print(output)
                completion(.success(output))
                
            case .failure(let error):
                print("OpenAI Failure Case: Title")
                completion(.failure(error))
            }
        })
    }
    
    /// Method for generating all applicable genres given an array of ChatMessage objects describing a conversation and then parsing the response that the GPT model provides into an array of Genre enums that can be applied to a story
    /// - Parameters:
    ///   - chat: an array of ChatMessage objects describing a conversation
    ///   - completion: completion handler for external usage of Genres
    public func generateAndParseGenres(chat: [ChatMessage], completion: @escaping (Result<[Genre], Error>) -> Void) {
        var chatCopy = chat
        
        // Add system context before sending chat
        chatCopy.insert(ChatMessage(role: .system, content: Constants.GENRES_PROMPT), at: 0)
        client?.sendChat(with: chatCopy, model: .chat(.chatgpt), maxTokens: Constants.MAX_TOKENS_FOR_GENRES, completionHandler: { result in
            switch result {
            case .success(let model):
                let output = model.choices?.first?.message.content ?? ""
                print(output)
                
                // Parse output to generate array
                var genres: [Genre] = extractGenres(output)
                print(genres)
                completion(.success(genres))
                
            case .failure(let error):
                print("OpenAI Failure Case: Genres")
                completion(.failure(error))
            }
        })
    }
}
