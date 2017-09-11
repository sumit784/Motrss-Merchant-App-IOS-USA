/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTTeamMemberDetailViewController
 
 Description: This class is used to show home offer screen for the application.
 
 Created By: Pranay.
 
 Creation Date: 20/07/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import UIKit
import RealmSwift
import TextFieldEffects
import ALCameraViewController
import AWSS3
import AWSCore
import Kingfisher

class MTTeamMemberDetailViewController: MTBaseViewController {
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var contentView: UIView!

  
  @IBOutlet weak var addMemberImageBGView: UIView!
  @IBOutlet weak var addMemberImageView: UIImageView!
  @IBOutlet weak var addMemberImageButton: UIButton!
  
  @IBOutlet weak var nameTextField: HoshiTextField!
  @IBOutlet weak var emailTextField: HoshiTextField!
  @IBOutlet weak var mobileTextField: HoshiTextField!
  @IBOutlet weak var genderTitleLabel: UILabel!
  @IBOutlet weak var maleButton: UIButton!
  @IBOutlet weak var maleTitleLabel: UILabel!
  @IBOutlet weak var femaleButton: UIButton!
  @IBOutlet weak var femaleTitleLabel: UILabel!
  @IBOutlet weak var otherButton: UIButton!
  @IBOutlet weak var otherTitleLabel: UILabel!
  
  @IBOutlet weak var dlDetailTitleLabel: UILabel!
  @IBOutlet weak var dlNumberTextField: HoshiTextField!
  
  @IBOutlet weak var expDateTitleLabel: UILabel!
  @IBOutlet weak var expDateButton: UIButton!
  @IBOutlet weak var issueStateTitleLabel: UILabel!
  @IBOutlet weak var  issueStateButton: UIButton!
  
  @IBOutlet weak var uploadDLPhotoTitleLabel: UILabel!
  @IBOutlet weak var licensePhotoButton: UIButton!
  @IBOutlet weak var licensePhotoImageView: UIImageView!
  
  @IBOutlet weak var addButton: UIButton!
  
  var isAddTeamMember = false
  var isMaleSelected = true
  var isFemaleSelected = false
  var isOtherSelected = false
  var selectedExpDateStr = ""
  var selectedExpDate:Date?
  var teamDetailObj:MTTeamDetailInfo?
		  
  var stateDataArr:[String] = ["Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"]
  var stateSelectedIndex = 0
  var profileImage:UIImage?
  var drivingLicenseImage:UIImage?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    isShowBackButton = true
    
    let screenSize: CGRect = UIScreen.main.bounds
    self.scrollView.frame = CGRect(x:0, y:0, width:screenSize.width, height:screenSize.height)
    let height = licensePhotoImageView.frame.origin.y + licensePhotoImageView.frame.size.height + 130
    //let height = CGFloat(900)
    self.scrollView.contentSize = CGSize(width:self.scrollView.frame.width, height:height)
    contentView.frame = CGRect(x:0, y:0, width:screenSize.width, height:height)

    setLocalization()
    updatePageUI()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  deinit {
  }
  
