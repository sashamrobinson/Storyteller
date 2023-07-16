//
//  LocalStorageHelper.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-15.
//

import Foundation

class LocalStorageHelper {
    
        // Method for saving user to local storage
        static func saveUser(userId: String) {
            UserDefaults.standard.set(userId, forKey: Constants.userKey)
        }
        
        // Method for retrieving user defaults
        static func retrieveUser() -> String? {
            return UserDefaults.standard.string(forKey: Constants.userKey)
        }
        
        // Method for clearing user from local storage
        static func clearUser() {
            UserDefaults.standard.removeObject(forKey: Constants.userKey)
        }
}
