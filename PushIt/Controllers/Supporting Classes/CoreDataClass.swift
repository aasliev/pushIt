//
//  CoreDataClass.swift
//  PushIt
//
//  Created by Asliddin Asliev on 8/21/20.
//  Copyright © 2020 Asliddin Asliev. All rights reserved.
//
import UIKit
import Foundation
import Firebase
import FirebaseFirestore
import CoreData

class CoreDataClass{
    
    let CHALLENGE_ENTITY = "Challenge"
    let FRIEND_ENTITY = "Friend"
    // challenge attributes
    let DATE_STARTED = "dateStarted"
    let DAYS_SKIPPED = "daysSkipped"
    let LAST_DATE_SKIPPED = "lastDateSkipped"
    let LONGEST_CON_DAYS = "longestConDays"
    let MOTIVATION = "motivation"
    let NAME = "name"
    
    //friends attribute
    let FRIEND_FIRST_NAME = "friendsFirstName"
    let FRIEND_LAST_NAME = "friendsLastName"
    let FRIEND_EMAIL = "friendsEmail"
    let FRIEND_NUM_OF_CHALLENGE = "friendNumOfChallenges"

    var challengeArray = [Challenge]()
    var friendArray = [Friend]()
    var coreDataUpdated = false
    //Singleton
    static let sharedCoreData = CoreDataClass()
    let databaseInstance = FirebaseDatabase.shared
    let authInstance = FirebaseAuth.sharedFirebaseAuth
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
       
    private init() {}
    
    
    // NSFetchRequests for core data entities
    lazy var challengeRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CHALLENGE_ENTITY)
    lazy var friendRequest = NSFetchRequest<NSFetchRequestResult>(entityName: FRIEND_ENTITY)
    
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
    //func tmp(with request: NSFetchRequest<>)
    
    func loadChallenge(with request: NSFetchRequest<Challenge> = Challenge.fetchRequest()) -> [Challenge]{
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            challengeArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
    return challengeArray
    }
    // load friend
    func loadFriend(with request: NSFetchRequest<Friend> = Friend.fetchRequest()) -> [Friend]{
        request.sortDescriptors = [NSSortDescriptor(key: "friendsFirstName", ascending: true)]
        do {
            friendArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
    return friendArray
    }
    
    //Use of this function is when user sign out, this method will clear all data from all entities
    func resetAllEntities() -> Bool {
        let challengeRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CHALLENGE_ENTITY)
        let friendRequest = NSFetchRequest<NSFetchRequestResult>(entityName: FRIEND_ENTITY)
        // Create Batch Delete Request
        let challengeDeleteRequest = NSBatchDeleteRequest(fetchRequest: challengeRequest)
        let friendDeleteRequest = NSBatchDeleteRequest(fetchRequest: friendRequest)
        do {
            try self.context.execute(challengeDeleteRequest)
            try self.context.execute(friendDeleteRequest)
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
        addDataToFriend()
        
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
    
    // friend funtions
    func addDataToFriend(){
        //Getting list of Challenges from Firestore Database
        databaseInstance.getFriends(usersEmail: authInstance.getCurrentUserEmail()) { (friendsDict) in
            print("From Core Data Class, addDataIntoEntities: \(friendsDict as AnyObject)")
            self.addFriendList(friendList: friendsDict)
    }
    }
    func addFriendList(friendList: Dictionary<Int , Dictionary <String, Any >>){
        var friends = [Friend]()
        
        for(_, data) in friendList{
            // create tmp challenge variable with the same context
            let tmpFriend = Friend(context: getContext())
            let firstName = (data[databaseInstance.FRIENDS_FIRST_NAME_FIELD] as! String)
            let lastName = (data[databaseInstance.FRIENDS_LAST_NAME_FIELD] as! String)
            let email = (data[databaseInstance.FRIENDS_EMAIL_FIELD] as! String)
            let numOfChallenges = Int32(data[databaseInstance.NUMBER_OF_CHALLENGES] as! Int)
            //print(dateStarted)
            //print(lastDateSkipped as! Date)
            tmpFriend.friendsEmail = email
            tmpFriend.friendsFirstName = firstName
            tmpFriend.friendsLastName = lastName
            tmpFriend.friendsNumOfChallenges = numOfChallenges
            friends.append(tmpFriend)
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
