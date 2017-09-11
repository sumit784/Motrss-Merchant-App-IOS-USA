/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTOffersTableViewCell.swift
 
 Description: This class is used to show order item in table view.
 
 Created By: Rohit W.
 
 Creation Date: 23/05/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import UIKit
import Kingfisher

class MTOffersTableViewCell: UITableViewCell {
  
  @IBOutlet weak var bgView: UIView!
  @IBOutlet weak var offerIDLabel: UILabel!
  @IBOutlet weak var offerCodeLabel: UILabel!
  @IBOutlet weak var offerTypeLabel: UILabel!
  @IBOutlet weak var offerStatusLabel: UILabel!
  
  @IBOutlet weak var deviderLabel1: UILabel!
  @IBOutlet weak var deviderLabel2: UILabel!
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var cancelMyOfferButton: UIButton!
  @IBOutlet weak var editButton: UIButton!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    bgView.layer.cornerRadius = 3.0
    bgView.layer.borderColor = UIColor.lightGray.cgColor
    bgView.layer.borderWidth = 1.0
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

  func updateCellData(offerDetailObj: MTOffersDetailInfo) {
    offerIDLabel.text = "offers_screen_offer_id_text".localized + offerDetailObj.offerId
    offerCodeLabel.text = "offers_screen_offer_code_text".localized + offerDetailObj.offerCode
    offerTypeLabel.text = "offers_screen_offer_type_text".localized + offerDetailObj.offerType
    if offerDetailObj.status.characters.count>0 {
      offerStatusLabel.text = "offers_screen_offer_status_text".localized + offerDetailObj.status
      //offerStatusLabel.isHidden = false
    } /*else {
      offerStatusLabel.text = "offers_screen_offer_status_text".localized + "Approved"
      //offerStatusLabel.isHidden = true
    }*/
    
    cancelButton.setTitle("offers_screen_cancel_button_text".localized, for: .normal)
    cancelMyOfferButton.setTitle("offers_screen_cancel_button_text".localized, for: .normal)
    editButton.setTitle("offers_screen_edit_button_text".localized, for: .normal)
    
    offerStatusLabel.textColor = UIColor.lightGray
    if offerDetailObj.awaitingApproval == "1" {
      deviderLabel1.isHidden = false
      deviderLabel2.isHidden = false
      cancelButton.isHidden = false
      editButton.isHidden = false
      cancelMyOfferButton.isHidden = true
      applyAttributeToStatus(text: offerDetailObj.status, color: UIColor.red)
    } else {
      //deviderLabel1.isHidden = true
      deviderLabel2.isHidden = true
      cancelButton.isHidden = true
      editButton.isHidden = true
      cancelMyOfferButton.isHidden = false
      
      //if offerDetailObj.status == "Open" {
        //offerStatusLabel.textColor = UIColor.greenTextColor
      applyAttributeToStatus(text: offerDetailObj.status, color: UIColor.greenTextColor)
      //}
    }
  }
  
  func getHeightOfCell(offerDetailObj: MTOffersDetailInfo)-> CGFloat {
    
    var cellHeight:CGFloat = 100.0
    //if offerDetailObj.awaitingApproval == "1" {
      cellHeight = 140.0
    //}
    return cellHeight
  }
  
  func applyAttributeToStatus(text: String, color: UIColor) {
    let attributedString1 = NSMutableAttributedString(string: offerStatusLabel.text!)
    let str1 = NSString(string: offerStatusLabel.text!)
    let range1 = str1.range(of: text)
    attributedString1.addAttribute(NSForegroundColorAttributeName, value: color , range: range1)
    attributedString1.addAttribute(NSFontAttributeName, value: UIFont(name: MTConstant.fontHMavenProRegular, size: 15.0)! , range: range1)
    offerStatusLabel.attributedText = attributedString1
  }
}
