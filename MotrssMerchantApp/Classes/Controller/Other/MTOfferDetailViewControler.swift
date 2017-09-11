/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTOfferDetailViewControler
 
 Description: This class is used to show home offer screen for the application.
 
 Created By: Pranay.
 
 Creation Date: 20/07/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import UIKit
import RealmSwift

class MTOfferDetailViewControler: MTBaseViewController {
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var contentView: UIView!

  @IBOutlet weak var offerTitleLabel: UILabel!
  @IBOutlet weak var offerPercentOffLabel: UILabel!
  @IBOutlet weak var offerFlatOffLabel: UILabel!
  @IBOutlet weak var offerPercentOffButton: UIButton!
  @IBOutlet weak var offerFlatOffButton: UIButton!
  
  @IBOutlet weak var offerTypeTitleLabel: UILabel!
  @IBOutlet weak var offerGeneralOffLabel: UILabel!
  @IBOutlet weak var offerCustomerLabel: UILabel!
  @IBOutlet weak var offerGeneralButton: UIButton!
  @IBOutlet weak var offerCustomerButton: UIButton!
  
  @IBOutlet weak var offerAmountTitleLabel: UILabel!
  @IBOutlet weak var offerAmountTextField: UITextField!
  @IBOutlet weak var offerPercentTitleLabel: UILabel!
  @IBOutlet weak var offerPercentTextField: UITextField!
  
  @IBOutlet weak var offerCodeTitleLabel: UILabel!
  @IBOutlet weak var offerCodeTextField: UITextField!
  @IBOutlet weak var generateCodeButton: UIButton!
  
  @IBOutlet weak var startDateTitleLabel: UILabel!
  @IBOutlet weak var startDateButton: UIButton!
  @IBOutlet weak var endDateTitleLabel: UILabel!
  @IBOutlet weak var endDateButton: UIButton!
  
  @IBOutlet weak var offerNameTitleLabel: UILabel!
  @IBOutlet weak var offerNameTextField: UITextField!
  @IBOutlet weak var offerDescTitleLabel: UILabel!
  @IBOutlet weak var offerDescTextView: UITextView!
  
  @IBOutlet weak var addOfferButton: UIButton!
  
  var offerDetailObject:MTOffersDetailInfo?
  var isAddOffers = false
  var selectedStartDateStr = ""
  var selectedEndDateStr = ""
  var selectedStartDate:Date?
  var selectedEndDate:Date?
  var isFlatOfferSelected = true
	var isPercentOfferSelected = false
  var isOfferTypeGeneralSelected = true
  var isOfferTypeCustomerSelected = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    isShowBackButton = true
    
