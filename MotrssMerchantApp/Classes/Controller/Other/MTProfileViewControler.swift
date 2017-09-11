/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTProfileViewControler.swift
 
 Description: This class is used to show home profile screen for the application.
 
 Created By: Pranay.
 
 Creation Date: 2/08/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import UIKit
import RealmSwift
import Kingfisher
import ALCameraViewController
import AWSS3
import AWSCore
import SwiftyJSON

protocol MTProfileViewControlerDelegate: class {
  func didUpdateEditProfile()
}

class MTProfileViewControler: MTBaseViewController, UITextFieldDelegate {
  
  @IBOutlet weak var userProfileImageView: UIImageView!
  @IBOutlet weak var changePhotoTitleLabel: UILabel!
  @IBOutlet weak var loginIdTitleLabel: UILabel!
  @IBOutlet weak var nameTitleLabel: UILabel!
  @IBOutlet weak var emailTitleLabel: UILabel!
  @IBOutlet weak var mobileTitleLabel: UILabel!
  /*@IBOutlet weak var nameLabel: UILabel!
   @IBOutlet weak var emailLabel: UILabel!
   @IBOutlet weak var mobileNumberLabel: UILabel!
   @IBOutlet weak var changeEmailButton: UIButton!
   @IBOutlet weak var changeMobileButton: UIButton!*/
  @IBOutlet weak var loginIdTextfield: UITextField!
  @IBOutlet weak var nameTextfield: UITextField!
  @IBOutlet weak var shopNameTitleLabel: UILabel!
  @IBOutlet weak var shopNameTextfield: UITextField!
  @IBOutlet weak var emailTextfield: UITextField!
  @IBOutlet weak var mobileTextfield: UITextField!
  @IBOutlet weak var changePasswordButton: UIButton!
  @IBOutlet weak var saveButton: UIButton!
  @IBOutlet weak var uploadUserImgButton: UIButton!
  @IBOutlet weak var mobileVerifiedImageView: UIImageView!
  @IBOutlet weak var emailVerifiedImageView: UIImageView!
  @IBOutlet weak var resendVerificationEmailButton: UIButton!

  
  var delegate:MTProfileViewControlerDelegate?
  var newUserImage:UIImage?
  var newUserImageUrl:String?
  var isEditingProfileDetails = false
  var oldMobileNumber = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    isShowBackButton = true
    
