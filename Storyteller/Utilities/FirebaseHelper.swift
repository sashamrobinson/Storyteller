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
            completion(error)
        }
    }

    // Method for creating a user in the Auth database
    static func createUserInAuth(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            }
            
        }
    }

    // Method for creating user in database
    static func createUserInDatabase(user: User) {
        
        let db = Firestore.firestore()
        let ref = db.collection("Users").document(user.id.description)
        ref.setData([
            "id": user.id.description,
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
            }
        }
        
        
        
        
        
    }
}

//ref.getDocuments { snapshot, error in
//
//    guard error == nil else {
//        print(error!.localizedDescription)
//        return
//    }
//
//    if let snapshot = snapshot {
//        for document in snapshot.documents {
//            let data = document.data()
//
//            let id = data["id"] as? String ?? ""
//            let breed = data["breed"] as? String ?? ""
//
//            let dog = Dog(id: id, breed: breed)
//            self.dogs.append(dog)
//        }
//    }
//
//}
