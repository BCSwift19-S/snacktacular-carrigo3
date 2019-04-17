//
//  Photo.swift
//  Snacktacular
//
//  Created by Cameron Arrigo on 4/14/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import Foundation
import Firebase

class Photo {
    var image: UIImage
    var description: String
    var postedBy: String
    var date: Date
    var documentUUID: String // Universal Unique Identifier
    
    init(image: UIImage, description: String, postedBy: String, date: Date, documentUUID: String) {
        self.image = image
        self.description = description
        self.postedBy = postedBy
        self.date = date
        self.documentUUID = documentUUID
    }
    
    convenience init() {
        let postedBy = Auth.auth().currentUser?.email ?? "Unknown user"
        self.init(image: UIImage(), description: "", postedBy: postedBy, date: Date(), documentUUID: "")
    }
    
//    func saveData(spot: Spot, completed: @escaping (Bool) -> ()) {
//        let db = Firestore.firestore()
//        let storage = Storage.storage()
//        //convert photo.image to a data type so it can be saved by Firebase Storage
//        guard let photoData = self.image.jpegData(compressionQuality: 0.5) else {
//            print("*** ERROR: could not convert image to data format")
//            return completed(false)
//        }
//        documentUUID = UUID().uuidString //Generate a unique ID to use for the photo image's name
//        // create a ref to upload storage to spot.documentID's folder (bucket), with the name we created.
//        let storageRef = storage.reference().child(spot.documentID).child(self.documentUUID)
//        //Create the dictionary representing the data we want to save
//        let dataToSave = self.dictionary
//        //if we have saved a record, we'll have a documentID
//        let ref = db.collection("spots").document(self.documentID).collection("reviews").document(self.documentID)
//        ref.setData(dataToSave) { (error) in
//            if let error = error {
//                print("*** ERROR: updating document \(self.documentID) in spot \(spot.documentID) \(error.localizedDescription)")
//                completed(false)
//            } else {
//                print("^^^ Document updated with ref ID \(ref.documentID)")
//                print("\(String(describing: self.dictionary["coordinate"]))")
//                completed(true)
//            }
//        }
//    }
}