    let editBtn = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editProfileButtonAction(_:)))
    self.navigationItem.rightBarButtonItem = editBtn
    
    shopNameTextfield.isEnabled = false
    loginIdTextfield.isEnabled = false
    setLocalization()
    updatePageUI()
    //getMerchantProfileData()
    checkCacheStatusForMerchantProfile()
    editProfileDetails()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  deinit {
  }
  
  func updatePageUI() {
    nameTextfield.delegate = self
    mobileTextfield.delegate = self
    emailTextfield.delegate = self
    //Update USer DataSource
    let realm = try! Realm()
    let userInfo = realm.objects(MTUserInfo.self).first
    if let object = userInfo {
      nameTextfield.text = object.ownerName
      mobileTextfield.text = object.mobileNumber
      emailTextfield.text = object.emailID
      shopNameTextfield.text = object.businessName
      oldMobileNumber = object.mobileNumber
      loginIdTextfield.text = object.loginID
      
      if object.isEmailVerified == "0" {
        emailVerifiedImageView.image = UIImage(named: "fail_img")
        resendVerificationEmailButton.isHidden = false
      } else {
        emailVerifiedImageView.image = UIImage(named: "coupon_applied_img")
        resendVerificationEmailButton.isHidden = true
      }
      if object.isMobileVerified == "0" {
        mobileVerifiedImageView.image = UIImage(named: "fail_img")
      } else {
        mobileVerifiedImageView.image = UIImage(named: "coupon_applied_img")
      }
    }
    if let imgURl = userInfo?.shopImage, imgURl.characters.count>0, imgURl != "00"  {
      MTCommonUtils.updateProfileImageCache(imageUrl: imgURl, forImage: userProfileImageView, placeholder: UIImage(named: "merchant_image"), contentMode: .scaleToFill)
      
      ImageCache.default.retrieveImage(forKey: imgURl, options: nil) {
        image, cacheType in
        if let image = image {
          self.newUserImage = image
          self.newUserImageUrl = imgURl
        }
      }
    } else {
      setMerchantDefaultImage()
      //userProfileImageView.image = UIImage(named: "logo_image")
    }
    nameTitleLabel.text = "edit_profile_name_title_text".localized
    shopNameTitleLabel.text = "edit_profile_shop_name_title_text".localized
    emailTitleLabel.text = "edit_profile_email_title_text".localized
    mobileTitleLabel.text = "edit_profile_mobile_title_text".localized
    loginIdTitleLabel.text = "edit_profile_login_id_title_text".localized
    
    let text = "profile_resend_verification_email_text".localized
    let attributedString = NSMutableAttributedString(string: text)
    let str = NSString(string: text)
    let range = str.range(of: "profile_resend_verification_email_text".localized)
    attributedString.addAttributes([NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue], range: range)
    attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.warningColor , range: range)
    resendVerificationEmailButton.setAttributedTitle(attributedString, for: .normal)
    
    //changeEmailButton.setTitle("edit_profile_change_title_text".localized, for: .normal)
    //changeMobileButton.setTitle("edit_profile_change_title_text".localized, for: .normal)
    changePasswordButton.setTitle("edit_profile_change_password_title_text".localized, for: .normal)
    saveButton.setTitle("edit_profile_save_btn_title_text".localized, for: .normal)
  }
  
  func setMerchantDefaultImage() {
    let realm = try! Realm()
    let userInfo = realm.objects(MTUserInfo.self).first
    if let mertInfo = userInfo {
      var isFourWheelarMerchant = false
      for type in mertInfo.merchantTypes {
        if type.merchantTypeId == "104" || type.merchantTypeId == "110" {
          isFourWheelarMerchant = true
          break;
        }
      }
      if isFourWheelarMerchant {
        userProfileImageView.image = UIImage(named: "merchant_image")
      } else {
        userProfileImageView.image = UIImage(named: "merchant_image_motorcycle")
      }
    }
  }
  
  func setLocalization() {
    self.title = "profile_screen_title_text".localized
  }
  
  func editProfileDetails() {
    
    if isEditingProfileDetails {
      //Show editing
      changePhotoTitleLabel.isHidden = false
      nameTextfield.isEnabled = true
      //shopNameTextfield.isEnabled = true
      emailTextfield.isEnabled = true
      mobileTextfield.isEnabled = true
      saveButton.isEnabled = true
      saveButton.isHidden = false
      changePasswordButton.isEnabled = true
      self.navigationItem.rightBarButtonItem = nil
      uploadUserImgButton.isEnabled = true
    } else {
      //not editable
      changePhotoTitleLabel.isHidden = true
      nameTextfield.isEnabled = false
      //shopNameTextfield.isEnabled = false
      emailTextfield.isEnabled = false
      mobileTextfield.isEnabled = false
      saveButton.isEnabled = false
      saveButton.isHidden = true
      changePasswordButton.isEnabled = false
      uploadUserImgButton.isEnabled = false
    }
  }
  
  func showResetPasswordView() {
    let views = Bundle.main.loadNibNamed("MTChangePasswordView", owner: nil, options: nil)
    let changePassword = views?[0] as! MTChangePasswordView
    changePassword.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
    changePassword.delegate = self
    self.navigationController?.view.addSubview(changePassword)
  }
  
  func showUpdateProfileMessage(msgStr: String) {
    let alert = UIAlertController(title: "", message: msgStr, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "general_ok_text".localized, style: UIAlertActionStyle.default, handler: { action in
      switch action.style{
      case .default:
        MTLogger.log.info("default")
        self.delegate?.didUpdateEditProfile()
        self.navigationController?.popViewController(animated: true)
      case .cancel:
        MTLogger.log.info("cancel")
      case .destructive:
        MTLogger.log.info("destructive")
      }
    }))
    
    self.present(alert, animated: true, completion: nil)
  }
  
  // MARK: UITextField Delegate Methods
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
    //To prevent whitspace
    let strString = NSString(string: str)
    
    if textField == nameTextfield {
      let spaceCount = str.characters.filter{$0 == " "}.count
      if str.characters.count > 50 {
        return false
      } else if spaceCount > 4 {
        return false
      }/*else if (strString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != NSNotFound) {
       return false
       }*/
    } /*else if textField == shopNameTextfield {
      let spaceCount = str.characters.filter{$0 == " "}.count
      if str.characters.count > 50 {
        return false
      } else if spaceCount > 4 {
        return false
      }
    }*/ else if textField == emailTextfield {
      if str.characters.count > 30 {
        return false
      } else if (strString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != NSNotFound) {
        return false
      }
    } else if textField == mobileTextfield {
      if str.characters.count > 10 {
        return false
      } else if (strString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != NSNotFound) {
        return false
      }
    }
    return true
  }
  
  func showProfileImageUploadAlert() {
    var optionArr:[String] = ["Phone Camera", "Gallery"]
    if newUserImage != nil {
      optionArr.append("Remove Image")
    }
    MTPickerView.showSingleColPicker("edit_profile_upload_image_title_text".localized, data: optionArr, defaultSelectedIndex: 0) {[unowned self] (selectedIndex, selectedValue) in
      
      let croppingEnabled = true
      if selectedIndex == 0 {
        let cameraViewController = CameraViewController(croppingEnabled: croppingEnabled) { [weak self] image, asset in
          if image != nil {
            self?.newUserImage = image
            self?.userProfileImageView.image = image
          }
          self?.dismiss(animated: true, completion: nil)
        }
        self.present(cameraViewController, animated: true, completion: nil)
      } else if selectedIndex == 1 {
        let cameraViewController = CameraViewController.imagePickerViewController(croppingEnabled: croppingEnabled) { [weak self] image, asset in
          if image != nil {
            self?.newUserImage = image
            self?.userProfileImageView.image = image
          }
          self?.dismiss(animated: true, completion: nil)
        }
        self.present(cameraViewController, animated: true, completion: nil)
      } else if selectedIndex == 2 {
        self.newUserImageUrl = ""
        self.newUserImage = nil
        self.setMerchantDefaultImage()
      }
    }
  }
  
  override func backButtonAction(sender:UIBarButtonItem){
    if isEditingProfileDetails {
      let alert = UIAlertController(title: "", message: "edit_profile_back_alert_text".localized, preferredStyle: UIAlertControllerStyle.alert)
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
          _ = self.navigationController?.popViewController(animated: true)
        case .cancel:
          MTLogger.log.info("cancel")
        case .destructive:
          MTLogger.log.info("destructive")
        }
      }))
      
      self.present(alert, animated: true, completion: nil)
    } else {
      _ = self.navigationController?.popViewController(animated: true)
    }
  }
  
  
  func uploadProfileImageToAWSS3() {
    
    MTProgressIndicator.sharedInstance.showProgressIndicator()
    //s3-us-west-1
    let credentialsProvider = AWSStaticCredentialsProvider(accessKey: MTConstant.AWS3AccessKey, secretKey: MTConstant.AWS3SecretKey)
    let configuration = AWSServiceConfiguration(region:AWSRegionType.USWest1, credentialsProvider:credentialsProvider)
    
    AWSServiceManager.default().defaultServiceConfiguration = configuration
    
    let folderName = "profile-images"
    let S3BucketName = "motrss-dev-assets/\(folderName)"
    //let S3BucketName = "motrss-app-assets/\(folderName)"
    let realm = try! Realm()
    let userInfo = realm.objects(MTUserInfo.self).first
    let remoteName = String(format:"%@_image.jpg", (userInfo?.merchantID)!)
    MTLogger.log.info("remoteName=> \(remoteName)")
    
    let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(remoteName)
    //let image = UIImage(named: "test")
    let data = UIImageJPEGRepresentation(self.newUserImage!, 0.9)
    do {
      try data?.write(to: fileURL)
    }
    catch {}
    
    let uploadRequest = AWSS3TransferManagerUploadRequest()!
    uploadRequest.body = fileURL
    uploadRequest.key = remoteName
    uploadRequest.bucket = S3BucketName
    uploadRequest.contentType = "image/jpeg"
    uploadRequest.acl = .publicRead
    
    let transferManager = AWSS3TransferManager.default()
    transferManager.upload(uploadRequest).continueWith { (task) -> Any? in
      
      if let error = task.error {
        MTCommonUtils.showAlertViewWithTitle(title: "", message: error.localizedDescription)
        print("Upload failed with error: (\(error.localizedDescription))")
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
        do {
          try FileManager.default.removeItem(at: fileURL as URL)
        } catch {
          print(error)
        }
        self.newUserImageUrl = ""
        MTCommonUtils.showAlertViewWithTitle(title: "", message: "edit_profile_profile_image_upload_fail_text".localized)
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
      }
      
      if task.result != nil {
        
        DispatchQueue.main.async {
          
          let url = AWSS3.default().configuration.endpoint.url
          let publicURL = url?.appendingPathComponent(uploadRequest.bucket!).appendingPathComponent(uploadRequest.key!)
          if let imgUrl = publicURL?.absoluteString {
            MTLogger.log.info("imgUrl=> \(imgUrl)")
            let fileName = uploadRequest.key!
            MTLogger.log.info("imgUrl=> \(fileName)")
            self.newUserImageUrl = fileName
            ImageCache.default.removeImage(forKey: fileName)
          }
          do {
            MTLogger.log.info("fileURL=> \(fileURL)")
            try FileManager.default.removeItem(at: fileURL as URL)
          } catch {
            print(error)
          }
          //Update data to server
          self.updateUserProfileDetailsOnServer()
        }
      }
      return nil
    }
  }
  
}

