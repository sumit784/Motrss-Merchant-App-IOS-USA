/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTSideMenuTableView.swift
 
 Description: This class is used to show the side menu itmes.
 
 Created By: Rohit W.
 
 Creation Date: 22/04/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import UIKit

class MTSideMenuTableView: UITableViewCell {
  
  @IBOutlet weak var subItemImageView: UIImageView!
  @IBOutlet weak var subItemTitleLable: UILabel!
  @IBOutlet weak var notificationSettingSwitch: UISwitch!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
}
