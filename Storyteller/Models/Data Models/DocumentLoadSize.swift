//
//  DocumentLoadSize.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-08-19.
//

import Foundation

/// Enum for measuring the amount of documents to search through. A greater value indicates a greater accuracy in search results per the user, but a longer fetch time.
/// - Cases:
///   - light: used for quick instant load, such as when the user creates a view
///   - medium: used after a light case load to download more stories
///   - heavy: used after a medium case load to download the greatest amount of stories. Designed for repeated use after being called
enum DocumentLoadSize: Int {
    case light = 100
    case medium = 200
    case heavy = 500
    
    var value: Int {
        return self.rawValue
    }
}
