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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func addFriendButtonPressed(_ sender: Any) {
        
    }
}
