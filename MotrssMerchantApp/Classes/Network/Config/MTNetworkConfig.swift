/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTNetworkConfig.swift
 
 Description: This class is used to configure the network api settings.
 
 Created By: Pranay U.
 
 Creation Date: 25/06/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import UIKit

struct MTNetworkConfig {
  
  /**
   Web API URL
   */
  #if DIST
  //Server URL for QA Release/Client Release
  static let NetworkBase_URL              = "http://motrss-api-dev.us-west-2.elasticbeanstalk.com/merchant/"
  #elseif RELEASE
  //Server URL for App Store Release
  static let NetworkBase_URL              = "http://motrss-api-dev.us-west-2.elasticbeanstalk.com/merchant/"
  #else
  //Server URL for Development
  static let NetworkBase_URL              = "http://motrss-api-dev.us-west-2.elasticbeanstalk.com/merchant/"
  #endif
  
  static let LoginWithMobile_URL          = "MerchantMobileLogin"
  static let LoginWithEmail_URL           = "MerchantLogin"
  static let SendTempPasswordOnEmai_URL   = "SendTempPasswordOnEmailId"
  static let ForgotMobilePin_URL          = "MerchantForgotPin"
  static let VerifyOTP_URL                = "MerchantVerifyOTP"
  static let UpdateOTP_URL                = "MerchantUpdatePin"
  static let ResetPassword_URL            = "MerchantPassword"
  
  static let GetMerchantNewOrders_URL     = "MerchantNewOrders"
  static let GetMerchantCurrentOrders_URL = "MerchantUpdateOrders"
  static let GetMerchantOrdersHistory_URL = "MerchantHistoryOrderList"
  
  static let GetMerchantOrders_URL        = "MerchantBookingOrders"
  static let UpdateOrderStatus_URL        = "ChangeOrderStatus"
  static let GetOrderDeclineReasons_URL   = "GetDeclineReasons"
  
  static let MerchantOrderInfo_URL        = "MerchantOrderInfo"
  
  static let GetMerchantOffer_URL         = "GetMerchantOffer"
  static let AddMerchantOffer_URL         = "AddMerchantOffer"
  static let UpdateMerchantOffer_URL      = "UpdateMerchantOffer"
  static let DeleteMerchantOffer_URL      = "DeleteMerchantOffer"
  
  static let GetTeamMemberList_URL        = "TeamMemberList"
  static let AddTeamMemberInfo_URL        = "AddTeamMemberInfo"
  static let UpdateTeamMemberInfo_URL     = "UpdateTeamMemberInfo"
  static let DeleteTeamMemberInfo_URL     = "DeleteTeamMemberInfo"
  
  static let GetMerchantSlots_URL         = "GetMerchantSlots"
  static let UpdateMerchantSlots_URL      = "UpdateMerchantSlots"
  
  static let GetMerchantProfile_URL       = "MerchantProfile"
  static let UpdateMerchantProfile_URL    = "MerchantProfileUpdate"
  static let ChangeMerchantPassword_URL   = "MerchantPassword"
  static let SendVerifyEmail_URL          = "SendVerifyMerchEmail"
  
  static let CheckCacheStatus_URL         = "MerchantCheckCacheStatus"
  static let SendOTPAfterLogin_URL        = "MerchantSendOTP"
  static let GetMerchantReviewRating_URL  = "MerchantReviewRating"
  static let UpdateProductPriceByMerchant_URL  = "UpdateProductPriceByMerchant"
  static let GetMerchantSpecificProdList_URL       = "GetMerchantSpecificProdList"
  static let ProcessOrderPayment_URL       = "Process_Order_Payment"
  static let MerchantOrderReview_URL       = "MerchantOrderReview"
  static let MerchantHistoryOrderDetails_URL       = "MerchantHistoryOrderDetails"
  
}

