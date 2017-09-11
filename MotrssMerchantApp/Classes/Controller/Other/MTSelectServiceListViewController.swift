/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTSelectServiceListViewController.swift
 
 Description: This class is used to show the selection of services.
 
 Created By: Pranay.
 
 Creation Date: 12/05/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import Foundation
import RealmSwift

class MTSelectServiceListViewController: MTBaseViewController {
  
  @IBOutlet weak var listTableView: UITableView!  
  
  var selectedSubCategory:MTSubCategoryInfo?
  var servicesListDataArr:[MTSubCategoryProductInfo] = []
  var mainPageViewFrame:CGRect?
	var selecteServiceClassObj:MTSelectServiceViewController?
  var selecteServiceType:String = ""
  var selecteCategoryType = ""
  var selectMerchantType = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    isShowBackButton = true
    
    //listTableView.separatorStyle = .none
    listTableView.register(UINib.init(nibName: "MTServiceListTableViewCell", bundle: nil), forCellReuseIdentifier: "MTServiceListTableViewCellIdentifier")
    NotificationCenter.default.addObserver(self, selector: #selector(refreshTableViewUI), name: NSNotification.Name(rawValue: MTConstant.Notification_UpdateServiceList), object: nil)
    
    updateUI()
    setLocalization()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    listTableView.reloadData()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    if let viewFrame  = mainPageViewFrame {
      self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: viewFrame.size.width, height: viewFrame.size.height-50)
      listTableView.frame = CGRect(x: listTableView.frame.origin.x, y: listTableView.frame.origin.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
      self.view.layoutIfNeeded()
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: MTConstant.Notification_UpdateServiceList), object: nil)
  }
  
  /// This function is used to update ht elogin screen UI
  func updateUI() {
    if let products = selectedSubCategory?.subCategoryProductList {
      for product in products {
        servicesListDataArr.append(product)
      }
      listTableView.reloadData()
    }
  }
  
  func refreshTableViewUI() {
    DispatchQueue.main.async {
      self.listTableView.reloadData()
    }
  }
  
  /// This function is used to add the localization for the Login screen
  func setLocalization() {
    
  }
  
  func updateProductToCartForIndex(indexPath: IndexPath) {
    //Add product to bookingservice model
    //let cell = listTableView.cellForRow(at: indexPath) as! MTServiceListTableViewCell
    //let productObj = servicesListDataArr[indexPath.row]
    //Update product to server
    
  }
}

extension MTSelectServiceListViewController {
  //IBActions
  @IBAction func serviceUpdateButtonAction(_ sender: Any) {
    if let button = sender as? UIButton {
      if let superview = button.superview {
        if let cell = superview.superview as? MTServiceListTableViewCell {
          let indexPath = listTableView.indexPath(for: cell)
          if let index = indexPath {
            updateProductToCartForIndex(indexPath: index)
          }
        }
      }
    }
  }
}

extension MTSelectServiceListViewController : UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Section"
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
    headerView.backgroundColor = UIColor.white
    
    let firstLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: headerView.frame.size.height))
    firstLabel.font = UIFont(name: MTConstant.fontHMavenProRegular, size: 13.0)
    firstLabel.text = "sidemenu_service_name_title_text".localized
    firstLabel.textColor = UIColor.appThemeColor
    //firstLabel.backgroundColor = UIColor.yellow
    firstLabel.textAlignment = .center
    firstLabel.numberOfLines = 0
    headerView.addSubview(firstLabel)
    
    let secondLabel = UILabel(frame: CGRect(x: firstLabel.frame.origin.x + firstLabel.frame.size.width+10, y: 0, width: 80, height: headerView.frame.size.height))
    secondLabel.font = UIFont(name: MTConstant.fontHMavenProRegular, size: 13.0)
    secondLabel.text = "sidemenu_service_avg_price_title_text".localized
    secondLabel.textColor = UIColor.appThemeColor
    //secondLabel.backgroundColor = UIColor.yellow
    secondLabel.textAlignment = .center
    secondLabel.numberOfLines = 0
    headerView.addSubview(secondLabel)
    
    let thirdLabel = UILabel(frame: CGRect(x: secondLabel.frame.origin.x + secondLabel.frame.size.width, y: 0, width: 90, height: headerView.frame.size.height))
    thirdLabel.font = UIFont(name: MTConstant.fontHMavenProRegular, size: 13.0)
    thirdLabel.text = "sidemenu_service_your_pice_text".localized
    thirdLabel.textColor = UIColor.appThemeColor
    //thirdLabel.backgroundColor = UIColor.yellow
    thirdLabel.textAlignment = .center
    thirdLabel.numberOfLines = 0
    headerView.addSubview(thirdLabel)
    
    return headerView
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let cell: MTServiceListTableViewCell = self.listTableView.dequeueReusableCell(withIdentifier: "MTServiceListTableViewCellIdentifier") as! MTServiceListTableViewCell
    let productObj = servicesListDataArr[indexPath.row]
    return cell.getHeightOfCell(productObj: productObj)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return servicesListDataArr.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell: MTServiceListTableViewCell = self.listTableView.dequeueReusableCell(withIdentifier: "MTServiceListTableViewCellIdentifier") as! MTServiceListTableViewCell
    
    let productObj = servicesListDataArr[indexPath.row]
    cell.selectedMerchantType = self.selectMerchantType    
    cell.updateCellData(productObj: productObj, selectedVehicleType: self.selecteServiceType)
    
    cell.tag = indexPath.row
    cell.selectionStyle = .none
    //cell.updateValueServiceButton.addTarget(self, action: #selector(serviceUpdateButtonAction(_:)), for: .touchUpInside)
    
    //Check if that product is alredy in cart
//    if productObj.isAddedToCart {
//      cell.addServiceButton.isHidden = true
//      cell.addedServiceButton.isHidden = false
//    } else {
//      cell.addServiceButton.isHidden = false
//      cell.addedServiceButton.isHidden = true
//    }
    
    return cell
  }
}

extension MTSelectServiceListViewController : UITableViewDelegate, MTServicePackageDetailsViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let productObj = servicesListDataArr[indexPath.row]
    if productObj.isPackage == "1" {
      //Show the package details
      let views = Bundle.main.loadNibNamed("MTServicePackageDetailsView", owner: nil, options: nil)
      let servicePackageView = views?[0] as! MTServicePackageDetailsView
      servicePackageView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
      servicePackageView.delegate = self
      servicePackageView.productInfo = productObj
      servicePackageView.selectedIndexPath = indexPath
      for package in productObj.packageList {
        servicePackageView.packageDetailDataArr.append(package)
      }
      self.navigationController?.view.addSubview(servicePackageView)
    }
  }
  
  func didSelectServiceProductForIndex(selectedIndexPath: IndexPath?) {
    if let index = selectedIndexPath {
      updateProductToCartForIndex(indexPath: index)
    }
  }
}

