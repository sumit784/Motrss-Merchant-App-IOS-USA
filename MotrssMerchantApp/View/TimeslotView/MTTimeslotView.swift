/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTTimeslotView.swift
 
 Description: This class is used to to update the user password.
 
 Created By: Rohit W.
 
 Creation Date: 24/04/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import UIKit
import TextFieldEffects
import SwiftyJSON

protocol MTTimeslotViewDelegate: class {
  func didUpdateTimeSlot(updatedTimeslot: String)
}

class MTTimeslotView: UIView, UITextFieldDelegate {

  @IBOutlet weak var bgView: UIView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var timeslotLable: UILabel!
  @IBOutlet weak var plusButton: UIButton!
  @IBOutlet weak var minusButton: UIButton!
  @IBOutlet weak var nextButton: UIButton!
  @IBOutlet weak var cancelButton: UIButton!
  
  var delegate: MTTimeslotViewDelegate?
  var slotDataDetail:MTSlotsData?
  
  override func awakeFromNib() {
    bgView.layer.cornerRadius = 3.0
    nextButton.layer.cornerRadius = 15.0
    cancelButton.layer.cornerRadius = 15.0
    titleLabel.text = "calendar_update_timeslot_title_text".localized
    nextButton.setTitle("forgot_pwd_done_btn_text".localized, for: .normal)
    cancelButton.setTitle("general_cancel_text".localized, for: .normal)
  }

  override func draw(_ rect: CGRect) {
    super.draw(rect)
    if let detail = slotDataDetail {
      timeslotLable.text = detail.slotCapacity
    }
  }
  
  @IBAction func minusButtonAction(_ sender: Any) {
    let textValue = Int(timeslotLable.text!)
    if let value = textValue, value > 0 {
      let newValue = value - 1
      timeslotLable.text = "\(newValue)"
    }
  }
  
  @IBAction func plusButtonAction(_ sender: Any) {
    let textValue = Int(timeslotLable.text!)
    if let value = textValue, value < 50 {
      let newValue = value + 1
      timeslotLable.text = "\(newValue)"
    }
  }
  
  @IBAction func nextButtonAction(_ sender: Any) {
    self.delegate?.didUpdateTimeSlot(updatedTimeslot: timeslotLable.text!)
    removeFromSuperview()
  }
  
  @IBAction func cancelButtonAction(_ sender: Any) {
    removeFromSuperview()
  }
  
}
