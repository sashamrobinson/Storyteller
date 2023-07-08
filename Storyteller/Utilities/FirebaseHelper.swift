//
//  FirebaseAuthenticationHelper.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-06.
//

import Firebase
import Foundation

// TODO: - Change print error statements to Alerts
// Method for creating a user in the Auth database
func createUserInAuth(email: String, password: String) {
    Auth.auth().createUser(withEmail: email, password: password) { result, error in
        if error != nil {
            print(error!.localizedDescription)
        }
        
    }
}

// Method for logging in a user to the Auth database
func login(email: String, password: String, completion: @escaping (Error?) -> Void) {
    Auth.auth().signIn(withEmail: email, password: password) { result, error in
        completion(error)
    }
}

