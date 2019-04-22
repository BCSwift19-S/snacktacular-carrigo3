//
//  Photo.swift
//  Snacktacular
//
//  Created by Cameron Arrigo on 4/14/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//
import UIKit
import Foundation
import Firebase

class Photo {
    var image: UIImage
    var description: String
    var postedBy: String
    var date: TimeInterval
    var documentUUID: String // Universal Unique Identifier
    
    var dictionary: [String: Any] {
        return ["description": description, "postedBy": postedBy, "date": date]
    }
    
    init(image: UIImage, description: String, postedBy: String, date: TimeInterval, documentUUID: String) {
        self.image = image
        self.description = description
        self.postedBy = postedBy
        self.date = date
        self.documentUUID = documentUUID
    }
    
    convenience init() {
        let postedBy = Auth.auth().currentUser?.email ?? "Unknown User"
        let newDate = Date().timeIntervalSince1970
        self.init(image: UIImage(), description: "", postedBy: postedBy, date: newDate, documentUUID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let description = dictionary["description"] as! String? ?? ""
        let postedBy = dictionary["postedBy"] as! String? ?? ""
        let date = dictionary["date"] as! TimeInterval? ?? 0.0
        self.init(image: UIImage(), description: "", postedBy: postedBy, date: date, documentUUID: "")
    }
    
    func saveData(spot: Spot, completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        let storage = Storage.storage()
        //convert photo.image to a data type so it can be saved by Firebase Storage
        guard let photoData = self.image.jpegData(compressionQuality: 0.5) else {
            print("*** ERROR: could not convert image to data format")
            return completed(false)
        }
        let uploadMetadata = StorageMetadata()
        uploadMetadata.contentType = "image/jpeg"
        documentUUID = UUID().uuidString //Generate a unique ID to use for the photo image's name
        // create a ref to upload storage to spot.documentID's folder (bucket), with the name we created.
        let storageRef = storage.reference().child(spot.documentID).child(self.documentUUID)
        let uploadTask = storageRef.putData(photoData, metadata: uploadMetadata)
        {metadata, error in
            guard error == nil else {
                print("*** ERROR: Error during .putData storage upload for \(storageRef). Error: \(error?.localizedDescription)")
                return
            }
            print("UPLOAD WORKED! Metadata is \(metadata)")
        }
        
        uploadTask.observe(.success) { (snapshot) in
            let dataToSave = self.dictionary
            // This will either create a new doc at documentUUID or update the existing doc with that name
            let ref = db.collection("spots").document(spot.documentID).collection("photos").document(self.documentUUID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("*** ERROR: updating document \(self.documentUUID) in spot \(spot.documentID) \(error.localizedDescription)")
                    completed(false)
                } else {
                    print("^^^ Document updated with ref ID \(ref.documentID)")
                    print("\(String(describing: self.dictionary["coordinate"]))")
                    completed(true)
                }
            }
        }
        
        uploadTask.observe(.failure) { (snapshot) in
            if let error = snapshot.error {
                print("*** ERROR: upload task for file \(self.documentUUID) failed, in spot \(spot.documentID)")
            }
            return completed(false)
        }
    }
}
