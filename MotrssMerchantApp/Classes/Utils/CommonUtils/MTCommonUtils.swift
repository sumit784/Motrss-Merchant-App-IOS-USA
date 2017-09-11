/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTCommonUtils.swift
 
 Description: This class includes common code used throughout the application.
 
 Created By: Pranay U.
 
 Creation Date: 25/06/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import UIKit
import MapKit
import RealmSwift
import Kingfisher

class MTCommonUtils: NSObject {
  
  /// This function is used to re-format the mobile number
  ///
  /// - Parameter phoneString: formated mobile number
  /// - Returns: mobile number in digit format
  class func convertPhoneStringToDigitFormat(phoneString : String) -> String {
    var convertedString = phoneString.replacingOccurrences(of: "(", with: "")
    convertedString = convertedString.replacingOccurrences(of: ")", with: "")
    convertedString = convertedString.replacingOccurrences(of: "-", with: "")
    convertedString = convertedString.replacingOccurrences(of: " ", with: "")
    return convertedString
  }
  
  /// This function is used to show the alert message with title and message string.
  ///
  /// - Parameters:
  ///   - title: title string
  ///   - message: message string
  class func showAlertViewWithTitle(title: String, message: String) {
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "general_ok_text".localized, style: UIAlertActionStyle.default, handler: { action in
      switch action.style{
      case .default:
        MTLogger.log.info("default")

      case .cancel:
        MTLogger.log.info("cancel")

      case .destructive:
        MTLogger.log.info("destructive")
      }

    }))
    self.showAlert(alert: alert)
  }
  
  /// Common function to show alert
  ///
  /// - Parameter alert: UIAlertController object to show
  class func showAlert(alert: UIAlertController) {
    let alertViewController = self.visibleViewController()
    alertViewController.present(alert, animated: true, completion: nil)
  }

  /// This function is used to get current visible controller
  ///
  /// - Returns: UIViewController
  class func visibleViewController() -> UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let rootVC = appDelegate.window?.rootViewController
    return self.findVisibleViewController(vc: rootVC!)
  }

  /// This function is used to find current visible controller on the window
  ///
  /// - Parameter vc: view controller
  /// - Returns: view controller
  class func findVisibleViewController(vc : UIViewController) -> UIViewController {
    
    if (vc.presentedViewController != nil) {
      return self.findVisibleViewController(vc: vc.presentedViewController!)
    } else if vc.isKind(of: UISplitViewController.self) {
      let svc = vc as! UISplitViewController
      if svc.viewControllers.count>0 {
        return self.findVisibleViewController(vc: svc.viewControllers.last!)
      } else {
        return vc
      }
    } else if vc.isKind(of: UINavigationController.self) {
      let nvc = vc as! UINavigationController
      if nvc.viewControllers.count>0 {
        return self.findVisibleViewController(vc: nvc.topViewController!)
      } else {
        return vc
      }
    } else if vc.isKind(of: UITabBarController.self) {
      let tvc = vc as! UITabBarController
      if (tvc.viewControllers?.count)!>0 {
        return self.findVisibleViewController(vc: tvc.selectedViewController!)
      } else {
        return vc
      }
    } else {
      return vc
    }
  }
  
  /// This function is used to used to validate a string for the correct email address format.
  ///
  /// - Parameter emailString: email string
  /// - Returns: true is validate
  class func isValidEmail(emailString:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: emailString)
  }
  
  /// This function is used to get a viewcontroller with given storyboard name and viewcontroller id.
  ///
  /// - Parameters:
  ///   - storyboardName: storyboard name
  ///   - viewcontrollerID: viewcntroller identifier
  /// - Returns: UIViewController
  class func viewcontroller(storyboardName : String, viewcontrollerID : String) -> UIViewController {
    let storyboard = UIStoryboard.init(name: storyboardName, bundle: nil)
    let viewcontroller = storyboard.instantiateViewController(withIdentifier: viewcontrollerID)
    return viewcontroller
  }
  
  class func selectServiceListViewControler(subCategory: MTSubCategoryInfo, withFrame frame: CGRect, mainClassObj: MTSelectServiceViewController, serviceType: String, categoryType: String, mType: String) -> MTSelectServiceListViewController {
    let serviceListVC = MTCommonUtils.viewcontroller(storyboardName: "Main", viewcontrollerID: MTConstant.SelectServiceListViewControllerID) as! MTSelectServiceListViewController
    serviceListVC.selectedSubCategory = subCategory
    serviceListVC.mainPageViewFrame = frame
    serviceListVC.selecteServiceClassObj = mainClassObj
    serviceListVC.selecteServiceType = serviceType
    serviceListVC.selecteCategoryType = categoryType
    serviceListVC.selectMerchantType = mType
    return serviceListVC
  }
  
  /// This function is used to set the app home screen
  class func gotoAppHomeScreen() {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let mainVC = MTCommonUtils.viewcontroller(storyboardName: "Main", viewcontrollerID: MTConstant.MainViewControllerID)
    appDelegate.window?.rootViewController = mainVC
  }
  
  /// This is method is used to load the nib of IntroView
  ///
  /// - Returns: UIView
  class func loadViewFromNib(nibName : String) -> UIView {
    let nib = UINib(nibName: nibName, bundle: Bundle.main)
    let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView    
    return view
  }
  
