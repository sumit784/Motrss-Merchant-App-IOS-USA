/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTProgressIndicator.swift
 
 Description: This class is used to show and hide the progress indicator.
 
 Created By: Pranay U.
 
 Creation Date: 20/04/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import Foundation

class MTProgressIndicator {
  
  private var progressView: UIView!;
  private var indicatorView: MTProgressView!;
  private var blackView: UIView!;
  
  static let sharedInstance = MTProgressIndicator()
  
  /**
   Private Init method
   */
  private init() {
    //This prevents others from using the default '()' initializer for this class.
  }
  
  /// This function is used to show the progress indicator
  func showProgressIndicator() {
    
    hideProgressIndicator()
    
    //Get screen size
    let screenSize = UIScreen.main.bounds
    let screenWidth = screenSize.width
    let screenHeight = screenSize.height
    
    progressView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
    //progressView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3)
    
    blackView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    //blackView.backgroundColor = UIColor.black
    blackView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7)
    blackView.layer.cornerRadius = 5.0
    blackView.center = progressView.center
    progressView.addSubview(blackView)
    
    indicatorView = MTProgressView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    indicatorView.center = progressView.center
    progressView.addSubview(indicatorView)
    
    indicatorView.startAnimating()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let rootVC = appDelegate.window?.rootViewController
    if (rootVC?.presentedViewController != nil) {
      //Presented View controller
      let visibleViewController = MTCommonUtils.findVisibleViewController(vc: rootVC!)
      if visibleViewController.navigationController != nil  {
        visibleViewController.navigationController?.view.addSubview(progressView)
      } else {
        visibleViewController.view.addSubview(progressView)
      }
    } else {
      rootVC?.view.addSubview(progressView)
    }
  }
  
  /// This function is used to hide the progress indicator
  func hideProgressIndicator() {
    if indicatorView != nil {
      indicatorView.stopAnimating()
      indicatorView.removeFromSuperview()
      indicatorView = nil
    }
    if progressView != nil {
      progressView.removeFromSuperview()
      progressView = nil
    }
  }
}
