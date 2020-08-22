//
//  SignInViewController.swift
//  PushIt
//
//  Created by Asliddin Asliev on 8/21/20.
//  Copyright © 2020 Asliddin Asliev. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    let commonFunctions = CommonFunctions.sharedCommonFunction
        //CommonFunctions.sharedCommonFunction

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    //MARK: - Sign In
    @IBAction func signInButtonPressed(_ sender: Any) {
        // Step 1:  check if textfields are not empty
        // Step 2: check if email is on firebase auth and password matches
        // Step 3: open challenges view
        
        if checkIfTextFieldIsEmpty(){
            // check firebase
            
            
        }
    }
    
    
    
    
    // MARK: - Additional funtions
    // returns true if not empty
    func checkIfTextFieldIsEmpty() -> Bool {
        
        let userNameCheckStatus = commonFunctions.checkIfEmpty(emailTextField, "Email", screen: self)
        let passwordCheckStatus =  commonFunctions.checkIfEmpty(passwordTextField, "Password", screen: self)
        return userNameCheckStatus && passwordCheckStatus
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
