//
//  OpionsTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 20/03/23.
//

import UIKit
import DropDown

let kUserSummary = "User Summary"
let kUserAccess = "User Access"
let kCreateUser = "Create New User"
let kUnitInformation = "Units information"

let kResidentMgmtSummary = "Summary"
let kManageBatch = "Manage Batch Invoice"
let kManageIndividual = "Manage Individual Invoice"


enum OptionType{
    case usermgmt
    case residentmgmt
   case digitalAccess
}


class OpionsTableViewController:BaseTableViewController {
    
    var unitsData = [Unit]()
    
    
     let menu: MenuView = MenuView.getInstance
    
     //Outlets
    @IBOutlet weak var view_SwitchProperty: UIView!
    @IBOutlet weak var lbl_SwitchProperty: UILabel!
    @IBOutlet weak var lbl_Title: UILabel!
     @IBOutlet weak var lbl_UserName: UILabel!
     @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var collection_doorrecords: UICollectionView!
     @IBOutlet weak var view_Background: UIView!
    
     @IBOutlet weak var imgView_Profile: UIImageView!
    var array_Options = [String]()
   
    var option : OptionType!
     override func viewDidLoad() {
         super.viewDidLoad()
         
          let fname = Users.currentUser?.moreInfo?.first_name ?? ""
        let lname = Users.currentUser?.moreInfo?.last_name ?? ""
        self.lbl_UserName.text = "\(fname) \(lname)"
        let role = Users.currentUser?.role
        self.lbl_UserRole.text = role
        imgView_Profile.addborder()
        let profilePic = Users.currentUser?.moreInfo?.profile_picture ?? ""
        if let url1 = URL(string: "\(kImageFilePath)/" + profilePic) {
           // self.imgView_Profile.af_setImage(withURL: url1)
            self.imgView_Profile.af_setImage(
                        withURL: url1,
                        placeholderImage: UIImage(named: "avatar"),
                        filter: nil,
                        imageTransition: .crossDissolve(0.2)
                    )
        }
        else{
            self.imgView_Profile.image = UIImage(named: "avatar")
        }
        view_Background.layer.cornerRadius = 25.0
        view_Background.layer.masksToBounds = true
         setUpCollectionLayout()
         view_SwitchProperty.layer.borderColor = themeColor.cgColor
         view_SwitchProperty.layer.borderWidth = 1.0
         view_SwitchProperty.layer.cornerRadius = 10.0
         view_SwitchProperty.layer.masksToBounds = true
         lbl_SwitchProperty.text = kCurrentPropertyName
         if option == .usermgmt{
             self.lbl_Title.text = "User Management"
             array_Options =  [kUserSummary, kUserAccess, kCreateUser, kUnitInformation]
         }
         else if option == .residentmgmt{
             self.lbl_Title.text = "Resident Management"
             array_Options =  [kResidentMgmtSummary, kManageBatch, kManageIndividual]
         }
         else{
             self.lbl_Title.text = "Digital Access"
             array_Options =  [kDeviceManagement]
         }
     }
     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         self.showBottomMenu()
     }
     override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
         
         self.closeMenu()
     }
    func showBottomMenu(){
    
    menu.delegate = self
    menu.showInView(self.view, title: "", message: "")
  
}
func closeMenu(){
    menu.removeView()
}
     override func getBackgroundImageName() -> String {
         let imgdefault = ""//UserInfoModalBase.currentUser?.data.property.defect_bg ?? ""
         return imgdefault
     }
    func setUpCollectionLayout(){
        let layout =  UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let cellWidth = (kScreenSize.width - 80)/CGFloat(2.0)
        let size = CGSize(width: cellWidth, height: 170 )
        layout.itemSize = size
        collection_doorrecords.collectionViewLayout = layout
    
        self.collection_doorrecords.reloadData()
    }
      

      override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1{
            return 175 * 4 + 180
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
     }
     //MARK: ******  PARSING *********
     
    
     //MARK: UIBUTTON ACTIONS
    @IBAction func actionSwitchProperty(_ sender:UIButton) {

        let dropDown_Unit = DropDown()
        dropDown_Unit.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Unit.dataSource = array_Property.map { $0.company_name }// Array(unitsData.values)
        dropDown_Unit.show()
        dropDown_Unit.selectionAction = { [unowned self] (index: Int, item: String) in
            lbl_SwitchProperty.text = item
            kCurrentPropertyName = item
            let prop = array_Property.first(where:{ $0.company_name == item})
            if prop != nil{
                kCurrentPropertyId = prop!.id
                getPropertyListInfo()
            }
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    @IBAction func actionNext(_ sender: UIButton){
       
       
        
    }
     //MARK: MENU ACTIONS
 
    @IBAction func actionLogout(_ sender: UIButton){
        let alert = UIAlertController(title: "Are you sure you want to logout?", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Logout", style: .default, handler: { action in
            UserDefaults.standard.removeObject(forKey: "UserId")
            kAppDelegate.updateLogoutLogs()
           kAppDelegate.setLogin()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
           
        }))
        self.present(alert, animated: true, completion: nil)
    }
   func goToNotification(){
       var controller: UIViewController!
       for cntroller in self.navigationController!.viewControllers as Array {
           if cntroller.isKind(of: NotificationsTableViewController.self) {
               controller = cntroller
               break
           }
       }
       if controller != nil{
           self.navigationController!.popToViewController(controller, animated: true)
       }
       else{
           let inboxTVC = kStoryBoardMain.instantiateViewController(identifier: "NotificationsTableViewController") as! NotificationsTableViewController
           self.navigationController?.pushViewController(inboxTVC, animated: true)
       }
        
    }
    func goToSettings(){
        var controller: UIViewController!
        for cntroller in self.navigationController!.viewControllers as Array {
            if cntroller.isKind(of: SettingsTableViewController.self) {
                controller = cntroller
               
                break
            }
        }
        if controller != nil{
            self.navigationController!.popToViewController(controller, animated: true)
        }
        else{
        let settingsTVC = kStoryBoardSettings.instantiateViewController(identifier: "SettingsTableViewController") as! SettingsTableViewController
        self.navigationController?.pushViewController(settingsTVC, animated: true)
        }
    }
  
  
 }

