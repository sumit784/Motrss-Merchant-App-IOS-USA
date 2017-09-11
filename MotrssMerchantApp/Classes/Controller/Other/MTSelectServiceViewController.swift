/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTSelectServiceViewController.swift
 
 Description: This class is used to show the selection of services.
 
 Created By: Pranay.
 
 Creation Date: 12/05/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import Foundation
import RealmSwift
import PagingMenuController

//--------------------

struct MenuItemClass: MenuItemViewCustomizable {
  
  var itemNameText = ""
  
  init(itemText: String) {
    itemNameText = itemText
  }
  
  var displayMode: MenuItemDisplayMode {
    return .text(title: MenuItemText(text: itemNameText, color: UIColor.darkGray, selectedColor: UIColor.appThemeColor, font: UIFont(name: MTConstant.fontHMavenProRegular, size: 16.0)!, selectedFont: UIFont(name: MTConstant.fontHMavenProRegular, size: 16.0)!))
    //return .multilineText(title: MenuItemText(text: itemNameText, color: UIColor.darkGray, selectedColor: UIColor.appThemeColor, font: UIFont(name: MTConstant.fontHMavenProRegular, size: 16.0)!, selectedFont: UIFont(name: MTConstant.fontHMavenProRegular, size: 16.0)!), description: nil)
  }
}

struct MenuOptions: MenuViewCustomizable {
  
  var menuItemClassArr:[MenuItemClass] = []
  
  init(menuItemArr: [String]) {
    for itemName in menuItemArr {
      menuItemClassArr.append(MenuItemClass(itemText: itemName))
    }
  }
  
  var focusMode: MenuFocusMode {
    return .underline(height: 3, color: UIColor.appThemeColor, horizontalPadding: 10, verticalPadding: 0)
  }
  
  var displayMode: MenuDisplayMode {
    //return .segmentedControl
    return .standard(widthMode: .fixed(width: 130), centerItem: false, scrollingMode: .pagingEnabled)
    //return .infinite(widthMode: .flexible, scrollingMode: .pagingEnabled)
  }
  
  var itemsOptions: [MenuItemViewCustomizable] {
    return menuItemClassArr
  }
  
  var dividerImage: UIImage? {
    return UIImage(named: "menu_devider_image")
  }
}

struct PagingMenu: PagingMenuControllerCustomizable {
  
  var selectServiceVCArr:[MTSelectServiceListViewController] = []
  var subCategoryItemNameArr:[String] = []
  
  init(subCategoriesArr: [MTSubCategoryInfo], pageViewFrame: CGRect, classObj: MTSelectServiceViewController, selectedServiceType: String, selectedCategoryType: String, mType: String) {
    for subCategory in subCategoriesArr {
      subCategoryItemNameArr.append(subCategory.subCategoryName)
      selectServiceVCArr.append(MTCommonUtils.selectServiceListViewControler(subCategory: subCategory, withFrame: pageViewFrame, mainClassObj: classObj, serviceType: selectedServiceType, categoryType: selectedCategoryType, mType: mType))
    }
  }
  
  var componentType: ComponentType {
    return .all(menuOptions: MenuOptions(menuItemArr: subCategoryItemNameArr), pagingControllers: selectServiceVCArr)
  }
}
//--------------------

class MTSelectServiceViewController: MTBaseViewController {
  
  @IBOutlet weak var pageMenuView: UIView!
  @IBOutlet weak var selectCategoryButton: UIButton!
  //@IBOutlet weak var continueButton: UIButton!
  
  @IBOutlet weak var selecteCategoryTitleLabel: UILabel!
  @IBOutlet weak var selecteCategoryCollectionView: UICollectionView!
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var itemTableView: UITableView!
  
  var searchActive : Bool = false
  var sectionDataArr:[MTSubCategoryProductInfo] = []
  var itemDataArr:[MTSubCategoryProductInfo] = []
  var searchDataArr:[MTSubCategoryProductInfo] = []
  var isSearchButtonTap = false
  
  var selectCategoryNameArr:[String] = []
  var selectCategoryDataArr:[MTServiceCategoryInfo] = []
  var selectCategorySelectedIndex = 0
  var pagingMenuController:PagingMenuController?
  var selectedCategoryCollectionIndex = 0
  var selectCategoryType = ""
  var selecteServiceType = ""
  var selectMerchantType = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    isShowBackButton = true
    
