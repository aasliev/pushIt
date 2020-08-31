//
//  SignInViewController.swift
//  PushIt
//
//  Created by Asliddin Asliev on 8/21/20.
//  Copyright © 2020 Asliddin Asliev. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {

    let commonFunctions = CommonFunctions.sharedCommonFunction
        //CommonFunctions.sharedCommonFunction
    let authInstance = FirebaseAuth.sharedFirebaseAuth
    let progressBarInstance = SVProgressHUDClass.shared

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // hide keyboard
        self.hideKeyboardWhenTappedAround()
    }
    //MARK: - Sign In
    @IBAction func signInButtonPressed(_ sender: Any) {
        // Step 1:  check if textfields are not empty
        // Step 2: check if email is on firebase auth and password matches
        // Step 3: open challenges view
        self.progressBarInstance.displayProgressBar()
        if checkIfTextFieldIsEmpty(){
            // check firebase
            let firebaseAuth = Auth.auth()
            firebaseAuth.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user , error) in
                           
            if (error != nil){
                if let errorMsg = AuthErrorCode(rawValue: error!._code){
                                   
                    //Method inside additionalFunction class shows error
                    self.progressBarInstance.dismissProgressBar()
                    self.commonFunctions.showError(error: error, errorMsg: errorMsg, screen: self)
                    }
                } else{
                //This method updates the currentUser variable which keeps track of email of currently logged in user
                //CoreDataClass.sharedCoreData.updateCoreData()
                //self.authInstance.updateCurrentUser()
                
                //self.updateCoreData { () -> () in
                self.authInstance.updateCurrentUser()
                CoreDataClass.sharedCoreData.updateCoreData()
                
                //self.commonFunctions.createUIalert(title: "Welcome Back", "Please wait while we are loading data.", self)
                
                
                let alertController = UIAlertController(title: "Loading Data", message: "Please wait while we are loading data.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    //self.loadItems()
                    //self.tableView.reloadData()
                    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                    // call didFinishLaunchWithOptions, this will make HomeScreen as Root ViewController
                    //Take user to Home Screen (Log In Screen), where user can log in.
                    appDelegate?.applicationDidFinishLaunching(UIApplication.shared)
                }))
                self.present(alertController, animated: true, completion: nil)
                

            }
        }
            
        }
        self.progressBarInstance.dismissProgressBar()

    }
    
    /*func updateCoreData(completion: ()->()){
        CoreDataClass.sharedCoreData.updateCoreData()
        completion()
    }
    */
    
    @IBAction func unwindToLogInScreen(_ sender: UIStoryboardSegue){}

    
    
    // MARK: - Additional funtions
    // returns true if not empty
    func checkIfTextFieldIsEmpty() -> Bool {
        
        let userNameCheckStatus = commonFunctions.checkIfEmpty(emailTextField, "Email", screen: self)
        let passwordCheckStatus =  commonFunctions.checkIfEmpty(passwordTextField, "Password", screen: self)
        return userNameCheckStatus && passwordCheckStatus
    }
    
//firestore.instence.collection('users').getDocument('asli@1.2').collection(friends_sub_collection).getDocument().where(friends_email='rv.1@2.com')
    
}

