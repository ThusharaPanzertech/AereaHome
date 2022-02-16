//
//  EditRoleTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 27/09/21.
//

import UIKit
enum AccessType {
    case add
    case view
    case edit
    case delete
    case all
}
var array_ViewAccess = [Bool]()
var array_AddAccess = [Bool]()
var array_EditAccess = [Bool]()
var array_DeleteAccess = [Bool]()

class EditRoleTableViewController: BaseTableViewController {
    //Outlets
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
   
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var imgView_Profile: UIImageView!
   
    @IBOutlet weak var btn_CheckAll: UIButton!
    @IBOutlet weak var btn_Add: UIButton!
    @IBOutlet weak var btn_View: UIButton!
    @IBOutlet weak var btn_Edit: UIButton!
    @IBOutlet weak var btn_Delete: UIButton!
    @IBOutlet weak var txt_RoleTitle: UITextField!
    @IBOutlet weak var table_EditRole: UITableView!
    @IBOutlet var arr_Buttons: [UIButton]!
    var isToDelete = false
    var dataSource = DataSource_EditRole()
    var heightSet = false
    var tableHeight: CGFloat = 0
    var selectedRole = ""
    let menu: MenuView = MenuView.getInstance
    var roleInfo: RoleInfo!
    var roleBase: RoleDetailsBase!
    let alertView: AlertView = AlertView.getInstance
    let alertView_message: MessageAlertView = MessageAlertView.getInstance
    override func viewDidLoad() {
        super.viewDidLoad()
        let fname = Users.currentUser?.user?.name ?? ""
        let lname = Users.currentUser?.moreInfo?.last_name ?? ""
        self.lbl_UserName.text = "\(fname) \(lname)"
        let role = Users.currentUser?.role?.name ?? ""
        self.lbl_UserRole.text = role
        imgView_Profile.addborder()
        getRoleDetails()
       
        for btn in arr_Buttons{
            btn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
            btn.layer.cornerRadius = 8.0
        }
       
        table_EditRole.dataSource = dataSource
        table_EditRole.delegate = dataSource
        
        self.table_EditRole.reloadData()
    }
    //MARK: ******  PARSING *********
    func getRoleDetails(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"        //
        ApiService.get_RoleDetails(parameters: ["login_id":userId, "id":roleInfo.id], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? RoleDetailsBase){
                    self.roleBase = response
                    self.roleInfo = response.role
                    self.dataSource.roleInfo = response.role
                    self.dataSource.roleBase = response
                    self.table_EditRole.reloadData()
                    self.tableView.reloadData()
                    self.checkAccessAll(type: .all, isToCheck: false)
                    
                    for (indx, permission) in self.roleInfo.permissions.enumerated(){
                        array_ViewAccess[indx] = permission.view == 1 ? true : false
                        array_EditAccess [indx] = permission.edit == 1 ? true : false
                        array_DeleteAccess[indx] = permission.delete == 1 ? true : false
                        array_AddAccess [indx] = permission.create == 1 ? true : false
                    }
                    self.table_EditRole.reloadData()
                    
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
    func updateRole(){
       
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        let params = NSMutableDictionary()
        params.setValue("\(userId)", forKey: "login_id")
        params.setValue("\(self.roleInfo.id)", forKey: "id")
        params.setValue("\(self.roleInfo.name)", forKey: "name")
        
        for (indx, permission) in self.roleInfo.permissions.enumerated(){
            let moduleId = permission.module_id
            let isToView = array_ViewAccess[indx] == true ? 1 : 0
            let isToAdd = array_AddAccess[indx] == true ? 1 : 0
            let isToEdit = array_EditAccess[indx] == true ? 1 : 0
            let isToDelete = array_DeleteAccess[indx] == true ? 1 : 0
            
            params.setValue("\(isToView)", forKey: "mod_view_\(moduleId)")
            params.setValue("\(isToAdd)", forKey: "mod_add_\(moduleId)")
            params.setValue("\(isToEdit)", forKey: "mod_edit_\(moduleId)")
            params.setValue("\(isToDelete)", forKey: "mod_delete_\(moduleId)")
        }
      // print(params)

        ApiService.update_Role(parameters: params as! [String : Any], completion: { status, result, error in
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? DeleteUserBase){
                    if response.response == 1{
                        DispatchQueue.main.async {
                            self.alertView_message.delegate = self
                            self.alertView_message.showInView(self.view_Background, title: "Role setting\nchanges has been\n submitted", okTitle: "Home", cancelTitle: "View roles list")
                        }
                    }
                    else{
                        self.displayErrorAlert(alertStr: response.message, title: "Alert")
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
    func deleteRole(){
       
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
       
        let param = [
            "login_id" : userId,
            "id" : self.roleInfo.id,
          
        ] as [String : Any]

        ApiService.delete_Role(parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
            self.isToDelete  = false
            if status  && result != nil{
                 if let response = (result as? DeleteUserBase){
                    if response.response == 1{
                        DispatchQueue.main.async {
                            self.alertView_message.delegate = self
                            self.alertView_message.showInView(self.view_Background, title: "Role has been\n deleted", okTitle: "Home", cancelTitle: "View Roles List")
                        }
                    }
                    else{
                        self.displayErrorAlert(alertStr: response.message, title: "Alert")
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        self.showBottomMenu()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.closeMenu()
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1{
            return self.roleBase == nil ? super.tableView(tableView, heightForRowAt: indexPath) : CGFloat(60 * self.roleBase.modules.count + 380)
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
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
    //MARK: UIButton ACTIONS
    @IBAction func actionDelete(_ sender: UIButton){
        showDeleteAlert()
        
    }
    @IBAction func actionSave(_ sender: UIButton){
        updateRole()
        
    }
    func showDeleteAlert(){
        isToDelete = true
        alertView.delegate = self
        alertView.showInView(self.view_Background, title: "Are you sure you want to\n delete the following role?", okTitle: "Yes", cancelTitle: "Back")
      
    }
    @IBAction func actionCheckAll(_ sender: UIButton){
        
        let accessType: AccessType = sender.tag == 1 ? .all :
            sender.tag == 2 ? .view :
            sender.tag == 3 ? .add :
            sender.tag == 4 ? .edit :
             .delete
        sender.isSelected = !sender.isSelected
        if accessType == .all{
            btn_Add.isSelected = sender.isSelected
            btn_View.isSelected = sender.isSelected
            btn_Edit.isSelected = sender.isSelected
            btn_Delete.isSelected = sender.isSelected
        }
        
        if sender.isSelected == true{
            self.checkAccessAll(type: accessType, isToCheck: true)
        }
        else{
            self.checkAccessAll(type: accessType, isToCheck: false)
        }
    }
    
    
    @IBAction func actionBackPressed(_ sender: UIButton){
        alertView.delegate = self
        alertView.showInView(self.view_Background, title: "Are you sure you want to\n leave this page?\nYour changes would not\n be saved.", okTitle: "Back", cancelTitle: "Yes")
    }
    func checkAccessAll(type: AccessType, isToCheck: Bool){
        
       if type == .add{
            array_AddAccess.removeAll()
        for _ in self.roleBase.modules{
            array_AddAccess.append(isToCheck)
        }
        }
        else if type == .edit{
            array_EditAccess.removeAll()
            for _ in self.roleBase.modules{
              
                array_EditAccess.append(isToCheck)
            }
        }
        else if type == .view{
            array_ViewAccess.removeAll()
            for _ in self.roleBase.modules{
                array_ViewAccess.append(isToCheck)
                
            }
        }
        else if type == .delete{
            array_DeleteAccess.removeAll()
            for _ in self.roleBase.modules{
                array_DeleteAccess.append(isToCheck)
            }
        }
        else{
            array_ViewAccess.removeAll()
            array_AddAccess.removeAll()
            array_EditAccess.removeAll()
            array_DeleteAccess.removeAll()
            for _ in self.roleBase.modules{
                array_ViewAccess.append(isToCheck)
                array_AddAccess.append(isToCheck)
                array_EditAccess.append(isToCheck)
                array_DeleteAccess.append(isToCheck)
            }
        }
        self.table_EditRole.reloadData()
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
class DataSource_EditRole: NSObject, UITableViewDataSource, UITableViewDelegate {
    var roleInfo: RoleInfo!
    var parentVc: UIViewController!
    var filePath = ""
    var roleBase: RoleDetailsBase!
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1;
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roleBase == nil ? 0 : roleBase.modules.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "editRoleCell") as! EditRoleTableViewCell
        let service = roleBase.modules[indexPath.row]
       
        cell.lbl_RoleType.text = service.name
        cell.btn_Edit.tag = indexPath.row
        cell.btn_Delete.tag = indexPath.row
        cell.btn_Add.tag = indexPath.row
        cell.btn_View.tag = indexPath.row
        
        if indexPath.row <= array_ViewAccess.count{
            cell.btn_View.isSelected = array_ViewAccess[indexPath.row]
        }
        if indexPath.row <= array_EditAccess.count{
            cell.btn_Edit.isSelected = array_EditAccess[indexPath.row]
        }
        if indexPath.row <= array_AddAccess.count{
            cell.btn_Add.isSelected = array_AddAccess[indexPath.row]
        }
        if indexPath.row <= array_DeleteAccess.count{
            cell.btn_Delete.isSelected = array_DeleteAccess[indexPath.row]
        }
        
        cell.btn_Edit.addTarget(self, action: #selector(self.actionEdit(_:)), for: .touchUpInside)
        cell.btn_View.addTarget(self, action: #selector(self.actionView(_:)), for: .touchUpInside)
        cell.btn_Add.addTarget(self, action: #selector(self.actionAdd(_:)), for: .touchUpInside)
        cell.btn_Delete.addTarget(self, action: #selector(self.actionDelete(_:)), for: .touchUpInside)
        cell.selectionStyle = .none
            return cell
      
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
       // let service = roleInfo.modules[(sender! as UITapGestureRecognizer).view!.tag]
        

    }
    @IBAction func actionEdit(_ sender: UIButton){
        sender.isSelected = !sender.isSelected
        array_EditAccess[sender.tag] = sender.isSelected
       
    }
    @IBAction func actionView(_ sender: UIButton){
        sender.isSelected = !sender.isSelected
        array_ViewAccess[sender.tag] = sender.isSelected
       
    }
    @IBAction func actionAdd(_ sender: UIButton){
        sender.isSelected = !sender.isSelected
        array_AddAccess[sender.tag] = sender.isSelected
       
    }
    @IBAction func actionDelete(_ sender: UIButton){
        sender.isSelected = !sender.isSelected
        array_DeleteAccess[sender.tag] = sender.isSelected
       
    }
    
}
extension EditRoleTableViewController: MenuViewDelegate{
    func onMenuClicked(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            self.menu.contractMenu()
            self.navigationController?.popToRootViewController(animated: true)
            break
        case 2:
            self.goToSettings()
            break
        case 3:
            self.actionLogout(sender)
            break
      
        default:
            break
        }
    }
    
    func onCloseClicked(_ sender: UIButton) {
        
    }
    
    
    
}
extension EditRoleTableViewController: AlertViewDelegate{
    func onBackClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func onCloseClicked() {
        
    }
    
    func onOkClicked() {
        if isToDelete ==  true{
            deleteRole()
        }
    }
    
    
}
extension EditRoleTableViewController: MessageAlertViewDelegate{
    func onHomeClicked() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func onListClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
