//
//  FirebaseAuthenticationHelper.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-06.
//

import SwiftUI
import Firebase
import Foundation
import OpenAISwift

class FirebaseHelper: ObservableObject {
    
    // Database reference
    static let db = Firestore.firestore()
    
    // TODO: - Change print error statements to Alerts
    // Method for logging in a user to the Auth database
    static func login(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let user = result?.user {
                LocalStorageHelper.saveUser(userId: user.uid)
            }
            
            completion(error)
        }
    }

    // Method for creating a user in the Auth database
    static func createUserInAuth(email: String, password: String, user: User) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            FirebaseHelper.createUserInDatabase(user: user)
            
        }
    }

    // Method for creating user in database
    static func createUserInDatabase(user: User) {
        
        guard let authUser = Auth.auth().currentUser else {
            print("Cannot get current user from Auth when trying to create user in database.")
            return
        }
        
        let ref = db.collection("Users").document(authUser.uid)
        
        ref.setData([
            "id": authUser.uid,
            "firstName": user.firstName,
            "lastName": user.lastName,
            "email": user.email,
            "birthDate": user.birthDate,
            "gender": user.gender,
            "username": user.username,
            "stories": [] as [Story]
        ]) { error in
            if let error = error {
                print(error.localizedDescription)
            }
            else {
                print("User successfully created and stored to database")
                
                // Save logged in user to Local Storage
                LocalStorageHelper.saveUser(userId: authUser.uid)
            }
        }
    }
    
    // Method for logging user out
    static func logoutUser() {
        do {
            
            // Log user out of Auth
            try Auth.auth().signOut()
            
            // Log user out of Local Storage
            LocalStorageHelper.clearUser()
            
        }
        catch {
            // TODO: - Error alert
            print("Error signing out")
        }
    }
    
    // Method for fetching user object information by id
    static func fetchUserById(id: String, completion: @escaping (User?) -> Void) {
        
        let userRef = db.collection("Users").document(id)
        
        userRef.getDocument { document, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            
        // All data is valid
        guard let document = document,
        document.exists,
        let data = document.data(),
        let id = data["id"] as? String,
        let firstName = data["firstName"] as? String,
        let lastName = data["lastName"] as? String,
        let email = data["email"] as? String,
        let birthDate = data["birthDate"] as? String,
        let gender = data["gender"] as? String,
        let username = data["username"] as? String,
        let stories = data["stories"] as? [Story] else {
            print("Invalid user document data")
            completion(nil)
            return
        }

        // Create User object
        let user = User(
            id: id,
            firstName: firstName,
            lastName: lastName,
            email: email,
            birthDate: birthDate,
            gender: gender,
            username: username,
            stories: stories
        )
        
        completion(user)
        }
    }
    
    // Method for storing a story in database
    static func saveStoryToDocumentAndUser(chatMessages: [ChatMessage]) {
        let id = LocalStorageHelper.retrieveUser()
        guard id != nil else {
            print("An error occured, cannot retrieve current local storage id.")
            return
        }
        
        fetchUserById(id: id!) { user in
            guard id != nil else {
                print("An error occured, cannot retrieve Firebase user.")
                return
            }
            
            let storyRef = db.collection("Stories").document()
            let date = Date()
            let data: [String: Any] = [
                "author": user!.firstName,
                "dateCreated": formatDate(date),
                "conversation": chatMessages,
            ]
            
            // Saving story to story document
            storyRef.setData(data) { error in
                if error != nil {
                    print("Error updating document")
                } else {
                    print("Document successfully updated")
                }
            }
            
            // Saving story to users story ids
            let userRef = db.collection("Users").document(id!)
            userRef.updateData([
                "stories": FieldValue.arrayUnion([id!])
            ]) { error in
                if error != nil {
                    print("Error updating document")
                } else {
                    print("Document successfully updated")
                }
            }
        }
    }
}
