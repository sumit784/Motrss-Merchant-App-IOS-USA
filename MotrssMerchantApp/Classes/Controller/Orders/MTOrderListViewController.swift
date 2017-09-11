/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTOrderListViewController.swift
 
 Description: This class is used to show the orders history.
 
 Created By: Pranay.
 
 Creation Date: 22/05/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import Foundation
import RealmSwift

class MTOrderListViewController: MTOrderBaseViewController {
  
  @IBOutlet weak var orderTableview: UITableView!
  @IBOutlet weak var noOrdersTitleLabel: UILabel!

  var orderType = MTEnums.OrdersSelectedType.none
  var orderTypeString = MTEnums.OrderType.none
  
	var mainPageViewFrame:CGRect?  
		  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    orderTableview.separatorStyle = .none
    orderTableview.register(UINib.init(nibName: "MTMyOrdersTableViewCell", bundle: nil), forCellReuseIdentifier: "MyOrdersTableViewCellIdentifier")

    if orderType == .newOrders {
      orderTypeString = MTEnums.OrderType.newOrders
    } else if orderType == .orderStatus {
      orderTypeString = MTEnums.OrderType.orderStatus
    } else if orderType == .orderHistory {
      orderTypeString = MTEnums.OrderType.orderHistory
    }
    //getOrdersDataFromServer()
    updateOrderHistoryList()
    setLocalization()
    
    DispatchQueue.main.async {
      self.getMerchantOrdersData()
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
//  func getOrdersDataFromServer() {
//    if orderType == .newOrders {
//      getMerchantNewOrders()
//    } else if orderType == .orderStatus {
//
//    } else if orderType == .orderHistory {
//
//    }
//  }
  
  /// This function is used to update ht elogin screen UI
  func updateOrderHistoryList() {
    
    if orderType == .newOrders {
      let realm = try! Realm()
      let filterString = String(format: "orderType == '%@'", orderTypeString.rawValue)
      let orderHistoryInfo = realm.objects(MTOrderDetailInfo.self).filter(filterString)
      orderHistoryDataArray.removeAll()
      for orderHistory in orderHistoryInfo {
        if orderHistory.orderStatus == "201" {
          if orderHistory.orderStatus != "260" {
            orderHistoryDataArray.append(orderHistory)
          }
        }
      }
      orderHistoryDataArray.sort(by: {$0.orderDate > $1.orderDate})
      refreshTableData()
    } else if orderType == .orderStatus {
      let realm = try! Realm()
      let filterString = String(format: "orderType == '%@'", orderTypeString.rawValue)
      let orderHistoryInfo = realm.objects(MTOrderDetailInfo.self).filter(filterString)
      orderHistoryDataArray.removeAll()
      for orderHistory in orderHistoryInfo {
        if orderHistory.orderStatus != "201" {
          if orderHistory.orderStatus != "260" {
            orderHistoryDataArray.append(orderHistory)
          }
        }
      }
      orderHistoryDataArray.sort(by: {$0.orderDate > $1.orderDate})
      refreshTableData()
    } else if orderType == .orderHistory {
      let realm = try! Realm()
      let filterString = String(format: "orderType == '%@'", orderTypeString.rawValue)
      let orderHistoryInfo = realm.objects(MTOrderDetailInfo.self).filter(filterString)
      orderHistoryDataArray.removeAll()
      for orderHistory in orderHistoryInfo {
        if orderHistory.orderStatus == "260" {
          orderHistoryDataArray.append(orderHistory)
        }
      }
      orderHistoryDataArray.sort(by: {$0.orderDate > $1.orderDate})
      refreshTableData()
    }
  }
  
  func refreshTableData() {
    DispatchQueue.main.async {
      if self.orderHistoryDataArray.count>0 {
        if self.orderTableview != nil {
          self.orderTableview.isHidden = false
          self.orderTableview.reloadData()
        }
        if self.noOrdersTitleLabel != nil {
          self.noOrdersTitleLabel.isHidden = true
        }
      } else {
        if self.orderTableview != nil {
          self.orderTableview.isHidden = true
          self.orderTableview.reloadData()
        }
        if self.noOrdersTitleLabel != nil {
          self.noOrdersTitleLabel.isHidden = false
        }
      }
    }
  }
  
  /// This function is used to add the localization for the Login screen
  func setLocalization() {
    if orderType == .newOrders {
      noOrdersTitleLabel.text = "order_list_screen_no_new_order_title_text".localized
    } else if orderType == .orderStatus {
      noOrdersTitleLabel.text = "order_list_screen_no_order_status_title_text".localized
    } else if orderType == .orderHistory {
      noOrdersTitleLabel.text = "order_list_screen_no_order_history_title_text".localized
    }
  }
  
  override func updateBaseOrderHistoryList(statusCode: String) {    
    //overide base class
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: MTConstant.Notification_RefeshOrderStatus), object: nil)
  }
}

