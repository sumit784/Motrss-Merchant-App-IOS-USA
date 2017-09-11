/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTOrderDetailsViewController.swift
 
 Description: This class is used to show the orders history details.
 
 Created By: Pranay.
 
 Creation Date: 22/05/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import Foundation
import RealmSwift

class MTOrderDetailsViewController: MTOrderBaseViewController {
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var contentView: UIView!
  
  @IBOutlet weak var bottomButtonView: UIView!
  @IBOutlet weak var declineOrderButton: UIButton!
  @IBOutlet weak var editOrderButton: UIButton!
  @IBOutlet weak var confirmOrderButton: UIButton!
  @IBOutlet weak var reviewOrderButton: UIButton!
  
  //Order Status
  @IBOutlet weak var orderStatusView: UIView!
  @IBOutlet weak var orderStatusTitleLable: UILabel!
  @IBOutlet weak var orderStatusDetailLable: UILabel!

  @IBOutlet weak var orderView: UIView!
  @IBOutlet weak var orderNumberLable: UILabel!
  //@IBOutlet weak var orderStatusTitleLable: UILabel!
  @IBOutlet weak var orderStatusLable: UILabel!
  @IBOutlet weak var aptDateTitleLable: UILabel!
  @IBOutlet weak var aptDateLable: UILabel!
  @IBOutlet weak var aptTimeTitleLable: UILabel!
  @IBOutlet weak var vehicleTitleLable: UILabel!
  @IBOutlet weak var vehicleLable: UILabel!
  @IBOutlet weak var vehicleNoTitleLable: UILabel!
  @IBOutlet weak var vehicleNoLable: UILabel!

  //Merchant Details
  @IBOutlet weak var userDetailView: UIView!
  @IBOutlet weak var userTitleLable: UILabel!
  @IBOutlet weak var userNameLable: UILabel!
  @IBOutlet weak var verifiedByTitleLable: UILabel!
  @IBOutlet weak var userContactTitleLable: UILabel!
  @IBOutlet weak var userContactLable: UILabel!
  @IBOutlet weak var userPickupAddressTitleLable: UILabel!
  @IBOutlet weak var userPickupAddressLable: UILabel!
  @IBOutlet weak var userDropOffAddressTitleLable: UILabel!
  @IBOutlet weak var userPickupAddressImageview: UIImageView!
  @IBOutlet weak var userDropOffAddressLable: UILabel!
  @IBOutlet weak var userDropOffAddressImageview: UIImageView!
  @IBOutlet weak var serviceArraoImageView: UIImageView!
  @IBOutlet weak var userPickupAddressDeviderLabel: UILabel!  
  @IBOutlet weak var userDropAdressDeviderLabel: UILabel!
  
  //Charge Details
  @IBOutlet weak var chargeDetailTitleLabel: UILabel!
  @IBOutlet weak var serviceButton: UIButton!
  @IBOutlet weak var servicesTableview: UITableView!
  @IBOutlet weak var amountTableview: UITableView!
  @IBOutlet weak var serviceDetailView: UIView!
  
  var orderType = MTEnums.OrdersSelectedType.none
  var orderTypeString = MTEnums.OrderType.none
  
	var mainPageViewFrame:CGRect?
  var servicesDataArray:[MTBookingReceiptDataModel] = []
  var amountDataArray:[MTBookingReceiptDataModel] = []
  
  var orderHistoryDetailInfo:MTOrderDetailInfo!  
  var isShowingServices = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    isShowBackButton = true
    
    let screenSize: CGRect = UIScreen.main.bounds
    self.scrollView.frame = CGRect(x:0, y:0, width:screenSize.width, height:screenSize.height)
    let height = amountTableview.frame.origin.y + amountTableview.frame.size.height
    self.scrollView.contentSize = CGSize(width:self.scrollView.frame.width, height:height)
    self.scrollView.delegate = self
    contentView.frame = CGRect(x:0, y:0, width:screenSize.width, height:height)
    
