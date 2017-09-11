/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTEnums.swift
 
 Description: This class includes the constant used in applications.
 
 Created By: Pranay U.
 
 Creation Date: 25/06/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import UIKit

class MTEnums: NSObject {
  
  enum VehicleListType:Int {
    case none
    case twowheelar
    case car
    case electric
    case luxury
    case minitruck
  }
  
  enum VehicleTypeId: String {
    case none = ""
    case twowheelar = "1"
    case car        = "2"
    case electric   = "15"
    case luxury     = "7"
    case minitruck  = "3"
  }
  
  enum AppLoginType : String {
    case normal   = "N"
    case google   = "G"
    case facebook = "F"
  }
  
  enum OrdersSelectedType: Int {
    case none = 0
    case newOrders = 1
    case orderStatus = 2
    case orderHistory = 3
  }
  
  enum OffersSelectedType: Int {
    case none = 0
    case myOffers = 1
    case awaitingForApproval = 2
  }
  
  enum TeamMemberSelectedType: Int {
    case none = 0
    case myTeam = 1
    case awaitingForApproval = 2
  }
  
  enum OrderType: String {
    case none         = "None"
    case newOrders    = "NewOrders"
    case orderStatus  = "OrderStatus"
    case orderHistory = "OrderHistory"
  }
}