  /// This function is used to update ht elogin screen UI
  func updatePageUI() {
    if let obj = teamDetailObj {
      nameTextField.text = obj.fullName
      emailTextField.text = obj.email
      mobileTextField.text = obj.mobile
      dlNumberTextField.text = obj.licenceNumber
      
      if obj.gender == "Male" {
        isMaleSelected = true
      } else if obj.gender == "Female" {
        isFemaleSelected = true
      } else if obj.gender == "Other" {
        isOtherSelected = true
      }
      updateGenderSelection()
      
      if obj.licenceExpDate.characters.count>0 {
        let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "dd-MMM-yyyy"
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let expDate = dateFormatter.date(from: obj.licenceExpDate) {
          
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "dd-MM-yyyy"
          self.selectedExpDate = expDate
          let expDateStr = dateFormatter.string(from: expDate)
          self.selectedExpDateStr = expDateStr
          self.expDateButton.setTitle(expDateStr, for: .normal)
        } else {
          self.selectedExpDate = Date()
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "dd-MM-yyyy"
          let date24 = dateFormatter.string(from: Date())
          self.selectedExpDateStr = date24
          self.expDateButton.setTitle(date24, for: .normal)
        }
      }
      
      if obj.licenceState.characters.count>0 {
        if let index = stateDataArr.index(of: obj.licenceState) {
          stateSelectedIndex = index
          issueStateButton.setTitle(obj.licenceState, for: .normal)
        } else {
          stateSelectedIndex = 0
          issueStateButton.setTitle(stateDataArr[stateSelectedIndex], for: .normal)
        }
      }
      
      if obj.profileImage.characters.count>0, obj.profileImage != "00"  {
        MTCommonUtils.updateTeamMemberImageCache(imageUrl: obj.profileImage, forImage: addMemberImageView, placeholder: UIImage(named: "user_default_round_image"), contentMode: .scaleToFill)
        addMemberImageView.contentMode = .scaleToFill
        addMemberImageView.layer.cornerRadius = (addMemberImageView.frame.size.height)/2
        addMemberImageView.layer.masksToBounds = true
        
        ImageCache.default.retrieveImage(forKey: obj.profileImage, options: nil) {
          image, cacheType in
          if let image = image {
            self.profileImage = image
          }
        }
      }
      if obj.licencePath.characters.count>0 {
        MTCommonUtils.updateTeamMemberImageCache(imageUrl: obj.licencePath, forImage: licensePhotoImageView, placeholder: UIImage(named: "upload_photo_img"), contentMode: .scaleToFill)
        
        ImageCache.default.retrieveImage(forKey: obj.licencePath, options: nil) {
          image, cacheType in
          if let image = image {
            self.drivingLicenseImage = image
          }
        }
      }
    }
  }
  
  func setLocalization() {
    self.title = "add_team_member_screen_title_text".localized
    nameTextField.placeholder = "add_team_member_full_name_title_text".localized
    emailTextField.placeholder = "add_team_member_email_title_text".localized
    mobileTextField.placeholder = "add_team_member_mob_no_title_text".localized
    dlNumberTextField.placeholder = "add_team_member_dl_number_title_text".localized
    
    genderTitleLabel.text = "add_team_member_gender_title_text".localized
    maleTitleLabel.text = "add_team_member_gender_male_title_text".localized
    femaleTitleLabel.text = "add_team_member_gender_female_title_text".localized
    otherTitleLabel.text = "add_team_member_gender_other_title_text".localized
    
    dlDetailTitleLabel.text = "add_team_member_dl_detail_title_text".localized
    expDateTitleLabel.text = "add_team_member_exp_date_title_text".localized
    issueStateTitleLabel.text = "add_team_member_issue_state_title_text".localized
    uploadDLPhotoTitleLabel.text = "add_team_member_upload_dl_photo_title_text".localized
    
    if isAddTeamMember {
      addButton.setTitle("add_team_member_add_btn_title_text".localized, for: .normal)
    } else {
      addButton.setTitle("add_team_member_update_btn_title_text".localized, for: .normal)
    }
    
    
    isMaleSelected = true
    updateGenderSelection()
    
    self.selectedExpDate = Date()
    let dateFormatter = DateFormatter()
    //dateFormatter.dateFormat = "dd-MMM-yyyy"
    dateFormatter.dateFormat = "dd-MM-yyyy"
    let date24 = dateFormatter.string(from: Date())
    self.selectedExpDateStr = date24
    self.expDateButton.setTitle(date24, for: .normal)
    
    stateSelectedIndex = 0
    issueStateButton.setTitle(stateDataArr[stateSelectedIndex], for: .normal)
  }
  
  func updateGenderSelection() {

    if isMaleSelected {
      maleButton.setImage(UIImage(named: "radio_button_selected"), for: .normal)
      femaleButton.setImage(UIImage(named: "radio_button_unselected_dark"), for: .normal)
      otherButton.setImage(UIImage(named: "radio_button_unselected_dark"), for: .normal)
    } else if isFemaleSelected {
      maleButton.setImage(UIImage(named: "radio_button_unselected_dark"), for: .normal)
      femaleButton.setImage(UIImage(named: "radio_button_selected"), for: .normal)
      otherButton.setImage(UIImage(named: "radio_button_unselected_dark"), for: .normal)
    } else if isOtherSelected {
      maleButton.setImage(UIImage(named: "radio_button_unselected_dark"), for: .normal)
      femaleButton.setImage(UIImage(named: "radio_button_unselected_dark"), for: .normal)
      otherButton.setImage(UIImage(named: "radio_button_selected"), for: .normal)
    } else {
      maleButton.setImage(UIImage(named: "radio_button_unselected_dark"), for: .normal)
      femaleButton.setImage(UIImage(named: "radio_button_unselected_dark"), for: .normal)
      otherButton.setImage(UIImage(named: "radio_button_unselected_dark"), for: .normal)
    }
  }
  