    declineOrderButton.layer.cornerRadius = declineOrderButton.frame.size.height/2
    declineOrderButton.layer.borderColor = UIColor.appThemeColor.cgColor
    declineOrderButton.layer.borderWidth = 1.0
    confirmOrderButton.layer.cornerRadius = confirmOrderButton.frame.size.height/2
    confirmOrderButton.layer.borderColor = UIColor.appThemeColor.cgColor
    confirmOrderButton.layer.borderWidth = 1.0
    editOrderButton.layer.cornerRadius = confirmOrderButton.frame.size.height/2
    editOrderButton.layer.borderColor = UIColor.appThemeColor.cgColor
    editOrderButton.layer.borderWidth = 1.0
    reviewOrderButton.layer.cornerRadius = confirmOrderButton.frame.size.height/2
    reviewOrderButton.layer.borderColor = UIColor.appThemeColor.cgColor
    reviewOrderButton.layer.borderWidth = 1.0
    
    timeslotPref1Button.layer.cornerRadius = 3.0
    timeslotPref1Button.layer.borderColor = UIColor.appThemeColor.cgColor
    timeslotPref1Button.layer.borderWidth = 1.0
    timeslotPref2Button.layer.cornerRadius = 3.0
    timeslotPref2Button.layer.borderColor = UIColor.appThemeColor.cgColor
    timeslotPref2Button.layer.borderWidth = 1.0
    timeslotPref3Button.layer.cornerRadius = 3.0
    timeslotPref3Button.layer.borderColor = UIColor.appThemeColor.cgColor
    timeslotPref3Button.layer.borderWidth = 1.0
    /*cancelOrderButton.isEnabled = false
    cancelOrderButton.alpha = 0.6
    confirmOrderButton.isEnabled = false
    confirmOrderButton.alpha = 0.6*/
    
    servicesTableview.register(UINib.init(nibName: "MTReceiptTableViewCell", bundle: nil), forCellReuseIdentifier: "ReceiptTableViewCellIdentifier")
    amountTableview.register(UINib.init(nibName: "MTReceiptTableViewCell", bundle: nil), forCellReuseIdentifier: "ReceiptTableViewCellIdentifier")

    updateHistoryDetails()
    setLocalization()
    
    orderHistoryDataArray.append(orderHistoryDetailInfo)
    updateOrderStatusButtonOptions(declineOrderButton: declineOrderButton, confirmOrderButton: confirmOrderButton, editOrderButton: editOrderButton, reviewOrderButton: reviewOrderButton, orderHistoryObj: orderHistoryDetailInfo, row: 0)
    
    //if orderHistoryDetailInfo.orderStatus == "260" {
    //  bottomButtonView.isHidden = true
    //}
    //getProductItemPricesForSelectedMerchant()
    
