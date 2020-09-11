//
//  ProfileScreenView.swift
//  PushIt
//
//  Created by Asliddin Asliev on 9/9/20.
//  Copyright © 2020 Asliddin Asliev. All rights reserved.
//

import UIKit

class ProfileScreenView: UIViewController {
    
    let progressBarInstance = SVProgressHUDClass.shared
    let coreDataClassShared = CoreDataClass.sharedCoreData
    let firestoreClassShared = FirebaseDatabase.shared
    let fireAuthClassShared = FirebaseAuth.sharedFirebaseAuth

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var firstNameLastNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.tabBarController?.tabBar.isHidden = true
        // Do any additional setup after loading the view.
        //setting up profile picture
        setProfilePicture()
        setProfile()
    }
    
    // set profilePicture
    func setProfilePicture(){
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width/2
        profilePicture.clipsToBounds = true
        profilePicture.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        profilePicture.addGestureRecognizer(tapGesture)
    }
    
    @objc func presentPicker(){
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    
    // function to set up profile
    func setProfile(){
        self.progressBarInstance.displayProgressBar()
        self.firestoreClassShared.getFirstLastName(usersEmail: self.fireAuthClassShared.getCurrentUserEmail()) { (fName, lName) in
            self.firstNameLastNameLabel.text = "\(fName) \(lName)"
            
        }
        self.progressBarInstance.dismissProgressBar()
        
    }
    
    
    @IBAction func signOutButtonPressed(_ sender: Any) {
        let alert : UIAlertController
        alert = UIAlertController(title: "Sing out", message: "Do you want to sign out?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        
        //If user press 'yes', perform following functions
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            
           //this is for user on his/her profile screen.  This if function perform sign out procces
            self.performSignOut()
            //self.coreDataClassShared.coreDataUpdated = false
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func xButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: Perform Sign Out
    func performSignOut () {
        self.progressBarInstance.displayProgressBar()
        //This function call sign out user from Firebase Auth
        FirebaseAuth.sharedFirebaseAuth.signOutCurrentUser()
        self.coreDataClassShared.resetAllEntities()
        self.navigationController?.navigationBar.isHidden = true;
        // get a reference to the app delegate
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        // call didFinishLaunchWithOptions, this will make HomeScreen as Root ViewController
        //Take user to Home Screen (Log In Screen), where user can log in.
        appDelegate?.applicationDidFinishLaunching(UIApplication.shared)
        self.progressBarInstance.dismissProgressBar()
    }
    
    
}

extension ProfileScreenView: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            profilePicture.image = imageSelected
        }
        
        if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            profilePicture.image = originalImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
