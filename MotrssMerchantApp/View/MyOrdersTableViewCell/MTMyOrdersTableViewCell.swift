/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTMyOrdersTableViewCell.swift
 
 Description: This class is used to show order item in table view.
 
 Created By: Rohit W.
 
 Creation Date: 23/05/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import UIKit
import Kingfisher

protocol MTMyOrdersTableViewCellDelegate: class {
  func didSelectTimeslotPreference(timeslot: String, forOrderID orderNo: String)
}

class MTMyOrdersTableViewCell: UITableViewCell {
  
  @IBOutlet weak var bgView: UIView!
  @IBOutlet weak var orderDateTimeLabel: UILabel!
  @IBOutlet weak var orderNumberLabel: UILabel!
  @IBOutlet weak var vehicleLicenseNumberLabel: UILabel!
  @IBOutlet weak var totalTitleLabel: UILabel!
  @IBOutlet weak var totalAmountLabel: UILabel!
  @IBOutlet weak var userNameLabel: UILabel!
  
  @IBOutlet weak var declineOrderButton: UIButton!
  @IBOutlet weak var editOrderButton: UIButton!
  @IBOutlet weak var confirmOrderButton: UIButton!
  @IBOutlet weak var verticalDeviderLabel1: UILabel!
  @IBOutlet weak var verticalDeviderLabel2: UILabel!
  @IBOutlet weak var statusMessageLabel: UILabel!
  
  @IBOutlet weak var apptTimeTitleLabel: UILabel!
  @IBOutlet weak var timeslotPref1Button: UIButton!
  @IBOutlet weak var timeslotPref2Button: UIButton!
  @IBOutlet weak var timeslotPref3Button: UIButton!
  @IBOutlet weak var reviewFeedbackButton: UIButton!
  
  var delegate:MTMyOrdersTableViewCellDelegate?
	var	orderHistoryDataObj: MTOrderDetailInfo?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    bgView.layer.cornerRadius = 3.0
    bgView.layer.borderColor = UIColor.lightGray.cgColor
    bgView.layer.borderWidth = 1.0
    timeslotPref1Button.layer.cornerRadius = 3.0
    timeslotPref1Button.layer.borderColor = UIColor.appThemeColor.cgColor
    timeslotPref1Button.layer.borderWidth = 1.0
    timeslotPref2Button.layer.cornerRadius = 3.0
    timeslotPref2Button.layer.borderColor = UIColor.appThemeColor.cgColor
    timeslotPref2Button.layer.borderWidth = 1.0
    timeslotPref3Button.layer.cornerRadius = 3.0
    timeslotPref3Button.layer.borderColor = UIColor.appThemeColor.cgColor
    timeslotPref3Button.layer.borderWidth = 1.0
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

