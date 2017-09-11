/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTTeamMemberTableViewCell.swift
 
 Description: This class is used to show order item in table view.
 
 Created By: Rohit W.
 
 Creation Date: 23/05/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import UIKit
import Kingfisher

class MTTeamMemberTableViewCell: UITableViewCell {
  
  @IBOutlet weak var bgView: UIView!
  @IBOutlet weak var teamMemberImageView: UIImageView!
  @IBOutlet weak var offerIDLabel: UILabel!
  @IBOutlet weak var offerCodeLabel: UILabel!
  @IBOutlet weak var offerTypeLabel: UILabel!
  
  @IBOutlet weak var deviderLabel1: UILabel!
  @IBOutlet weak var deviderLabel2: UILabel!
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var editButton: UIButton!
  
  @IBOutlet weak var deleteButton: UIButton!
  @IBOutlet weak var verifiedLabel: UILabel!
  @IBOutlet weak var verifiedImageView: UIImageView!
  @IBOutlet weak var ratingCountLabel: UILabel!
  @IBOutlet weak var ratingCountImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    bgView.layer.cornerRadius = 3.0
    bgView.layer.borderColor = UIColor.lightGray.cgColor
    bgView.layer.borderWidth = 1.0
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

  func updateCellData(offerDetailObj: MTTeamDetailInfo) {
    offerIDLabel.text = offerDetailObj.fullName
    offerCodeLabel.text = "team_member_list_id_text".localized + offerDetailObj.teamId
    offerTypeLabel.text = "team_member_list_contact_text".localized + offerDetailObj.mobile
    
    cancelButton.setTitle("offers_screen_cancel_button_text".localized, for: .normal)
    editButton.setTitle("offers_screen_edit_button_text".localized, for: .normal)
    
    verifiedLabel.text = "team_member_list_verified_text".localized
    ratingCountLabel.text = "4.0"
    
    if offerDetailObj.profileImage.characters.count>0 {
      MTCommonUtils.updateTeamMemberImageCache(imageUrl: offerDetailObj.profileImage, forImage: teamMemberImageView, placeholder: UIImage(named: "user_default_round_image"), contentMode: .scaleToFill)
      teamMemberImageView.contentMode = .scaleToFill
      teamMemberImageView.layer.cornerRadius = (teamMemberImageView.frame.size.height)/2
      teamMemberImageView.layer.masksToBounds = true
    }
    
    if offerDetailObj.awaitingApproval == "1" {
      deviderLabel1.isHidden = false
      deviderLabel2.isHidden = false
      cancelButton.isHidden = false
      editButton.isHidden = false
      
      deleteButton.isHidden = true
      verifiedLabel.isHidden = true
      verifiedImageView.isHidden = true
      ratingCountLabel.isHidden = true
      ratingCountImageView.isHidden = true
    } else {
      deviderLabel1.isHidden = true
      deviderLabel2.isHidden = true
      cancelButton.isHidden = true
      editButton.isHidden = true
      
      deleteButton.isHidden = false
      verifiedLabel.isHidden = false
      verifiedImageView.isHidden = false
      ratingCountLabel.isHidden = false
      ratingCountImageView.isHidden = false
    }
  }
  
  func getHeightOfCell(offerDetailObj: MTTeamDetailInfo)-> CGFloat {
    
    var cellHeight:CGFloat = 100.0
    if offerDetailObj.awaitingApproval == "1" {
      cellHeight = 140.0
    }
    return cellHeight
  }
}
