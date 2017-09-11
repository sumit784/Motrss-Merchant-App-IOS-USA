/*!
 Copyright: Copyright (C) 2017 mobitronics (http://mobitronics.in/).  All Rights Reserved.
 
 File Name:  MTSideMenuController.swift
 
 Description: This class is used to show the side navigation menu.
 
 Created By: Rohit W.
 
 Creation Date: 25/06/17.
 
 Modified By:
 
 Modification Date:
 
 Version: 1.0.0
 */

import UIKit
import RealmSwift
import Kingfisher

struct SectionItems {
  var name: String!
  var image: String!
  var items: [String]!
  var itemsImage: [String]!
  var collapsed: Bool!
  
  init(name: String, image: String, items: [String], itemsImage: [String], collapsed: Bool = true) {
    self.name = name
    self.image = image
    self.items = items
    self.itemsImage = itemsImage
    self.collapsed = collapsed
  }
}

class MTSideMenuController: UIViewController {
  
  @IBOutlet weak var tableview: UITableView!
  @IBOutlet weak var userEmailLabel: UILabel!
  @IBOutlet weak var userNameLabel: UILabel!
  
  var sections = [SectionItems]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    updateUserProfileData()
    tableview.register(UINib.init(nibName: "MTSideMenuTableView", bundle: nil), forCellReuseIdentifier: MTConstant.SideMenuTableViewIdentifier)

    var servicePriceSectionArr:[String] = []
    let realm = try! Realm()
    let userInfo = realm.objects(MTUserInfo.self).first
    if let info = userInfo {
      for merchantType in info.merchantTypes {
        if merchantType.merchantTypeId == "102" {
          servicePriceSectionArr.append("sidemenu_service_price_bike_title_text".localized)
        } else if merchantType.merchantTypeId == "104" {
          servicePriceSectionArr.append("sidemenu_service_price_car_title_text".localized)
        } else if merchantType.merchantTypeId == "111" {
          servicePriceSectionArr.append("sidemenu_service_price_truck_title_text".localized)
        } else if merchantType.merchantTypeId == "105" {
          servicePriceSectionArr.append("sidemenu_service_price_mpv_title_text".localized)
        }
      }
    }
    
    // Initialize the sections array
    sections = [
      SectionItems(name: "sidemenu_home_title_text".localized, image: "menu_home" , items: [], itemsImage: []),
      SectionItems(name: "sidemenu_calendar_title_text".localized, image: "menu_calendar" , items: [], itemsImage: []),
      SectionItems(name: "sidemenu_revenue_title_text".localized, image: "menu_revenue" , items: [], itemsImage: []),
      //SectionItems(name: "sidemenu_quotation_title_text".localized, image: "my_notifications" , items: [], itemsImage: []),
      SectionItems(name: "sidemenu_service_price_title_text".localized, image: "menu_service_price" , items: servicePriceSectionArr, itemsImage: []),
      SectionItems(name: "sidemenu_offers_title_text".localized, image: "menu_offers" , items: [], itemsImage: []),
      SectionItems(name: "sidemenu_team_members_title_text".localized, image: "menu_team_members" , items: [], itemsImage: []),
      SectionItems(name: "sidemenu_profile_title_text".localized, image: "menu_profile" , items: [], itemsImage: []),
      SectionItems(name: "sidemenu_rate_review_title_text".localized, image: "menu_rate_review" , items: [], itemsImage: []),
      //SectionItems(name: "sidemenu_setting_title_text".localized, image: "my_offer" , items: [], itemsImage: []),
      SectionItems(name: "sidemenu_logout_title_text".localized, image: "menu_logout" , items: [], itemsImage: []),
     
      SectionItems(name: "".localized, image: "" , items: [], itemsImage: []),
    ]
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  public func updateUserProfileData() {
    //Update USer DataSource
    let realm = try! Realm()
    let userInfo = realm.objects(MTUserInfo.self).first
    userNameLabel.text = userInfo?.businessName
    userEmailLabel.text = userInfo?.emailID
  }
  
  func showLogoutAlert() {
    let alert = UIAlertController(title: "", message: "sidemenu_my_logout_alert_text".localized, preferredStyle: UIAlertControllerStyle.alert)
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
        //Delete all data and move to login screen
        let realm = try! Realm()
        try! realm.write {
          realm.deleteAll()
        }
        
        //Clear all nsuserdefault
        if let bundle = Bundle.main.bundleIdentifier {
          UserDefaults.standard.removePersistentDomain(forName: bundle)
        }
        
        //Clear all image cache
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let signVC = MTCommonUtils.viewcontroller(storyboardName: "Main", viewcontrollerID: MTConstant.LoginNavigationViewControllerID)
        appDelegate.window?.rootViewController = signVC
        
      case .cancel:
        MTLogger.log.info("cancel")
      case .destructive:
        MTLogger.log.info("destructive")
      }
    }))
    
    self.present(alert, animated: true, completion: nil)
  }
}

