/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTMainViewController.swift
 
 Description: This class acts as the main class for app which load the side navigation menu and home screen.
 
 Created By: Rohit W.
 
 Creation Date: 25/06/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import Foundation
import SideMenuController

class MTMainViewController: SideMenuController {
  
  required init?(coder aDecoder: NSCoder) {
    SideMenuController.preferences.drawing.menuButtonImage = UIImage(named: "menu_image")
    SideMenuController.preferences.drawing.sidePanelPosition = .overCenterPanelLeft
    SideMenuController.preferences.drawing.sidePanelWidth = 300
    SideMenuController.preferences.drawing.centerPanelShadow = true
    SideMenuController.preferences.animating.statusBarBehaviour = .showUnderlay
    
    SideMenuController.preferences.interaction.swipingEnabled = false
    SideMenuController.preferences.interaction.panningEnabled = true
    
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    performSegue(withIdentifier: MTConstant.HomeViewSegueIdentifier, sender: nil)
    performSegue(withIdentifier: MTConstant.SideMenuSegueIdentifier, sender: nil)
  }
}
