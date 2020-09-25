//
//  SearchFriendsTableViewCell.swift
//  PushIt
//
//  Created by Asliddin Asliev on 9/14/20.
//  Copyright © 2020 Asliddin Asliev. All rights reserved.
//

import UIKit

class SearchFriendsTableViewCell: UITableViewCell {

    // singletons
    let coreDataClassShared = CoreDataClass.sharedCoreData
    let firestoreClassShared = FirebaseDatabase.shared
    let firebaseAuthClassShared = FirebaseAuth.sharedFirebaseAuth
    
    
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var firstNameLastName: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpProfilePicture()
        //print(": ", firstNameLastName)
        email.isHidden = true
        
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

    @IBAction func addFriendButtonPressed(_ sender: UIButton) {
        // at the moment we will just add a friend (without sending notification)
        // after implementing push notification, we will send notification to ask
        var friend = Friend(context: coreDataClassShared.context)
        
        // getting friends info
        // add friend to currentUser friends_sub_collection
        let currentUser = firebaseAuthClassShared.getCurrentUserEmail()
        firestoreClassShared.getUserInfo(usersEmail: email.text!) { (friendInfo) in
            self.firestoreClassShared.addToFriend(currentUserEmail: currentUser, friendInfo: friendInfo)
            //add friend to core data
            friend.friendsEmail = friendInfo.email
            friend.friendsFirstName = friendInfo.firstName
            friend.friendsLastName = friendInfo.lastName
            friend.friendsNumOfChallenges = Int32(friendInfo.numOfChallenges)
        
            self.coreDataClassShared.saveItems()
            
        }
        
        // get current users info
        // add current user to friends friend_sub_collection
        firestoreClassShared.getUserInfo(usersEmail: firebaseAuthClassShared.getCurrentUserEmail()) { (currentUserInfo) in
            self.firestoreClassShared.addToFriend(currentUserEmail: self.email.text!, friendInfo: currentUserInfo)
            
        }
        
        // hide button
        
        if #available(iOS 13.0, *) {
            sender.setImage(UIImage(systemName: "person.badge.minus"), for: .normal)
            sender.isEnabled = false
        } else {
            // Fallback on earlier versions
            sender.isHidden = true
            sender.isEnabled = false
        }
       print("Button pressed")
        
        
        
    }
}
