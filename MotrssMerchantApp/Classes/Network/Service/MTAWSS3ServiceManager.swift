/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTAWSS3ServiceManager.swift
 
 Description: This class is used to get data from S3.
 
 Created By: Pranay U.
 
 Creation Date: 11/08/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import UIKit
import AWSS3
import AWSCore
import RealmSwift
import SwiftyJSON

class MTAWSS3ServiceManager: MTBaseServiceManager {
  
  /**
   Shared instance to prepare the singleton class of ProgressIndicator
   */
  static let sharedInstance = MTAWSS3ServiceManager()
  
  //This prevents others from using the default '()' initializer for this class.
  private override init() {
    super.init()
  }
  
  /// This service is used to fetch file from AWS S3
  ///
  func getAWSS3DataFor(folderName: String, remoteFileName: String, onSuccess successBlock: @escaping ((AnyObject) -> Void), onFailure failureBlock: @escaping ((AnyObject) -> Void)) {
    
    let accessKey = MTConstant.AWS3AccessKey
    let secretKey = MTConstant.AWS3SecretKey
    
    let credentialsProvider = AWSStaticCredentialsProvider(accessKey: accessKey, secretKey: secretKey)
    let configuration = AWSServiceConfiguration(region:AWSRegionType.USWest1, credentialsProvider:credentialsProvider)
    
    AWSServiceManager.default().defaultServiceConfiguration = configuration
    
    //let folderName = "cache"
    let S3BucketName = "motrss-dev-assets/\(folderName)"
    
    //let remoteName = "getparentcatlist.json"
    //MTLogger.log.info("remoteName=> \(remoteName)")
    
    let downloadingFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(remoteFileName)
    MTLogger.log.info("downloadingFileURL=> \(downloadingFileURL)")
    
    let request = AWSS3TransferManagerDownloadRequest()
    
    if let downloadRequest = request {
      downloadRequest.bucket = S3BucketName
      downloadRequest.key = remoteFileName
      downloadRequest.downloadingFileURL = downloadingFileURL
      
      let transferManager = AWSS3TransferManager.default()
      transferManager.download(downloadRequest).continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask<AnyObject>) -> Any? in
        
        if let error = task.error as NSError? {
          if error.domain == AWSS3TransferManagerErrorDomain, let code = AWSS3TransferManagerErrorType(rawValue: error.code) {
            switch code {
            case .cancelled, .paused:
              break
            default:
              //print("Error downloading: \(String(describing: downloadRequest.key)) Error: \(error)")
              MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_something_went_wrong".localized)
              failureBlock(false as AnyObject)
            }
          } else {
            //print("Error downloading: \(String(describing: downloadRequest.key)) Error: \(error)")
            MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_something_went_wrong".localized)
            failureBlock(false as AnyObject)
          }
          return nil
        }
        let downloadOutput = task.result
        MTLogger.log.info("downloadOutput=> \(String(describing: downloadOutput))")
        do {
          let fileContent = try String(contentsOf: downloadingFileURL, encoding: String.Encoding.utf8)
          MTLogger.log.info("fileContent=> \(fileContent)")
          
          successBlock(fileContent as AnyObject)
        } catch {
          MTCommonUtils.showAlertViewWithTitle(title: "", message: "error_something_went_wrong".localized)
          failureBlock(false as AnyObject)
        }
        return nil
      })
    }
  }
  
