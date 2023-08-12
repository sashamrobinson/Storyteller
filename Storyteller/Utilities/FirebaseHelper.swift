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
    /// Method for logging users into Firebase Auth
    /// - Parameters:
    ///   - email: a String with the users email
    ///   - password: a String containing the users password
    ///   - completion: completion handler on the event that the function returns an error
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
    
    /// Method for creating the user document in the Users collection and populating it with the passed in User object
    /// - Parameter user: a User object representing a User in the Firebase database
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
    
    
    /// Method for fetching user information from Firebase document and then packaging it into a User object
    /// - Parameters:
    ///   - id: a String representing the users document id
    ///   - completion: completion handler that returns the User object // error for external use
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
            let stories = data["stories"] as? [String] else {
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
    
    /// Method for fetching an individual story from a document id
    /// - Parameters:
    ///   - id: a String representing the document id
    ///   - completion: completion handler that returns the Story object // error for external use
    static func fetchStory(id: String, completion: @escaping (Story?) -> Void) {
        let storyRef = db.collection("Stories").document(id)
        storyRef.getDocument { document, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            
            // All data is valid
            guard let document = document,
            document.exists,
            let data = document.data(),
            let author = data["author"] as? String,
            let dateCreated = data["dateCreated"] as? String,
            let title = data["title"] as? String,
            let authorUid = data["authorUid"] as? String,
            let published = data["published"] as? Bool,
            let conversationData = data["conversation"] as? [[String: Any]] else {
                print("Invalid user document data")
                completion(nil)
                return
            }
            
            // Populate chat message objects
            var chatMessages: [ChatMessage] = []
            for chatData in conversationData {
                if let role = chatData["role"] as? String,
                   let content = chatData["content"] as? String {
                        let chatMessage = ChatMessage(role: role == "user" ? .user : .assistant, content: content)
                        chatMessages.append(chatMessage)
                }
            }

            // Create User object
            let story = Story(
                author: author,
                authorUid: authorUid,
                dateCreated: dateCreated,
                title: title,
                published: published,
                conversation: chatMessages
            )
            
            completion(story)
        }
    }
    
    /// Method for saving a story the user has created to its own document and the ID to the users document
    /// - Parameter chatMessages: an array of ChatMessage objects from OpenAI representing the messages and roles in the conversation
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
            let date = Date() // Current date
            let conversationData: [[String: Any]] = chatMessages.map { chatMessage in
                return [
                    "role": chatMessage.role.rawValue,
                    "content": chatMessage.content
                ]
            }
            let data: [String: Any] = [
                "author": user!.firstName,
                "authorUid": user!.id,
                "dateCreated": formatDate(date),
                "title": "New Story",
                "published": false,
                "conversation": conversationData,
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
                "stories": FieldValue.arrayUnion([storyRef.documentID])
            ]) { error in
                if error != nil {
                    print("Error updating document")
                } else {
                    print("Document successfully updated")
                }
            }
        }
    }
    
    /// Method for fetching all story documents, parsing them into an array and then returning for display
    /// - Parameter id: a String representing the user document ID found in the Firebase database
    static func fetchStoriesFromUserDocument(id: String, completion: @escaping ([Story]?) -> Void) {
        fetchUserById(id: id) { user in
            guard user != nil else {
                print("An error occured. User came back nil.")
                completion(nil)
                return
            }
            
            let storyIds = user!.stories
            var stories: [Story] = []
            let dispatchGroup = DispatchGroup()
            
            for storyId in storyIds {
                dispatchGroup.enter()
                fetchStory(id: storyId) { story in
                    if let story = story {
                        print("Adding story to stories array")
                        stories.append(story)
                    } else {
                        print("An error occured. Story object came back nil.")
                    }
                    dispatchGroup.leave()

                }
            }
            
            dispatchGroup.notify(queue: .main) {
                // Return stories
                print(stories)
                completion(stories)
            }
        }
    }
}
