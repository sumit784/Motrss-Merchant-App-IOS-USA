/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTUpdateOrderStatusViewController.swift
 
 Description: This class is used to show the orders history details.
 
 Created By: Pranay.
 
 Creation Date: 22/05/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import Foundation
import RealmSwift
import ALCameraViewController
import AWSS3
import AWSCore

class MTUpdateOrderStatusViewController: MTBaseViewController {
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var contentView: UIView!
  
  @IBOutlet weak var userDetailView: UIView!
  @IBOutlet weak var userDetailTitleLabel: UILabel!
  @IBOutlet weak var userDetailNameLabel: UILabel!
  @IBOutlet weak var userDetailContactTitleLabel: UILabel!
  @IBOutlet weak var userDetailContactLabel: UILabel!
  @IBOutlet weak var userDetailVehicleTitleLabel: UILabel!
  @IBOutlet weak var userDetailVehicleLabel: UILabel!
  @IBOutlet weak var userDetailVehicleNoTitleLabel: UILabel!
  @IBOutlet weak var userDetailVehicleNoLabel: UILabel!
  
  @IBOutlet weak var statusTableView: UITableView!
  @IBOutlet weak var updateStatusButton: UIButton!
  
  var statusDataArray:[MTOrderStatusDataModel] = []
  var orderDetailInfo:MTOrderDetailInfo?
  var selectedStatusData:MTOrderStatusDataModel?
  var isContainAdditionalIssueCell = false
  var issuesImageDataArray:[UIImage] = []
  var issuesTextData = ""
  var statusTextData = ""
  var selectedIndexNumber = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    isShowBackButton = true
    
    let screenSize: CGRect = UIScreen.main.bounds
    self.scrollView.frame = CGRect(x:0, y:0, width:screenSize.width, height:screenSize.height)
    //let height = statusTableView.frame.origin.y + CGFloat(statusDataArray.count * 60)
    let height = CGFloat(900)
    self.scrollView.contentSize = CGSize(width:self.scrollView.frame.width, height:height)
    //self.scrollView.delegate = self
    contentView.frame = CGRect(x:0, y:0, width:screenSize.width, height:height)
    
