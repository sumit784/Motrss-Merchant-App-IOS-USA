/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTAppRatingView.swift
 
 Description: This class is used to show the forgot pasword view.
 
 Created By: Rohit W.
 
 Creation Date: 24/06/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import UIKit
import TextFieldEffects
import SwiftyJSON
import SwiftyStarRatingView

protocol MTAppRatingViewDelegate: class {
  
}

class MTAppRatingView: UIView, UITextFieldDelegate {

  @IBOutlet weak var bgView: UIView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var submitButton: UIButton!
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var startRatingView: SwiftyStarRatingView!
  
  var delegate: MTAppRatingViewDelegate?
  
  override func awakeFromNib() {
    bgView.layer.cornerRadius = 3.0
    submitButton.layer.cornerRadius = 15.0
    cancelButton.layer.cornerRadius = 15.0
    
    titleLabel.text = "rate_app_title_text".localized
    submitButton.setTitle("rate_app_submit_text".localized, for: .normal)
    cancelButton.setTitle("general_cancel_text".localized, for: .normal)
  }
  
  @IBAction func submitButtonAction(_ sender: Any) {
    if startRatingView.value<=0 {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "rate_app_empty_rating_alert_text".localized)
    } else {
      //Submit the rating to App Store
      //NOTE::Pending
      rateApp(completion: { (success) in
        MTLogger.log.info("Rated Motrss App")
      })
    }
  }
  
  @IBAction func cancelButtonAction(_ sender: Any) {
    removeFromSuperview()
  }
  
  @IBAction func starRatingViewAction(_ sender: Any) {
    if let ratingView = sender as? SwiftyStarRatingView {
      MTLogger.log.info("Value = \(ratingView.value)")
    }
  }
  
  func rateApp(completion: @escaping ((_ success: Bool)->())) {
    guard let url = URL(string : "itms-apps://itunes.apple.com/app/" + MTConstant.AppStoreMotrssUserAppId) else {
      completion(false)
      return
    }
    guard #available(iOS 10, *) else {
      completion(UIApplication.shared.openURL(url))
      return
    }
    UIApplication.shared.open(url, options: [:], completionHandler: completion)
  }
}