    if self.orderType == .orderHistory {
      getMerchantOrderHistoryDetailsData()
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func updateBaseOrderHistoryList(statusCode: String) {
    
    let realm = try! Realm()
    try! realm.write {
      self.orderHistoryDetailInfo?.orderStatus = statusCode
    }
    updateOrderStatusButtonOptions(declineOrderButton: declineOrderButton, confirmOrderButton: confirmOrderButton, editOrderButton: editOrderButton, reviewOrderButton: reviewOrderButton, orderHistoryObj: orderHistoryDetailInfo, row: 0)
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: MTConstant.Notification_RefeshOrderStatus), object: nil)
    if statusCode == "260" {
      self.navigationController?.popToRootViewController(animated: true)
    }
  }
  
  /// This function is used to update ht elogin screen UI
  func updateHistoryDetails() {
    //Order Details
    orderView.layer.cornerRadius = 3.0
    orderView.layer.borderColor = UIColor.selectedBorderColor.cgColor
    orderView.layer.borderWidth = 1.0
    
    orderNumberLable.text = "myorder_order_no_title_text".localized + orderHistoryDetailInfo.orderId
    //orderStatusTitleLable.text = "order_detail_status_title_text".localized
    aptDateTitleLable.text = "order_detail_apt_date_title_text".localized
    vehicleTitleLable.text = "order_detail_vehicle_title_text".localized
    vehicleNoTitleLable.text = "order_detail_vehicle_number_title_text".localized
    
    /*let statusText = "order_detail_status_title_text".localized + MTCommonUtils.getShortOrderStatusDetails(orderStatusCode: orderHistoryDetailInfo.orderStatus)
    orderStatusLable.text = statusText
    let attributedString1 = NSMutableAttributedString(string: statusText)
    let str1 = NSString(string: statusText)
    let range1 = str1.range(of: "order_detail_status_title_text".localized)
    attributedString1.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGray , range: range1)
    attributedString1.addAttribute(NSFontAttributeName, value: UIFont(name: MTConstant.fontHMavenProRegular, size: 13.0)! , range: range1)
    orderStatusLable.attributedText = attributedString1*/
    orderStatusLable.isHidden = true
    orderStatusView.layer.cornerRadius = 3.0
    orderStatusView.layer.borderColor = UIColor.selectedBorderColor.cgColor
    orderStatusView.layer.borderWidth = 1.0
    orderStatusTitleLable.text = "order_detail_update_title_text".localized
    orderStatusDetailLable.text = MTCommonUtils.getOrderStatusDetails(orderStatusCode: orderHistoryDetailInfo.orderStatus)
      
    aptDateLable.text = ""
    if orderHistoryDetailInfo.orderDate.characters.count>0 {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd"
      let date = dateFormatter.date(from: (orderHistoryDetailInfo.orderDate))
      
      dateFormatter.dateFormat = "dd-MMM-yyyy"
      let date24 = dateFormatter.string(from: date!)
      aptDateLable.text = date24
    }
    //Apt Time
    aptTimeTitleLable.text = "order_detail_apt_time_title_text".localized
    //Time
    if orderHistoryDetailInfo.timePreference1.characters.count>0 {
      //Covert AM/PM time to show
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "HH:mm:ss"
      if let date = dateFormatter.date(from: orderHistoryDetailInfo.timePreference1) {
        dateFormatter.dateFormat = "h:mm a"
        let date24 = dateFormatter.string(from: date)
        timeslotPref1Button.setTitle(date24, for: .normal)
        timeslotPref1Button.isHidden = false
      } else {
        timeslotPref1Button.setTitle("", for: .normal)
        timeslotPref1Button.isHidden = true
      }
    } else {
      timeslotPref1Button.setTitle("", for: .normal)
      timeslotPref1Button.isHidden = true
    }
    if orderHistoryDetailInfo.timePreference2.characters.count>0 {
      //Covert AM/PM time to show
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "HH:mm:ss"
      if let date = dateFormatter.date(from: orderHistoryDetailInfo.timePreference2) {
        
        dateFormatter.dateFormat = "h:mm a"
        let date24 = dateFormatter.string(from: date)
        timeslotPref2Button.setTitle(date24, for: .normal)
        timeslotPref2Button.isHidden = false
      } else {
        timeslotPref2Button.setTitle("", for: .normal)
        timeslotPref2Button.isHidden = true
      }
    } else {
      timeslotPref2Button.setTitle("", for: .normal)
      timeslotPref2Button.isHidden = true
    }
    if orderHistoryDetailInfo.timePreference3.characters.count>0 {
      //Covert AM/PM time to show
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "HH:mm:ss"
      if let date = dateFormatter.date(from: orderHistoryDetailInfo.timePreference3) {
        
        dateFormatter.dateFormat = "h:mm a"
        let date24 = dateFormatter.string(from: date)
        timeslotPref3Button.setTitle(date24, for: .normal)
        timeslotPref3Button.isHidden = false
      } else {
        timeslotPref3Button.setTitle("", for: .normal)
        timeslotPref3Button.isHidden = true
      }
    } else {
      timeslotPref3Button.setTitle("", for: .normal)
      timeslotPref3Button.isHidden = true
    }
    
    vehicleLable.text = orderHistoryDetailInfo.vehicleCompanyName + " " + orderHistoryDetailInfo.vehicleModelName
    vehicleNoLable.text = orderHistoryDetailInfo.vehicleState + "-" + orderHistoryDetailInfo.vehicleNumber
    
    //USer Details
    userDetailView.layer.cornerRadius = 3.0
    userDetailView.layer.borderColor = UIColor.selectedBorderColor.cgColor
    userDetailView.layer.borderWidth = 1.0
    
    userTitleLable.text = "order_detail_user_detail_title_text".localized
    userNameLable.text = orderHistoryDetailInfo.userName
    userContactTitleLable.text = "order_detail_contact_number_title_text".localized
    userContactLable.text = orderHistoryDetailInfo.contactMobile
    
    userPickupAddressTitleLable.text = "order_detail_pickup_address_title_text".localized
    userPickupAddressLable.text = orderHistoryDetailInfo.pickAddress
    userDropOffAddressTitleLable.text = "order_detail_dropoff_address_title_text".localized
    userDropOffAddressLable.text = orderHistoryDetailInfo.dropAddress
    
    verifiedByTitleLable.text = "order_detail_merchant_verified_title_text".localized
    
    //Charge Details
    chargeDetailTitleLabel.text = "order_detail_charge_details_title_text".localized
    serviceButton.setTitle("order_detail_service_title_text".localized, for: .normal)
    serviceDetailView.layer.cornerRadius = 3.0
    serviceDetailView.layer.borderColor = UIColor.selectedBorderColor.cgColor
    serviceDetailView.layer.borderWidth = 1.0

    servicesTableview.layer.cornerRadius = 3.0
    servicesTableview.layer.borderColor = UIColor.selectedBorderColor.cgColor
    servicesTableview.layer.borderWidth = 1.0
    
    amountTableview.layer.cornerRadius = 3.0
    amountTableview.layer.borderColor = UIColor.selectedBorderColor.cgColor
    amountTableview.layer.borderWidth = 1.0
    
    updateServicesProductData()
    
//    for productItem in orderHistoryDetailInfo.orderHistoryProducts {
//      if !isProductCatPresent(dataModel: productItem) {
//        let itemObj = MTBookingReceiptDataModel()
//        itemObj.itemName = productItem.catName + " -> " + productItem.subCatName
//        itemObj.itemCatID = productItem.catId
//        itemObj.isCategory = true
//        servicesDataArray.append(itemObj)
//      }
//      let itemObj = MTBookingReceiptDataModel()
//      itemObj.itemName = productItem.productName
//      itemObj.itemValue = productItem.productPrice
//      servicesDataArray.append(itemObj)
//    }
    
    //for product in orderHistoryDetailInfo.orderHistoryProducts {
    //  servicesDataArray.append(product)
    //}
    
    amountDataArray.removeAll()
    let amount1 = MTBookingReceiptDataModel()
    amount1.itemName = "order_detail_total_amount_title_text".localized
    //amount1.itemValue = orderHistoryDetailInfo.orderFinalAmount
    if let value1 = Double (orderHistoryDetailInfo.orderFinalAmount) {
      //if let value2 = Double (orderHistoryDetailInfo.orderTaxAmount) {
      //  amount1.itemValue = "\(value1 + value2)"
      //} else {
        let strValue = "\(value1)"
        amount1.itemValue = strValue.roundStringTo(places: 2)
      //}
    }
    amountDataArray.append(amount1)
    /*let amount2 = MTBookingReceiptDataModel()
    amount2.itemName = "order_detail_paid_amount_title_text".localized
    amount2.itemValue = orderHistoryDetailInfo.orderBookingAmount
    amountDataArray.append(amount2)
    let amount3 = MTBookingReceiptDataModel()
    amount3.itemName = "order_detail_balance_amount_title_text".localized
    amount3.itemValue = orderHistoryDetailInfo.orderBalanceAmount
    amountDataArray.append(amount3)*/
    amountTableview.reloadData()
    
    updateServicesAndAmountView()
  }
  
  func isProductCatPresent(dataModel: MTOrderProductInfo) -> Bool {
    var retVal = false
    for productItem in servicesDataArray {
      if productItem.itemCatID == dataModel.catId {
        retVal = true
        break
      }
    }
    return retVal
  }
  
  func updateServicesProductData() {
    servicesDataArray.removeAll()
    
    //let realm = try! Realm()
    //let productInfo = realm.objects(MTSelectedMerchantProductInfo.self)
    //for productItem in productInfo {
    for productItem in orderHistoryDetailInfo.orderHistoryProducts {
      if !isProductCatPresent(dataModel: productItem) {
        let itemObj = MTBookingReceiptDataModel()
        itemObj.itemName = productItem.catName + " -> " + productItem.subCatName
        itemObj.itemCatID = productItem.catId
        itemObj.isCategory = true
        servicesDataArray.append(itemObj)
      }
      let itemObj = MTBookingReceiptDataModel()
      itemObj.itemName = productItem.productName
      itemObj.itemValue = productItem.productPrice
      servicesDataArray.append(itemObj)
    }
    
    //Pick Drop
    let itemObj2 = MTBookingReceiptDataModel()
    itemObj2.itemName = "receipt_chart_pickdrop_amount_text".localized
    itemObj2.itemValue = "\(orderHistoryDetailInfo.orderPickupDropFees)"
    servicesDataArray.append(itemObj2)
    
    //Discount
    let itemObj3 = MTBookingReceiptDataModel()
    var dicountStr = "receipt_chart_discount_coupon_text".localized
    if orderHistoryDetailInfo.offerCode.characters.count>0 {
      dicountStr = dicountStr + " (" + orderHistoryDetailInfo.offerCode + ")"
    }
    itemObj3.itemName = dicountStr
    itemObj3.itemValue = "\(orderHistoryDetailInfo.orderDiscountAmount)"
    servicesDataArray.append(itemObj3)
    
    //Service Fee
    let itemObj4 = MTBookingReceiptDataModel()
    itemObj4.itemName = "receipt_chart_service_fees_text".localized
    itemObj4.itemValue = "\(orderHistoryDetailInfo.orderServiceFees)"
    servicesDataArray.append(itemObj4)
    
    //Net Amount/Sub Total
    let itemObj1 = MTBookingReceiptDataModel()
    itemObj1.itemName = "receipt_chart_net_amount_text".localized
    itemObj1.itemValue = "\(orderHistoryDetailInfo.orderSubTotal)"
    servicesDataArray.append(itemObj1)
    
    //Tax amount
    let itemObj6 = MTBookingReceiptDataModel()
    itemObj6.itemName = "receipt_chart_taxes_detail_amount_text1".localized
    itemObj6.itemValue = "\(orderHistoryDetailInfo.orderTaxAmount)"
    servicesDataArray.append(itemObj6)
    
    servicesTableview.reloadData()
  }
  
  func updateServicesAndAmountView() {
    UIView.animate(withDuration: 0.2, animations: {
      //self.servicesTableview.isHidden = false
      
      self.updatePickupDropAddress()
      
      var serviceCount = 0
      if self.isShowingServices {
        serviceCount = self.servicesDataArray.count
        self.serviceArraoImageView.rotate(CGFloat(Double.pi / 2))
      } else {
        self.serviceArraoImageView.rotate(0.0)
      }
      let tableHeight:CGFloat = CGFloat(serviceCount * 35)
      //self.servicesTableview.frame = CGRect(x: self.servicesTableview.frame.origin.x, y: self.servicesTableview.frame.origin.y, width: self.servicesTableview.frame.size.width, height: tableHeight)
      self.chargeDetailTitleLabel.frame = CGRect(x: self.chargeDetailTitleLabel.frame.origin.x, y: self.userDetailView.frame.origin.y + self.userDetailView.frame.size.height + 10, width: self.chargeDetailTitleLabel.frame.size.width, height: self.chargeDetailTitleLabel.frame.size.height)

      self.serviceDetailView.frame = CGRect(x: self.serviceDetailView.frame.origin.x, y: self.chargeDetailTitleLabel.frame.origin.y + self.chargeDetailTitleLabel.frame.size.height + 5, width: self.serviceDetailView.frame.size.width, height: self.serviceDetailView.frame.size.height)

      self.servicesTableview.frame = CGRect(x: self.servicesTableview.frame.origin.x, y: self.serviceDetailView.frame.origin.y + self.serviceDetailView.frame.size.height + 5, width: self.servicesTableview.frame.size.width, height: tableHeight)
      
      self.amountTableview.frame = CGRect(x: self.amountTableview.frame.origin.x, y: self.servicesTableview.frame.origin.y + self.servicesTableview.frame.size.height + 10, width: self.amountTableview.frame.size.width, height: CGFloat(self.amountDataArray.count*35))
      
      let height = self.amountTableview.frame.origin.y + self.amountTableview.frame.size.height + 150
      self.scrollView.contentSize = CGSize(width:self.scrollView.frame.width, height:height)
      self.contentView.frame = CGRect(x:0, y:0, width:self.scrollView.frame.size.width, height:height)
    })
  }
  
  func updatePickupDropAddress() {
    if let detailObject = orderHistoryDetailInfo {
      if detailObject.orderPickDropOption == "Pk_dp_none" {
        //Hide Pickup and Drop Address
        
        userDetailView.frame = CGRect(x: userDetailView.frame.origin.x, y: userDetailView.frame.origin.y, width: userDetailView.frame.size.width, height: 62)
        userPickupAddressTitleLable.isHidden = true
        userPickupAddressLable.isHidden = true
        userPickupAddressImageview.isHidden = true
        userPickupAddressDeviderLabel.isHidden = true
        
        userDropOffAddressTitleLable.isHidden = true
        userDropOffAddressLable.isHidden = true
        userDropOffAddressImageview.isHidden = true
        userDropAdressDeviderLabel.isHidden = true
        
      } else if detailObject.orderPickDropOption == "Pk_dp_both" {
        //Show Pickup and Drop Address
      } else if detailObject.orderPickDropOption == "pickup" {
        //Hide Drop Address
        userDetailView.frame = CGRect(x: userDetailView.frame.origin.x, y: userDetailView.frame.origin.y, width: userDetailView.frame.size.width, height: 130)
        userDropOffAddressTitleLable.isHidden = true
        userDropOffAddressLable.isHidden = true
        userDropOffAddressImageview.isHidden = true
        userDropAdressDeviderLabel.isHidden = true

      } else if detailObject.orderPickDropOption == "drop" {
        //Hide Pickup Address
        userDetailView.frame = CGRect(x: userDetailView.frame.origin.x, y: userDetailView.frame.origin.y, width: userDetailView.frame.size.width, height: 130)
        userPickupAddressTitleLable.isHidden = true
        userPickupAddressLable.isHidden = true
        userPickupAddressImageview.isHidden = true
        userPickupAddressDeviderLabel.isHidden = true
        
        userDropOffAddressTitleLable.frame = userPickupAddressTitleLable.frame
        userDropOffAddressLable.frame = userPickupAddressLable.frame
        userDropOffAddressImageview.frame = userPickupAddressImageview.frame
        userDropAdressDeviderLabel.frame = userPickupAddressDeviderLabel.frame
      }
    }
  }
  /// This function is used to add the localization for the Login screen
  func setLocalization() {
    self.title = "order_detail_screen_title_text".localized
  }
}

