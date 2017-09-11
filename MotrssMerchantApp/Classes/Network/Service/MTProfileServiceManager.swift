/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTProfileServiceManager.swift
 
 Description: This class is used to call the login, create account, forget password service.
 
 Created By: Pranay U.
 
 Creation Date: 25/06/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import UIKit
import Alamofire
import RealmSwift
import SwiftyJSON

class MTProfileServiceManager: MTBaseServiceManager {
  
  /**
   Shared instance to prepare the singleton class of ProgressIndicator
   */
  static let sharedInstance = MTProfileServiceManager()
  
  //This prevents others from using the default '()' initializer for this class.
  private override init() {
    super.init()
  }
  
  /// This service is used to validate the user credential with the server and login to the server
  ///
  /// - Parameters:
  ///   - email: user email
  ///   - password: user password
  ///   - successBlock: success block
  ///   - failureBlock: failure block
  func loginWithEmail(email: String, andPassword password: String, forLogin loginType: String, onSuccess successBlock: @escaping ((AnyObject) -> Void), onFailure failureBlock: @escaping ((AnyObject) -> Void)) {
    
    let loginRequestURL = MTNetworkConfig.NetworkBase_URL + MTNetworkConfig.LoginWithEmail_URL
    
    let loginParameters : Parameters = ["YEK_HTUA_SW":self.getCurrentTimeStamp(),
                                        "login_id":email,
                                        "password":password]
    
    MTLogger.log.info("loginParameters: \(loginParameters)")
    
    // get a session manager and add the request adapter
    let sessionManager = Alamofire.SessionManager.default
    sessionManager.adapter = MTServiceHeadersAdapter()
    
    // make calls with the session manager
    sessionManager.request(loginRequestURL, method: .post, parameters: loginParameters, encoding: URLEncoding.default)
      .validate { request, response, data in
        return .success
      }
      .response { response in
        if let data = response.data, let response = String(data: data, encoding: .utf8) {
          MTLogger.log.info("Login Response: \(response)")
          
          let jsonResponse = self.convertToDictionary(text: response)
          if (self.isErrorMessage(responseDict: jsonResponse)) {
            successBlock(false as AnyObject)
          } else {
            let loginJson = JSON(jsonResponse!)
            if let status = loginJson["Status"].string, status == "Success" {
              
              if let loginData = loginJson["Data"].dictionary {
                self.updateMerchatLoginDetails(loginData: loginData)
                self.getMerchantProfile(onSuccess: { (success) in
                  successBlock(true as AnyObject)
                }, onFailure: { (failure) in
                  //Delete Profile Object
                  let realm = try! Realm()
                  try! realm.write {
                    realm.delete(realm.objects(MTUserInfo.self))
                  }
                  failureBlock(false as AnyObject)
                })
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
  
  /// This service is used to validate the user credential with the server and login to the server
  ///
  /// - Parameters:
  ///   - email: user email
  ///   - password: user password
  ///   - successBlock: success block
  ///   - failureBlock: failure block
  func loginWithMobile(mobile: String, andPassword password: String, onSuccess successBlock: @escaping ((AnyObject) -> Void), onFailure failureBlock: @escaping ((AnyObject) -> Void)) {
    
    let loginRequestURL = MTNetworkConfig.NetworkBase_URL + MTNetworkConfig.LoginWithMobile_URL
    
    let loginParameters : Parameters = ["YEK_HTUA_SW":self.getCurrentTimeStamp(),
                                        "contact_mobile":mobile,
                                        "mobilepin":password]
    
    MTLogger.log.info("loginWithMobile: \(loginParameters)")
    
    // get a session manager and add the request adapter
    let sessionManager = Alamofire.SessionManager.default
    sessionManager.adapter = MTServiceHeadersAdapter()
    
    // make calls with the session manager
    sessionManager.request(loginRequestURL, method: .post, parameters: loginParameters, encoding: URLEncoding.default)
      .validate { request, response, data in
        return .success
      }
      .response { response in
        if let data = response.data, let response = String(data: data, encoding: .utf8) {
          MTLogger.log.info("loginWithMobile Response: \(response)")
          
          let jsonResponse = self.convertToDictionary(text: response)
          if (self.isErrorMessage(responseDict: jsonResponse)) {
            successBlock(false as AnyObject)
          } else {
            
            let loginJson = JSON(jsonResponse!)
            if let status = loginJson["Status"].string, status == "Success" {
              
              if let loginData = loginJson["Data"].dictionary {
                self.updateMerchatLoginDetails(loginData: loginData)
                self.getMerchantProfile(onSuccess: { (success) in
                  successBlock(true as AnyObject)
                }, onFailure: { (failure) in
                  //Delete Profile Object
                  let realm = try! Realm()
                  try! realm.write {
                    realm.delete(realm.objects(MTUserInfo.self))
                  }
                  failureBlock(false as AnyObject)
                })
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

  func updateMerchatLoginDetails(loginData: [String : JSON]) {
    
    let realm = try! Realm()
    let userInfo = MTUserInfo()
    
    if let userID = loginData["id"]?.string {
      userInfo.userID = userID
    }
    if let loginID = loginData["login_id"]?.string {
      userInfo.loginID = loginID
    }
    if let emailID = loginData["email"]?.string {
      userInfo.emailID = emailID
    }
    if let merchantID = loginData["merchant_id"]?.string {
      userInfo.merchantID = merchantID
    }
    if let ownerName = loginData["owner_name"]?.string {
      userInfo.ownerName = ownerName
    }
    if let pickupDeskID = loginData["fk_pickup_desk_id"]?.string {
      userInfo.pickupDeskID = pickupDeskID
    }
    if let mobileNumber = loginData["mobile"]?.string {
      userInfo.mobileNumber = mobileNumber
    }
    if let isLoginWithTempPwd = loginData["is_temp_pwd"]?.string {
      userInfo.isLoginWithTempPwd = isLoginWithTempPwd
    }
    if let auth = loginData["merchant_auth_key"]?.string {
      userInfo.authKey = auth
    }
    if let password = loginData["password"]?.string {
      userInfo.password = password
    }
    
    if let password = loginData["is_mobile_verified"]?.string {
      userInfo.isMobileVerified = password
    }
    if let password = loginData["is_email_verified"]?.string {
      userInfo.isEmailVerified = password
    }
    if let password = loginData["business_name"]?.string {
      userInfo.businessName = password
    }
    if let password = loginData["shop_img"]?.string {
      userInfo.shopImage = password
    }
    
    //Delete Profile Object
    try! realm.write {
      realm.delete(realm.objects(MTUserInfo.self))
    }
    //Add Profile Info object
    try! realm.write {
      realm.add(userInfo)
    }
  }
  
  func updateMerchatProfileDetails(loginData: [String : JSON]) {
    
    let realm = try! Realm()
    
    if let profileData = loginData["profile"]?.dictionary {
      let userInfo = realm.objects(MTUserInfo.self).first
      
      if let userID = profileData["id"]?.string {
        try! realm.write {
          userInfo?.userID = userID
        }
      }
      if let loginID = profileData["login_id"]?.string {
        try! realm.write {
          userInfo?.loginID = loginID
        }
      }
      if let emailID = profileData["email"]?.string {
        try! realm.write {
          userInfo?.emailID = emailID
        }
      }
      if let merchantID = profileData["merchant_id"]?.string {
        try! realm.write {
          userInfo?.merchantID = merchantID
        }
      }
      if let ownerName = profileData["owner_name"]?.string {
        try! realm.write {
          userInfo?.ownerName = ownerName
        }
      }
      if let mobileNumber = profileData["mobile"]?.string {
        try! realm.write {
          userInfo?.mobileNumber = mobileNumber
        }
      }
      
      if let password = profileData["is_mobile_verified"]?.string {
        try! realm.write {
          userInfo?.isMobileVerified = password
        }
      }
      if let password = profileData["is_email_verified"]?.string {
        try! realm.write {
          userInfo?.isEmailVerified = password
        }
      }
      if let password = profileData["business_name"]?.string {
        try! realm.write {
          userInfo?.businessName = password
        }
      }
      if let password = profileData["shop_img"]?.string {
        try! realm.write {
          userInfo?.shopImage = password
        }
      }
    }
    try! realm.write {
      realm.delete(realm.objects(MTMerchantTypeInfo.self))
    }
    
    if let merchantTypeArr = loginData["merchant_type"]?.array {
      let userInfo = realm.objects(MTUserInfo.self).first
      
      for merchantTypeDict in merchantTypeArr {
        
        let merchanttype = MTMerchantTypeInfo()
        
        if let merchantTypeId = merchantTypeDict["merchant_type_id"].string {
          try! realm.write {
            merchanttype.merchantTypeId = merchantTypeId
          }
        }
        if let priceTypeCol = merchantTypeDict["price_type_col"].string {
          try! realm.write {
            merchanttype.priceTypeCol = priceTypeCol
          }
        }
        try! realm.write {
          userInfo?.merchantTypes.append(merchanttype)
        }
      }
    }
  }
  
  /// This service is used to for forgot password
  ///
  /// - Parameters:
  ///   - email: user email
  ///   - successBlock: success block
  ///   - failureBlock: failure block
  func SendTempPasswordOnEmai(email: String, onSuccess successBlock: @escaping ((AnyObject) -> Void), onFailure failureBlock: @escaping ((AnyObject) -> Void)) {
    
    let requestURL = MTNetworkConfig.NetworkBase_URL + MTNetworkConfig.SendTempPasswordOnEmai_URL
    
    let parameters : Parameters = ["YEK_HTUA_SW":self.getCurrentTimeStamp(),
                                   "email_id":email]
    
    MTLogger.log.info("SendTempPasswordOnEmai: \(parameters)")
    
    // get a session manager and add the request adapter
    let sessionManager = Alamofire.SessionManager.default
    sessionManager.adapter = MTServiceHeadersAdapter()
    
    // make calls with the session manager
    sessionManager.request(requestURL, method: .post, parameters: parameters, encoding: URLEncoding.default)
      .validate { request, response, data in
        return .success
      }
      .response { response in
        if let data = response.data, let response = String(data: data, encoding: .utf8) {
          MTLogger.log.info("SendTempPasswordOnEmai Response: \(response)")
          
          let jsonResponse = self.convertToDictionary(text: response)
          if (self.isErrorMessage(responseDict: jsonResponse)) {
            failureBlock(false as AnyObject)
          } else {
            successBlock(jsonResponse as AnyObject)
          }
        }
    }
  }
  
  /// This service is used to reset the password
  ///
  /// - Parameters:
  ///   - email: user email
  ///   - answer: user password
  ///   - successBlock: success block
  ///   - failureBlock: failure block
  func forgotMobilePin(mobileNumber: String, successBlock: @escaping ((AnyObject) -> Void), onFailure failureBlock: @escaping ((AnyObject) -> Void)) {
    
    let requestURL = MTNetworkConfig.NetworkBase_URL + MTNetworkConfig.ForgotMobilePin_URL
    
    let parameters : Parameters = ["YEK_HTUA_SW":self.getCurrentTimeStamp(),
                                   "contact_mobile":mobileNumber]
    
    MTLogger.log.info("forgotMobilePin: \(parameters)")
    
    // get a session manager and add the request adapter
    let sessionManager = Alamofire.SessionManager.default
    sessionManager.adapter = MTServiceHeadersAdapter()
    
    // make calls with the session manager
    sessionManager.request(requestURL, method: .post, parameters: parameters, encoding: URLEncoding.default)
      .validate { request, response, data in
        return .success
      }
      .response { response in
        if let data = response.data, let response = String(data: data, encoding: .utf8) {
          MTLogger.log.info("forgotMobilePin Response: \(response)")
          
          let jsonResponse = self.convertToDictionary(text: response)
          if (self.isErrorMessage(responseDict: jsonResponse)) {
            failureBlock(false as AnyObject)
          } else {
            let loginJson = JSON(jsonResponse!)
            if let status = loginJson["Status"].string, status == "Success" {
              successBlock(jsonResponse as AnyObject)
            } else {
              successBlock(false as AnyObject)
            }
          }
        }
    }
  }
  
  /// This service is used to validate send OTP Pin
  ///
  /// - Parameters:
  ///   - mobileNumber: mobile number
  ///   - successBlock: success block
  ///   - failureBlock: failure block
  func verifyOTPPin(userID: String, userOTP: String, onSuccess successBlock: @escaping ((AnyObject) -> Void), onFailure failureBlock: @escaping ((AnyObject) -> Void)) {
    
    let requestURL = MTNetworkConfig.NetworkBase_URL + MTNetworkConfig.VerifyOTP_URL
    
    let parameters : Parameters = ["YEK_HTUA_SW":self.getCurrentTimeStamp(),
                                   "merchant_otp":userOTP,
                                   "id":userID]
    
    MTLogger.log.info("verifyOTPPin: \(parameters)")
    
    // get a session manager and add the request adapter
    let sessionManager = Alamofire.SessionManager.default
    sessionManager.adapter = MTServiceHeadersAdapter()
    
    // make calls with the session manager
    sessionManager.request(requestURL, method: .post, parameters: parameters, encoding: URLEncoding.default)
      .validate { request, response, data in
        return .success
      }
      .response { response in
        if let data = response.data, let response = String(data: data, encoding: .utf8) {
          MTLogger.log.info("verifyOTPPin Response: \(response)")
          
          let jsonResponse = self.convertToDictionary(text: response)
          if (self.isErrorMessage(responseDict: jsonResponse)) {
            failureBlock(false as AnyObject)
          } else {
            successBlock(jsonResponse as AnyObject)
          }
        }
    }
  }
  
  /// This service is used to reset OTP Pin
  ///
  /// - Parameters:
  ///   - mobileNumber: mobile number
  ///   - successBlock: success block
  ///   - failureBlock: failure block
  func resetOTPPin(userID: String, newMobilePin: String, onSuccess successBlock: @escaping ((AnyObject) -> Void), onFailure failureBlock: @escaping ((AnyObject) -> Void)) {
    
    let requestURL = MTNetworkConfig.NetworkBase_URL + MTNetworkConfig.UpdateOTP_URL
    
    let parameters : Parameters = ["YEK_HTUA_SW":self.getCurrentTimeStamp(),
                                   "mid":userID,
                                   "mobile_pin":newMobilePin]
    
    MTLogger.log.info("resetOTPPin: \(parameters)")
    
    // get a session manager and add the request adapter
    let sessionManager = Alamofire.SessionManager.default
    sessionManager.adapter = MTServiceHeadersAdapter()
    
    // make calls with the session manager
    sessionManager.request(requestURL, method: .post, parameters: parameters, encoding: URLEncoding.default)
      .validate { request, response, data in
        return .success
      }
      .response { response in
        if let data = response.data, let response = String(data: data, encoding: .utf8) {
          MTLogger.log.info("resetOTPPin Response: \(response)")
          
          let jsonResponse = self.convertToDictionary(text: response)
          if (self.isErrorMessage(responseDict: jsonResponse)) {
            failureBlock(false as AnyObject)
          } else {
            successBlock(true as AnyObject)
          }
        }
    }
  }
  
  /// This service is used to reset the password
  ///
  /// - Parameters:
  ///   - email: user email
  ///   - answer: user password
  ///   - successBlock: success block
  ///   - failureBlock: failure block
  func resetPassword(merchantEmailID: String, password: String, oldPassword: String, onSuccess successBlock: @escaping ((AnyObject) -> Void), onFailure failureBlock: @escaping ((AnyObject) -> Void)) {
    
    let requestURL = MTNetworkConfig.NetworkBase_URL + MTNetworkConfig.ResetPassword_URL
    
    let parameters : Parameters = ["YEK_HTUA_SW":self.getCurrentTimeStamp(),
                                   "email_id":merchantEmailID,
                                   "password":password,
                                   "oldpassword":oldPassword]
    
    MTLogger.log.info("resetPassword: \(parameters)")
    
    // get a session manager and add the request adapter
    let sessionManager = Alamofire.SessionManager.default
    sessionManager.adapter = MTServiceHeadersAdapter()
    
    // make calls with the session manager
    sessionManager.request(requestURL, method: .post, parameters: parameters, encoding: URLEncoding.default)
      .validate { request, response, data in
        return .success
      }
      .response { response in
        if let data = response.data, let response = String(data: data, encoding: .utf8) {
          MTLogger.log.info("resetPassword Response: \(response)")
          
          let jsonResponse = self.convertToDictionary(text: response)
          if (self.isErrorMessage(responseDict: jsonResponse)) {
            failureBlock(false as AnyObject)
          } else {
            let loginJson = JSON(jsonResponse!)
            if let status = loginJson["Status"].string, status == "Success" {
              successBlock(true as AnyObject)
            } else {
              successBlock(false as AnyObject)
            }
          }
        }
    }
  }  


//----------------------

  func getMerchantProfile(onSuccess successBlock: @escaping ((AnyObject) -> Void), onFailure failureBlock: @escaping ((AnyObject) -> Void)) {
    
    let requestURL = MTNetworkConfig.NetworkBase_URL + MTNetworkConfig.GetMerchantProfile_URL
    
    let realm = try! Realm()
    let userInfo = realm.objects(MTUserInfo.self).first
    let parameters : Parameters = ["YEK_HTUA_SW":self.getCurrentTimeStamp(),
                                        "merchant_id":userInfo?.merchantID ?? "" ]
    
    MTLogger.log.info("getMerchantProfile: \(parameters)")
    
    // get a session manager and add the request adapter
    let sessionManager = Alamofire.SessionManager.default
    sessionManager.adapter = MTServiceHeadersAdapter()
    
    // make calls with the session manager
    sessionManager.request(requestURL, method: .post, parameters: parameters, encoding: URLEncoding.default)
      .validate { request, response, data in
        return .success
      }
      .response { response in
        if let data = response.data, let response = String(data: data, encoding: .utf8) {
          MTLogger.log.info("getMerchantProfile: \(response)")
          
          let jsonResponse = self.convertToDictionary(text: response)
          if (self.isErrorMessage(responseDict: jsonResponse)) {
            successBlock(false as AnyObject)
          } else {
            let loginJson = JSON(jsonResponse!)
            if let status = loginJson["Status"].string, status == "Success" {
              
              if let loginData = loginJson["Data"].dictionary {
                //if let profileData = loginData["profile"]?.dictionary {
                  self.updateMerchatProfileDetails(loginData: loginData)
                  successBlock(true as AnyObject)
                //} else {
                //  failureBlock(false as AnyObject)
                //}
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

  func updateMerchantProfile(name: String, email: String, mobile: String, shopImage: String, /*shopName: String,*/ onSuccess successBlock: @escaping ((AnyObject) -> Void), onFailure failureBlock: @escaping ((AnyObject) -> Void)) {
    
    let requestURL = MTNetworkConfig.NetworkBase_URL + MTNetworkConfig.UpdateMerchantProfile_URL
    
    var shopImgStr = "00"
    if shopImage.characters.count>0 {
      shopImgStr = shopImage
    }
    
    let realm = try! Realm()
    let userInfo = realm.objects(MTUserInfo.self).first
    let parameters : Parameters = ["YEK_HTUA_SW":self.getCurrentTimeStamp(),
                                   "merchant_id":userInfo?.merchantID ?? "" ,
                                   "owner_name":name,
                                   //"business_name":name,
                                   "email":email,
                                   "mobile":mobile,
                                   "shop_img":shopImgStr]
    
    MTLogger.log.info("updateMerchantProfile: \(parameters)")
    
    // get a session manager and add the request adapter
    let sessionManager = Alamofire.SessionManager.default
    sessionManager.adapter = MTServiceHeadersAdapter()
    
    // make calls with the session manager
    sessionManager.request(requestURL, method: .post, parameters: parameters, encoding: URLEncoding.default)
      .validate { request, response, data in
        return .success
      }
      .response { response in
        if let data = response.data, let response = String(data: data, encoding: .utf8) {
          MTLogger.log.info("updateMerchantProfile: \(response)")
          
          let jsonResponse = self.convertToDictionary(text: response)
          if (self.isErrorMessage(responseDict: jsonResponse)) {
            successBlock(false as AnyObject)
          } else {
            let loginJson = JSON(jsonResponse!)
            if let status = loginJson["Status"].string, status == "Success" {
              self.getMerchantProfile(onSuccess: { (success) in
                successBlock(true as AnyObject)
              }, onFailure: { (failure) in
                failureBlock(false as AnyObject)
              })
            } else {
              failureBlock(false as AnyObject)
            }
          }
        }
    }
  }

  func updateMerchantPassword(email: String, newPassword: String, oldPassword: String, onSuccess successBlock: @escaping ((AnyObject) -> Void), onFailure failureBlock: @escaping ((AnyObject) -> Void)) {
    
    let requestURL = MTNetworkConfig.NetworkBase_URL + MTNetworkConfig.ChangeMerchantPassword_URL
    
    //let realm = try! Realm()
    //let userInfo = realm.objects(MTUserInfo.self).first
    let parameters : Parameters = ["YEK_HTUA_SW":self.getCurrentTimeStamp(),
                                   "email_id":email ,
                                   "password":newPassword,
                                   "oldpassword":oldPassword]
    
    MTLogger.log.info("updateMerchantPassword: \(parameters)")
    
    // get a session manager and add the request adapter
    let sessionManager = Alamofire.SessionManager.default
    sessionManager.adapter = MTServiceHeadersAdapter()
    
    // make calls with the session manager
    sessionManager.request(requestURL, method: .post, parameters: parameters, encoding: URLEncoding.default)
      .validate { request, response, data in
        return .success
      }
      .response { response in
        if let data = response.data, let response = String(data: data, encoding: .utf8) {
          MTLogger.log.info("updateMerchantPassword: \(response)")
          
          let jsonResponse = self.convertToDictionary(text: response)
          if (self.isErrorMessage(responseDict: jsonResponse)) {
            successBlock(false as AnyObject)
          } else {
            let loginJson = JSON(jsonResponse!)
            if let status = loginJson["Status"].string, status == "Success" {
              successBlock(true as AnyObject)
            } else {
              failureBlock(false as AnyObject)
            }
          }
        }
    }
  }
  
  ///
  /// - Parameters:
  ///   - successBlock: success block
  ///   - failureBlock: failure block
  func checkCacheStatus(isForProduct: Bool, serviceName: String, onSuccess successBlock: @escaping ((AnyObject) -> Void), onFailure failureBlock: @escaping ((AnyObject) -> Void)) {
    
    let requestURL = MTNetworkConfig.NetworkBase_URL + MTNetworkConfig.CheckCacheStatus_URL
    
    let realm = try! Realm()
    let userInfo = realm.objects(MTUserInfo.self).first
    
    var parameters : Parameters = Parameters()
    //parameters["serviceName"] = serviceName
    parameters["merchant_id"] = userInfo?.merchantID
    
    //if serviceName == MTNetworkConfig.GetProfileDetails_URL {
    //  let realm = try! Realm()
    //  let userInfo = realm.objects(MTUserInfo.self).first
    //  parameters[MTAESManager.encryptString("user_id")] = MTAESManager.encryptString(userInfo?.userID)
    //}
    
    MTLogger.log.info("checkCacheStatus: \(parameters)")
    
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
          MTLogger.log.info("checkCacheStatus error: \(error.localizedDescription)")
          MTCommonUtils.showAlertViewWithTitle(title: "", message: error.localizedDescription)
          failureBlock(false as AnyObject)
        } else if let data = response.data, let response = String(data: data, encoding: .utf8) {
          MTLogger.log.info("checkCacheStatus Response: \(response)")
          
          let jsonResponse = self.convertToDictionary(text: response)
          if (self.isErrorMessage(responseDict: jsonResponse)) {
            successBlock(false as AnyObject)
          } else {
            let json = JSON(jsonResponse!)
            if let status = json["Status"].string, status == "success" {
              
              if let dataDictionary = json["Data"].dictionary {
                
                var retutnValue = false
                
                if isForProduct {
                  let userDefault = UserDefaults.standard
                  let value = userDefault.string(forKey: MTConstant.UserDefault_ProductsUpdated)
                  if let updateCount = dataDictionary["is_products_updated"]?.string {
                    if value != updateCount {
                      retutnValue = true
                      //Update count
                      userDefault.set(updateCount, forKey: MTConstant.UserDefault_ProductsUpdated)
                    }
                  }
                } else {
                  let userDefault = UserDefaults.standard
                  let value = userDefault.string(forKey: MTConstant.UserDefault_ProfileUpdated)
                  if let updateCount = dataDictionary["is_profile_updated"]?.string {
                    if value != updateCount {
                      retutnValue = true
                      //Update count
                      userDefault.set(updateCount, forKey: MTConstant.UserDefault_ProfileUpdated)
                    }
                  }
                }

                successBlock(retutnValue as AnyObject)
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
  
  //--------------
  /// This service is used to validate send OTP Pin after login
  ///
  /// - Parameters:
  ///   - mobileNumber: mobile number
  ///   - successBlock: success block
  ///   - failureBlock: failure block
  func sendOTPPinForMobile(newMobileNo: String, onSuccess successBlock: @escaping ((AnyObject) -> Void), onFailure failureBlock: @escaping ((AnyObject) -> Void)) {
    
    let requestURL = MTNetworkConfig.NetworkBase_URL + MTNetworkConfig.SendOTPAfterLogin_URL
    
    let realm = try! Realm()
    let userInfo = realm.objects(MTUserInfo.self).first
    let parameters : Parameters = [
      "mobile":newMobileNo,
      "id":userInfo?.userID ?? ""]
    
    MTLogger.log.info("sendOTPPinAfterLogin: \(parameters)")
    
    // get a session manager and add the request adapter
    let sessionManager = Alamofire.SessionManager.default
    sessionManager.adapter = MTServiceHeadersAdapter()
    
    // make calls with the session manager
    sessionManager.request(requestURL, method: .post, parameters: parameters, encoding: URLEncoding.default)
      .validate { request, response, data in
        return .success
      }
      .response { response in
        if let data = response.data, let response = String(data: data, encoding: .utf8) {
          MTLogger.log.info("sendOTPPinAfterLogin Response: \(response)")
          
          let jsonResponse = self.convertToDictionary(text: response)
          if (self.isErrorMessage(responseDict: jsonResponse)) {
            failureBlock(false as AnyObject)
          } else {
            successBlock(jsonResponse as AnyObject)
          }
        }
    }
  }
  
  func getMerchantReviewAndRatings(successBlock: @escaping ((AnyObject) -> Void), onFailure failureBlock: @escaping ((AnyObject) -> Void)) {
    
    let requestURL = MTNetworkConfig.NetworkBase_URL + MTNetworkConfig.GetMerchantReviewRating_URL
    
    let realm = try! Realm()
    let userInfo = realm.objects(MTUserInfo.self).first
    
    let parameters : Parameters = [
      "merchant_id":userInfo?.merchantID ?? ""]
    
    MTLogger.log.info("getMerchantReviewAndRatings: \(parameters)")
    
    // get a session manager and add the request adapter
    let sessionManager = Alamofire.SessionManager.default
    sessionManager.adapter = MTServiceHeadersAdapter()
    
    // make calls with the session manager
    sessionManager.request(requestURL, method: .post, parameters: parameters, encoding: URLEncoding.default)
      .validate { request, response, data in
        return .success
      }
      .response { response in
        if let data = response.data, let response = String(data: data, encoding: .utf8) {
          MTLogger.log.info("getMerchantReviewAndRatings Response: \(response)")
          
          if let jsonResponse = self.convertToDictionary(text: response) {
            if (self.isErrorMessage(responseDict: jsonResponse)) {
              successBlock(false as AnyObject)
            } else {
              let loginJson = JSON(jsonResponse)
              if let status = loginJson["Status"].string, status == "Success" {
                if let dataArray = loginJson["Data"].array {
                  
                  let realm = try! Realm()
                  try! realm.write {
                    realm.delete(realm.objects(MTReviewRatingsInfo.self))
                  }
                  
                  for notificationDict in dataArray {
                    
                    let reviewInfo = MTReviewRatingsInfo()
                    
                    if let value = notificationDict["id"].string {
                      reviewInfo.reviewID = value
                    }
                    if let value = notificationDict["fk_merchant_id"].string {
                      reviewInfo.merchantId = value
                    }
                    if let value = notificationDict["fk_user_id"].string {
                      reviewInfo.userId = value
                    }
                    if let value = notificationDict["rating"].string {
                      reviewInfo.rating = value
                    }
                    if let value = notificationDict["cust_review"].string {
                      reviewInfo.custReview = value
                    }
                    if let value = notificationDict["added_date"].string {
                      reviewInfo.addedDate = value
                    }
                    if let value = notificationDict["user_name"].string {
                      reviewInfo.userName = value
                    }
                    if let value = notificationDict["user_id"].string {
                      reviewInfo.userEmailId = value
                    }
                    if let value = notificationDict["order_id"].string {
                      reviewInfo.orderId = value
                    }
                    if let value = notificationDict["heading"].string {
                      reviewInfo.heading = value
                    }
                    try! realm.write {
                      realm.add(reviewInfo)
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
          } else {
            failureBlock(false as AnyObject)
          }
        }
    }
  }
  
  /// This service is used to send verification email
  ///
  /// - Parameters:
  ///   - successBlock: success block
  ///   - failureBlock: failure block
  func resendVerificationEmail(successBlock: @escaping ((AnyObject) -> Void), onFailure failureBlock: @escaping ((AnyObject) -> Void)) {
    
    let requestURL = MTNetworkConfig.NetworkBase_URL + MTNetworkConfig.SendVerifyEmail_URL
    
    let realm = try! Realm()
    let userInfo = realm.objects(MTUserInfo.self).first
    
    let parameters : Parameters = [
      "merchant_id":userInfo?.merchantID ?? "",
      "email":userInfo?.emailID ?? ""]
    
    MTLogger.log.info("resendVerificationEmail: \(parameters)")
    
    // get a session manager and add the request adapter
    let sessionManager = Alamofire.SessionManager.default
    sessionManager.adapter = MTServiceHeadersAdapter()
    
    // make calls with the session manager
    sessionManager.request(requestURL, method: .post, parameters: parameters, encoding: URLEncoding.default)
      .validate { request, response, data in
        return .success
      }
      .response { response in
        if let data = response.data, let response = String(data: data, encoding: .utf8) {
          MTLogger.log.info("resendVerificationEmail Response: \(response)")
          
          let jsonResponse = self.convertToDictionary(text: response)
          if (self.isErrorMessage(responseDict: jsonResponse)) {
            successBlock(false as AnyObject)
          } else {
            let loginJson = JSON(jsonResponse!)
            if let status = loginJson["Status"].string, status == "Success" {
              successBlock(true as AnyObject)
            } else {
              failureBlock(false as AnyObject)
            }
          }
        }
    }
  }
}
