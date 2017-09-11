/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTLoginViewController.swift
 
 Description: This class is used to login to application.
 
 Created By: Pranay U.
 
 Creation Date: 25/06/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import Foundation
import RealmSwift
import SwiftyJSON
import TextFieldEffects

class MTLoginViewController: MTBaseViewController, UITextFieldDelegate {
  
  @IBOutlet weak var mobileNumberTextField: HoshiTextField!
  @IBOutlet weak var countryCodeTextField: UITextField!
  @IBOutlet weak var emailTextField: HoshiTextField!
  @IBOutlet weak var passwordTextField: HoshiTextField!
  @IBOutlet weak var mobilePinTextField: HoshiTextField!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var forgotPasswordButton: UIButton!
  @IBOutlet weak var mobileButton: UIButton!
  @IBOutlet weak var emailButton: UIButton!
  
  private var loginTypeEmail: Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    updateLoginUI()
    setLocalization()    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: false)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  /// This function is used to update ht elogin screen UI
  func updateLoginUI() {
    //Textfiled Cusstomization
    mobileNumberTextField.delegate = self
    countryCodeTextField.delegate = self
    passwordTextField.delegate = self
    emailTextField.delegate = self
    mobilePinTextField.delegate = self
    
    //loginButton.isEnabled = false
    //loginButton.alpha = 0.7
    loginButton.layer.cornerRadius = 5.0
    showEmailLoginOptions()
  }
  
  /// This function is used to add the localization for the Login screen
  func setLocalization() {
    loginButton.setTitle("login_login_button_title_text".localized, for: .normal)
    forgotPasswordButton.setTitle("login_forgot_password_title_text".localized, for: .normal)
    mobileNumberTextField.placeholder = "login_mobile_no_placeholder_text".localized
    passwordTextField.placeholder = "login_password_placeholder_text".localized
    emailTextField.placeholder = "login_email_placeholder_text".localized
    //countryCodeTextField.placeholder = "login_country_code_placeholder_text".localized
    countryCodeTextField.isHidden = true
    emailButton.setTitle("login_email_option_title_text".localized, for: .normal)
    mobileButton.setTitle("login_mobile_option_title_text".localized, for: .normal)
    mobilePinTextField.placeholder = "login_pin_placeholder_text".localized
  }
  
  // MARK: UITextField Delegate Methods
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
    //To prevent whitspace
    let strString = NSString(string: str)
    
    if textField == mobileNumberTextField {
      //To format the mobile number
      if string == "" {
        return true
      } else if str.characters.count < 3 {
        if str.characters.count == 1{
          textField.text = "("
        }
      } else if str.characters.count == 5 {
        textField.text = textField.text! + ") "
      } else if str.characters.count == 10 {
        textField.text =  textField.text! + "-"
      } else if str.characters.count > 14 {
        return false
      }
    } else if textField == mobilePinTextField {
      
      if str.characters.count > 6 {
        return false
      } else if (strString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != NSNotFound) {
        return false
      }
    } else if textField == emailTextField {
      if str.characters.count > 30 {
        return false
      } else if (strString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != NSNotFound) {
        return false
      }
    } else if textField == passwordTextField {
      if str.characters.count > 15 {
        return false
      } else if (strString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != NSNotFound) {
        return false
      }
    } else if textField == countryCodeTextField {
      //To limit the country code
      if str.characters.count > 4 {
        return false
      } else if (strString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != NSNotFound) {
        return false
      }
    }
    return true
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    //validateLoginOption()
  }
  
  func showEmailLoginOptions() {
    loginTypeEmail = true
    forgotPasswordButton.setTitle("login_forgot_password_title_text".localized, for: .normal)
    emailButton.setTitleColor(UIColor.appThemeColor, for: .normal)
    mobileButton.setTitleColor(UIColor.lightGray, for: .normal)
    emailButton.setBackgroundImage(UIImage(named: "login_btn_bg_image"), for: .normal)
    mobileButton.setBackgroundImage(UIImage(named: ""), for: .normal)
    emailTextField.isHidden = false
    passwordTextField.isHidden = false
    mobileNumberTextField.isHidden = true
    countryCodeTextField.isHidden = true
    mobilePinTextField.isHidden = true
    //validateLoginOption()
  }
  
  func showMobileLoginOptions() {
    loginTypeEmail = false
    forgotPasswordButton.setTitle("login_forgot_pin_title_text".localized, for: .normal)
    emailButton.setTitleColor(UIColor.lightGray, for: .normal)
    mobileButton.setTitleColor(UIColor.appThemeColor, for: .normal)
    emailButton.setBackgroundImage(UIImage(named: ""), for: .normal)
    mobileButton.setBackgroundImage(UIImage(named: "login_btn_bg_image"), for: .normal)
    emailTextField.isHidden = true
    passwordTextField.isHidden = true
    mobileNumberTextField.isHidden = false
    countryCodeTextField.isHidden = false
    mobilePinTextField.isHidden = false
    //validateLoginOption()
  }
  
  func validateLoginOption() -> Bool {
    if loginTypeEmail {
      if (emailTextField.text?.characters.count)!>0 && (passwordTextField.text?.characters.count)! > 0 {
      
        if (emailTextField.text?.characters.count)! < 4 || (emailTextField.text?.characters.count)! > 30 {
          MTCommonUtils.showAlertViewWithTitle(title: "", message: "login_email_validation_error_text".localized)
        } else if (passwordTextField.text?.characters.count)! < 4 || (passwordTextField.text?.characters.count)! > 15 {
          MTCommonUtils.showAlertViewWithTitle(title: "", message: "login_password_validation_error_text".localized)
        } else if !MTCommonUtils.isValidEmail(emailString: emailTextField.text!) {
          MTCommonUtils.showAlertViewWithTitle(title: "", message: "login_email_validation_error_text".localized)
        } else {
          return true
        }
      } else {
        MTCommonUtils.showAlertViewWithTitle(title: "", message: "login_email_password_blank_error_text".localized)
      }
    } else {
      let formatedMobileNo = MTCommonUtils.convertPhoneStringToDigitFormat(phoneString: mobileNumberTextField.text!)
      if formatedMobileNo.characters.count > 0 && (mobilePinTextField.text?.characters.count)! > 0 {
      
        if !MTCommonUtils.isValidMobileNumber(formatedMobileNo: formatedMobileNo) {
          MTCommonUtils.showAlertViewWithTitle(title: "", message: "login_mobile_invalid_error_text".localized)
        } else if mobilePinTextField.text?.characters.count != 6 {
          MTCommonUtils.showAlertViewWithTitle(title: "", message: "login_mobile_pin_invalid_error_text".localized)
          //More validation for mobile number
        } else {
          return true
        }
      } else {
        MTCommonUtils.showAlertViewWithTitle(title: "", message: "login_mobile_pin_blank_error_text".localized)
      }
    }
    return false
  }
  
  // MARK: IBAction Methods
  
  @IBAction func loginButtonAction(_ sender: Any) {
    //On login button tap
    MTLogger.log.info("loginButtonAction")
    if loginTypeEmail {
      if validateLoginOption() {
        loginWithEmail(email: emailTextField.text!, withPassword: passwordTextField.text!, forLogin: MTEnums.AppLoginType.normal.rawValue)
      }
    } else {
      if validateLoginOption() {
        loginWithMobile()
      }
    }
  }
  
  @IBAction func emailButtonAction(_ sender: Any) {
    showEmailLoginOptions()
  }
  
  @IBAction func mobileButtonAction(_ sender: Any) {
    showMobileLoginOptions()
  }
  
  @IBAction func forgotPassordOrPinButtonAction(_ sender: Any) {
    if loginTypeEmail == true {
      //Perform Forgot Password action
      
      /*let views = Bundle.main.loadNibNamed("MTForgotPasswordView", owner: nil, options: nil)
      let forgotPasswordView = views?[0] as! MTForgotPasswordView
      forgotPasswordView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
      forgotPasswordView.delegate = self
      self.view.addSubview(forgotPasswordView)*/
      if (emailTextField.text?.characters.count)!>0 {
        
        if (emailTextField.text?.characters.count)! < 4 || (emailTextField.text?.characters.count)! > 30 {
          MTCommonUtils.showAlertViewWithTitle(title: "", message: "login_email_validation_error_text".localized)
        } else if !MTCommonUtils.isValidEmail(emailString: emailTextField.text!) {
          MTCommonUtils.showAlertViewWithTitle(title: "", message: "login_email_validation_error_text".localized)
        } else {
          //Chek the email with server
          //forgotPasswordService()
          shallMoveToResetPassword(merchantEmail: emailTextField.text!)
        }
      } else {
        MTCommonUtils.showAlertViewWithTitle(title: "", message: "login_email_blank_error_text".localized)
      }
      
    } else {
      //Perform Forgot Pin action
      /*let views = Bundle.main.loadNibNamed("MTForgotPinView", owner: nil, options: nil)
      let forgotPinView = views?[0] as! MTForgotPinView
      forgotPinView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
      forgotPinView.delegate = self
      self.view.addSubview(forgotPinView)*/
      let formatedMobileNo = MTCommonUtils.convertPhoneStringToDigitFormat(phoneString: mobileNumberTextField.text!)
      if formatedMobileNo.characters.count > 0 {
        
        if !MTCommonUtils.isValidMobileNumber(formatedMobileNo: formatedMobileNo) {
          MTCommonUtils.showAlertViewWithTitle(title: "", message: "login_mobile_invalid_error_text".localized)
        } else {
          //Chek mobile number with API
          //checkMobileNumberExist(formatedMobileNo: formatedMobileNo)
          self.forgotMbilePinServiceForMobileNumber(mobileNumber: formatedMobileNo)
        }
      } else {
        MTCommonUtils.showAlertViewWithTitle(title: "", message: "login_mobile_number_blank_error_text".localized)
      }
    }
  }
  
