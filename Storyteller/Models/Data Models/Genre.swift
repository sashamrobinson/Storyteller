//
//  Genre.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-08-15.
//

import Foundation

/// Enum to represent different types of genres for a story
enum Genre: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    case heartwarming
    case sad
    case scary
    case adventure
    case romance
    case funny
    case historical
    case struggle
    case love
    case sliceoflife
    case exciting
    case wow
    
    var color: String {
        switch self {
            case .heartwarming: return "#FFC34F"
            case .sad: return "#72CCFF"
            case .scary: return "#B982FF"
            case .adventure: return "#F49661"
            case .romance: return "#F96D6D"
            case .funny: return "#B3FD78"
            case .historical: return "#7977F5"
            case .struggle: return "#7C5C52"
            case .love: return "#FB3333"
            case .sliceoflife: return "#F973EB"
            case .exciting: return "#F5D52B"
            case .wow: return "#5381F4"
        }
    }
    
    // TODO: - Change descriptions, generic ones right now
    var description: String {
        switch self {
            case .heartwarming:
                return "Feel the warmth and compassion as characters overcome challenges, bringing smiles and uplifting moments."
            case .sad:
                return "Explore the depths of human emotions, delving into heart-wrenching tales that touch the soul."
            case .scary:
                return "Experience spine-chilling thrills and terror as you journey into the unknown and face the supernatural."
            case .adventure:
                return "Embark on exciting quests and expeditions, encountering danger, discovery, and heroic triumphs."
            case .romance:
                return "Delve into passionate relationships, capturing the essence of love, desire, and emotional connection."
            case .funny:
                return "Laugh out loud at humorous tales filled with witty banter, comical situations, and lighthearted fun."
            case .historical:
                return "Travel back in time to different eras, reliving historical events and societal transformations."
            case .struggle:
                return "Witness characters battling against adversity, showcasing strength and resilience in the face of challenges."
            case .love:
                return "Celebrate the power of love in its various forms, from familial bonds to romantic connections."
            case .sliceoflife:
                return "Capture everyday moments, exploring the ordinary lives of characters and their personal growth."
            case .exciting:
                return "Experience heart-pounding excitement and action, with fast-paced plots and daring feats."
            case .wow:
                return "Be amazed by the extraordinary and fantastical, where the impossible becomes reality."
        }
    }
    
    var name: String {
        switch self {
            case .heartwarming:
                return "Heartwarming"
            case .sad:
                return "Sad"
            case .scary:
                return "Scary"
            case .adventure:
                return "Adventure"
            case .romance:
                return "Romance"
            case .funny:
                return "Funny"
            case .historical:
                return "Historical"
            case .struggle:
                return "Struggle"
            case .love:
                return "Love"
            case .sliceoflife:
                return "Slice of Life"
            case .exciting:
                return "Exciting"
            case .wow:
                return "Wow"
        }
    }
}
