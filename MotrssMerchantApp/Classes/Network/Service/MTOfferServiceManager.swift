/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTOfferServiceManager.swift
 
 Description: This class is used to get offer service.
 
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

class MTOfferServiceManager: MTBaseServiceManager {
  
  /**
   Shared instance to prepare the singleton class of ProgressIndicator
   */
  static let sharedInstance = MTOfferServiceManager()
  
  //This prevents others from using the default '()' initializer for this class.
  private override init() {
    super.init()
  }
  
  /// This service is used to get all merchant orders
  func getAllMerchantOffers(onSuccess successBlock: @escaping ((AnyObject) -> Void), onFailure failureBlock: @escaping ((AnyObject) -> Void)) {
    
    let requestURL = MTNetworkConfig.NetworkBase_URL + MTNetworkConfig.GetMerchantOffer_URL
    
    let realm = try! Realm()
    let userInfo = realm.objects(MTUserInfo.self).first
    
    var parameters : Parameters = Parameters()
    parameters["YEK_HTUA_SW"] = self.getCurrentTimeStamp()
    parameters["merchant_id"] = userInfo?.merchantID
    
    MTLogger.log.info("getAllMerchantOffers: \(parameters)")
    
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
          MTLogger.log.info("getAllMerchantOffers error: \(error.localizedDescription)")
          MTCommonUtils.showAlertViewWithTitle(title: "", message: error.localizedDescription)
          failureBlock(false as AnyObject)
          
        } else if let data = response.data, let response = String(data: data, encoding: .utf8) {
          MTLogger.log.info("getAllMerchantOffers Response: \(response)")
          
          let jsonResponse = self.convertToDictionary(text: response)
          if (self.isErrorMessage(responseDict: jsonResponse)) {
            successBlock(false as AnyObject)
          } else {
            let jsonData = JSON(jsonResponse!)
            if let status = jsonData["Status"].string, status == "Success" {
              
              if let dataArray = jsonData["Data"].array {
                
                let realm = try! Realm()
                //Delete All Products Obj
                try! realm.write {
                  realm.delete(realm.objects(MTOffersDetailInfo.self))
                }
                
                for dictionary in dataArray {
                  
                  let offersInfo = MTOffersDetailInfo()
                  
                  if let offerId = dictionary["offer_id"].string {
                    offersInfo.offerId = offerId
                  }
                  if let value = dictionary["offer_name"].string {
                    offersInfo.offerName = value
                  }
                  if let value = dictionary["offer_code"].string {
                    offersInfo.offerCode = value
                  }
                  if let value = dictionary["description"].string {
                    offersInfo.offerDescription = value
                  }
                  if let value = dictionary["img_url"].string {
                    offersInfo.imgUrl = value
                  }
                  if let value = dictionary["offer_max_amt"].string {
                    offersInfo.offerMaxAmt = value
                  }
                  if let value = dictionary["offer_type"].string {
                    offersInfo.offerType = value
                  }
                  if let value = dictionary["offer_by"].string {
                    offersInfo.offerBy = value
                  }
                  if let value = dictionary["offer_name"].string {
                    offersInfo.offerName = value
                  }
                  if let value = dictionary["percent_off_amt"].string {
                    offersInfo.percentOffAmt = value
                  }
                  if let value = dictionary["is_percent_off"].string {
                    offersInfo.isPercentOff = value
                  }
                  if let value = dictionary["offer_start_date"].string {
                    offersInfo.offerStartDate = value
                  }
                  if let value = dictionary["offer_exp_date"].string {
                    offersInfo.offerExpDate = value
                  }
                  if let value = dictionary["fk_user_id"].string {
                    offersInfo.fkUserId = value
                  }
                  if let value = dictionary["is_active"].string {
                    offersInfo.isActive = value
                  }
                  if let value = dictionary["awaiting_approval"].string {
                    offersInfo.awaitingApproval = value
                  }
                  if let status = dictionary["status"].string {
                    offersInfo.status = status
                  }
                  
                  //Add Offers Info object
                  try! realm.write {
                    realm.add(offersInfo)
                  }
                }
                successBlock(true as AnyObject)
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
  
  /// This service is used to add offer
  func addUpdateNewMerchantOffer(isUpdate: Bool, offerId: String, offerOption: String, percentAmt: String, offerType: String, offerAmt: String, offerCode: String, startDate: String, endDate: String, offerName: String, offerDescription: String, onSuccess successBlock: @escaping ((AnyObject) -> Void), onFailure failureBlock: @escaping ((AnyObject) -> Void)) {
    
    var requestURL = ""
    if isUpdate {
      requestURL = MTNetworkConfig.NetworkBase_URL + MTNetworkConfig.UpdateMerchantOffer_URL
    } else {
      requestURL = MTNetworkConfig.NetworkBase_URL + MTNetworkConfig.AddMerchantOffer_URL
    }
    
    let realm = try! Realm()
    let userInfo = realm.objects(MTUserInfo.self).first
    
    var parameters : Parameters = Parameters()
    parameters["YEK_HTUA_SW"] = self.getCurrentTimeStamp()
    parameters["merchant_id"] = userInfo?.merchantID
    
    if percentAmt.characters.count>0 {
      parameters["percentamt"] = percentAmt
    }
    
    parameters["offertype"] = offerType
    parameters["offeramt"] = offerAmt
    parameters["offercode"] = offerCode
    parameters["startdate"] = startDate
    parameters["enddate"] = endDate
    parameters["offername"] = offerName
    parameters["offer"] = offerOption
    if offerDescription.characters.count>0 {
      parameters["description"] = offerDescription
    }
    if isUpdate {
      parameters["offerid"] = offerId
    }
    MTLogger.log.info("addNewMerchantOffer: \(parameters)")
    
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
          MTLogger.log.info("addNewMerchantOffer error: \(error.localizedDescription)")
          MTCommonUtils.showAlertViewWithTitle(title: "", message: error.localizedDescription)
          failureBlock(false as AnyObject)
          
        } else if let data = response.data, let response = String(data: data, encoding: .utf8) {
          MTLogger.log.info("addNewMerchantOffer Response: \(response)")
          
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
  
  /// This service is used to delete offer
  func deleteMerchantOffer(offerId: String, onSuccess successBlock: @escaping ((AnyObject) -> Void), onFailure failureBlock: @escaping ((AnyObject) -> Void)) {
    
    let requestURL = MTNetworkConfig.NetworkBase_URL + MTNetworkConfig.DeleteMerchantOffer_URL
    
    let realm = try! Realm()
    let userInfo = realm.objects(MTUserInfo.self).first
    
    var parameters : Parameters = Parameters()
    parameters["YEK_HTUA_SW"] = self.getCurrentTimeStamp()
    parameters["merchant_id"] = userInfo?.merchantID
    parameters["offerid"] = offerId

    MTLogger.log.info("deleteMerchantOffer: \(parameters)")
    
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
          MTLogger.log.info("deleteMerchantOffer error: \(error.localizedDescription)")
          MTCommonUtils.showAlertViewWithTitle(title: "", message: error.localizedDescription)
          failureBlock(false as AnyObject)
          
        } else if let data = response.data, let response = String(data: data, encoding: .utf8) {
          MTLogger.log.info("deleteMerchantOffer Response: \(response)")
          
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


