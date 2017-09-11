/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTBookingServiceDataModel.swift
 
 Description: This class is used for booking details model.
 
 Created By: Pranay U.
 
 Creation Date: 25/06/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import UIKit

class MTBookingServiceDataModel: NSObject {
  
  /**
   Shared instance to prepare the singleton class of ProgressIndicator
   */
  static let sharedInstance = MTBookingServiceDataModel()
  
  //This prevents others from using the default '()' initializer for this class.
  private override init() {
    super.init()
  }
  
  func resetDataModel() {

  }
}

class MTBookingReceiptDataModel: NSObject {
  var itemName = ""
  var itemValue = ""
  var isCategory = false
  var itemCatID = ""
}

class MTOrderStatusDataModel: NSObject {
  var itemName = ""
  var itemStatus = ""
  var itemUpdateStatusButton = ""
  var itemIsUpdated = false
}