extension MTOrderDetailsViewController : UITableViewDataSource {
  
//  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//    if tableView == servicesTableview {
//      return 35
//    } else if tableView == amountTableview {
//      return 35
//    } else if tableView == timeLineTableview {
//      return 300
//    }
//    return 0
//  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if tableView == servicesTableview {
      return servicesDataArray.count
    } else if tableView == amountTableview {
      return amountDataArray.count
    }
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiptTableViewCellIdentifier") as! MTReceiptTableViewCell
    
    if tableView == servicesTableview {
      let productInfoObj = servicesDataArray[indexPath.row]
      cell.updateCellData(dataModelObj: productInfoObj)
      /*cell.chargesNameLabel.text = productInfoObj.itemName
      if productInfoObj.itemValue == "" {
        cell.chargesPriceLabel.text = "currency_text".localized + "0.0"
      } else {
        cell.chargesPriceLabel.text = "currency_text".localized + productInfoObj.itemValue
      }*/
      if productInfoObj.isCategory {
        cell.chargesNameLabel.textColor = UIColor.appThemeColor
        cell.chargesPriceLabel.isHidden = true
      } else {
        cell.chargesNameLabel.textColor = UIColor.black
        cell.chargesPriceLabel.isHidden = false
      }
    } else {
      let productInfoObj = amountDataArray[indexPath.row]
      cell.chargesNameLabel.text = productInfoObj.itemName
      
      if productInfoObj.itemValue == "" {
        cell.chargesPriceLabel.text = "currency_text".localized + "0.0"
      } else {
        cell.chargesPriceLabel.text = "currency_text".localized + productInfoObj.itemValue
      }
      if productInfoObj.itemName == "order_detail_total_amount_title_text".localized {
        cell.chargesNameLabel.textColor = UIColor.appThemeColor
        cell.chargesPriceLabel.textColor = UIColor.appThemeColor
      } else if productInfoObj.itemName == "order_detail_paid_amount_title_text".localized {
        cell.chargesNameLabel.textColor = UIColor.greenTextColor
        cell.chargesPriceLabel.textColor = UIColor.greenTextColor
      } else if productInfoObj.itemName == "order_detail_balance_amount_title_text".localized {
        cell.chargesNameLabel.textColor = UIColor.red
        cell.chargesPriceLabel.textColor = UIColor.red
      }
    }
    cell.selectionStyle = .none
    return cell
  }
}


