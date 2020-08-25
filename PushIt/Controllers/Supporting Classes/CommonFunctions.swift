//
//  CommonFunctions.swift
//  PushIt
//
//  Created by Asliddin Asliev on 6/9/20.
//  Copyright © 2020 Asliddin Asliev. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import Firebase
class CommonFunctions {
    
    static let sharedCommonFunction = CommonFunctions()
    //static let sharedCommonFunction = CommonFunctions()

    // Creates UIAlert with the title (by default 'Error')
    func createUIalert(title : String = "Error", _ message : String, _ screen : UIViewController ) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        screen.present(alertController, animated: true, completion: nil)
    
    }
    
    // check if textField is empty
    func checkIfEmpty(_ textField: UITextField,_ placeholderText: String, screen: UIViewController) -> Bool{
        if textField.text!.isEmpty {
            //Making changes to inform user that text field is empty
            textField.attributedPlaceholder = NSAttributedString(string: placeholderText,
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            createUIalert("Add missing information.", screen)
            
            //textField.backgroundColor = UIColor.red
            return false
            
        }else{
            
            // Revert the changes made in if statment
            //textField.backgroundColor = UIColor.white
            textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            return true
            
        }
    }
    
    func showError(error: Error?,errorMsg: AuthErrorCode,screen: UIViewController) {
        
        switch errorMsg {
        
        case .networkError:
            createUIalert("Network Error.", screen)
            break
        case .userNotFound:
            createUIalert("Email Not Found!", screen)
            break
        case .wrongPassword:
           createUIalert("Email or Pasword is wrong", screen)
            break
        case .tooManyRequests:
            createUIalert("too many request", screen)
            break
        case .invalidEmail:
            createUIalert("Invalid Email", screen)
            break
        case .emailAlreadyInUse:
            createUIalert("Email is already in use.", screen)
            break
        case .weakPassword:
            createUIalert("weak password", screen)
            break
        default:
            createUIalert("Error occured. Please try again.", screen)
        }
    }
}