//  func updateParentCategoryData(categoryFileData: String, onSuccess successBlock: @escaping ((AnyObject) -> Void), onFailure failureBlock: @escaping ((AnyObject) -> Void)) {
//    
//    let json = JSON(parseJSON: categoryFileData)
//    if let status = json["Status"].string, status == "Success" {
//      
//      if let dataArray = json["Data"].array {
//        
//        let realm = try! Realm()
//        //Delete Categories Object
//        try! realm.write {
//          realm.delete(realm.objects(MTParentCategoryInfo.self))
//        }
//        
//        for dictionary in dataArray {
//          
//          let serviceCategoryInfo = MTParentCategoryInfo()
//          
//          if let categoryName = dictionary["name"].string {
//            serviceCategoryInfo.categoryName = categoryName
//          }
//          if let categoryId = dictionary["parent_category"].string {
//            serviceCategoryInfo.categoryId = categoryId
//          }
//          if let categoryName = dictionary["root_category"].string {
//            serviceCategoryInfo.rootCategoryId = categoryName
//          }
//          if let vehicleTypeId = dictionary["vehicle_type_id"].string {
//            serviceCategoryInfo.vehicleTypeId = vehicleTypeId
//          }
//          if let merchantTypeId = dictionary["fk_merchant_type_id"].string {
//            serviceCategoryInfo.merchantTypeId = merchantTypeId
//          }
//          
//          //Update database
//          try! realm.write {
//            realm.add(serviceCategoryInfo)
//          }
//        }
//        successBlock(true as AnyObject)
//      } else {
//        failureBlock(false as AnyObject)
//      }
//    } else {
//      failureBlock(false as AnyObject)
//    }
//  }
  
  func updateCategorySubCategoryAndProductDetails(categoryFileData: String, onSuccess successBlock: @escaping ((AnyObject) -> Void), onFailure failureBlock: @escaping ((AnyObject) -> Void)) {
    
    let json = JSON(parseJSON: categoryFileData)
    if let status = json["Status"].string, status == "Success" {
      
      if let mainDataArray = json["Data"].array {
        
        //let parentCategoryId = MTBookingServiceDataModel.sharedInstance.bookServiceParentCategoryID
        //let parentCategoryId = ""
        let realm = try! Realm()
        //Delete Categories Object for that parent catgory
        try! realm.write {
          //let filterString = String(format: "parentCategoryType == '%@'", categoryType)
          realm.delete(realm.objects(MTServiceCategoryInfo.self))
        }
        
        for dataDict in mainDataArray {
          if let twoWheelerArr = dataDict["2_wheeler"].array {
            UpdateCategorySubcategoryAndProductDataInDB(categoryType: "2_wheeler", dataArray: twoWheelerArr)
          }
          if let fourWheelerArr = dataDict["4_wheeler"].array {
            UpdateCategorySubcategoryAndProductDataInDB(categoryType: "4_wheeler", dataArray: fourWheelerArr)
          }
        }

        successBlock(true as AnyObject)
      } else {
        failureBlock(false as AnyObject)
      }
    } else {
      failureBlock(false as AnyObject)
    }
  }
  
  func UpdateCategorySubcategoryAndProductDataInDB(categoryType: String, dataArray: [JSON]) {
    
    for dictionary in dataArray {
      
      let serviceCategoryInfo = MTServiceCategoryInfo()
      
      //Main Categories
      serviceCategoryInfo.parentCategoryType = categoryType
      
      if let categoryId = dictionary["catid"].string {
        serviceCategoryInfo.categoryId = categoryId
      }
      if let categoryName = dictionary["catname"].string {
        serviceCategoryInfo.categoryName = categoryName
      }
      if let categoryImage = dictionary["catImage"].string {
        serviceCategoryInfo.categoryImage = categoryImage
      }
      
      //Sub Categories
      if let subCtegoriesArray = dictionary["subCatList"].array {
        
        for subCategoryDict in subCtegoriesArray {
          
          let subCategoryInfo = MTSubCategoryInfo()
          
          //Cat Id & SubCat Id
          subCategoryInfo.parentCategoryType = categoryType
          subCategoryInfo.categoryId = serviceCategoryInfo.categoryId
          subCategoryInfo.categoryName = serviceCategoryInfo.categoryName
          
          if let subCategoryId = subCategoryDict["subcatid"].string {
            subCategoryInfo.subCategoryId = subCategoryId
          }
          if let subCategoryName = subCategoryDict["subcatname"].string {
            subCategoryInfo.subCategoryName = subCategoryName
          }
          if let subCategoryImage = subCategoryDict["subcaticonimage"].string {
            subCategoryInfo.subCategoryImage = subCategoryImage
          }
          
          //Subcategory Products
          if let productsArray = subCategoryDict["prodlist"].array {
            
            for productDict in productsArray {
              
              let productsInfo = MTSubCategoryProductInfo()
              
              //Cat Id & SubCat Id
              productsInfo.parentCategoryType = categoryType
              productsInfo.categoryId = serviceCategoryInfo.categoryId
              productsInfo.categoryName = serviceCategoryInfo.categoryName
              productsInfo.subCategoryId = subCategoryInfo.subCategoryId
              productsInfo.subCategoryName = subCategoryInfo.subCategoryName
              
              if let productId = productDict["id"].string {
                productsInfo.productId = productId
              }
              if let productName = productDict["name"].string {
                productsInfo.productName = productName
              }
              if let priceVehicleType1 = productDict["price_vehicle_type_1"].string {
                productsInfo.priceVehicleType1 = priceVehicleType1
              }
              if let priceVehicleType1Avg = productDict["price_vehicle_type_1_avg"].string {
                productsInfo.priceVehicleType1Avg = priceVehicleType1Avg
              }
              if let priceVehicleType2 = productDict["price_vehicle_type_2"].string {
                productsInfo.priceVehicleType2 = priceVehicleType2
              }
              if let priceVehicleType2Avg = productDict["price_vehicle_type_2_avg"].string {
                productsInfo.priceVehicleType2Avg = priceVehicleType2Avg
              }
              if let priceVehicleType3 = productDict["price_vehicle_type_3"].string {
                productsInfo.priceVehicleType3 = priceVehicleType3
              }
              if let priceVehicleType3Avg = productDict["price_vehicle_type_3_avg"].string {
                productsInfo.priceVehicleType3Avg = priceVehicleType3Avg
              }
              if let priceVehicleType7 = productDict["price_vehicle_type_7"].string {
                productsInfo.priceVehicleType7 = priceVehicleType7
              }
              if let priceVehicleType7Avg = productDict["price_vehicle_type_7_avg"].string {
                productsInfo.priceVehicleType7Avg = priceVehicleType7Avg
              }
              if let priceVehicleType15 = productDict["price_vehicle_type_15"].string {
                productsInfo.priceVehicleType15 = priceVehicleType15
              }
              if let priceVehicleType15Avg = productDict["price_vehicle_type_15_avg"].string {
                productsInfo.priceVehicleType15Avg = priceVehicleType15Avg
              }
              //Get Packages
              if let isPackage = productDict["is_package"].string {
                productsInfo.isPackage = isPackage
              }
              if let packageArr = productDict["packageprodlist"].array {
                
                for package in packageArr {
                  
                  let packageInfo = MTProductPackageInfo()
                  
                  if let itemId = package["id"].string {
                    packageInfo.itemId = itemId
                  }
                  if let itemName = package["name"].string {
                    packageInfo.itemName = itemName
                  }
                  if let itemPrice = package["price"].string {
                    packageInfo.itemPrice = itemPrice
                  }
                  if let priceVehicleType1 = package["price_vehicle_type_1"].string {
                    packageInfo.priceVehicleType1 = priceVehicleType1
                  }
                  if let priceVehicleType2 = package["price_vehicle_type_2"].string {
                    packageInfo.priceVehicleType2 = priceVehicleType2
                  }
                  if let priceVehicleType3 = package["price_vehicle_type_3"].string {
                    packageInfo.priceVehicleType3 = priceVehicleType3
                  }
                  if let priceVehicleType7 = package["price_vehicle_type_7"].string {
                    packageInfo.priceVehicleType7 = priceVehicleType7
                  }
                  if let priceVehicleType15 = package["price_vehicle_type_15"].string {
                    packageInfo.priceVehicleType15 = priceVehicleType15
                  }
                  
                  productsInfo.packageList.append(packageInfo)
                }
              }
              
              subCategoryInfo.subCategoryProductList.append(productsInfo)
            }
          }
          
          serviceCategoryInfo.subCategoryList.append(subCategoryInfo)
        }
      }
      
      let realm = try! Realm()
      //Update database
      try! realm.write {
        realm.add(serviceCategoryInfo)
      }
    }
  }
}