    let screenSize: CGRect = UIScreen.main.bounds
    self.scrollView.frame = CGRect(x:0, y:0, width:screenSize.width, height:screenSize.height)
    let height = offerDescTextView.frame.origin.y + offerDescTextView.frame.size.height + 120
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
    if let offerObj = offerDetailObject {
      if !isAddOffers {
        if offerObj.percentOffAmt.characters.count>0 {
          isFlatOfferSelected = false
          isPercentOfferSelected = true
          updateSelectedOffer()
          offerPercentTextField.text = offerObj.percentOffAmt
        }
        
        offerAmountTextField.text = offerObj.offerMaxAmt
        offerCodeTextField.text = offerObj.offerCode
        //startDateButton.setTitle(offerObj.offerStartDate, for: .normal)
        //endDateButton.setTitle(offerObj.offerExpDate, for: .normal)
        offerNameTextField.text = offerObj.offerName
        offerDescTextView.text = offerObj.offerDescription
        
        if offerObj.offerStartDate.characters.count>0 {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
          let dateObj = dateFormatter.date(from: offerObj.offerStartDate)
          
          if let date = dateObj {
            selectedStartDate = date
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            let date24 = dateFormatter.string(from: date)
            self.selectedStartDateStr = date24
            self.startDateButton.setTitle(date24, for: .normal)
          }
        }
        
        if offerObj.offerExpDate.characters.count>0 {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
          let dateObj = dateFormatter.date(from: offerObj.offerExpDate)
          
          if let date = dateObj {
            selectedEndDate = date
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            let date24 = dateFormatter.string(from: date)
            self.selectedEndDateStr = date24
            self.endDateButton.setTitle(date24, for: .normal)
          }
        }
        
        if offerObj.offerType == "G" {
          isOfferTypeGeneralSelected = true
          isOfferTypeCustomerSelected = false
          updateSelectedOfferType()
        } else if offerObj.offerType == "C" {
          isOfferTypeGeneralSelected = false
          isOfferTypeCustomerSelected = true
          updateSelectedOfferType()
        }
      }
    }
  }
  
  func setLocalization() {
    if isAddOffers {
      self.title = "offers_add_screen_title_text".localized
    } else {
      self.title = "offers_add_update_screen_title_text".localized
    }
    
    offerTitleLabel.text = "offers_add_offer_title_title_text".localized
    offerPercentOffLabel.text = "offers_add_offer_percent_off_text".localized
    offerFlatOffLabel.text = "offers_add_flat_off_text".localized
    
    offerTypeTitleLabel.text = "offers_add_offer_type_title_text".localized
    offerGeneralOffLabel.text = "offers_add_offer_type_general_text".localized
    offerCustomerLabel.text = "offers_add_offer_type_customer_text".localized
    
    offerAmountTitleLabel.text = "offers_add_offer_amt_title_text".localized
    offerPercentTitleLabel.text = "offers_add_offer_percent_title_text".localized
    
    offerAmountTextField.layer.cornerRadius = 1.0
    offerAmountTextField.layer.borderColor = UIColor.selectedBorderColor.cgColor
    offerAmountTextField.layer.borderWidth = 1.0
    offerPercentTextField.layer.cornerRadius = 1.0
    offerPercentTextField.layer.borderColor = UIColor.selectedBorderColor.cgColor
    offerPercentTextField.layer.borderWidth = 1.0
    
    offerCodeTitleLabel.text = "offers_add_offer_code_title_text".localized
    offerCodeTextField.layer.cornerRadius = 1.0
    offerCodeTextField.layer.borderColor = UIColor.selectedBorderColor.cgColor
    offerCodeTextField.layer.borderWidth = 1.0
    generateCodeButton.setTitle("offers_add_offer_generate_title_text".localized, for: .normal)

    startDateTitleLabel.text = "offers_add_start_date_title_text".localized
    startDateButton.layer.cornerRadius = 1.0
    startDateButton.layer.borderColor = UIColor.selectedBorderColor.cgColor
    startDateButton.layer.borderWidth = 1.0
    
    endDateTitleLabel.text = "offers_add_end_date_title_text".localized
    endDateButton.layer.cornerRadius = 1.0
    endDateButton.layer.borderColor = UIColor.selectedBorderColor.cgColor
    endDateButton.layer.borderWidth = 1.0
    
    offerNameTitleLabel.text = "offers_add_offer_name_title_text".localized
    offerNameTextField.layer.cornerRadius = 1.0
    offerNameTextField.layer.borderColor = UIColor.selectedBorderColor.cgColor
    offerNameTextField.layer.borderWidth = 1.0
    
    offerDescTitleLabel.text = "offers_add_offer_desc_title_text".localized
    offerDescTextView.layer.cornerRadius = 1.0
    offerDescTextView.layer.borderColor = UIColor.selectedBorderColor.cgColor
    offerDescTextView.layer.borderWidth = 1.0

    if self.isAddOffers {
      addOfferButton.setTitle("offers_add_offer_button_title_text".localized, for: .normal)
    } else {
      addOfferButton.setTitle("offers_update_offer_button_title_text".localized, for: .normal)
    }
    
    updateSelectedOffer()
    updateSelectedOfferType()
  }
  
  func updateSelectedOffer() {
    if isFlatOfferSelected {
      offerFlatOffButton.setImage(UIImage(named: "radio_button_selected"), for: .normal)
      offerFlatOffButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
      offerPercentOffButton.setImage(UIImage(named: "radio_button_unselected_dark"), for: .normal)
      offerPercentOffButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
      
      offerPercentTitleLabel.isHidden = true
      offerPercentTextField.isHidden = true
      offerPercentTextField.text = ""
    } else if isPercentOfferSelected {
      offerFlatOffButton.setImage(UIImage(named: "radio_button_unselected_dark"), for: .normal)
      offerFlatOffButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
      offerPercentOffButton.setImage(UIImage(named: "radio_button_selected"), for: .normal)
      offerPercentOffButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
      
      offerPercentTitleLabel.isHidden = false
      offerPercentTextField.isHidden = false
      offerPercentTextField.text = ""
    }
  }
  
  func updateSelectedOfferType() {
    if isOfferTypeGeneralSelected {
      offerGeneralButton.setImage(UIImage(named: "radio_button_selected"), for: .normal)
      offerGeneralButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
      offerCustomerButton.setImage(UIImage(named: "radio_button_unselected_dark"), for: .normal)
      offerCustomerButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
      
    } else if isOfferTypeCustomerSelected {
      offerGeneralButton.setImage(UIImage(named: "radio_button_unselected_dark"), for: .normal)
      offerGeneralButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
      offerCustomerButton.setImage(UIImage(named: "radio_button_selected"), for: .normal)
      offerCustomerButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
    }
  }
}

