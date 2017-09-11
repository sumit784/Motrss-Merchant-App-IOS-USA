/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTBaseViewController.swift
 
 Description: This class is the base class for the all viewcontroller. So we can put the common code used in application.
 
 Created By: Pranay U.
 
 Creation Date: 25/06/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import Foundation
import RealmSwift

class MTBaseViewController: UIViewController {
  
  var isShowBackButton = false
  var bookingModelInfo = MTBookingServiceDataModel.sharedInstance
		
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //Set Navigation Bar Style
    self.navigationController?.navigationBar.barTintColor = MTConstant.navigationBarColor
    self.navigationController?.navigationBar.tintColor = MTConstant.navigationTintColor
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:MTConstant.navigationTintColor, NSFontAttributeName:UIFont(name: MTConstant.fontMavenProMedium, size: 19.0)!];
    self.navigationController?.navigationBar.isTranslucent = false    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if isShowBackButton {
      //Show the custom back arrow
      let backButton:UIButton = UIButton.init(type: .custom)
      backButton.addTarget(self, action: #selector(self.backButtonAction(sender:)), for: .touchUpInside)
      backButton.setImage(UIImage.init(named: "back_arrow_img_white"), for: .normal)
      backButton.sizeToFit()
      let myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: backButton)
      self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  var screenWidth:CGFloat {
    return UIScreen.main.bounds.width
  }
  
  var screenHeight:CGFloat {
    return UIScreen.main.bounds.height
  }
  
  var loggedInUserId: String {
    let realm = try! Realm()
    let userInfo = realm.objects(MTUserInfo.self).first
    if let userID = userInfo?.userID {
      return userID
    }
    return ""
  }
  
  var loggedInUserEmailId: String {
    let realm = try! Realm()
    let userInfo = realm.objects(MTUserInfo.self).first
    if let emailID = userInfo?.emailID {
      return emailID
    }
    return ""
  }

  var loggedInAuthKey: String {
    let realm = try! Realm()
    let userInfo = realm.objects(MTUserInfo.self).first
    if let authKey = userInfo?.authKey {
      return authKey
    }
    return ""
  }

  var loggedInMobileNumber: String {
    let realm = try! Realm()
    let userInfo = realm.objects(MTUserInfo.self).first
    if let mobileNumber = userInfo?.mobileNumber {
      return mobileNumber
    }
    return ""
  }

  
  //Mark: Action
  func backButtonAction(sender:UIBarButtonItem){
    _ = self.navigationController?.popViewController(animated: true)
  }
}
