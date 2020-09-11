//
//  ProfileScreenView.swift
//  PushIt
//
//  Created by Asliddin Asliev on 9/9/20.
//  Copyright © 2020 Asliddin Asliev. All rights reserved.
//

import UIKit

class ProfileScreenView: UIViewController {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var firstNameLastNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.tabBarController?.tabBar.isHidden = true
        // Do any additional setup after loading the view.
        //setting up profile picture
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width/2
        profilePicture.clipsToBounds = true
        profilePicture.layer.borderColor = UIColor.white.cgColor
        profilePicture.layer.borderWidth = 3
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFriendScreen"{
            self.navigationController?.popToRootViewController(animated: false)
        }
    }
    

    @IBAction func xButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
