/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTOfferListViewControler
 
 Description: This class is used to show home offer screen for the application.
 
 Created By: Pranay.
 
 Creation Date: 20/07/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import UIKit
import RealmSwift

class MTOfferListViewControler: MTBaseViewController {
  
  @IBOutlet weak var offerTableview: UITableView!
  @IBOutlet weak var noOffersTitleLabel: UILabel!
  
  var offerType = MTEnums.OffersSelectedType.none
  var mainPageViewFrame:CGRect?
  var offerDetailDataArray:[MTOffersDetailInfo] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    offerTableview.separatorStyle = .none
    offerTableview.register(UINib.init(nibName: "MTOffersTableViewCell", bundle: nil), forCellReuseIdentifier: "OffersTableViewCellIdentifier")
    
    setLocalization()
    updatePageUI()
    //updateOfferList()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  deinit {
  }
  
  /// This function is used to update ht elogin screen UI
  func updatePageUI() {

  }
  
  func setLocalization() {
    if offerType == .myOffers {
      noOffersTitleLabel.text = "offers_screen_no_myoffer_text".localized
    } else if offerType == .awaitingForApproval {
      noOffersTitleLabel.text = "offers_screen_no_awaiting_offer_text".localized
    }
  }

  /// This function is used to update ht elogin screen UI
  func updateOfferList() {
    
    if offerType == .myOffers {
      let realm = try! Realm()
      let offersInfo = realm.objects(MTOffersDetailInfo.self)
      offerDetailDataArray.removeAll()
      for offer in offersInfo {
        if offer.awaitingApproval == "0" && offer.status.characters.count > 0 {
          offerDetailDataArray.append(offer)
        }
      }
      //offerDetailDataArray.sort(by: {$0.orderDate > $1.orderDate})
      refresTableData()
    } else if offerType == .awaitingForApproval {
      let realm = try! Realm()
      let offersInfo = realm.objects(MTOffersDetailInfo.self)
      offerDetailDataArray.removeAll()
      for offer in offersInfo {
        if offer.awaitingApproval == "1" && offer.status.characters.count > 0  {
          offerDetailDataArray.append(offer)
        }
      }
      //orderHistoryDataArray.sort(by: {$0.orderDate > $1.orderDate})
      refresTableData()
    }
  }
  
  func refresTableData() {
    DispatchQueue.main.async {
      if self.offerDetailDataArray.count>0 {
        if self.offerTableview != nil {
          self.offerTableview.isHidden = false
          self.offerTableview.reloadData()
        }
        if self.noOffersTitleLabel != nil {
          self.noOffersTitleLabel.isHidden = true
        }
      } else {
        if self.offerTableview != nil {
          self.offerTableview.isHidden = true
        }
        if self.noOffersTitleLabel != nil {
          self.noOffersTitleLabel.isHidden = false
        }
      }
    }
  }
}

extension MTOfferListViewControler {

}

extension MTOfferListViewControler : UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let cell: MTOffersTableViewCell = self.offerTableview.dequeueReusableCell(withIdentifier: "OffersTableViewCellIdentifier") as! MTOffersTableViewCell
    let offerObj = offerDetailDataArray[indexPath.row]
    return cell.getHeightOfCell(offerDetailObj: offerObj)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return offerDetailDataArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell: MTOffersTableViewCell = self.offerTableview.dequeueReusableCell(withIdentifier: "OffersTableViewCellIdentifier") as! MTOffersTableViewCell    
    let offerObj = offerDetailDataArray[indexPath.row]
    
    cell.updateCellData(offerDetailObj: offerObj)
    cell.selectionStyle = .none
    
    if offerObj.awaitingApproval == "1" {
      cell.cancelButton.tag = indexPath.row
      cell.cancelButton.addTarget(self, action: #selector(cancelOfferButtonAction(_:)), for: .touchUpInside)
      
      cell.editButton.tag = indexPath.row
      cell.editButton.addTarget(self, action: #selector(editOfferButtonAction(_:)), for: .touchUpInside)
    } else {
      cell.cancelMyOfferButton.tag = indexPath.row
      cell.cancelMyOfferButton.addTarget(self, action: #selector(cancelOfferButtonAction(_:)), for: .touchUpInside)
    }
    return cell
  }
}

extension MTOfferListViewControler : UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    /*let offerDetailObj = offerDetailDataArray[indexPath.row]
    let offerDetailsVC = MTCommonUtils.viewcontroller(storyboardName: "Main", viewcontrollerID: MTConstant.OfferDetailViewControlerID) as! MTOfferDetailViewControler
    let realm = try! Realm()
    try! realm.write() {
      offerDetailsVC.offerDetailObject = MTOffersDetailInfo(value: offerDetailObj)
    }
    self.navigationController?.pushViewController(offerDetailsVC, animated: true)*/
  }
}

extension MTOfferListViewControler {
  
  func showCancelConfirmationAlert(selectedOfferIndex: Int) {
    let alert = UIAlertController(title: "", message: "offers_cancel_confirmation_alert_text".localized, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "general_no_text".localized, style: UIAlertActionStyle.cancel, handler: { action in
      switch action.style{
      case .default:
        MTLogger.log.info("default")
      case .cancel:
        MTLogger.log.info("cancel")
      case .destructive:
        MTLogger.log.info("destructive")
      }
    }))
    alert.addAction(UIAlertAction(title: "general_yes_text".localized, style: UIAlertActionStyle.default, handler: { action in
      switch action.style{
      case .default:
        MTLogger.log.info("default")
        let offerObj = self.offerDetailDataArray[selectedOfferIndex]
        self.cancelMerchantOffer(offerID: offerObj.offerId)
        
      case .cancel:
        MTLogger.log.info("cancel")
      case .destructive:
        MTLogger.log.info("destructive")
      }
    }))
    
    self.present(alert, animated: true, completion: nil)
  }
  
  @IBAction func cancelOfferButtonAction(_ sender: Any) {
    if let button = sender as? UIButton {
      showCancelConfirmationAlert(selectedOfferIndex: button.tag)
      //let offerObj = offerDetailDataArray[button.tag]
      //cancelMerchantOffer(offerID: offerObj.offerId)
    }
  }
  
  @IBAction func editOfferButtonAction(_ sender: Any) {
    if let button = sender as? UIButton {
      let offerDetailObj = offerDetailDataArray[button.tag]
      let offerDetailsVC = MTCommonUtils.viewcontroller(storyboardName: "Main", viewcontrollerID: MTConstant.OfferDetailViewControlerID) as! MTOfferDetailViewControler
      let realm = try! Realm()
      try! realm.write() {
        offerDetailsVC.offerDetailObject = MTOffersDetailInfo(value: offerDetailObj)
      }
      self.navigationController?.pushViewController(offerDetailsVC, animated: true)
    }
  }
  
  func cancelMerchantOffer(offerID: String) {
    if MTRechabilityManager.sharedInstance.isRechable {
      MTProgressIndicator.sharedInstance.showProgressIndicator()
      
      MTOfferServiceManager.sharedInstance.deleteMerchantOffer(offerId: offerID, onSuccess: { (success) -> Void in
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
        if (success as! Bool) {
          MTLogger.log.info("cancelMerchantOffer => ")
          NotificationCenter.default.post(name: NSNotification.Name(rawValue: MTConstant.Notification_RefreshMErchantOffers), object: nil)
        }
      }) { (failure) -> Void in
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
        MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_something_went_wrong".localized)
      }
    } else {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_no_internet".localized)
    }
  }
}
