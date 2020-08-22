//
//  LaunchScreenViewController.swift
//  PushIt
//
//  Created by Asliddin Asliev on 8/21/20.
//  Copyright © 2020 Asliddin Asliev. All rights reserved.
//

import UIKit
import Firebase

class LaunchScreenViewController: UINavigationController {

    var window: UIWindow?
    //let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
    //let signInStoryBoard = UIStoryboard(name: "SignIn:SignUp", bundle: nil)
    let user = Auth.auth().currentUser
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // if user is logged in go to
        if user != nil {
            // User is signed in.
            print("Automatic Sign In: \(String(describing: user?.email))")
            //let initialViewController = mainStoryBoard.instantiateViewController(withIdentifier: "ChallengesView")

            //self.window!.rootViewController = initialViewController

        } else {
            // No user is signed in.
            //let initialViewController = signInStoryBoard.instantiateViewController(withIdentifier: "SignInView")
            //self.window!.rootViewController = initialViewController
            performSegue(withIdentifier: "toSignInView", sender: self)
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSignInView" {
            guard let vc = segue.destination as? SignInViewController else { return }
            //vc.segueText = segueTextField.text
        }
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
