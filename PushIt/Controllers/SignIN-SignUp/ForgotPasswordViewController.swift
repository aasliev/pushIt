//
//  ForgotPasswordViewController.swift
//  PushIt
//
//  Created by Asliddin Asliev on 8/21/20.
//  Copyright © 2020 Asliddin Asliev. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    var success = true

    let commonFunctions = CommonFunctions.sharedCommonFunction
    let authInstance = FirebaseAuth.sharedFirebaseAuth
    let progressBarInstance = SVProgressHUDClass.shared
    
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        hideKeyboardWhenTappedAround()
    }
    

    @IBAction func resetButtonPressed(_ sender: Any) {
        // step 1: show message saying that email has been sent
        // step 2: go back to login page.
        //var success = true
        progressBarInstance.displayProgressBar()
            
            if (commonFunctions.checkIfEmpty(emailTextField, "Email", screen: self)) {
                
                authInstance.resetPassword(email: emailTextField.text!, viewController: self) { boolean in
                    if !boolean {
                        self.success = false
                    }
                }
            }
        self.progressBarInstance.dismissProgressBar()

        }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToLogInPage" {
            if self.success{
                //self.progressBarInstance.displayError(errorMsg: "Please check your email to reset password.")
                self.commonFunctions.createUIalert("Please check your email to reset your password.", self)
            } else {
                //check
            }
        }
    }
   // @IBAction func unwindToLogInScreen(_ sender: UIStoryboardSegue){
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