    //statusTableView.separatorStyle = .none
    statusTableView.register(UINib.init(nibName: "MTOrderStatusTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderStatusTableViewCellIdentifier")
    statusTableView.isScrollEnabled = false
    
    userDetailView.layer.cornerRadius = 3.0
    userDetailView.layer.borderColor = UIColor.selectedBorderColor.cgColor
    userDetailView.layer.borderWidth = 1.0
    
    updateStatusUI()
    setLocalization()
    updateStatusTableData()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  /// This function is used to update ht elogin screen UI
  func updateStatusUI() {
    if let orderInfoObj = self.orderDetailInfo {
      userDetailNameLabel.text = orderInfoObj.userName
      userDetailContactLabel.text = orderInfoObj.contactMobile
      userDetailVehicleLabel.text = orderInfoObj.vehicleCompanyName + " " + orderInfoObj.vehicleModelName
      userDetailVehicleNoLabel.text = orderInfoObj.vehicleState + "-" + orderInfoObj.vehicleNumber
    }
  }
  
  func updateStatusTableData() {
    
    if let orderInfoObj = self.orderDetailInfo {
      if orderInfoObj.orderPickDropOption == "pickup" ||
        orderInfoObj.orderPickDropOption == "Pk_dp_both" {
        
        let item0 = MTOrderStatusDataModel()
        item0.itemName = "order_status_assign_pickup_text".localized
        item0.itemStatus = "405"
        item0.itemIsUpdated = false
        statusDataArray.append(item0)
      }
    }
    let item1 = MTOrderStatusDataModel()
    item1.itemName = "order_status_vehicle_received_text".localized
    item1.itemStatus = "210"
    item1.itemIsUpdated = false
    statusDataArray.append(item1)
    
    let item2 = MTOrderStatusDataModel()
    item2.itemName = "order_status_vehicle_take_for_service_text".localized
    item2.itemStatus = "225"
    item2.itemIsUpdated = false
    statusDataArray.append(item2)
    
    let item3 = MTOrderStatusDataModel()
    item3.itemName = "order_status_issue_found_text".localized
    item3.itemStatus = "230"
    item3.itemIsUpdated = false
    statusDataArray.append(item3)
    
    if self.isShowAdditionalIssueFound() {
      //Inser one more item
      let item = MTOrderStatusDataModel()
      item.itemName = "order_status_add_note_text".localized
      item.itemIsUpdated = false
      item.itemStatus = "0999"
      statusDataArray.append(item)
      
      if let orderInfoObj = self.orderDetailInfo {
        if orderInfoObj.additionalIssuesImages.characters.count>0 {
          let imgArray = orderInfoObj.additionalIssuesImages.components(separatedBy: ",")
          for _ in imgArray {
            self.issuesImageDataArray.append(UIImage(named: "logo_image")!)
          }
        }
      }
    }
    let item4 = MTOrderStatusDataModel()
    item4.itemName = "order_status_service_complete_text".localized
    item4.itemStatus = "235"
    item4.itemIsUpdated = false
    statusDataArray.append(item4)
    
    let item5 = MTOrderStatusDataModel()
    item5.itemName = "order_status_ready_delivery_text".localized
    item5.itemStatus = "240"
    item5.itemIsUpdated = false
    statusDataArray.append(item5)
    
    if let orderInfoObj = self.orderDetailInfo {
      if orderInfoObj.orderPickDropOption == "drop" ||
        orderInfoObj.orderPickDropOption == "Pk_dp_both" {
        
        let item6 = MTOrderStatusDataModel()
        item6.itemName = "order_status_assign_dropto_text".localized
        item6.itemStatus = "401"
        item6.itemIsUpdated = false
        statusDataArray.append(item6)
      }
    }
    
    let item7 = MTOrderStatusDataModel()
    item7.itemName = "order_status_deliverd_text".localized
    item7.itemStatus = "245"
    item7.itemIsUpdated = false
    statusDataArray.append(item7)
    
    let item8 = MTOrderStatusDataModel()
    item8.itemName = "order_status_update_service_notes_text".localized
    item8.itemStatus = "250"
    item8.itemIsUpdated = false
    statusDataArray.append(item8)
    
    let item9 = MTOrderStatusDataModel()
    item9.itemName = "order_status_order_completed_text".localized
    item9.itemStatus = "260"
    item9.itemIsUpdated = false
    statusDataArray.append(item9)
    
    statusTableView.reloadData()
    updateStatusTableView()
  }
  
  func isShowAdditionalIssueFound() -> Bool {
    var retValue = false
    
    if let orderInfoObj = self.orderDetailInfo {
      let statusValue = orderInfoObj.orderStatus
      if statusValue == "225" {
        retValue = true
      } else {
        if statusValue == "230" ||
          statusValue == "235" ||
          statusValue == "240" ||
          statusValue == "245" ||
          statusValue == "250" ||
          statusValue == "260" ||
          statusValue == "320" ||
          statusValue == "325" ||
          statusValue == "401" {
          
          //check for the issue text & image
          if orderInfoObj.additionalIssuesFound.characters.count>0 {
            retValue = true
          }
        }
      }
    }
    
    return retValue
  }
  
  func updateStatusTableView() {
    UIView.animate(withDuration: 0.2, animations: {
      //self.servicesTableview.isHidden = false
      var tableHeight:CGFloat = CGFloat(self.statusDataArray.count * 60)
      if self.issuesImageDataArray.count <= 0 {
        //Do Nothing
      } else if self.issuesImageDataArray.count>0 && self.issuesImageDataArray.count<=5  {
        tableHeight += 80.0
      } else if self.issuesImageDataArray.count>5 {
        tableHeight += 80.0 + 80.0
      }
      if let orderInfoObj = self.orderDetailInfo {
        if orderInfoObj.orderStatus == "245" {
          tableHeight = tableHeight + 60
        }
      }
      //      if self.isContainAdditionalIssueCell {
      //        tableHeight += 140
      //      }
      self.statusTableView.frame = CGRect(x: self.statusTableView.frame.origin.x, y: self.statusTableView.frame.origin.y, width: self.statusTableView.frame.size.width, height: tableHeight)
      
      let height = self.statusTableView.frame.origin.y + self.statusTableView.frame.size.height + 150
      self.scrollView.contentSize = CGSize(width:self.scrollView.frame.width, height:height)
      self.contentView.frame = CGRect(x:0, y:0, width:self.scrollView.frame.size.width, height:height)
    })
  }
  
  /// This function is used to add the localization for the Login screen
  func setLocalization() {
    self.title = "order_status_screen_title_text".localized
    userDetailTitleLabel.text = "order_status_user_details_title_text".localized
    userDetailContactTitleLabel.text = "order_status_contact_title_text".localized
    userDetailVehicleTitleLabel.text = "order_status_vehicle_title_text".localized
    userDetailVehicleNoTitleLabel.text = "order_status_vehicle_number_title_text".localized
    updateStatusButton.setTitle("order_status_update_button_text".localized, for: .normal)
  }
}

extension MTUpdateOrderStatusViewController : UITableViewDataSource {
  
  //  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
  //    return 60
  //  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let cell: MTOrderStatusTableViewCell = self.statusTableView.dequeueReusableCell(withIdentifier: "OrderStatusTableViewCellIdentifier") as! MTOrderStatusTableViewCell
    let statusInfoObj = statusDataArray[indexPath.row]
    return cell.getHeightOfCell(dataModelObj: statusInfoObj, issuesImageDataArr: issuesImageDataArray, orderDetailInfo: self.orderDetailInfo!)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return statusDataArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell: MTOrderStatusTableViewCell = self.statusTableView.dequeueReusableCell(withIdentifier: "OrderStatusTableViewCellIdentifier") as! MTOrderStatusTableViewCell
    