    itemTableView.isHidden = true
    itemTableView.register(UINib.init(nibName: "MTServiceListTableViewCell", bundle: nil), forCellReuseIdentifier: "MTServiceListTableViewCellIdentifier")
    
    pageMenuView.frame = CGRect(x: 80, y: pageMenuView.frame.origin.y, width: self.view.frame.size.width-80, height: pageMenuView.frame.size.height)
    //searchBar.setValue("Done", forKey:"cancelButtonText")
    
    updateUI()
    setLocalization()
    
    //Check status
    checkCacheStatusForParentCategory()
    
    selecteCategoryTitleLabel.layer.borderWidth = 1.0
    selecteCategoryTitleLabel.layer.borderColor = UIColor.selectedBorderColor.cgColor
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  /// This function is used to update ht elogin screen UI
  func updateUI() {
    selectCategoryButton.showUnselectedState()
    selectCategoryButton.showDropDownImage()
    selectCategoryButton.setTitle("select_service_select_category_text".localized, for: .normal)
    selectCategoryButton.layer.borderColor = UIColor.lightGray.cgColor
    selectCategoryButton.layer.borderWidth = 1.0
  }
  
  /// This function is used to add the localization for the Login screen
  func setLocalization() {
    self.title = "select_service_title_text".localized
    //continueButton.setTitle("cart_screen_continue_text".localized, for: .normal)
    selecteCategoryTitleLabel.text = "select_service_select_category_title_text".localized
  }
  
  func updateCategoryData(parentCatType: String) {
    let realm = try! Realm()
    let filterString = String(format: "parentCategoryType == '%@'", parentCatType)
    let serviceCategoryInfo = realm.objects(MTServiceCategoryInfo.self).filter(filterString)
    selectCategoryNameArr.removeAll()
    selectCategoryDataArr.removeAll()
    for serviceCategory in serviceCategoryInfo {
      selectCategoryNameArr.append(serviceCategory.categoryName)
      selectCategoryDataArr.append(serviceCategory)
    }
    if selectCategoryNameArr.count>0 && selectCategoryDataArr.count>0 {
      self.showSelectedCategoryData(forIndex: 0)
    }
    
    self.selecteCategoryCollectionView.reloadData()
  }
  
  func showSelectedCategoryData(forIndex: Int) {
    //MTBookingServiceDataModel.sharedInstance.selectedServiceProductDataArr.removeAll()
    self.selectCategorySelectedIndex = forIndex
    self.selectCategoryButton.setTitle(selectCategoryNameArr[forIndex], for: .normal)
    self.selectCategoryButton.showSelectedState()
    
    updateSubCategoryData()
  }
  
  func updateSubCategoryData() {
    let serviceCategory = self.selectCategoryDataArr[self.selectCategorySelectedIndex]
    if serviceCategory.subCategoryList.count > 0 {
      //Update UI
      var subCategoryInfoArr:[MTSubCategoryInfo] = []
      for subCategory in serviceCategory.subCategoryList {
        subCategoryInfoArr.append(subCategory)
      }
      updatePageUIForCategory(subCategoriesArr: subCategoryInfoArr)
    } else {
      //Remove Page UI there is no subcategores and products
      self.pagingMenuController?.view.removeFromSuperview()
      self.pagingMenuController?.removeFromParentViewController()
    }
  }
  
  func updatePageUIForCategory(subCategoriesArr: [MTSubCategoryInfo]) {
    self.pagingMenuController?.view.removeFromSuperview()
    self.pagingMenuController?.removeFromParentViewController()
    
    let options = PagingMenu(subCategoriesArr: subCategoriesArr, pageViewFrame: pageMenuView.frame, classObj: self, selectedServiceType: self.selecteServiceType, selectedCategoryType: self.selectCategoryType, mType: self.selectMerchantType)
    pagingMenuController = PagingMenuController(options: options)
    pagingMenuController?.view.frame = CGRect(x: 0, y: 0, width: pageMenuView.frame.size.width, height: pageMenuView.frame.size.height)
    //pagingMenuController?.menuView?.frame = CGRect(x: 0, y: 0, width: pageMenuView.frame.size.width, height: (pagingMenuController?.menuView?.frame.size.height)!)
    pagingMenuController?.delegate = self
    
    addChildViewController(pagingMenuController!)
    pageMenuView.addSubview((pagingMenuController?.view)!)
    pagingMenuController?.didMove(toParentViewController: self)
  }
  
