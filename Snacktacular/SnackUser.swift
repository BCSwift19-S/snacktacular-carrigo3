//
//  SnackUser.swift
//  Snacktacular
//
//  Created by Cameron Arrigo on 4/22/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import Foundation
import Firebase

class SnackUser {
    var email: String
    var displayName: String
    var photoURL: String
    var userSince: TimeInterval
    var documentID: String
    
    var dictionary: [String: Any] {
        return ["email": email, "displayName": displayName, "photoURL": photoURL, "userSince": userSince, "docummentID": documentID]
    }
    
    init(email: String, displayName: String, photoURL: String, userSince: TimeInterval, documentID: String) {
        self.email = email
        self.displayName = displayName
        self.photoURL = photoURL
        self.userSince = userSince
        self.documentID = documentID
    }
    
    convenience init (user: User) {
        self.init(email: user.email ?? "", displayName: user.displayName ?? "", photoURL: (user.photoURL != nil ? "\(user.photoURL!)" : ""), userSince: TimeInterval(), documentID: user.uid)
    }
    
    convenience init(dictionary: [String: Any]) {
        let email = dictionary["email"] as! String? ?? ""
        let displayName = dictionary["displayName"] as! String? ?? ""
        let photoURL = dictionary["photoURL"] as? String ?? ""
        let userSince = dictionary["userSince"] as! TimeInterval?  ?? TimeInterval()
        self.init(email: email, displayName: displayName, photoURL: photoURL, userSince: userSince, documentID: "")
    }
    
    func saveIfNewUser() {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(documentID)
        userRef.getDocument { (document, error) in
            guard error == nil else {
                print("😡 ERROR: could not access document for user \(userRef.documentID), error: \(error!.localizedDescription)")
                return
            }
            guard document?.exists == false else {
                print("^^^ The document for user \(self.documentID) already exists, no reason to create it ")
                return
            }
            self.saveData()
        }
    }
    
    func saveData() {
        let db = Firestore.firestore()
        let dataToSave: [String: Any] = self.dictionary
        db.collection("users").document(documentID).setData(dataToSave) { error in
            if let error = error {
                print("😡 ERROR: \(error.localizedDescription), could not save data for \(self.documentID)")
            }
        }
    }
}
