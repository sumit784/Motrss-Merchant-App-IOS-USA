/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTHomeViewControler.swift
 
 Description: This class is used to show home screen for the application.
 
 Created By: Rohit W.
 
 Creation Date: 25/06/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import UIKit
import SideMenuController
import RealmSwift
import Kingfisher
import PagingMenuController

//--------------------

struct OrdersMenuItemClass: MenuItemViewCustomizable {
  
  var itemNameText = ""
  
  init(itemText: String) {
    itemNameText = itemText
  }
  
  var displayMode: MenuItemDisplayMode {
    return .text(title: MenuItemText(text: itemNameText, color: UIColor.darkGray, selectedColor: UIColor.appThemeColor, font: UIFont(name: MTConstant.fontHMavenProRegular, size: 16.0)!, selectedFont: UIFont(name: MTConstant.fontHMavenProRegular, size: 16.0)!))
  }
}

struct OrdersMenuOptions: MenuViewCustomizable {
  
  var menuItemClassArr:[OrdersMenuItemClass] = []
  
  init(menuItemArr: [String]) {
    for itemName in menuItemArr {
      menuItemClassArr.append(OrdersMenuItemClass(itemText: itemName))
    }
  }
  
  var focusMode: MenuFocusMode {
    return .underline(height: 3, color: UIColor.appThemeColor, horizontalPadding: 10, verticalPadding: 0)
  }
  
  var displayMode: MenuDisplayMode {
    return .segmentedControl
    //return .standard(widthMode: .flexible, centerItem: false, scrollingMode: .pagingEnabled)
    //return .infinite(widthMode: .flexible, scrollingMode: .pagingEnabled)
  }
  
  var itemsOptions: [MenuItemViewCustomizable] {
    return menuItemClassArr
  }
  
  var dividerImage: UIImage? {
    return UIImage(named: "menu_devider_image")
  }
}

struct OrdersPagingMenu: PagingMenuControllerCustomizable {
  
  let orderVC1 = MTCommonUtils.orderViewControler(orderType: .newOrders)
  let orderVC2 = MTCommonUtils.orderViewControler(orderType: .orderStatus)
  let orderVC3 = MTCommonUtils.orderViewControler(orderType: .orderHistory)
  
  //var viewControllersArr:[MTOrderListViewController] = []
  var itemNameArr:[String] = ["New Orders", "Order Status", "Order History"]
  
  init(pageViewFrame: CGRect) {
    /*viewControllersArr.append(MTCommonUtils.orderViewControler(orderType: .newOrders, withFrame: pageViewFrame))
    viewControllersArr.append(MTCommonUtils.orderViewControler(orderType: .orderStatus, withFrame: pageViewFrame))
    viewControllersArr.append(MTCommonUtils.orderViewControler(orderType: .orderHistory, withFrame: pageViewFrame))*/
  }
  
  var componentType: ComponentType {
    //return .all(menuOptions: OrdersMenuOptions(menuItemArr: itemNameArr), pagingControllers: viewControllersArr)
    return .all(menuOptions: OrdersMenuOptions(menuItemArr: itemNameArr), pagingControllers: [orderVC1, orderVC2, orderVC3])
  }
}
//--------------------

class MTHomeViewControler: MTBaseViewController, SideMenuControllerDelegate, UIScrollViewDelegate {
  
  var pageMenuOptions:OrdersPagingMenu?
  var pagingMenuController:PagingMenuController?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "home_screen_title_text".localized
    sideMenuController?.delegate = self
    
    setLocalization()
    
    updatePageUI()
    //getAllMerchantOrders()
    getMerchantOrderCancelReasons()
    
