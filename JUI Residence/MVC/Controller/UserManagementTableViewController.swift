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

    var array_Users = [UserModal]()
    var roles = [String: String]()
    let menu: MenuView = MenuView.getInstance
    var dataSource = DataSource_UserManagement()
    var heightSet = false
    var tableHeight: CGFloat = 0
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
   
    @IBOutlet weak var imgView_Profile: UIImageView!
    var unitsData = [Unit]()
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let fname = Users.currentUser?.user?.name ?? ""
        let lname = Users.currentUser?.moreInfo?.last_name ?? ""
        self.lbl_UserName.text = "\(fname) \(lname)"
        let role = Users.currentUser?.role?.name ?? ""
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
            let ht = selectedRowIndex == -1  ?  (array_Users.count * 145) + 370 : ((array_Users.count - 1) * 145) + 255 + 370
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
                    if(self.array_Users.count > 0){
                        self.array_Users = self.array_Users.sorted(by: { $0.cardInfo.created_at > $1.cardInfo.created_at })
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
        if txt_Role.text != ""{
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
        
        
        ApiService.search_User(parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                    if status  && result != nil{
                         if let response = (result as? UserSummaryBase){
                            self.array_Users = response.users
                            self.roles = response.roles
                            if(self.array_Users.count > 0){
                                self.array_Users = self.array_Users.sorted(by: { $0.cardInfo.created_at > $1.cardInfo.created_at })
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
    //MARK: UIBUTTON ACTIONS
    @IBAction func actionRoles(_ sender:UIButton) {
        let sortedArray = roles.sorted { $0.key < $1.key }
        let arrRoles = sortedArray.map { $0.value }
        let dropDown_Roles = DropDown()
        dropDown_Roles.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Roles.dataSource = arrRoles//Array(roles.values)
        dropDown_Roles.show()
        dropDown_Roles.selectionAction = { [unowned self] (index: Int, item: String) in
            txt_Role.text = item
            txt_FirstName.text = ""
            txt_LastName.text = ""
            txt_Unit.text = ""
            self.searchUser()
            
        }
    }
    @IBAction func actionSortBy(_ sender:UIButton) {
       
        let dropDown_Roles = DropDown()
        dropDown_Roles.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Roles.dataSource = ["Unit No(Ascending)", "Unit No(Descending)", "Date Added(Ascending)","Date Added(Descending)"]
        dropDown_Roles.show()
        dropDown_Roles.selectionAction = { [unowned self] (index: Int, item: String) in
            txt_SortBy.text = item
           
            self.sortUsersBy(index: index)
            
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
            txt_Role.text = ""
            txt_FirstName.text = ""
            txt_LastName.text = ""
            txt_Unit.text = item
            self.searchUser()
            
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
                self.array_Users = self.array_Users.sorted(by: { $0.cardInfo.unit_no < $1.cardInfo.unit_no })
            }
            else if index == 1{
                self.array_Users = self.array_Users.sorted(by: { $0.cardInfo.unit_no > $1.cardInfo.unit_no })
            }
            else if index == 2{
                self.array_Users = self.array_Users.sorted(by: { $0.cardInfo.created_at < $1.cardInfo.created_at })
            }
            else{
                self.array_Users = self.array_Users.sorted(by: { $0.cardInfo.created_at > $1.cardInfo.created_at })
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
class DataSource_UserManagement: NSObject, UITableViewDataSource, UITableViewDelegate {
    var parentVc: UIViewController!
    var array_Users = [UserModal]()
    var filePath = ""
    var roles = [String: String]()
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
        cell.lbl_FirstName.text = user.cardInfo.name
        let unitno = user.cardInfo.unit_no ?? 0
        if let unitId = unitsData.first(where: { $0.id == unitno}) {
            cell.lbl_UnitNo.text = unitId.unit
        }
        else{
        cell.lbl_UnitNo.text = ""
        }
       // cell.lbl_UnitNo.text = unitsData[unitno]
        cell.lbl_AssignedRole.text = self.roles["\(user.cardInfo.role_id ?? 0)"]
        cell.lbl_Email.text = user.cardInfo.email
        cell.lbl_Password.text = user.cardInfo.account_enabled == 1 ? "Yes" : "No"
        cell.lbl_Contact.text = user.cardInfo.userInfo?.phone
        cell.lbl_LastName.text = user.cardInfo.userInfo?.last_name
        
        cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
        //dropShadow()
        cell.view_Outer.tag = indexPath.row
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        cell.view_Outer.addGestureRecognizer(tap)
        cell.btn_Edit.tag = indexPath.row
        
       
        
        cell.btn_Edit.addTarget(self, action: #selector(self.actionEdit(_:)), for: .touchUpInside)
        cell.selectionStyle = .none
        cell.img_Arrow.image = indexPath.row == selectedRowIndex ? UIImage(named: "up_arrow") : UIImage(named: "down_arrow")
        if indexPath.row != selectedRowIndex{
            for vw in cell.arrViews{
                vw.isHidden = true
            }
        }
        else{
            for vw in cell.arrViews{
                vw.isHidden = false
            }
        }
        
            return cell
      
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return indexPath.row == selectedRowIndex ? 255 : 145
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
        self.parentVc.navigationController?.pushViewController(addUserVC, animated: true)
    }
    
}
extension UserManagementTableViewController: MenuViewDelegate{
    func onMenuClicked(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            
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
extension UserManagementTableViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == txt_FirstName{
            txt_LastName.text = ""
        }
        else if textField == txt_LastName{
            txt_FirstName.text = ""
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        txt_Role.text = ""
        txt_Unit.text = ""
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
       
            self.searchUser()
        
    }
}