  func showProfileImageUploadAlert() {
    var optionArr:[String] = []
    if let _ = profileImage {
      optionArr.append("Remove Image")
    } else {
      optionArr.append("Phone Camera")
      optionArr.append("Gallery")
    }
    
    MTPickerView.showSingleColPicker("add_team_member_profile_image_title_text".localized, data: optionArr, defaultSelectedIndex: 0) {[unowned self] (selectedIndex, selectedValue) in
      
      let croppingEnabled = true
      if optionArr.count == 2 && selectedIndex == 0 {
        let cameraViewController = CameraViewController(croppingEnabled: croppingEnabled) { [weak self] image, asset in
          if image != nil {
            self?.profileImage = image
            self?.addMemberImageView.image = image
            self?.addMemberImageView.contentMode = .scaleToFill
            self?.addMemberImageView.layer.cornerRadius = (self?.addMemberImageView.frame.size.height)!/2
            self?.addMemberImageView.layer.masksToBounds = true
          }
          self?.dismiss(animated: true, completion: nil)
        }
        self.present(cameraViewController, animated: true, completion: nil)
      } else if optionArr.count == 2 && selectedIndex == 1 {
        let cameraViewController = CameraViewController.imagePickerViewController(croppingEnabled: croppingEnabled) { [weak self] image, asset in
          if image != nil {
            self?.profileImage = image
            self?.addMemberImageView.image = image
            self?.addMemberImageView.contentMode = .scaleToFill
            self?.addMemberImageView.layer.cornerRadius = (self?.addMemberImageView.frame.size.height)!/2
            self?.addMemberImageView.layer.masksToBounds = true
          }
          self?.dismiss(animated: true, completion: nil)
        }
        self.present(cameraViewController, animated: true, completion: nil)
      } else if optionArr.count == 1 && selectedIndex == 0 {
        self.profileImage = nil
        self.addMemberImageView.image = UIImage(named: "user_default_round_image")
        self.addMemberImageView.contentMode = .scaleToFill
        self.addMemberImageView.layer.cornerRadius = (self.addMemberImageView.frame.size.height)/2
        self.addMemberImageView.layer.masksToBounds = true
      }
    }
  }
  
  func showDrivingLicenseImageUploadAlert() {
    var optionArr:[String] = []
    if let _ = drivingLicenseImage {
      optionArr.append("Remove Image")
    } else {
      optionArr.append("Phone Camera")
      optionArr.append("Gallery")
    }
    
    MTPickerView.showSingleColPicker("add_team_member_upload_dl_photo_title_text".localized, data: optionArr, defaultSelectedIndex: 0) {[unowned self] (selectedIndex, selectedValue) in
      
      let croppingEnabled = true
      if optionArr.count == 2 && selectedIndex == 0 {
        let cameraViewController = CameraViewController(croppingEnabled: croppingEnabled) { [weak self] image, asset in
          if image != nil {
            self?.drivingLicenseImage = image
            self?.licensePhotoImageView.image = image
          }
          self?.dismiss(animated: true, completion: nil)
        }
        self.present(cameraViewController, animated: true, completion: nil)
      } else if optionArr.count == 2 && selectedIndex == 1 {
        let cameraViewController = CameraViewController.imagePickerViewController(croppingEnabled: croppingEnabled) { [weak self] image, asset in
          if image != nil {
            self?.drivingLicenseImage = image
            self?.licensePhotoImageView.image = image
          }
          self?.dismiss(animated: true, completion: nil)
        }
        self.present(cameraViewController, animated: true, completion: nil)
      } else if optionArr.count == 1 && selectedIndex == 0 {
        self.drivingLicenseImage = nil
        self.licensePhotoImageView.image = UIImage.init(named: "upload_photo_img")
      }
    }
  }
}

