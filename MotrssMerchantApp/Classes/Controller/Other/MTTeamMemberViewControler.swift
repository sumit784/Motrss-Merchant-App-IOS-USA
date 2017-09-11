/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTTeamMemberViewControler.swift
 
 Description: This class is used to show home offer screen for the application.
 
 Created By: Pranay.
 
 Creation Date: 20/07/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import UIKit
import PagingMenuController

struct TeamMemberPagingMenu: PagingMenuControllerCustomizable {
  
  let teamVC1 = MTCommonUtils.TeamMemberListViewControler(teamType: .myTeam)
  let teamVC2 = MTCommonUtils.TeamMemberListViewControler(teamType: .awaitingForApproval)
  
  var itemNameArr:[String] = ["My Team", "Awaiting Approval"]
  
  init(pageViewFrame: CGRect) {
  }
  
  var componentType: ComponentType {
    return .all(menuOptions: OrdersMenuOptions(menuItemArr: itemNameArr), pagingControllers: [teamVC1, teamVC2])
  }
}

class MTTeamMemberViewControler: MTBaseViewController {
  
  var pageMenuOptions:TeamMemberPagingMenu?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    isShowBackButton = true
    
    setLocalization()
    updatePageUI()
    getAllTeamMembers()
    
    let addButton = UIBarButtonItem(image: UIImage.init(named: "add_address_icon"), style: .plain, target: self, action: #selector(self.moveToAddTeamMemberScreen))
    self.navigationItem.rightBarButtonItem = addButton
    
    NotificationCenter.default.addObserver(self, selector: #selector(getAllTeamMembers), name: NSNotification.Name(rawValue: MTConstant.Notification_RefreshTeamMembers), object: nil)
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
    pageMenuOptions = TeamMemberPagingMenu(pageViewFrame: self.view.frame)
    let pagingMenuController = PagingMenuController(options: pageMenuOptions!)
    //pagingMenuController.delegate = self
    
    addChildViewController(pagingMenuController)
    self.view.addSubview((pagingMenuController.view)!)
    pagingMenuController.didMove(toParentViewController: self)
  }
  
  func setLocalization() {
    self.title = "team_member_screen_title_text".localized
  }
  
  func refreshAllTeamMembers() {
    self.pageMenuOptions?.teamVC1.updateTeamMemberList()
    self.pageMenuOptions?.teamVC2.updateTeamMemberList()
  }
}

extension MTTeamMemberViewControler {
  
  func moveToAddTeamMemberScreen() {
    let teamDetailsVC = MTCommonUtils.viewcontroller(storyboardName: "Main", viewcontrollerID: MTConstant.TeamMemberDetailViewControllerID) as! MTTeamMemberDetailViewController
    teamDetailsVC.isAddTeamMember = true
    self.navigationController?.pushViewController(teamDetailsVC, animated: true)
  }

  
  func getAllTeamMembers() {
    if MTRechabilityManager.sharedInstance.isRechable {
      MTProgressIndicator.sharedInstance.showProgressIndicator()
      
      MTTeamMemberServiceManager.sharedInstance.getAllTeamMemberList(onSuccess: { (success) -> Void in
        MTProgressIndicator.sharedInstance.hideProgressIndicator()
        if (success as! Bool) {
          MTLogger.log.info("getAllTeamMembers => ")
          self.refreshAllTeamMembers()
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
