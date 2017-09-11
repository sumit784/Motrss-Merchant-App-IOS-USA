/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTOrderDeclineSelectionView.swift
 
 Description: This class is used to show the decline reason.
 
 Created By: Rohit W.
 
 Creation Date: 24/07/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import UIKit
import TextFieldEffects
import SwiftyJSON
import RealmSwift

protocol MTOrderDeclineSelectionViewDelegate: class {
  func didSelectReason(selectedReason: String)
}

class MTOrderDeclineSelectionView: UIView, UITextFieldDelegate {

  @IBOutlet weak var bgView: UIView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var nextButton: UIButton!
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var tableView: UITableView!
  
  var delegate: MTOrderDeclineSelectionViewDelegate?
  var reasonDataArray:[MTOrderCancelReasonInfo] = []
  var selectedReasonItem = -1
  
  override func awakeFromNib() {
    //nextButton.isEnabled = false
    //nextButton.alpha = 0.7
    bgView.layer.cornerRadius = 3.0
    nextButton.layer.cornerRadius = 15.0
    cancelButton.layer.cornerRadius = 15.0
    tableView.layer.borderWidth = 1.0
    tableView.layer.borderColor = UIColor.selectedBorderColor.cgColor
    
    titleLabel.text = "order_decline_reason_title_text".localized
    nextButton.setTitle("order_decline_apply_text".localized, for: .normal)
    cancelButton.setTitle("general_cancel_text".localized, for: .normal)
    
    tableView.separatorStyle = .none
    tableView.register(UINib.init(nibName: "MTOrderDeclineTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderDeclineTableViewCellIdentifier")

    updateReasonData()
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
  }
  
  func updateViewSize() {
    let tableHeight = CGFloat(reasonDataArray.count) * 30.0
    tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: tableHeight)
    
    nextButton.frame = CGRect(x: nextButton.frame.origin.x, y: tableView.frame.origin.y + tableView.frame.size.height + 10, width: nextButton.frame.size.width, height: nextButton.frame.size.height)
    cancelButton.frame = CGRect(x: cancelButton.frame.origin.x, y: tableView.frame.origin.y + tableView.frame.size.height + 10, width: cancelButton.frame.size.width, height: cancelButton.frame.size.height)
    
    bgView.frame = CGRect(x: bgView.frame.origin.x, y: bgView.frame.origin.y, width: bgView.frame.size.width, height: cancelButton.frame.origin.y + cancelButton.frame.size.height + 10)
    
    bgView.center = self.center
  }
  
  func updateReasonData() {
    let realm = try! Realm()
    let info = realm.objects(MTOrderCancelReasonInfo.self)
    reasonDataArray.removeAll()
    for (index, element) in info.enumerated() {
    //for couponObj in couponListInfo {
      reasonDataArray.append(element)
    }
    self.tableView.reloadData()
    updateViewSize()
  }
  
  @IBAction func nextButtonAction(_ sender: Any) {
    if selectedReasonItem != -1 {
      if selectedReasonItem < reasonDataArray.count {
        let obj = reasonDataArray[selectedReasonItem]
        self.delegate?.didSelectReason(selectedReason: obj.reasonName)
      }
      removeFromSuperview()
    } else {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "order_reason_empty_order_status_alert_text".localized)
    }
  }
  
  @IBAction func cancelButtonAction(_ sender: Any) {
    removeFromSuperview()
  }
}

extension MTOrderDeclineSelectionView : UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 30
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return reasonDataArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell: MTOrderDeclineTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "OrderDeclineTableViewCellIdentifier") as! MTOrderDeclineTableViewCell
    
    let object = reasonDataArray[indexPath.row]
    
    cell.tag = indexPath.row
    cell.selectionStyle = .none
    cell.reasonLabel.text = object.reasonName
    
    cell.selectButton.tag = indexPath.row
    cell.selectButton.addTarget(self, action: #selector(didSelectCouponCodeButtonAction(_:)), for: .touchUpInside)
    
    if selectedReasonItem == indexPath.row {
      cell.selectButton.setImage(UIImage(named: "radio_button_selected"), for: .normal)
    } else {
      cell.selectButton.setImage(UIImage(named: "radio_button_unselected_dark"), for: .normal)
    }
    return cell
  }
}

extension MTOrderDeclineSelectionView : UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
  
  func didSelectCouponCodeButtonAction(_ sender: Any) {
    if let button = sender as? UIButton {
      if let superview = button.superview {
        if let cell = superview.superview as? MTOrderDeclineTableViewCell {
          let indexPath = tableView.indexPath(for: cell)
          if let index = indexPath {
            cell.selectButton.setImage(UIImage(named: "radio_button_selected"), for: .normal)
            selectedReasonItem = index.row
            tableView.reloadData()
            
            //let offerObj = reasonDataArray[index.row]
            //refCodeTextField.text = offerObj.offerCode
          }
        }
      }
    }
  }
}

