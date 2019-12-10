//
//  showChallengesView.swift
//  PushIt
//
//  Created by Asliddin Asliev on 11/7/19.
//  Copyright © 2019 Asliddin Asliev. All rights reserved.
//

import UIKit
import CoreData

class showChallengesView: UIViewController {
    var selectedChallenge : Challenge? {
        didSet{
            self.navigationItem.title =  selectedChallenge?.name
            //let motivation = selectedChallenge?.motivation
            //let date : NSDate = (selectedChallenge?.dateStart! ?? nil)! as NSDate
            
            
        }
    }
    let todayDate = Date()
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var item = Challenge()
    
    @IBOutlet weak var motivationText: UITextView!
    @IBOutlet weak var numOfDays: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let borderColor : UIColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        //motivationText.layer.borderWidth = 1.5
        //motivationText.layer.borderColor = borderColor.cgColor
        motivationText.text = selectedChallenge?.motivation
        //self.navigationItem.title =
        //showData()
        
        
        //print(selectedChallenge?.dateStart)
        let date = selectedChallenge?.dateStart! as! Date
        let tmp = String(calculateNumOfDays(startDate: date))
        numOfDays.text = tmp
        //print(calendar.component(.year, from: date))
        
        self.hideKeyboardWhenTappedAround()
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
                self.saveItem()
            }
            
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
    

}


extension showChallengesView{
    func calculateNumOfDays(startDate : Date) -> Int {
        

        let diffInDays = Calendar.current.dateComponents([.day], from: startDate, to: self.todayDate).day ?? 0
        
        return diffInDays
    }
}
