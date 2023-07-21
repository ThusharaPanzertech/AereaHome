//
//  SystemAccessTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 05/07/23.
//

import UIKit
import DropDown
var systemaccess_selection = [String: [String: [Int]]]()
var systemaccess_moduleselection = [String: Int]()
class SystemAccessTableViewController:  BaseTableViewController {
    //Outlets
    @IBOutlet weak var view_SwitchProperty: UIView!
    @IBOutlet weak var lbl_SwitchProperty: UILabel!
    @IBOutlet weak var lbl_Title: UILabel!

    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var imgView_Profile: UIImageView!

    let menu: MenuView = MenuView.getInstance
    @IBOutlet weak var table_SystemAccessList: UITableView!
    var dataSource = DataSource_SystemAccess()
    var user: UserModal!
   
    var array_Users = [UserAccessDataModal]()
    var array_Modules = [Module]()
    var roles = [String: String]()
    var buildings = [String: String]()
    let alertView_message: MessageAlertView = MessageAlertView.getInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        lbl_Title.text = "Manage System Access: \(self.user!.name) \(self.user!.last_name)"
        view_SwitchProperty.layer.borderColor = themeColor.cgColor
        view_SwitchProperty.layer.borderWidth = 1.0
        view_SwitchProperty.layer.cornerRadius = 10.0
        view_SwitchProperty.layer.masksToBounds = true
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
       
