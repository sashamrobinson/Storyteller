//
//  FirebaseAuthenticationHelper.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-06.
//

import SwiftUI
import Firebase
import FirebaseStorage
import Foundation
import OpenAISwift

class FirebaseHelper: ObservableObject {
    
    // Database reference
    static let db = Firestore.firestore()
    static let storage = Storage.storage()
    
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
            "stories": [] as [Story],
            "likedStories": [] as [String],
            "genresLiked": [:] as [String: Int]
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
    
    /// Method for logging user out of Firebase Auth and Local Storage
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
            let likedStories = data["likedStories"] as? [String],
            let genresLikedData = data["genresLiked"] as? [String: Int],
            let stories = data["stories"] as? [String] else {
                print("Invalid user document data")
                completion(nil)
                return
            }
            
            // Populate genres objects
            var genresLiked: [Genre: Int] = [:]
            for (genre, numberOfLikes) in genresLikedData {
                if let genreEnum = Genre(rawValue: genre.lowercased()) {
                    genresLiked[genreEnum] = numberOfLikes
                }
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
                stories: stories,
                likedStories: likedStories,
                genresLiked: genresLiked
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
            let summary = data["summary"] as? String,
            let genresData = data["genres"] as? [String],
            let numberOfLikes = data["numberOfLikes"] as? Int,
            let storyId = data["storyId"] as? String,
            let imageUrl = data["imageUrl"] as? String,
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
            
            // Populate genres objects
            var genres: [Genre] = []
            for genreString in genresData {
                if let genreEnum = Genre(rawValue: genreString.lowercased()) {
                    genres.append(genreEnum)
                }
            }

            // Create User object
            let story = Story(
                storyId: storyId,
                author: author,
                authorUid: authorUid,
                dateCreated: dateCreated,
                title: title,
                published: published,
                conversation: chatMessages,
                summary: summary,
                genres: genres,
                numberOfLikes: numberOfLikes,
                imageUrl: imageUrl
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
                        
            // Generate summarization
            OpenAIHelper.shared.generateSummarization(chat: chatMessages, name: user!.firstName, completion: { result in
                switch result {
                case .success(let output):
                    let summary = output
                    OpenAIHelper.shared.generateTitle(chat: chatMessages, completion: { result in
                        switch result {
                        case .success(let output):
                            let title = output
                            OpenAIHelper.shared.generateAndParseGenres(chat: chatMessages) { result in
                                switch result {
                                case .success(let output):
                                    let genres = output
                                    
                                    // Convert genres to data Firebase can handle
                                    let genreData = genres.map { $0.rawValue }
                                    
                                    let data: [String: Any] = [
                                        "author": user!.firstName,
                                        "authorUid": user!.id,
                                        "dateCreated": formatDate(date),
                                        "title": title,
                                        "published": false,
                                        "conversation": conversationData,
                                        "summary": summary,
                                        "genres": genreData,
                                        "numberOfLikes": 0,
                                        "storyId": storyRef.documentID,
                                        "imageUrl": ""
                                    ]
                                    print(data)
                                    
                                    // Saving story to story document
                                    storyRef.setData(data) { error in
                                        if error != nil {
                                            print("Error updating document")
                                        } else {
                                            print("Document successfully updated")
                                        }
                                    }
                                    
                                    // Update data collection for queries
                                    for genre in genres {
                                        let genreDocRef = db.collection("Data").document(genre.rawValue)
                                        genreDocRef.updateData([
                                            "stories": FieldValue.arrayUnion([storyRef.documentID])
                                        ]) { error in
                                            if let error = error {
                                                print("Error updating genre document: \(error)")
                                            } else {
                                                print("Genre document successfully updated")
                                            }
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
                                case .failure:
                                    print("Failed generating genres")
                                }
                            }
                        case .failure:
                            print("Failed generating title")
                        }
                    })
                case .failure:
                    print("Failed generating summary")
                }
            })
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
                        stories.append(story)
                    } else {
                        print("An error occured. Story object came back nil.")
                    }
                    dispatchGroup.leave()

                }
            }
            
            dispatchGroup.notify(queue: .main) {
                // Return stories
                completion(stories)
            }
        }
    }
    
    /// Method for adding / removing a like from a story (mostly for algorithm)
    static func addOrClearLike(likedStory: Bool, userId: String, storyId: String, genres: [Genre], completion: @escaping () -> Void) {
        let storyRef = db.collection("Stories").document(storyId)
        let userRef = db.collection("Users").document(userId)

        if likedStory {
            print("adding like")
            // Add like to Story
            storyRef.updateData(["numberOfLikes": FieldValue.increment(Int64(1))])
            
            // Add like to user profile
            userRef.updateData(["likedStories": FieldValue.arrayUnion([storyId])])
            
            var updates: [String: Any] = [:]
            for genre in genres {
                updates["genresLiked.\(genre.rawValue)"] = FieldValue.increment(Int64(1))
            }
            userRef.updateData(updates)
            
            completion()
            
        } else {
            print("removing like")
            // Remove like from Story
            storyRef.updateData(["numberOfLikes": FieldValue.increment(Int64(-1))])

            // Remove like from user profile
            userRef.updateData(["likedStories": FieldValue.arrayRemove([storyId])])
            
            var updates: [String: Any] = [:]
            for genre in genres {
                updates["genresLiked.\(genre.rawValue)"] = FieldValue.increment(Int64(-1))
            }
            userRef.updateData(updates)
            
            completion()
        }
    }
    
    /// Method for updating a story when the user edits the title, summary and image
    /// - Parameters:
    ///   - storyId: a String containing the id of the story document
    ///   - newTitle: a String containing the new title the user wishes to change to
    ///   - newSummary: a String containing the new summary the user wishes to change to
    ///   - newImage: a URL containing the path to a new image in the Firebase Storage
    ///   - completion: completion handler for displaying success animation
    static func updateStory(storyId: String, newTitle: String, newSummary: String, newImage: UIImage?, completion: @escaping (Error?) -> Void) {
        // TODO: - Update genres
        // TODO: - Update complete animation
        addImageToStorage(selectedImage: newImage, storyId: storyId) { result in
            switch result {
            case .success(let imageUrl):
                let storyRef = db.collection("Stories").document(storyId)
                storyRef.updateData([
                        "title": newTitle,
                        "summary": newSummary,
                        "imageUrl": imageUrl
                ]) { error in
                    if let error = error {
                        completion(error)
                    } else {
                        completion(nil)
                    }
                }
                
            case .failure(let error):
                print("Error uploading image: \(error)")
            }
        }
    }
    
    
    /// Method for adding images to Firebase Storage
    /// - Parameters:
    ///   - selectedImage: the image that the user selected and wishes to be parsed to storage
    ///   - storyId: the story ID for interal querying to which we save the images url to
    ///   - completion: completion handler for external use
    static func addImageToStorage(selectedImage: UIImage?, storyId: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let uid = LocalStorageHelper.retrieveUser() else {
            print("Cannot get local user to add image to storage")
            completion(.failure("Cannot get local user to add image to storage" as! Error))
            return
        }
        
        let storageRef = storage.reference(withPath: uid + "+" + storyId)
        guard let imageData = selectedImage?.jpegData(compressionQuality: 0.5) else {
            print("Cannot get image data")
            completion(.failure("Cannot get image data" as! Error))
            return
        }
        storageRef.putData(imageData) { metaData, error in
            if let error = error {
                print("Error pushing image to Storage")
                completion(.failure(error))
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error retrieving download URL")
                    completion(.failure(error))
                    return
                }
                
                if let imageUrl = url?.absoluteString {
                    print("Successfully stored image with URL: \(imageUrl)")
                    completion(.success(imageUrl))
                } else {
                    completion(.failure("Cannot get absolute string of image URL" as! Error))
                }
            }
        }
    }
    
    /// Method for generating stories from a specific genre
    /// - Parameters:
    ///   - numberOfPostsToReturn: the number of Story objects to return
    ///   - genre: an enum representing which genre to query for
    ///   - currentStories: the current Story objects being displayed
    ///   - maxLoadSize: an enum representing the max amount of Storys we can handle
    ///   - completion: completion handler for external use
    static func genreSpecificStoryGenerationAlgorithm(numberOfPostsToReturn: Int, genre: Genre, currentStories: [Story], maxLoadSize: DocumentLoadSize, completion: @escaping ([Story]) -> Void) {
        
        // TODO: -- Make it so you can't see your own stories
        var storiesToReturn: [Story] = []
        let storyIdsOfCurrentStories = currentStories.map { $0.storyId }
        
        let dataRef = db.collection("Data").document(genre.rawValue)
        dataRef.getDocument { document, error in
            if error != nil {
                print("Error retrieving genre specific data stories")
                return
            }
            
            // Get random stories
            if let document = document, document.exists {
                if let storyIdArray = document.get("stories") as? [String] {
                    
                    let shuffledArray = storyIdArray.shuffled()
                    var selectedStoriesIds: [String] = []
                    
                    for index in 0...(shuffledArray.count > maxLoadSize.value ? maxLoadSize.value : shuffledArray.count - 1) {
                        if selectedStoriesIds.count > numberOfPostsToReturn {
                            break
                        }
                        
                        if storyIdsOfCurrentStories.contains(shuffledArray[index]) {
                            continue
                        }
                        
                        selectedStoriesIds.append(shuffledArray[index])
                    }
                    
                    // Get story objects
                    let dispatchGroup = DispatchGroup()
                    for storyId in selectedStoriesIds {
                        dispatchGroup.enter()
                        fetchStory(id: storyId) { story in
                            if let story = story {
                                storiesToReturn.append(story)
                            } else {
                                print("An error occured. Story object came back nil.")
                            }
                            dispatchGroup.leave()

                        }
                    }
                    
                    dispatchGroup.notify(queue: .main) {
                        completion(storiesToReturn)
                    }
         
                } else {
                    completion(storiesToReturn)
                }
            } else {
                print("Error getting document")
            }
        }
    }
    
    /// Method for generating user specific stories based on the users liked genres
    /// - Parameters:
    ///   - numberOfPostsToReturn: the number of Story objects to return for display
    ///   - currentStories: an array of the current Story objects being displayed
    ///   - completion: completion handler for external use
    static func userSpecificStoryGenerationAlgorithm(numberOfPostsToReturn: Int, currentStories: [Story], completion: @escaping ([Story]) -> Void) {
        
        var stories: [Story] = currentStories

        // Divide users likes into categories
        let id = LocalStorageHelper.retrieveUser()
        guard id != nil else {
            print("An error occured, cannot retrieve current local storage id.")
            return
        }
        
        fetchUserById(id: id!) { user in
            guard user != nil else {
                print("User came back nil")
                return
            }
            
            var totalGenresLiked: Double = 0
            for (_, numberOfLikes) in user!.genresLiked {
                totalGenresLiked += Double(numberOfLikes)
            }
            var genreIndex = 0
            func fetchNextGenre() {
                if genreIndex < user!.genresLiked.count {
                    let genre = Array(user!.genresLiked.keys)[genreIndex]
                    let numberOfLikes = user!.genresLiked[genre]!
                    let numberOfPostsToFetch = round((Double(numberOfLikes) / totalGenresLiked) * Double(numberOfPostsToReturn))
                    
                    genreSpecificStoryGenerationAlgorithm(numberOfPostsToReturn: Int(numberOfPostsToFetch), genre: genre, currentStories: stories, maxLoadSize: .light) { fetchedStories in
                        stories.append(contentsOf: fetchedStories)
                        genreIndex += 1
                        fetchNextGenre()
                    }
                } else {
                    completion(stories)
                }
            }
            
            fetchNextGenre()
                   
        }
    }
    
    // TODO: - Implement querying further than just title
    /// Method for querying for stories based on a keyword. Keyword checked against title 
    /// - Parameter query: a String representing the query in the document
    static func queryStoriesWithKeyword(query: String, completion: @escaping ([Story]) -> Void) {
        var stories: [Story] = []

        db.collection("Stories")
            .whereField("title", isGreaterThanOrEqualTo: query)
            .whereField("title", isLessThanOrEqualTo: query + "\u{f8ff}")
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error getting documents: \(error)")
                    completion(stories)
                    return
                }
                
                guard let querySnapshot = querySnapshot else {
                    print("Empty query snapshot")
                    completion(stories)
                    return
                }
                
                for document in querySnapshot.documents {
                    let data = document.data()
                    
                    guard let author = data["author"] as? String,
                    let dateCreated = data["dateCreated"] as? String,
                    let title = data["title"] as? String,
                    let authorUid = data["authorUid"] as? String,
                    let published = data["published"] as? Bool,
                    let summary = data["summary"] as? String,
                    let genresData = data["genres"] as? [String],
                    let numberOfLikes = data["numberOfLikes"] as? Int,
                    let storyId = data["storyId"] as? String,
                    let imageUrl = data["imageUrl"] as? String,
                    let conversationData = data["conversation"] as? [[String: Any]] else {
                        print("Invalid user document data")
                        completion(stories)
                        return
                    }
                    
                    // Populate chat message objects
                    var chatMessages: [ChatMessage] = []
                    for chatData in conversationData {
                        if let role = chatData["role"] as? String,
                           let content = chatData["content"] as? String {
                               let chatMessage = ChatMessage(role: role == "user" ? .user : .assistant, content:    content)
                               chatMessages.append(chatMessage)
                        }
                    }
                   
                    // Populate genres objects
                    var genres: [Genre] = []
                    for genreString in genresData {
                        if let genreEnum = Genre(rawValue: genreString.lowercased()) {
                            genres.append(genreEnum)
                        }
                    }
   
                    // Create User object
                    
                    let story = Story(
                       storyId: storyId,
                       author: author,
                       authorUid: authorUid,
                       dateCreated: dateCreated,
                       title: title,
                       published: published,
                       conversation: chatMessages,
                       summary: summary,
                       genres: genres,
                       numberOfLikes: numberOfLikes,
                       imageUrl: imageUrl
                    )
                    stories.append(story)
                }
                
                completion(stories)
            }
    }
}
