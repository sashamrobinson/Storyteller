//
//  Story.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-08.
//

import Foundation
import OpenAISwift

struct Story: Identifiable {
    let id = UUID()
    let author: String
    let authorUid: String
    let dateCreated: String
    let title: String
    let published: Bool
    let conversation: [ChatMessage]
}