  func updateSearchCategoryData(parentCatType: String) {
    let realm = try! Realm()
    let filterString = String(format: "parentCategoryType == '%@'", parentCatType)
    let allDataInfo = realm.objects(MTSubCategoryProductInfo.self).filter(filterString)
    itemDataArr.removeAll()
    for data in allDataInfo {
      itemDataArr.append(data)
    }
    self.itemTableView.reloadData()
  }
}

extension MTSelectServiceViewController {
  //IBActions
  @IBAction func selectCategoryButtonAction(_ sender: Any) {
    if selectCategoryNameArr.count<=0 {
      return
    }
    MTPickerView.showSingleColPicker("select_service_select_category_text".localized, data: selectCategoryNameArr, defaultSelectedIndex: selectCategorySelectedIndex) {[unowned self] (selectedIndex, selectedValue) in
      self.showSelectedCategoryData(forIndex: selectedIndex)
    }
  }
  
//  @IBAction func continueButtonAction(_ sender: Any) {
//    
//  }
}

extension MTSelectServiceViewController {
  //Service Methods
  
  func checkCacheStatusForParentCategory() {
    if MTRechabilityManager.sharedInstance.isRechable {
      MTProgressIndicator.sharedInstance.showProgressIndicator()
      MTProfileServiceManager.sharedInstance.checkCacheStatus(isForProduct: false, serviceName: MTNetworkConfig.GetMerchantProfile_URL, onSuccess: { (success) -> Void in
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
        if (success as! Bool) {
          MTLogger.log.info("Call Get Service Details Service => ")
          self.getParentCategoryDetailsFromS3()
        } else {
          let realm = try! Realm()
          let filterString = String(format: "parentCategoryType == '%@'", self.selectCategoryType)
          let serviceCategoryInfo = realm.objects(MTServiceCategoryInfo.self).filter(filterString)
          if serviceCategoryInfo.count <= 0 {
            self.getParentCategoryDetailsFromS3()
          } else {
            //Update UI
            self.updateCategoryData(parentCatType: self.selectCategoryType)
            self.updateSearchCategoryData(parentCatType: self.selectCategoryType)
          }
        }
      }) { (failure) -> Void in
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
      }
    } else {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_no_internet".localized)
    }
  }
  
//  func checkCacheStatusForParentCategory() {
//    if MTRechabilityManager.sharedInstance.isRechable {
//      MTProgressIndicator.sharedInstance.showProgressIndicator()
//      MTSelectServiceManager.sharedInstance.checkCacheStatus(serviceName: MTNetworkConfig.GetParentCategoryInfo_URL, onSuccess: { (success) -> Void in
//        MTProgressIndicator.sharedInstance.hideProgressIndicator()
//        if (success as! Bool) {
//          MTLogger.log.info("Call Get Parent Category Service => ")
//          //Get categories data from server
//          //self.getParentCategoryDetailsFromServer()
//          self.getParentCategoryDetailsFromS3()
//        } else {
//          //Update UI
//          self.updateCategoryData(parentCatId: MTBookingServiceDataModel.sharedInstance.bookServiceParentCategoryID)
//          self.updateSearchCategoryData(parentCatId: MTBookingServiceDataModel.sharedInstance.bookServiceParentCategoryID)
//          /*let realm = try! Realm()
//           let parentCategoryInfo = realm.objects(MTParentCategoryInfo.self)
//           if parentCategoryInfo.count<=0 {
//           //Get categories data from server
//           //self.getParentCategoryDetailsFromServer()
//           self.getParentCategoryDetailsFromS3()
//           } else {
//           self.checkCacheStatusSubCategoryAndProductsForParentCategory()
//           }*/
//        }
//      }) { (failure) -> Void in
//        MTProgressIndicator.sharedInstance.hideProgressIndicator()
//      }
//    } else {
//      MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_no_internet".localized)
//    }
//  }
  
  /*func getParentCategoryDetailsFromServer() {
   if MTRechabilityManager.sharedInstance.isRechable {
   MTProgressIndicator.sharedInstance.showProgressIndicator()
   MTSelectServiceManager.sharedInstance.getParentCategoryData(onSuccess: { (success) -> Void in
   MTProgressIndicator.sharedInstance.hideProgressIndicator()
   if (success as! Bool) {
   MTLogger.log.info("Success=> ")
   self.checkCacheStatusSubCategoryAndProductsForParentCategory()
   }
   }) { (failure) -> Void in
   MTProgressIndicator.sharedInstance.hideProgressIndicator()
   }
   } else {
   MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_no_internet".localized)
   }
   }*/
  
