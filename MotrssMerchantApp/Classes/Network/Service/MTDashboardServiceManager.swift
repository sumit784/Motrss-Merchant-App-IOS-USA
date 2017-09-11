/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTDashboardServiceManager.swift
 
 Description: This class is used to get dashboard service.
 
 Created By: Pranay U.
 
 Creation Date: 25/07/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import UIKit
import Alamofire
import RealmSwift
import SwiftyJSON

class MTDashboardServiceManager: MTBaseServiceManager {
  
  /**
   Shared instance to prepare the singleton class of ProgressIndicator
   */
  static let sharedInstance = MTDashboardServiceManager()
  
  //This prevents others from using the default '()' initializer for this class.
  private override init() {
    super.init()
  }
  
  /// This service is used to get all merchant orders
  func getMerchantOrdersAndRevenue(fromDate: String, toDate: String, onSuccess successBlock: @escaping ((AnyObject) -> Void), onFailure failureBlock: @escaping ((AnyObject) -> Void)) {
    
    let requestURL = MTNetworkConfig.NetworkBase_URL + MTNetworkConfig.MerchantOrderInfo_URL
    
    let realm = try! Realm()
    let userInfo = realm.objects(MTUserInfo.self).first
    
    var parameters : Parameters = Parameters()
    parameters["YEK_HTUA_SW"] = self.getCurrentTimeStamp()
    parameters["merchant_id"] = userInfo?.merchantID

    if toDate.characters.count>0 {
      parameters["to_date"] = toDate
    }
    if fromDate.characters.count>0 {
      parameters["from_date"] = fromDate
    }
    
    MTLogger.log.info("getMerchantOrdersAndRevenue: \(parameters)")
    
    // get a session manager and add the request adapter
    let sessionManager = Alamofire.SessionManager.default
    sessionManager.adapter = MTServiceHeadersAdapter()
    
    // make calls with the session manager
    sessionManager.request(requestURL, method: .post, parameters: parameters, encoding: URLEncoding.default)
      .validate { request, response, data in
        return .success
      }
      .response { response in
        
        if let error  = response.error {
          MTLogger.log.info("getMerchantOrdersAndRevenue error: \(error.localizedDescription)")
          MTCommonUtils.showAlertViewWithTitle(title: "", message: error.localizedDescription)
          failureBlock(false as AnyObject)
          
        } else if let data = response.data, let response = String(data: data, encoding: .utf8) {
          MTLogger.log.info("getMerchantOrdersAndRevenue Response: \(response)")
          
          let jsonResponse = self.convertToDictionary(text: response)
          if (self.isErrorMessage(responseDict: jsonResponse)) {
            successBlock(false as AnyObject)
          } else {
            let jsonData = JSON(jsonResponse!)
            if let status = jsonData["Status"].string, status == "Success" {
              
              if let dataDict = jsonData["Data"].dictionary {
                
                let realm = try! Realm()
                try! realm.write {
                  realm.delete(realm.objects(MTEarningsDetailInfo.self))
                }
                
                let earningInfo = MTEarningsDetailInfo()
                
                if let totalEarnArr = dataDict["totalEarn"]?.array {
                  for total in totalEarnArr {
                    if let value = total["totalEarnMerch"].string {
                      earningInfo.totalEarningMerchant = value
                    }
                    if let value = total["totalEarnAll"].string {
                      earningInfo.totalEarningAll = value
                    }
                  }
                }
                
                if let balAmountArr = dataDict["balAmount"]?.array {
                  for total in balAmountArr {
                    if let value = total["totalBalMerch"].string {
                      earningInfo.totalBalanceMerchant = value
                    }
                    if let value = total["totalBalAll"].string {
                      earningInfo.totalBalanceAll = value
                    }
                  }
                }
                
                if let currMonthEarnArr = dataDict["currMonthEarn"]?.array {
                  for total in currMonthEarnArr {
                    if let value = total["monthEarnMerch"].string {
                      earningInfo.monthEarningMerchant = value
                    }
                    if let value = total["monthEarnAll"].string {
                      earningInfo.monthEarningAll = value
                    }
                  }
                }
                
                try! realm.write {
                  realm.add(earningInfo)
                }
              }
              successBlock(true as AnyObject)
            } else {
              failureBlock(false as AnyObject)
            }
          }
        }
    }
  }
  
