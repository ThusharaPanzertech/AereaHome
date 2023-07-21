//
//  UserAccessTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 12/06/23.
//

import UIKit
import DropDown
let textBgColor = UIColor(red: 208/255, green: 208/255, blue: 208/255, alpha: 1.0)
var selection = [String: [String: [Int]]]()
var moduleSelection = [[String: Int]]()
class UserAccessTableViewController: BaseTableViewController {
    var user_access = [String: [String: [Int]]]()
    var array_Users = [UserAccessDataModal]()
    var array_Modules = [Module]()
    var roles = [String: String]()
    let menu: MenuView = MenuView.getInstance
    var dataSourceUser = DataSource_User()
    var dataSourceAccess = DataSource_UserAccess()
   var selectedBuildingId = ""
    var selectedRoleId = ""
    let alertView: AlertView = AlertView.getInstance
    var buildings = [String: String]()
    var unitsData = [Unit]()
    var array_BuildingUnit = [BuildingUnit]()
    var selectedunit = ""
    //Outlets
    @IBOutlet var arr_Textfields: [UITextField]!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var table_Users: UITableView!
    @IBOutlet weak var table_Access: UITableView!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_NoRecords: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var view_Scroll: UIView!
    @IBOutlet weak var view_SwitchProperty: UIView!
    @IBOutlet weak var lbl_SwitchProperty: UILabel!
    @IBOutlet weak var imgView_Profile: UIImageView!
    @IBOutlet  var scrollWidth: NSLayoutConstraint!
    @IBOutlet  var scrollHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var txt_Building: UITextField!
    @IBOutlet weak var txt_Unit: UITextField!
    @IBOutlet weak var txt_Role: UITextField!
    
