/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTServicePackageDetailsView.swift
 
 Description: This class is used to to sort service centers
 
 Created By: Rohit W.
 
 Creation Date: 21/05/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import UIKit

protocol MTServicePackageDetailsViewDelegate: class {
  func didSelectServiceProductForIndex(selectedIndexPath: IndexPath?)
}

class MTServicePackageDetailsView: UIView, UITextFieldDelegate {

  @IBOutlet weak var bgView: UIView!
  @IBOutlet weak var packageTitleLabel: UILabel!
  @IBOutlet weak var addServiceButton: UIButton!
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var avgPriceTitleLabel: UILabel!
  @IBOutlet weak var avgPriceValueLabel: UILabel!
  @IBOutlet weak var packageDescLabel: UILabel!
  @IBOutlet weak var packageTableView: UITableView!
  
  var delegate: MTServicePackageDetailsViewDelegate?
  var packageDetailDataArr:[MTProductPackageInfo] = []
  var productInfo:MTSubCategoryProductInfo?
  var selectedIndexPath: IndexPath?
  
  override func awakeFromNib() {
    //bgView.layer.cornerRadius = 3.0
    addServiceButton.layer.cornerRadius = 2.0
    cancelButton.layer.cornerRadius = 2.0
    
    addServiceButton.layer.borderColor = UIColor.lightGray.cgColor
    addServiceButton.layer.borderWidth = 1.0
    cancelButton.layer.borderColor = UIColor.lightGray.cgColor
    cancelButton.layer.borderWidth = 1.0
    
    packageTableView.register(UINib.init(nibName: "MTServicePackageDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "ServicePackageDetailTableViewCellIdentifier")
    packageTableView.delegate = self
    packageTableView.dataSource = self
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    packageTitleLabel.text = productInfo?.productName
    
    //Get total price
    var finalValue:Double = 0.0
    for packaheItem in packageDetailDataArr {
      if packaheItem.itemPrice.characters.count>0 {
        finalValue = finalValue + Double(packaheItem.itemPrice)!
      }
    }
    avgPriceValueLabel.text = "currency_text".localized + "\(finalValue)"
    
    var productPrice:String?
//    if MTBookingServiceDataModel.sharedInstance.bookServiceVehicleTypeID == MTEnums.VehicleTypeId.twowheelar {
//      productPrice = productInfo?.priceVehicleType1
//    } else if MTBookingServiceDataModel.sharedInstance.bookServiceVehicleTypeID == MTEnums.VehicleTypeId.car {
//      productPrice = productInfo?.priceVehicleType2
//    } else if MTBookingServiceDataModel.sharedInstance.bookServiceVehicleTypeID == MTEnums.VehicleTypeId.electric {
//      productPrice = productInfo?.priceVehicleType15
//    } else if MTBookingServiceDataModel.sharedInstance.bookServiceVehicleTypeID == MTEnums.VehicleTypeId.luxury {
//      productPrice = productInfo?.priceVehicleType7
//    } else if MTBookingServiceDataModel.sharedInstance.bookServiceVehicleTypeID == MTEnums.VehicleTypeId.minitruck {
//      productPrice = productInfo?.priceVehicleType3
//    }
    if productPrice == "" {
      productPrice = "0.0"
    }
    let cartPrice = "select_service_add_service_text".localized + " " + "currency_text".localized +  "\(productPrice ?? "0.0")"
    addServiceButton.setTitle(cartPrice, for: .normal)
    cancelButton.setTitle("general_cancel_text".localized, for: .normal)
    packageDescLabel.text = "select_service_package_desc_text".localized
    avgPriceTitleLabel.text = "select_service_avg_ptice_text".localized
  }
  
  @IBAction func addServiceButtonAction(_ sender: Any) {
    delegate?.didSelectServiceProductForIndex(selectedIndexPath: selectedIndexPath)
    removeFromSuperview()
  }
  
  @IBAction func cancelButtonAction(_ sender: Any) {
    removeFromSuperview()
  }
}


extension MTServicePackageDetailsView : UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return packageDetailDataArr.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell: MTServicePackageDetailTableViewCell = self.packageTableView.dequeueReusableCell(withIdentifier: "ServicePackageDetailTableViewCellIdentifier") as! MTServicePackageDetailTableViewCell
    
    let packageObj = packageDetailDataArr[indexPath.row]
    cell.textLabel?.text = packageObj.itemName
    cell.textLabel?.font = UIFont(name: MTConstant.fontHMavenProRegular, size: 14)
    
    cell.tag = indexPath.row
    cell.selectionStyle = .none
    return cell
  }
}


extension MTServicePackageDetailsView : UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
}
