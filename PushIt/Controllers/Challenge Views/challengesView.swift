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

    var itemArray = [Challenge]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        //loadItems()
        tableView.rowHeight = 80
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadItems()
        tableView.reloadData()
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
        }
    }
    
    
    //MARK: - Model Manipulation Methods
    
    func saveItems()
    {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
        
    }
    
    func loadItems(with request: NSFetchRequest<Challenge> = Challenge.fetchRequest()) {
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
    }
    
    // MARK: - log out function (for now, later it will be view profile)
    
    @IBAction func profileButtonPressed(_ sender: Any) {
        // log out and go to log in page
        let alert : UIAlertController
        alert = UIAlertController(title: "Sing out", message: "Do you want to sign out?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        
        //If user press 'yes', perform following functions
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            
           //this is for user on his/her profile screen.  This if function perform sign out procces
            self.performSignOut()
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    //MARK: Perform Sign Out
    func performSignOut () {
        self.progressBarInstance.displayProgressBar()
        //This function call sign out user from Firebase Auth
        FirebaseAuth.sharedFirebaseAuth.signOutCurrentUser()
        //self.coreDataInstance.resetAllEntities()
        self.navigationController?.navigationBar.isHidden = true;
        // get a reference to the app delegate
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        // call didFinishLaunchWithOptions, this will make HomeScreen as Root ViewController
        //Take user to Home Screen (Log In Screen), where user can log in.
        appDelegate?.applicationDidFinishLaunching(UIApplication.shared)
        self.progressBarInstance.dismissProgressBar()
    }
    
    
}


//MARK: - Search bar Method
extension challengesView: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Challenge> = Challenge.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        loadItems(with: request)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count==0{
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            loadItems()
            tableView.reloadData()
        }
    }
    
}


extension challengesView: SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                self.context.delete(self.itemArray[indexPath.row])
                self.itemArray.remove(at: indexPath.row)
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
}
