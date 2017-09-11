/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTExtensions.swift
 
 Description: This class includes extensions.
 
 Created By: Pranay U.
 
 Creation Date: 25/06/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import Foundation
import UIKit

// MARK: - Status Bar Extension
extension UIApplication {
  var statusBarView: UIView? {
    return value(forKey: "statusBar") as? UIView
  }
}

// MARK: - String Extension
extension String {
  var localized: String {
    return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
  }
  
  func localizedWithComment(_ comment:String) -> String {
    return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: comment)
  }
  func joinWithSpace(firstString:String, secondString:String) -> String{
    let combinedString = firstString + " " + secondString
    return combinedString
  }
  
  func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
    let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
    let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
    
    return boundingBox.height
  }
  
  
  func roundStringTo(places:Int) -> String {
    if let doubleValue = Double(self) {
      return String(format: "%.2f", doubleValue)
    } else {
      return self
    }
  }
}

// MARK: - Color Extension
extension UIColor{
  
  convenience init(hex:Int, alpha:CGFloat = 1.0) {
    self.init(
      red:   CGFloat((hex & 0xFF0000) >> 16) / 255.0,
      green: CGFloat((hex & 0x00FF00) >> 8)  / 255.0,
      blue:  CGFloat((hex & 0x0000FF) >> 0)  / 255.0,
      alpha: alpha
    )
  }
  
  class var sliFadedBlue: UIColor {
    return UIColor(red: 99.0 / 255.0, green: 150.0 / 255.0, blue: 193.0 / 255.0, alpha: 1.0)
  }
  
  class var appThemeColor: UIColor {
    //return UIColor(red: 255.0/255.0, green: 130.0/255.0, blue: 74.0/255.0, alpha: 1.0)
    return UIColor(red: 245.0/255.0, green: 123.0/255.0, blue: 68.0/255.0, alpha: 1.0)
  }
  
  class var dullThemeColor: UIColor {
    return UIColor(red: 255.0/255.0, green: 187.0/255.0, blue: 157.0/255.0, alpha: 1.0)
  }
  
  class var greenTextColor: UIColor {
    return UIColor(red: 35.0/255.0, green: 155.0/255.0, blue: 86.0/255.0, alpha: 1.0)
  }

  class var unselectedBorderColor: UIColor {
    return UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1.0)
  }
  
  class var selectedBorderColor: UIColor {
    return UIColor(red: 225.0/255.0, green: 225.0/255.0, blue: 225.0/255.0, alpha: 1.0)
  }
  
  class var warningColor: UIColor {
    return UIColor(red: 246.0/255.0, green: 117.0/255.0, blue: 117.0/255.0, alpha: 1.0)
  }
  
  class var borderColor: UIColor {
    return UIColor(red: 218.0/255.0, green: 218.0/255.0, blue: 218.0/255.0, alpha: 1.0)
  }
}

// MARK: - Font Extension
extension UIFont {
  class func textStyleFont() -> UIFont {
    if #available(iOS 8.2, *) {
      return UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightSemibold)
    } else {
      // Fallback on earlier versions
      return UIFont.boldSystemFont(ofSize: 14.0)
    }
  }
}

// MARK: - Imageview Extension
extension UIImageView {
  func downloadedFrom(url: String?, contentMode mode: UIViewContentMode = .scaleAspectFit, withDefaultImage defaultImage:UIImage) {
    if url != nil {
      contentMode = mode
      URLSession.shared.dataTask(with: URL.init(string:(url)!)!) { (data, response, error) in
        guard
          let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
          let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
          let data = data, error == nil,
          let image = UIImage(data: data)
          else { return }
          DispatchQueue.main.async() { () -> Void in
            self.image = image
          }
        }.resume()
    } else {
      DispatchQueue.main.async() { () -> Void in
        self.image = defaultImage
      }
    }
  }  
}

// MARK: - UIImage Extension
extension UIImage {
  
  class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
    let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    color.setFill()
    UIRectFill(rect)
    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return image
  }
  
}

