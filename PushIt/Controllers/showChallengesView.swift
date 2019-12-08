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
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var item = Challenge()
    
    @IBOutlet weak var motivationText: UITextView!
    @IBOutlet weak var numOfDays: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let borderColor : UIColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        motivationText.layer.borderWidth = 1.5
        motivationText.layer.borderColor = borderColor.cgColor
        
        //self.navigationItem.title = 
        //showData()
    }
    
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        if numOfDays.text! != "0"
        {
            numOfDays.text = "0"
        }
        
    }
    
//    func showData(with request: NSFetchRequest<Challenge> = Challenge.fetchRequest()){
//        do {
//            item = try context.fetch(request)
//        } catch {
//            print("Error fetching data from context \(error)")
//        }
    
        
 //   }

}
