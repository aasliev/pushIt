//
//  SignUpViewController.swift
//  PushIt
//
//  Created by Asliddin Asliev on 8/21/20.
//  Copyright © 2020 Asliddin Asliev. All rights reserved.
//

import UIKit
import Firebase
class SignUpViewController: UIViewController {
    
    
    let commonFunctions = CommonFunctions.sharedCommonFunction
    let progressBarInstance = SVProgressHUDClass.shared
    let databaseInstance = FirebaseDatabase.shared
    let authInstance = FirebaseAuth.sharedFirebaseAuth

    var userNameAdded = false
    var dataAddedIntoFirestore = false

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func checkIfTextFieldIsEmpty() -> Bool {
        let firstNameCheckStatus = commonFunctions.checkIfEmpty(firstNameTextField, "First Name", screen: self)
        let lastNameCheckStatus = commonFunctions.checkIfEmpty(lastNameTextField, "Last Name", screen: self)
        let emailCheckStatus =  commonFunctions.checkIfEmpty(emailTextField, "Email", screen: self)
        let passwordCheckStatus =  commonFunctions.checkIfEmpty(passwordTextField, "Password", screen: self)
        let confirmPasswordCheckStatus =  commonFunctions.checkIfEmpty(confirmPasswordTextField, "Confirm Password", screen: self)
        
        return firstNameCheckStatus && lastNameCheckStatus && emailCheckStatus && passwordCheckStatus && confirmPasswordCheckStatus
    }
    
    func checkPassword(_ pswd1: String,_ pswd2: String ) -> Bool{
        
        if (pswd1 == pswd2){
            return true
        }
        return false
        
    }
    
    func chechError(_ error: Error?){
        
        if error != nil {
            
            if let errorMsg = AuthErrorCode(rawValue: (error! as AnyObject).code){
                self.commonFunctions.showError(error: error, errorMsg: errorMsg, screen: self)
            }
        } else {
            self.databaseInstance.addNewUserToFirestore(firstName: self.firstNameTextField.text!, lastName: self.lastNameTextField.text!, email: self.emailTextField.text!){ boolean in
                
                print("Completion called from firestore \(boolean)")
                if boolean {
                    self.dataAddedIntoFirestore = true
                    
                    //This waits untill username is added
                    if (self.userNameAdded) {
                        // get a reference to the app delegate
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        
                        // call didFinishLaunchWithOptions, this will make HomeScreen as Root ViewController
                        //Take user to Home Screen (Log In Screen), where user can log in.
                        appDelegate?.applicationDidFinishLaunching(UIApplication.shared)
                        
                    }
                }
                }
            //addUserNameAndPerformSegue()
       // }
        //else {
        // get a reference to the app delegate
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        
        // call didFinishLaunchWithOptions, this will make HomeScreen as Root ViewController
        //Take user to Home Screen (Log In Screen), where user can log in.
        appDelegate?.applicationDidFinishLaunching(UIApplication.shared) }
    }
    

    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        // step 1: check if textFeilds are not empty
        // step 2: check if email is not taken
        // step 3: check if passwords match
        // step 4: create an account
        // step 5: open challenges view
        
        self.progressBarInstance.displayProgressBar()
        if(checkIfTextFieldIsEmpty()){
            if !checkPassword(passwordTextField.text!, confirmPasswordTextField.text!){
                // pswrds are not matching
                self.commonFunctions.createUIalert("Passwords are not matching.", self)
            } else {
                // pswrds are matching
                Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                    self.chechError(error)
                }
                
            }
            
        }
        self.progressBarInstance.dismissProgressBar()
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
