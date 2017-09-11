/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTChangePasswordView.swift
 
 Description: This class is used to to update the user password.
 
 Created By: Rohit W.
 
 Creation Date: 24/05/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import UIKit
import TextFieldEffects
import SwiftyJSON
import RealmSwift

protocol MTChangePasswordViewDelegate: class {
  func didPasswordChangesSuccessfully()
}

class MTChangePasswordView: UIView, UITextFieldDelegate {

  @IBOutlet weak var bgView: UIView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var oldPasswordTextField: HoshiTextField!
  @IBOutlet weak var newPasswordTextField: HoshiTextField!
  @IBOutlet weak var confimrPasswordTextField: HoshiTextField!
  @IBOutlet weak var nextButton: UIButton!
  @IBOutlet weak var cancelButton: UIButton!
  
  var delegate: MTChangePasswordViewDelegate?
  
  override func awakeFromNib() {
    /*nextButton.isEnabled = false
    nextButton.alpha = 0.7*/
    bgView.layer.cornerRadius = 3.0
    nextButton.layer.cornerRadius = 15.0
    cancelButton.layer.cornerRadius = 15.0
    titleLabel.text = "change_pwd_title_text".localized
    nextButton.setTitle("change_pwd_submit_button_text".localized, for: .normal)
    cancelButton.setTitle("general_cancel_text".localized, for: .normal)
    oldPasswordTextField.placeholder = "change_pwd_old_pwd_text".localized
    oldPasswordTextField.delegate = self
    newPasswordTextField.placeholder = "change_pwd_new_pwd_text".localized
    newPasswordTextField.delegate = self
    confimrPasswordTextField.placeholder = "change_pwd_confirm_pwd_text".localized
    confimrPasswordTextField.delegate = self
  }
  
  // MARK: UITextField Delegate Methods
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if textField == oldPasswordTextField || textField == newPasswordTextField || textField == confimrPasswordTextField {
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
    if textField == oldPasswordTextField || textField == newPasswordTextField || textField == confimrPasswordTextField {
      if (oldPasswordTextField.text?.characters.count)!>0 && (newPasswordTextField.text?.characters.count)!>0 && (confimrPasswordTextField.text?.characters.count)!>0 {
        if newPasswordTextField.text != confimrPasswordTextField.text {
          nextButton.isEnabled = false
          nextButton.alpha = 0.7
          MTCommonUtils.showAlertViewWithTitle(title: "", message: "change_pwd_password_not_match_err_text".localized)
        } else if (newPasswordTextField.text?.characters.count)!<6 || (confimrPasswordTextField.text?.characters.count)!<6 {
          nextButton.isEnabled = false
          nextButton.alpha = 0.7
          MTCommonUtils.showAlertViewWithTitle(title: "", message: "change_pwd_password_length_err_text".localized)
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
    if (oldPasswordTextField.text?.characters.count)!<=0 && (newPasswordTextField.text?.characters.count)!<=0 && (confimrPasswordTextField.text?.characters.count)!<=0 {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "change_pwd_password_empty_field_err_text".localized)
    } else if newPasswordTextField.text != confimrPasswordTextField.text {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "change_pwd_password_not_match_err_text".localized)
    } else if (oldPasswordTextField.text?.characters.count)!<4 || (oldPasswordTextField.text?.characters.count)!>15 {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "change_pwd_old_password_invalid_err_text".localized)
    } else if (newPasswordTextField.text?.characters.count)!<4 || (confimrPasswordTextField.text?.characters.count)!<4 || (newPasswordTextField.text?.characters.count)!>15 || (confimrPasswordTextField.text?.characters.count)!>15 {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "edit_profile_password_length_err_text".localized)
    } else {
      changePassword()
    }
  }
  
  @IBAction func cancelButtonAction(_ sender: Any) {
    removeFromSuperview()
  }
  
  // MARK: Service Methods
  
  func changePassword() {
    if MTRechabilityManager.sharedInstance.isRechable {
      MTProgressIndicator.sharedInstance.showProgressIndicator()
      
      let realm = try! Realm()
      let userInfo = realm.objects(MTUserInfo.self).first
      
      MTProfileServiceManager.sharedInstance.updateMerchantPassword(email: (userInfo?.emailID)!, newPassword: newPasswordTextField.text!, oldPassword: oldPasswordTextField.text!, onSuccess: { (success) -> Void in
        
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
        if (success as! Bool) {
          MTCommonUtils.showAlertViewWithTitle(title: "", message: "forgot_pwd_pwd_update_success_text".localized)
          self.delegate?.didPasswordChangesSuccessfully()
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

//NOTE
//2. Chnage password, Old password not saved in app
