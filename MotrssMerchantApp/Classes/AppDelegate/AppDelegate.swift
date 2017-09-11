/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  AppDelegate.swift
 
 Description: This is delegate class of the application.
 
 Created By: Pranay U.
 
 Creation Date: 25/06/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import UIKit
import IQKeyboardManagerSwift
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    //Initalize rechability for the network notification
    MTRechabilityManager.sharedInstance.startNotifier()

    //Testfairy Configuration
    TestFairy.begin(MTConstant.TestFairyAPIKey)
    
    //Added Keyboard Manager for an accesory view
    IQKeyboardManager.sharedManager().enable = true

    //Realm Db Configuration
    //Note: Need to update the schema version if there is change in DB models (For App Store Submission and also uncommnent the migrateAppDatabaseForNewVerion method)
    let currentRealmSchemaVersion:UInt64 = 0
    let config = Realm.Configuration (
      schemaVersion: currentRealmSchemaVersion)
    Realm.Configuration.defaultConfiguration = config
    //To log the default realm db file path
    /*MTLogger.log.info("Path ===> \(Realm.Configuration.defaultConfiguration.fileURL)")
     MTLogger.log.info("Version ===> \(Realm.Configuration.defaultConfiguration.schemaVersion)")*/
    /*//To migrate the realn db schema
    migrateAppDatabaseForNewVerion(updateVersionNumber: currentRealmSchemaVersion)*/
    
    let realm = try! Realm()
    let userInfo = realm.objects(MTUserInfo.self).first    
    if let authKey = userInfo?.authKey, authKey.characters.count>0 {
      //Go to the home screen
      MTCommonUtils.gotoAppHomeScreen()
    }
    
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    //FBSDKAppEvents.activateApp()
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }

  //MARK: Realm DB Migration
  /*func migrateAppDatabaseForNewVerion( updateVersionNumber: UInt64 ) {
    let config = Realm.Configuration(
      // Set the new schema version. This must be greater than the previously used
      // version (if you've never set a schema version before, the version is 0).
      schemaVersion: updateVersionNumber,
      
      // Set the block which will be called automatically when opening a Realm with
      // a schema version lower than the one set above
      migrationBlock: { migration, oldSchemaVersion in
        // We haven’t migrated anything yet, so oldSchemaVersion == 0
        if (oldSchemaVersion < updateVersionNumber) {
          // Nothing to do!
          // Realm will automatically detect new properties and removed properties
          // And will update the schema on disk automatically
        }
    })
    
    // Tell Realm to use this new configuration object for the default Realm
    Realm.Configuration.defaultConfiguration = config
  }*/
}
