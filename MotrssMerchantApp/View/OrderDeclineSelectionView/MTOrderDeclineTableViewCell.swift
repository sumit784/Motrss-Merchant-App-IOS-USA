/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTReferalCodeTableViewCell.swift
 
 Description: This class is used to show reviews in table view.
 
 Created By: Rohit W.
 
 Creation Date: 16/05/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import UIKit

class MTOrderDeclineTableViewCell: UITableViewCell {
  
  @IBOutlet weak var reasonLabel: UILabel!
  @IBOutlet weak var selectButton: UIButton!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

  func updateCellData() {
    
  }
}