extension MTOfferDetailViewControler: UITextFieldDelegate {
  
  @IBAction func generateCodeButtonAction(_ sender: Any) {
    offerCodeTextField.text = randomOfferCodeString(length: 5)
  }
  
  @IBAction func startDateButtonAction(_ sender: Any) {

    var datePickerSetting = DatePickerSetting()
    if let oldDate = selectedStartDate {
      datePickerSetting.date = oldDate
    } else {
      datePickerSetting.date = Date()
    }
    datePickerSetting.minimumDate = Date()
    
    MTPickerView.showDatePicker("offers_add_start_date_title_text".localized, datePickerSetting: datePickerSetting) { (selectedDate) in
      MTLogger.log.info("selectedDate \(selectedDate)")
      self.selectedStartDate = selectedDate
      
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "dd-MMM-yyyy"
      let date24 = dateFormatter.string(from: selectedDate)
      self.selectedStartDateStr = date24
      self.startDateButton.setTitle(date24, for: .normal)
    }
  }
  
  @IBAction func endDateButtonAction(_ sender: Any) {
    if let oldDate = selectedStartDate {
      
      var datePickerSetting = DatePickerSetting()
      datePickerSetting.date = oldDate
      datePickerSetting.minimumDate = oldDate
      
      MTPickerView.showDatePicker("offers_add_end_date_title_text".localized, datePickerSetting: datePickerSetting) { (selectedDate) in
        MTLogger.log.info("selectedDate \(selectedDate)")
        self.selectedEndDate = selectedDate
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        let date24 = dateFormatter.string(from: selectedDate)
        self.selectedEndDateStr = date24
        self.endDateButton.setTitle(date24, for: .normal)
      }
    } else {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "offers_add_offer_start_date_empty_alert_text".localized)
    }
  }
  
  @IBAction func addOfferButtonAction(_ sender: Any) {
    if (offerAmountTextField.text?.characters.count)! <= 0 {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "offers_add_empty_offer_amt_alert_text".localized)
    } else if (offerCodeTextField.text?.characters.count)! <= 0 {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "offers_add_empty_offer_code_alert_text".localized)
    } else if (selectedStartDateStr.characters.count)<=0 {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "offers_add_empty_start_date_alert_text".localized)
    } else if (selectedEndDateStr.characters.count)<=0 {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "offers_add_empty_end_date_alert_text".localized)
    } else if (offerNameTextField.text?.characters.count)! < 2 || (offerNameTextField.text?.characters.count)! > 20 {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "offers_add_empty_offer_name_alert_text".localized)
    } else if (offerDescTextView.text?.characters.count)! <= 0 {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "offers_add_empty_offer_desc_alert_text".localized)
    } else if isPercentOfferSelected && (offerPercentTextField.text?.characters.count)!<=0 {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "offers_add_empty_offer_percent_alert_text".localized)
    } else {
      if isAddOffers {
        addUpdateMerchantOffer(isUpdate: false, offerId: "")
      } else {
        addUpdateMerchantOffer(isUpdate: true, offerId: (offerDetailObject?.offerId)!)
      }
    }
  }
  
  @IBAction func offerSelectionButtonAction(_ sender: Any) {
    if let button = sender as? UIButton {
      if button.tag == 1 {
        if isPercentOfferSelected {
          /*isPercentOfferSelected = false
          isFlatOfferSelected = true*/
        } else {
          isPercentOfferSelected = true
          isFlatOfferSelected = false
        }
      } else if button.tag == 2 {
        if isFlatOfferSelected {
          /*isFlatOfferSelected = false
          isPercentOfferSelected = true*/
        } else {
          isFlatOfferSelected = true
          isPercentOfferSelected = false
        }
      }
      updateSelectedOffer()
    }
  }
  
  @IBAction func offerTypeSelectionButtonAction(_ sender: Any) {
    if let button = sender as? UIButton {
      if button.tag == 1 {
        if isOfferTypeGeneralSelected {
        } else {
          isOfferTypeGeneralSelected = true
          isOfferTypeCustomerSelected = false
        }
      } else if button.tag == 2 {
        if isOfferTypeCustomerSelected {
        } else {
          isOfferTypeCustomerSelected = true
          isOfferTypeGeneralSelected = false
        }
      }
      updateSelectedOfferType()
    }
  }
  
  func randomOfferCodeString(length: Int) -> String {
    
    let letters : NSString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let len = UInt32(letters.length)
    
    var randomString = ""
    
    for _ in 0 ..< length {
      let rand = arc4random_uniform(len)
      var nextChar = letters.character(at: Int(rand))
      randomString += NSString(characters: &nextChar, length: 1) as String
    }
    
    return randomString
  }
  
  // MARK: UITextField Delegate Methods
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
    //To prevent whitspace
    let strString = NSString(string: str)
    
    if textField == offerAmountTextField {
      if str.characters.count > 4 {
        return false
      } else if (strString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != NSNotFound) {
        return false
      }
    } else if textField == offerPercentTextField {
      if str.contains(".") {
        if str.characters.count > 3 {
          return false
        } else if (strString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != NSNotFound) {
          return false
        }
      } else {
        if str.characters.count > 2 {
          return false
        } else if (strString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != NSNotFound) {
          return false
        }
      }
    } else if textField == offerNameTextField {
      if str.characters.count > 20 {
        return false
      } else if (strString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != NSNotFound) {
        return false
      }
    }
    return true
  }
}

