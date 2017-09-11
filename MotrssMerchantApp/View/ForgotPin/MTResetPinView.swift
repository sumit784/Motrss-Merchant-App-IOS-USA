/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTResetPinView.swift
 
 Description: This class is used to to update the new pin.
 
 Created By: Rohit W.
 
 Creation Date: 24/04/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import UIKit
import TextFieldEffects
import SwiftyJSON

class MTResetPinView: UIView, UITextFieldDelegate {

  @IBOutlet weak var bgView: UIView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var setPinTextField: HoshiTextField!
  @IBOutlet weak var confirmPinTextField: HoshiTextField!
  @IBOutlet weak var nextButton: UIButton!
  @IBOutlet weak var cancelButton: UIButton!
  
  var userId = ""
  
  override func awakeFromNib() {
    /*nextButton.isEnabled = false
    nextButton.alpha = 0.7*/
    bgView.layer.cornerRadius = 3.0
    nextButton.layer.cornerRadius = 15.0
    cancelButton.layer.cornerRadius = 15.0
    titleLabel.text = "forgot_pin_reset_title_text".localized
    nextButton.setTitle("forgot_pwd_done_btn_text".localized, for: .normal)
    cancelButton.setTitle("general_cancel_text".localized, for: .normal)
    setPinTextField.placeholder = "forgot_pwd_set_pin_text".localized
    setPinTextField.delegate = self
    confirmPinTextField.placeholder = "forgot_pwd_reset_pin_text".localized
    confirmPinTextField.delegate = self
  }
  
  // MARK: UITextField Delegate Methods
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if textField == setPinTextField || textField == confirmPinTextField {
      //To prevent whitspace
      let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
      let strString = NSString(string: str)
      if str.characters.count > 6 {
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
    if setPinTextField.text != confirmPinTextField.text {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "forgot_pwd_pin_not_match_err_text".localized)
    } else if (setPinTextField.text?.characters.count)! != 6 || (confirmPinTextField.text?.characters.count)! != 6 {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "forgot_pwd_pin_length_err_text".localized)
    } else {
      resetPinOnServer()
    }
  }
  
  @IBAction func cancelButtonAction(_ sender: Any) {
    removeFromSuperview()
  }
  
  // MARK: Service Methods
  
  func resetPinOnServer() {
    if MTRechabilityManager.sharedInstance.isRechable {
      MTProgressIndicator.sharedInstance.showProgressIndicator()
      
      MTProfileServiceManager.sharedInstance.resetOTPPin(userID: userId, newMobilePin: confirmPinTextField.text!, onSuccess: { (success) -> Void in
        
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
        if (success as! Bool) {
          MTCommonUtils.showAlertViewWithTitle(title: "", message: "forgot_pwd_pin_update_success_text".localized)
          self.removeFromSuperview()
        }
      }) { (failure) -> Void in
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
      }
    } else {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_no_internet".localized)
    }
  }
}