    let statusInfoObj = statusDataArray[indexPath.row]
    cell.orderUpdateTitleLabel.text = statusInfoObj.itemName
    cell.orderUpdateButton.tag = indexPath.row
    cell.orderUpdateButton.addTarget(self, action: #selector(updateOrderStatusButtonAction(_:)), for: .touchUpInside)
    
    if statusInfoObj.itemIsUpdated {
      cell.orderUpdateButton.setImage(UIImage.init(named: "order_selected"), for: .normal)
    } else {
      cell.orderUpdateButton.setImage(UIImage.init(named: "order_select"), for: .normal)
    }
    cell.selectionStyle = .none
    
    updateStatusCell(cell: cell, index: indexPath.row, statusInfoObj: statusInfoObj)
    
    updateCellData(cell: cell, dataModelObj: statusInfoObj)
    
    return cell
  }
  
  func updateStatusCell(cell: MTOrderStatusTableViewCell, index: Int, statusInfoObj: MTOrderStatusDataModel) {
    if let orderInfoObj = self.orderDetailInfo {
      
      if orderInfoObj.orderStatus == "301" {
        
        if let orderInfoObj = self.orderDetailInfo {
          if orderInfoObj.orderPickDropOption == "pickup" ||
            orderInfoObj.orderPickDropOption == "Pk_dp_both" {
            if statusInfoObj.itemStatus == "405" {
              enableCell(cell: cell)
            } else {
              disableCell(cell: cell)
            }
          } else {
            if statusInfoObj.itemStatus == "210" {
              enableCell(cell: cell)
            } else {
              disableCell(cell: cell)
            }
          }
        }
      } else if orderInfoObj.orderStatus == "405" {
        if statusInfoObj.itemStatus == "405" {
          statusCompleteCell(cell: cell)
        } else if statusInfoObj.itemStatus == "210" {
          enableCell(cell: cell)
        } else {
          disableCell(cell: cell)
        }
      } else if orderInfoObj.orderStatus == "210" {
        if statusInfoObj.itemStatus == "405" ||
          statusInfoObj.itemStatus == "210" {
          statusCompleteCell(cell: cell)
        } else if statusInfoObj.itemStatus == "225" {
          enableCell(cell: cell)
        } else {
          disableCell(cell: cell)
        }
      } else if orderInfoObj.orderStatus == "225" {
        if statusInfoObj.itemStatus == "405" ||
          statusInfoObj.itemStatus == "210" ||
          statusInfoObj.itemStatus == "225" {
          statusCompleteCell(cell: cell)
        } else if statusInfoObj.itemStatus == "230" {
          enableCell(cell: cell)
        } else if statusInfoObj.itemStatus == "235" {
          enableCell(cell: cell)
        } else {
          disableCell(cell: cell)
        }
      } else if orderInfoObj.orderStatus == "230" {
        if statusInfoObj.itemStatus == "405" ||
          statusInfoObj.itemStatus == "210" ||
          statusInfoObj.itemStatus == "225" ||
          statusInfoObj.itemStatus == "230" {
          statusCompleteCell(cell: cell)
        } else if statusInfoObj.itemStatus == "235" {
          enableCell(cell: cell)
        } else {
          disableCell(cell: cell)
        }
      } else if orderInfoObj.orderStatus == "235" {
        if statusInfoObj.itemStatus == "405" ||
          statusInfoObj.itemStatus == "210" ||
          statusInfoObj.itemStatus == "225" ||
          statusInfoObj.itemStatus == "230" ||
          statusInfoObj.itemStatus == "235" {
          statusCompleteCell(cell: cell)
        } else if statusInfoObj.itemStatus == "240" {
          enableCell(cell: cell)
        } else {
          disableCell(cell: cell)
        }
      } else if orderInfoObj.orderStatus == "240" {
        
        if let orderInfoObj = self.orderDetailInfo {
          if orderInfoObj.orderPickDropOption == "drop" ||
            orderInfoObj.orderPickDropOption == "Pk_dp_both" {
            
            if statusInfoObj.itemStatus == "405" ||
              statusInfoObj.itemStatus == "210" ||
              statusInfoObj.itemStatus == "225" ||
              statusInfoObj.itemStatus == "230" ||
              statusInfoObj.itemStatus == "235" ||
              statusInfoObj.itemStatus == "240" {
              statusCompleteCell(cell: cell)
            } else if statusInfoObj.itemStatus == "401" {
              enableCell(cell: cell)
            } else {
              disableCell(cell: cell)
            }
          } else {
            if statusInfoObj.itemStatus == "405" ||
              statusInfoObj.itemStatus == "210" ||
              statusInfoObj.itemStatus == "225" ||
              statusInfoObj.itemStatus == "230" ||
              statusInfoObj.itemStatus == "235" ||
              statusInfoObj.itemStatus == "240" {
              statusCompleteCell(cell: cell)
            } else if statusInfoObj.itemStatus == "245" {
              enableCell(cell: cell)
            } else {
              disableCell(cell: cell)
            }
          }
        }
      } else if orderInfoObj.orderStatus == "401" {
        if statusInfoObj.itemStatus == "405" ||
          statusInfoObj.itemStatus == "210" ||
          statusInfoObj.itemStatus == "225" ||
          statusInfoObj.itemStatus == "230" ||
          statusInfoObj.itemStatus == "235" ||
          statusInfoObj.itemStatus == "240" ||
          statusInfoObj.itemStatus == "401" {
          statusCompleteCell(cell: cell)
        } else if statusInfoObj.itemStatus == "245" {
          enableCell(cell: cell)
        } else {
          disableCell(cell: cell)
        }
      } else if orderInfoObj.orderStatus == "245" {
        if statusInfoObj.itemStatus == "405" ||
          statusInfoObj.itemStatus == "210" ||
          statusInfoObj.itemStatus == "225" ||
          statusInfoObj.itemStatus == "230" ||
          statusInfoObj.itemStatus == "235" ||
          statusInfoObj.itemStatus == "240" ||
          statusInfoObj.itemStatus == "401" ||
          statusInfoObj.itemStatus == "245"{
          statusCompleteCell(cell: cell)
        } else if statusInfoObj.itemStatus == "250" {
          enableCell(cell: cell)
        } else {
          disableCell(cell: cell)
        }
      } else if orderInfoObj.orderStatus == "250" {
        if statusInfoObj.itemStatus == "405" ||
          statusInfoObj.itemStatus == "210" ||
          statusInfoObj.itemStatus == "225" ||
          statusInfoObj.itemStatus == "230" ||
          statusInfoObj.itemStatus == "235" ||
          statusInfoObj.itemStatus == "240" ||
          statusInfoObj.itemStatus == "401" ||
          statusInfoObj.itemStatus == "245" ||
          statusInfoObj.itemStatus == "250" {
          statusCompleteCell(cell: cell)
        } else if statusInfoObj.itemStatus == "260" {
          enableCell(cell: cell)
        } else {
          disableCell(cell: cell)
        }
      } else if orderInfoObj.orderStatus == "260" {
        if statusInfoObj.itemStatus == "405" ||
          statusInfoObj.itemStatus == "210" ||
          statusInfoObj.itemStatus == "225" ||
          statusInfoObj.itemStatus == "230" ||
          statusInfoObj.itemStatus == "235" ||
          statusInfoObj.itemStatus == "240" ||
          statusInfoObj.itemStatus == "401" ||
          statusInfoObj.itemStatus == "245" ||
          statusInfoObj.itemStatus == "250" ||
          statusInfoObj.itemStatus == "260" {
          statusCompleteCell(cell: cell)
        } else {
          disableCell(cell: cell)
        }
        
      } else {
        disableCell(cell: cell)
      }
    }
  }
  