extension MTTeamMemberDetailViewController: UITextFieldDelegate {
  
  @IBAction func addMemberImageButtonAction(_ sender: Any) {
    showProfileImageUploadAlert()
  }

  @IBAction func genderButtonSlectionAction(_ sender: Any) {
    if let button = sender as? UIButton {
      if button.tag == 1 {
        if isMaleSelected {
          isMaleSelected = false
        } else {
          isMaleSelected = true
          isFemaleSelected = false
          isOtherSelected = false
        }
      } else if button.tag == 2 {
        if isFemaleSelected {
          isFemaleSelected = false
        } else {
          isFemaleSelected = true
          isMaleSelected = false
          isOtherSelected = false
        }
      } else if button.tag == 3 {
        if isOtherSelected {
          isOtherSelected = false
        } else {
          isOtherSelected = true
          isMaleSelected = false
          isFemaleSelected = false
        }
      }
    }
    updateGenderSelection()
  }
  
  @IBAction func expDateButtonAction(_ sender: Any) {
    var datePickerSetting = DatePickerSetting()
    if let oldDate = selectedExpDate {
      datePickerSetting.date = oldDate
    } else {
      datePickerSetting.date = Date()
    }
    datePickerSetting.minimumDate = Date()

    MTPickerView.showDatePicker("add_team_member_exp_date_title_text".localized, datePickerSetting: datePickerSetting) { (selectedDate) in
      MTLogger.log.info("selectedDate \(selectedDate)")
      self.selectedExpDate = selectedDate

      let dateFormatter = DateFormatter()
      //dateFormatter.dateFormat = "dd-MMM-yyyy"
      dateFormatter.dateFormat = "dd-MM-yyyy"
      let date24 = dateFormatter.string(from: selectedDate)
      self.selectedExpDateStr = date24
      self.expDateButton.setTitle(date24, for: .normal)
    }
  }
  
  @IBAction func issueStateButtonAction(_ sender: Any) {
    if stateDataArr.count<=0 {
      return
    }
    MTPickerView.showSingleColPicker("add_team_member_issue_state_title_text".localized, data: stateDataArr, defaultSelectedIndex: stateSelectedIndex) {[unowned self] (selectedIndex, selectedValue) in
      self.stateSelectedIndex = selectedIndex
      self.issueStateButton.setTitle(selectedValue, for: .normal)
    }
  }
  
  @IBAction func uploadDLPhotoButtonAction(_ sender: Any) {
    showDrivingLicenseImageUploadAlert()
  }
  
