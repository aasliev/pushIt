//
//  FriendsView.swift
//  PushIt
//
//  Created by Asliddin Asliev on 9/10/20.
//  Copyright © 2020 Asliddin Asliev. All rights reserved.
//

import UIKit


class FriendsView: UITableViewController{
    

    // arrau to hold Friends List
    var itemArray = [Friend]()
    
    
    // singletons
    let coreDataClassShared = CoreDataClass.sharedCoreData
    let firestoreClassShared = FirebaseDatabase.shared
    let firebaseAuthClassShared = FirebaseAuth.sharedFirebaseAuth
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.tabBarController?.tabBar.isHidden = false
        tableView.rowHeight = 60
        itemArray = coreDataClassShared.loadFriend()
    }

    override func viewDidAppear(_ animated: Bool) {
        itemArray = coreDataClassShared.loadFriend()
        tableView.reloadData()
    }
    
    // MARK: - Table DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 1
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! FriendsTableViewCell
        //cell.textLabel?.text = itemArray[indexPath.row].name
        cell.firstNameLastName.text = "\(itemArray[indexPath.row].friendsFirstName!) \(itemArray[indexPath.row].friendsLastName!)"
        // download image for each friend
        self.firestoreClassShared.downloadprofilePicture(email: itemArray[indexPath.row].friendsEmail!) { (image) in
            cell.profilePicture.image = image
        }
        
        return cell
    }
    
    
    //MARK: -  TableView Delegate Methods
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.performSegue(withIdentifier: "toShowView", sender: self)
//           
//        tableView.deselectRow(at: indexPath, animated: true)
//       }
//    
    
    
    
    //prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProfileView"{
        if let destinationVC = segue.destination as? ProfileScreenView {
            destinationVC.modalPresentationStyle = .fullScreen
            }
        }
    }
    
    
}

/*
extension FriendsView: SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
            
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
        self.coreDataClassShared.getContext().delete(self.itemArray[indexPath.row])
        //self.context.delete(self.itemArray[indexPath.row])
        // remove from firestore too
            self.firestoreClassShared.removeFriend(friendEmail: self.itemArray[indexPath.row].friendsEmail!)

        
        self.itemArray.remove(at: indexPath.row)
        // remove from firestore too
        self.coreDataClassShared.saveItems()
        self.tableView.reloadData()
        }
        // customize the action appearance
        deleteAction.image = UIImage(named: "trash-icon")
        
        return [deleteAction]
 
 }
    
}*/


