/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTCalendarViewControler.swift
 
 Description: This class is used to show home calendar screen for the application.
 
 Created By: Pranay.
 
 Creation Date: 20/07/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import UIKit
import FSCalendar
import RealmSwift

class MTCalendarViewControler: MTBaseViewController {
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var monthTitleLabel: UILabel!
  @IBOutlet weak var updateButton: UIButton!
  
  var merchantSlotsDataArr:[MTMerchantSlotsInfo] = []
  var selectDateArray:[UIView] = []
  //var shopCloseSelcted = false
  var shopCloseButton:UIButton?
  var selectedItemIndex = 0
  var selectedTimeSlotIndex = 0
  var slotViewArray:[UIView] = []
  var capacityHourLabel:UILabel?
  var selectedTimeSlotData:MTSlotsData?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    isShowBackButton = true
    
    let screenSize: CGRect = UIScreen.main.bounds
    self.scrollView.frame = CGRect(x:0, y:0, width:screenSize.width, height:screenSize.height)
    let height = self.view.frame.origin.y + self.view.frame.size.height + 130
    self.scrollView.contentSize = CGSize(width:self.scrollView.frame.width, height:height)
    contentView.frame = CGRect(x:0, y:0, width:screenSize.width, height:height)

    setLocalization()
    updatePageUI()
    getMerchantCalendarData()
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
    
    let realm = try! Realm()
    let mtSlotsInfo = realm.objects(MTMerchantSlotsInfo.self)
    merchantSlotsDataArr.removeAll()
    for slotsInfo in mtSlotsInfo {
      merchantSlotsDataArr.append(slotsInfo)
      //merchantSlotsDataArr.append(MTMerchantSlotsInfo(value: slotsInfo))
    }

