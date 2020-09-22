//
//  SearchFriendsTableViewCell.swift
//  PushIt
//
//  Created by Asliddin Asliev on 9/14/20.
//  Copyright © 2020 Asliddin Asliev. All rights reserved.
//

import UIKit

class SearchFriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var firstNameLastName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //setUpProfilePicture()
        
    }
    func setUpProfilePicture(){
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width/2
        profilePicture.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        print("selected")
    }

    @IBAction func addFriendButtonPressed(_ sender: Any) {
        print("Button pressed")
        
    }
}