    let refreshButton = UIBarButtonItem(image: UIImage.init(named: "refresh"), style: .plain, target: self, action: #selector(self.refetchMerchantOrders))
    self.navigationItem.rightBarButtonItem = refreshButton
    
    NotificationCenter.default.addObserver(self, selector: #selector(refetchOrderStatus), name: NSNotification.Name(rawValue: MTConstant.Notification_RefeshOrderStatus), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(refetchOrderStatusUI), name: NSNotification.Name(rawValue: MTConstant.Notification_RefeshOrderStatusUI), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(refetchNewOrders), name: NSNotification.Name(rawValue: MTConstant.Notification_RefershNewOrder), object: nil)
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    //Reset
    MTBookingServiceDataModel.sharedInstance.resetDataModel()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  deinit {
  }
  
  /// This function is used to update ht elogin screen UI
  func updatePageUI() {
    pageMenuOptions = OrdersPagingMenu(pageViewFrame: self.view.frame)
    pagingMenuController = PagingMenuController(options: pageMenuOptions!)
    //pagingMenuController.delegate = self
    
    addChildViewController(pagingMenuController!)
    self.view.addSubview((pagingMenuController?.view)!)
    pagingMenuController?.didMove(toParentViewController: self)
  }
  
  func setLocalization() {
  }
 
  /*func refreshMerchalAllOrders() {
    self.pageMenuOptions?.orderVC1.updateOrderHistoryList()
    self.pageMenuOptions?.orderVC2.updateOrderHistoryList()
    self.pageMenuOptions?.orderVC3.updateOrderHistoryList()
  }*/
}

extension MTHomeViewControler {
  
  func sideMenuControllerDidHide(_ sideMenuController: SideMenuController) {
    if sideMenuController.view.tag == 101 {
      let calendarVC = MTCommonUtils.viewcontroller(storyboardName: "Main", viewcontrollerID: MTConstant.CalendarViewControlerID) as! MTCalendarViewControler
      self.navigationController?.pushViewController(calendarVC, animated: true)
    } else if sideMenuController.view.tag == 102 {
      let dashboardVC = MTCommonUtils.viewcontroller(storyboardName: "Main", viewcontrollerID: MTConstant.DashboardViewControlerID) as! MTDashboardViewControler
      self.navigationController?.pushViewController(dashboardVC, animated: true)
      
    } else if sideMenuController.view.tag == 111 || sideMenuController.view.tag == 112 || sideMenuController.view.tag == 113 {
      //MTCommonUtils.showAlertViewWithTitle(title: "", message: "This is new requirement.")
      let serviceListVC = MTCommonUtils.viewcontroller(storyboardName: "Main", viewcontrollerID: MTConstant.SelectServiceViewControllerID) as! MTSelectServiceViewController
      if sideMenuController.view.tag == 112 {
        serviceListVC.selecteServiceType = "Truck"
        serviceListVC.selectMerchantType = "111"
      } else if sideMenuController.view.tag == 113 {
        serviceListVC.selecteServiceType = "MPV"
        serviceListVC.selectMerchantType = "105"
      } else {
        serviceListVC.selecteServiceType = "Car"
        serviceListVC.selectMerchantType = "104"
      }
      serviceListVC.selectCategoryType = "4_wheeler"
      self.navigationController?.pushViewController(serviceListVC, animated: true)
      
    } else if sideMenuController.view.tag == 110 {
      //MTCommonUtils.showAlertViewWithTitle(title: "", message: "This is new requirement.")
      let serviceListVC = MTCommonUtils.viewcontroller(storyboardName: "Main", viewcontrollerID: MTConstant.SelectServiceViewControllerID) as! MTSelectServiceViewController
      serviceListVC.selecteServiceType = "TwoWheelar"
      serviceListVC.selectCategoryType = "2_wheeler"
      serviceListVC.selectMerchantType = "102"
      self.navigationController?.pushViewController(serviceListVC, animated: true)
      
    } else if sideMenuController.view.tag == 105 {
      let offerVC = MTCommonUtils.viewcontroller(storyboardName: "Main", viewcontrollerID: MTConstant.OfferViewControlerID) as! MTOfferViewControler
      self.navigationController?.pushViewController(offerVC, animated: true)
    } else if sideMenuController.view.tag == 106 {
      let teamVC = MTCommonUtils.viewcontroller(storyboardName: "Main", viewcontrollerID: MTConstant.TeamMemberViewControlerID) as! MTTeamMemberViewControler
      self.navigationController?.pushViewController(teamVC, animated: true)
    } else if sideMenuController.view.tag == 107 {
      let profileVC = MTCommonUtils.viewcontroller(storyboardName: "Main", viewcontrollerID: MTConstant.ProfileViewControlerID) as! MTProfileViewControler
      self.navigationController?.pushViewController(profileVC, animated: true)
    } else if sideMenuController.view.tag == 108 {
      let reviewVC = MTCommonUtils.viewcontroller(storyboardName: "Main", viewcontrollerID: MTConstant.ReviewAndRatingViewControlerID) as! MTReviewAndRatingViewControler
      self.navigationController?.pushViewController(reviewVC, animated: true)
    }
  }
  
  func sideMenuControllerDidReveal(_ sideMenuController: SideMenuController) {
    if let sideMenu = sideMenuController.sideViewController as? MTSideMenuController {
      //sideMenu.updateUserProfileData()
    }
  }
  
}

extension MTHomeViewControler {
  
  // MARK: IBAction Methods
  @IBAction func bookServicingAction(_ sender: Any) {
    
  }
}

extension MTHomeViewControler {
  // MARK: Service Methods
  
  func refetchMerchantOrders() {
    if let pgVC = pagingMenuController {
      if pgVC.currentPage == 0 {
        self.pageMenuOptions?.orderVC1.getMerchantOrdersData()
      } else if pgVC.currentPage == 1 {
        self.pageMenuOptions?.orderVC2.getMerchantOrdersData()
      } else if pgVC.currentPage == 2 {
        self.pageMenuOptions?.orderVC3.getMerchantOrdersData()
      }
    }
  }
  
  func refetchOrderStatus() {
    if let menu = self.pageMenuOptions {
      menu.orderVC2.getMerchantOrdersData()
    }
  }
  
  func refetchOrderStatusUI() {
    if let menu = self.pageMenuOptions {
      menu.orderVC2.updateOrderHistoryList()
    }
  }
  
  func refetchNewOrders() {
    if let menu = self.pageMenuOptions {
      menu.orderVC1.getMerchantOrdersData()
    }
  }
  
  /*func getAllMerchantOrders() {
    MTProgressIndicator.sharedInstance.showProgressIndicator()
    MTOrderServiceManager.sharedInstance.getMerchantOrders(/*orderStatus: "", userId: "", */onSuccess: { (success) -> Void in
      MTProgressIndicator.sharedInstance.hideProgressIndicator()
      if (success as! Bool) {
        self.refreshMerchalAllOrders()
      }
    }) { (failure) -> Void in
      MTProgressIndicator.sharedInstance.hideProgressIndicator()
    }
  }*/
  
  func getMerchantOrderCancelReasons() {
    MTProgressIndicator.sharedInstance.showProgressIndicator()
    MTOrderServiceManager.sharedInstance.getOrderCancelReason(onSuccess: { (success) -> Void in
      MTProgressIndicator.sharedInstance.hideProgressIndicator()
      if (success as! Bool) {
      }
    }) { (failure) -> Void in
      MTProgressIndicator.sharedInstance.hideProgressIndicator()
    }
  }
}