// MARK: - UIView Extension
extension UIView {
  func installShadow() {
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOffset = CGSize(width: 1, height: 0)
    layer.shadowRadius = 1.0
    layer.shadowOpacity = 0.5
    let boundsRect = CGRect(x: 0, y: bounds.size.height , width: bounds.size.width, height: 1.0)
    layer.shadowPath = UIBezierPath(rect: boundsRect).cgPath
    layer.masksToBounds = false
  }
  
  func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
    let animation = CABasicAnimation(keyPath: "transform.rotation")
    
    animation.toValue = toValue
    animation.duration = duration
    animation.isRemovedOnCompletion = false
    animation.fillMode = kCAFillModeForwards
    
    self.layer.add(animation, forKey: nil)
  }
}

// MARK: - Button Extension
extension UIButton {
  func addShadow() {
    layer.shadowColor = UIColor.sliFadedBlue.cgColor
    layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
    layer.shadowOpacity = 1.0
    layer.shadowRadius = 0.0
    layer.masksToBounds = false
  }
  
  func showDropDownImage() {
    let imgView = UIImageView(image: UIImage(named: "drop_down_img"))
    imgView.frame = CGRect(x: self.frame.size.width-15, y: self.frame.size.height/2-2.5, width: 10, height: 5)
    self.addSubview(imgView)
    self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
  }
  
  func showSelectedState() {
    self.layer.borderWidth = 1.0
    self.layer.borderColor = UIColor.selectedBorderColor.cgColor
    self.setTitleColor(UIColor.black, for: .normal)
  }
  
  func showUnselectedState() {
    self.layer.borderWidth = 1.0
    self.layer.borderColor = UIColor.selectedBorderColor.cgColor
    self.setTitleColor(UIColor.lightGray, for: .normal)
  }
}

// MARK: - UITextField Extension
extension UITextField {
  func addShadowView() {
    layer.backgroundColor = UIColor.white.cgColor
    layer.borderColor = UIColor.gray.cgColor
    layer.borderWidth = 1.0
    layer.cornerRadius = 5
    layer.masksToBounds = false
    layer.shadowRadius = 2.0
    layer.shadowColor = UIColor.gray.cgColor
    layer.shadowOffset = CGSize.init(width: 1.0, height: 1.0)
    layer.shadowOpacity = 1.0
    layer.shadowRadius = 1.0
  }
  
  func showLightBorder() {
    self.layer.borderWidth = 1.0
    self.layer.borderColor = UIColor.selectedBorderColor.cgColor
  }
}

extension UILabel {
  
  func showUnderline() {
    guard let text = self.text else { return }
    let textRange = NSMakeRange(0, text.characters.count)
    let attributedText = NSMutableAttributedString(string: text)
    attributedText.addAttribute(NSUnderlineStyleAttributeName , value: NSUnderlineStyle.styleSingle.rawValue, range: textRange)
    // Add other attributes if needed
    self.attributedText = attributedText
  }
}


// MARK: - Notification Extension
extension NSNotification.Name {
  static let doctorMarkedasFavourite = NSNotification.Name("doctorMarkedasFavourite")
}


@IBDesignable class TopAlignedLabel: UILabel {
  override func drawText(in rect: CGRect) {
    if let stringText = text {
      let stringTextAsNSString = stringText as NSString
      let labelStringSize = stringTextAsNSString.boundingRect(with: CGSize(width: self.frame.width,height: CGFloat.greatestFiniteMagnitude),
                                                              options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                              attributes: [NSFontAttributeName: font],
                                                              context: nil).size
      super.drawText(in: CGRect(x:0,y: 0,width: self.frame.width, height:ceil(labelStringSize.height)))
    } else {
      super.drawText(in: rect)
    }
  }
  override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    layer.borderWidth = 1
    layer.borderColor = UIColor.black.cgColor
  }
}

extension Double {
  /// Rounds the double to decimal places value
  func roundTo(places:Int) -> Double {
    let divisor = pow(10.0, Double(places))
    return (self * divisor).rounded() / divisor
  }
}