//  func showOTPWillSendAlert(toMobileNo : String) {
//    let alertMsg = "login_otp_will_send_alert_text".localized + toMobileNo
//    let alert = UIAlertController(title: "", message: alertMsg, preferredStyle: UIAlertControllerStyle.alert)
//    alert.addAction(UIAlertAction(title: "general_no_text".localized, style: UIAlertActionStyle.cancel, handler: { action in
//      switch action.style{
//      case .default:
//        MTLogger.log.info("default")
//      case .cancel:
//        MTLogger.log.info("cancel")
//      case .destructive:
//        MTLogger.log.info("destructive")
//      }
//    }))
//    alert.addAction(UIAlertAction(title: "general_yes_text".localized, style: UIAlertActionStyle.default, handler: { action in
//      switch action.style{
//      case .default:
//        MTLogger.log.info("default")
//        //Call API
//        self.forgotPinServiceForMobileNumber(mobileNumber: toMobileNo)
//      case .cancel:
//        MTLogger.log.info("cancel")
//        
//      case .destructive:
//        MTLogger.log.info("destructive")
//      }
//    }))
//    
//    self.present(alert, animated: true, completion: nil)
//  }
  
  // MARK: Service Methods
  
  func loginWithEmail(email: String, withPassword password: String, forLogin loginType: String) {
    if MTRechabilityManager.sharedInstance.isRechable {
      MTProgressIndicator.sharedInstance.showProgressIndicator()
      MTProfileServiceManager.sharedInstance.loginWithEmail(email: email, andPassword: password, forLogin: loginType, onSuccess: { (success) -> Void in
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
        if (success as! Bool) {
          MTLogger.log.info("Login Success")
          //Go to the home screen
          MTCommonUtils.gotoAppHomeScreen()
        }
      }) { (failure) -> Void in
        MTCommonUtils.showAlertViewWithTitle(title: "", message: "login_server_error_text".localized)
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
      }
    } else {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_no_internet".localized)
    }
  }
  
  func loginWithMobile() {
    if MTRechabilityManager.sharedInstance.isRechable {
      MTProgressIndicator.sharedInstance.showProgressIndicator()
      let mobileNo = MTCommonUtils.convertPhoneStringToDigitFormat(phoneString: mobileNumberTextField.text!)
      MTProfileServiceManager.sharedInstance.loginWithMobile(mobile: mobileNo, andPassword: mobilePinTextField.text!, onSuccess: { (success) -> Void in
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
        if (success as! Bool) {
          MTLogger.log.info("Login Success")
          //Go to the home screen
          MTCommonUtils.gotoAppHomeScreen()
        }
      }) { (failure) -> Void in
        MTCommonUtils.showAlertViewWithTitle(title: "", message: "login_server_error_text".localized)
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
      }
    } else {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_no_internet".localized)
    }
  }
  
