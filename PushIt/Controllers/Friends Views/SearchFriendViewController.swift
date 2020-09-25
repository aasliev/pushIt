//
//  SearchFriendViewController.swift
//  PushIt
//
//  Created by Asliddin Asliev on 9/14/20.
//  Copyright © 2020 Asliddin Asliev. All rights reserved.
//

import UIKit
import CoreData
import FirebaseFirestore

struct searchFriend{
    var firstName: String
    var lastName: String
    var email: String
    var numOfChallenges: Int
    init() {
        firstName = ""
        lastName = ""
        email = ""
        numOfChallenges = 0
    }
    
    func isEmpty() -> Bool{
        if (firstName == "" && lastName == "" && email == "" && numOfChallenges == 0){
            return true}
        return false
    }
}

class SearchFriendViewController: UITableViewController {

    // singletons
    let coreDataClassShared = CoreDataClass.sharedCoreData
    let firestoreClassShared = FirebaseDatabase.shared
    let firebaseAuthClassShared = FirebaseAuth.sharedFirebaseAuth
    
    
    
    var searchResult = [searchFriend]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.keyboardWillHide(notification: <#T##NSNotification#>)
        tableView.rowHeight = 60

    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchResult.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchIdentifier", for: indexPath) as! SearchFriendsTableViewCell

        // Configure the cell...
        cell.firstNameLastName.text = "\(searchResult[indexPath.row].firstName) \(searchResult[indexPath.row].lastName)"
        //cell.profilePicture.image
        self.firestoreClassShared.downloadprofilePicture(email: searchResult[indexPath.row].email) { (image) in
            cell.profilePicture.image = image
        }
        cell.email.text = searchResult[indexPath.row].email
        if (self.checkIfFriend(email: searchResult[indexPath.row].email)){ // friends
            if #available(iOS 13.0, *) {
                cell.addButton.setImage(UIImage(systemName: "person.badge.minus"), for: .normal)
                cell.addButton.isEnabled = false
            } else {
                // Fallback on earlier versions
                cell.addButton.isHidden = true
                cell.addButton.isEnabled = false
            }
        }
        return cell
    }
    
    
    
    func loadSearchData(text: String, completion: @escaping ()->()){
        print("looking for: \(text)")
        searchResult.removeAll()
        var user = searchFriend()
        
        let ref = firestoreClassShared.db
        let searchName = firestoreClassShared.SEARCH_NAME_FIELD
        
        ref.collection(firestoreClassShared.USERS_MAIN_COLLECTION).order(by: searchName).limit(to: 10).whereField(searchName, isGreaterThanOrEqualTo: text.lowercased()).whereField(searchName, isLessThanOrEqualTo: text.lowercased() + "\u{f8ff}").getDocuments { (querySnapshot, err) in
            
            if err?.localizedDescription == nil {
            //print("inside ref")
            print(querySnapshot?.documents.count as Any)
            
            for doc in querySnapshot!.documents{
                print("Data: ", doc.data())
                user.email = (doc.data()[self.firestoreClassShared.USER_EMAIL_FIELD] as! String)
                user.lastName = (doc.data()[self.firestoreClassShared.LAST_NAME_FIELD] as! String)
                user.firstName = (doc.data()[self.firestoreClassShared.FIRST_NAME_FIELD] as! String)
                user.numOfChallenges = (doc.data()[self.firestoreClassShared.NUMBER_OF_CHALLENGES] as! Int)
                //print(user as Any)
                self.searchResult.append(user)
                completion()
            }
            } else {
                print("error")
                print(err?.localizedDescription as Any)
                //return
            }
            
        }
    }
    
    // check if Friends...
    // return true if friends, false otherwise
    func checkIfFriend (email : String) -> Bool {

        let request: NSFetchRequest<Friend> = Friend.fetchRequest()
        let predicate = NSPredicate(format: "friendsEmail == %@", email)
        request.predicate = predicate
        request.fetchLimit = 1
        
        do{
            let count = try CoreDataClass.sharedCoreData.getContext().count(for: request)
            if(count == 0){
                // no matching object
                return false
            }
            else{
                // at least one matching object exists
                print("Match Found!")
                return true
            }
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return false
        }
    }

}

extension SearchFriendViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // load data to searchResult
        // call function
        self.loadSearchData(text: searchBar.text!.lowercased()) {
            print("inside search(number of data): ", self.searchResult.count)
            self.tableView.reloadData()
        }
//        //self.loadSearchData(text: searchBar.text!.lowercased())
//        print("inside seach(number of data): ", searchResult.count)
//        for data in searchResult{
//            print("inside search: " ,data)
//        }
//        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //if character count == 0, clear searchResult
        if searchBar.text?.count == 0 {
            searchResult.removeAll()
        }
        
        tableView.reloadData()
        
    }
    
}
