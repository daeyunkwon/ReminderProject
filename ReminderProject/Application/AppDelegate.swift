//
//  AppDelegate.swift
//  ReminderProject
//
//  Created by 권대윤 on 7/2/24.
//

import UIKit

import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let config = Realm.Configuration(schemaVersion: 5) { migration, oldSchemaVersion in
            if oldSchemaVersion < 1 {
                
            }
            
            if oldSchemaVersion < 2 {
                migration.enumerateObjects(ofType: Reminder.className()) { oldObject, newObject in
                    guard let new = newObject else { return }
                    guard let old = oldObject else { return }
                    
                    
                    guard let dateString = old["deadline"] as? String else { return }
                    
                    let date = Date.makeStringToDate(str: dateString)
                    let doubleValue: Double = date.timeIntervalSince1970
                    
                    new["deadline"] = doubleValue
                }
            }
            
            if oldSchemaVersion < 3 {
                
            }
            
            if oldSchemaVersion < 5 {
                //deadline -> Date 타입으로 변경
            }
        }
        
        Realm.Configuration.defaultConfiguration = config
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

