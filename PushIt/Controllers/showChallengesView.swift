//
//  showChallengesView.swift
//  PushIt
//
//  Created by Asliddin Asliev on 11/7/19.
//  Copyright © 2019 Asliddin Asliev. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
class showChallengesView: UIViewController {
    var selectedChallenge : Challenge? {
        didSet{
            self.navigationItem.title =  selectedChallenge?.name
        }
    }
    let todayDate = Date()
    let commonFunctions = CommonFunctions.sharedCommonFunction

    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    @IBOutlet weak var motivationText: UITextView!  //motivation text view
    @IBOutlet weak var numOfDays: UILabel!          //number of consequtive days
    @IBOutlet weak var daysWOFail: UILabel!         //total days - skipped
    @IBOutlet weak var daysSkipped: UILabel!        //skipped days
    @IBOutlet weak var totalDays: UILabel!          //startDate - today
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
        self.hideKeyboardWhenTappedAround()
        //motivationText.isEditable = false
    }
    
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "Reset", message: "Do you want to start over?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            if self.numOfDays.text! != "0"
            {
                self.numOfDays.text = "0"
                //change the start date to today's day
                self.selectedChallenge?.dateStart = self.todayDate
                self.selectedChallenge?.lastDateSkipped = self.todayDate
                self.selectedChallenge?.daysSkipped = 0
                self.selectedChallenge?.longestConDays = 0
                self.reloadData()
                self.saveItem()
            }
            
        }))
        self.present(alert, animated: true, completion: nil)

    }
    
    
    @IBAction func skipButtonPressed(_ sender: Any) {
        // increment skippedDays, and set skipdate to today.
        //check if user pressed skipped today already..
        let alert = UIAlertController(title: "Skip", message: "Do you want to skip a day?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
        
        let daysSkipped = self.selectedChallenge?.daysSkipped
        let longestCon = self.selectedChallenge?.longestConDays
            if (!self.checkDate(date: self.selectedChallenge?.lastDateSkipped as! Date)){
            self.selectedChallenge?.daysSkipped = Double(Int(daysSkipped!) + 1)
            self.selectedChallenge?.longestConDays = Double(Int(longestCon!) - 1)
            //print("Inside if: (#of skipped days...", self.selectedChallenge?.daysSkipped, self.selectedChallenge?.longestConDays)
            //reload data
            self.selectedChallenge?.lastDateSkipped = self.todayDate
            self.reloadData()
        }
        else {
            print("Error")
            self.commonFunctions.createUIalert("You can only skip once a day.", self)
            
        }
    }
        ))
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
    
    func reloadData(){
        // load motivation
         motivationText.text = selectedChallenge?.motivation
        
        // longest consecutive day
        let tmpConDay = selectedChallenge?.longestConDays
        let lastSkippedDay = selectedChallenge?.lastDateSkipped as! Date
        let daysSinceLastSkip = calculateNumOfDays(startDate: lastSkippedDay)
        
        
        if (Int(tmpConDay!) <= daysSinceLastSkip){
            selectedChallenge?.longestConDays = Double(daysSinceLastSkip)
        }
        numOfDays.text = String(Int(selectedChallenge?.longestConDays ?? 0))
         // total days..
         let startDate = selectedChallenge?.dateStart as! Date
         let total = calculateNumOfDays(startDate: startDate)
         totalDays.text = String(total)
         
         //skipped days
        daysSkipped.text = String(Int(selectedChallenge?.daysSkipped ?? 0))
         //days without fail: total days - skipped
         let days_wo_fail = String(total - Int(selectedChallenge!.daysSkipped))
         daysWOFail.text = days_wo_fail
         //print("days without fail: ", days_wo_fail)
        //print("before saving: ", selectedChallenge?.longestConDays)
        self.saveItem()
    }
    

    func checkDate(date : Date) -> Bool{
        //get day, month year of today and sent date
        // if they are equal send true, otherwise false.
        
        let calendar = Calendar.current
        let todayYear = calendar.component(.year, from: todayDate)
        let todayMonth = calendar.component(.month, from: todayDate)
        let todayDay = calendar.component(.day, from: todayDate)
        //
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        if(year == todayYear && month == todayMonth && day == todayDay){
            return true
        }
        
        return false
    }
}


extension showChallengesView{
    func calculateNumOfDays(startDate : Date) -> Int {
        

        let diffInDays = Calendar.current.dateComponents([.day], from: startDate, to: self.todayDate).day ?? 0
        
        return diffInDays
    }
}
