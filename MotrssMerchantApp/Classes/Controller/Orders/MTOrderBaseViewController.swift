/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTOrderBaseViewController.swift
 
 Description: This class is used to base class for the orders history.
 
 Created By: Pranay.
 
 Creation Date: 22/05/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import Foundation
import RealmSwift

class MTOrderBaseViewController: MTBaseViewController {
  
  @IBOutlet weak var timeslotPref1Button: UIButton!
  @IBOutlet weak var timeslotPref2Button: UIButton!
  @IBOutlet weak var timeslotPref3Button: UIButton!
  
  var orderHistoryDataArray:[MTOrderDetailInfo] = []
  var declineOrderHistoryObj:MTOrderDetailInfo?
  var acceptOrderTimeslotPref = ""
  var acceptOrderTimeslotId = ""
		
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

extension MTOrderBaseViewController {

  func updateOrderStatusButtonOptions(declineOrderButton: UIButton, confirmOrderButton: UIButton, editOrderButton: UIButton, reviewOrderButton: UIButton, orderHistoryObj: MTOrderDetailInfo, row: Int) {
    
    reviewOrderButton.isEnabled = false
    reviewOrderButton.alpha = 0.0
    reviewOrderButton.setTitle("".localized, for: .normal)
    reviewOrderButton.isHidden = true
    
    if orderHistoryObj.orderStatus == "201" {
      declineOrderButton.isEnabled = true
      declineOrderButton.alpha = 1.0
      declineOrderButton.setTitle("service_status_decline_order_text".localized, for: .normal)
      declineOrderButton.addTarget(self, action: #selector(declineOrderButtonAction(_:)), for: .touchUpInside)
      declineOrderButton.tag = row
      
      confirmOrderButton.isEnabled = true
      confirmOrderButton.alpha = 1.0
      confirmOrderButton.setTitle("service_status_accept_order_text".localized, for: .normal)
      confirmOrderButton.addTarget(self, action: #selector(acceptOrderButtonAction(_:)), for: .touchUpInside)
      confirmOrderButton.tag = row
      
      editOrderButton.isEnabled = true
      editOrderButton.alpha = 1.0
      editOrderButton.setTitle("service_status_edit_order_text".localized, for: .normal)
      editOrderButton.addTarget(self, action: #selector(editOrderButtonAction(_:)), for: .touchUpInside)
      editOrderButton.tag = row
    } else if orderHistoryObj.orderStatus == "205" {
      declineOrderButton.isEnabled = false
      declineOrderButton.alpha = 0.5
      declineOrderButton.setTitle("service_status_decline_order_text".localized, for: .normal)
      
      confirmOrderButton.isEnabled = false
      confirmOrderButton.alpha = 0.5
      confirmOrderButton.setTitle("service_status_accept_order_text".localized, for: .normal)
      
      editOrderButton.isEnabled = false
      editOrderButton.alpha = 0.5
      editOrderButton.setTitle("service_status_update_status_text".localized, for: .normal)
    } else if orderHistoryObj.orderStatus == "301" {
      declineOrderButton.isEnabled = true
      declineOrderButton.alpha = 1.0
      declineOrderButton.setTitle("service_status_cancel_order_text".localized, for: .normal)
      declineOrderButton.addTarget(self, action: #selector(declineOrderButtonAction(_:)), for: .touchUpInside)
      declineOrderButton.tag = row
      
      confirmOrderButton.isEnabled = false
      confirmOrderButton.alpha = 0.5
      confirmOrderButton.setTitle("service_status_update_order_text".localized, for: .normal)
      
      editOrderButton.isEnabled = true
      editOrderButton.alpha = 1.0
      editOrderButton.setTitle("service_status_update_status_text".localized, for: .normal)
      editOrderButton.addTarget(self, action: #selector(updateStatusButtonAction(_:)), for: .touchUpInside)
      editOrderButton.tag = row
    } else if orderHistoryObj.orderStatus == "210" ||
        orderHistoryObj.orderStatus == "225" ||
        orderHistoryObj.orderStatus == "230" ||
        orderHistoryObj.orderStatus == "401" {
      declineOrderButton.isEnabled = true
      declineOrderButton.alpha = 1.0
      declineOrderButton.setTitle("service_status_cancel_order_text".localized, for: .normal)
      declineOrderButton.addTarget(self, action: #selector(declineOrderButtonAction(_:)), for: .touchUpInside)
      declineOrderButton.tag = row
      
      confirmOrderButton.isEnabled = true
      confirmOrderButton.alpha = 1.0
      confirmOrderButton.setTitle("service_status_update_order_text".localized, for: .normal)
      confirmOrderButton.addTarget(self, action: #selector(updateOrderButtonAction(_:)), for: .touchUpInside)
      confirmOrderButton.tag = row
      
      editOrderButton.isEnabled = true
      editOrderButton.alpha = 1.0
      editOrderButton.setTitle("service_status_update_status_text".localized, for: .normal)
      editOrderButton.addTarget(self, action: #selector(updateStatusButtonAction(_:)), for: .touchUpInside)
      editOrderButton.tag = row

    } else if orderHistoryObj.orderStatus == "235" ||
      orderHistoryObj.orderStatus == "240" ||
      orderHistoryObj.orderStatus == "245" ||
      orderHistoryObj.orderStatus == "250" ||
      orderHistoryObj.orderStatus == "405" {
      
      declineOrderButton.isEnabled = false
      declineOrderButton.alpha = 0.5
      declineOrderButton.setTitle("service_status_cancel_order_text".localized, for: .normal)
      
      confirmOrderButton.isEnabled = false
      confirmOrderButton.alpha = 0.5
      confirmOrderButton.setTitle("service_status_update_order_text".localized, for: .normal)
      
      editOrderButton.isEnabled = true
      editOrderButton.alpha = 1.0
      editOrderButton.setTitle("service_status_update_status_text".localized, for: .normal)
      editOrderButton.addTarget(self, action: #selector(updateStatusButtonAction(_:)), for: .touchUpInside)
      editOrderButton.tag = row

    } else if orderHistoryObj.orderStatus == "260" {
      
      declineOrderButton.isEnabled = false
      declineOrderButton.alpha = 0.0
      declineOrderButton.setTitle("".localized, for: .normal)
      
      confirmOrderButton.isEnabled = false
      confirmOrderButton.alpha = 0.0
      confirmOrderButton.setTitle("".localized, for: .normal)
      
      editOrderButton.isEnabled = false
      editOrderButton.alpha = 0.0
      editOrderButton.setTitle("".localized, for: .normal)
      
      reviewOrderButton.isHidden = false
      reviewOrderButton.isEnabled = true
      reviewOrderButton.alpha = 1.0
      reviewOrderButton.setTitle("myorder_review_feedback_title_text".localized, for: .normal)
      reviewOrderButton.addTarget(self, action: #selector(reviewMerchantFeedbackButtonAction(_:)), for: .touchUpInside)
      reviewOrderButton.tag = row
    } else {
      declineOrderButton.alpha = 0.0
      declineOrderButton.isEnabled = false
      declineOrderButton.setTitle("service_status_decline_order_text".localized, for: .normal)
      confirmOrderButton.isEnabled = false
      confirmOrderButton.alpha = 0.0
      confirmOrderButton.setTitle("service_status_accept_order_text".localized, for: .normal)
      editOrderButton.isEnabled = false
      editOrderButton.alpha = 0.0
      editOrderButton.setTitle("service_status_edit_order_text".localized, for: .normal)
    }
  }
  
  func updateBaseOrderHistoryList(statusCode: String) {
    //Override in subclass
    
  }
  
  func showOrderDeclineListView() {
    let views = Bundle.main.loadNibNamed("MTOrderDeclineSelectionView", owner: nil, options: nil)
    let view = views?[0] as! MTOrderDeclineSelectionView
    view.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
    view.delegate = self
    self.navigationController?.view.addSubview(view)
  }
}

extension MTOrderBaseViewController:MTOrderDeclineSelectionViewDelegate {
  
  func didSelectReason(selectedReason: String) {
    declineOrderService(orderID: (declineOrderHistoryObj?.orderId)!, statusCode: "206", declineReason: selectedReason)
  }
}

extension MTOrderBaseViewController {
  
  @IBAction func declineOrderButtonAction(_ sender: Any) {
    if let button = sender as? UIButton {
      declineOrderHistoryObj = orderHistoryDataArray[button.tag]
      
      //Show popup of decline reason
      showOrderDeclineListView()
      //declineOrderService(orderID: orderHistoryObj.orderId, statusCode: "206")
    }
  }
  
  @IBAction func acceptOrderButtonAction(_ sender: Any) {
    if let button = sender as? UIButton {
      let orderHistoryObj = orderHistoryDataArray[button.tag]
      if orderHistoryObj.orderId == acceptOrderTimeslotId && acceptOrderTimeslotPref.characters.count>0{
        showAcceptOrderConfirmationAlert(orderID: orderHistoryObj.orderId, statusCode: "205")
        //acceptOrderService(orderID: orderHistoryObj.orderId, statusCode: "205")
      } else {
        MTCommonUtils.showAlertViewWithTitle(title: "", message: "order_accept_empty_timeslot_alert_text".localized)
      }
    }
  }
  
  @IBAction func editOrderButtonAction(_ sender: Any) {
    if let button = sender as? UIButton {
      //let orderHistoryObj = orderHistoryDataArray[button.tag]
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "This is new requirement.")
    }
  }
  
  @IBAction func updateOrderButtonAction(_ sender: Any) {
    if let button = sender as? UIButton {
      //let orderHistoryObj = orderHistoryDataArray[button.tag]
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "This is new requirement.")
    }
  }
  
  @IBAction func updateStatusButtonAction(_ sender: Any) {
    if let button = sender as? UIButton {
      let orderHistoryObj = orderHistoryDataArray[button.tag]
      let orderStatusVC = MTCommonUtils.viewcontroller(storyboardName: "Main", viewcontrollerID: MTConstant.UpdateOrderStatusViewControllerIdentifier) as! MTUpdateOrderStatusViewController
      let realm = try! Realm()
      try! realm.write() {
        orderStatusVC.orderDetailInfo = MTOrderDetailInfo(value: orderHistoryObj)
      }
      self.navigationController?.pushViewController(orderStatusVC, animated: true)
    }
  }
  
  @IBAction func reviewMerchantFeedbackButtonAction(_ sender: Any) {
    if let button = sender as? UIButton {
      let orderHistoryObj = orderHistoryDataArray[button.tag]
      getMerchantReviewAndFeedback(orderID: orderHistoryObj.orderId)
    }
  }
  
  func showMerchantReviewPopView(reviewObjDetails: MTReviewRatingsInfo, orderID: String) {
    
    let views = Bundle.main.loadNibNamed("MTMerchantReviewPopupView", owner: nil, options: nil)
    let reviewView = views?[0] as! MTMerchantReviewPopupView
    reviewView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
    reviewView.reviewObjDetails = reviewObjDetails
    reviewView.orderID = orderID
    self.navigationController?.view.addSubview(reviewView)
  }
  
  func showAcceptOrderConfirmationAlert(orderID: String, statusCode: String) {
    
    var dateStr = ""
    let dateFormatter = DateFormatter()
    //dateFormatter.dateFormat = "yyyy-MM-dd"
    //let dateObj = dateFormatter.date(from: Date())
    //if let date = dateObj {
    dateFormatter.dateFormat = "dd-MMM-yy"
    dateStr = dateFormatter.string(from: Date())
    
    var timeSlot = ""
    //Covert AM/PM time to show
    let newDateFormatter = DateFormatter()
    newDateFormatter.dateFormat = "HH:mm:ss"
    if let date = newDateFormatter.date(from: acceptOrderTimeslotPref) {
      newDateFormatter.dateFormat = "h:mm a"
      timeSlot = newDateFormatter.string(from: date)
    }
    
    let message = "order_detail_accept_order_alert_text1".localized + "\n" + "order_detail_accept_order_alert_text2".localized + dateStr + "\n" + "order_detail_accept_order_alert_text3".localized + timeSlot
    
    let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
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
        self.acceptOrderService(orderID: orderID, statusCode: statusCode)
        
      case .cancel:
        MTLogger.log.info("cancel")
        
      case .destructive:
        MTLogger.log.info("destructive")
      }
    }))
    
    self.present(alert, animated: true, completion: nil)
  }

  func declineOrderService(orderID: String, statusCode: String, declineReason: String) {
    if MTRechabilityManager.sharedInstance.isRechable {
      MTProgressIndicator.sharedInstance.showProgressIndicator()
      
      MTOrderServiceManager.sharedInstance.updateOrderStatus(orderStatusCode: statusCode, userId: "", addIssuesText: "", orderId: orderID, addIssuesImages: "", serviceAddNotes: "", declineReason: declineReason, timeslotPref: "", onSuccess: { (success) -> Void in
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
        if (success as! Bool) {
          MTLogger.log.info("Declined Order => ")
          self.updateBaseOrderHistoryList(statusCode: statusCode)
          NotificationCenter.default.post(name: NSNotification.Name(rawValue: MTConstant.Notification_RefershNewOrder), object: nil)
        }
      }) { (failure) -> Void in
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
      }
    } else {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_no_internet".localized)
    }
  }
  
  func acceptOrderService(orderID: String, statusCode: String) {
    if MTRechabilityManager.sharedInstance.isRechable {
      MTProgressIndicator.sharedInstance.showProgressIndicator()
      
      MTOrderServiceManager.sharedInstance.updateOrderStatus(orderStatusCode: statusCode, userId: "", addIssuesText: "", orderId: orderID, addIssuesImages: "", serviceAddNotes: "", declineReason: "", timeslotPref: acceptOrderTimeslotPref, onSuccess: { (success) -> Void in
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
        if (success as! Bool) {
          MTLogger.log.info("Accepted Order => ")
          self.updateBaseOrderHistoryList(statusCode: statusCode)
          NotificationCenter.default.post(name: NSNotification.Name(rawValue: MTConstant.Notification_RefershNewOrder), object: nil)
        }
      }) { (failure) -> Void in
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
        MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_something_went_wrong".localized)
      }
    } else {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_no_internet".localized)
    }
  }
  
  func getMerchantReviewAndFeedback(orderID: String) {
    if MTRechabilityManager.sharedInstance.isRechable {
      MTProgressIndicator.sharedInstance.showProgressIndicator()
      
      MTOrderServiceManager.sharedInstance.getReviewAndFeednackForOrder(orderId: orderID, onSuccess: { (success) -> Void in
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
        if let object = success as? MTReviewRatingsInfo {
        //if (success as! Bool) {
          MTLogger.log.info("Review Order => \(object.heading)")
          self.showMerchantReviewPopView(reviewObjDetails: object, orderID: orderID)
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