extension OpionsTableViewController: MenuViewDelegate{
    func onMenuClicked(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            
            self.navigationController?.popToRootViewController(animated: true)
            break
        case 2:
            self.goToNotification()
            break
        case 3:
            self.goToSettings()
            break
        case 4:
            self.actionLogout(sender)
            break
     
        default:
            break
        }
    }
    
    func onCloseClicked(_ sender: UIButton) {
        
    }
    
    
}

   
   
extension OpionsTableViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array_Options.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "doorRecordCell", for: indexPath) as! DocumentCollectionViewCell
        let file = array_Options[indexPath.item]
       
           
        cell.lbl_DocumentName.text = file
       
        let imgname = file == kUserSummary ? "user_summary" :
        file == kUnitInformation ? "unit_information" :
        file == kUserAccess ? "user_access":
        file == kCreateUser ? "create_user":
        file == kResidentMgmtSummary ? "resid_mgmt_summary":
        file == kManageBatch ? "batch_invoice":
        file == kDeviceManagement ? "digital_access":
       "ind_invoice"
        cell.imgIcon.image = UIImage(named: imgname)
        
        
        cell.view_Outer.tag = indexPath.item
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        cell.view_Outer.addGestureRecognizer(tap)
        
        return cell
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        let type = array_Options[(sender! as UITapGestureRecognizer).view!.tag]
        if type == kUserSummary{
            let userManagementTVC = kStoryBoardMain.instantiateViewController(identifier: "UserManagementTableViewController") as! UserManagementTableViewController
            self.navigationController?.pushViewController(userManagementTVC, animated: true)
        }
        else  if type == kUserAccess{
            let userAccessTVC = kStoryBoardMain.instantiateViewController(identifier: "UserAccessTableViewController") as! UserAccessTableViewController
            userAccessTVC.unitsData = self.unitsData
            self.navigationController?.pushViewController(userAccessTVC, animated: true)
        }
        else if type == kCreateUser{
            let addUserVC = kStoryBoardMain.instantiateViewController(identifier: "AddUserTableViewController") as! AddUserTableViewController
        addUserVC.isToEdit = false
       
            self.navigationController?.pushViewController(addUserVC, animated: true)
        
        }
        else if type == kUnitInformation{
            let addUserVC = kStoryBoardMenu.instantiateViewController(identifier: "UnitIInfoSummaryTableViewController") as! UnitIInfoSummaryTableViewController
       
            self.navigationController?.pushViewController(addUserVC, animated: true)
        
        }
        else if type == kManageBatch{
            let addUserVC = kStoryBoardMain.instantiateViewController(identifier: "ManageBatchInvoiceTableViewController") as! ManageBatchInvoiceTableViewController
       
            self.navigationController?.pushViewController(addUserVC, animated: true)
        
        }
        else if type == kManageIndividual{
            let addUserVC = kStoryBoardMain.instantiateViewController(identifier: "ManageInvoiceTableViewController") as! ManageInvoiceTableViewController
            addUserVC.unitsData = self.unitsData
            self.navigationController?.pushViewController(addUserVC, animated: true)
        
        }
        else if type == kDeviceManagement{
            let deviceTVC = kStoryBoardMenu.instantiateViewController(identifier: "CardSummaryTableViewController") as! CardSummaryTableViewController
            deviceTVC.isCardAccess = false
            deviceTVC.unitsData = self.unitsData
            self.navigationController?.pushViewController(deviceTVC, animated: true)
        
        }
        else{
            
        }
        
    }
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
      
      
    
}
