//
//  MTDataModel.swift
//  MotrssUserApp
//
//  Created by Pranay on 25/06/17.
//  Copyright © 2017 mobitronics. All rights reserved.
//

import Foundation
import RealmSwift

class MTUserInfo: Object {
  dynamic var userID = ""
  dynamic var emailID = ""
  dynamic var loginID = ""
  dynamic var merchantID = ""
  dynamic var ownerName = ""
  dynamic var pickupDeskID = ""
  dynamic var mobileNumber = ""
  dynamic var isLoginWithTempPwd = ""
  dynamic var authKey = ""
  dynamic var password = ""
  
  dynamic var isMobileVerified = ""
  dynamic var isEmailVerified = ""
  dynamic var businessName = ""
  dynamic var shopImage = ""
  
  let merchantTypes = List<MTMerchantTypeInfo>()
}

class MTMerchantTypeInfo: Object {
  
  dynamic var merchantTypeId = ""
  dynamic var priceTypeCol = ""
}

//Order History
class MTOrderDetailInfo: Object {
  
  dynamic var orderType = ""
  
  //merchant
  dynamic var merchantName = ""
  dynamic var merchantMobile = ""
  dynamic var merchantID = ""
  dynamic var merchantAddressOne = ""
  dynamic var merchantAddressTwo = ""
  dynamic var merchantState = ""
  dynamic var merchantCity = ""
  
  //vehicle
  dynamic var userName = ""
  dynamic var contactMobile = ""
  dynamic var pickAddress = ""
  dynamic var dropAddress = ""
  
  //order
  dynamic var orderId = ""
  dynamic var orderStatus = ""
  dynamic var orderPaymentStatus = ""
  dynamic var orderIsFeedback = ""
  dynamic var orderNote = ""
  dynamic var orderTeamMemberId = ""
  dynamic var additionalIssuesFound = ""
  dynamic var additionalIssuesImages = ""
  dynamic var orderDate = ""
  
  dynamic var timePreference1 = ""
  dynamic var timePreference2 = ""
  dynamic var timePreference3 = ""
  
  dynamic var orderFinalAmount = ""
  dynamic var orderBookingPaymentStatus = ""
  dynamic var orderBalancePaymentStatus = ""
  dynamic var orderDiscountAmount = ""
  dynamic var orderServiceFees = ""
  dynamic var orderTaxAmount = ""
  dynamic var orderSubTotal = ""
  dynamic var orderMerchantAmount = ""
  dynamic var orderBookingAmount = ""
  dynamic var orderBalanceAmount = ""
  dynamic var orderPickupDropFees = ""
  dynamic var orderPickDropOption = ""
  dynamic var offerId = ""
  
  //Offer
  dynamic var offerName = ""
  dynamic var offerCode = ""

  //vehicle
  dynamic var vehicleNumber = ""
  dynamic var vehicleCompanyName = ""
  dynamic var vehicleModelName = ""
  dynamic var vehicleState = ""
  dynamic var vehicleType = ""
  
  //products
  let orderHistoryProducts = List<MTOrderProductInfo>()
}

class MTOrderProductInfo: Object {
  
  //products
  dynamic var productId = ""
  dynamic var productPrice = ""
  dynamic var productName = ""
  dynamic var subCatId = ""
  dynamic var catId = ""
  dynamic var subCatName = ""
  dynamic var catName = ""
}

//Offers
class MTOffersDetailInfo: Object {
  
  dynamic var offerId = ""
  dynamic var offerName = ""
  dynamic var offerCode = ""
  dynamic var offerDescription = ""
  dynamic var imgUrl = ""
  dynamic var offerMaxAmt = ""
  dynamic var offerType = ""
  dynamic var offerBy = ""
  dynamic var percentOffAmt = ""
  dynamic var isPercentOff = ""
  dynamic var offerStartDate = ""
  dynamic var offerExpDate = ""
  dynamic var fkUserId = ""
  dynamic var isActive = ""
  dynamic var awaitingApproval = ""
  dynamic var status = ""
}

//Team Member
class MTTeamDetailInfo: Object {
  