extension MTOrderDetailsViewController : UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

  }
}

extension MTOrderDetailsViewController {
  
  @IBAction func timeslot1ButtonAction(_ sender: Any) {
    timeslotPref1Button.backgroundColor = UIColor.appThemeColor
    timeslotPref1Button.setTitleColor(UIColor.white, for: .normal)
    timeslotPref2Button.backgroundColor = UIColor.clear
    timeslotPref2Button.setTitleColor(UIColor.appThemeColor, for: .normal)
    timeslotPref3Button.backgroundColor = UIColor.clear
    timeslotPref3Button.setTitleColor(UIColor.appThemeColor, for: .normal)
    
    if let dataObj = orderHistoryDetailInfo {
      acceptOrderTimeslotId = dataObj.orderId
      acceptOrderTimeslotPref = dataObj.timePreference1
    }
  }
  
  @IBAction func timeslot2ButtonAction(_ sender: Any) {
    timeslotPref1Button.backgroundColor = UIColor.clear
    timeslotPref1Button.setTitleColor(UIColor.appThemeColor, for: .normal)
    timeslotPref2Button.backgroundColor = UIColor.appThemeColor
    timeslotPref2Button.setTitleColor(UIColor.white, for: .normal)
    timeslotPref3Button.backgroundColor = UIColor.clear
    timeslotPref3Button.setTitleColor(UIColor.appThemeColor, for: .normal)
    if let dataObj = orderHistoryDetailInfo {
      acceptOrderTimeslotId = dataObj.orderId
      acceptOrderTimeslotPref = dataObj.timePreference2
    }
  }
  