extension MTOfferDetailViewControler {

  func addUpdateMerchantOffer(isUpdate: Bool, offerId: String) {
    if MTRechabilityManager.sharedInstance.isRechable {
      MTProgressIndicator.sharedInstance.showProgressIndicator()
      
      var offerTypeStr = ""
      var offerOptionStr = ""
      if isOfferTypeGeneralSelected {
        offerTypeStr = "G"
      } else if isOfferTypeCustomerSelected {
        offerTypeStr = "C"
      }
      if isFlatOfferSelected {
        offerOptionStr = "flat"
      } else if isPercentOfferSelected {
        offerOptionStr = "percent"
      }
      
      MTOfferServiceManager.sharedInstance.addUpdateNewMerchantOffer(isUpdate: isUpdate, offerId: offerId, offerOption: offerOptionStr, percentAmt: offerPercentTextField.text!, offerType: offerTypeStr, offerAmt: offerAmountTextField.text!, offerCode: offerCodeTextField.text!, startDate: selectedStartDateStr, endDate: selectedEndDateStr, offerName: offerNameTextField.text!, offerDescription: offerDescTextView.text!, onSuccess: { (success) -> Void in
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
    if self.isAddOffers {
      mesageStr = "offers_add_offer_added_alert_text".localized
    } else {
      mesageStr = "offers_add_offer_updated_alert_text".localized
    }
    let alert = UIAlertController(title: "", message: mesageStr, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "general_ok_text".localized, style: UIAlertActionStyle.default, handler: { action in
      switch action.style{
      case .default:
        //self.delegate?.didAddUpdateVehicleDetails()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: MTConstant.Notification_RefreshMErchantOffers), object: nil)
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
