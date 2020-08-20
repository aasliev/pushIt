//
//  NotificationFunctions.swift
//  PushIt
//
//  Created by Asliddin Asliev on 6/23/20.
//  Copyright © 2020 Asliddin Asliev. All rights reserved.
//

import Foundation
import UserNotifications

/*
 I will need 2 type of notifications..
 1. Dayly notification: make a function that will ask for title, body and time.
 2. Once a time notification. (when its called)
 */




// creates a notification and adds it to notificatino center...
class notificationsFunctions{
    static let sharedNotificationsFunctions = notificationsFunctions()
    
    //func createNotification(
    
    func dailyNotification(title:String, body:String, time:DateComponents, identifier: String){
        // step1. Create content
        let content = self.notificationContent(title: title, body: body)
        // step2. Trigger (UNCalendarNotificationTrigger)
        let trigger = UNCalendarNotificationTrigger(dateMatching: time, repeats: true)
        // step 3. identifier
        let identifier = "PushIt.DailyNotification.\(identifier)"
        
        // step 4. add to notification center
        self.addNotification(trigger: trigger, content: content, identifier: identifier)
    }
    
    // Function to create content
    func notificationContent(title:String,body:String)->UNMutableNotificationContent{
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.userInfo = ["step":0]
        return content
    }
    
    // add notification to notification center
    func addNotification(trigger:UNNotificationTrigger,content:UNMutableNotificationContent, identifier:String){
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            self.printError(error, location: "Add request for identifier:" + identifier)
        }
    }
    
    // print error
    func printError(_ error: Error?, location: String){
           if let error = error {
               print("Error: \(error.localizedDescription) in \(location)")
           }
       }
}