  @IBAction func timeslot3ButtonAction(_ sender: Any) {
    timeslotPref1Button.backgroundColor = UIColor.clear
    timeslotPref1Button.setTitleColor(UIColor.appThemeColor, for: .normal)
    timeslotPref2Button.backgroundColor = UIColor.clear
    timeslotPref2Button.setTitleColor(UIColor.appThemeColor, for: .normal)
    timeslotPref3Button.backgroundColor = UIColor.appThemeColor
    timeslotPref3Button.setTitleColor(UIColor.white, for: .normal)
    if let dataObj = orderHistoryDetailInfo {
      acceptOrderTimeslotId = dataObj.orderId
      acceptOrderTimeslotPref = dataObj.timePreference3
    }
  }
  
  @IBAction func serviceButtonAction(_ sender: Any) {
    if isShowingServices {
      isShowingServices = false
    } else {
      isShowingServices = true
    }
    updateServicesAndAmountView()
  }
}


extension MTOrderDetailsViewController {
  
  func getProductItemPricesForSelectedMerchant() {
    if MTRechabilityManager.sharedInstance.isRechable {
      MTProgressIndicator.sharedInstance.showProgressIndicator()
      MTOrderServiceManager.sharedInstance.getMerchantSpecificProdListForOrderDetail(oderDetail: orderHistoryDetailInfo, onSuccess: { (success) -> Void in
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
        if (success as! Bool) {
          MTLogger.log.info("Success=> ")
          self.updateServicesProductData()
        }
      }) { (failure) -> Void in
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
      }
    } else {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_no_internet".localized)
    }
  }
  
  func getMerchantOrderHistoryDetailsData() {
    MTProgressIndicator.sharedInstance.showProgressIndicator()
    
    MTOrderServiceManager.sharedInstance.getMerchantOrderHistoryDetails(orderId: orderHistoryDetailInfo.orderId, orderType: self.orderTypeString.rawValue, onSuccess: { (success) -> Void in
      MTProgressIndicator.sharedInstance.hideProgressIndicator()
      if let object = success as? MTOrderDetailInfo {
      //if (success as! Bool) {
        self.orderHistoryDetailInfo = object
        self.updateHistoryDetails()
      }
    }) { (failure) -> Void in
      MTProgressIndicator.sharedInstance.hideProgressIndicator()
    }
  }
}

