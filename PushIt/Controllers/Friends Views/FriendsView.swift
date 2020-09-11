//
//  FriendsView.swift
//  PushIt
//
//  Created by Asliddin Asliev on 9/10/20.
//  Copyright © 2020 Asliddin Asliev. All rights reserved.
//

import UIKit

class FriendsView: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.tabBarController?.tabBar.isHidden = false

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProfileView"{
        if let destinationVC = segue.destination as? ProfileScreenView {
            destinationVC.modalPresentationStyle = .fullScreen
        }
        }
        
        
    }
    
}