          let fname = Users.currentUser?.moreInfo?.first_name ?? ""
        let lname = Users.currentUser?.moreInfo?.last_name ?? ""
        self.lbl_UserName.text = "\(fname) \(lname)"
        let role = Users.currentUser?.role
        self.lbl_UserRole.text = role
        table_SystemAccessList.dataSource = dataSource
        table_SystemAccessList.delegate = dataSource
        dataSource.parentVc = self
        setUpUI()
        getUserAccessSummary()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //selectedRowIndex_Feedback = -1
        self.showBottomMenu()
        
       
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.closeMenu()
    }
   
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
       
        if indexPath.row == 1{
           
            
             let   ht = (110 * array_Users.count)  + 150 + (100 * array_Users.count)
            
            
            return CGFloat(ht)
        
        }
        if indexPath.row == 2{
           
           
            return  self.array_Users.count == 0 ? 0 :  super.tableView(tableView, heightForRowAt: indexPath)
        
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
        
      
    }
    func showBottomMenu(){
    
    menu.delegate = self
    menu.showInView(self.view, title: "", message: "")
  
}
func closeMenu(){
    menu.removeView()
}
    func setUpUI(){
       
        lbl_SwitchProperty.text = kCurrentPropertyName
        
        view_Background.layer.cornerRadius = 25.0
        view_Background.layer.masksToBounds = true
      
        imgView_Profile.addborder()
       
     
       
    }
    //MARK: ******  PARSING *********
   
    func getUserAccessSummary(){
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.get_SystemAccessSummary(parameters: ["login_id":userId, "user_id": self.user.id!], completion: { status, result, error in
            systemaccess_moduleselection.removeAll()
            systemaccess_selection.removeAll()
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? UserAccessSummaryBase){
                    self.array_Users = response.users
                     self.array_Modules = response.modules
                    self.roles = response.roles
                     self.dataSource.array_Users = self.array_Users
                    self.dataSource.array_Modules = self.array_Modules
                     self.buildings = response.buildings
                    
                     
                     for (indx,userObj) in self.array_Users.enumerated(){
                         let val = ["\(indx)": 0]
                         systemaccess_moduleselection["\(indx)"] = 0
                        // systemaccess_selection["\(userObj.id)"] = userObj.user_access
                         
                         if userObj.user_access.keys.count == 0{
                                                     var modSelection = [String: [Int]]()
                                                     for mod in self.array_Modules{
                                                         modSelection["\(mod.id)"] = [0,0,0,0]
                                                     }
                                                     systemaccess_selection["\(userObj.id)"] = modSelection
                                                 }
                                                 else{
                                                     systemaccess_selection["\(userObj.id)"] = userObj.user_access
                                                 }
                         
                         
                         
                     }
                         
                         
                         
                         
//                         if userObj.user_access.keys.count == 0{
//                             var modSelection = [String: [Int]]()
//                             for mod in self.array_Modules{
//                                 let val = ["\(mod.id)": [0,0,0,0]]
//                                 modSelection.append(val)
//                             }
//                             systemaccess_selection["\(userObj.id)"] = modSelection
//                         }
//                         else{
//                             systemaccess_selection["\(userObj.id)"] = userObj.user_access
//                         }
                         
                     
                    if self.array_Users.count == 0{
                        //self.lbl_NoRecords.isHidden = false
                        self.table_SystemAccessList.isHidden = true
                    }
                    else{
                        //self.lbl_NoRecords.isHidden = true
                        self.table_SystemAccessList.isHidden = false
                       // self.view_NoRecords.removeFromSuperview()
                    }
                    DispatchQueue.main.async {
                       
                       
                        
                        
                    
                        self.table_SystemAccessList.reloadData()
                        self.tableView.reloadData()
                    }
                }
        }
            else if error != nil{
                self.displayErrorAlert(alertStr: "\(error!.localizedDescription)", title: "Alert")
            }
            else{
                self.displayErrorAlert(alertStr: "Something went wrong.Please try again", title: "Alert")
            }
        })
    }
   
  
  
         
    
    func updateSystemAccess(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        
        
        
        
        let params = NSMutableDictionary()
        params.setValue("\(userId)", forKey: "login_id")
        params.setValue("\(self.user.id!)", forKey: "user_id")
       
        
        
        
        
        var ids = [String]()
        for obj in array_Users{
            ids.append("\(obj.id)")
            let data = systemaccess_selection["\(obj.id)"]
            for mod in self.array_Modules{
                if systemaccess_selection["\(obj.id)"] != nil{
                    let accessVal = systemaccess_selection["\(obj.id)"]!["\(mod.id)"]
                    if accessVal != nil{
                        if accessVal!.count > 0{
                            let isEnabled = accessVal![0]
                            params.setValue("\(isEnabled)", forKey: "mod_\(mod.id)_pid_\(obj.id)")
                        }
                    }
                }
                
            }
            
        }
        params.setValue(ids, forKey: "punitids")
        
        
        ApiService.update_SystemAccess(parameters: params as! [String : Any], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? DeleteUserBase){
                     DispatchQueue.main.async {
                         self.alertView_message.delegate = self
                         self.alertView_message.showInView(self.view_Background, title: "System Access has been updated", okTitle: "Home", cancelTitle: "View User Management")
                         
                     }
                }
        }
            else if error != nil{
                self.displayErrorAlert(alertStr: "\(error!.localizedDescription)", title: "Alert")
            }
            else{
                self.displayErrorAlert(alertStr: "Something went wrong.Please try again", title: "Alert")
            }
        })
    }
    
    //MARK: UIBUTTON ACTION
   
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
    @IBAction func actionSubmit(_ sender:UIButton) {
        self.updateSystemAccess()
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
    @IBAction func actionUserManagement(_ sender: UIButton){
        let userManagementTVC = kStoryBoardMain.instantiateViewController(identifier: "UserManagementTableViewController") as! UserManagementTableViewController
        self.navigationController?.pushViewController(userManagementTVC, animated: true)
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

class DataSource_SystemAccess: NSObject, UITableViewDataSource, UITableViewDelegate {
    var parentVc: UIViewController!
    var array_Users = [UserAccessDataModal]()
    var array_Modules = [Module]()
    var roles = [String: String]()
   
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return array_Users.count;

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "accessCell") as! SystemAccessTableViewCell
               
        cell.collectionViewAccess.dataSource = self
        cell.collectionViewAccess.delegate = self
        

        cell.collectionViewAccess.isScrollEnabled = true
      
        cell.collectionViewAccess.tag = indexPath.section
        DispatchQueue.main.async {
            cell.collectionViewAccess.reloadData()
        }
        return cell
          
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
                return 95
            
       
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if array_Users.count == 0{
            return nil
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! AssignDeviceHeaderTableViewCell
            let user = array_Users[section]
            cell.lbl_Building.text = user.building == "" ? "-" : user.building
            cell.lbl_Unit.text = user.unit == "" ? "-" : "\(user.unit)"
            
           
            
            cell.btn_CheckAll.tag =  section
            
            cell.btn_CheckAll.addTarget(self, action: #selector(self.actionSelectAll(_:)), for: .touchUpInside)
            if systemaccess_moduleselection["\(section)"] == 0{
                cell.btn_CheckAll.isSelected = false
            }
            else{
                cell.btn_CheckAll.isSelected = true
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if array_Users.count == 0{
            return 0
        }
        else{
            return 92
            
            
        }
        
    }
   
    @IBAction func actionSelectAll(_ sender:UIButton){
        sender.isSelected = !sender.isSelected
        let user = array_Users[sender.tag]
       
        if sender.isSelected == true{
            systemaccess_moduleselection["\(sender.tag)"] = 1
           let val = [1,1,1,1]
            var modSelection = [String: [Int]]()
            for mod in self.array_Modules{
                modSelection["\(mod.id)"] = val
            }
            systemaccess_selection["\(user.id)"] = modSelection
           
        }
        else{
            systemaccess_moduleselection["\(sender.tag)"] = 0
            let val = [0,0,0,0]
          
            var modSelection = [String: [Int]]()
            for mod in self.array_Modules{
                modSelection["\(mod.id)"] = val
            }
            systemaccess_selection["\(user.id)"] = modSelection
           
            
        }
        DispatchQueue.main.async {
            (self.parentVc as! SystemAccessTableViewController).table_SystemAccessList.reloadData()
        }
        
        
        
    }
      
}
extension DataSource_SystemAccess: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array_Modules.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "systemaceesscell", for: indexPath) as! SystemAccessColllectionViewCell
        let module = array_Modules[indexPath.item]
       
       
        cell.btn_Checkbox.tag = module.id
        cell.btn_Checkbox.addTarget(self, action: #selector(self.actionSelectModule(_:)), for: .touchUpInside)

            cell.lbl_Access.text = module.name
           
        
           
            
            
//            let sele = moduleSelection[indexPath.item]
//            if sele["\(module.id)"] != nil{
//                cell.btn_Checkbox.isSelected = sele["\(module.id)"]! == 1
//            }
          
            
           
        
        let user = array_Users[collectionView.tag]
        let access = systemaccess_selection["\(user.id)"]
        let moduleId = array_Modules[indexPath.item].id
        if access != nil{
            let  accessVal = access!["\(moduleId)"]
            if accessVal != nil{
                if accessVal!.count > 0{
                    let isEnabled = accessVal![0]
                    cell.btn_Checkbox.isSelected = (isEnabled != 0)
                   
                }
            }
        }
       
        
        
        
        
            return cell

       
    }
    
    @IBAction func actionSelectModule(_ sender:UIButton){
        sender.isSelected = !sender.isSelected
        let buttonPosition = sender.convert(CGPoint.zero, to: (self.parentVc as! SystemAccessTableViewController).table_SystemAccessList)
         let indexPath = (self.parentVc as! SystemAccessTableViewController).table_SystemAccessList.indexPathForRow(at: buttonPosition)
        
        
    
        let column = sender.tag
        if indexPath != nil{
            let user = array_Users[indexPath!.section]
          
            if sender.isSelected == true{
               let val = [1,1,1,1]
                systemaccess_selection["\(user.id)"]!["\(column)"] = val
               
            }
            else{
                let val = [0,0,0,0]
              
                systemaccess_selection["\(user.id)"]!["\(column)"] = val
                
                
            }
            DispatchQueue.main.async {
                (self.parentVc as! SystemAccessTableViewController).table_SystemAccessList.reloadData()
            }
            
        }
       
      
        
       
    }
  
    
    
}

extension SystemAccessTableViewController: MenuViewDelegate{
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
extension SystemAccessTableViewController : MessageAlertViewDelegate{
    func onHomeClicked() {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func onListClicked() {
        var controller: UIViewController!
        for cntroller in self.navigationController!.viewControllers as Array {
            if cntroller.isKind(of: OpionsTableViewController.self) {
                controller = cntroller
               
                break
            }
        }
        if controller != nil{
            self.navigationController!.popToViewController(controller, animated: true)
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
    
    }
}
