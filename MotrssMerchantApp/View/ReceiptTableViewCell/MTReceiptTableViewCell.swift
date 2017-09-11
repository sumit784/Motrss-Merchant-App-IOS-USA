//
//  ServicePackageDetailTableViewCell.swift
//  MotrssUserApp
//
//  Created by Pranay on 12/05/17.
//  Copyright © 2017 mobitronics. All rights reserved.
//

import UIKit

class MTReceiptTableViewCell: UITableViewCell {
  
  @IBOutlet weak var chargesNameLabel: UILabel!
  @IBOutlet weak var chargesPriceLabel: UILabel!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func updateCellData(dataModelObj : MTBookingReceiptDataModel) {
    chargesNameLabel.text = dataModelObj.itemName
    
//    if dataModelObj.itemValue == "" {
//      chargesPriceLabel.text = "currency_text".localized + "0.0"
//    } else {
//      chargesPriceLabel.text = "currency_text".localized + dataModelObj.itemValue
//    }
    
    if dataModelObj.itemValue == "" {
      chargesPriceLabel.text = "currency_text".localized + "0.0"
    } else if dataModelObj.itemName.contains("receipt_chart_discount_coupon_text".localized) {
      chargesPriceLabel.text = "-" + "currency_text".localized + dataModelObj.itemValue.roundStringTo(places: 2)
    } else {
      chargesPriceLabel.text = "currency_text".localized + dataModelObj.itemValue.roundStringTo(places: 2)
    }

    
    if dataModelObj.itemName.contains("receipt_chart_service_fees_running_text".localized) {
      let text = dataModelObj.itemName
      let attributedString = NSMutableAttributedString(string: text)
      let str = NSString(string: text)
      let range = str.range(of: "receipt_chart_service_fees_running_text".localized)
      attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGray , range: range)
      attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: MTConstant.fontHMavenProRegular, size: 10.0)! , range: range)
      chargesNameLabel.attributedText = attributedString
    }
  }  
}
