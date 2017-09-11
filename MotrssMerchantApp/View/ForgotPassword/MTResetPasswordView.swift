/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTResetPasswordView.swift
 
 Description: This class is used to to update the user password.
 
 Created By: Rohit W.
 
 Creation Date: 24/04/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import UIKit
import TextFieldEffects
import SwiftyJSON

protocol MTResetPasswordViewDelegate: class {
  func didResetPasswordSuccessAfterLogin()
}

class MTResetPasswordView: UIView, UITextFieldDelegate {

  @IBOutlet weak var bgView: UIView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var oldPasswordTextField: HoshiTextField!
  @IBOutlet weak var setPasswordTextField: HoshiTextField!
  @IBOutlet weak var resetPasswordTextField: HoshiTextField!
  @IBOutlet weak var nextButton: UIButton!
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var orLabel: UILabel!
  @IBOutlet weak var tempPwdButton: UIButton!
  
  var delegate: MTResetPasswordViewDelegate?
  var merchantId = ""
  var merchantEmail = ""
  
//  //For after login
//  var isFromLogin = false
//	var userId = ""
//  var tempPassword = ""
  
  override func awakeFromNib() {
    /*nextButton.isEnabled = false
    nextButton.alpha = 0.7*/
    bgView.layer.cornerRadius = 3.0
    nextButton.layer.cornerRadius = 15.0
    cancelButton.layer.cornerRadius = 15.0
    titleLabel.text = "forgot_pwd_title_text".localized
    nextButton.setTitle("forgot_pwd_done_btn_text".localized, for: .normal)
    cancelButton.setTitle("general_cancel_text".localized, for: .normal)
    oldPasswordTextField.placeholder = "forgot_pwd_old_pwd_text".localized
    oldPasswordTextField.delegate = self
    setPasswordTextField.placeholder = "forgot_pwd_set_pwd_text".localized
    setPasswordTextField.delegate = self
    resetPasswordTextField.placeholder = "forgot_pwd_reset_pwd_text".localized
    resetPasswordTextField.delegate = self
    
    orLabel.text = "forgot_pwd_or_text".localized
    orLabel.showUnderline()
    let font = UIFont(name: MTConstant.fontHMavenProRegular, size: 16)
    let yourAttributes : [String: Any] = [
      NSFontAttributeName : font!,
      NSForegroundColorAttributeName : UIColor.black,
      NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue]
    let attributeString = NSMutableAttributedString(string: "forgot_pwd_send_temp_pwd_text".localized, attributes: yourAttributes)
    tempPwdButton.setAttributedTitle(attributeString, for: .normal)
    tempPwdButton.titleLabel?.adjustsFontSizeToFitWidth = true
  }
  
