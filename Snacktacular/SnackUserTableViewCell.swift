//
//  SnackUserTableViewCell.swift
//  Snacktacular
//
//  Created by Cameron Arrigo on 4/22/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import UIKit

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeZone = .none
    return dateFormatter
}()

class SnackUserTableViewCell: UITableViewCell {
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userSinceLabel: UILabel!
    
    var snackUser: SnackUser! {
        didSet {
            displayNameLabel.text = snackUser.displayName
            emailLabel.text = snackUser.email
            var newDate = Date(timeIntervalSince1970: snackUser.userSince)
            let formattedDated = dateFormatter.string(from: newDate)
            userSinceLabel.text = formattedDated
        }
        
    }
}
