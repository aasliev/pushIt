//
//  createChallengeView.swift
//  PushIt
//
//  Created by Asliddin Asliev on 11/7/19.
//  Copyright © 2019 Asliddin Asliev. All rights reserved.
//

import UIKit

class createChallengeView: UIViewController {
    
   

    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var nameOfTheChallenge: UITextField!
    @IBOutlet weak var motivationText: UITextView!
    @IBOutlet weak var dateStarted: UIDatePicker!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let borderColor : UIColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        //motivationText.layer.borderWidth = 1.5
        //motivationText.layer.borderColor = borderColor.cgColor
        self.hideKeyboardWhenTappedAround()
    }
    

    //MARK: - Add new Challenge
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        let tmpChallenge = Challenge(context: self.context)
        tmpChallenge.name = nameOfTheChallenge.text!
        tmpChallenge.motivation = motivationText.text!
        tmpChallenge.dateStart = dateStarted.date
        
        self.saveItem()
        print("------------")
        //print(dateStarted.date - date.timeIntervalSinceNow)
        
        //performSegue(withIdentifier: "toChallengesView", sender: self)
        _ = navigationController?.popViewController(animated: true)
    }
    
    func saveItem()
    {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
    }
    
}
