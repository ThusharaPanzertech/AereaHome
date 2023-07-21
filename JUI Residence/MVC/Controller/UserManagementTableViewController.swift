//
//  UserManagementTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 26/07/21.
//

import UIKit
import DropDown

var selectedRowIndex = -1

class UserManagementTableViewController: BaseTableViewController {
    var userroles = [String]()
    var array_Users = [UserModal]()
    var roles = [String: String]()
    let menu: MenuView = MenuView.getInstance
    var dataSource = DataSource_UserManagement()
    var heightSet = false
    var tableHeight: CGFloat = 0
    let alertView: AlertView = AlertView.getInstance
    let alertView_message: MessageAlertView = MessageAlertView.getInstance
    var userIdToActivate = 0
    var isToActivateUser = false
    //Outlets
    @IBOutlet var arrTextFields: [UITextField]!
    @IBOutlet weak var txt_Role: UITextField!
    @IBOutlet weak var txt_FirstName: UITextField!
    @IBOutlet weak var txt_LastName: UITextField!
    @IBOutlet weak var txt_Unit: UITextField!
    @IBOutlet weak var txt_SortBy: UITextField!
    @IBOutlet weak var table_ManageUsers: UITableView!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var view_Footer: UIView!
    @IBOutlet weak var view_SwitchProperty: UIView!
    @IBOutlet weak var lbl_SwitchProperty: UILabel!
    @IBOutlet weak var imgView_Profile: UIImageView!
    var unitsData = [Unit]()
    var sortIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
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
        table_ManageUsers.dataSource = dataSource
        table_ManageUsers.delegate = dataSource
        dataSource.parentVc = self
        table_ManageUsers.reloadData()
        UITextField.appearance().attributedPlaceholder = NSAttributedString(string: UITextField().placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])

        for txtfield in self.arrTextFields{
            txtfield.layer.cornerRadius = 20.0
            txtfield.layer.masksToBounds = true
            txtfield.delegate = self
            txtfield.textColor = textColor
            txtfield.attributedPlaceholder = NSAttributedString(string: txtfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
        }
      
        view_Background.layer.cornerRadius = 25.0
        view_Background.layer.masksToBounds = true
        selectedRowIndex = -1
        self.getUnitList()
       
    }
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        self.tableHeight = self.table_ManageUsers.contentSize.height
//        if self.tableHeight > 0 && heightSet == false{
//        DispatchQueue.main.async {
//
//            self.tableView.reloadData()
//            self.heightSet = true
//        }
//       }
//
//    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return view_Footer
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 150

    }
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == 1{
//            return tableHeight > 0 ?  tableHeight + 280 :  super.tableView(tableView, heightForRowAt: indexPath)
//        }
//        return super.tableView(tableView, heightForRowAt: indexPath)
//    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1{
            let ht = selectedRowIndex == -1  ?  (array_Users.count * 145) + 440 : ((array_Users.count - 1) * 145) + 285 + 440
            return CGFloat(ht)
           // return tableHeight > 0 ?  tableHeight   :  super.tableView(tableView, heightForRowAt: indexPath)
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txt_Role.text = ""
        txt_FirstName.text = ""
        txt_LastName.text = ""
        txt_Unit.text = ""
        getUserSummary()
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
    func getUserSummary(){
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.get_UserSummary(parameters: ["login_id":userId], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? UserSummaryBase){
                    self.array_Users = response.users
                    self.roles = response.roles
                     self.userroles = response.user_roles
                    if(self.array_Users.count > 0){
                        self.array_Users = self.array_Users.sorted(by: { $0.dateObj > $1.dateObj })
                    }
                    self.dataSource.roles = self.roles
                     self.dataSource.userroles = self.userroles
                    self.dataSource.array_Users = self.array_Users
                    if self.array_Users.count == 0{

                    }
                    else{
                       // self.view_NoRecords.removeFromSuperview()
                    }
                    DispatchQueue.main.async {
                        self.table_ManageUsers.reloadData()
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
    func getUnitList(){
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.get_UnitList(parameters: ["login_id":userId], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? UnitBase){
                    self.unitsData = response.units
                    self.dataSource.unitsData = response.units
                   
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
    func getRolesList(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"        //
        ApiService.get_RolesList(parameters: ["login_id":userId], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? RolesBase){
                    self.roles = response.roles
                   
                   
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
    func searchUser(){
        if txt_Role.text == "" && txt_Unit.text == "" && txt_FirstName.text == "" && txt_LastName.text == "" {
            self.getUserSummary()
        }
        else{
        var role_Id = ""
        var unit_Id = ""
        if let roleId = roles.first(where: { $0.value == txt_Role.text })?.key {
            role_Id = roleId
        }
        if let unitId = unitsData.first(where: { $0.unit == txt_Unit.text }) {
            unit_Id = "\(unitId.id)"
        }
          
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        var param = [String : Any]()
            param = [
                "login_id" : userId,
                "unit" : txt_Unit.text!,
                "name" : txt_FirstName.text!,
                "last_name" : txt_LastName.text!,
                "role" : role_Id,
                
            ] as [String : Any]
      /*  if txt_Role.text != ""{
            param = [
                "login_id" : userId,
                "option": "role",
                "role" : role_Id
                
            ] as [String : Any]
        }
        else if txt_FirstName.text != ""{
            param = [
                "login_id" : userId,
                "option": "name",
                "name" : txt_FirstName.text!,
                
            ] as [String : Any]
        }
        else if txt_LastName.text != ""{
            param = [
                "login_id" : userId,
                "option": "last_name",
                "last_name" : txt_LastName.text!,
                
            ] as [String : Any]
        }
        else if txt_Unit.text != ""{
            param = [
                "login_id" : userId,
                "option": "unit",
                "unit" : txt_Unit.text!,
                
            ] as [String : Any]
        }
        */
        
        ApiService.search_User(parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                    if status  && result != nil{
                         if let response = (result as? UserSummaryBase){
                            self.array_Users = response.users
                            self.roles = response.roles
                            if(self.array_Users.count > 0){
                                self.array_Users = self.array_Users.sorted(by: { $0.created_at > $1.created_at })
                            }
                            /* if self.sortIndex == 0{
                                 self.array_Users = self.array_Users.sorted(by: { $0.unit.unit < $1.unit.unit })
                             }
                             else if self.sortIndex == 1{
                                 self.array_Users = self.array_Users.sorted(by: { $0.unit.unit > $1.unit.unit })
                             }
                               else*/ if self.sortIndex == 2{
                                 self.array_Users = self.array_Users.sorted(by: { $0.dateObj < $1.dateObj })
                             }
                             else{
                                 self.array_Users = self.array_Users.sorted(by: { $0.dateObj > $1.dateObj })
                             }
                             self.dataSource.array_Users = self.array_Users
                             DispatchQueue.main.async {
                                 self.table_ManageUsers.reloadData()
                                 self.tableView.reloadData()
                             }
                            self.dataSource.roles = self.roles
                            self.dataSource.array_Users = self.array_Users
                            if self.array_Users.count == 0{

                            }
                            else{
                               // self.view_NoRecords.removeFromSuperview()
                            }
                            DispatchQueue.main.async {
                                self.table_ManageUsers.reloadData()
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
                   
                   
                
        }
            else if error != nil{
                self.displayErrorAlert(alertStr: "\(error!.localizedDescription)", title: "Alert")
            }
            else{
                self.displayErrorAlert(alertStr: "Something went wrong.Please try again", title: "Alert")
            }
        })
    }
    }
    func showActivateAlert(user_id:Int, isToActivate: Bool, index:Int){
        self.userIdToActivate = user_id
        self.isToActivateUser = isToActivate
        let status = isToActivate ? "activate" : "deactivate"
        let username = self.array_Users[index].name ?? "the user"
        alertView.delegate = self
        alertView.showInView(self.view_Background, title: "Are you sure you want to\n \(status) \(username)?", okTitle: "Yes", cancelTitle: "Back")
    }
    func activateUser(user_id:Int){
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.activate_user(parameters: ["login_id":userId,"user": user_id
                                             ], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? MessageBase){
                     DispatchQueue.main.async {
                         self.alertView_message.delegate = self
                         self.alertView_message.showInView(self.view_Background, title: "User account has been activated", okTitle: "Home", cancelTitle: "View User Management")
                     }
                     self.searchUser()
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
    func deactivateUser(user_id:Int){
        
        
        
        
        
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.deactivate_user(parameters: ["login_id":userId, "user": user_id], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? MessageBase){
                     DispatchQueue.main.async {
                         self.alertView_message.delegate = self
                         self.alertView_message.showInView(self.view_Background, title: "User account has been deactivated", okTitle: "Home", cancelTitle: "View User Management")
                     }
                     self.searchUser()
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
    //MARK: UIBUTTON ACTIONS
    @IBAction func actionSearch(_ sender:UIButton) {
        self.searchUser()
    }
    @IBAction func actionClear(_ sender:UIButton) {
        self.txt_Role.text = ""
        txt_FirstName.text = ""
        txt_LastName.text = ""
        txt_Unit.text = ""
        txt_SortBy.text = ""
        self.getUserSummary()
        self.txt_Role.backgroundColor = textBgColor
        txt_FirstName.backgroundColor = textBgColor
        txt_LastName.backgroundColor = textBgColor
        txt_Unit.backgroundColor = textBgColor
        txt_SortBy.backgroundColor = textBgColor
        
    }
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
    @IBAction func actionRoles(_ sender:UIButton) {
        let sortedArray = roles.sorted { $0.value < $1.value }
        let arrRoles = sortedArray.map { $0.value }
        let dropDown_Roles = DropDown()
        dropDown_Roles.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Roles.dataSource = arrRoles//Array(roles.values)
        dropDown_Roles.show()
        dropDown_Roles.selectionAction = { [unowned self] (index: Int, item: String) in
            txt_Role.text = item
           
            txt_Role.backgroundColor = .white
            
        }
    }
    @IBAction func actionSortBy(_ sender:UIButton) {
       
        let dropDown_Roles = DropDown()
        dropDown_Roles.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Roles.dataSource = ["Unit No(Ascending)", "Unit No(Descending)", "Date Added(Ascending)","Date Added(Descending)"]
        dropDown_Roles.show()
        dropDown_Roles.selectionAction = { [unowned self] (index: Int, item: String) in
            txt_SortBy.text = item
            self.sortIndex = index
           
            txt_SortBy.backgroundColor = .white
        }
    }
    @IBAction func actionUnit(_ sender:UIButton) {
       // let sortedArray = unitsData.sorted(by:  { $0.1 < $1.1 })
        let arrUnit = unitsData.map { $0.unit }
        let dropDown_Unit = DropDown()
        dropDown_Unit.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Unit.dataSource = arrUnit// Array(unitsData.values)
        dropDown_Unit.show()
        dropDown_Unit.selectionAction = { [unowned self] (index: Int, item: String) in
//            txt_Role.text = ""
//            txt_FirstName.text = ""
//            txt_LastName.text = ""
            txt_Unit.text = item
            txt_Unit.backgroundColor = .white
          //  self.searchUser()
            
        }
    }
    @IBAction func actionAddNew(_ sender: UIButton){
            let addUserVC = kStoryBoardMain.instantiateViewController(identifier: "AddUserTableViewController") as! AddUserTableViewController
        addUserVC.isToEdit = false
        addUserVC.roles = self.roles
            self.navigationController?.pushViewController(addUserVC, animated: true)
        
        
    }
    
    func sortUsersBy(index: Int){
        if(self.array_Users.count > 0){
            if index == 0{
                //self.array_Users = self.array_Users.sorted(by: { $0.unit.unit < $1.unit.unit })
            }
            else if index == 1{
             //   self.array_Users = self.array_Users.sorted(by: { $0.unit.unit > $1.unit.unit })
            }
              else if index == 2{
                self.array_Users = self.array_Users.sorted(by: { $0.created_at < $1.created_at })
            }
            else{
                self.array_Users = self.array_Users.sorted(by: { $0.created_at > $1.created_at })
            }
            self.dataSource.array_Users = self.array_Users
            DispatchQueue.main.async {
                self.table_ManageUsers.reloadData()
                self.tableView.reloadData()
            }
           
        }
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
class DataSource_UserManagement: NSObject, UITableViewDataSource, UITableViewDelegate {
    var parentVc: UIViewController!
    var array_Users = [UserModal]()
    var filePath = ""
    var roles = [String: String]()
    var userroles = [String]()
    var unitsData = [Unit]()
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1;
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  array_Users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "manageUserCell") as! AccessRolesTableViewCell
        let user = array_Users[indexPath.row]
       
       // if user.userinfo != nil{
            cell.lbl_FirstName.text = user.name

            cell.lbl_UnitNo.text = user.unit == "" ? "-" : "\(user.unit)"
            cell.lbl_AssignedRole.text = self.roles["\(user.role_id ?? 0)"]
            cell.lbl_Email.text = user.email
            cell.lbl_Password.text = user.account_enabled == 1 ? "Yes" : "No"
            cell.lbl_Contact.text = user.userinfo.phone
            cell.lbl_LastName.text = user.userinfo.last_name
       // }
        cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
        //dropShadow()
        cell.view_Outer.tag = indexPath.row
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        cell.view_Outer.addGestureRecognizer(tap)
        cell.btn_Edit.tag = indexPath.row
        cell.btn_Activate.tag = indexPath.row
        cell.btn_UnitInfo.tag = indexPath.row
        cell.btn_SystemAccess.tag = indexPath.row
        cell.btn_AssignDevices.tag = indexPath.row
        if indexPath.row != selectedRowIndex{
            for vw in cell.arrViews{
                vw.isHidden = true
            }
        }
        else{
            for vw in cell.arrViews{
                vw.isHidden = false

            }
            if self.userroles.contains("\(user.role_id ?? 0)")
            {
                
                    cell.btn_UnitInfo.isHidden = false
                    cell.btn_SystemAccess.isHidden = false
                    cell.btn_Space.constant = 52
                
            }
            else{
                cell.btn_UnitInfo.isHidden = true
                cell.btn_SystemAccess.isHidden = true
                cell.btn_Space.constant = 10
            }
        }

        
        
        
        cell.btn_Activate.addTarget(self, action: #selector(self.actionActivate(_:)), for: .touchUpInside)
        cell.btn_UnitInfo.addTarget(self, action: #selector(self.actionUnitInfo(_:)), for: .touchUpInside)
        cell.btn_AssignDevices.addTarget(self, action: #selector(self.actionAssignDevices(_:)), for: .touchUpInside)
        cell.btn_SystemAccess.addTarget(self, action: #selector(self.actionSystemAccess(_:)), for: .touchUpInside)
      
        if user.status == 1{
            cell.btn_Activate.setImage(UIImage(named: "activated"), for: .normal)
        }
        else{
            cell.btn_Activate.setImage(UIImage(named: "deactivated"), for: .normal)
        }
        
        
        cell.btn_Edit.addTarget(self, action: #selector(self.actionEdit(_:)), for: .touchUpInside)
        cell.selectionStyle = .none
        cell.img_Arrow.image = indexPath.row == selectedRowIndex ? UIImage(named: "up_arrow") : UIImage(named: "down_arrow")
       
        
            return cell
      
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return indexPath.row == selectedRowIndex ? 285 : 145
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        selectedRowIndex = (sender! as UITapGestureRecognizer).view!.tag
        DispatchQueue.main.async {
            (self.parentVc as! UserManagementTableViewController).table_ManageUsers.reloadData()
            (self.parentVc as! UserManagementTableViewController).tableView.reloadData()
        
      
        }
//        let editUserVC = kStoryBoardMain.instantiateViewController(identifier: "EditUserTableViewController") as! EditUserTableViewController
//        self.parentVc.navigationController?.pushViewController(editUserVC, animated: true)

    }
    @IBAction func actionDelete(_ sender: UIButton){
    }
    @IBAction func actionEdit(_ sender: UIButton){
        let addUserVC = kStoryBoardMain.instantiateViewController(identifier: "AddUserTableViewController") as! AddUserTableViewController
    addUserVC.isToEdit = true
        let user = array_Users[sender.tag]
        addUserVC.user = user
        addUserVC.roles = self.roles
        addUserVC.country_id = user.userinfo.country
        addUserVC.role_id = user.role_id
        self.parentVc.navigationController?.pushViewController(addUserVC, animated: true)
    }
    @IBAction func actionUnitInfo(_ sender: UIButton){
        let assignUnitVC = kStoryBoardMain.instantiateViewController(identifier: "AssignUnitsTableViewController") as! AssignUnitsTableViewController
  
        let user = array_Users[sender.tag]
        assignUnitVC.user = user
        assignUnitVC.roles = self.roles
        //assignUnitVC.unitsData = self.unitsData
        self.parentVc.navigationController?.pushViewController(assignUnitVC, animated: true)
        
    }
    @IBAction func actionSystemAccess(_ sender: UIButton){
        let systemAccessVC = kStoryBoardMain.instantiateViewController(identifier: "SystemAccessTableViewController") as! SystemAccessTableViewController
  
        let user = array_Users[sender.tag]
        systemAccessVC.user = user
        systemAccessVC.roles = self.roles
        //assignUnitVC.unitsData = self.unitsData
        self.parentVc.navigationController?.pushViewController(systemAccessVC, animated: true)
        
    }
    @IBAction func actionAssignDevices(_ sender: UIButton){
        let assignUnitVC = kStoryBoardMain.instantiateViewController(identifier: "AssignDevicesTableViewController") as! AssignDevicesTableViewController
  
        let user = array_Users[sender.tag]
        assignUnitVC.user = user
      //  assignUnitVC.roles = self.roles
        //assignUnitVC.unitsData = self.unitsData
        self.parentVc.navigationController?.pushViewController(assignUnitVC, animated: true)
        
    }
    @IBAction func actionActivate(_ sender: UIButton){
        
        let user = array_Users[sender.tag]
        if user.status == 1{
           
          
            (self.parentVc as! UserManagementTableViewController).showActivateAlert(user_id: user.id, isToActivate: false, index: sender.tag)
        }
        else{
            (self.parentVc as! UserManagementTableViewController).showActivateAlert(user_id: user.id, isToActivate: true, index: sender.tag)
        }
    }
    
}
extension UserManagementTableViewController: MenuViewDelegate{
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
extension UserManagementTableViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
//        if textField == txt_FirstName{
//            txt_LastName.text = ""
//        }
//        else if textField == txt_LastName{
//            txt_FirstName.text = ""
//        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.backgroundColor = .white
//        txt_Role.text = ""
//        txt_Unit.text = ""
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text!.count > 0{
            textField.backgroundColor = UIColor.white
        }
        else{
            textField.backgroundColor = UIColor(red: 208/255, green: 208/255, blue: 208/255, alpha: 1.0)
        }
       //     self.searchUser()
        
    }
}
extension UserManagementTableViewController: AlertViewDelegate{
    func onBackClicked() {
       
    }
    
    func onCloseClicked() {
        
    }
    
    func onOkClicked() {
        if self.isToActivateUser == true{
            self.activateUser(user_id: self.userIdToActivate)
        }
        else{
            self.deactivateUser(user_id: self.userIdToActivate)
        }
    }
    
    
}
extension UserManagementTableViewController : MessageAlertViewDelegate{
    func onHomeClicked() {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func onListClicked() {
        //self.getDeviceSummaryLists()
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
