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
    
    private init() {}
    
    private var client: OpenAISwift?
    
    public func setup() {
        self.client = OpenAISwift(authToken: SensitiveInformation.apiKEY)
    }
    
    public func getResponse(input: String, completion: @escaping (Result<String, Error>) -> Void) {
        client?.sendCompletion(with: input, maxTokens: 50, completionHandler: { result in
            switch result {
            case .success(let model):
                let output = model.choices?.first?.text ?? ""
                completion(.success(output))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
