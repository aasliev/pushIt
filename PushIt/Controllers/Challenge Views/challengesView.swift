//
//  challengesView.swift
//  PushIt
//
//  Created by Asliddin Asliev on 11/7/19.
//  Copyright © 2019 Asliddin Asliev. All rights reserved.
//

import UIKit
import CoreData
import SwipeCellKit
import UserNotifications
import Firebase


class challengesView: UITableViewController {
    
    // instance of other classes
    //let firebaseAuth = Auth.auth()
    //let databaseIstance = FirebaseDatabase.shared
    //let authInstance = FirebaseAuth.sharedFirebaseAuth
    //let coreDataInstance = CoreDataClass.sharedCoreData
    let progressBarInstance = SVProgressHUDClass.shared
    let coreDataClassShared = CoreDataClass.sharedCoreData
    let firestoreClassShared = FirebaseDatabase.shared
    var itemArray = [Challenge]()
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.tabBarController?.tabBar.isHidden = false
        tableView.rowHeight = 60
        
        print("--------------")
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //print("viewDidAppear")
        //loadItems()
        itemArray = coreDataClassShared.loadChallenge()
        tableView.reloadData()
        self.navigationController?.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: -  TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "challengeCell", for: indexPath) as! SwipeTableViewCell
        cell.textLabel?.text = itemArray[indexPath.row].name
        cell.delegate = self
        
        return cell
    }
    
    //MARK: -  TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toShowView", sender: self)
        //                context.delete(itemArray[indexPath.row])
        //                itemArray.remove(at: indexPath.row)
        //        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShowView" {
            let destinationVC = segue.destination as! showChallengesView
            
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedChallenge = itemArray[indexPath.row]
            }
        } else if segue.identifier == "toProfileView"{
            if let destinationVC = segue.destination as? ProfileScreenView {
                destinationVC.modalPresentationStyle = .fullScreen
            }
            
        }
    }
    
    
}


//MARK: - Search bar Method
extension challengesView: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Challenge> = Challenge.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        
        //request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        itemArray = coreDataClassShared.loadChallenge(with: request)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count==0{
            itemArray = coreDataClassShared.loadChallenge()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            itemArray = coreDataClassShared.loadChallenge()
            tableView.reloadData()
        }
    }
    
}


extension challengesView: SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.coreDataClassShared.getContext().delete(self.itemArray[indexPath.row])
                //self.context.delete(self.itemArray[indexPath.row])
                // remove from firestore too
                self.firestoreClassShared.removeChallenge(challengeName: self.itemArray[indexPath.row].name!)
            print(self.itemArray[indexPath.row].name!)

                self.itemArray.remove(at: indexPath.row)
                // remove from firestore too
                self.coreDataClassShared.saveItems()
                self.tableView.reloadData()
                //self.saveItems()
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "trash-icon")
        
        return [deleteAction]
    }
    
    
}


extension UIViewController {
func hideKeyboardWhenTappedAround() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
}

@objc func dismissKeyboard() {
    view.endEditing(true)
}
    
    func moveScreenWithKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height-70
                
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

