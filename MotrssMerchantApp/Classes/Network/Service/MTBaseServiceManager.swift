/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTBaseServiceManager.swift
 
 Description: This class is used to create the base serive class for all the services.
 
 Created By: Pranay U.
 
 Creation Date: 25/06/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import Foundation
import Alamofire
import SwiftyJSON

// MARK: - Use an Alamofire RequestAdapter to add headers to all calls in the session

/// Service header adapter to add the multiple header fields
class MTServiceHeadersAdapter: RequestAdapter {
  func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
    var urlRequest = urlRequest
    
    //Add header fields
    urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
    urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    
    return urlRequest
  }
}

class MTBaseServiceManager: NSObject {
  
  /// This function is used to convert given JSON text into dictionary
  ///
  /// - Parameter text: json text
  /// - Returns: dictionary
  func convertToDictionary(text: String?) -> [String: AnyObject]? {
    if text != nil && (text?.characters.count)!>0 {
      if let data = text?.data(using: .utf8) {
        do {
          return try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
        } catch {
          print(error.localizedDescription)
        }
      }      
    }
    return nil
  }

  func isSucceed(responseDict : [String: AnyObject]) -> Bool {
    if let status = responseDict["Status"], self.isNotNull(object: status as AnyObject?) {
      if status.isEqual("success") || status.isEqual("Success") {
        return true
      }
    }
    return false
  }
  
  /// This function is used to find out the error message on the data receved from the server
  ///
  /// - Parameter responseDict: response dictionary
  /// - Returns: Boolean value for the error
  func isErrorMessage(responseDict : [String: AnyObject]?) -> Bool {
    var isContainsErr = false
    
    if let responseDataDict = responseDict {
      if isSucceed(responseDict: responseDataDict) {
        isContainsErr = false
      } else if let message = responseDataDict["Message"], self.isNotNull(object: message as AnyObject?) {
        if let messageStr = message as? String {
          MTCommonUtils.showAlertViewWithTitle(title: "", message: messageStr )
        } else {
          MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_something_went_wrong".localized)
        }
        isContainsErr = true
      } else if let status = responseDataDict["Status"], self.isNotNull(object: status as AnyObject?) {
        if status.isEqual("Failed") {
          isContainsErr = true
          var msgStr = ""
          if let dataDict = responseDataDict["Data"], self.isNotNull(object: dataDict as AnyObject?) {
            let json = JSON(dataDict)
            if let message = json["Message"].string, message.characters.count>0 {
              msgStr = message
            }
          }
          if msgStr.characters.count > 0 {
            MTCommonUtils.showAlertViewWithTitle(title: "", message: msgStr)
          } else {
            MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_something_went_wrong".localized)
          }
        }
      }
    } else {
      isContainsErr = true
      MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_something_went_wrong".localized)
    }
    
    return isContainsErr
  }
  
  /// This function is used to check if the attributes received from server has the appropriate value
  ///
  /// - Parameter object: attribute
  /// - Returns: booealn value
  func isNotNull(object:AnyObject?) -> Bool {
    guard let object = object else {
      return false
    }
    return (isNotNSNull(object: object) && isNotStringNull(object: object))
  }
  
  /// This function is used to check if the attributes received from server has the appropriate value
  ///
  /// - Parameter object: attribute
  /// - Returns: booealn value
  func isNotNSNull(object:AnyObject) -> Bool {
    return object.classForCoder != NSNull.classForCoder()
  }
  
  /// This function is used to check if the attributes received from server has the appropriate value
  ///
  /// - Parameter object: attribute
  /// - Returns: booealn value
  func isNotStringNull(object:AnyObject) -> Bool {
    if let object = object as? String, object.uppercased() == "NULL" || object.uppercased() == "null" || object.uppercased() == "<null>" {
      return false
    }
    return true
  }
  
  /// This function is used to get current time stamp
  ///
  /// - Returns: timestamp string
  func getCurrentTimeStamp() -> String {
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyyMMddHHmmss"
    let timeStamp = formatter.string(from: date)
    return timeStamp
  }
}
