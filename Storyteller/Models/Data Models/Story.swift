//
//  Story.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-08.
//

import Foundation

struct Story: Identifiable {
    
    let id = UUID()
    let createdBy: String
    let dateCreated: String
    let publicized: Bool
    let story: [Message]
    
}