  dynamic var teamId = ""
  dynamic var merchantId = ""
  dynamic var profileImage = ""
  dynamic var fullName = ""
  dynamic var email = ""
  dynamic var mobile = ""
  dynamic var gender = ""
  dynamic var licenceNumber = ""
  dynamic var licenceExpDate = ""
  dynamic var licenceState = ""
  dynamic var licencePath = ""
  dynamic var awaitingApproval = ""
}

//Revenue
class MTEarningsDetailInfo: Object {
  
  dynamic var totalEarningMerchant = ""
  dynamic var totalEarningAll = ""
  dynamic var totalBalanceMerchant = ""
  dynamic var totalBalanceAll = ""
  dynamic var monthEarningMerchant = ""
  dynamic var monthEarningAll = ""
}

//Timeslot
class MTMerchantSlotsInfo: Object {
  
  dynamic var merchantTimeScheduleId = ""
  dynamic var merchantId = ""
  dynamic var date = ""
  dynamic var dateId = ""
  dynamic var isOpen = ""
  dynamic var monthEarningAll = ""
  
  //slots
  let slots = List<MTSlotsData>()
}

class MTSlotsData: Object {
  
  dynamic var scheduleMapId = ""
  dynamic var scheduleSlotName = ""
  dynamic var scheduleSlotTime = ""
  dynamic var slotCapacity = ""
}

class MTOrderCancelReasonInfo: Object {
  
  dynamic var reasonId = ""
  dynamic var reasonName = ""
  dynamic var displayOrder = ""
}

class MTReviewRatingsInfo: Object {
  
  dynamic var reviewID = ""
  dynamic var merchantId = ""
  dynamic var userId = ""
  dynamic var rating = ""
  dynamic var custReview = ""
  dynamic var addedDate = ""
  dynamic var userName = ""
  dynamic var userEmailId = ""
  dynamic var orderId = ""
  dynamic var heading = ""
}

//Select Service

//class MTParentCategoryInfo: Object {
//  dynamic var categoryName = ""
//  dynamic var categoryId = ""
//  dynamic var rootCategoryId = ""
//  dynamic var vehicleTypeId = ""
//  dynamic var merchantTypeId = ""
//}

class MTServiceCategoryInfo: Object {
  
  dynamic var parentCategoryType = ""
  
  dynamic var categoryId = ""
  dynamic var categoryName = ""
  dynamic var categoryImage = ""
  
  let subCategoryList = List<MTSubCategoryInfo>()
}

class MTSubCategoryInfo: Object {
  
  dynamic var parentCategoryType = ""
  dynamic var categoryId = ""
  dynamic var categoryName = ""
  
  dynamic var subCategoryName = ""
  dynamic var subCategoryId = ""
  dynamic var subCategoryImage = ""
  
  let subCategoryProductList = List<MTSubCategoryProductInfo>()
}

class MTSubCategoryProductInfo: Object {
  
  dynamic var parentCategoryType = ""
  dynamic var categoryId = ""
  dynamic var categoryName = ""
  dynamic var subCategoryId = ""
  dynamic var subCategoryName = ""
  
  dynamic var productId = ""
  dynamic var productName = ""
  dynamic var priceVehicleType1 = ""
  dynamic var priceVehicleType1Avg = ""
  dynamic var priceVehicleType2 = ""
  dynamic var priceVehicleType2Avg = ""
  dynamic var priceVehicleType3 = ""
  dynamic var priceVehicleType3Avg = ""
  dynamic var priceVehicleType7 = ""
  dynamic var priceVehicleType7Avg = ""
  dynamic var priceVehicleType15 = ""
  dynamic var priceVehicleType15Avg = ""
  dynamic var isPackage = ""
  
  let packageList = List<MTProductPackageInfo>()
}

class MTProductPackageInfo: Object {
  dynamic var itemId = ""
  dynamic var itemName = ""
  dynamic var itemPrice = ""
  
  dynamic var priceVehicleType1 = ""
  dynamic var priceVehicleType2 = ""
  dynamic var priceVehicleType3 = ""
  dynamic var priceVehicleType7 = ""
  dynamic var priceVehicleType15 = ""
}

class MTSelectedMerchantProductInfo: Object {
  
  dynamic var productName = ""
  dynamic var productId = ""
  dynamic var subCategoryId = ""
  dynamic var categoryId = ""
  dynamic var categoryName = ""
  dynamic var subCategoryName = ""
  dynamic var productPrice = ""
}