  func getMerchantTimeSlots(onSuccess successBlock: @escaping ((AnyObject) -> Void), onFailure failureBlock: @escaping ((AnyObject) -> Void)) {
    
    let requestURL = MTNetworkConfig.NetworkBase_URL + MTNetworkConfig.GetMerchantSlots_URL
    
    let realm = try! Realm()
    let userInfo = realm.objects(MTUserInfo.self).first
    
    var parameters : Parameters = Parameters()
    parameters["YEK_HTUA_SW"] = self.getCurrentTimeStamp()
    parameters["merchant_id"] = userInfo?.merchantID
    
    MTLogger.log.info("getMerchantTimeSlots: \(parameters)")
    
    // get a session manager and add the request adapter
    let sessionManager = Alamofire.SessionManager.default
    sessionManager.adapter = MTServiceHeadersAdapter()
    
    // make calls with the session manager
    sessionManager.request(requestURL, method: .post, parameters: parameters, encoding: URLEncoding.default)
      .validate { request, response, data in
        return .success
      }
      .response { response in
        
        if let error  = response.error {
          MTLogger.log.info("getMerchantTimeSlots error: \(error.localizedDescription)")
          MTCommonUtils.showAlertViewWithTitle(title: "", message: error.localizedDescription)
          failureBlock(false as AnyObject)
          
        } else if let data = response.data, let response = String(data: data, encoding: .utf8) {
          MTLogger.log.info("getMerchantTimeSlots Response: \(response)")
          
          let jsonResponse = self.convertToDictionary(text: response)
          if (self.isErrorMessage(responseDict: jsonResponse)) {
            successBlock(false as AnyObject)
          } else {
            let jsonData = JSON(jsonResponse!)
            if let status = jsonData["Status"].string, status == "Success" {
              
              
              if let dataDict = jsonData["Data"].dictionary {
                
                if let slotsArr = dataDict["MerchantSlots"]?.array {
                  
                  let realm = try! Realm()
                  try! realm.write {
                    realm.delete(realm.objects(MTMerchantSlotsInfo.self))
                  }
                  
                  for slotDict in slotsArr {
                    
                    let merchantSlotsInfo = MTMerchantSlotsInfo()
                    
                    if let value = slotDict["merchant_time_schedule_id"].string {
                      merchantSlotsInfo.merchantTimeScheduleId = value
                    }
                    if let value = slotDict["Merchant_id"].string {
                      merchantSlotsInfo.merchantId = value
                    }
                    if let value = slotDict["Date"].string {
                      merchantSlotsInfo.date = value
                    }
                    if let value = slotDict["Date_id"].string {
                      merchantSlotsInfo.dateId = value
                    }
                    if let value = slotDict["is_open"].string {
                      merchantSlotsInfo.isOpen = value
                    }

                    if let slotsDataArr = slotDict["slots"].array {
                      
                      for slotDataDict in slotsDataArr {
                        let slotsInfo = MTSlotsData()
                        
                        if let value = slotDataDict["schedule_map_id"].string {
                          slotsInfo.scheduleMapId = value
                        }
                        if let value = slotDataDict["schedule_slot_name"].string {
                          slotsInfo.scheduleSlotName = value
                        }
                        if let value = slotDataDict["schedule_slot_time"].string {
                          slotsInfo.scheduleSlotTime = value
                        }
                        if let value = slotDataDict["slot_capacity"].string {
                          slotsInfo.slotCapacity = value
                        }
                        
                        merchantSlotsInfo.slots.append(slotsInfo)
                      }
                    }
                    
                    try! realm.write {
                      realm.add(merchantSlotsInfo)
                    }
                  }
                  successBlock(true as AnyObject)
                } else {
                  failureBlock(false as AnyObject)
                }
              } else {
                failureBlock(false as AnyObject)
              }
            } else {
              failureBlock(false as AnyObject)
            }
          }
        }
    }
  }

  func updateMerchantTimeSlots(timeslotInfo: MTMerchantSlotsInfo, onSuccess successBlock: @escaping ((AnyObject) -> Void), onFailure failureBlock: @escaping ((AnyObject) -> Void)) {
    
    let requestURL = MTNetworkConfig.NetworkBase_URL + MTNetworkConfig.UpdateMerchantSlots_URL
    
    let realm = try! Realm()
    let userInfo = realm.objects(MTUserInfo.self).first
    
    var parameters : Parameters = Parameters()
    parameters["YEK_HTUA_SW"] = self.getCurrentTimeStamp()
    parameters["merchant_id"] = userInfo?.merchantID
    parameters["merch_time_schld_id"] = timeslotInfo.merchantTimeScheduleId
    if timeslotInfo.isOpen == "1" {
      parameters["is_open"] = "1"
    } else {
      parameters["is_open"] = "00"
    }
    for (index, element) in timeslotInfo.slots.enumerated() {
      let keyStr = "slot" + "\(index+1)" + "_capacity"
      if element.slotCapacity == "0" {
        parameters[keyStr] = "00"
      } else {
        parameters[keyStr] = element.slotCapacity
      }
    }
    
    MTLogger.log.info("updateMerchantTimeSlots: \(parameters)")
    
    // get a session manager and add the request adapter
    let sessionManager = Alamofire.SessionManager.default
    sessionManager.adapter = MTServiceHeadersAdapter()
    
    // make calls with the session manager
    sessionManager.request(requestURL, method: .post, parameters: parameters, encoding: URLEncoding.default)
      .validate { request, response, data in
        return .success
      }
      .response { response in
        
        if let error  = response.error {
          MTLogger.log.info("updateMerchantTimeSlots error: \(error.localizedDescription)")
          MTCommonUtils.showAlertViewWithTitle(title: "", message: error.localizedDescription)
          failureBlock(false as AnyObject)
          
        } else if let data = response.data, let response = String(data: data, encoding: .utf8) {
          MTLogger.log.info("updateMerchantTimeSlots Response: \(response)")
          
          let jsonResponse = self.convertToDictionary(text: response)
          if (self.isErrorMessage(responseDict: jsonResponse)) {
            successBlock(false as AnyObject)
          } else {
            let jsonData = JSON(jsonResponse!)
            if let status = jsonData["Status"].string, status == "Success" {
              successBlock(true as AnyObject)
            } else {
              failureBlock(false as AnyObject)
            }
          }
        }
    }
  }
}


