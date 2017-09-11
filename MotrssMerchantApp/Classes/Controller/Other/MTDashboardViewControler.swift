/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTDashboardViewControler.swift
 
 Description: This class is used to show home dashboard screen for the application.
 
 Created By: Pranay.
 
 Creation Date: 20/07/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import UIKit
import RealmSwift

class MTDashboardViewControler: MTBaseViewController {
  
  @IBOutlet weak var earningView: UIView!
  @IBOutlet weak var balanceView: UIView!
  @IBOutlet weak var totalView: UIView!
  @IBOutlet weak var earningTitleLabel: UILabel!
  @IBOutlet weak var earningValueLabel: UILabel!
  @IBOutlet weak var balanceTitleLabel: UILabel!
  @IBOutlet weak var balanceValueLabel: UILabel!
  @IBOutlet weak var totalTitleLabel: UILabel!
  @IBOutlet weak var totalValueLabel: UILabel!
  @IBOutlet weak var fromTitleLabel: UILabel!
  @IBOutlet weak var toTitleLabel: UILabel!
  @IBOutlet weak var revenueTitleLabel: UILabel!
  @IBOutlet weak var getDetailButton: UIButton!
  @IBOutlet weak var fromDateButton: UIButton!
  @IBOutlet weak var toDateButton: UIButton!
  
  var selectedStartDateStr = ""
  var selectedEndDateStr = ""
  var selectedStartDate:Date?
  var selectedEndDate:Date?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    isShowBackButton = true
    
    setLocalization()
    updatePageUI()
    getMerchantEarnings()
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
    let realm = try! Realm()
    if let earningInfo = realm.objects(MTEarningsDetailInfo.self).first {
      earningValueLabel.text = "currency_text".localized + " " + earningInfo.monthEarningMerchant
      balanceValueLabel.text = "currency_text".localized + " " + earningInfo.totalBalanceMerchant
      totalValueLabel.text = "currency_text".localized + " " + earningInfo.totalEarningAll
    }
  }
  
  func setLocalization() {
    self.title = "dashboard_screen_title_text".localized
    earningTitleLabel.text = "dashboard_screen_earning_this_month_title_text".localized
    balanceTitleLabel.text = "dashboard_screen_your_balance_text".localized
    totalTitleLabel.text = "dashboard_screen_total_earning_title_text".localized
    
    fromTitleLabel.text = "dashboard_screen_from_title_text".localized
    toTitleLabel.text = "dashboard_screen_to_title_text".localized
    revenueTitleLabel.text = "dashboard_screen_revenue_title_text".localized
    getDetailButton.setTitle("dashboard_screen_get_btn_title_text".localized, for: .normal)
    getDetailButton.layer.cornerRadius = 3.0
    getDetailButton.clipsToBounds = true
    
    earningView.layer.cornerRadius = 3.0
    earningView.clipsToBounds = true
    balanceView.layer.cornerRadius = 3.0
    balanceView.clipsToBounds = true
    totalView.layer.cornerRadius = 3.0
    totalView.clipsToBounds = true
    
    fromDateButton.layer.cornerRadius = 1.0
    fromDateButton.layer.borderColor = UIColor.selectedBorderColor.cgColor
    fromDateButton.layer.borderWidth = 1.0
    toDateButton.layer.cornerRadius = 1.0
    toDateButton.layer.borderColor = UIColor.selectedBorderColor.cgColor
    toDateButton.layer.borderWidth = 1.0
    getDetailButton.layer.cornerRadius = 1.0
    getDetailButton.clipsToBounds = true
  }
}

extension MTDashboardViewControler {
  
  @IBAction func getDetailButtonAction(_ sender: Any) {
    if selectedStartDate == nil || selectedEndDate == nil {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "dashboard_add_offer_from_date_empty_alert_text".localized)
    } else {
      getMerchantEarnings()
    }
  }
  
  @IBAction func fromDateButtonAction(_ sender: Any) {
    var datePickerSetting = DatePickerSetting()
    if let oldDate = selectedStartDate {
      datePickerSetting.date = oldDate
    } else {
      datePickerSetting.date = Date()
    }
    let previousYear = Calendar.current.date(byAdding: .year, value: -1, to: Date())
    datePickerSetting.minimumDate = previousYear
    
    MTPickerView.showDatePicker("dashboard_screen_from_title_text".localized, datePickerSetting: datePickerSetting) { (selectedDate) in
      MTLogger.log.info("selectedDate \(selectedDate)")
      self.selectedStartDate = selectedDate
      
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "dd-MMM-yyyy"
      let date24 = dateFormatter.string(from: selectedDate)
      self.selectedStartDateStr = date24
      self.fromDateButton.setTitle(date24, for: .normal)
    }
  }
  
  @IBAction func toDateButtonAction(_ sender: Any) {
    if let oldDate = selectedStartDate {
      
      var datePickerSetting = DatePickerSetting()
      datePickerSetting.date = oldDate
      datePickerSetting.minimumDate = oldDate
      
      MTPickerView.showDatePicker("dashboard_screen_to_title_text".localized, datePickerSetting: datePickerSetting) { (selectedDate) in
        MTLogger.log.info("selectedDate \(selectedDate)")
        self.selectedEndDate = selectedDate
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        let date24 = dateFormatter.string(from: selectedDate)
        self.selectedEndDateStr = date24
        self.toDateButton.setTitle(date24, for: .normal)
      }
    } else {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "dashboard_add_offer_from_date_empty_alert_text".localized)
    }
  }
}

extension MTDashboardViewControler {
  
  func getMerchantEarnings() {
    if MTRechabilityManager.sharedInstance.isRechable {
      MTProgressIndicator.sharedInstance.showProgressIndicator()
      
      MTDashboardServiceManager.sharedInstance.getMerchantOrdersAndRevenue(fromDate: selectedStartDateStr, toDate: selectedEndDateStr, onSuccess: { (success) -> Void in
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
        if (success as! Bool) {
          MTLogger.log.info("getMerchadntEarnings => ")
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
