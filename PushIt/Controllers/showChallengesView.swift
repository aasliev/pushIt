//
//  showChallengesView.swift
//  PushIt
//
//  Created by Asliddin Asliev on 11/7/19.
//  Copyright © 2019 Asliddin Asliev. All rights reserved.
//

import UIKit

class showChallengesView: UIViewController {

    @IBOutlet weak var motivationText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let borderColor : UIColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        motivationText.layer.borderWidth = 1.5
        motivationText.layer.borderColor = borderColor.cgColor
    }
    

}