  func getParentCategoryDetailsFromS3() {
    if MTRechabilityManager.sharedInstance.isRechable {
      
      let realm = try! Realm()
      var merchantProductJson = ""
      if let userInfo = realm.objects(MTUserInfo.self).first {
        merchantProductJson = userInfo.merchantID + "_merchant_products.json"
      }
      MTProgressIndicator.sharedInstance.showProgressIndicator()
      MTAWSS3ServiceManager.sharedInstance.getAWSS3DataFor(folderName: "cache", remoteFileName: merchantProductJson, onSuccess: { (success) -> Void in
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
        
        if let fileData = success as? String {
          //MTLogger.log.info("fileData =>\n \(fileData)")
          
          MTAWSS3ServiceManager.sharedInstance.updateCategorySubCategoryAndProductDetails(categoryFileData: fileData, onSuccess: { (success) in
            if let parseSuccess = success as? Bool {
              MTLogger.log.info("Success=> \(parseSuccess)")
              
              //Update UI
              self.updateCategoryData(parentCatType: self.selectCategoryType)
              self.updateSearchCategoryData(parentCatType: self.selectCategoryType)
              
              //let parentCategoryId = MTBookingServiceDataModel.sharedInstance.bookServiceParentCategoryID
//              let parentCategoryId = ""
//              let productJson = "\(parentCategoryId)" + "_category_products.json"
//              self.getAllCategorySSubCategoryAndProductDetailsFromS3(fileName: productJson)
            }
          }, onFailure: { (failure) in
            MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_something_went_wrong".localized)
          })
        } else {
          MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_something_went_wrong".localized)
        }
      }) { (failure) -> Void in
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
      }
    } else {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_no_internet".localized)
    }
  }
  
//  func getAllCategorySSubCategoryAndProductDetailsFromS3(fileName: String) {
//    if MTRechabilityManager.sharedInstance.isRechable {
//      MTProgressIndicator.sharedInstance.showProgressIndicator()
//      MTAWSS3ServiceManager.sharedInstance.getAWSS3DataFor(folderName: "cache", remoteFileName: fileName, onSuccess: { (success) -> Void in
//        MTProgressIndicator.sharedInstance.hideProgressIndicator()
//        
//        if let fileData = success as? String {
//          //MTLogger.log.info("fileData =>\n \(fileData)")
//          
//          MTAWSS3ServiceManager.sharedInstance.updateCategorySubCategoryAndProductDetails(categoryFileData: fileData, onSuccess: { (success) in
//            if let parseSuccess = success as? Bool {
//              MTLogger.log.info("Success=> \(parseSuccess)")
//              
//              //Update UI
//              //self.updateCategoryData(parentCatId: MTBookingServiceDataModel.sharedInstance.bookServiceParentCategoryID)
//              //self.updateSearchCategoryData(parentCatId: MTBookingServiceDataModel.sharedInstance.bookServiceParentCategoryID)
//            }
//          }, onFailure: { (failure) in
//            MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_something_went_wrong".localized)
//          })
//        } else {
//          MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_something_went_wrong".localized)
//        }
//      }) { (failure) -> Void in
//        MTProgressIndicator.sharedInstance.hideProgressIndicator()
//      }
//    } else {
//      MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_no_internet".localized)
//    }
//  }
  
  /*func checkCacheStatusSubCategoryAndProductsForParentCategory() {
   if MTRechabilityManager.sharedInstance.isRechable {
   MTProgressIndicator.sharedInstance.showProgressIndicator()
   let serviceName = "GetParentCategoryWiseProductList_" + MTBookingServiceDataModel.sharedInstance.bookServiceParentCategoryID
   MTSelectServiceManager.sharedInstance.checkCacheStatus(serviceName: serviceName, onSuccess: { (success) -> Void in
   MTProgressIndicator.sharedInstance.hideProgressIndicator()
   if (success as! Bool) {
   MTLogger.log.info("Call Get SubCategoryAndProductsService => ")
   //Get categories data from server
   self.getSubCategoryAndProductDetailsFromServer()
   } else {
   let realm = try! Realm()
   let filterString = String(format: "parentCategoryId == '%@'", MTBookingServiceDataModel.sharedInstance.bookServiceParentCategoryID)
   let serviceCategoryInfo = realm.objects(MTServiceCategoryInfo.self).filter(filterString)
   if serviceCategoryInfo.count <= 0{
   self.getSubCategoryAndProductDetailsFromServer()
   } else {
   //Update UI
   self.updateCategoryData(parentCatId: MTBookingServiceDataModel.sharedInstance.bookServiceParentCategoryID)
   }
   }
   }) { (failure) -> Void in
   MTProgressIndicator.sharedInstance.hideProgressIndicator()
   }
   } else {
   MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_no_internet".localized)
   }
   }*/
  
