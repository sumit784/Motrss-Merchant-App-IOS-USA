/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTOfferViewControler.swift
 
 Description: This class is used to show home offer screen for the application.
 
 Created By: Pranay.
 
 Creation Date: 20/07/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import UIKit
import PagingMenuController

//--------------------

struct OfferMenuItemClass: MenuItemViewCustomizable {
  
  var itemNameText = ""
  
  init(itemText: String) {
    itemNameText = itemText
  }
  
  var displayMode: MenuItemDisplayMode {
    return .text(title: MenuItemText(text: itemNameText, color: UIColor.darkGray, selectedColor: UIColor.appThemeColor, font: UIFont(name: MTConstant.fontHMavenProRegular, size: 16.0)!, selectedFont: UIFont(name: MTConstant.fontHMavenProRegular, size: 16.0)!))
  }
}

struct OfferMenuOptions: MenuViewCustomizable {
  
  var menuItemClassArr:[OfferMenuItemClass] = []
  
  init(menuItemArr: [String]) {
    for itemName in menuItemArr {
      menuItemClassArr.append(OfferMenuItemClass(itemText: itemName))
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

struct OfferPagingMenu: PagingMenuControllerCustomizable {
  
  let offerVC1 = MTCommonUtils.offerViewControler(offerType: .myOffers)
  let offerVC2 = MTCommonUtils.offerViewControler(offerType: .awaitingForApproval)
  
  var itemNameArr:[String] = ["My Offers", "Awaiting Approval"]
  
  init(pageViewFrame: CGRect) {
  }
  
  var componentType: ComponentType {
    return .all(menuOptions: OrdersMenuOptions(menuItemArr: itemNameArr), pagingControllers: [offerVC1, offerVC2])
  }
}
//--------------------

class MTOfferViewControler: MTBaseViewController {
  
  var pageMenuOptions:OfferPagingMenu?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    isShowBackButton = true
    
    setLocalization()
    updatePageUI()
    getAllMerchantOffers()
    
    let addButton = UIBarButtonItem(image: UIImage.init(named: "add_address_icon"), style: .plain, target: self, action: #selector(self.moveToAddOrderScreen))
    self.navigationItem.rightBarButtonItem = addButton
    
    NotificationCenter.default.addObserver(self, selector: #selector(getAllMerchantOffers), name: NSNotification.Name(rawValue: MTConstant.Notification_RefreshMErchantOffers), object: nil)
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
    pageMenuOptions = OfferPagingMenu(pageViewFrame: self.view.frame)
    let pagingMenuController = PagingMenuController(options: pageMenuOptions!)
    //pagingMenuController.delegate = self
    
    addChildViewController(pagingMenuController)
    self.view.addSubview((pagingMenuController.view)!)
    pagingMenuController.didMove(toParentViewController: self)
  }
  
  func setLocalization() {
    self.title = "offers_screen_title_text".localized
  }
  
  func refreshAllOffers() {
    self.pageMenuOptions?.offerVC1.updateOfferList()
    self.pageMenuOptions?.offerVC2.updateOfferList()
  }
}

extension MTOfferViewControler {
  
  func moveToAddOrderScreen() {
    let offerDetailsVC = MTCommonUtils.viewcontroller(storyboardName: "Main", viewcontrollerID: MTConstant.OfferDetailViewControlerID) as! MTOfferDetailViewControler
    offerDetailsVC.isAddOffers = true
    self.navigationController?.pushViewController(offerDetailsVC, animated: true)
  }
  
  func getAllMerchantOffers() {
    if MTRechabilityManager.sharedInstance.isRechable {
      MTProgressIndicator.sharedInstance.showProgressIndicator()
      
      MTOfferServiceManager.sharedInstance.getAllMerchantOffers(onSuccess: { (success) -> Void in
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
        if (success as! Bool) {
          MTLogger.log.info("getAllMerchantOffers => ")
          self.refreshAllOffers()
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
