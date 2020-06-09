//
//  createChallengeView.swift
//  PushIt
//
//  Created by Asliddin Asliev on 11/7/19.
//  Copyright © 2019 Asliddin Asliev. All rights reserved.
//

import UIKit

class createChallengeView: UIViewController, UITextViewDelegate {
    
   

    
    var calendar = Calendar.current
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let commonFunctions = CommonFunctions.sharedCommonFunction

    @IBOutlet weak var nameOfTheChallenge: UITextField!
    @IBOutlet weak var motivationText: UITextView!
    @IBOutlet weak var dateStarted: UIDatePicker!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //let borderColor : UIColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        //motivationText.layer.borderWidth = 1.5
        //motivationText.layer.borderColor = borderColor.cgColor
        self.hideKeyboardWhenTappedAround()
        calendar.timeZone = TimeZone.current
        self.navigationItem.hidesBackButton = true
        
        motivationText.delegate = self
        // setting motivation textview placeholder
        
        motivationText.text = "Motivation"
        motivationText.textColor = UIColor.lightGray

        motivationText.becomeFirstResponder()

        motivationText.selectedTextRange = motivationText.textRange(from: motivationText.beginningOfDocument, to: motivationText.beginningOfDocument)
    }
    // placeholder functions
    
    func textView(_ motivationText: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:String = motivationText.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {

            motivationText.text = "Motivation"
            motivationText.textColor = UIColor.lightGray

            motivationText.selectedTextRange = motivationText.textRange(from: motivationText.beginningOfDocument, to: motivationText.beginningOfDocument)
        }

        // Else if the text view's placeholder is showing and the
        // length of the replacement string is greater than 0, set
        // the text color to black then set its text to the
        // replacement string
         else if motivationText.textColor == UIColor.lightGray && !text.isEmpty {
            motivationText.textColor = UIColor.black
            motivationText.text = text
        }

        // For every other case, the text should change with the usual
        // behavior...
        else {
            return true
        }

        // ...otherwise return false since the updates have already
        // been made
        return false
    }
    
    func textViewDidChangeSelection(_ motivationText: UITextView) {
        if self.view.window != nil {
            if motivationText.textColor == UIColor.lightGray {
                motivationText.selectedTextRange = motivationText.textRange(from: motivationText.beginningOfDocument, to: motivationText.beginningOfDocument)
            }
        }
    }


    //MARK: - Add new Challenge
    @IBAction func CreateButtonPressed(_ sender: Any) {
        let dateStart = setHMS(date: dateStarted.date)
        print(dateStart)
        //print(tmpChallenge.name)
        //print(tmpChallenge.motivation)
        //print(tmpChallenge.dateStart)
        if nameOfTheChallenge.text != "" && motivationText.text != "Motivation" {
            let tmpChallenge = Challenge(context: self.context)
            tmpChallenge.name = nameOfTheChallenge.text!
            tmpChallenge.motivation = motivationText.text!
            tmpChallenge.dateStart = dateStarted.date
            self.saveItem()
            //performSegue(withIdentifier: "toChallengesView", sender: self)
            _ = navigationController?.popViewController(animated: true)
        }
        else {
            commonFunctions.createUIalert("Please fill out all the information", self)
        }
        print("------------")
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
    
    
    func saveItem()
    {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
    }
    func setHMS(date : Date)->Date{
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        components.hour = 0
        components.minute = 0
        components.second = 0
        return calendar.date(from: components)!
    }
    
}