  // MARK: UITextField Delegate Methods
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if textField == setPasswordTextField || textField == resetPasswordTextField {
      //To prevent whitspace
      let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
      let strString = NSString(string: str)
      if str.characters.count > 15 {
        return false
      } else if (strString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != NSNotFound) {
        return false
      }
    }
    return true
  }
  /*func textFieldDidEndEditing(_ textField: UITextField) {
    if textField == setPasswordTextField || textField == resetPasswordTextField {
      if (setPasswordTextField.text?.characters.count)!>0 && (resetPasswordTextField.text?.characters.count)!>0 {
        if setPasswordTextField.text != resetPasswordTextField.text {
          nextButton.isEnabled = false
          nextButton.alpha = 0.7
          MTCommonUtils.showAlertViewWithTitle(title: "", message: "forgot_pwd_password_not_match_err_text".localized)
        } else if (setPasswordTextField.text?.characters.count)!<6 || (resetPasswordTextField.text?.characters.count)!<6 {
          nextButton.isEnabled = false
          nextButton.alpha = 0.7
          MTCommonUtils.showAlertViewWithTitle(title: "", message: "forgot_pwd_password_length_err_text".localized)
        } else {
          nextButton.isEnabled = true
          nextButton.alpha = 1.0
        }
      } else {
        nextButton.isEnabled = false
        nextButton.alpha = 0.7
      }
    }
  }*/

  @IBAction func nextButtonAction(_ sender: Any) {
    if setPasswordTextField.text != resetPasswordTextField.text {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "forgot_pwd_password_not_match_err_text".localized)
    } else if (oldPasswordTextField.text?.characters.count)!<4 || (setPasswordTextField.text?.characters.count)!<4 || (resetPasswordTextField.text?.characters.count)!<4 || (setPasswordTextField.text?.characters.count)!>15 || (resetPasswordTextField.text?.characters.count)!>15 || (oldPasswordTextField.text?.characters.count)!>15  {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "forgot_pwd_password_length_err_text".localized)
    } else {
      //if isFromLogin {
        //resetPasswordAfterLogin()
      //} else {
        resetPasswordOnServer()
      //}
    }
  }
  
  @IBAction func cancelButtonAction(_ sender: Any) {
    removeFromSuperview()
  }
  
  @IBAction func sendTempPasswordButtonAction(_ sender: Any) {
    //sendTemporaryPasswordOnEmail()
    sendTempPasswordAlert()
  }
  
  func sendTempPasswordAlert() {
    let alertMsg = "forgot_pwd_email_sent_alert_text".localized + merchantEmail
    let alert = UIAlertController(title: "", message: alertMsg, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "general_no_text".localized, style: UIAlertActionStyle.cancel, handler: { action in
      switch action.style{
      case .default:
        MTLogger.log.info("default")
      case .cancel:
        MTLogger.log.info("cancel")
      case .destructive:
        MTLogger.log.info("destructive")
      }
    }))
    alert.addAction(UIAlertAction(title: "general_yes_text".localized, style: UIAlertActionStyle.default, handler: { action in
      switch action.style{
      case .default:
        MTLogger.log.info("default")
        self.sendTempPasswordOnEmailService()
        
      case .cancel:
        MTLogger.log.info("cancel")
        
      case .destructive:
        MTLogger.log.info("destructive")
      }
    }))
    
    let alertViewController = MTCommonUtils.visibleViewController()
    alertViewController.present(alert, animated: true, completion: nil)
  }
  
  // MARK: Service Methods
  
  func resetPasswordOnServer() {
    if MTRechabilityManager.sharedInstance.isRechable {
      MTProgressIndicator.sharedInstance.showProgressIndicator()
      
      MTProfileServiceManager.sharedInstance.resetPassword(merchantEmailID: self.merchantEmail, password: resetPasswordTextField.text!, oldPassword: oldPasswordTextField.text!, onSuccess: { (success) -> Void in
        
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
        if (success as! Bool) {
          self.removeFromSuperview()
          MTCommonUtils.showAlertViewWithTitle(title: "", message: "forgot_pwd_pwd_update_success_text".localized)
        }
      }) { (failure) -> Void in
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
      }
    } else {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_no_internet".localized)
    }
  }
  
//  func resetPasswordAfterLogin() {
//    if MTRechabilityManager.sharedInstance.isRechable {
//      MTProgressIndicator.sharedInstance.showProgressIndicator()
//      
//      MTProfileServiceManager.sharedInstance.resetPasswordAfterLogin(emailID: userEmailId, userID: userId, tempPassword: tempPassword, newPassword: resetPasswordTextField.text!, onSuccess: { (success) -> Void in
//        
//        MTProgressIndicator.sharedInstance.hideProgressIndicator()
//        if (success as! Bool) {
//          MTCommonUtils.showAlertViewWithTitle(title: "", message: "forgot_pwd_pwd_update_success_text".localized)
//          self.delegate?.didResetPasswordSuccessAfterLogin()
//          self.removeFromSuperview()
//        }
//      }) { (failure) -> Void in
//        MTProgressIndicator.sharedInstance.hideProgressIndicator()
//      }
//    } else {
//      MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_no_internet".localized)
//    }
//  }
  
  func sendTempPasswordOnEmailService() {
    if MTRechabilityManager.sharedInstance.isRechable {
      MTProgressIndicator.sharedInstance.showProgressIndicator()
      MTProfileServiceManager.sharedInstance.SendTempPasswordOnEmai(email: merchantEmail, onSuccess: { (success) -> Void in
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
        
        let loginJson = JSON(success)
        if let status = loginJson["Status"].string, status == "Success" {
          
          if let dataDict = loginJson["Data"].dictionary {
            if let mid = dataDict["id"]?.string {
              self.merchantId = mid
              MTCommonUtils.showAlertViewWithTitle(title: "", message: "forgot_pwd_email_sent_text".localized)
              self.removeFromSuperview()
            } else {
              MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_something_went_wrong".localized)
            }
          } else {
            MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_something_went_wrong".localized)
          }
        } else {
          MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_something_went_wrong".localized)
        }
      }) { (failure) -> Void in
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
      }
    } else {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_no_internet".localized)
    }
  }
}
