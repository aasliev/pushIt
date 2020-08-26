//
//  FirebaseDatabase.swift
//  PushIt
//
//  Created by Asliddin Asliev on 8/21/20.
//  Copyright © 2020 Asliddin Asliev. All rights reserved.
//

import Firebase

class FirebaseDatabase {

    //MARK: Firestore Database Istance
    //let config = FirebaseApp.configure()
    let db : Firestore
    let authInstance : FirebaseAuth

    //Singleton
    static let shared : FirebaseDatabase = FirebaseDatabase()

    //MARK: - Firestore Collection Names
    let USERS_MAIN_COLLECTION = "user_collection"
    let CHALLENGES_SUB_COLLECTION = "challenges_sub_collection"
    let FRIENDS_SUB_COLLECTION = "friends_sub_collection"
    
    // user/friends fields
    let USER_EMAIL_FIELD = "email"
    let FIRST_NAME_FIELD = "first_name"
    let LAST_NAME_FIELD = "last_name"
    let NUMBER_OF_CHALLENGES = "number_of_challenges"
    
    let CHALLENGE_NAME_FIELD = "challenge_name"
    let CHALLENGE_MOTIVATION_FIELD = "challenge_motivation"
    let DATE_STARTED_FIELD = "date_started"
    let LAST_DATE_SKIPPED_FIELD = "last_date_skipped"
    let LONGEST_CON_DAY_FIELD = "longest_con_day"
    let NUMBER_OF_DAYS_SKIPPED_FIELD = "number_of_days_skipped"
    
    let FRIENDS_EMAIL_FIELD = "friends_email"
    let FRIENDS_FIRST_NAME_FIELD = "first_name"
    let FRIENDS_LAST_NAME_FIELD = "last_name"

    //MARK: Collection Paths
    let USER_COLLECTION_PATH : String
    
    //MARK: Collection Reference
    let USER_COLLECTION_REF : CollectionReference
    
    var path : String = ""
    var message : String = ""
    var ref : DocumentReference
    var numberOfChallenges : Int?
    //var rating : Int?
    //private var numberOfSwaps : Int?
    //let MAX_HOLDING_BOOKS = 5
    
    private init() {
        
        //FirebaseApp.configure()
        
        db = Firestore.firestore()
        authInstance = FirebaseAuth.sharedFirebaseAuth
        
        USER_COLLECTION_REF = db.collection(USERS_MAIN_COLLECTION)
        
        USER_COLLECTION_PATH = "\(USERS_MAIN_COLLECTION)"
        
        //this exact ref won't be used. This is written to silent the error : "Return from initializer without initializing all stored properties"
        ref = db.collection("Document Path").document("Document Name")
    }
    
    //MARK: Add Methods to Firestore
    //Adding New User to Firestore when user Sign Up
    func addNewUserToFirestore(firstName: String, lastName: String, email: String,completion: @escaping (Bool)->() ) {
        
        ref = db.collection(USERS_MAIN_COLLECTION).document(email.lowercased())
        ref.setData([
            USER_EMAIL_FIELD : email.lowercased(),
            FIRST_NAME_FIELD : firstName,
            LAST_NAME_FIELD : lastName,
            NUMBER_OF_CHALLENGES : 0
        ]){ err in
            if let err = err{
                print("Error writing document \(err)")
                completion(false)
            } else {
                print("Document successfully written!.\n")
                completion(true)
            }
        }
    }
    
    // Add to Challenges
    
    
    func addToChallenges(currentUserEmail: String, challengeName: String, challengeMotivation: String, dateStarted: Date){
        path = "\(USERS_MAIN_COLLECTION)/\(currentUserEmail)/\(CHALLENGES_SUB_COLLECTION)"
        ref = db.collection(path).document("\(challengeName)")
        
        ref.setData([
            CHALLENGE_NAME_FIELD: challengeName,
            CHALLENGE_MOTIVATION_FIELD: challengeMotivation,
            DATE_STARTED_FIELD: dateStarted,
            LAST_DATE_SKIPPED_FIELD: dateStarted,
            LONGEST_CON_DAY_FIELD: 0,
            NUMBER_OF_DAYS_SKIPPED_FIELD: 0
        ]) { err in
            if let err = err{
            _ = self.checkError(error: err, whileDoing: "adding challenge to Challenge Sub-Collection")
            } else {
                self.changeNumberOfChallenges(usersEmail: currentUserEmail, by: 1)
            }
        }
    }
    
    func addToFriend(currentUserEmail: String, friendEmail: String, friendFirstName: String, friendLastName: String){
        
        path = "\(USERS_MAIN_COLLECTION)/\(currentUserEmail)/\(FRIENDS_SUB_COLLECTION)"
        ref = db.collection(path).document("\(friendEmail)")
        
        ref.setData([
            FRIENDS_LAST_NAME_FIELD: friendLastName,
            FRIENDS_FIRST_NAME_FIELD: friendFirstName
        ]){ err in
            _ = self.checkError(error: err, whileDoing: "adding friend to Friend Sub-Collection")
        }
    }
    
    
    //MARK: - Delete from Firestore
     
    // method to delete a field
    private func deleteDocument(documentPath: String, documentName: String){
        db.collection(documentPath).document(documentName).delete()
    }
    
    // remove challenge from challenge_sub_colection
    // users/userEmail/challenge-sub-collection/challengeName
    func removeChallenge(challengeName: String){
        let path = "\(USERS_MAIN_COLLECTION)/\(authInstance.getCurrentUserEmail())/\(CHALLENGES_SUB_COLLECTION)"
        self.deleteDocument(documentPath: path, documentName: challengeName)
        self.changeNumberOfChallenges(usersEmail: authInstance.getCurrentUserEmail(), by: -1)
    }
    
    //remove friends from friend_sub_collection
    // users/userEmail/friend_subcollection/friendsEmail
    func removeFriend(friendEmail: String){
        let path = "\(USERS_MAIN_COLLECTION)/\(authInstance.getCurrentUserEmail())/\(FRIENDS_SUB_COLLECTION))"
        self.deleteDocument(documentPath: path, documentName: friendEmail)
    }
    
    // Increment-Decrement Number of challenges
    func changeNumberOfChallenges(usersEmail: String, by: Int){
        
        let ref = db.collection(USERS_MAIN_COLLECTION).document(usersEmail)
        ref.updateData([
            self.NUMBER_OF_CHALLENGES: FieldValue.increment(Int64(by))
        ])
    }
    
    
    //MARK: Error
    private func checkError (error: Error?, whileDoing: String) -> Bool{
        
        //ternary operator
        //(error == err) ? print("Number of Swaps for Current User is incremented.") : print("Error while \(whileDoing): \(String(describing: error))")
        
        if error?.localizedDescription == nil{
            print("Successful \(whileDoing)! Class: FirebaseDatabase.swift")
            return true
        } else {
            print("Error while \(whileDoing) .: \(String(describing: error)) Class: FirebaseDatabase.swift")
            return false
        }
        
    }


}
