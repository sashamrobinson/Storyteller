//
//  Message.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-08.
//

import Foundation

struct Message: Identifiable {
    let id = UUID()
    let sender: String
    let content: String
}
