//
//  SVProgressHUDClass.swift
//  PushIt
//
//  Created by Asliddin Asliev on 8/23/20.
//  Copyright © 2020 Asliddin Asliev. All rights reserved.
//

import Foundation
import SVProgressHUD

class SVProgressHUDClass {
    
    //Singleton
    static let shared = SVProgressHUDClass()
    
    private init() {
    }
    
    
    //MARK: Display Methods
    func displayProgressBar () {
        
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setDefaultAnimationType(SVProgressHUDAnimationType.native)
        SVProgressHUD.setForegroundColor(UIColor.red)           //Ring Color
        SVProgressHUD.setBackgroundColor(UIColor.red)        //HUD Color
        SVProgressHUD.setBackgroundLayerColor(UIColor.red)    //Background Color
        SVProgressHUD.show()
    }
    
    
    func displaySuccessSatus (successStatus: String) {
        SVProgressHUD.showSuccess(withStatus: successStatus)
    }
    
    func displayMessage (message : String) {
        SVProgressHUD.setMaximumDismissTimeInterval(1)
        SVProgressHUD.showInfo(withStatus: message)
    }
    
    func displayError (errorMsg: String) {
        SVProgressHUD.showError(withStatus: errorMsg)
    }
    
    
    func dismissProgressBar () {
        SVProgressHUD.dismiss()
    }

}
