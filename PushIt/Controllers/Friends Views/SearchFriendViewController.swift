//
//  SearchFriendViewController.swift
//  PushIt
//
//  Created by Asliddin Asliev on 9/14/20.
//  Copyright © 2020 Asliddin Asliev. All rights reserved.
//

import UIKit
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
        return cell
    }
    
    
    // load data from firestore to searchResult
    // func to search by email
    /*class func findUsers(text: String)->Void{
        ref.child("Users").queryOrderedByChild("name").queryStartingAtValue(text).queryEndingAtValue(text+"\u{f8ff}").observeEventType(.Value, withBlock: { snapshot in
            var user = User()
            var users = [User]()
            for u in snapshot.children{
                user.name = u.value!["name"] as? String
                ...
                users.append(user)
            }
            self.users = users
        })
    }*/
    
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
                print(err?.localizedDescription)
                //return
            }
            
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
