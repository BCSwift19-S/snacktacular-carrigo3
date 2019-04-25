//
//  SnackUsers.swift
//  Snacktacular
//
//  Created by Cameron Arrigo on 4/22/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import Foundation
import Firebase

class SnackUsers {
    var snackUsersArray = [SnackUser]()
    var db: Firestore!
    
    init(){
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ()) {
        db.collection("users").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("*** ERROR: adding the snapshpot listener \(error!.localizedDescription)")
                return completed()
            }
            self.snackUsersArray = []
            //there are querySnapshot!.documents.count documents in the spots snapshot
            for document in querySnapshot!.documents {
                let snackUser = SnackUser(dictionary: document.data())
                snackUser.documentID = document.documentID
                self.snackUsersArray.append(snackUser)
            }
            completed()
        }
    }
    
}
