/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTReviewAndRatingViewControler.swift
 
 Description: This class is used to show rating screen for the application.
 
 Created By: Pranay.
 
 Creation Date: 8/08/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import UIKit
import RealmSwift

class MTReviewAndRatingViewControler: MTBaseViewController {
  
  @IBOutlet weak var reviewTableView: UITableView!
  @IBOutlet weak var noReviewLabel: UILabel!
  
  var reviewsDataArray:[MTReviewRatingsInfo] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    isShowBackButton = true
    
    reviewTableView.register(UINib.init(nibName: "MTMerchantReviewsTableViewCell", bundle: nil), forCellReuseIdentifier: "MerchantReviewsTableViewCellIdentifier")
    reviewTableView.rowHeight = UITableViewAutomaticDimension

    setLocalization()
    updatePageUI()
    getAllReviewAndRatingsData()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  deinit {
  }
  
  func updatePageUI() {
    let realm = try! Realm()
    let reviews = realm.objects(MTReviewRatingsInfo.self)
    reviewsDataArray.removeAll()
    for reviewObj in reviews {
      reviewsDataArray.append(reviewObj)
    }
    
    if reviewsDataArray.count>0 {
      reviewTableView.isHidden = false
      reviewTableView.reloadData()
      noReviewLabel.isHidden = true
    } else {
      reviewTableView.isHidden = true
      noReviewLabel.isHidden = false
    }
  }
  
  func setLocalization() {
    self.title = "review_screen_title_text".localized
    noReviewLabel.text = "review_screen_no_reviews_text".localized
  }
}

extension MTReviewAndRatingViewControler {
  
  @IBAction func getDetailButtonAction(_ sender: Any) {

  }
}

extension MTReviewAndRatingViewControler : UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let cell: MTMerchantReviewsTableViewCell = self.reviewTableView.dequeueReusableCell(withIdentifier: "MerchantReviewsTableViewCellIdentifier") as! MTMerchantReviewsTableViewCell
    let reviewObj = reviewsDataArray[indexPath.row]
    return cell.getHeightOfCell(reviewObj: reviewObj)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return reviewsDataArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell: MTMerchantReviewsTableViewCell = self.reviewTableView.dequeueReusableCell(withIdentifier: "MerchantReviewsTableViewCellIdentifier") as! MTMerchantReviewsTableViewCell
    
    let reviewObj = reviewsDataArray[indexPath.row]
    cell.updateCellData(reviewObj: reviewObj)
    
    cell.tag = indexPath.row
    cell.selectionStyle = .none
    
    return cell
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }
  
  func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }
}

extension MTReviewAndRatingViewControler : UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
}

extension MTReviewAndRatingViewControler {
  
  func getAllReviewAndRatingsData() {
    if MTRechabilityManager.sharedInstance.isRechable {
      MTProgressIndicator.sharedInstance.showProgressIndicator()
      MTProfileServiceManager.sharedInstance.getMerchantReviewAndRatings(successBlock: { (success) -> Void in
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
        if (success as! Bool) {
          MTLogger.log.info("Success=> ")
          self.updatePageUI()
        }
      }) { (failure) -> Void in
        MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_something_went_wrong".localized)
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
      }
    } else {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_no_internet".localized)
    }
  }
}