  func updateCellData(orderHistoryObj: MTOrderDetailInfo) {
    
    orderHistoryDataObj = orderHistoryObj
    orderNumberLabel.text = "myorder_order_no_title_text".localized + orderHistoryObj.orderId
    vehicleLicenseNumberLabel.text = orderHistoryObj.vehicleState + "-" + orderHistoryObj.vehicleNumber
    //totalTitleLabel.text = "myorder_total_title_text".localized
    totalAmountLabel.text = "currency_text".localized + orderHistoryObj.orderFinalAmount
    userNameLabel.text = orderHistoryObj.userName
    
    declineOrderButton.setTitle("myorder_decline_order_title_text".localized, for: .normal)
    confirmOrderButton.setTitle("myorder_confirm_order_title_text".localized, for: .normal)
    reviewFeedbackButton.setTitle("myorder_review_feedback_title_text".localized, for: .normal)
    reviewFeedbackButton.isHidden = true
    
    apptTimeTitleLabel.text = "myorder_appointment_time_title_text".localized
        
    //Time
    if orderHistoryObj.timePreference1.characters.count>0 {
      //Covert AM/PM time to show
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "HH:mm:ss"
      if let date = dateFormatter.date(from: orderHistoryObj.timePreference1) {
        dateFormatter.dateFormat = "h:mm a"
        let date24 = dateFormatter.string(from: date)
        timeslotPref1Button.setTitle(date24, for: .normal)
        timeslotPref1Button.isHidden = false
      } else {
          timeslotPref1Button.setTitle("", for: .normal)
          timeslotPref1Button.isHidden = true
      }
    } else {
      timeslotPref1Button.setTitle("", for: .normal)
      timeslotPref1Button.isHidden = true
    }
    if orderHistoryObj.timePreference2.characters.count>0 {
      //Covert AM/PM time to show
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "HH:mm:ss"
      if let date = dateFormatter.date(from: orderHistoryObj.timePreference2) {
      
        dateFormatter.dateFormat = "h:mm a"
        let date24 = dateFormatter.string(from: date)
        timeslotPref2Button.setTitle(date24, for: .normal)
        timeslotPref2Button.isHidden = false
      } else {
        timeslotPref2Button.setTitle("", for: .normal)
        timeslotPref2Button.isHidden = true
      }
    } else {
      timeslotPref2Button.setTitle("", for: .normal)
      timeslotPref2Button.isHidden = true
    }
    if orderHistoryObj.timePreference3.characters.count>0 {
      //Covert AM/PM time to show
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "HH:mm:ss"
      if let date = dateFormatter.date(from: orderHistoryObj.timePreference3) {
      
        dateFormatter.dateFormat = "h:mm a"
        let date24 = dateFormatter.string(from: date)
        timeslotPref3Button.setTitle(date24, for: .normal)
        timeslotPref3Button.isHidden = false
      } else {
        timeslotPref3Button.setTitle("", for: .normal)
        timeslotPref3Button.isHidden = true
      }
    } else {
      timeslotPref3Button.setTitle("", for: .normal)
      timeslotPref3Button.isHidden = true
    }
    
    verticalDeviderLabel1.isHidden = false
    verticalDeviderLabel2.isHidden = false
    statusMessageLabel.text = ""
    
    orderDateTimeLabel.text = ""
    if orderHistoryObj.orderDate.characters.count>0 {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd"
      let date = dateFormatter.date(from: (orderHistoryObj.orderDate))
      
      dateFormatter.dateFormat = "dd-MMM-yyyy"
      let date24 = dateFormatter.string(from: date!)
      orderDateTimeLabel.text = date24
    }
    
    if orderHistoryObj.orderStatus == "260" {
      declineOrderButton.isHidden = true
      editOrderButton.isHidden = true
      confirmOrderButton.isHidden = true
      verticalDeviderLabel1.isHidden = true
      verticalDeviderLabel2.isHidden = true
      statusMessageLabel.isHidden = true
      reviewFeedbackButton.isHidden = false
    }
    
    if orderHistoryObj.orderStatus == "201" {
      timeslotPref1Button.isEnabled = true
      timeslotPref2Button.isEnabled = true
      timeslotPref3Button.isEnabled = true
    } else {
      timeslotPref1Button.isEnabled = false
      timeslotPref2Button.isEnabled = false
      timeslotPref3Button.isEnabled = false
    }
  }
  
  func getHeightOfCell(orderHistoryObj: MTOrderDetailInfo)-> CGFloat {
    
    var cellHeight:CGFloat = 210.0
    //if orderHistoryObj.orderStatus == "260" {
    //  cellHeight = 162.0
    //}
    return cellHeight
  }
  
  @IBAction func timeslot1ButtonAction(_ sender: Any) {
    timeslotPref1Button.backgroundColor = UIColor.appThemeColor
    timeslotPref1Button.setTitleColor(UIColor.white, for: .normal)
    timeslotPref2Button.backgroundColor = UIColor.clear
    timeslotPref2Button.setTitleColor(UIColor.appThemeColor, for: .normal)
    timeslotPref3Button.backgroundColor = UIColor.clear
    timeslotPref3Button.setTitleColor(UIColor.appThemeColor, for: .normal)
    
    if let dataObj = orderHistoryDataObj {
      self.delegate?.didSelectTimeslotPreference(timeslot: dataObj.timePreference1, forOrderID: dataObj.orderId)
    }
  }
  
  @IBAction func timeslot2ButtonAction(_ sender: Any) {
    timeslotPref1Button.backgroundColor = UIColor.clear
    timeslotPref1Button.setTitleColor(UIColor.appThemeColor, for: .normal)
    timeslotPref2Button.backgroundColor = UIColor.appThemeColor
    timeslotPref2Button.setTitleColor(UIColor.white, for: .normal)
    timeslotPref3Button.backgroundColor = UIColor.clear
    timeslotPref3Button.setTitleColor(UIColor.appThemeColor, for: .normal)
    if let dataObj = orderHistoryDataObj {
      self.delegate?.didSelectTimeslotPreference(timeslot: dataObj.timePreference2, forOrderID: dataObj.orderId)
    }
  }
  
  @IBAction func timeslot3ButtonAction(_ sender: Any) {
    timeslotPref1Button.backgroundColor = UIColor.clear
    timeslotPref1Button.setTitleColor(UIColor.appThemeColor, for: .normal)
    timeslotPref2Button.backgroundColor = UIColor.clear
    timeslotPref2Button.setTitleColor(UIColor.appThemeColor, for: .normal)
    timeslotPref3Button.backgroundColor = UIColor.appThemeColor
    timeslotPref3Button.setTitleColor(UIColor.white, for: .normal)
    if let dataObj = orderHistoryDataObj {
      self.delegate?.didSelectTimeslotPreference(timeslot: dataObj.timePreference3, forOrderID: dataObj.orderId)
    }
  }
  
  @IBAction func reviewFeedbackButtonAction(_ sender: Any) {
    
  }
}
