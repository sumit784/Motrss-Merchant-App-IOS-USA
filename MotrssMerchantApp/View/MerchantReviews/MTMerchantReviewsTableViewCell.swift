/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTMerchantReviewsTableViewCell.swift
 
 Description: This class is used to show reviews in table view.
 
 Created By: Pranay W.
 
 Creation Date: 16/08/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import UIKit

class MTMerchantReviewsTableViewCell: UITableViewCell {
  
  @IBOutlet weak var orderIDTitleLabel: UILabel!
  @IBOutlet weak var reviewTitleLabel: UILabel!
  @IBOutlet weak var commentDescLabel: UILabel!
  @IBOutlet weak var userNameLAbel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var verifiedUserLabel: UILabel!
  @IBOutlet weak var verifiedUSerImageView: UIImageView!
  
  @IBOutlet weak var ratingLable: UILabel!
  
  @IBOutlet weak var ratingImageView1: UIImageView!
  @IBOutlet weak var ratingImageView2: UIImageView!
  @IBOutlet weak var ratingImageView3: UIImageView!
  @IBOutlet weak var ratingImageView4: UIImageView!
  @IBOutlet weak var ratingImageView5: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

  func updateCellData(reviewObj: MTReviewRatingsInfo) {
    
    userNameLAbel.text = reviewObj.userName
    
    //dateLabel.text = reviewObj.addedDate
    if reviewObj.addedDate.characters.count>0 {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
      if let date = dateFormatter.date(from: reviewObj.addedDate) {
        dateFormatter.dateFormat = "MMM dd,yyyy h:mm a"
        let date24 = dateFormatter.string(from: date)
        dateLabel.text = date24
      } else {
        dateLabel.text = ""
      }
    } else {
      dateLabel.text = ""
    }
    ratingLable.text = reviewObj.rating
    
    commentDescLabel.text = reviewObj.custReview
    /*if reviewObj.custReview.characters.count>23 {
      var reviewTitle = reviewObj.custReview
      let startIndex = reviewTitle.index(reviewTitle.startIndex, offsetBy: 23)
      reviewTitle = reviewTitle.substring(to: startIndex)
      reviewTitleLabel.text = reviewTitle + "..."
    } else {
      reviewTitleLabel.text = reviewObj.custReview
    }*/
    reviewTitleLabel.text = reviewObj.heading
    orderIDTitleLabel.text = "review_screen_order_id_text".localized + reviewObj.orderId
    
    //verifiedUserLabel.isHidden = true
    //verifiedUSerImageView.isHidden = true
    
    MTCommonUtils.updateRatings(rating: reviewObj.rating, withImages: ratingImageView1, imgView2: ratingImageView2, imgView3: ratingImageView3, imgView4: ratingImageView4, imgView5: ratingImageView5, isWhiteEmptyImg: false)
  }
  
  func getHeightOfCell(reviewObj: MTReviewRatingsInfo)-> CGFloat {
    
    let cellHeight:CGFloat = 160.0
    let labelHeight:CGFloat = 30.0
    
    let size:CGRect = reviewObj.custReview.boundingRect(with: CGSize.init(width: commentDescLabel.frame.size.width, height: 2000.0), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:commentDescLabel.font], context: nil)
    let newHeight = ceil(size.height)
    if newHeight > labelHeight  {
      return ((cellHeight - labelHeight) + newHeight)
    } else {
      return cellHeight
    }
  }
}
