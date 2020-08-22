//
//  FirebaseAuth.swift
//  PushIt
//
//  Created by Asliddin Asliev on 8/21/20.
//  Copyright © 2020 Asliddin Asliev. All rights reserved.
//

import Firebase

class FirebaseAuth {
    let authInstance : Auth
    let commonFunctions : CommonFunctions
    private var currentUserEmail : String?
    
    static let sharedFirebaseAuth = FirebaseAuth()

    private init() {
        
        authInstance = Auth.auth()
        commonFunctions = CommonFunctions.sharedCommonFunction

        
        //checks if user is loged in.  Fi
        currentUserEmail = (authInstance.currentUser == nil) ? nil: (authInstance.currentUser?.email)
        
    }
    
    func updateCurrentUser() {
        
        //Checking if any user is signed in. 'authInstance.currentUser' will be nil if no user is logged in
        if (authInstance.currentUser == nil) {
            //as not any user is logged in, set currentUserEmail = nil
            currentUserEmail = nil
        } else {
            //This sets currentUserEmail to email of logged in user
            currentUserEmail = authInstance.currentUser?.email
        }
    }
    
    //Returns email of current user
    func getCurrentUserEmail() -> String {
        
        //currentUser will be equal to email of currently signed in user if
        if (currentUserEmail == nil ){
            updateCurrentUser()
            return getCurrentUserEmail()
        }else {
            return currentUserEmail!
        }
    }
    
    //Sign out current user from Firebase Auth
    func signOutCurrentUser(){
        
        do {
            try self.authInstance.signOut()
            
            //This method updates the currentUser variable which keeps track of email of currently logged in user
            updateCurrentUser()
            
            //Reseting all data from Core Data of user
            //CoreDataClass.sharedCoreData.resetAllEntities()
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
}
