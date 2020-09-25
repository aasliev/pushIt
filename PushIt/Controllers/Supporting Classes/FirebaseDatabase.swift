//
//  FirebaseDatabase.swift
//  PushIt
//
//  Created by Asliddin Asliev on 8/21/20.
//  Copyright © 2020 Asliddin Asliev. All rights reserved.
//

import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseCore
import FirebaseStorage
class FirebaseDatabase {

    //MARK: Firestore Database Istance
    let config = FirebaseApp.configure()
    let db : Firestore
    let authInstance : FirebaseAuth
    let storage = Storage.storage()

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
    let SEARCH_NAME_FIELD = "searchName"
    
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
            NUMBER_OF_CHALLENGES : 0,
            SEARCH_NAME_FIELD: "\(firstName.lowercased()) \(lastName.lowercased())"
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
    
    func addToFriend(currentUserEmail: String, friendInfo: searchFriend){
        
        path = "\(USERS_MAIN_COLLECTION)/\(currentUserEmail)/\(FRIENDS_SUB_COLLECTION)"
        ref = db.collection(path).document("\(friendInfo.email)")
        
        ref.setData([
            FRIENDS_LAST_NAME_FIELD: friendInfo.lastName,
            FRIENDS_FIRST_NAME_FIELD: friendInfo.firstName,
            FRIENDS_EMAIL_FIELD: friendInfo.email,
            NUMBER_OF_CHALLENGES: friendInfo.numOfChallenges
            
        ]){ err in
            _ = self.checkError(error: err, whileDoing: "adding friend to Friend Sub-Collection")
        }
        
        // get all data from friend
        
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
    
    //MARK: - Get the list of documents in sub collections
    //Common method to get all documents from sub collections, will be called from other get methods
    private func getDocuments (docPath : String, docMessage : String, completion: @escaping (Dictionary<Int , Dictionary<String  , Any>>)->())  {
        
        var dictionary : Dictionary<Int, Dictionary<String  , Any>> = [:]
        // db.collection("Users").document("as@li.com").collection("Friends")
        db.collection(docPath).getDocuments { (querySnapshot, error) in
            
            if (self.checkError(error: error , whileDoing: docMessage)) {
                var index = 0
                for document in querySnapshot!.documents {
                    dictionary[index] = document.data()
                    //dictionary[document.documentID] = document.data()
                    index += 1
                }
            }
            
            completion(dictionary)
        }
        
    }
    
    
    // Challenge Sub Collection
    func getChallenges(usersEmail : String, completion: @escaping (Dictionary<Int  , Dictionary<String  , Any>>)->()){
        path = "\(USERS_MAIN_COLLECTION)/\(usersEmail)/\(CHALLENGES_SUB_COLLECTION)"
        message = "getting data from challenges"
        
        getDocuments(docPath: path, docMessage: message) { (challengeDictionary) in
            
            completion(challengeDictionary)
        }
    }
    
    
    //MARK: Error
    func checkError (error: Error?, whileDoing: String) -> Bool{
        
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
    
    // MARK: - Update functions for challenge
    // users/usersEmail/challengeName
    // update last date skipped
    func updateChallengeField(usersEmail: String, challengeName: String,fieldName: String, data: Any){
        let path = "\(USERS_MAIN_COLLECTION)/\(usersEmail)/\(CHALLENGES_SUB_COLLECTION)"
        let ref = db.collection(path).document(challengeName)
        ref.updateData([
            fieldName: data
        ])
    }
    
    // get user's first and last name
    
    func getFirstLastName(usersEmail: String, completion: @escaping (String, String) ->()){
        var firstName = ""
        var lastName = ""
        db.collection(USERS_MAIN_COLLECTION).document(usersEmail).getDocument { (document, err) in
            if let document = document, document.exists {
                    
                firstName = document.get(self.FIRST_NAME_FIELD) as! String
                lastName = document.get(self.LAST_NAME_FIELD) as! String
                if (firstName != "" || lastName != ""){
                    completion(firstName, lastName)
                }
            }
        }
    }
    // get user info
    func getUserInfo(usersEmail: String, completion: @escaping (searchFriend) -> ()){
        var tmpUser = searchFriend()
        path = "\(USERS_MAIN_COLLECTION)/\(usersEmail)"
        db.collection(USERS_MAIN_COLLECTION).document(usersEmail).getDocument { (doc, err) in
            
            if let doc = doc, doc.exists {
                tmpUser.firstName = doc.get(self.FIRST_NAME_FIELD) as! String
                tmpUser.lastName = doc.get(self.LAST_NAME_FIELD) as! String
                tmpUser.email = doc.get(self.USER_EMAIL_FIELD) as! String
                tmpUser.numOfChallenges = doc.get(self.NUMBER_OF_CHALLENGES) as! Int
                if (!tmpUser.isEmpty()){
                    completion(tmpUser)
                }
            }
            
        }
    }
    
    
    // download profile picture from firebase storage
    func downloadprofilePicture(email: String, completion: @escaping (UIImage)->()){
        
        let storage = Storage.storage()
        // get referemce to storage
        let storageRef = storage.reference()
        //create a path
        let profileImageRef = storageRef.child("\(email)/profile.jpg")
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
               profileImageRef.getData(maxSize: 2 * 1024 * 1024) { data, error in
                 if let error = error {
                   // Uh-oh, an error occurred!
                   print(error.localizedDescription)
                   print("error downloading image")
                 } else {
                   // Data for "images/island.jpg" is returned
                    let image = UIImage(data: data!)!
                    completion(image)
                 }
               }
    }
    
    
}
