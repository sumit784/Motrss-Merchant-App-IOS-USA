/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTTeamMemberServiceManager.swift
 
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

class MTTeamMemberServiceManager: MTBaseServiceManager {
  
  /**
   Shared instance to prepare the singleton class of ProgressIndicator
   */
  static let sharedInstance = MTTeamMemberServiceManager()
  
  //This prevents others from using the default '()' initializer for this class.
  private override init() {
    super.init()
  }
  
  /// This service is used to get all merchant orders
  func getAllTeamMemberList(onSuccess successBlock: @escaping ((AnyObject) -> Void), onFailure failureBlock: @escaping ((AnyObject) -> Void)) {
    
    let requestURL = MTNetworkConfig.NetworkBase_URL + MTNetworkConfig.GetTeamMemberList_URL
    
    let realm = try! Realm()
    let userInfo = realm.objects(MTUserInfo.self).first
    
    var parameters : Parameters = Parameters()
    parameters["YEK_HTUA_SW"] = self.getCurrentTimeStamp()
    parameters["merchant_id"] = userInfo?.merchantID
    
    MTLogger.log.info("getAllTeamMemberList: \(parameters)")
    
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
          MTLogger.log.info("getAllTeamMemberList error: \(error.localizedDescription)")
          MTCommonUtils.showAlertViewWithTitle(title: "", message: error.localizedDescription)
          failureBlock(false as AnyObject)
          
        } else if let data = response.data, let response = String(data: data, encoding: .utf8) {
          MTLogger.log.info("getAllTeamMemberList Response: \(response)")
          
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
                  realm.delete(realm.objects(MTTeamDetailInfo.self))
                }
                
                for dictionary in dataArray {
                  
                  let teamInfo = MTTeamDetailInfo()
                  
                  if let value = dictionary["id"].string {
                    teamInfo.teamId = value
                  }
                  if let value = dictionary["fk_merchant_id"].string {
                    teamInfo.merchantId = value
                  }
                  if let value = dictionary["fullname"].string {
                    teamInfo.fullName = value
                  }
                  if let value = dictionary["mobile"].string {
                    teamInfo.mobile = value
                  }
                  if let value = dictionary["email"].string {
                    teamInfo.email = value
                  }
                  if let value = dictionary["gender"].string {
                    teamInfo.gender = value
                  }
                  if let value = dictionary["profile_image"].string {
                    teamInfo.profileImage = value
                  }
                  if let value = dictionary["drivers_license_path"].string {
                    teamInfo.licencePath = value
                  }
                  if let value = dictionary["drivers_license_number"].string {
                    teamInfo.licenceNumber = value
                  }
                  if let value = dictionary["dl_expiry_date"].string {
                    teamInfo.licenceExpDate = value
                  }
                  if let value = dictionary["dl_issue_state"].string {
                    teamInfo.licenceState = value
                  }
                  if let value = dictionary["awaiting_approval"].string {
                    teamInfo.awaitingApproval = value
                  }
                  
                  //Add Offers Info object
                  try! realm.write {
                    realm.add(teamInfo)
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
  func addUpdateTeamDetailData(isUpdate: Bool, memberDetail: MTTeamDetailInfo, onSuccess successBlock: @escaping ((AnyObject) -> Void), onFailure failureBlock: @escaping ((AnyObject) -> Void)) {
    
    var requestURL = ""
    if isUpdate {
      requestURL = MTNetworkConfig.NetworkBase_URL + MTNetworkConfig.UpdateTeamMemberInfo_URL
    } else {
      requestURL = MTNetworkConfig.NetworkBase_URL + MTNetworkConfig.AddTeamMemberInfo_URL
    }
    
    let realm = try! Realm()
    let userInfo = realm.objects(MTUserInfo.self).first
    
    var parameters : Parameters = Parameters()
    parameters["YEK_HTUA_SW"] = self.getCurrentTimeStamp()
    parameters["merchant_id"] = userInfo?.merchantID
    
    if memberDetail.teamId.characters.count>0 {
      parameters["teamid"] = memberDetail.teamId
    }    
    if memberDetail.fullName.characters.count>0 {
      parameters["fullname"] = memberDetail.fullName
    }
    if memberDetail.email.characters.count>0 {
      parameters["email"] = memberDetail.email
    }
    if memberDetail.mobile.characters.count>0 {
      parameters["mobile"] = memberDetail.mobile
    }
    if memberDetail.gender.characters.count>0 {
      parameters["gender"] = memberDetail.gender
    }
    if memberDetail.licenceNumber.characters.count>0 {
      parameters["licence_number"] = memberDetail.licenceNumber
    }
    if memberDetail.licenceExpDate.characters.count>0 {
      parameters["licence_expdate"] = memberDetail.licenceExpDate
    }
    if memberDetail.licenceState.characters.count>0 {
      parameters["licence_state"] = memberDetail.licenceState
    }
    if memberDetail.licencePath.characters.count>0 {
      parameters["licence_path"] = memberDetail.licencePath
    }
    if memberDetail.profileImage.characters.count>0 {
      parameters["profile_image"] = memberDetail.profileImage
    }
    
    MTLogger.log.info("addUpdateTeamDetailData: \(parameters)")
    
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
          MTLogger.log.info("addUpdateTeamDetailData error: \(error.localizedDescription)")
          MTCommonUtils.showAlertViewWithTitle(title: "", message: error.localizedDescription)
          failureBlock(false as AnyObject)
          
        } else if let data = response.data, let response = String(data: data, encoding: .utf8) {
          MTLogger.log.info("addUpdateTeamDetailData Response: \(response)")
          
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
  func deleteTeamDetails(teamID: String, onSuccess successBlock: @escaping ((AnyObject) -> Void), onFailure failureBlock: @escaping ((AnyObject) -> Void)) {
    
    let requestURL = MTNetworkConfig.NetworkBase_URL + MTNetworkConfig.DeleteTeamMemberInfo_URL
    
    var parameters : Parameters = Parameters()
    parameters["YEK_HTUA_SW"] = self.getCurrentTimeStamp()
    parameters["teamid"] = teamID

    MTLogger.log.info("deleteTeamDetails: \(parameters)")
    
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
          MTLogger.log.info("deleteTeamDetails error: \(error.localizedDescription)")
          MTCommonUtils.showAlertViewWithTitle(title: "", message: error.localizedDescription)
          failureBlock(false as AnyObject)
          
        } else if let data = response.data, let response = String(data: data, encoding: .utf8) {
          MTLogger.log.info("deleteTeamDetails Response: \(response)")
          
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