//  func sendTempPasswordOnEmailService() {
//    if MTRechabilityManager.sharedInstance.isRechable {
//      MTProgressIndicator.sharedInstance.showProgressIndicator()
//      MTProfileServiceManager.sharedInstance.SendTempPasswordOnEmai(email: emailTextField.text!, onSuccess: { (success) -> Void in
//        MTProgressIndicator.sharedInstance.hideProgressIndicator()
//        
//        let loginJson = JSON(success)
//        if let status = loginJson["Status"].string, status == "Success" {
//          
//          if let dataDict = loginJson["Data"].dictionary {
//            if let mid = dataDict["id"]?.string {
//              self.shallMoveToResetPassword(merchantID: mid)
//            } else {
//              MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_something_went_wrong".localized)
//            }
//          } else {
//            MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_something_went_wrong".localized)
//          }
//        } else {
//          MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_something_went_wrong".localized)
//        }
//      }) { (failure) -> Void in
//        MTProgressIndicator.sharedInstance.hideProgressIndicator()
//      }
//    } else {
//      MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_no_internet".localized)
//    }
//  }
  
//  func checkMobileNumberExist(formatedMobileNo : String) {
//    if MTRechabilityManager.sharedInstance.isRechable {
//      MTProgressIndicator.sharedInstance.showProgressIndicator()
//      MTProfileServiceManager.sharedInstance.checkMobileNumberExist(mobileNumber: formatedMobileNo, successBlock: { (success) -> Void in
//        MTProgressIndicator.sharedInstance.hideProgressIndicator()
//        if (success as! Bool) {
//          MTLogger.log.info("Success")
//          self.showOTPWillSendAlert(toMobileNo: formatedMobileNo)
//        }
//      }) { (failure) -> Void in
//        MTProgressIndicator.sharedInstance.hideProgressIndicator()
//      }
//    } else {
//      MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_no_internet".localized)
//    }
//  }
  
  func forgotMbilePinServiceForMobileNumber(mobileNumber : String) {
    if MTRechabilityManager.sharedInstance.isRechable {
      MTProgressIndicator.sharedInstance.showProgressIndicator()
      MTProfileServiceManager.sharedInstance.forgotMobilePin(mobileNumber: mobileNumber, successBlock: { (success) -> Void in
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
        
        let loginJson = JSON(success)
        if let status = loginJson["Status"].string, status == "Success" {
          
          if let dataDict = loginJson["Data"].dictionary {
            if let userOtp = dataDict["merchant_otp"]?.string {
              
              if let userId = dataDict["mid"]?.string {
                
                //if let userAuthKey = dataDict["auth_key"]?.string {
                  //Move to next screen
                  self.shallMoveToVerifyOTPScreen(userOtp: userOtp, userId: userId, /*userAuthKey: userAuthKey,*/ userMobileNumber: mobileNumber)
                //} else {
                //  MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_something_went_wrong".localized)
                //}
              } else {
                MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_something_went_wrong".localized)
              }
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

extension MTLoginViewController: MTVerifyOTPPinViewDelegate, MTResetPasswordViewDelegate {
  
  func shallMoveToResetPassword(merchantEmail: String) {
    
    let views = Bundle.main.loadNibNamed("MTResetPasswordView", owner: nil, options: nil)
    let resetPassword = views?[0] as! MTResetPasswordView
    resetPassword.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
    //resetPassword.merchantId = merchantID
    resetPassword.merchantEmail = merchantEmail
    self.view.addSubview(resetPassword)
  }
  
  func shallMoveToVerifyOTPScreen(userOtp: String, userId: String, /*userAuthKey: String,*/ userMobileNumber: String) {
    let views = Bundle.main.loadNibNamed("MTVerifyOTPPinView", owner: nil, options: nil)
    let forgotPinView = views?[0] as! MTVerifyOTPPinView
    forgotPinView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
    forgotPinView.delegate = self
    forgotPinView.userId = userId
    //forgotPinView.userAuthKey = userAuthKey
    forgotPinView.userOtp = userOtp
    forgotPinView.userMobileNumber = userMobileNumber
    self.view.addSubview(forgotPinView)
  }
  
  func shallMoveToResetOTPScreen(userId: String) {
    let views = Bundle.main.loadNibNamed("MTResetPinView", owner: nil, options: nil)
    let resetPinView = views?[0] as! MTResetPinView
    resetPinView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
    resetPinView.userId = userId
    self.view.addSubview(resetPinView)
  }
  
  func didResetPasswordSuccessAfterLogin() {
    MTLogger.log.info("Login Success")
    //Go to the home screen
    MTCommonUtils.gotoAppHomeScreen()
  }
  
  func didVerifyPinSuccess() {
    //No need
  }
  
  func didCancelVerifyPin() {
    //No need
  }
}