  @IBAction func addButtonAction(_ sender: Any) {
    
    let spaceCount = nameTextField.text?.characters.filter{$0 == " "}.count
    if (nameTextField.text?.characters.count)! < 2 || (nameTextField.text?.characters.count)! > 50 {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "register_name_validation_error_text".localized)
    } else if spaceCount! > 4 {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "register_name_spaces_validation_error_text".localized)
    } /*else if (emailTextField.text?.characters.count)! < 4 || (emailTextField.text?.characters.count)! > 30 {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "login_email_validation_error_text".localized)
    } else if !MTCommonUtils.isValidEmail(emailString: emailTextField.text!) {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "login_email_validation_error_text".localized)
    } else if !MTCommonUtils.isValidMobileNumber(formatedMobileNo: mobileTextField.text!) {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "register_mobile_validation_error_text".localized)
    }*/ else if (dlNumberTextField.text?.characters.count)! < 8 || (dlNumberTextField.text?.characters.count)! > 16 {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "add_vehicle_licence_number_invalid_error_text".localized)
    } else if drivingLicenseImage == nil {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "team_member_licence_photo_empty_error_text".localized)
    } else {
      if (emailTextField.text?.characters.count)! > 0 {
        if (emailTextField.text?.characters.count)! < 4 || (emailTextField.text?.characters.count)! > 30 {
          MTCommonUtils.showAlertViewWithTitle(title: "", message: "login_email_validation_error_text".localized)
        } else if !MTCommonUtils.isValidEmail(emailString: emailTextField.text!) {
          MTCommonUtils.showAlertViewWithTitle(title: "", message: "login_email_validation_error_text".localized)
        } else {
          if (mobileTextField.text?.characters.count)! > 0 {
            if !MTCommonUtils.isValidMobileNumber(formatedMobileNo: mobileTextField.text!) {
              MTCommonUtils.showAlertViewWithTitle(title: "", message: "register_mobile_validation_error_text".localized)
            } else {
              processTeamMemberData()
            }
          } else {
            processTeamMemberData()
          }
        }
      } else if (mobileTextField.text?.characters.count)! > 0 {
        if !MTCommonUtils.isValidMobileNumber(formatedMobileNo: mobileTextField.text!) {
          MTCommonUtils.showAlertViewWithTitle(title: "", message: "register_mobile_validation_error_text".localized)
        } else {
          processTeamMemberData()
        }
      } else {
        processTeamMemberData()
      }
    }
  }
  
  func processTeamMemberData()  {
    //Add Data on server
    
    let addTeamMember = MTTeamDetailInfo()
    addTeamMember.fullName = nameTextField.text!
    addTeamMember.email = emailTextField.text!
    addTeamMember.mobile = mobileTextField.text!
    if isMaleSelected {
      addTeamMember.gender = "Male"
    } else if isFemaleSelected {
      addTeamMember.gender = "Female"
    } else if isOtherSelected {
      addTeamMember.gender = "Other"
    }
    addTeamMember.licenceNumber = dlNumberTextField.text!
    addTeamMember.licenceExpDate = selectedExpDateStr
    addTeamMember.licenceState = stateDataArr[stateSelectedIndex]
    
    if let obj = teamDetailObj {
      if !isAddTeamMember {
        addTeamMember.teamId = obj.teamId
        addTeamMember.merchantId = obj.merchantId
        addTeamMember.awaitingApproval = obj.awaitingApproval
      }
    }
    
    if let licenseImage = drivingLicenseImage {
      
      MTProgressIndicator.sharedInstance.showProgressIndicator()
      uploadImageToAWSS3(uploadImage: licenseImage, isLicenseImg: true, teamDetailInfo: addTeamMember, onSuccess: { (success) in
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
        
        if let profilePic = self.profileImage {
          MTProgressIndicator.sharedInstance.showProgressIndicator()
          self.uploadImageToAWSS3(uploadImage: profilePic, isLicenseImg: false, teamDetailInfo: addTeamMember, onSuccess: { (success) in
            MTProgressIndicator.sharedInstance.hideProgressIndicator()
            
            self.addUpdateTeamMember(teamDetailInfo: addTeamMember)
          }, onFailure: { (failure) in
            MTProgressIndicator.sharedInstance.hideProgressIndicator()
          })
        } else {
          self.addUpdateTeamMember(teamDetailInfo: addTeamMember)
        }
      }, onFailure: { (failure) in
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
      })
    } else if let profilePic = self.profileImage {
      MTProgressIndicator.sharedInstance.showProgressIndicator()
      self.uploadImageToAWSS3(uploadImage: profilePic, isLicenseImg: false, teamDetailInfo: addTeamMember, onSuccess: { (success) in
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
        
        self.addUpdateTeamMember(teamDetailInfo: addTeamMember)
      }, onFailure: { (failure) in
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
      })
    } else {
      self.addUpdateTeamMember(teamDetailInfo: addTeamMember)
    }
  }
  
  // MARK: UITextField Delegate Methods
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
    //To prevent whitspace
    let strString = NSString(string: str)
    
    if textField == nameTextField {
      let spaceCount = str.characters.filter{$0 == " "}.count
      if str.characters.count > 50 {
        return false
      } else if spaceCount > 4 {
        return false
      }/*else if (strString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != NSNotFound) {
       return false
       }*/
    } else if textField == emailTextField {
      if str.characters.count > 30 {
        return false
      } else if (strString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != NSNotFound) {
        return false
      }
    } else if textField == mobileTextField {
      if str.characters.count > 10 {
        return false
      } else if (strString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != NSNotFound) {
        return false
      }
    } else if textField == dlNumberTextField {
      
      let characterSet = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789").inverted
      let filtered = string.components(separatedBy: characterSet).joined(separator: "")
      
      if str.characters.count > 16 {
        return false
      } else if (strString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != NSNotFound) {
        return false
      } else {
        return string == filtered
      }
    }
    return true
  }
}

