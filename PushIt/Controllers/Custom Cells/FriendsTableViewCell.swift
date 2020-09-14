//
//  FriendsTableViewCell.swift
//  PushIt
//
//  Created by Asliddin Asliev on 9/12/20.
//  Copyright © 2020 Asliddin Asliev. All rights reserved.
//

import UIKit
import SwipeCellKit
class FriendsTableViewCell: SwipeTableViewCell {
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var firstNameLastName: UILabel!
    
    override class func awakeFromNib() {
        // setup profile picture
        
    }
    
    func setUpProfilePicture(){
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width/2
        profilePicture.clipsToBounds = true
    }
}
