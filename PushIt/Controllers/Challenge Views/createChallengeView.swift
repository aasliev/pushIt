//
//  createChallengeView.swift
//  PushIt
//
//  Created by Asliddin Asliev on 11/7/19.
//  Copyright © 2019 Asliddin Asliev. All rights reserved.
//

import UIKit
import UserNotifications
class createChallengeView: UIViewController, UITextViewDelegate {
    
    var calendar = Calendar.current
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //instances of shared classes
    let commonFunctions = CommonFunctions.sharedCommonFunction
    let coreDataShared = CoreDataClass.sharedCoreData
    let firebaseDatabase = FirebaseDatabase.shared
    //let firebaseAuth = FirebaseAuth.sharedFirebaseAuth
    let notifications = notificationsFunctions()
    
    // users data
    @IBOutlet weak var nameOfTheChallenge: UITextField!
    @IBOutlet weak var motivationText: UITextView!
    @IBOutlet weak var dateStarted: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        calendar.timeZone = TimeZone.current
        self.navigationItem.hidesBackButton = true
        
        motivationText.delegate = self
        // setting motivation textview placeholder
        
        motivationText.text = "Motivation"
        motivationText.textColor = UIColor.lightGray

        }
    // placeholder functions
    
    func textViewDidBeginEditing(_ motivationText: UITextView)
    {
        if (motivationText.text == "Motivation" && motivationText.textColor == .lightGray)
        {
            motivationText.text = ""
            motivationText.textColor = .black
        }
        motivationText.becomeFirstResponder() //Optional
    }

    func textViewDidEndEditing(_ motivationText: UITextView)
    {
        if (motivationText.text == "")
        {
            motivationText.text = "Motivation"
            motivationText.textColor = .lightGray
        }
        motivationText.resignFirstResponder()
    }

    //MARK: - Add new Challenge
    @IBAction func CreateButtonPressed(_ sender: Any) {
        
        if self.checkIfTextFieldIsEmpty() && motivationText.text != "Motivation" {
            let tmpChallenge = Challenge(context: self.coreDataShared.getContext())
            tmpChallenge.name = nameOfTheChallenge.text!
            tmpChallenge.motivation = motivationText.text!
            tmpChallenge.dateStart = dateStarted.date
            tmpChallenge.lastDateSkipped = dateStarted.date
            tmpChallenge.daysSkipped = 0
            coreDataShared.saveItems()
            //self.saveItem()
            //performSegue(withIdentifier: "toChallengesView", sender: self)
            _ = navigationController?.popViewController(animated: true)
        }
        else {
            commonFunctions.createUIalert("Please fill out all the information", self)
        }
        
        // daily 8:00 am and 8:00 pm notifications..
        var timeComponent = Calendar.current.dateComponents([.hour, .minute, .second], from: Date())
        timeComponent.hour = 8
        timeComponent.minute = 0
        timeComponent.second = 0
        notifications.dailyNotification(title: "Don't forget your habits today!", body: "Keep pushing your comfort zone boundaries.", time: timeComponent, identifier: "mornign")
        timeComponent.hour = 20
        timeComponent.minute = 0
        timeComponent.second = 0
        notifications.dailyNotification(title: "How was your day?", body: "Don't forget to evaluate your day before going to sleep.", time: timeComponent, identifier: "night")
        
    }
    
    
    @IBAction func CancelButtonPressed(_ sender: Any) {
        // pop uimessage, are you sure you want to cancel, and go back to the list of challenges
        let alert : UIAlertController
        
        alert = UIAlertController(title: "Cancel", message: "Do you want to cancel?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            _ = self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)

    }
    
    // check if user entered data
    func checkIfTextFieldIsEmpty() -> Bool {
        let challengeName = commonFunctions.checkIfEmpty(nameOfTheChallenge, "Name It", screen: self)
        return challengeName
    }
}
