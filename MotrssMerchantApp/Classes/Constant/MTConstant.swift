/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTConstant.swift
 
 Description: This class includes the constant used in applications.
 
 Created By: Pranay U.
 
 Creation Date: 25/06/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import UIKit

struct MTConstant {

  /*
   * Keys Constant
   */
  static let TestFairyAPIKey            = "0fa470093bfa5a0caded743a90eab6db53442dad"
  static let FacebbokURLSchemeKey       = "fb654581127911812"
  static let GoogleURLSchemeKey         = "com.googleusercontent.apps.1015045742316-1umgdp43kqvgm7lavql7ak280u3rddaa"
  
  static let AWS3AccessKey              = "AKIAJAZVF4PZRNO6IAEA"
  static let AWS3SecretKey              = "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"
  
  static let AppStoreMotrssUserAppId    = "id959379869"
  
  /*
  * Date formats used in app
  */
  static let dateFormat1                = "MMM dd,yyyy"
  static let dateFormat2                = "yyy-MM-dd"
  static let dateFormat3                = "yyyy-MM-dd'T'HH:mm:ss"
  static let dateFormat4                = "EEE,MMM dd"
  static let dateFormat5                = "EEEE, MMM d, h:mm a"
  static let dateFormat6                = "MMM d, h:mm a"
  
  /*
  * Navigation Customization
  */
  
  static let navigationBarColor         = UIColor.appThemeColor
  static let navigationTintColor        = UIColor.white
  
  static let fontMavenProBold           = "MavenPro-Bold"
  static let fontMavenProMedium         = "MavenPro-Medium"
  static let fontHMavenProRegular       = "MavenPro-Regular"

  /*
   * UserDefault Constant
   */
  static let Default_Access_Token                     = "default_access_token"
  static let Default_Email                            = "default_email"
  static let UserDefault_ProductsUpdated              = "User_Default_Products_Updated"
  static let UserDefault_ProfileUpdated               = "User_Default_Profile_Updated"
  
  /*
   * Notification Oberser Constant
   */
  static let Notification_RefeshOrderStatus           = "OrderStatusUpdated"
  static let Notification_RefeshOrderStatusUI         = "OrderStatusUpdated"
  static let Notification_RefershNewOrder             = "RefreshNewOrders"
  static let Notification_RefreshMErchantOffers       = "RefreshMErchantOffers"
  static let Notification_RefreshTeamMembers          = "RefreshTeamMembers"
  static let Notification_UpdateServiceList           = "Notification_UpdateServiceListUI"
  
  /*
  * Viewcontroller Identifiers
  */
  static let LoginNavigationViewControllerID          = "LoginNavigationViewController"
  static let LoginViewControllerID                    = "LoginViewController"
  static let MainViewControllerID                     = "MainViewController"
  static let DashboardViewControlerID                 = "DashboardViewControler"
  static let OfferViewControlerID                     = "OfferViewControler"
  static let OfferListViewControlerID                 = "OfferListViewControler"
  static let OfferDetailViewControlerID               = "OfferDetailViewControler"
  static let TeamMemberViewControlerID                = "TeamMemberViewControler"
  static let TeamMemberListViewControlerID            = "TeamMemberListViewControler"
  static let TeamMemberDetailViewControllerID         = "TeamMemberDetailViewController"
  static let CalendarViewControlerID                  = "CalendarViewControler"
  static let ProfileViewControlerID                   = "ProfileViewControler"
  static let ReviewAndRatingViewControlerID           = "ReviewAndRatingViewControler"
  
  /*
   * Segue Identifiers
   */
  static let LoginViewSegueIdentifier                   = "LoginViewSegueIdentifier"
  static let HomeViewSegueIdentifier                    = "homeViewSegueIdentifier"
  static let SideMenuSegueIdentifier                    = "sideMenuSegueIdentifier"
  
  static let OrderListViewControllerIdentifier          = "OrderListViewController"
  static let OrderDetailsViewControllerIdentifier       = "OrderDetailsViewController"
  static let UpdateOrderStatusViewControllerIdentifier  = "UpdateOrderStatusViewController"
  static let SelectServiceViewControllerID              = "SelectServiceViewController"
  static let SelectServiceListViewControllerID          = "SelectServiceListViewController"
  
  /*
  * UITableViewCell Identifiers
  */
  static let SideMenuTableViewIdentifier                = "SideMenuTableViewIdentifier"
 
}
