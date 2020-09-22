//
//  FriendsTableViewCell.swift
//  PushIt
//
//  Created by Asliddin Asliev on 9/21/20.
//  Copyright © 2020 Asliddin Asliev. All rights reserved.
//

import UIKit
import SwipeCellKit
class FriendsTableViewCell: SwipeTableViewCell {
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var firstNameLastName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // setup profile picture
        setUpProfilePicture()
    }
    
    func setUpProfilePicture(){
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width/2
        profilePicture.clipsToBounds = true
    }
}
