/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTTeamMemberListViewControler
 
 Description: This class is used to show home offer screen for the application.
 
 Created By: Pranay.
 
 Creation Date: 20/07/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import UIKit
import RealmSwift

class MTTeamMemberListViewControler: MTBaseViewController {
  
  @IBOutlet weak var teamMemberTableview: UITableView!
  
  var teamType = MTEnums.TeamMemberSelectedType.none
  var mainPageViewFrame:CGRect?
  var teamDetailDataArray:[MTTeamDetailInfo] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    teamMemberTableview.separatorStyle = .none
    teamMemberTableview.register(UINib.init(nibName: "MTTeamMemberTableViewCell", bundle: nil), forCellReuseIdentifier: "TeamMemberTableViewCellIdentifier")
    
    setLocalization()
    updatePageUI()
    updateTeamMemberList()
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

  }
  
  func setLocalization() {
    
  }

  /// This function is used to update ht elogin screen UI
  func updateTeamMemberList() {
    
    if teamType == .myTeam {
      let realm = try! Realm()
      let offersInfo = realm.objects(MTTeamDetailInfo.self)
      teamDetailDataArray.removeAll()
      for offer in offersInfo {
        if offer.awaitingApproval != "1" {
          teamDetailDataArray.append(offer)
        }
      }
      //offerDetailDataArray.sort(by: {$0.orderDate > $1.orderDate})
      DispatchQueue.main.async {
        if self.teamMemberTableview != nil {
          self.teamMemberTableview.reloadData()
        }
      }
    } else if teamType == .awaitingForApproval {
      let realm = try! Realm()
      let offersInfo = realm.objects(MTTeamDetailInfo.self)
      teamDetailDataArray.removeAll()
      for offer in offersInfo {
        if offer.awaitingApproval == "1" {
          teamDetailDataArray.append(offer)
        }
      }
      //orderHistoryDataArray.sort(by: {$0.orderDate > $1.orderDate})
      DispatchQueue.main.async {
        if self.teamMemberTableview != nil {
          self.teamMemberTableview.reloadData()
        }
      }
    }
  }
}

extension MTTeamMemberListViewControler {

}

extension MTTeamMemberListViewControler : UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let cell: MTTeamMemberTableViewCell = self.teamMemberTableview.dequeueReusableCell(withIdentifier: "TeamMemberTableViewCellIdentifier") as! MTTeamMemberTableViewCell
    let offerObj = teamDetailDataArray[indexPath.row]
    return cell.getHeightOfCell(offerDetailObj: offerObj)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return teamDetailDataArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell: MTTeamMemberTableViewCell = self.teamMemberTableview.dequeueReusableCell(withIdentifier: "TeamMemberTableViewCellIdentifier") as! MTTeamMemberTableViewCell
    let offerObj = teamDetailDataArray[indexPath.row]
    
    cell.updateCellData(offerDetailObj: offerObj)
    cell.selectionStyle = .none
    
    if offerObj.awaitingApproval == "1" {
      cell.cancelButton.tag = indexPath.row
      cell.cancelButton.addTarget(self, action: #selector(cancelOfferButtonAction(_:)), for: .touchUpInside)
      
      cell.editButton.tag = indexPath.row
      cell.editButton.addTarget(self, action: #selector(editOfferButtonAction(_:)), for: .touchUpInside)
    } else {
      cell.deleteButton.tag = indexPath.row
      cell.deleteButton.addTarget(self, action: #selector(cancelOfferButtonAction(_:)), for: .touchUpInside)
    }
    return cell
  }
}

extension MTTeamMemberListViewControler : UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    /*let offerDetailObj = offerDetailDataArray[indexPath.row]
    let offerDetailsVC = MTCommonUtils.viewcontroller(storyboardName: "Main", viewcontrollerID: MTConstant.OfferDetailViewControlerID) as! MTOfferDetailViewControler
    let realm = try! Realm()
    try! realm.write() {
      offerDetailsVC.offerDetailObject = MTOffersDetailInfo(value: offerDetailObj)
    }
    self.navigationController?.pushViewController(offerDetailsVC, animated: true)*/
  }
}

extension MTTeamMemberListViewControler {
  
  @IBAction func cancelOfferButtonAction(_ sender: Any) {
    if let button = sender as? UIButton {
      let teamDetailObj = teamDetailDataArray[button.tag]
      cancelTeamDetail(teamId: teamDetailObj.teamId)
    }
  }
  
  @IBAction func editOfferButtonAction(_ sender: Any) {
    if let button = sender as? UIButton {
      let teamDetailObj = teamDetailDataArray[button.tag]
      let teamDetailsVC = MTCommonUtils.viewcontroller(storyboardName: "Main", viewcontrollerID: MTConstant.TeamMemberDetailViewControllerID) as! MTTeamMemberDetailViewController
      let realm = try! Realm()
      try! realm.write() {
        teamDetailsVC.teamDetailObj = MTTeamDetailInfo(value: teamDetailObj)
      }
      self.navigationController?.pushViewController(teamDetailsVC, animated: true)
    }
  }
  
  func cancelTeamDetail(teamId: String) {
    if MTRechabilityManager.sharedInstance.isRechable {
      MTProgressIndicator.sharedInstance.showProgressIndicator()
      
      MTTeamMemberServiceManager.sharedInstance.deleteTeamDetails(teamID: teamId, onSuccess: { (success) -> Void in
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
        if (success as! Bool) {
          MTLogger.log.info("cancelTeamDetail => ")
          NotificationCenter.default.post(name: NSNotification.Name(rawValue: MTConstant.Notification_RefreshTeamMembers), object: nil)
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