    //Month Label
    if merchantSlotsDataArr.count>0 {
      let firstObj = merchantSlotsDataArr.first
      if let dateObj = firstObj?.date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let expDate = dateFormatter.date(from: dateObj) {
          
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "MMM yyyy"
          let expDateStr = dateFormatter.string(from: expDate)
          self.monthTitleLabel.text = expDateStr
        }
      }
    }
    
    selectDateArray.removeAll()
    let horizontalCalendarView = UIView()
    horizontalCalendarView.frame = CGRect(x: 0, y: 100, width: self.scrollView.frame.size.width, height: 80)
    horizontalCalendarView.backgroundColor = UIColor.clear
    
    let deviderLabel = UILabel()
    deviderLabel.frame = CGRect(x: 0, y: horizontalCalendarView.frame.origin.y + horizontalCalendarView.frame.size.height, width: horizontalCalendarView.frame.size.width, height: 1)
    deviderLabel.backgroundColor = UIColor.selectedBorderColor
    self.scrollView.addSubview(deviderLabel)
    
    let width = horizontalCalendarView.frame.size.width/CGFloat(merchantSlotsDataArr.count)
    for (index, element) in merchantSlotsDataArr.enumerated() {
      
      let dateView = UIView()
      dateView.frame = CGRect(x: CGFloat(index) * width, y: 0, width: width, height: horizontalCalendarView.frame.size.height)
      dateView.backgroundColor = UIColor.unselectedBorderColor
      
      let topLabel = UILabel()
      topLabel.frame = CGRect(x: 0, y: 0, width: dateView.frame.size.width, height: dateView.frame.size.height/2)
      topLabel.backgroundColor = UIColor.clear
      topLabel.font = UIFont(name: MTConstant.fontHMavenProRegular, size: 16.0)
      topLabel.textAlignment = .center
      topLabel.textColor = UIColor.lightGray
      if element.date.characters.count>0 {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let slotDate = dateFormatter.date(from: element.date) {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "EE"
          let slotDateStr = dateFormatter.string(from: slotDate)
          topLabel.text = slotDateStr
        }
      }
      dateView.addSubview(topLabel)
      
      let bottomLabel = TopAlignedLabel()
      bottomLabel.frame = CGRect(x: 0, y: dateView.frame.size.height/2, width: dateView.frame.size.width, height: dateView.frame.size.height/2)
      bottomLabel.backgroundColor = UIColor.clear
      bottomLabel.font = UIFont(name: MTConstant.fontHMavenProRegular, size: 16.0)
      bottomLabel.textAlignment = .center
      if element.date.characters.count>0 {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let slotDate = dateFormatter.date(from: element.date) {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "dd"
          let slotDateStr = dateFormatter.string(from: slotDate)
          bottomLabel.text = slotDateStr
        }
      }
      dateView.addSubview(bottomLabel)
      
      let selecButton = UIButton()
      selecButton.frame = CGRect(x: 0, y: 0, width: dateView.frame.size.width, height: dateView.frame.size.height)
      selecButton.backgroundColor = UIColor.clear
      selecButton.tag = index
      selecButton.addTarget(self, action: #selector(dateSelectionButtonAction(_:)), for: .touchUpInside)
      dateView.addSubview(selecButton)
      
      dateView.tag = index
      selectDateArray.append(dateView)
      
      horizontalCalendarView.addSubview(dateView)
    }
    self.scrollView.addSubview(horizontalCalendarView)
    
    //Shop Closed
    let shopLabel = UILabel()
    shopLabel.frame = CGRect(x: 0, y: deviderLabel.frame.origin.y + deviderLabel.frame.size.height + 5, width: deviderLabel.frame.size.width/2, height: 30)
    shopLabel.backgroundColor = UIColor.clear
    shopLabel.font = UIFont(name: MTConstant.fontHMavenProRegular, size: 16.0)
    shopLabel.text = "calendar_screen_shop_closed_title_text".localized
    shopLabel.textAlignment = .right
    self.scrollView.addSubview(shopLabel)
    
    shopCloseButton = UIButton()
    shopCloseButton?.frame = CGRect(x: shopLabel.frame.size.width + 20, y: deviderLabel.frame.origin.y + deviderLabel.frame.size.height + 10, width: 25, height: 25)
    shopCloseButton?.setImage(UIImage(named: "uncheckmark"), for: .normal)
    shopCloseButton?.addTarget(self, action: #selector(shopClosedButtonAction(_:)), for: .touchUpInside)
    self.scrollView.addSubview(shopCloseButton!)
    
    let deviderLabel2 = UILabel()
    deviderLabel2.frame = CGRect(x: 0, y: (shopCloseButton?.frame.origin.y)! + (shopCloseButton?.frame.size.height)! + 15, width: self.scrollView.frame.size.width, height: 1)
    deviderLabel2.backgroundColor = UIColor.selectedBorderColor
    self.scrollView.addSubview(deviderLabel2)
    
    capacityHourLabel = UILabel()
    capacityHourLabel?.frame = CGRect(x: 0, y: deviderLabel2.frame.origin.y + deviderLabel2.frame.size.height, width: deviderLabel2.frame.size.width, height: 30)
    capacityHourLabel?.backgroundColor = UIColor.clear
    capacityHourLabel?.font = UIFont(name: MTConstant.fontHMavenProRegular, size: 16.0)
    capacityHourLabel?.text = "calendar_screen_capacity_title_text".localized
    capacityHourLabel?.textAlignment = .center
    self.scrollView.addSubview(capacityHourLabel!)
    
    selectedItemIndex = 0
    updateSelectedDateOption(index: selectedItemIndex)
    updateShopCloseStatus()
    updateTimeSlotView()
  }
  
  func updateSelectedDateOption(index: Int) {
    for selectDate in selectDateArray {
      if selectDate.tag == index {
        selectDate.backgroundColor = UIColor.appThemeColor
      } else {
        selectDate.backgroundColor = UIColor.unselectedBorderColor
      }
    }
  }
  
  func updateTimeSlotView() {
    
    for slotView in slotViewArray {
      for view in (slotView.subviews) {
        view.removeFromSuperview()
      }
      slotView.removeFromSuperview()
    }
    
    slotViewArray.removeAll()
    if selectedItemIndex >= merchantSlotsDataArr.count {
      return
    }
    if selectedItemIndex < merchantSlotsDataArr.count {
      let selectedSlotInfo = merchantSlotsDataArr[selectedItemIndex]
      if selectedSlotInfo.isOpen == "1" {
        return
      }
    }
    
    let selectedSlot = merchantSlotsDataArr[selectedItemIndex]
    var yPos = CGFloat((capacityHourLabel?.frame.origin.y)! + (capacityHourLabel?.frame.size.height)! + 10)
    var xPos = CGFloat(0.0)
    for (index, element) in selectedSlot.slots.enumerated() {
      if index % 2 == 0  {
        xPos = 0
        if index>0 {
          yPos = yPos + CGFloat(50)
        }
      } else {
        xPos = self.scrollView.frame.size.width/2
      }
      
      let slotView = UIView()
      slotView.frame = CGRect(x: xPos, y: yPos, width: self.scrollView.frame.size.width/2, height: 50)
      slotView.backgroundColor = UIColor.clear
      self.scrollView.addSubview(slotView)
      
      //Time Image
      let timeImgView = UIImageView()
      timeImgView.frame = CGRect(x: 10, y: 15, width: 20, height: 20)
      timeImgView.image = UIImage(named: "time_clock")
      slotView.addSubview(timeImgView)
      
      //Time Label
      let timeLabel = UILabel()
      timeLabel.frame = CGRect(x: timeImgView.frame.origin.x + timeImgView.frame.size.width + 0, y: 15, width: 70, height: 20)
      if element.scheduleSlotTime.characters.count>0 {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        if let slotDate = dateFormatter.date(from: element.scheduleSlotTime) {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "h:mm a"
          let slotDateStr = dateFormatter.string(from: slotDate)
          timeLabel.text = slotDateStr
        }
      }
      //timeLabel.text = element.scheduleSlotTime
      
      timeLabel.font = UIFont(name: MTConstant.fontHMavenProRegular, size: 13.0)
      timeLabel.textAlignment = .center
      timeLabel.backgroundColor = UIColor.clear
      slotView.addSubview(timeLabel)
      
      //Time button
      let timeButton = UIButton()
      let btnXPos = timeLabel.frame.origin.x + timeLabel.frame.size.width + 5
      timeButton.frame = CGRect(x: btnXPos, y: 10, width: slotView.frame.size.width-btnXPos-5, height: 30)
      timeButton.backgroundColor = UIColor.unselectedBorderColor
      timeButton.layer.borderWidth = 1.0
      timeButton.layer.borderColor = UIColor.selectedBorderColor.cgColor
      timeButton.setTitle(element.slotCapacity, for: .normal)
      timeButton.titleLabel?.font = UIFont(name: MTConstant.fontHMavenProRegular, size: 15.0)
      timeButton.setTitleColor(UIColor.black, for: .normal)
      timeButton.tag = index
      timeButton.addTarget(self, action: #selector(selectedTimeSlotButtonAction(_:)), for: .touchUpInside)
      slotView.addSubview(timeButton)
      
      slotViewArray.append(slotView)
    }
    
    if slotViewArray.count>0 {
      let lastTimeView = slotViewArray.last
      let height = (lastTimeView?.frame.origin.y)! + (lastTimeView?.frame.size.height)! + 30
      self.scrollView.contentSize = CGSize(width:self.scrollView.frame.width, height:height)
      contentView.frame = CGRect(x:0, y:0, width:self.scrollView.frame.size.width, height:height)
    }
  }
  
  
  func setLocalization() {
    self.title = "calendar_screen_title_text".localized
    updateButton.setTitle("calendar_screen_update_title_text".localized, for: .normal)
  }
  
  func showTimeSlotView(slotDetail: MTSlotsData) {
    let views = Bundle.main.loadNibNamed("MTTimeslotView", owner: nil, options: nil)
    let timeslotView = views?[0] as! MTTimeslotView
    timeslotView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
    timeslotView.delegate = self
    timeslotView.slotDataDetail = slotDetail
    self.navigationController?.view.addSubview(timeslotView)
  }
  
  override func backButtonAction(sender:UIBarButtonItem){
    let alert = UIAlertController(title: "", message: "back_button_alert_text".localized, preferredStyle: UIAlertControllerStyle.alert)
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
  }
  
  func updateShopCloseStatus() {
    if selectedItemIndex < merchantSlotsDataArr.count {
      let selectedSlotInfo = merchantSlotsDataArr[selectedItemIndex]
      if selectedSlotInfo.isOpen == "1" {
        DispatchQueue.main.async {
          self.shopCloseButton?.setImage(UIImage(named: "checkmark"), for: .normal)
        }
      } else if selectedSlotInfo.isOpen == "0" {
        DispatchQueue.main.async {
          self.shopCloseButton?.setImage(UIImage(named: "uncheckmark"), for: .normal)
        }
      }
    }
  }
}

extension MTCalendarViewControler: MTTimeslotViewDelegate {
  
  func didUpdateTimeSlot(updatedTimeslot: String) {
    
    let timeSlotView = slotViewArray[selectedTimeSlotIndex]
    for view in timeSlotView.subviews {
      if let button = view as? UIButton {
        button.setTitle(updatedTimeslot, for: .normal)
      }
    }
    let realm = try! Realm()
    try! realm.write {
      self.selectedTimeSlotData?.slotCapacity = updatedTimeslot
    }
  }
  
  func getMerchantCalendarData() {
    if MTRechabilityManager.sharedInstance.isRechable {
      MTProgressIndicator.sharedInstance.showProgressIndicator()
      
      MTDashboardServiceManager.sharedInstance.getMerchantTimeSlots(onSuccess: { (success) -> Void in
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
        if (success as! Bool) {
          MTLogger.log.info("getMerchantCalendarData => ")
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
  
  func updateMerchantTimeslotData() {
    if MTRechabilityManager.sharedInstance.isRechable {
      MTProgressIndicator.sharedInstance.showProgressIndicator()
      
      let selectedSlotInfo = merchantSlotsDataArr[selectedItemIndex]
      MTDashboardServiceManager.sharedInstance.updateMerchantTimeSlots(timeslotInfo: selectedSlotInfo, onSuccess: { (success) -> Void in
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
        if (success as! Bool) {
          MTLogger.log.info("updateMerchantTimeslotData => ")
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
    let mesageStr = "calendar_timeslot_updated_alert_text".localized
    let alert = UIAlertController(title: "", message: mesageStr, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "general_ok_text".localized, style: UIAlertActionStyle.default, handler: { action in
      switch action.style{
      case .default:
        //self.navigationController?.popViewController(animated: true)
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

extension MTCalendarViewControler {

  @IBAction func shopClosedButtonAction(_ sender: Any) {
    let selectedSlotInfo = merchantSlotsDataArr[selectedItemIndex]
    let realm = try! Realm()
    if selectedSlotInfo.isOpen == "1" {
      try! realm.write {
        selectedSlotInfo.isOpen = "0"
      }
    } else if selectedSlotInfo.isOpen == "0" {
      try! realm.write {
        selectedSlotInfo.isOpen = "1"
      }
    }
    merchantSlotsDataArr[selectedItemIndex] = selectedSlotInfo
    updateShopCloseStatus()
    updateTimeSlotView()
  }

  @IBAction func updateButtonAction(_ sender: Any) {
    updateMerchantTimeslotData()
  }
  
  @IBAction func selectedTimeSlotButtonAction(_ sender: Any) {
    if let button = sender as? UIButton {
      selectedTimeSlotIndex = button.tag
      let selectedSlot = merchantSlotsDataArr[selectedItemIndex]
      if (selectedSlot.slots.count>0) {
        selectedTimeSlotData = selectedSlot.slots[selectedTimeSlotIndex]
        showTimeSlotView(slotDetail: selectedTimeSlotData!)
      }
    }
  }
  
  @IBAction func dateSelectionButtonAction(_ sender: Any) {
    if let button = sender as? UIButton {
      selectedItemIndex = button.tag
      updateSelectedDateOption(index: selectedItemIndex)
      updateShopCloseStatus()
      updateTimeSlotView()
    }
  }
  
  @IBAction func timeslotSelectionButtonAction(_ sender: Any) {
    if let button = sender as? UIButton {
      if button.tag == 1 {
        
      }
    }
  }
  
}
