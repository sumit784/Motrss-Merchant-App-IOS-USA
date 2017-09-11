/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTCollapsibleTableViewHeader.swift
 
 Description: This class is enlarge and colapse table view cell.
 
 Created By: Rohit W.
 
 Creation Date: 22/04/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import UIKit

protocol MTCollapsibleTableViewHeaderDelegate {
  func toggleSection(_ header: MTCollapsibleTableViewHeader, section: Int)
}

class MTCollapsibleTableViewHeader: UITableViewHeaderFooterView {
  
  var delegate: MTCollapsibleTableViewHeaderDelegate?
  var section: Int = 0
  
  let itemImageView = UIImageView()
  let titleLabel = UILabel()
  let arrowImageView = UIImageView()
  
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    arrowImageView.translatesAutoresizingMaskIntoConstraints = false
    //arrowImageView.backgroundColor = UIColor.yellow
    
    itemImageView.frame = CGRect(x: 15, y: 12.5, width: 25, height: 25)
    titleLabel.frame = CGRect(x: 55, y: 0, width: 200, height: 50)
    titleLabel.font = UIFont(name: MTConstant.fontHMavenProRegular, size: 16)
    
    contentView.addSubview(itemImageView)
    contentView.addSubview(titleLabel)
    contentView.addSubview(arrowImageView)
    
    //
    // Call tapHeader when tapping on this header
    //
    addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MTCollapsibleTableViewHeader.tapHeader(_:))))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    contentView.backgroundColor = UIColor.white
    titleLabel.textColor = UIColor.black
    
    //
    // Autolayout the lables
    //
    let views = [
      "itemImageView" : itemImageView,
      "titleLabel" : titleLabel,
      "arrowImageView" : arrowImageView,
      ]
    
    contentView.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|-20-[itemImageView]-10-[titleLabel]-[arrowImageView]-20-|",
      options: [],
      metrics: nil,
      views: views
    ))
    contentView.addConstraint(NSLayoutConstraint(
      item: arrowImageView,
      attribute: .width,
      relatedBy: .equal,
      toItem: nil,
      attribute: .notAnAttribute,
      multiplier: 1.0,
      constant: 18))
    contentView.addConstraint(NSLayoutConstraint(
      item: arrowImageView,
      attribute: .height,
      relatedBy: .equal,
      toItem: nil,
      attribute: .notAnAttribute,
      multiplier: 1.0,
      constant: 15))
    
    contentView.addConstraint(NSLayoutConstraint(item: arrowImageView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .top, multiplier: 1, constant: 10))
    
    contentView.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "V:|-[titleLabel]-|",
      options: [],
      metrics: nil,
      views: views
    ))
    
    contentView.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "V:|-[arrowImageView]-|",
      options: [],
      metrics: nil,
      views: views
    ))
    contentView.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "V:|-[itemImageView]-|",
      options: [],
      metrics: nil,
      views: views
    ))
  }
  
  //
  // Trigger toggle section when tapping on the header
  //
  func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
    guard let cell = gestureRecognizer.view as? MTCollapsibleTableViewHeader else {
      return
    }
    
    delegate?.toggleSection(self, section: cell.section)
  }
  
  func setCollapsed(_ collapsed: Bool) {
    //
    // Animate the arrow rotation (see Extensions.swf)
    //
    arrowImageView.rotate(collapsed ? 0.0 : CGFloat(Double.pi / 2))
  }
}