  /*func getSubCategoryAndProductDetailsFromServer() {
   if MTRechabilityManager.sharedInstance.isRechable {
   MTProgressIndicator.sharedInstance.showProgressIndicator()
   let parentCatID = MTBookingServiceDataModel.sharedInstance.bookServiceParentCategoryID
   MTSelectServiceManager.sharedInstance.getSubCategoryDataAndProductsForParentCategory(parentCategoryId: parentCatID, onSuccess: { (success) -> Void in
   MTProgressIndicator.sharedInstance.hideProgressIndicator()
   if (success as! Bool) {
   MTLogger.log.info("Success=> ")
   //Update UI
   self.updateCategoryData(parentCatId: parentCatID)
   }
   }) { (failure) -> Void in
   MTProgressIndicator.sharedInstance.hideProgressIndicator()
   }
   } else {
   MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_no_internet".localized)
   }
   }*/
}

extension MTSelectServiceViewController: PagingMenuControllerDelegate {
  
  //Mark:PagingMenuControllerDelegate metthods
  
  func willMove(toMenu menuController: UIViewController, fromMenu previousMenuController: UIViewController) {
    MTLogger.log.info("willMove UIViewController")
  }
  func didMove(toMenu menuController: UIViewController, fromMenu previousMenuController: UIViewController) {
    MTLogger.log.info("didMove UIViewController")
  }
  func willMove(toMenuItem menuItemView: MenuItemView, fromMenuItem previousMenuItemView: MenuItemView) {
    MTLogger.log.info("willMove MenuItemView")
  }
  func didMove(toMenuItem menuItemView: MenuItemView, fromMenuItem previousMenuItemView: MenuItemView) {
    MTLogger.log.info("didMove MenuItemView")
  }
}

extension MTSelectServiceViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  
  // MARK: - UICollectionViewDataSource protocol
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.selectCategoryDataArr.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCellIdentifier", for: indexPath as IndexPath) as! MTCategoryCollectionViewCell
    
    let object = self.selectCategoryDataArr[indexPath.item]
    cell.categoryTitleLabel.text = object.categoryName
    cell.categoryImageView.image = UIImage(named: object.categoryImage)
    
    cell.layer.cornerRadius = 3.0
    if selectedCategoryCollectionIndex ==  indexPath.item {
      cell.layer.borderWidth = 1.0
      cell.layer.borderColor = UIColor.appThemeColor.cgColor
      cell.categoryTitleLabel.textColor = UIColor.appThemeColor
    } else {
      cell.layer.borderWidth = 1.0
      cell.layer.borderColor = UIColor.selectedBorderColor.cgColor
      cell.categoryTitleLabel.textColor = UIColor.black
    }
    
    return cell
  }
  
  // MARK: - UICollectionViewDelegate protocol
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    selectedCategoryCollectionIndex = indexPath.item
    collectionView.reloadData()
    self.showSelectedCategoryData(forIndex: selectedCategoryCollectionIndex)
  }
}

class MTCategoryCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var categoryTitleLabel: UILabel!
  @IBOutlet weak var categoryImageView: UIImageView!
}

extension MTSelectServiceViewController:UISearchBarDelegate {
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    let uiButton = searchBar.value(forKey: "cancelButton") as? UIButton
    uiButton?.setTitle("Done", for: .normal)
    searchActive = true;
    itemTableView.isHidden = false
    //bgView.isHidden = true
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    searchActive = false;
    if isSearchButtonTap {
      isSearchButtonTap = false
    } else {
      //itemTableView.isHidden = true
      //bgView.isHidden = false
    }
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchActive = false;
    itemTableView.isHidden = true
    //bgView.isHidden = false
    searchDataArr.removeAll()
    sectionDataArr.removeAll()
    searchBar.text = ""
    searchBar.endEditing(true)
    self.itemTableView.reloadData()
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchActive = false;
    isSearchButtonTap = true
    //itemTableView.isHidden = true
    //bgView.isHidden = false
    searchBar.resignFirstResponder()
    //self.view.endEditing(true)
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
    sectionDataArr.removeAll()
    searchDataArr = itemDataArr.filter({ (text) -> Bool in
      let tmp: MTSubCategoryProductInfo = text as MTSubCategoryProductInfo
      let rangeStr = tmp.productName.range(of:searchText, options:.caseInsensitive)
      if let range = rangeStr {
        return !range.isEmpty
      }
      return false
    })
    if(searchDataArr.count == 0){
      searchActive = false;
    } else {
      searchActive = true;
      
      //Filter sectionArr
      
      for searchItem in searchDataArr {
        if !self.isContainSubCategoryObjectInSection(subCatId: searchItem.subCategoryId) {
          sectionDataArr.append(searchItem)
        }
      }
    }
    self.itemTableView.reloadData()
  }
  
  func isContainSubCategoryObjectInSection(subCatId: String) -> Bool {
    var retValue = false
    for item in sectionDataArr {
      if item.subCategoryId == subCatId {
        retValue = true
        break
      }
    }
    return retValue
  }
}