  func disableCell(cell: MTOrderStatusTableViewCell) {
    cell.orderUpdateTitleLabel.alpha = 0.5
    cell.orderUpdateButton.alpha = 0.5
    cell.orderUpdateButton.isEnabled = false
  }
  
  func enableCell(cell: MTOrderStatusTableViewCell) {
    cell.orderUpdateTitleLabel.alpha = 1.0
    cell.orderUpdateButton.alpha = 1.0
    cell.orderUpdateButton.isEnabled = true
  }
  
  func statusCompleteCell(cell: MTOrderStatusTableViewCell) {
    cell.orderUpdateTitleLabel.alpha = 1.0
    cell.orderUpdateButton.alpha = 1.0
    cell.orderUpdateButton.isEnabled = false
    cell.orderUpdateButton.setImage(UIImage.init(named: "order_selected"), for: .normal)
  }
  
  func updateCellData(cell: MTOrderStatusTableViewCell, dataModelObj : MTOrderStatusDataModel) {
    
    if dataModelObj.itemStatus == "0999"  {
      
      cell.orderUpdateButton.isHidden = true
      cell.orderUpdateTitleLabel.isHidden = true
      
      cell.statusNotesTextView.isHidden = true
      cell.statusNotesTextView.delegate = nil
      
      cell.issueDetailsTextView.text = issuesTextData
      cell.issueDetailsTextView.isHidden = false
      cell.issueDetailsTextView.delegate = self
      cell.issueDeviderLable.isHidden = false
      cell.issueCaptureImageButton.isHidden = false
      cell.issueCaptureImageButton.isEnabled = true
      cell.issueCaptureImageButton.addTarget(self, action: #selector(uploadIssueImageButtonAction(_:)), for: .touchUpInside)
      
      if let orderInfoObj = self.orderDetailInfo, orderInfoObj.orderStatus != "225" {
        cell.issueDetailsTextView.delegate = nil
        if issuesTextData.characters.count>0 {
          cell.issueDetailsTextView.text = issuesTextData
        } else {
          cell.issueDetailsTextView.text = orderInfoObj.additionalIssuesFound
        }
        cell.issueDetailsTextView.isEditable = false
        cell.issueDetailsTextView.isSelectable = false
        cell.issueCaptureImageButton.isEnabled = false
        
        if orderInfoObj.additionalIssuesImages.characters.count>0 {
          let imgArray = orderInfoObj.additionalIssuesImages.components(separatedBy: ",")
          if imgArray.count > 0 {
            var xPos = 0
            var yPos = 60
            let width = Int(self.view.frame.size.width/5)
            for (index, element) in (imgArray.enumerated()) {
              var countIndex = index
              if index>4 {
                countIndex = countIndex-5
                yPos = 60 + 80
              }
              xPos = width * countIndex
              
              let imgButton = UIButton(frame: CGRect(x: xPos, y: yPos, width: width, height: 80))
              
              //self.issuesImageDataArray.append(UIImage(named: "logo_image")!)
              let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: Int(imgButton.frame.size.height)))
              imageView.tag = index
              //MTCommonUtils.updateOrderImageCache(imageUrl: element, forImage: imageView, placeholder: UIImage(named: "logo_image"), contentMode: .scaleAspectFit)
              MTCommonUtils.updateOrderImageCache(imageUrl: element, forImage: imageView, placeholder: UIImage(named: "logo_image"), contentMode: .scaleAspectFit, downloadHandler: { (newImage, imgTag) in
                //self.issuesImageDataArray.append(newImage)
                self.issuesImageDataArray[imgTag] = newImage
              })
              imageView.layer.cornerRadius = 0.0
              imageView.layer.borderColor = UIColor.selectedBorderColor.cgColor
              imageView.layer.borderWidth = 1.0
              //imageView.backgroundColor = UIColor.clear
              //imgButton.backgroundColor = UIColor.clear
              //imgButton.setImage(element, for: .normal)
              //imgButton.addTarget(self, action: #selector(uploadedIssueImageButtonAction(_:)), for: .touchUpInside)
              imgButton.addSubview(imageView)
              cell.addSubview(imgButton)
            }
          }
        } else {
          updateIssueImagesForCell(cell: cell)
        }
      } else {
        updateIssueImagesForCell(cell: cell)
      }
    } else if dataModelObj.itemStatus == "250" && self.orderDetailInfo?.orderStatus == "245" {
      cell.orderUpdateButton.isHidden = false
      cell.orderUpdateTitleLabel.isHidden = false
      
      cell.issueDetailsTextView.isHidden = true
      cell.issueDetailsTextView.delegate = nil
      cell.issueDeviderLable.isHidden = true
      cell.issueCaptureImageButton.isHidden = true
      cell.issueCaptureImageButton.isEnabled = false
      
      cell.statusNotesTextView.isHidden = false
      cell.statusNotesTextView.delegate = self
    } else {
      cell.orderUpdateButton.isHidden = false
      cell.orderUpdateTitleLabel.isHidden = false
      
      cell.issueDetailsTextView.isHidden = true
      cell.issueDetailsTextView.delegate = nil
      cell.issueDeviderLable.isHidden = true
      cell.issueCaptureImageButton.isHidden = true
      cell.issueCaptureImageButton.isEnabled = false
      
      cell.statusNotesTextView.isHidden = true
      cell.statusNotesTextView.delegate = nil
    }
  }
  