//
// MARK: - View Controller DataSource and Delegate
//
extension MTSideMenuController:UITableViewDataSource, UITableViewDelegate {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return sections.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sections[section].items.count
  }
  
  // Cell
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: MTSideMenuTableView = self.tableview.dequeueReusableCell(withIdentifier: MTConstant.SideMenuTableViewIdentifier) as! MTSideMenuTableView
    
    cell.subItemTitleLable.text = ""
    if let titles = sections[(indexPath as NSIndexPath).section].items {
      if titles.count>0 {
        let title = titles[indexPath.row]
        cell.subItemTitleLable.text = title
        
      }
    }
    cell.subItemImageView.image = UIImage(named: "")
    if let subItemImage = sections[(indexPath as NSIndexPath).section].itemsImage {
      if subItemImage.count>0 {
        let imgName = subItemImage[indexPath.row]
        cell.subItemImageView.image = UIImage(named: imgName)
        cell.subItemImageView.contentMode = .scaleAspectFit
      }
    }
    cell.selectionStyle = .none
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return sections[(indexPath as NSIndexPath).section].collapsed! ? 0 : 50.0
  }
  
  // Header
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? MTCollapsibleTableViewHeader ?? MTCollapsibleTableViewHeader(reuseIdentifier: "header")
    
    let sectionName = sections[section].name
    if (sectionName?.characters.count)!>0 {
      header.titleLabel.text = sectionName
      header.itemImageView.image = UIImage(named: sections[section].image)
      header.itemImageView.contentMode = .scaleAspectFit
      
      if sectionName == "sidemenu_service_price_title_text".localized  {
        header.arrowImageView.image = UIImage(named: "down_arrow_image")
      } else {
        header.arrowImageView.image = UIImage(named: "")
      }
      
      header.setCollapsed(sections[section].collapsed)
      
      header.section = section
      header.delegate = self
    } else {
      header.titleLabel.text = ""
      header.itemImageView.image = UIImage(named: "")
      header.arrowImageView.image = UIImage(named: "")
    }
    
    return header
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 50.0
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 1.0
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let titles = sections[(indexPath as NSIndexPath).section].items {
      if titles.count>0 {
        let title = titles[indexPath.row]
        MTLogger.log.info("title \(title)")
        moveToMainDetailVCForItem(title: title)
      }
    }
  }
  
  func moveToMainDetailVCForItem(title: String) {
    if title == "sidemenu_service_price_bike_title_text".localized {
      sideMenuController?.view.tag = 110
      sideMenuController?.toggle()
      
    } else if title == "sidemenu_service_price_car_title_text".localized {
      sideMenuController?.view.tag = 111
      sideMenuController?.toggle()
      
    } else if title == "sidemenu_service_price_truck_title_text".localized {
      sideMenuController?.view.tag = 112
      sideMenuController?.toggle()
      
    } else if title == "sidemenu_service_price_mpv_title_text".localized {
      sideMenuController?.view.tag = 113
      sideMenuController?.toggle()
    }
  }
}

//
// MARK: - Section Header Delegate
//
extension MTSideMenuController: MTCollapsibleTableViewHeaderDelegate {
  
  func toggleSection(_ header: MTCollapsibleTableViewHeader, section: Int) {
    
    if section == 3 {
      //do enlarge collapse
      let collapsed = !sections[section].collapsed
      
      // Toggle collapse
      sections[section].collapsed = collapsed
      header.setCollapsed(collapsed)
      
      // Adjust the height of the rows inside the section
      tableview.beginUpdates()
      for i in 0 ..< sections[section].items.count {
        tableview.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
      }
      tableview.endUpdates()
    } else {
      switch section {
      case 0:
        //Go to my order //Home
        sideMenuController?.view.tag = 100
        sideMenuController?.toggle()
        break
      case 1:
        //Calendar
        sideMenuController?.view.tag = 101
        sideMenuController?.toggle()
        break
      case 2:
        //Revenue
        sideMenuController?.view.tag = 102
        sideMenuController?.toggle()
        break
      /*case 3:
        //Quotation
        sideMenuController?.view.tag = 103
        sideMenuController?.toggle()
        break*/
      case 3:
        //Service Price
        //sideMenuController?.view.tag = 104
        //sideMenuController?.toggle()
        break
      case 4:
        //Offers
        sideMenuController?.view.tag = 105
        sideMenuController?.toggle()
        break
      case 5:
        //Team Members
        sideMenuController?.view.tag = 106
        sideMenuController?.toggle()
        break
      case 6:
        //Profile
        sideMenuController?.view.tag = 107
        sideMenuController?.toggle()
        break
      case 7:
        //Rate Review
        sideMenuController?.view.tag = 108
        sideMenuController?.toggle()
        break
      /*case 9:
        //Setting
        sideMenuController?.view.tag = 109
        sideMenuController?.toggle()
        break*/
      case 8:
        //Logout
        showLogoutAlert()
        break
        
      default:
        break
      }
    }
  }
}