extension MTSelectServiceViewController: UITableViewDataSource, UITableViewDelegate {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    if(searchActive){
      return sectionDataArr.count
    } else {
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if(searchActive) {
      let sectionProduct = sectionDataArr[section]
      let rowsArr = searchDataArr.filter{ $0.subCategoryId == sectionProduct.subCategoryId }
      return rowsArr.count
    }
    //return data.count;
    return 0;
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    let subCat = sectionDataArr[section]
    return "\(subCat.categoryName) -> \(subCat.subCategoryName)"
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //let cell = tableView.dequeueReusableCell(withIdentifier: "SelectServiceCellIdentifier", for: indexPath);
    let cell: MTServiceListTableViewCell = self.itemTableView.dequeueReusableCell(withIdentifier: "MTServiceListTableViewCellIdentifier") as! MTServiceListTableViewCell
    
    //if(searchActive){
    let sectionProduct = sectionDataArr[indexPath.section]
    let rowsArr = searchDataArr.filter{ $0.subCategoryId == sectionProduct.subCategoryId }
    let productObj = rowsArr[indexPath.row]
    //cell.textLabel?.text = productObj.productName
    
    cell.selectedMerchantType = self.selectMerchantType
    cell.updateCellData(productObj: productObj, selectedVehicleType: self.selecteServiceType)
    
    cell.tag = indexPath.row
    cell.selectionStyle = .none
    //cell.addServiceButton.addTarget(self, action: #selector(serviceAddButtonAction(_:)), for: .touchUpInside)
    
    //Check if that product is alredy in cart
//    if productObj.isAddedToCart {
//      cell.addServiceButton.isHidden = true
//      cell.addedServiceButton.isHidden = false
//    } else {
//      cell.addServiceButton.isHidden = false
//      cell.addedServiceButton.isHidden = true
//    }
//    
//    //Check if that product is alredy in cart
//    if productObj.isAddedToCart {
//      cell.addServiceButton.isHidden = true
//      cell.addedServiceButton.isHidden = false
//    } else {
//      cell.addServiceButton.isHidden = false
//      cell.addedServiceButton.isHidden = true
//    }
    //} else {
    //let productObj = itemDataArr[indexPath.row]
    //  cell.textLabel?.text = ""
    //}
    //cell.textLabel?.font = UIFont.init(name: MTConstant.fontHMavenProRegular, size: 15.0)
    
    return cell;
  }
  
  @IBAction func serviceAddButtonAction(_ sender: Any) {
    if let button = sender as? UIButton {
      if let superview = button.superview {
        if let cell = superview.superview as? MTServiceListTableViewCell {
          let indexPath = itemTableView.indexPath(for: cell)
          if let index = indexPath {
            updatedSelectedProduct(indexPath: index)
          }
        }
      }
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //updatedSelectedProduct(indexPath: indexPath)
  }
  
  func updatedSelectedProduct(indexPath: IndexPath) {
//    let sectionProduct = sectionDataArr[indexPath.section]
//    let rowsArr = searchDataArr.filter{ $0.subCategoryId == sectionProduct.subCategoryId }
//    let productObj = rowsArr[indexPath.row]
    
//    let realm = try! Realm()
//    try! realm.write {
//      productObj.isAddedToCart = true
//    }
    
    /*sectionDataArr.removeAll()
     searchDataArr.removeAll()
     searchBar.text = ""
     searchBar.endEditing(true)
     self.itemTableView.isHidden = true*/
    
    self.itemTableView.reloadData()
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: MTConstant.Notification_UpdateServiceList), object: nil)
  }
}