extension MTProfileViewControler {
  
  @IBAction func editProfileButtonAction(_ sender: Any) {
    if !isEditingProfileDetails {
      isEditingProfileDetails = true
      editProfileDetails()
    }
  }
  
  @IBAction func saveButtonAction(_ sender: Any) {
    
    let spaceCount = nameTextfield.text?.characters.filter{$0 == " "}.count
    
    if (nameTextfield.text?.characters.count)! <= 0 {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "edit_profile_empty_name_err_text".localized)
    } else if (nameTextfield.text?.characters.count)! < 2 || (nameTextfield.text?.characters.count)! > 50 {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "register_name_validation_error_text".localized)
      
    } /*else if (shopNameTextfield.text?.characters.count)! <= 0 {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "edit_profile_empty_shop_name_err_text".localized)
    } else if (shopNameTextfield.text?.characters.count)! < 2 || (shopNameTextfield.text?.characters.count)! > 50 {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "register_name_validation_error_text".localized)
      
    }*/ else if spaceCount! > 4 {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "register_name_spaces_validation_error_text".localized)
    } else if (emailTextfield.text?.characters.count)! < 4 || (emailTextfield.text?.characters.count)! > 30 {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "login_email_validation_error_text".localized)
    } else if !MTCommonUtils.isValidEmail(emailString: emailTextfield.text!) {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "login_email_validation_error_text".localized)
    } else if !MTCommonUtils.isValidMobileNumber(formatedMobileNo: mobileTextfield.text!) {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "register_mobile_validation_error_text".localized)
    } else {
      if MTRechabilityManager.sharedInstance.isRechable {
        
        if self.oldMobileNumber != self.mobileTextfield.text {
          //Show OTP verification flow
          self.callToSendOTPService()
        } else {
          if newUserImage != nil {
            uploadProfileImageToAWSS3()
          } else {
            newUserImageUrl = ""
            //Update data to server
            updateUserProfileDetailsOnServer()
          }
        }
      } else {
        MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_no_internet".localized)
      }
    }
    
    /*if (nameTextfield.text?.characters.count)! <= 0 {
     MTCommonUtils.showAlertViewWithTitle(title: "", message: "edit_profile_empty_name_err_text".localized)
     } else if (emailTextfield.text?.characters.count)! <= 0 {
     MTCommonUtils.showAlertViewWithTitle(title: "", message: "edit_profile_empty_email_err_text".localized)
     } else if (mobileTextfield.text?.characters.count)! <= 0 {
     MTCommonUtils.showAlertViewWithTitle(title: "", message: "edit_profile_empty_mobile_err_text".localized)
     } else if !MTCommonUtils.isValidEmail(emailString: emailTextfield.text!) {
     MTCommonUtils.showAlertViewWithTitle(title: "", message: "login_email_validation_error_text".localized)
     } else if (mobileTextfield.text?.characters.count)! != 10 {
     MTCommonUtils.showAlertViewWithTitle(title: "", message: "register_mobile_validation_error_text".localized)
     } else {
     //Update data to server
     updateUserProfileDetailsOnServer()
     }*/
  }
  
  @IBAction func changePasswordButtonAction(_ sender: Any) {
    showResetPasswordView()
  }
  
  @IBAction func uploadUserImageButtonAction(_ sender: Any) {
    showProfileImageUploadAlert()
  }
  
  @IBAction func resendVerifcationEmailButtonAction(_ sender: Any) {
    sendResendEmailVerficationAlert()
    //resendVerificationEmail()
  }
  
  func sendResendEmailVerficationAlert() {
    let realm = try! Realm()
    let userInfo = realm.objects(MTUserInfo.self).first
    var userEmail = ""
    if let info = userInfo {
      userEmail = info.emailID
    }
    let alertMsg = "my_account_resend_email_verification_alert_text".localized + userEmail
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
        self.resendVerificationEmail()
        
      case .cancel:
        MTLogger.log.info("cancel")
        
      case .destructive:
        MTLogger.log.info("destructive")
      }
    }))
    
    let alertViewController = MTCommonUtils.visibleViewController()
    alertViewController.present(alert, animated: true, completion: nil)
  }
}