  func updateIssueImagesForCell(cell: MTOrderStatusTableViewCell) {
    if self.issuesImageDataArray.count>0 {
      var xPos = 0
      var yPos = 60
      let width = Int(self.view.frame.size.width/5)
      for (index, element) in (self.issuesImageDataArray.enumerated()) {
        var countIndex = index
        if index>4 {
          countIndex = countIndex-5
          yPos = 60 + 80
        }
        xPos = width * countIndex
        
        let imgButton = UIButton(frame: CGRect(x: xPos, y: yPos, width: width, height: 80))
        imgButton.backgroundColor = UIColor.lightGray
        imgButton.setImage(element, for: .normal)
        imgButton.tag = index
        imgButton.addTarget(self, action: #selector(uploadedIssueImageButtonAction(_:)), for: .touchUpInside)
        cell.addSubview(imgButton)
      }
    }
  }
}


extension MTUpdateOrderStatusViewController : UITableViewDelegate, UITextViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.tag == 999 {
      issuesTextData = textView.text
    } else if textView.tag == 250 {
      statusTextData = textView.text
    }
  }
}

extension MTUpdateOrderStatusViewController {
  
  @IBAction func uploadedIssueImageButtonAction(_ sender: Any) {
    if let button = sender as? UIButton {
      if issuesImageDataArray.count>0 {
        let image = issuesImageDataArray[button.tag]
        showRemoveIssueImageAlert(issueImage: image, imgIndex: button.tag)
      }
    }
  }
  
