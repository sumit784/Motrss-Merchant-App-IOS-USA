/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTOrderServiceManager.swift
 
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

class MTOrderServiceManager: MTBaseServiceManager {
  
  /**
   Shared instance to prepare the singleton class of ProgressIndicator
   */
  static let sharedInstance = MTOrderServiceManager()
  
  //This prevents others from using the default '()' initializer for this class.
  private override init() {
    super.init()
  }
  
  /// This service is used to get all merchant orders
  func getMerchantOrders(orderType: MTEnums.OrderType.RawValue, onSuccess successBlock: @escaping ((AnyObject) -> Void), onFailure failureBlock: @escaping ((AnyObject) -> Void)) {
    
    var urlStr = MTNetworkConfig.GetMerchantNewOrders_URL
    if orderType == MTEnums.OrderType.newOrders.rawValue {
      urlStr = MTNetworkConfig.GetMerchantNewOrders_URL
    } else if orderType == MTEnums.OrderType.orderStatus.rawValue {
      urlStr = MTNetworkConfig.GetMerchantCurrentOrders_URL
    } else if orderType == MTEnums.OrderType.orderHistory.rawValue {
      urlStr = MTNetworkConfig.GetMerchantOrdersHistory_URL
    }
    MTLogger.log.info("getMerchantOrders URL: \(urlStr)")
    
    let requestURL = MTNetworkConfig.NetworkBase_URL + urlStr
    
    let realm = try! Realm()
    let userInfo = realm.objects(MTUserInfo.self).first
    
    var parameters : Parameters = Parameters()
    parameters["YEK_HTUA_SW"] = self.getCurrentTimeStamp()
    parameters["merchant_id"] = userInfo?.merchantID ?? ""
    parameters["device_id"] = "5311839E985FA01B56E7AD74334S" //NOTE:: Need to add device id
    
    MTLogger.log.info("getMerchantOrders: \(parameters)")
    
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
          MTLogger.log.info("getMerchantOrders error: \(error.localizedDescription)")
          MTCommonUtils.showAlertViewWithTitle(title: "", message: error.localizedDescription)
          failureBlock(false as AnyObject)
          
        } else if let data = response.data, let response = String(data: data, encoding: .utf8) {
          MTLogger.log.info("getMerchantOrders Response: \(response)")
          
          if let jsonResponse = self.convertToDictionary(text: response) {
            if (self.isErrorMessage(responseDict: jsonResponse)) {
              successBlock(false as AnyObject)
            } else {
              let jsonData = JSON(jsonResponse)
              if let status = jsonData["Status"].string, status == "Success" {
                
                if let dataArray = jsonData["Data"].array {
                  
                  self.updateMerchantOrderData(dataArray: dataArray, orderType:orderType)
                  successBlock(true as AnyObject)
                } else if let dataDict = jsonData["Data"].dictionary {
                  if let dataArray = dataDict["order"]?.array {
                    self.updateMerchantOrderData(dataArray: dataArray, orderType:orderType)
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
          } else {
            failureBlock(false as AnyObject)
          }
        }
    }
  }
  
  /// This service is used to get all merchant orders
  func getMerchantOrderHistoryDetails(orderId: String, orderType: MTEnums.OrderType.RawValue, onSuccess successBlock: @escaping ((AnyObject) -> Void), onFailure failureBlock: @escaping ((AnyObject) -> Void)) {
    
    let requestURL = MTNetworkConfig.NetworkBase_URL + MTNetworkConfig.MerchantHistoryOrderDetails_URL
    
    //let realm = try! Realm()
    //let userInfo = realm.objects(MTUserInfo.self).first
    
    var parameters : Parameters = Parameters()
    parameters["YEK_HTUA_SW"] = self.getCurrentTimeStamp()
    parameters["order_id"] = orderId
    
    MTLogger.log.info("getMerchantOrderHistoryDetails: \(parameters)")
    
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
          MTLogger.log.info("getMerchantOrders error: \(error.localizedDescription)")
          MTCommonUtils.showAlertViewWithTitle(title: "", message: error.localizedDescription)
          failureBlock(false as AnyObject)
          
        } else if let data = response.data, let response = String(data: data, encoding: .utf8) {
          MTLogger.log.info("getMerchantOrders Response: \(response)")
          
          if let jsonResponse = self.convertToDictionary(text: response) {
            if (self.isErrorMessage(responseDict: jsonResponse)) {
              successBlock(false as AnyObject)
            } else {
              let jsonData = JSON(jsonResponse)
              if let status = jsonData["Status"].string, status == "Success" {
                
                if let dataArray = jsonData["Data"].array {
                  
                  var productHistoryInfo: MTOrderDetailInfo?
                  for dictionary in dataArray {
                    productHistoryInfo = self.parseMerchantDetail(dictionary: dictionary, orderType: orderType)
                  }
                  
                  successBlock(productHistoryInfo as AnyObject)
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
  
  func updateMerchantOrderData(dataArray: [JSON], orderType: String) {
    let realm = try! Realm()
    //Delete All Products Obj
    //try! realm.write {
    //  realm.delete(realm.objects(MTOrderDetailInfo.self))
    //}
    try! realm.write {
      let filterString = String(format: "orderType == '%@'", orderType)
      realm.delete(realm.objects(MTOrderDetailInfo.self).filter(filterString))
    }

    for dictionary in dataArray {
      
      let productHistoryInfo = parseMerchantDetail(dictionary: dictionary, orderType: orderType)
      
      //Add Offers Info object
      let realm = try! Realm()
      try! realm.write {
        realm.add(productHistoryInfo)
      }
    }
  }
  
  func parseMerchantDetail(dictionary: JSON, orderType: String) -> MTOrderDetailInfo {
    
    let productHistoryInfo = MTOrderDetailInfo()
    productHistoryInfo.orderType = orderType
    
    //merchant
    if let merchantDict = dictionary["merchant"].dictionary {
      if let merchantName = merchantDict["business_name"]?.string {
        productHistoryInfo.merchantName = merchantName
      }
      if let mobile = merchantDict["mobile"]?.string {
        productHistoryInfo.merchantMobile = mobile
      }
      if let mid = merchantDict["mid"]?.string {
        productHistoryInfo.merchantID = mid
      }
      if let address_one = merchantDict["address_one"]?.string {
        productHistoryInfo.merchantAddressOne = address_one
      }
      if let address_two = merchantDict["address_two"]?.string {
        productHistoryInfo.merchantAddressTwo = address_two
      }
      if let state = merchantDict["state"]?.string {
        productHistoryInfo.merchantState = state
      }
      if let city = merchantDict["city"]?.string {
        productHistoryInfo.merchantCity = city
      }
    }
    
    //user
    if let userDict = dictionary["user"].dictionary {
      if let userName = userDict["user_name"]?.string {
        productHistoryInfo.userName = userName
      }
      if let contactMobile = userDict["contact_mobile"]?.string {
        productHistoryInfo.contactMobile = contactMobile
      }
      if let pickAddress = userDict["pickaddress"]?.string {
        productHistoryInfo.pickAddress = pickAddress
      }
      if let dropAddress = userDict["dropaddress"]?.string {
        productHistoryInfo.dropAddress = dropAddress
      }
    }
    
    //order
    if let orderDict = dictionary["order"].dictionary {
      if let orderId = orderDict["id"]?.string {
        productHistoryInfo.orderId = orderId
      }
      if let orderStatus = orderDict["order_status"]?.string {
        productHistoryInfo.orderStatus = orderStatus
      }
      if let payment_status = orderDict["payment_status"]?.string {
        productHistoryInfo.orderPaymentStatus = payment_status
      }
      if let is_feedback = orderDict["is_feedback"]?.string {
        productHistoryInfo.orderIsFeedback = is_feedback
      }
      if let note = orderDict["note"]?.string {
        productHistoryInfo.orderNote = note
      }
      if let orderTeamMemberId = orderDict["fk_team_member_id"]?.string {
        productHistoryInfo.orderTeamMemberId = orderTeamMemberId
      }
      if let additionalIssuesImages = orderDict["additional_issues_images"]?.string {
        productHistoryInfo.additionalIssuesImages = additionalIssuesImages
      }
      if let additionalIssuesFound = orderDict["additional_issues_found"]?.string {
        productHistoryInfo.additionalIssuesFound = additionalIssuesFound
      }
      if let orderDate = orderDict["order_date"]?.string {
        productHistoryInfo.orderDate = orderDate
      }
      if let timePreference1 = orderDict["time_pref1"]?.string {
        productHistoryInfo.timePreference1 = timePreference1
      }
      if let timePreference2 = orderDict["time_pref2"]?.string {
        productHistoryInfo.timePreference2 = timePreference2
      }
      if let timePreference3 = orderDict["time_pref3"]?.string {
        productHistoryInfo.timePreference3 = timePreference3
      }
      if let final_amount = orderDict["final_amount"]?.string {
        productHistoryInfo.orderFinalAmount = final_amount
      }
      if let booking_payment_status = orderDict["booking_payment_status"]?.string {
        productHistoryInfo.orderBookingPaymentStatus = booking_payment_status
      }
      if let balance_payment_status = orderDict["balance_payment_status"]?.string {
        productHistoryInfo.orderBalancePaymentStatus = balance_payment_status
      }
      if let discount_amount = orderDict["discount_amount"]?.string {
        productHistoryInfo.orderDiscountAmount = discount_amount
      }
      if let service_fees = orderDict["service_fees"]?.string {
        productHistoryInfo.orderServiceFees = service_fees
      }
      if let orderTaxAmount = orderDict["tax_amount"]?.string {
        productHistoryInfo.orderTaxAmount = orderTaxAmount
      }
      if let orderSubTotal = orderDict["sub_total"]?.string {
        productHistoryInfo.orderSubTotal = orderSubTotal
      }
      if let merchant_amount = orderDict["merchant_amount"]?.string {
        productHistoryInfo.orderMerchantAmount = merchant_amount
      }
      if let booking_amount = orderDict["booking_amount"]?.string {
        productHistoryInfo.orderBookingAmount = booking_amount
      }
      if let balance_amount = orderDict["balance_amount"]?.string {
        productHistoryInfo.orderBalanceAmount = balance_amount
      }
      if let pickup_drop_fees = orderDict["pickup_drop_fees"]?.string {
        productHistoryInfo.orderPickupDropFees = pickup_drop_fees
      }
      if let orderPickDropOption = orderDict["pick_drop_option"]?.string {
        productHistoryInfo.orderPickDropOption = orderPickDropOption
      }
      if let offerId = orderDict["offerid"]?.string {
        productHistoryInfo.offerId = offerId
      }
    }
    
    //Offer
    if let orderDict = dictionary["offerinfo"].dictionary {
      if let offerName = orderDict["offer_name"]?.string {
        productHistoryInfo.offerName = offerName
      }
      if let offerCode = orderDict["offer_code"]?.string {
        productHistoryInfo.offerCode = offerCode
      }
    }
    
    //vehicle
    if let vehcileDict = dictionary["vehicle"].dictionary {
      if let vehicleNumber = vehcileDict["vehicle_number"]?.string {
        productHistoryInfo.vehicleNumber = vehicleNumber
      }
      if let vehicleCompanyName = vehcileDict["vehicle_company_name"]?.string {
        productHistoryInfo.vehicleCompanyName = vehicleCompanyName
      }
      if let vehicleModelName = vehcileDict["vehicle_model_name"]?.string {
        productHistoryInfo.vehicleModelName = vehicleModelName
      }
      if let state = vehcileDict["state"]?.string {
        productHistoryInfo.vehicleState = state
      }
      if let vehicleType = vehcileDict["vtype"]?.string {
        productHistoryInfo.vehicleType = vehicleType
      }
    }
    
    //products
    if let productsArray = dictionary["products"].array {
      
      for productDictionary in productsArray {
        
        let productInfo = MTOrderProductInfo()
        
        if let productId = productDictionary["product_id"].string {
          productInfo.productId = productId
        }
        if let productPrice = productDictionary["price"].string {
          productInfo.productPrice = productPrice
        }
        if let productName = productDictionary["name"].string {
          productInfo.productName = productName
        }
        if let subCatId = productDictionary["sub_catid"].string {
          productInfo.subCatId = subCatId
        }
        if let catId = productDictionary["cat_id"].string {
          productInfo.catId = catId
        }
        if let subCatName = productDictionary["subcatname"].string {
          productInfo.subCatName = subCatName
        }
        if let catName = productDictionary["catname"].string {
          productInfo.catName = catName
        }
        productHistoryInfo.orderHistoryProducts.append(productInfo)
      }
    }
    return productHistoryInfo
  }
  
  /// This service is used to get all merchant orders
  func updateOrderStatus(orderStatusCode: String, userId: String, addIssuesText: String, orderId: String, addIssuesImages: String, serviceAddNotes: String, declineReason: String, timeslotPref: String, onSuccess successBlock: @escaping ((AnyObject) -> Void), onFailure failureBlock: @escaping ((AnyObject) -> Void)) {
    
    let requestURL = MTNetworkConfig.NetworkBase_URL + MTNetworkConfig.UpdateOrderStatus_URL
    
    let realm = try! Realm()
    let userInfo = realm.objects(MTUserInfo.self).first
    
    var parameters : Parameters = Parameters()
    parameters["YEK_HTUA_SW"] = self.getCurrentTimeStamp()
    if let mid = userInfo?.merchantID {
      parameters["mid"] = mid
    }
    if userId.characters.count>0 {
      parameters["uid"] = userId
    }
    parameters["order_id"] = orderId
    parameters["status"] = orderStatusCode
    if addIssuesText.characters.count>0 {
      parameters["add_issues_found"] = addIssuesText
    }
    if addIssuesImages.characters.count>0 {
      parameters["add_issues_images"] = addIssuesImages
    }
    if serviceAddNotes.characters.count>0 {
      parameters["serv_additional_notes"] = serviceAddNotes
    }
    if declineReason.characters.count>0 {
      parameters["reason"] = declineReason
    }
    if timeslotPref.characters.count>0 {
      parameters["set_time_pref"] = timeslotPref
    }
    
    MTLogger.log.info("updateOrderStatus: \(parameters)")
    
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
          MTLogger.log.info("updateOrderStatus error: \(error.localizedDescription)")
          MTCommonUtils.showAlertViewWithTitle(title: "", message: error.localizedDescription)
          failureBlock(false as AnyObject)
          
        } else if let data = response.data, let response = String(data: data, encoding: .utf8) {
          MTLogger.log.info("updateOrderStatus Response: \(response)")
          
          let jsonResponse = self.convertToDictionary(text: response)
          if (self.isErrorMessage(responseDict: jsonResponse)) {
            successBlock(false as AnyObject)
          } else {
            let jsonData = JSON(jsonResponse!)
            if let status = jsonData["Status"].string, status == "Success" {
              self.getMerchantOrders(orderType: MTEnums.OrderType.orderStatus.rawValue, onSuccess: { (success) in
                if (success as! Bool) {
                  successBlock(true as AnyObject)
                } else {
                  failureBlock(false as AnyObject)
                }
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
  
  /// This service is used to get all merchant orders
  func getOrderCancelReason(onSuccess successBlock: @escaping ((AnyObject) -> Void), onFailure failureBlock: @escaping ((AnyObject) -> Void)) {
    
    let requestURL = MTNetworkConfig.NetworkBase_URL + MTNetworkConfig.GetOrderDeclineReasons_URL
    
    //let realm = try! Realm()
    //let userInfo = realm.objects(MTUserInfo.self).first
    
    var parameters : Parameters = Parameters()
    parameters["YEK_HTUA_SW"] = self.getCurrentTimeStamp()
    
    MTLogger.log.info("getOrderCancelReason: \(parameters)")
    
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
          MTLogger.log.info("getOrderCancelReason error: \(error.localizedDescription)")
          MTCommonUtils.showAlertViewWithTitle(title: "", message: error.localizedDescription)
          failureBlock(false as AnyObject)
          
        } else if let data = response.data, let response = String(data: data, encoding: .utf8) {
          MTLogger.log.info("getOrderCancelReason Response: \(response)")
          
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
                  realm.delete(realm.objects(MTOrderCancelReasonInfo.self))
                }
                
                for dictionary in dataArray {
                  
                  let cancelInfo = MTOrderCancelReasonInfo()
                  
                  if let value = dictionary["id"].string {
                    cancelInfo.reasonId = value
                  }
                  if let value = dictionary["option_name"].string {
                    cancelInfo.reasonName = value
                  }
                  if let value = dictionary["display_order"].string {
                    cancelInfo.displayOrder = value
                  }
                  
                  try! realm.write {
                    realm.add(cancelInfo)
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

  /// This service is used to get all merchant orders
  func updateMerchantProduct(productId: String, productPrice: String, mType: String, onSuccess successBlock: @escaping ((AnyObject) -> Void), onFailure failureBlock: @escaping ((AnyObject) -> Void)) {
    
    let requestURL = MTNetworkConfig.NetworkBase_URL + MTNetworkConfig.UpdateProductPriceByMerchant_URL
    
    let realm = try! Realm()
    let userInfo = realm.objects(MTUserInfo.self).first
    
    var priceTypeCol = ""
    if let info = userInfo {
      for merchantType in info.merchantTypes {
        if merchantType.merchantTypeId == mType {
          priceTypeCol = merchantType.priceTypeCol
          break
        }
      }
    }
    var parameters : Parameters = Parameters()
    //parameters["YEK_HTUA_SW"] = self.getCurrentTimeStamp()
    parameters["product_id"] = productId
    parameters["price"] = productPrice
    parameters["merchant_id"] = userInfo?.merchantID
    parameters["price_type_col"] = priceTypeCol
    
    MTLogger.log.info("updateMerchantProduct: \(parameters)")
    
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
          MTLogger.log.info("updateMerchantProduct error: \(error.localizedDescription)")
          MTCommonUtils.showAlertViewWithTitle(title: "", message: error.localizedDescription)
          failureBlock(false as AnyObject)
          
        } else if let data = response.data, let response = String(data: data, encoding: .utf8) {
          MTLogger.log.info("updateMerchantProduct Response: \(response)")
          
          if let jsonResponse = self.convertToDictionary(text: response) {
            if (self.isErrorMessage(responseDict: jsonResponse)) {
              successBlock(false as AnyObject)
            } else {
              let jsonData = JSON(jsonResponse)
              if let status = jsonData["Status"].string, status == "Success" {
                successBlock(true as AnyObject)
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
  
  func getMerchantSpecificProdListForOrderDetail(oderDetail: MTOrderDetailInfo, onSuccess successBlock: @escaping ((AnyObject) -> Void), onFailure failureBlock: @escaping ((AnyObject) -> Void)) {
    
    let requestURL = MTNetworkConfig.NetworkBase_URL + MTNetworkConfig.GetMerchantSpecificProdList_URL
    
    var parameters : Parameters = Parameters()
    parameters["merchant_id"] = oderDetail.merchantID
    /*parameters["vtype"] = oderDetail.vehicleType
    var productIDs = ""
    for (_, element) in (oderDetail.orderHistoryProducts.enumerated()) {
      
      if productIDs.characters.count>0 {
        productIDs = productIDs + "," + element.productId
      } else {
        productIDs = element.productId
      }
    }
    parameters["products"] = productIDs*/
    
    MTLogger.log.info("getMerchantSpecificProdList: \(parameters)")
    
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
          MTLogger.log.info("getMerchantSpecificProdList error: \(error.localizedDescription)")
          MTCommonUtils.showAlertViewWithTitle(title: "", message: error.localizedDescription)
          failureBlock(false as AnyObject)
        } else if let data = response.data, let response = String(data: data, encoding: .utf8) {
          MTLogger.log.info("getMerchantSpecificProdList Response: \(response)")
          
          let jsonResponse = self.convertToDictionary(text: response)
          if (self.isErrorMessage(responseDict: jsonResponse)) {
            successBlock(false as AnyObject)
          } else {
            let json = JSON(jsonResponse!)
            if let status = json["Status"].string, status == "Success" {
              if let dataArray = json["Data"].array {
                
                let realm = try! Realm()
                try! realm.write {
                  realm.delete(realm.objects(MTSelectedMerchantProductInfo.self))
                }
                
                for dictionary in dataArray {
                  let productInfo = MTSelectedMerchantProductInfo()
                  
                  if let productName = dictionary["name"].string {
                    productInfo.productName = productName
                  }
                  if let productId = dictionary["fk_product_id"].string {
                    productInfo.productId = productId
                  }
                  if let subCategoryId = dictionary["sub_catid"].string {
                    productInfo.subCategoryId = subCategoryId
                  }
                  if let categoryId = dictionary["cat_id"].string {
                    productInfo.categoryId = categoryId
                  }
                  if let subCategoryName = dictionary["subcatname"].string {
                    productInfo.subCategoryName = subCategoryName
                  }
                  if let categoryName = dictionary["catname"].string {
                    productInfo.categoryName = categoryName
                  }
                  if let productPrice = dictionary["pmprice"].string {
                    productInfo.productPrice = productPrice
                  }
                  
                  //Update database
                  try! realm.write {
                    realm.add(productInfo)
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
  
  //payment process for stripe
  func processPayment(orderId: String, onSuccess successBlock: @escaping ((AnyObject) -> Void), onFailure failureBlock: @escaping ((AnyObject) -> Void)) {
    
    let requestURL = MTNetworkConfig.NetworkBase_URL + MTNetworkConfig.ProcessOrderPayment_URL
    
    var parameters : Parameters = Parameters()
    parameters["order_id"] = orderId
    
    MTLogger.log.info("processPayment: \(parameters)")
    
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
          MTLogger.log.info("processPayment error: \(error.localizedDescription)")
          MTCommonUtils.showAlertViewWithTitle(title: "", message: error.localizedDescription)
          failureBlock(false as AnyObject)
        } else if let data = response.data, let response = String(data: data, encoding: .utf8) {
          MTLogger.log.info("processPayment Response: \(response)")
          
          let jsonResponse = self.convertToDictionary(text: response)
          if (self.isErrorMessage(responseDict: jsonResponse)) {
            successBlock(false as AnyObject)
          } else {
            let jsonData = JSON(jsonResponse!)
            if let status = jsonData["Status"].string, status == "Success" {
              successBlock(true as AnyObject)
            } else {
              failureBlock(false as AnyObject)
              MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_something_went_wrong".localized)
            }
          }
        }
    }
  }

  //payment process for stripe
  func getReviewAndFeednackForOrder(orderId: String, onSuccess successBlock: @escaping ((AnyObject) -> Void), onFailure failureBlock: @escaping ((AnyObject) -> Void)) {
    
    let requestURL = MTNetworkConfig.NetworkBase_URL + MTNetworkConfig.MerchantOrderReview_URL
    
    var parameters : Parameters = Parameters()
    parameters["order_id"] = orderId
    
    MTLogger.log.info("getReviewAndFeednackForOrder: \(parameters)")
    
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
          MTLogger.log.info("getReviewAndFeednackForOrder error: \(error.localizedDescription)")
          MTCommonUtils.showAlertViewWithTitle(title: "", message: error.localizedDescription)
          failureBlock(false as AnyObject)
        } else if let data = response.data, let response = String(data: data, encoding: .utf8) {
          MTLogger.log.info("getReviewAndFeednackForOrder Response: \(response)")
          
          let jsonResponse = self.convertToDictionary(text: response)
          if (self.isErrorMessage(responseDict: jsonResponse)) {
            successBlock(false as AnyObject)
          } else {
            let jsonData = JSON(jsonResponse!)
            if let status = jsonData["Status"].string, status == "Success" {
              
              if let notificationDict = jsonData["Data"].dictionary {
                
                let reviewInfo = MTReviewRatingsInfo()
                
                if let value = notificationDict["id"]?.string {
                  reviewInfo.reviewID = value
                }
                if let value = notificationDict["fk_merchant_id"]?.string {
                  reviewInfo.merchantId = value
                }
                if let value = notificationDict["fk_user_id"]?.string {
                  reviewInfo.userId = value
                }
                if let value = notificationDict["rating"]?.string {
                  reviewInfo.rating = value
                }
                if let value = notificationDict["cust_review"]?.string {
                  reviewInfo.custReview = value
                }
                if let value = notificationDict["added_date"]?.string {
                  reviewInfo.addedDate = value
                }
                if let value = notificationDict["user_name"]?.string {
                  reviewInfo.userName = value
                }
                if let value = notificationDict["user_id"]?.string {
                  reviewInfo.userEmailId = value
                }
                if let value = notificationDict["order_id"]?.string {
                  reviewInfo.orderId = value
                }
                if let value = notificationDict["heading"]?.string {
                  reviewInfo.heading = value
                }
                
                successBlock(reviewInfo as AnyObject)
              } else {
                failureBlock(false as AnyObject)
                MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_something_went_wrong".localized)
              }
            } else {
              failureBlock(false as AnyObject)
              MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_something_went_wrong".localized)
            }
          }
        }
    }
  }
}