extension MTProfileViewControler {
  func updateUserProfileDetailsOnServer() {
    if MTRechabilityManager.sharedInstance.isRechable {
      MTProgressIndicator.sharedInstance.showProgressIndicator()
      
      MTProfileServiceManager.sharedInstance.updateMerchantProfile(name: nameTextfield.text!, email: emailTextfield.text!, mobile: mobileTextfield.text!, shopImage: newUserImageUrl!, /*shopName: shopNameTextfield.text!,*/ onSuccess: { (success) -> Void in
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
        if (success as! Bool) {
          /*if self.oldMobileNumber != self.mobileTextfield.text {
            //Show OTP verification flow
            self.callToSendOTPService()
          } else {*/
            self.showUpdateProfileMessage(msgStr: "edit_profile_success_alert_text".localized)
          //}
        }
      }) { (failure) -> Void in
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
      }
    } else {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_no_internet".localized)
    }
  }
  
  func resendVerificationEmail() {
    if MTRechabilityManager.sharedInstance.isRechable {
      MTProgressIndicator.sharedInstance.showProgressIndicator()
      
      MTProfileServiceManager.sharedInstance.resendVerificationEmail(successBlock: { (success) in
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
        if (success as! Bool) {
          MTCommonUtils.showAlertViewWithTitle(title: "", message: "profile_verification_email_sent_alert_text".localized)
        }
      }, onFailure: { (failure) in
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
      })
    } else {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_no_internet".localized)
    }
  }
}

