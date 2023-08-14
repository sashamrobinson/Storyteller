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
    
    /// Method for generating a summarization of a conversation provided as an array of ChatMessage objects.
    /// - Parameters:
    ///   - chat: array of ChatMessage objects representing the conversation
    ///   - completion: completion handler for external use of GPT Model response
    public func generateSummarization(chat: [ChatMessage], completion: @escaping (Result<String, Error>) -> Void) {
        
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
        
        client?.sendChat(with: chatCopy, model: .chat(.chatgpt), maxTokens: Constants.MAX_TOKENS, completionHandler: { result in
            switch result {
            case .success(let model):
                let output = model.choices?.first?.message.content ?? ""
                completion(.success(output))
                
            case .failure(let error):
                print("OpenAI Failure Case")
                completion(.failure(error))
            }
        })

    }
}