//  class func updateImageCache(imageUrl imageString: String, forImage imageView:UIImageView, placeholder: Image? = nil, contentMode: UIViewContentMode? = nil) {
//    //let baseImgeUrl = "https://s3-us-west-1.amazonaws.com/motrss-app-assets/assets/vehicle_images/"
//    let baseImgeUrl = "https://s3-us-west-1.amazonaws.com/motrss-app-assets/vehicle-images/"
//    if imageString.characters.count>0 && imageString != "00" {
//      var imgeUrlStr = baseImgeUrl + imageString
//      imgeUrlStr = imgeUrlStr.replacingOccurrences(of: " ", with: "%20")
//      let resource = ImageResource(downloadURL: URL(string: imgeUrlStr)!, cacheKey: imageString)
//      imageView.kf.setImage(with: resource, placeholder: placeholder)
//      if let imageMode = contentMode {
//        imageView.contentMode = imageMode
//      }
//    }
//  }
  
  class func updateProfileImageCache(imageUrl imageString: String, forImage imageView:UIImageView, placeholder: Image? = nil, contentMode: UIViewContentMode? = nil) {
    let baseImgeUrl = "https://s3-us-west-1.amazonaws.com/motrss-dev-assets/profile-images/"
    if imageString.characters.count>0 && imageString != "00" {
      var imgeUrlStr = baseImgeUrl + imageString
      imgeUrlStr = imgeUrlStr.replacingOccurrences(of: " ", with: "%20")
      let resource = ImageResource(downloadURL: URL(string: imgeUrlStr)!, cacheKey: imageString)
      imageView.kf.setImage(with: resource, placeholder: placeholder)
      if let imageMode = contentMode {
        imageView.contentMode = imageMode
      }
    }
  }

  class func updateTeamMemberImageCache(imageUrl imageString: String, forImage imageView:UIImageView, placeholder: Image? = nil, contentMode: UIViewContentMode? = nil) {
    let baseImgeUrl = "https://s3-us-west-1.amazonaws.com/motrss-dev-assets/team-member-images/"
    if imageString.characters.count>0 && imageString != "00" {
      var imgeUrlStr = baseImgeUrl + imageString
      imgeUrlStr = imgeUrlStr.replacingOccurrences(of: " ", with: "%20")
      let resource = ImageResource(downloadURL: URL(string: imgeUrlStr)!, cacheKey: imageString)
      imageView.kf.setImage(with: resource, placeholder: placeholder)
      if let imageMode = contentMode {
        imageView.contentMode = imageMode
      }
    }
  }
  
  class func updateOrderImageCache(imageUrl imageString: String, forImage imageView:UIImageView, placeholder: Image? = nil, contentMode: UIViewContentMode? = nil, downloadHandler: @escaping ((UIImage, Int) -> Void)) {
    let baseImgeUrl = "https://s3-us-west-1.amazonaws.com/motrss-dev-assets/order-images/"
    if imageString.characters.count>0 && imageString != "00" {
      var imgeUrlStr = baseImgeUrl + imageString + ".jpg"
      imgeUrlStr = imgeUrlStr.replacingOccurrences(of: " ", with: "%20")
      let resource = ImageResource(downloadURL: URL(string: imgeUrlStr)!, cacheKey: imageString)
      imageView.kf.setImage(with: resource, placeholder: placeholder, completionHandler: { (image, error, cacheType, url) in
        if let downloadedImage = image {
          MTLogger.log.info("Tag: \(imageView.tag)")
          downloadHandler(downloadedImage, imageView.tag)
        }
      })
      if let imageMode = contentMode {
        imageView.contentMode = imageMode
      }
    }
  }
  
  class func updateRatings(rating: String?, withImages imgView1: UIImageView, imgView2: UIImageView, imgView3: UIImageView, imgView4: UIImageView, imgView5: UIImageView, isWhiteEmptyImg: Bool) {
    
    if let ratingStr = rating {
      let ratingValue = Double(ratingStr)!
      
      if ratingValue <= Double(1.0) {
        imgView1.image = UIImage(named: "star_full_img")
        if isWhiteEmptyImg {
          imgView2.image = UIImage(named: "star_empty_white_img")
          imgView3.image = UIImage(named: "star_empty_white_img")
          imgView4.image = UIImage(named: "star_empty_white_img")
          imgView5.image = UIImage(named: "star_empty_white_img")
        } else {
          imgView2.image = UIImage(named: "star_empty_img")
          imgView3.image = UIImage(named: "star_empty_img")
          imgView4.image = UIImage(named: "star_empty_img")
          imgView5.image = UIImage(named: "star_empty_img")
        }
      } else if ratingValue <= Double(1.5) {
        imgView1.image = UIImage(named: "star_full_img")
        imgView2.image = UIImage(named: "star_half_img")
        if isWhiteEmptyImg {
          imgView3.image = UIImage(named: "star_empty_white_img")
          imgView4.image = UIImage(named: "star_empty_white_img")
          imgView5.image = UIImage(named: "star_empty_white_img")
        } else {
          imgView3.image = UIImage(named: "star_empty_img")
          imgView4.image = UIImage(named: "star_empty_img")
          imgView5.image = UIImage(named: "star_empty_img")
        }
      } else if ratingValue <= Double(2.0) {
        imgView1.image = UIImage(named: "star_full_img")
        imgView2.image = UIImage(named: "star_full_img")
        if isWhiteEmptyImg {
          imgView3.image = UIImage(named: "star_empty_white_img")
          imgView4.image = UIImage(named: "star_empty_white_img")
          imgView5.image = UIImage(named: "star_empty_white_img")
        } else {
          imgView3.image = UIImage(named: "star_empty_img")
          imgView4.image = UIImage(named: "star_empty_img")
          imgView5.image = UIImage(named: "star_empty_img")
        }
      } else if ratingValue <= Double(2.5) {
        imgView1.image = UIImage(named: "star_full_img")
        imgView2.image = UIImage(named: "star_full_img")
        imgView3.image = UIImage(named: "star_half_img")
        if isWhiteEmptyImg {
          imgView4.image = UIImage(named: "star_empty_white_img")
          imgView5.image = UIImage(named: "star_empty_white_img")
        } else {
          imgView4.image = UIImage(named: "star_empty_img")
          imgView5.image = UIImage(named: "star_empty_img")
        }
      } else if ratingValue <= Double(3.0) {
        imgView1.image = UIImage(named: "star_full_img")
        imgView2.image = UIImage(named: "star_full_img")
        imgView3.image = UIImage(named: "star_full_img")
        if isWhiteEmptyImg {
          imgView4.image = UIImage(named: "star_empty_white_img")
          imgView5.image = UIImage(named: "star_empty_white_img")
        } else {
          imgView4.image = UIImage(named: "star_empty_img")
          imgView5.image = UIImage(named: "star_empty_img")
        }
      } else if ratingValue <= Double(3.5) {
        imgView1.image = UIImage(named: "star_full_img")
        imgView2.image = UIImage(named: "star_full_img")
        imgView3.image = UIImage(named: "star_full_img")
        imgView4.image = UIImage(named: "star_half_img")
        if isWhiteEmptyImg {
          imgView5.image = UIImage(named: "star_empty_white_img")
        } else {
          imgView5.image = UIImage(named: "star_empty_img")
        }
      } else if ratingValue <= Double(4.0) {
        imgView1.image = UIImage(named: "star_full_img")
        imgView2.image = UIImage(named: "star_full_img")
        imgView3.image = UIImage(named: "star_full_img")
        imgView4.image = UIImage(named: "star_full_img")
        if isWhiteEmptyImg {
          imgView5.image = UIImage(named: "star_empty_white_img")
        } else {
          imgView5.image = UIImage(named: "star_empty_img")
        }
      } else if ratingValue <= Double(4.5) {
        imgView1.image = UIImage(named: "star_full_img")
        imgView2.image = UIImage(named: "star_full_img")
        imgView3.image = UIImage(named: "star_full_img")
        imgView4.image = UIImage(named: "star_full_img")
        imgView5.image = UIImage(named: "star_half_img")
        
      } else if ratingValue <= Double(5.0) {
        imgView1.image = UIImage(named: "star_full_img")
        imgView2.image = UIImage(named: "star_full_img")
        imgView3.image = UIImage(named: "star_full_img")
        imgView4.image = UIImage(named: "star_full_img")
        imgView5.image = UIImage(named: "star_full_img")
        
      } else {
        if isWhiteEmptyImg {
          imgView1.image = UIImage(named: "star_empty_white_img")
          imgView2.image = UIImage(named: "star_empty_white_img")
          imgView3.image = UIImage(named: "star_empty_white_img")
          imgView4.image = UIImage(named: "star_empty_white_img")
          imgView5.image = UIImage(named: "star_empty_white_img")
        } else {
          imgView1.image = UIImage(named: "star_empty_img")
          imgView2.image = UIImage(named: "star_empty_img")
          imgView3.image = UIImage(named: "star_empty_img")
          imgView4.image = UIImage(named: "star_empty_img")
          imgView5.image = UIImage(named: "star_empty_img")
        }
      }
    }
  }
  
  class func isValidMobileNumber(formatedMobileNo : String) -> Bool {
    if formatedMobileNo.characters.count != 10 {
      return false
    } else if formatedMobileNo == "0000000000" || formatedMobileNo == "11111111111"  || formatedMobileNo == "2222222222" || formatedMobileNo == "3333333333" || formatedMobileNo == "1000000000" || formatedMobileNo == "0111111111" || formatedMobileNo == "0011111111" || formatedMobileNo == "0101010101" {
      return false
    } else if (formatedMobileNo.characters.first == "0") || (formatedMobileNo.characters.first == "1") {
      return false
    }
    return true
  }
  
  class func showAppTermsAndCondition() {
    let url = URL(string: "http://motrss.com/terms-of-use/")!
    if #available(iOS 10.0, *) {
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    } else {
      UIApplication.shared.openURL(url)
    }
  }
  
  /*class func orderViewControler(orderType: MTEnums.OrdersSelectedType, withFrame frame: CGRect) -> MTOrderListViewController {
    let orderListVC = MTCommonUtils.viewcontroller(storyboardName: "Main", viewcontrollerID: MTConstant.OrderListViewControllerIdentifier) as! MTOrderListViewController
    orderListVC.orderType = orderType
    orderListVC.mainPageViewFrame = frame
    return orderListVC
  }*/
  
  class func orderViewControler(orderType: MTEnums.OrdersSelectedType) -> MTOrderListViewController {
    let orderListVC = MTCommonUtils.viewcontroller(storyboardName: "Main", viewcontrollerID: MTConstant.OrderListViewControllerIdentifier) as! MTOrderListViewController
    orderListVC.orderType = orderType
    //orderListVC.mainPageViewFrame = frame
    return orderListVC
  }
  
  class func offerViewControler(offerType: MTEnums.OffersSelectedType) -> MTOfferListViewControler {
    let offerListVC = MTCommonUtils.viewcontroller(storyboardName: "Main", viewcontrollerID: MTConstant.OfferListViewControlerID) as! MTOfferListViewControler
    offerListVC.offerType = offerType
    //orderListVC.mainPageViewFrame = frame
    return offerListVC
  }
  
  class func TeamMemberListViewControler(teamType: MTEnums.TeamMemberSelectedType) -> MTTeamMemberListViewControler {
    let teamListVC = MTCommonUtils.viewcontroller(storyboardName: "Main", viewcontrollerID: MTConstant.TeamMemberListViewControlerID) as! MTTeamMemberListViewControler
    teamListVC.teamType = teamType
    //orderListVC.mainPageViewFrame = frame
    return teamListVC
  }
  
  class func getShortOrderStatusDetails(orderStatusCode: String) -> String {
    var orderStatusDetails = ""
    
    if orderStatusCode == "201" {
      orderStatusDetails = "Pending"
    } else if orderStatusCode == "205" {
      orderStatusDetails = "Confirmed"
    } else if orderStatusCode == "206" {
      orderStatusDetails = "Rejected"
    /*} else if orderStatusCode == "501" {
      orderStatusDetails = "Cancelled"*/
    } else if orderStatusCode == "301" {
      orderStatusDetails = "Amount block"
    } else if orderStatusCode == "210" {
      orderStatusDetails = "Vehicle Received"
    } else if orderStatusCode == "225" {
      orderStatusDetails = "Service Started"
    } else if orderStatusCode == "230" {
      orderStatusDetails = "Issue Found"
    } else if orderStatusCode == "235" {
      orderStatusDetails = "Service Completed"
    } else if orderStatusCode == "240" {
      orderStatusDetails = "Ready For Delivery"
    } else if orderStatusCode == "245" {
      orderStatusDetails = "Delivered to custeomer"
    } else if orderStatusCode == "250" {
      orderStatusDetails = "Service Note Update"
    } else if orderStatusCode == "260" {
      orderStatusDetails = "Order Completed"
    } else if orderStatusCode == "405" {
      orderStatusDetails = "Assign Pickup"
    } else if orderStatusCode == "401" {
      orderStatusDetails = "Assign Dropoff"
    }
    return orderStatusDetails
  }
  
  class func getOrderStatusDetails(orderStatusCode: String) -> String {
    var orderStatusDetails = ""
    
    if orderStatusCode == "201" {
      orderStatusDetails = "service_status_message_text_201".localized
    } else if orderStatusCode == "205" {
      orderStatusDetails = "service_status_message_text_205".localized
    } else if orderStatusCode == "206" {
      orderStatusDetails = "service_status_message_text_206".localized
    } else if orderStatusCode == "501" {
      orderStatusDetails = "service_status_message_text_501".localized
    } else if orderStatusCode == "301" {
      orderStatusDetails = "service_status_message_text_301".localized
    } else if orderStatusCode == "305" {
      orderStatusDetails = "service_status_message_text_305".localized
    } else if orderStatusCode == "210" {
      orderStatusDetails = "service_status_message_text_210".localized
    } else if orderStatusCode == "225" {
      orderStatusDetails = "service_status_message_text_225".localized
    } else if orderStatusCode == "230" {
      orderStatusDetails = "service_status_message_text_230".localized
    } else if orderStatusCode == "220" {
      orderStatusDetails = "service_status_message_text_220".localized
    } else if orderStatusCode == "235" {
      orderStatusDetails = "service_status_message_text_235".localized
    } else if orderStatusCode == "240" {
      orderStatusDetails = "service_status_message_text_240".localized
    } else if orderStatusCode == "245" {
      orderStatusDetails = "service_status_message_text_245".localized
    } else if orderStatusCode == "250" {
      orderStatusDetails = "service_status_message_text_250".localized
    } else if orderStatusCode == "260" {
      orderStatusDetails = "service_status_message_text_260".localized
    } else if orderStatusCode == "401" {
      orderStatusDetails = "service_status_message_text_401".localized
    } else if orderStatusCode == "405" {
      orderStatusDetails = "service_status_message_text_405".localized
    } else if orderStatusCode == "320" {
      orderStatusDetails = "service_status_message_text_320".localized
    } else if orderStatusCode == "325" {
      orderStatusDetails = "service_status_message_text_320".localized
    }
    return orderStatusDetails
  }
}
