//
//  FirebaseAuthenticationHelper.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-07-06.
//

import Firebase
import Foundation

class FirebaseHelper: ObservableObject {
    
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
        
        let db = Firestore.firestore()
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
}
