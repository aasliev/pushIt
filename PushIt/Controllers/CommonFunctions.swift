//
//  CommonFunctions.swift
//  PushIt
//
//  Created by Asliddin Asliev on 6/9/20.
//  Copyright © 2020 Asliddin Asliev. All rights reserved.
//

import Foundation
import UIKit

class CommonFunctions {
    static let sharedCommonFunction = CommonFunctions()
    
    // Creates UIAlert with the title (by default 'Error')
    func createUIalert(title : String = "Error", _ message : String, _ screen : UIViewController ) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        screen.present(alertController, animated: true, completion: nil)
    
    }
}
