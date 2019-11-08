//
//  challengesView.swift
//  PushIt
//
//  Created by Asliddin Asliev on 11/7/19.
//  Copyright © 2019 Asliddin Asliev. All rights reserved.
//

import UIKit
import CoreData

class challengesView: UITableViewController {

    var itemArray = [Challenge]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadItems()
    }
    
    
    //MARK: -  TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "challengeCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].name
        
        return cell
    }
    
    //MARK: -  TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
       
        self.performSegue(withIdentifier: "toShowView", sender: self)
//                context.delete(itemArray[indexPath.row])
//                itemArray.remove(at: indexPath.row)
//        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - Add New Challenges
    
    @IBAction func addNewChallenge(_ sender: UIBarButtonItem) {
//        var textField = UITextField()
//
//        let alert = UIAlertController(title: "Add New Challenge", message: "", preferredStyle: .alert)
//
//        let action = UIAlertAction(title: "Add Challenge", style: .default) { (action) in
//            //what will happen when the user clicks the add button
//            let newChallenge = Challenge(context: self.context)
//            newChallenge.name = textField.text!
//
//            self.loadItems()
//            self.saveItems()
        
//        }
//        alert.addTextField { (alertTextField) in
//            alertTextField.placeholder = "Create new challenge"
//            textField = alertTextField
//        }
//        alert.addAction(action)
//
//        present(alert, animated: true, completion: nil)
        
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
    
}


//MARK: - Search bar Method
extension challengesView: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Challenge> = Challenge.fetchRequest()
        request.predicate = NSPredicate(format: "nameOfTheChallenge CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "nameOfTheChallenge", ascending: true)]
        
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