    let alertView_message: MessageAlertView = MessageAlertView.getInstance
    override func viewDidLoad() {
        super.viewDidLoad()
        lbl_NoRecords.isHidden = true
        for txtField in arr_Textfields{
            //txtField.delegate = self
            txtField.layer.cornerRadius = 20.0
            txtField.layer.masksToBounds = true
            txtField.textColor = textColor
            txtField.attributedPlaceholder = NSAttributedString(string: txtField.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
        }
       // scrollView.isExclusiveTouch = true
       // scrollView.delaysContentTouches = false
        view_SwitchProperty.layer.borderColor = themeColor.cgColor
        view_SwitchProperty.layer.borderWidth = 1.0
        view_SwitchProperty.layer.cornerRadius = 10.0
        view_SwitchProperty.layer.masksToBounds = true
        lbl_SwitchProperty.text = kCurrentPropertyName
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
        imgView_Profile.addborder()
        table_Users.dataSource = dataSourceUser
        table_Users.delegate = dataSourceUser
        dataSourceUser.parentVc = self
        
        
        table_Access.dataSource = dataSourceAccess
        table_Access.delegate = dataSourceAccess
        dataSourceAccess.parentVc = self
       
        
       
        view_Background.layer.cornerRadius = 25.0
        view_Background.layer.masksToBounds = true
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       scrollView.contentSize = CGSize(width: 1560, height: 1000)
////        scrollView.isScrollEnabled = true
////        scrollView.isHidden = false
////        scrollView.bounces = false
////
     //  view_Scroll.frame =  CGRect(x: 0, y: 0, width: 200, height: 100)
//
        table_Access.bounces = false
        table_Access.isScrollEnabled = false
    }
   
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2{
            if array_Users.count == 0 {
                return super.tableView(tableView, heightForRowAt: indexPath)
            }
            else{
                return CGFloat((80 * array_Users.count) + 50)
            }
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        getUserAccessSummary()
        self.showBottomMenu()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.closeMenu()
    }
    func showBottomMenu(){
        
        menu.delegate = self
        menu.showInView(self.view, title: "", message: "")
       // self.menu.loadCollection(array_Permissions: global_array_Permissions, array_Modules: global_array_Modules)
    }
    func closeMenu(){
        menu.removeView()
    }
    override func getBackgroundImageName() -> String {
        let imgdefault = ""//UserInfoModalBase.currentUser?.data.property.defect_bg ?? ""
        return imgdefault
    }
    //MARK: ******  PARSING *********
    
   
    func getBuildingUnitsLists(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
       
        ApiService.get_buildingUnitsList(parameters: ["login_id":userId, "building_id" : self.selectedBuildingId], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? BuildingUnitBase){
                     self.array_BuildingUnit = response.data
                    
                   
                     
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
     
    
    
    
    func getUserAccessSummary(){
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.get_UserAccessSummary(parameters: ["login_id":userId], completion: { status, result, error in
            moduleSelection.removeAll()
            selection.removeAll()
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? UserAccessSummaryBase){
                    self.array_Users = response.users
                     self.array_Modules = response.modules
                    self.roles = response.roles
                     self.dataSourceAccess.array_Users = self.array_Users
                    self.dataSourceAccess.array_Modules = self.array_Modules
                    self.dataSourceUser.array_Users = self.array_Users
                     self.buildings = response.buildings
                    // self.user_access = response.user_access
                 //    self.dataSourceAccess.user_access = response.user_access
                     for user in response.users{
                         selection["\(user.id)"] = user.user_access
                     }
                //     selection  = response.user_access
                      self.user_access = selection
                      self.dataSourceAccess.user_access = selection
                     for mod in self.array_Modules{
                         let val = ["\(mod.id)": 0]
                         moduleSelection.append(val)
                     }
                    if self.array_Users.count == 0{
                        self.lbl_NoRecords.isHidden = false
                        self.table_Access.isHidden = true
                    }
                    else{
                        self.lbl_NoRecords.isHidden = true
                        self.table_Access.isHidden = false
                       // self.view_NoRecords.removeFromSuperview()
                    }
                    DispatchQueue.main.async {
                        let ht =  CGFloat((80 * self.array_Users.count) + 50)
                        
                       // self.scrollView.contentSize = CGSize(width: CGFloat(130 * self.array_Modules.count), height: ht)
                       // self.view_Scroll.frame =  CGRect(x: 0, y: 0, width: CGFloat(130 * self.array_Modules.count), height: ht)
                        
                        
                        self.scrollWidth.constant = CGFloat(130 * self.array_Modules.count)
                        self.scrollView.contentSize = CGSize(width: CGFloat(130 * self.array_Modules.count), height: ht)
                       self.scrollHeightConstraint.constant = ht
                        self.table_Users.reloadData()
                       
                       
                        
                        
                    
                        self.table_Access.reloadData()
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
   
  
    func getSearchUserAccessSummary(){
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.search_UserAccessSummary(parameters: ["login_id":userId, "building" : selectedBuildingId , "unit" : self.selectedunit , "role" : selectedRoleId], completion: { status, result, error in
            moduleSelection.removeAll()
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? UserAccessSummaryBase){
                    self.array_Users = response.users
                     self.array_Modules = response.modules
                    self.roles = response.roles
                     self.dataSourceAccess.array_Users = self.array_Users
                    self.dataSourceAccess.array_Modules = self.array_Modules
                    self.dataSourceUser.array_Users = self.array_Users
                     self.buildings = response.buildings
                     
                     for user in response.users{
                         selection["\(user.id)"] = user.user_access
                     }
                      self.user_access = selection
                      self.dataSourceAccess.user_access = selection
                     
                     
                  //   self.user_access = response.user_access
                  //   self.dataSourceAccess.user_access = response.user_access
              //       selection  = response.user_access
                     for mod in self.array_Modules{
                         let val = ["\(mod.id)": 0]
                         moduleSelection.append(val)
                     }
                     if self.array_Users.count == 0{
                         self.lbl_NoRecords.isHidden = false
                         self.table_Access.isHidden = true
                     }
                     else{
                         self.lbl_NoRecords.isHidden = true
                         self.table_Access.isHidden = false
                        // self.view_NoRecords.removeFromSuperview()
                     }
                    DispatchQueue.main.async {
                        let ht =  CGFloat((80 * self.array_Users.count) + 40)
                        
                       // self.scrollView.contentSize = CGSize(width: CGFloat(130 * self.array_Modules.count), height: ht)
                       // self.view_Scroll.frame =  CGRect(x: 0, y: 0, width: CGFloat(130 * self.array_Modules.count), height: ht)
                        
                        
                        self.scrollWidth.constant = CGFloat(130 * self.array_Modules.count)
                        self.scrollView.contentSize = CGSize(width: CGFloat(130 * self.array_Modules.count), height: ht)
                       self.scrollHeightConstraint.constant = ht
                        self.table_Users.reloadData()
                       
                       
                        
                        
                    
                        self.table_Access.reloadData()
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
    
    func submitUserAccess(){
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        
        let params = NSMutableDictionary()
        params.setValue("\(userId)", forKey: "login_id")

        var ids = [String]()
        for (indx,data) in self.array_Users.enumerated(){
            
            ids.append("\(data.id)")
            
            for mod in self.array_Modules{

                
                let access = selection["\(data.id)"]
                let moduleId = mod.id
                if access != nil{
                    let  accessVal = access!["\(moduleId)"]
                    if accessVal != nil{
                        if accessVal!.count > 0{
                            let isEnabled = accessVal![0]
                            params.setValue("\(isEnabled)", forKey: "mod_\(mod.id)_user_\(data.id)")
                           
                        }
                    }
                }
                
                
                
                
                
            }
        }
        params.setValue(ids, forKey: "userids")
        
        
        
        
        
        
        
        ApiService.submit_UserAccess(parameters: params as! [String : Any]) { status, result, error in
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? UserAccessUpdateBase){
                     DispatchQueue.main.async {
                         self.alertView_message.delegate = self
                         self.alertView_message.showInView(self.view_Background, title: "User Access changes have been saved successfully", okTitle: "Home", cancelTitle: "View User Access")
                     }
                    
                }
        }
            else if error != nil{
                self.displayErrorAlert(alertStr: "\(error!.localizedDescription)", title: "Alert")
            }
            else{
                self.displayErrorAlert(alertStr: "Something went wrong.Please try again", title: "Alert")
            }
        }
        
        
        
       
    }
   
   
   
    
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
    @IBAction func actionSelectAll(_ sender:UIButton){
        sender.isSelected = !sender.isSelected
        moduleSelection.removeAll()
        for mod in self.array_Modules{
            let sele = sender.isSelected  ? 1 : 0
                     let val = ["\(mod.id)": sele]
                     moduleSelection.append(val)
            
            if sender.isSelected == true{
               let val = [1,1,1,1]
                for user in array_Users{
                    selection["\(user.id)"]!["\(mod.id)"] = val
                }
            }
            else{
                let val = [0,0,0,0]
                for user in array_Users{
                    selection["\(user.id)"]!["\(mod.id)"] = val
                }
                
            }
        }
        
        DispatchQueue.main.async {
            self.table_Access.reloadData()
        }
       
    }
    @IBAction func actionBuilding(_ sender: UIButton){
        
        let arrUnit = buildings.sorted { $0.key < $1.key }
        let sortedArray = arrUnit.map { $0.value }
      let dropDown_arrOptions = DropDown()
        dropDown_arrOptions.anchorView = sender // UIView or UIBarButtonItem
        dropDown_arrOptions.dataSource = sortedArray
        dropDown_arrOptions.show()
        dropDown_arrOptions.selectionAction = { [unowned self] (index: Int, item: String) in

            txt_Building.backgroundColor = .white
            txt_Building.text = item
            txt_Unit.text = ""
            self.selectedBuildingId   = arrUnit[index].key
            self.getBuildingUnitsLists()
            
      }
        
        
       
    }
    @IBAction func actionUnit(_ sender:UIButton) {
        //  let sortedArray = unitsData.sorted(by:  { $0.1 < $1.1 })
//        let arrUnit = unitsData.map { $0.unit }
//        let dropDown_Unit = DropDown()
//        dropDown_Unit.anchorView = sender // UIView or UIBarButtonItem
//        dropDown_Unit.dataSource = arrUnit// Array(unitsData.values)
//        dropDown_Unit.show()
//        dropDown_Unit.selectionAction = { [unowned self] (index: Int, item: String) in
//
//            txt_Unit.text = item
//            txt_Unit.backgroundColor = .white
//
//        }
        
        if selectedBuildingId == ""{
            displayErrorAlert(alertStr: "Please select building", title: "")
        }
        else{
            let arrUnit = array_BuildingUnit.map { $0.unit }
            let dropDown_Unit = DropDown()
            dropDown_Unit.anchorView = sender // UIView or UIBarButtonItem
            dropDown_Unit.dataSource = arrUnit// Array(unitsData.values)
            dropDown_Unit.show()
            dropDown_Unit.selectionAction = { [unowned self] (index: Int, item: String) in
                txt_Unit.text = item
                self.selectedunit = "\(array_BuildingUnit[index].id)"
               
            }
        }
        
        
    }
    @IBAction func actionRoles(_ sender:UIButton) {
        let sortedArray = roles.sorted { $0.value < $1.value }
        let arrRoles = sortedArray.map { $0.value }
        let dropDown_Roles = DropDown()
        dropDown_Roles.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Roles.dataSource = arrRoles//Array(roles.values)
        dropDown_Roles.show()
        dropDown_Roles.selectionAction = { [unowned self] (index: Int, item: String) in
            txt_Role.text = item
            //selectedRoleId = sortedArray[index].key
            let prop = roles.first(where:{ $0.value == item})
            if prop != nil{
                self.selectedRoleId  = prop!.key
            }
            txt_Role.backgroundColor = .white
        }
    }
    @IBAction func actionClear(_ sender:UIButton) {
        self.txt_Unit.text = ""
        txt_Building.text = ""
        txt_Role.text = ""
        txt_Building.backgroundColor = textBgColor
        txt_Unit.backgroundColor = textBgColor
        txt_Role.backgroundColor = textBgColor
        
        self.selectedBuildingId = ""
        self.selectedRoleId = ""
        
        self.getUserAccessSummary()
        
        
    }
    @IBAction func actionSearch(_ sender:UIButton) {
       
       
        self.getSearchUserAccessSummary()
        
        
    }
    @IBAction func actionSubmit(_ sender:UIButton) {
       
        self.submitUserAccess()
        
        
    }
    //MARK: MENU ACTIONS
    @IBAction func actionInbox(_ sender: UIButton){
//        let inboxTVC = self.storyboard?.instantiateViewController(identifier: "InboxTableViewController") as! InboxTableViewController
//        self.navigationController?.pushViewController(inboxTVC, animated: true)
    }
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
    @IBAction func actionAnnouncement(_ sender: UIButton){
        let announcementTVC = kStoryBoardMain.instantiateViewController(identifier: "AnnouncementTableViewController") as! AnnouncementTableViewController
        self.navigationController?.pushViewController(announcementTVC, animated: true)
    }
    @IBAction func actionAppointmemtUnitTakeOver(_ sender: UIButton){
        //self.checkAppointmentStatus(type: .unitTakeOver)
    }
    @IBAction func actionDefectList(_ sender: UIButton){
        self.menu.contractMenu()
    }
    @IBAction func actionAppointmentJointInspection(_ sender: UIButton){
        //self.checkAppointmentStatus(type: .jointInspection)
    }
    @IBAction func actionFacilityBooking(_ sender: UIButton){
//        let facilityBookingTVC = self.storyboard?.instantiateViewController(identifier: "FacilitySummaryTableViewController") as! FacilitySummaryTableViewController
//        self.navigationController?.pushViewController(facilityBookingTVC, animated: true)
    }
    @IBAction func actionFeedback(_ sender: UIButton){
//        let feedbackTVC = self.storyboard?.instantiateViewController(identifier: "FeedbackSummaryTableViewController") as! FeedbackSummaryTableViewController
//        self.navigationController?.pushViewController(feedbackTVC, animated: true)
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
class DataSource_UserAccess: NSObject, UITableViewDataSource, UITableViewDelegate {
    var parentVc: UIViewController!
    var user_access = [String: [String: [Int]]]()
    var array_Modules = [Module]()
    var array_Users = [UserAccessDataModal]()
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1;
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return  array_Users.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
           
                let cell = tableView.dequeueReusableCell(withIdentifier: "moduleListCell1") as! ModuleListTableViewCell1
                
                cell.collectionViewModule.dataSource = self
                cell.collectionViewModule.delegate = self
                

                cell.collectionViewModule.isScrollEnabled = false
              
                cell.collectionViewModule.tag = indexPath.row
        DispatchQueue.main.async {
            cell.collectionViewModule.reloadData()
        }
        if indexPath.row > 0{
            cell.contentView.backgroundColor = indexPath.row % 2 == 0 ?
            UIColor.white : UIColor(red: 222/255, green: 208/255, blue: 181/255, alpha: 1.0)
            
//            cell.contentView.backgroundColor = indexPath.row % 2 == 0 ?
//            UIColor.white : UIColor(red: 142/255, green: 128/255, blue: 101/255, alpha: 1.0)
        }
        else{
            cell.contentView.backgroundColor = UIColor.clear
        }
        //print("taggg   --------  \(cell.collectionViewModule.tag)")
        
        
                return cell
          
            
            

            
           
        
      
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return indexPath.row == 0 ? 50 : 80
    }
  
    }
   

class DataSource_User: NSObject, UITableViewDataSource, UITableViewDelegate {
    var parentVc: UIViewController!
    var array_Users = [UserAccessDataModal]()
   
   
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1;
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return  array_Users.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "userListCell1") as! UserListTableViewCell
               
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "userListCell") as! UserListTableViewCell
                let user = array_Users[indexPath.row - 1]
                cell.lbl_UserName.text = "\(user.first_name)"
                cell.lbl_UserRole.text = user.role
                cell.lbl_UserUnit.text = user.unit
//
//                cell.contentView.backgroundColor = indexPath.row % 2 == 0 ?
//                UIColor.white : UIColor(red: 142/255, green: 128/255, blue: 101/255, alpha: 1.0)
//
                if indexPath.row > 0{
                    cell.contentView.backgroundColor = indexPath.row % 2 == 0 ?
                    UIColor.white : UIColor(red: 222/255, green: 208/255, blue: 181/255, alpha: 1.0)
                }
                return cell
            }
       
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return  indexPath.row == 0 ? 50 : 80
    }
  
    }
   



extension DataSource_UserAccess: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array_Modules.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moduleCell1", for: indexPath) as! ModuleColllectionViewCell
        let module = array_Modules[indexPath.item]
        cell.btn_AccessCheckbox.alpha =  collectionView.tag == 0 ? 0 : 1
        cell.btn_AccessCheckbox.isHidden  =  collectionView.tag == 0 ? true : false

        if collectionView.tag == 0{
            cell.centerX.constant = 1000
           // cell.btn_AccessCheckbox.isHidden = true
           
            cell.btn_Checkbox.tag = module.id
            cell.btn_Checkbox.addTarget(self, action: #selector(self.actionSelectColumn(_:)), for: .touchUpInside)
            let module = array_Modules[indexPath.row]
            cell.lbl_ModuleName.text = module.name
          //  cell.btn_AccessCheckbox.isHidden = true
            cell.lbl_ModuleName.isHidden = false
            cell.btn_Checkbox.isHidden = false
            
            
            let sele = moduleSelection[indexPath.item]
            if sele["\(module.id)"] != nil{
                cell.btn_Checkbox.isSelected = sele["\(module.id)"]! == 1
            }
          
            

           
        }
        else{
          //  cell.centerX.constant = 0
          //  cell.btn_AccessCheckbox.isHidden = false
            cell.lbl_ModuleName.isHidden = true
            cell.btn_Checkbox.isHidden = true

            let index = collectionView.tag - 1
            let user = array_Users[index]
            let access = selection["\(user.id)"]
            let moduleId = array_Modules[indexPath.item].id
            if access != nil{
                let  accessVal = access!["\(moduleId)"]
                if accessVal != nil{
                    if accessVal!.count > 0{
                        let isEnabled = accessVal![0]
                        cell.btn_AccessCheckbox.isSelected = (isEnabled != 0)
                       
                    }
                }
            }
            
            cell.btn_AccessCheckbox.tag = module.id
           cell.btn_AccessCheckbox.addTarget(self, action: #selector(self.actionChangeAccess(_:)), for: .touchUpInside)
        }
       
        
        
        
        
            return cell

       
    }
    
    @IBAction func actionSelectColumn(_ sender:UIButton){
        let column = sender.tag
        sender.isSelected = !sender.isSelected
        
        let indx = array_Modules.firstIndex(where:{ $0.id == column})
        if sender.isSelected == true{
           let val = [1,1,1,1]
            for user in array_Users{
                selection["\(user.id)"]!["\(column)"] = val
            }
        }
        else{
            let val = [0,0,0,0]
            for user in array_Users{
                selection["\(user.id)"]!["\(column)"] = val
            }
            
        }
        if indx != nil{
            
                let sel = sender.isSelected == true ? 1 : 0
                moduleSelection[indx!] = ["\(column)": sel ]
            
        }
        DispatchQueue.main.async {
            (self.parentVc as! UserAccessTableViewController).table_Access.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
            (self.parentVc as! UserAccessTableViewController).table_Access.reloadData()
        }
    }
    @IBAction func actionChangeAccess(_ sender:UIButton){
        sender.isSelected = !sender.isSelected
        
        let buttonPosition = sender.convert(CGPoint.zero, to: (self.parentVc as! UserAccessTableViewController).table_Access)
         let indexPath = (self.parentVc as! UserAccessTableViewController).table_Access.indexPathForRow(at: buttonPosition)
        
        
    
        let column = sender.tag
       
        
        let indx = array_Modules.firstIndex(where:{ $0.id == column})
        if sender.isSelected == true{
           let val = [1,1,1,1]
            let user = array_Users[indexPath!.row - 1]
                selection["\(user.id)"]!["\(column)"] = val
           
        }
        else{
            let val = [0,0,0,0]
            let user = array_Users[indexPath!.row - 1]
                selection["\(user.id)"]!["\(column)"] = val
            
            
        }
      
        DispatchQueue.main.async {
            (self.parentVc as! UserAccessTableViewController).table_Access.reloadData()
        }
    }
    
    
}
extension UserAccessTableViewController: MenuViewDelegate{
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

extension UserAccessTableViewController: AlertViewDelegate{
    func onBackClicked() {
       
    }
    
    func onCloseClicked() {
        
    }
    
    func onOkClicked() {
        
    }
    
    
}
extension UserAccessTableViewController : MessageAlertViewDelegate{
    func onHomeClicked() {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func onListClicked() {
       
    
    }
}