  @IBAction func uploadIssueImageButtonAction(_ sender: Any) {
    if issuesImageDataArray.count<10 {
      showUploadIssueImageAlert()
    } else {
      MTCommonUtils.showAlertViewWithTitle(title: "", message:"order_status_max_img_count_alert_text".localized)
    }
  }
  
  func showRemoveIssueImageAlert(issueImage: UIImage?, imgIndex: Int) {
    let optionArr:[String] = ["Remove Image"]
    
    MTPickerView.showSingleColPicker("order_status_upload_issue_image_text".localized, data: optionArr, defaultSelectedIndex: 0) {[unowned self] (selectedIndex, selectedValue) in
      
      if selectedIndex == 0 {
        self.issuesImageDataArray.remove(at: imgIndex)
        self.statusTableView.reloadData()
        self.updateStatusTableView()
      }
    }
  }
  
  func showUploadIssueImageAlert() {
    let optionArr:[String] = ["Phone Camera", "Gallery"]
    
    MTPickerView.showSingleColPicker("order_status_upload_issue_image_text".localized, data: optionArr, defaultSelectedIndex: 0) {[unowned self] (selectedIndex, selectedValue) in
      
      let croppingEnabled = true
      if selectedIndex == 0 {
        let cameraViewController = CameraViewController(croppingEnabled: croppingEnabled) { [weak self] image, asset in
          if image != nil {
            self?.issuesImageDataArray.append(image!)
            
            self?.statusTableView.reloadData()
            self?.updateStatusTableView()
          }
          self?.dismiss(animated: true, completion: nil)
        }
        self.present(cameraViewController, animated: true, completion: nil)
      } else if selectedIndex == 1 {
        let cameraViewController = CameraViewController.imagePickerViewController(croppingEnabled: croppingEnabled) { [weak self] image, asset in
          if image != nil {
            self?.issuesImageDataArray.append(image!)
            
            self?.statusTableView.reloadData()
            self?.updateStatusTableView()
          }
          self?.dismiss(animated: true, completion: nil)
        }
        self.present(cameraViewController, animated: true, completion: nil)
      }
    }
  }
  
  /*@IBAction func updateStatusButtonAction(_ sender: Any) {
   if let selectedItem = selectedStatusData {
   if selectedItem.itemIsUpdated {
   //processOrderUpdate(selectedItem: selectedItem)
   showProcessOrderUpdateAlert(selectedItem: selectedItem)
   } else {
   MTCommonUtils.showAlertViewWithTitle(title: "", message: "order_status_empty_order_status_alert_text".localized)
   }
   } else {
   MTCommonUtils.showAlertViewWithTitle(title: "", message: "order_status_empty_order_status_alert_text".localized)
   }
   }*/
  
  @IBAction func updateOrderStatusButtonAction(_ sender: Any) {
    if let button = sender as? UIButton {
      let indexNumber = button.tag
      
      let statusInfoObj = statusDataArray[indexNumber]
      if statusInfoObj.itemStatus == "230" {
        let spaceCount = issuesTextData.characters.filter{$0 == " "}.count
        let newLineCount = issuesTextData.characters.filter{$0 == "\n"}.count
        if issuesTextData.characters.count <= 0 {
          MTCommonUtils.showAlertViewWithTitle(title: "", message: "order_status_empty_issue_details_alert_text".localized)
          return
        } else if issuesTextData.characters.count >= 250 || spaceCount > 30 || newLineCount > 30 {
          MTCommonUtils.showAlertViewWithTitle(title: "", message: "order_status_invalid_issue_details_alert_text".localized)
          return
        }
      }
      
      if statusInfoObj.itemIsUpdated {
        statusInfoObj.itemIsUpdated = false
      } else {
        statusInfoObj.itemIsUpdated = true
        selectedStatusData = statusInfoObj
      }
      /*statusDataArray[indexNumber] = statusInfoObj*/
      /*if statusInfoObj.itemStatus == "230" && statusInfoObj.itemIsUpdated == true {
       //Inser one more item
       let item = MTOrderStatusDataModel()
       item.itemName = "order_status_add_note_text".localized
       item.itemIsUpdated = false
       item.itemStatus = "0999"
       statusDataArray.insert(item, at: indexNumber+1)
       isContainAdditionalIssueCell = true
       } else if statusInfoObj.itemStatus == "230" && statusInfoObj.itemIsUpdated == false {
       statusDataArray.remove(at: indexNumber+1)
       isContainAdditionalIssueCell = false
       }*/
      
      /*statusTableView.reloadData()
       updateStatusTableView()*/
      
      showProcessOrderUpdateAlert(selectedItem: statusInfoObj, indexNumber: indexNumber)
    }
  }
  
