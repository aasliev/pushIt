//
//  CoreDataClass.swift
//  PushIt
//
//  Created by Asliddin Asliev on 8/21/20.
//  Copyright © 2020 Asliddin Asliev. All rights reserved.
//

import Foundation
import Firebase
import CoreData

class CoreDataClass{
    
    let DATE_STARTED = "dateStarted"
    let DAYS_SKIPPED = "daysSkipped"
    let LAST_DATE_SKIPPED = "lastDateSkipped"
    let LONGEST_CON_DAYS = "longestConDays"
    let MOTIVATION = "motivation"
    let NAME = "name"
    
    var challengeArray  = [Challenge]()
    
    //Singleton
       static let sharedCoreData = CoreDataClass()
       let databaseInstance = FirebaseDatabase.shared
       let authInstance = FirebaseAuth.sharedFirebaseAuth
       let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
       
       private init() {}
       
       func getContext() -> NSManagedObjectContext {
           return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
       }
    
      
    func saveItems()
    {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        //self.tableView.reloadData()
        
    }
    func loadItems(with request: NSFetchRequest<Challenge> = Challenge.fetchRequest()) -> [Challenge]{
        do {
            challengeArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
    return challengeArray
    }
    
}