extension MTOrderListViewController : UITableViewDataSource {
  
//  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//    return 187
//  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let cell: MTMyOrdersTableViewCell = self.orderTableview.dequeueReusableCell(withIdentifier: "MyOrdersTableViewCellIdentifier") as! MTMyOrdersTableViewCell
    let orderHistoryObj = orderHistoryDataArray[indexPath.row]
    return cell.getHeightOfCell(orderHistoryObj: orderHistoryObj)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return orderHistoryDataArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell: MTMyOrdersTableViewCell = self.orderTableview.dequeueReusableCell(withIdentifier: "MyOrdersTableViewCellIdentifier") as! MTMyOrdersTableViewCell
    
    let orderHistoryObj = orderHistoryDataArray[indexPath.row]
    
    cell.updateCellData(orderHistoryObj: orderHistoryObj)
    cell.selectionStyle = .none
    cell.delegate = self
    //For Order Status Button
    //updateOrderStatusButtonOptions(cell: cell, orderHistoryObj: orderHistoryObj, row: indexPath.row)
    updateOrderStatusButtonOptions(declineOrderButton: cell.declineOrderButton, confirmOrderButton: cell.confirmOrderButton, editOrderButton: cell.editOrderButton, reviewOrderButton: cell.reviewFeedbackButton, orderHistoryObj: orderHistoryObj, row: indexPath.row)
    return cell
  }
}

extension MTOrderListViewController : UITableViewDelegate, MTMyOrdersTableViewCellDelegate {
  
  func didSelectTimeslotPreference(timeslot: String, forOrderID orderNo: String) {
    MTLogger.log.info("timeslot => \(timeslot)")
    MTLogger.log.info("orderNo => \(orderNo)")
    acceptOrderTimeslotId = orderNo
    acceptOrderTimeslotPref = timeslot
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let orderHistoryObj = orderHistoryDataArray[indexPath.row]
    let orderDetailsVC = MTCommonUtils.viewcontroller(storyboardName: "Main", viewcontrollerID: MTConstant.OrderDetailsViewControllerIdentifier) as! MTOrderDetailsViewController
    orderDetailsVC.orderType = self.orderType
    orderDetailsVC.orderTypeString = self.orderTypeString
    let realm = try! Realm()
    try! realm.write() {
      orderDetailsVC.orderHistoryDetailInfo = MTOrderDetailInfo(value: orderHistoryObj)
    }
    self.navigationController?.pushViewController(orderDetailsVC, animated: true)    
  }
}

extension MTOrderListViewController {
  
  func getMerchantOrdersData() {
    MTProgressIndicator.sharedInstance.showProgressIndicator()
    MTOrderServiceManager.sharedInstance.getMerchantOrders(orderType: orderTypeString.rawValue, onSuccess: { (success) -> Void in
      MTProgressIndicator.sharedInstance.hideProgressIndicator()
      if (success as! Bool) {
        self.updateOrderHistoryList()
      }
    }) { (failure) -> Void in
      MTProgressIndicator.sharedInstance.hideProgressIndicator()
    }
  }
  
  
}