extension MTProfileViewControler: MTChangePasswordViewDelegate {
  func didPasswordChangesSuccessfully() {
    
  }
}


extension MTProfileViewControler {
  
  func checkCacheStatusForMerchantProfile() {
    if MTRechabilityManager.sharedInstance.isRechable {
      MTProgressIndicator.sharedInstance.showProgressIndicator()
      MTProfileServiceManager.sharedInstance.checkCacheStatus(isForProduct: false, serviceName: MTNetworkConfig.GetMerchantProfile_URL, onSuccess: { (success) -> Void in
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
        if (success as! Bool) {
          MTLogger.log.info("Call Get Merchant Details Service => ")
          self.getMerchantProfileData()
        } else {
          //Do Nothing
        }
      }) { (failure) -> Void in
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
      }
    } else {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_no_internet".localized)
    }
  }
  
  func getMerchantProfileData() {
    if MTRechabilityManager.sharedInstance.isRechable {
      MTProgressIndicator.sharedInstance.showProgressIndicator()
      
      MTProfileServiceManager.sharedInstance.getMerchantProfile(onSuccess: { (success) -> Void in
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
        if (success as! Bool) {
          MTLogger.log.info("getMerchantProfileData => ")
          self.updatePageUI()
        }
      }) { (failure) -> Void in
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
        MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_something_went_wrong".localized)
      }
    } else {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_no_internet".localized)
    }
  }
}

