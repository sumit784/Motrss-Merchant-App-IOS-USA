/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTLogger.swift
 
 Description: This is the logger class used to log the dubug text.
 
 Created By: Pranay U.
 
 Creation Date: 25/06/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */


import Foundation
import XCGLogger

class MTLogger: NSObject {
  
  static let log: XCGLogger = {
    let log = XCGLogger(identifier: "MTLogger", includeDefaultDestinations: false)
    
    //Customize as needed
    
    //Create a destination for the system console log (via NSLog)
    let systemDestination = AppleSystemLogDestination(identifier: "MTLogger.systemDestination")
    
    //configuration options
    #if DEBUG
      systemDestination.outputLevel = .debug
    #else
      systemDestination.outputLevel = .none
    #endif
    //systemDestination.outputLevel = .debug
    systemDestination.showLogIdentifier = false
    systemDestination.showFunctionName = true
    systemDestination.showThreadName = true
    systemDestination.showLevel = true
    systemDestination.showFileName = true
    systemDestination.showLineNumber = true
    systemDestination.showDate = true
    
    //Add the destination to the logger
    log.add(destination: systemDestination)
    
    //Add basic app info, version info etc, to the start of the logs
    log.logAppDetails()
    
    return log
  }()
}

