//
//  Review.swift
//  Snacktacular
//
//  Created by Cameron Arrigo on 4/14/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import Foundation
import Firebase

class Review {
    var title: String
    var text: String
    var rating: Int
    var reviewerUserID: String
    var date: TimeInterval
    var documentID: String
    
    var dictionary: [String: Any] {
        return ["title": title, "text": text, "rating": rating, "reviewerUserID": reviewerUserID, "date": date]
    }
    
    init(title: String, text: String, rating: Int, reviewerUserID: String, date: TimeInterval, documentID: String) {
        self.title = title
        self.text = text
        self.rating = rating
        self.reviewerUserID = reviewerUserID
        self.date = date
        self.documentID = documentID
    }
    
    convenience init(dictionary: [String: Any]) {
        let title = dictionary["title"] as! String? ?? ""
        let text = dictionary["text"] as! String? ?? ""
        let rating = dictionary["rating"] as! Int? ?? 0
        let reviewerUserID = dictionary["reviewerUserID"] as! String? ?? ""
        let date = dictionary["date"] as! TimeInterval? ?? 0.0
        self.init(title: title, text: text, rating: rating, reviewerUserID: reviewerUserID, date: date, documentID: "")
    }
    
    convenience init() {
        let currentUserID = Auth.auth().currentUser?.email ?? "Unknown User"
        let newDate = Date().timeIntervalSince1970
        self.init(title: "", text: "", rating: 0, reviewerUserID: currentUserID, date: newDate, documentID: "")
    }
    
    func saveData(spot: Spot, completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        print("📍📍📍 spot.documentID = \(spot.documentID), length = \(spot.documentID.count)")
        //Create the dictionary representing the data we want to save
        let dataToSave = self.dictionary
        //if we have saved a record, we'll have a documentID
        if self.documentID != "" {
            let ref = db.collection("spots").document(self.documentID).collection("reviews").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("*** ERROR: updating document \(self.documentID) in spot \(spot.documentID) \(error.localizedDescription)")
                    completed(false)
                } else {
                    print("^^^ Document updated with ref ID \(ref.documentID)")
                    print("\(String(describing: self.dictionary["coordinate"]))")
                    completed(true)
                }
            }
        } else {
            var ref: DocumentReference? = nil //Let firestone create the new documentID
            ref = db.collection("spots").document(spot.documentID).collection("reviews").addDocument(data: dataToSave) { (error) in
                if let error = error {
                    print("*** ERROR: creating new document in spot \(spot.documentID) for new review documentID \(error.localizedDescription)")
                    completed(false)
                } else {
                    print("^^^ Document updated with ref ID \(ref?.documentID ?? "unknown")")
                    spot.updateAverageRating {
                        completed(true)
                    }
                }
            }
        }
    }
    
    func deleteData(spot: Spot, completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        db.collection("spots").document(spot.documentID).collection("reviews").document(documentID).delete() { error in
            if let error = error {
                print("😡 ERROR: deleting review documentID \(self.documentID) \(error.localizedDescription)")
                completed(false)
            } else {
                spot.updateAverageRating {
                    completed(true)
                }
            }
        }
    }
}