extension MTProfileViewControler: MTVerifyOTPPinViewDelegate {
  
  func callToSendOTPService() {
    //To Send the OTP
    MTProgressIndicator.sharedInstance.showProgressIndicator()
    MTProfileServiceManager.sharedInstance.sendOTPPinForMobile(newMobileNo: mobileTextfield.text!, onSuccess: { (success) in
      MTProgressIndicator.sharedInstance.hideProgressIndicator()
      
      let json = JSON(success)
      if let status = json["Status"].string, status == "Success" {
        
        if let dataDict = json["Data"].dictionary {
          if let userOTP = dataDict["merchant_otp"]?.string {
            //Move to GET OTP screen
            self.showVerifyOTPScreen(userOTP: userOTP)
          } else {
            MTCommonUtils.showAlertViewWithTitle(title: "", message: "login_verify_mobile_toast_text".localized)
          }
        } else {
          MTCommonUtils.showAlertViewWithTitle(title: "", message: "login_verify_mobile_toast_text".localized)
        }
      } else {
        MTCommonUtils.showAlertViewWithTitle(title: "", message: "login_verify_mobile_toast_text".localized)
      }
    }, onFailure: { (failure) in
      MTProgressIndicator.sharedInstance.hideProgressIndicator()
      //MTCommonUtils.showAlertViewWithTitle(title: "", message: "login_verify_mobile_toast_text".localized)
    })
  }
  
  func showVerifyOTPScreen(userOTP: String) {
    //let realm = try! Realm()
    //let userInfo = realm.objects(MTUserInfo.self).first
    
    let views = Bundle.main.loadNibNamed("MTVerifyOTPPinView", owner: nil, options: nil)
    let verifyPinView = views?[0] as! MTVerifyOTPPinView
    verifyPinView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
    verifyPinView.delegate = self
    verifyPinView.userId = loggedInUserId
    //verifyPinView.userAuthKey = userInfo?.authKey
    verifyPinView.userOtp = userOTP
    verifyPinView.userMobileNumber = mobileTextfield.text!
    //verifyPinView.isFromRegistration = true
    //self.view.addSubview(verifyPinView)
    self.navigationController?.view.addSubview(verifyPinView)
  }
  
  func shallMoveToResetOTPScreen(userId: String) {
    //PIN Verify Success 
    didVerifyPinSuccess()
  }
  
  func didVerifyPinSuccess() {
    //Pin Verify success move back to scrren
    //self.showUpdateProfileMessage(msgStr: "edit_profile_success_alert_text".localized)
    if newUserImage != nil {
      uploadProfileImageToAWSS3()
    } else {
      newUserImageUrl = ""
      //Update data to server
      updateUserProfileDetailsOnServer()
    }
  }
  
  func didCancelVerifyPin() {
    //Pin Verify cancel move back to scrren
    //self.showUpdateProfileMessage(msgStr: "edit_profile_mobile_not_verified_alert_text".localized)
    MTCommonUtils.showAlertViewWithTitle(title: "", message: "edit_profile_mobile_not_verified_alert_text".localized)
  }
}