  func showProcessOrderUpdateAlert(selectedItem: MTOrderStatusDataModel, indexNumber: Int) {
    
    let message = "order_status_update_confirmation_alert_text".localized + selectedItem.itemName
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
        self.selectedIndexNumber = indexNumber
        self.statusDataArray[indexNumber] = selectedItem
        self.statusTableView.reloadData()
        self.updateStatusTableView()
        
        self.processOrderUpdate(selectedItem: selectedItem)
        
      case .cancel:
        MTLogger.log.info("cancel")
        
      case .destructive:
        MTLogger.log.info("destructive")
      }
    }))
    
    self.present(alert, animated: true, completion: nil)
  }
  
  func processOrderUpdate(selectedItem: MTOrderStatusDataModel) {
    if let orderInfoObj = self.orderDetailInfo {
      if selectedItem.itemStatus == "230" {
        
        //Additional Issue
        var imagesDataArrTxt = ""
        if issuesImageDataArray.count>0 {
          for (index, _) in (self.issuesImageDataArray.enumerated()) {
            if imagesDataArrTxt.characters.count>0 {
              imagesDataArrTxt = imagesDataArrTxt + "," + orderInfoObj.orderId + "_" + "\(index)"
            } else {
              imagesDataArrTxt = orderInfoObj.orderId + "_" + "\(index)"
            }
          }
          
          var successCount = 0
          MTProgressIndicator.sharedInstance.showProgressIndicator()
          for (index, element) in (self.issuesImageDataArray.enumerated()) {
            let imageName = orderInfoObj.orderId + "_" + "\(index)"
            uploadImageToAWSS3(uploadImage: element, imageName: imageName, onSuccess: { (success) in
              successCount += 1
              if successCount == self.issuesImageDataArray.count {
                //All images uploaded to AWS S3
                MTProgressIndicator.sharedInstance.hideProgressIndicator()
                
                self.updateOrderServicefor(orderID: orderInfoObj.orderId, withStatus: selectedItem.itemStatus, addIssuesText: self.issuesTextData, addIssuesImages: imagesDataArrTxt, serviceAddNotes: "")
              }
            }, onFailure: { (failure) in
              MTProgressIndicator.sharedInstance.hideProgressIndicator()
            })
          }
        } else {
          updateOrderServicefor(orderID: orderInfoObj.orderId, withStatus: selectedItem.itemStatus, addIssuesText: issuesTextData, addIssuesImages: imagesDataArrTxt, serviceAddNotes: "")
        }
      } else if selectedItem.itemStatus == "250" {
        updateOrderServicefor(orderID: orderInfoObj.orderId, withStatus: selectedItem.itemStatus, addIssuesText: "", addIssuesImages: "", serviceAddNotes: statusTextData)
      } else {
        updateOrderServicefor(orderID: orderInfoObj.orderId, withStatus: selectedItem.itemStatus, addIssuesText: "", addIssuesImages: "", serviceAddNotes: "")
      }
    }
  }
  
  func updateOrderServicefor(orderID: String, withStatus statusCode: String, addIssuesText: String, addIssuesImages: String, serviceAddNotes: String) {
    
    if statusCode == "260" {
      if MTRechabilityManager.sharedInstance.isRechable {
        MTProgressIndicator.sharedInstance.showProgressIndicator()
        MTOrderServiceManager.sharedInstance.processPayment(orderId: orderID, onSuccess: { (success) in
          
          MTProgressIndicator.sharedInstance.hideProgressIndicator()
          if (success as! Bool) {
            self.processUpdateOrderServicefor(orderID: orderID, withStatus: statusCode, addIssuesText: addIssuesText, addIssuesImages: addIssuesImages, serviceAddNotes: serviceAddNotes)
          } else {
            MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_something_went_wrong".localized)
          }
        }, onFailure: { (failure) in
          MTProgressIndicator.sharedInstance.hideProgressIndicator()
          MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_something_went_wrong".localized)
        })
      } else {
        MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_no_internet".localized)
      }
    } else {
      processUpdateOrderServicefor(orderID: orderID, withStatus: statusCode, addIssuesText: addIssuesText, addIssuesImages: addIssuesImages, serviceAddNotes: serviceAddNotes)
    }
  }
  
  func processUpdateOrderServicefor(orderID: String, withStatus statusCode: String, addIssuesText: String, addIssuesImages: String, serviceAddNotes: String) {
    if MTRechabilityManager.sharedInstance.isRechable {
      MTProgressIndicator.sharedInstance.showProgressIndicator()
      
      MTOrderServiceManager.sharedInstance.updateOrderStatus(orderStatusCode: statusCode, userId: "", addIssuesText: addIssuesText, orderId: orderID, addIssuesImages: addIssuesImages, serviceAddNotes: serviceAddNotes, declineReason:"", timeslotPref: "", onSuccess: { (success) -> Void in
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
        if (success as! Bool) {
          MTLogger.log.info("Updated Order => ")
          
          if statusCode == "225" {
            //Inser one more item
            let item = MTOrderStatusDataModel()
            item.itemName = "order_status_add_note_text".localized
            item.itemIsUpdated = false
            item.itemStatus = "0999"
            self.statusDataArray.insert(item, at: self.selectedIndexNumber+2)
          }
          //if statusCode == "230" && self.issuesImageDataArray.count>0 {
          //  self.issuesImageDataArray.removeAll()
          //}
          let realm = try! Realm()
          try! realm.write {
            self.orderDetailInfo?.orderStatus = statusCode
          }
          self.statusTableView.reloadData()
          
          //NotificationCenter.default.post(name: NSNotification.Name(rawValue: MTConstant.Notification_RefeshOrderStatus), object: nil)
          NotificationCenter.default.post(name: NSNotification.Name(rawValue: MTConstant.Notification_RefeshOrderStatusUI), object: nil)
          if statusCode == "260" {
            self.navigationController?.popToRootViewController(animated: true)
          }
        }
      }) { (failure) -> Void in
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
        MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_something_went_wrong".localized)
      }
    } else {
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_no_internet".localized)
    }
  }
  
  func uploadImageToAWSS3(uploadImage: UIImage, imageName: String, onSuccess successBlock: @escaping ((AnyObject) -> Void), onFailure failureBlock: @escaping ((AnyObject) -> Void)) {
    
    //s3-us-west-1
    let credentialsProvider = AWSStaticCredentialsProvider(accessKey: MTConstant.AWS3AccessKey, secretKey: MTConstant.AWS3SecretKey)
    let configuration = AWSServiceConfiguration(region:AWSRegionType.USWest1, credentialsProvider:credentialsProvider)
    
    AWSServiceManager.default().defaultServiceConfiguration = configuration
    
    let folderName = "order-images"
    let S3BucketName = "motrss-dev-assets/\(folderName)"
    
    let remoteName = String(format:"%@.jpg", imageName)
    MTLogger.log.info("remoteName=> \(remoteName)")
    
    let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(remoteName)
    //let image = UIImage(named: "test")
    let data = UIImageJPEGRepresentation(uploadImage, 0.9)
    do {
      try data?.write(to: fileURL)
    }
    catch {}
    
    let uploadRequest = AWSS3TransferManagerUploadRequest()!
    uploadRequest.body = fileURL
    uploadRequest.key = remoteName
    uploadRequest.bucket = S3BucketName
    uploadRequest.contentType = "image/jpeg"
    uploadRequest.acl = .publicRead
    
    let transferManager = AWSS3TransferManager.default()
    transferManager.upload(uploadRequest).continueWith { (task) -> Any? in
      
      if let error = task.error {
        MTCommonUtils.showAlertViewWithTitle(title: "", message: error.localizedDescription)
        print("Upload failed with error: (\(error.localizedDescription))")
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
        do {
          try FileManager.default.removeItem(at: fileURL as URL)
        } catch {
          print(error)
        }
        failureBlock(false as AnyObject)
      }
      
      if task.result != nil {
        
        DispatchQueue.main.async {
          
          let url = AWSS3.default().configuration.endpoint.url
          let publicURL = url?.appendingPathComponent(uploadRequest.bucket!).appendingPathComponent(uploadRequest.key!)
          if let imgUrl = publicURL?.absoluteString {
            MTLogger.log.info("imgUrl=> \(imgUrl)")
            let fileName = uploadRequest.key!
            MTLogger.log.info("imgUrl=> \(fileName)")
          }
          do {
            MTLogger.log.info("fileURL=> \(fileURL)")
            try FileManager.default.removeItem(at: fileURL as URL)
          } catch {
            print(error)
          }
          successBlock(true as AnyObject)
        }
      }
      
      return nil
    }
  }
  
  func processCustomerPayment(orderID: String, onSuccess successBlock: @escaping ((AnyObject) -> Void), onFailure failureBlock: @escaping ((AnyObject) -> Void)) {
    
    if MTRechabilityManager.sharedInstance.isRechable {
      MTProgressIndicator.sharedInstance.showProgressIndicator()
      
      MTOrderServiceManager.sharedInstance.processPayment(orderId: orderID, onSuccess: { (success) in
        if (success as! Bool) {
          successBlock(true as AnyObject)
        } else {
          failureBlock(false as AnyObject)
        }
      }, onFailure: { (failure) in
        failureBlock(false as AnyObject)
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
        MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_something_went_wrong".localized)
      })
    } else {
      failureBlock(false as AnyObject)
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_no_internet".localized)
    }
  }
}
