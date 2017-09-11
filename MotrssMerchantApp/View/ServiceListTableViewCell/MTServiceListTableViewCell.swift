/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTServiceListTableViewCell.swift
 
 Description: This class is used to show service item in table view.
 
 Created By: Rohit W.
 
 Creation Date: 23/04/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import UIKit

class MTServiceListTableViewCell: UITableViewCell {
  
  @IBOutlet weak var serviceNameLabel: UILabel!
  @IBOutlet weak var avgServicePriceLabel: UILabel!
  @IBOutlet weak var yourServicePriceTextfield: UITextField!
  @IBOutlet weak var updateValueServiceButton: UIButton!
  
  var selectedProductName = ""
  var selectedProductId = ""
	var selectedMerchantType = ""
  
  override func awakeFromNib() {
    super.awakeFromNib()
    yourServicePriceTextfield.layer.cornerRadius = 3.0
    yourServicePriceTextfield.layer.borderWidth = 1.0
    yourServicePriceTextfield.layer.borderColor = UIColor.lightGray.cgColor
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

  func updateCellData(productObj: MTSubCategoryProductInfo, selectedVehicleType: String) {
    selectedProductName = productObj.productName
    selectedProductId = productObj.productId
    serviceNameLabel.text = productObj.productName
    
    var yourPriceValue = "0.00"
    var avgPriceValue = "0.00"
    
    if selectedVehicleType == "Car" {
      avgPriceValue = productObj.priceVehicleType2Avg
      yourPriceValue = productObj.priceVehicleType2
    } else if selectedVehicleType == "Truck" {
      avgPriceValue = productObj.priceVehicleType3Avg
      yourPriceValue = productObj.priceVehicleType3
    } else if selectedVehicleType == "MPV" {
      avgPriceValue = productObj.priceVehicleType7Avg
      yourPriceValue = productObj.priceVehicleType7
    } else if selectedVehicleType == "TwoWheelar" {
      avgPriceValue = productObj.priceVehicleType1Avg
      yourPriceValue = productObj.priceVehicleType1
    }
    
    if avgPriceValue == "" {
      avgPriceValue = "0.00"
    }
    if yourPriceValue == "" {
      yourPriceValue = "0.00"
    }
    avgServicePriceLabel.text = "currency_text".localized + avgPriceValue
    yourServicePriceTextfield.text = yourPriceValue
    updateValueServiceButton.addTarget(self, action: #selector(showUpdateServicePriceAlert), for: .touchUpInside)
  }
  
  func getHeightOfCell(productObj: MTSubCategoryProductInfo)-> CGFloat {
    
    let cellHeight:CGFloat = 50.0
    let labelHeight:CGFloat = 34.0
    
    let size:CGRect = productObj.productName.boundingRect(with: CGSize.init(width: avgServicePriceLabel.frame.origin.x-55, height: 2000.0), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:serviceNameLabel.font], context: nil)
    let newHeight = ceil(size.height)
    if newHeight > labelHeight  {
      return ((cellHeight - labelHeight) + newHeight)
    } else {
      return cellHeight
    }
  }
}


extension MTServiceListTableViewCell: UITextFieldDelegate {
  // MARK: UITextField Delegate Methods
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
    //To prevent whitspace
    //let strString = NSString(string: str)
    
    if textField == yourServicePriceTextfield {
      if str.contains(".") {
        if str.characters.count > 7 {
          return false
        }
      } else if str.characters.count > 6 {
        return false
      }
    }
    return true
  }

  func showUpdateServicePriceAlert(){
    let alert = UIAlertController(title: "", message: "select_service_update_price_alert_text".localized, preferredStyle: UIAlertControllerStyle.alert)
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
        self.updateProductPriceOnServer()
      case .cancel:
        MTLogger.log.info("cancel")
      case .destructive:
        MTLogger.log.info("destructive")
      }
    }))
    
    MTCommonUtils.visibleViewController().present(alert, animated: true, completion: nil)
  }
  
  func updateProductPriceOnServer() {
    if (yourServicePriceTextfield.text?.characters.count)! <= 0 {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "select_service_product_price_zero_alert_text".localized)
    } else {
      if MTRechabilityManager.sharedInstance.isRechable {
        MTProgressIndicator.sharedInstance.showProgressIndicator()
        MTOrderServiceManager.sharedInstance.updateMerchantProduct(productId: self.selectedProductId, productPrice: yourServicePriceTextfield.text!, mType: self.selectedMerchantType, onSuccess: { (success) -> Void in
          MTProgressIndicator.sharedInstance.hideProgressIndicator()
          if (success as! Bool) {
            MTLogger.log.info("Call Get Service Details Service => ")
            MTCommonUtils.showAlertViewWithTitle(title: "", message: "select_service_product_price_updated_title_text".localized)
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
}
