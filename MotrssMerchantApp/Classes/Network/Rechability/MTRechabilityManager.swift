/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTRechabilityManager.swift
 
 Description: This class is used initiality the rechability which get updated on the network notification.
 
 Created By: Pranay U.
 
 Creation Date: 25/06/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import UIKit
import ReachabilitySwift

class MTRechabilityManager: NSObject {
  
  /**
   Shared instance to prepare the singleton class of ProgressIndicator
   */
  static let sharedInstance = MTRechabilityManager()
  /**
   rechablity object
   */
  private var reachability: Reachability! = nil
  
  var isRechable: Bool = false
		
  //This prevents others from using the default '()' initializer for this class.
  private override init() {
    super.init()
    
    initRechability()
  }
  
  private func initRechability() -> Void {
    reachability = Reachability()!
  }
  
  /// This function is usd to start notifier for the internet rechability
  func startNotifier() -> Void {
    
    if reachability != nil {
      reachability.whenReachable = { reachability in
        // this is called on a background thread, but UI updates must
        // be on the main thread, like this:
        DispatchQueue.main.async {
          if reachability.isReachableViaWiFi {
            MTLogger.log.info("Reachable via WiFi")
            self.isRechable = true
          } else {
            MTLogger.log.info("Reachable via Cellular")
            self.isRechable = true
          }
        }
      }
      reachability.whenUnreachable = { reachability in
        // this is called on a background thread, but UI updates must
        // be on the main thread, like this:
        DispatchQueue.main.async {
          MTLogger.log.info("Not reachable")
          self.isRechable = false
        }
      }
      
      do {
        try reachability.startNotifier()
      } catch {
        MTLogger.log.info("Unable to start notifier")
      }
    }
  }
  
  /// Stop notifier
  func stopNotifier() -> Void {
    if reachability != nil {
      reachability.stopNotifier()
    }
  }
}
