/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTForgotPasswordView.swift
 
 Description: This class is used to show the forgot pasword view.
 
 Created By: Rohit W.
 
 Creation Date: 24/04/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import UIKit
import TextFieldEffects
import SwiftyJSON

protocol MTVerifyOTPPinViewDelegate: class {
  func shallMoveToResetOTPScreen(userId: String)
  func didVerifyPinSuccess()
  func didCancelVerifyPin()
}

class MTVerifyOTPPinView: UIView, UITextFieldDelegate {

  @IBOutlet weak var bgView: UIView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var optSentDescLabel: UILabel!
  @IBOutlet weak var nextButton: UIButton!
  @IBOutlet weak var cancelButton: UIButton!
  
  @IBOutlet weak var firstTextField: HoshiTextField!
  @IBOutlet weak var secondTextField: HoshiTextField!
  @IBOutlet weak var thirdTextField: HoshiTextField!
  @IBOutlet weak var fourthTextField: HoshiTextField!
  @IBOutlet weak var fifthTextField: HoshiTextField!
  
  var delegate: MTVerifyOTPPinViewDelegate?
  var userOtp = ""
  var userId = ""
  var userMobileNumber = ""
  
  override func awakeFromNib() {
    nextButton.isEnabled = false
    nextButton.alpha = 0.7
    bgView.layer.cornerRadius = 3.0
    nextButton.layer.cornerRadius = 15.0
    cancelButton.layer.cornerRadius = 15.0
    nextButton.setTitle("forgot_pwd_next_btn_text".localized, for: .normal)
    cancelButton.setTitle("general_cancel_text".localized, for: .normal)
    
    firstTextField.delegate = self
    secondTextField.delegate = self
    thirdTextField.delegate = self
    fourthTextField.delegate = self
    fifthTextField.delegate = self
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    titleLabel.text = "forgot_verify_pin_title_text".localized
    
    optSentDescLabel.text = "forgot_pin_otp_sent_desc_text".localized + userMobileNumber
  }
  // MARK: UITextField Delegate Methods
  
  //public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
  //  return false
  //}
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    if (firstTextField.text?.characters.count)!<=0 || (secondTextField.text?.characters.count)!<=0 || (thirdTextField.text?.characters.count)!<=0 || (fourthTextField.text?.characters.count)!<=0 || (fifthTextField.text?.characters.count)!<=0 {
      nextButton.isEnabled = false
      nextButton.alpha = 0.7
    } else {
      nextButton.isEnabled = true
      nextButton.alpha = 1.0
    }
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
    
    if textField == firstTextField {
      if string == "" {
        if (firstTextField.text?.characters.count)!>0 {
          textField.resignFirstResponder()
          firstTextField.text = str
          return false
        }
        //return true
      } else if str.characters.count >= 1 {
        if str.characters.count == 1 {
          textField.resignFirstResponder()
          secondTextField.becomeFirstResponder()
          firstTextField.text = str
          //secondTextField.text = ""
          return false
        } else {
          return false
        }
      }
    } else if textField == secondTextField {
      if string == "" {
        if (secondTextField.text?.characters.count)!>0 {
          textField.resignFirstResponder()
          firstTextField.becomeFirstResponder()
          secondTextField.text = str
          return false
        }
        //return true
      } else if str.characters.count >= 1 {
        if str.characters.count == 1 {
          textField.resignFirstResponder()
          thirdTextField.becomeFirstResponder()
          secondTextField.text = str
          //thirdTextField.text = ""
          return false
        } else {
          return false
        }
      }
    } else if textField == thirdTextField {
      if string == "" {
        if (thirdTextField.text?.characters.count)!>0 {
          textField.resignFirstResponder()
          secondTextField.becomeFirstResponder()
          thirdTextField.text = str
          return false
        }
        //return true
      } else if str.characters.count >= 1 {
        if str.characters.count == 1 {
          textField.resignFirstResponder()
          fourthTextField.becomeFirstResponder()
          thirdTextField.text = str
          //fourthTextField.text = ""
          return false
        } else {
          return false
        }
      }
    } else if textField == fourthTextField {
      if string == "" {
        if (fourthTextField.text?.characters.count)!>0 {
          textField.resignFirstResponder()
          thirdTextField.becomeFirstResponder()
          fourthTextField.text = str
          return false
        }
        //return true
      } else if str.characters.count >= 1 {
        if str.characters.count == 1 {
          textField.resignFirstResponder()
          fifthTextField.becomeFirstResponder()
          fourthTextField.text = str
          //fifthTextField.text = ""
          return false
        } else {
          return false
        }
      }
    } else if textField == fifthTextField {
      if string == "" {
        if (fifthTextField.text?.characters.count)!>0 {
          textField.resignFirstResponder()
          fourthTextField.becomeFirstResponder()
          fifthTextField.text = str
          return false
        }
        //return true
      } else if str.characters.count >= 1 {
        if str.characters.count == 1 {
          fifthTextField.text = str
          textField.resignFirstResponder()
          return false
        } else {
          return false
        }
      }
    }
    return true
  }
  
  @IBAction func nextButtonAction(_ sender: Any) {
    if (firstTextField.text?.characters.count)!<=0 || (secondTextField.text?.characters.count)!<=0 || (thirdTextField.text?.characters.count)!<=0 || (fourthTextField.text?.characters.count)!<=0 || (fifthTextField.text?.characters.count)!<=0 {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "forgot_pin_otp_error_text".localized)
    } else {
      let enteredOtp = firstTextField.text! + secondTextField.text! + thirdTextField.text! + fourthTextField.text! + fifthTextField.text!
      if userOtp == enteredOtp {
        verifyOTPPinService()
      } else {
        MTCommonUtils.showAlertViewWithTitle(title: "", message: "forgot_pin_otp_invalid_error_text".localized)
      }
    }
  }
  
  @IBAction func cancelButtonAction(_ sender: Any) {
    removeFromSuperview()
  }
  
  // MARK: Service Methods
  
  func verifyOTPPinService() {
    if MTRechabilityManager.sharedInstance.isRechable {
      MTProgressIndicator.sharedInstance.showProgressIndicator()
      MTProfileServiceManager.sharedInstance.verifyOTPPin(userID: userId, userOTP: userOtp, onSuccess: { (success) -> Void in
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
        
        let loginJson = JSON(success)
        if let status = loginJson["Status"].string, status == "Success" {
          self.delegate?.shallMoveToResetOTPScreen(userId: self.userId)
          self.removeFromSuperview()
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