extension MTTeamMemberDetailViewController {

  func uploadImageToAWSS3(uploadImage: UIImage, isLicenseImg: Bool, teamDetailInfo: MTTeamDetailInfo, onSuccess successBlock: @escaping ((AnyObject) -> Void), onFailure failureBlock: @escaping ((AnyObject) -> Void)) {
    
    //s3-us-west-1
    let credentialsProvider = AWSStaticCredentialsProvider(accessKey: MTConstant.AWS3AccessKey, secretKey: MTConstant.AWS3SecretKey)
    let configuration = AWSServiceConfiguration(region:AWSRegionType.USWest1, credentialsProvider:credentialsProvider)
    
    AWSServiceManager.default().defaultServiceConfiguration = configuration
    
    let folderName = "team-member-images"
    let S3BucketName = "motrss-dev-assets/\(folderName)"
    
    let realm = try! Realm()
    let userInfo = realm.objects(MTUserInfo.self).first
    var remoteName = ""
    if isLicenseImg {
      remoteName = String(format:"%@_%@_DL.jpg", (userInfo?.merchantID)!, (nameTextField.text)!)
    } else {
      remoteName = String(format:"%@_%@.jpg", (userInfo?.merchantID)!, (nameTextField.text)!)
    }
    MTLogger.log.info("remoteName=> \(remoteName)")
    
    let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(remoteName)
    let data = UIImageJPEGRepresentation(uploadImage, 0.9)
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
        MTLogger.log.info("Upload failed with error: (\(error.localizedDescription))")
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
        do {
          try FileManager.default.removeItem(at: fileURL as URL)
        } catch {
          print(error)
        }
        failureBlock(false as AnyObject)
      }
      
      if task.result != nil {
        
        DispatchQueue.main.async {
          
          let url = AWSS3.default().configuration.endpoint.url
          let publicURL = url?.appendingPathComponent(uploadRequest.bucket!).appendingPathComponent(uploadRequest.key!)
          if let imgUrl = publicURL?.absoluteString {
            MTLogger.log.info("imgUrl=> \(imgUrl)")
            let fileName = uploadRequest.key!
            MTLogger.log.info("imgUrl=> \(fileName)")
            if isLicenseImg {
              teamDetailInfo.licencePath = fileName
            } else {
              teamDetailInfo.profileImage = fileName
            }
            ImageCache.default.removeImage(forKey: fileName)
          }
          do {
            MTLogger.log.info("fileURL=> \(fileURL)")
            try FileManager.default.removeItem(at: fileURL as URL)
          } catch {
            print(error)
          }
          successBlock(true as AnyObject)
        }
      }
      
      return nil
    }
  }
  
  func addUpdateTeamMember(teamDetailInfo: MTTeamDetailInfo) {
    if MTRechabilityManager.sharedInstance.isRechable {
      MTProgressIndicator.sharedInstance.showProgressIndicator()
      
      var isUpdate = true
      if isAddTeamMember {
        isUpdate = false
      }
      
      MTTeamMemberServiceManager.sharedInstance.addUpdateTeamDetailData(isUpdate: isUpdate, memberDetail: teamDetailInfo, onSuccess: { (success) -> Void in
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
        if (success as! Bool) {
          self.showSuccessAlert()
        }
      }) { (failure) -> Void in
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
        MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_something_went_wrong".localized)
      }
    } else {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_no_internet".localized)
    }
  }
  
  func showSuccessAlert() {
    var mesageStr = ""
    if self.isAddTeamMember {
      mesageStr = "team_member_added_alert_text".localized
    } else {
      mesageStr = "team_member_updated_alert_text".localized
    }
    let alert = UIAlertController(title: "", message: mesageStr, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "general_ok_text".localized, style: UIAlertActionStyle.default, handler: { action in
      switch action.style{
      case .default:
        //self.delegate?.didAddUpdateVehicleDetails()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: MTConstant.Notification_RefreshTeamMembers), object: nil)
        self.navigationController?.popViewController(animated: true)
        MTLogger.log.info("default")
        
      case .cancel:
        MTLogger.log.info("cancel")
        
      case .destructive:
        MTLogger.log.info("destructive")
      }
    }))
    
    self.present(alert, animated: true, completion: nil)
  }
}
