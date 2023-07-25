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
                completion(.failure(error))
            }
        })

    }
}
