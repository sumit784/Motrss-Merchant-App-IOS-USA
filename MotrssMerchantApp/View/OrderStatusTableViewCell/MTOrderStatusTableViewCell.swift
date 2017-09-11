//
//  ServicePackageDetailTableViewCell.swift
//  MotrssUserApp
//
//  Created by Pranay on 12/05/17.
//  Copyright © 2017 mobitronics. All rights reserved.
//

import UIKit

class MTOrderStatusTableViewCell: UITableViewCell {
  
  @IBOutlet weak var orderUpdateTitleLabel: UILabel!
  @IBOutlet weak var orderUpdateButton: UIButton!
  
  @IBOutlet weak var issueDetailsTextView: UITextView!
  @IBOutlet weak var issueDeviderLable: UILabel!
  @IBOutlet weak var issueCaptureImageButton: UIButton!
  
  @IBOutlet weak var statusNotesTextView: UITextView!
  //var issuesImageDataArr:[UIImage]?
		
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
//  func updateCellData(dataModelObj : MTOrderStatusDataModel, issuesImageDataArr: [UIImage]) {
//    
//    if dataModelObj.itemStatus == "0999" {
//      orderUpdateButton.isHidden = true
//      orderUpdateTitleLabel.isHidden = true
//      
//      issueDetailsTextView.isHidden = false
//      issueDeviderLable.isHidden = false
//      issueCaptureImageButton.isHidden = false
//      issueCaptureImageButton.isEnabled = true
//
//      self.issuesImageDataArr = issuesImageDataArr
//      if self.issuesImageDataArr != nil && (self.issuesImageDataArr?.count)!>0 {
//        for (index, element) in (self.issuesImageDataArr?.enumerated())! {
//          let imgButton = UIButton(frame: CGRect(x: 0, y: 60, width: 80, height: 80))
//          imgButton.backgroundColor = UIColor.lightGray
//          imgButton.setImage(element, for: .normal)
//          imgButton.tag = index
//          imgButton.addTarget(self, action: #selector(uploadedIssueImageButtonAction(_:)), for: .touchUpInside)
//          self.addSubview(imgButton)
//        }
//      }
//    } else {
//      orderUpdateButton.isHidden = false
//      orderUpdateTitleLabel.isHidden = false
//      
//      issueDetailsTextView.isHidden = true
//      issueDeviderLable.isHidden = true
//      issueCaptureImageButton.isHidden = true
//      issueCaptureImageButton.isEnabled = false
//
//    }
//  }
  
  func getHeightOfCell(dataModelObj: MTOrderStatusDataModel, issuesImageDataArr: [UIImage], orderDetailInfo:MTOrderDetailInfo)-> CGFloat {
    var cellHeight:CGFloat = 60.0
    if dataModelObj.itemStatus == "0999" {
      if issuesImageDataArr.count <= 0 {
        cellHeight = 60.0
      } else if issuesImageDataArr.count>0 && issuesImageDataArr.count<=5  {
        cellHeight = 80.0 + 60.0
      } else if issuesImageDataArr.count>5 {
        cellHeight = 80.0 + 80.0 + 60.0
      }      
    } else if dataModelObj.itemStatus == "250" && orderDetailInfo.orderStatus == "245" {
      cellHeight = cellHeight + 60
    }
    
    return cellHeight
  }
  
//  @IBAction func uploadedIssueImageButtonAction(_ sender: Any) {
//    if let button = sender as? UIButton {
//      if let imgArr = issuesImageDataArr {
//        if imgArr.count>0 {
//          let image = imgArr[button.tag]
//          
//        }
//      }
//      
//    }
//  }
}
