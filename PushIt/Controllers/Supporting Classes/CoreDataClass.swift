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
    
    let CHALLENGE_ENTITY = "Challenge"
    
    let DATE_STARTED = "dateStarted"
    let DAYS_SKIPPED = "daysSkipped"
    let LAST_DATE_SKIPPED = "lastDateSkipped"
    let LONGEST_CON_DAYS = "longestConDays"
    let MOTIVATION = "motivation"
    let NAME = "name"
    
    var challengeArray  = [Challenge]()
    var coreDataUpdated = false
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
    
    //Use of this function is when user sign out, this method will clear all data from all entities
    func resetAllEntities() -> Bool {
        let challengeRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CHALLENGE_ENTITY)
        
        // Create Batch Delete Request
        let challengeDeleteRequest = NSBatchDeleteRequest(fetchRequest: challengeRequest)
        
        do {
            try self.context.execute(challengeDeleteRequest)
            print("Successfully Emptied Core Data.")
            return true
        } catch {
            print("Error deteting entitry \(error)")
            return false
        }
    }
    
    // addDataToCoreData
    private func addDataToCoreData(){
        // for now we have only one entity (Challenge)
        addDataToChallenge()
    }
    
    func addDataToChallenge(){
        //Getting list of Challenges from Firestore Database
        databaseInstance.getChallenges(usersEmail: authInstance.getCurrentUserEmail()) { (challengesDict) in
            print("From Core Data Class, addDataIntoEntities: \(challengesDict as AnyObject)")
            self.addChallengeList(challengeList: challengesDict)
    }
    }
    func addChallengeList(challengeList: Dictionary<Int , Dictionary <String, Any >>){
        var challenges = [Challenge]()
        
        for(_, data) in challengeList{
            // create tmp challenge variable with the same context
            let tmpChallenge = Challenge(context: getContext())
            let name = (data[databaseInstance.CHALLENGE_NAME_FIELD] as! String)
            let motivation = (data[databaseInstance.CHALLENGE_MOTIVATION_FIELD] as! String)
            let dateStarted = (data[databaseInstance.DATE_STARTED_FIELD] as! Timestamp).dateValue()
            let lastDateSkipped = (data[databaseInstance.LAST_DATE_SKIPPED_FIELD] as! Timestamp).dateValue()
            let longestConDay = (data[databaseInstance.LONGEST_CON_DAY_FIELD] as! Double)
            let numOfSkippedDays = (data[databaseInstance.NUMBER_OF_DAYS_SKIPPED_FIELD] as! Double)
            
            //print(dateStarted)
            //print(lastDateSkipped as! Date)
            tmpChallenge.name = name
            tmpChallenge.motivation = motivation
            tmpChallenge.dateStart = dateStarted
            tmpChallenge.lastDateSkipped = lastDateSkipped
            tmpChallenge.longestConDays = longestConDay
            tmpChallenge.daysSkipped = numOfSkippedDays
            
            challenges.append(tmpChallenge)
        }
        saveItems()
        coreDataUpdated = true
    }
    
    // updateCoreData every time user Signs In
    func updateCoreData() {
        //First, in case there is data stored inside Core Data resetAllEntities() will clear it.
        resetAllEntities()
        
        //Second, adding data into CoreData. Which is recived from Firestore.
        addDataToCoreData()
        //print("check")
    }
    
    
}
