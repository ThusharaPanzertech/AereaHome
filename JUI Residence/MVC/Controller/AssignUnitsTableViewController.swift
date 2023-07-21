//
//  AssignUnitsTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 20/06/23.
//

import UIKit
import DropDown

class AssignUnitsTableViewController:  BaseTableViewController {
    
    //Outlets
    @IBOutlet weak var txt_Role: UITextField!
    @IBOutlet weak var txt_Building: UITextField!
    @IBOutlet weak var txt_Unit: UITextField!
    @IBOutlet weak var txt_CardNo: UITextField!
    
    @IBOutlet weak var table_Units: UITableView!
   
    @IBOutlet weak var view_SwitchProperty: UIView!
    @IBOutlet weak var lbl_SwitchProperty: UILabel!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet var arr_Textfields: [UITextField]!
    @IBOutlet var arr_Buttons: [UIButton]!
    @IBOutlet var arr_ViewToHide: [UIView]!
    @IBOutlet weak var view_Fields: UIView!
   
    @IBOutlet weak var btn_Submit: UIButton!
    @IBOutlet weak var btn_PrimaryContact: UIButton!
    @IBOutlet weak var btn_Home: UIButton!
    @IBOutlet weak var btn_UserList: UIButton!
    @IBOutlet weak var view_Background: UIView!
  //  @IBOutlet weak var view_Background1: UIView!
    @IBOutlet weak var imgView_Profile: UIImageView!
    let menu: MenuView = MenuView.getInstance
    let alertView: AlertView = AlertView.getInstance
    let alertView_message: MessageAlertView = MessageAlertView.getInstance
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var lbl_MsgTitlee: UILabel!
    @IBOutlet weak var lbl_MsgDesc: UILabel!
   
    var selectedIndexes = [Int]()
    var isToEdit: Bool!
    var dataSource = DataSource_AssignUnits()
    var user: UserModal!
    var isToDelete = false
  //  var unitsData = [Unit]()
    var array_assignedUnits = [UnitAssigned]()
    var roles = [String: String]()
    var buildings = [String: String]()
    var unitcards = [String: String]()
    var array_BuildingUnit = [BuildingUnit]()
    var selectedrole = ""
    var selectedunit = ""
    var selectedunitToDelete = ""
    var selectedbuilding = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for vw in self.arr_ViewToHide{
            vw.isHidden = true
        }
        self.lbl_Title.text = "Manage Unit(s) : \(user.name) \(user.last_name)"
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

        for txtField in arr_Textfields{
            txtField.layer.cornerRadius = 20.0
            txtField.layer.masksToBounds = true
            txtField.delegate = self
            txtField.textColor = textColor
            txtField.attributedPlaceholder = NSAttributedString(string: txtField.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
        }
        imgView_Profile.addborder()
       
        view_Fields.layer.cornerRadius = 25.0
        view_Fields.layer.masksToBounds = true
        view_Background.layer.cornerRadius = 25.0
        view_Background.layer.masksToBounds = true
       // view_Background1.layer.cornerRadius = 25.0
       // view_Background1.layer.masksToBounds = true
        for btn in arr_Buttons{
            btn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
            btn.layer.cornerRadius = 8.0
        }
              getAssignedUnitList()
       

        
        table_Units.dataSource = dataSource
        table_Units.delegate = dataSource
        dataSource.parentVc = self
        table_Units.reloadData()
    }
    @objc func done(){
        self.view.endEditing(true)
    }
    @IBAction func actionUnit(_ sender:UIButton) {
        if selectedbuilding == ""{
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
                getUnitCardList()
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
           // self.selectedrole = sortedArray[index].key
            let prop = roles.first(where:{ $0.value == item})
            if prop != nil{
                self.selectedrole  = prop!.key
            }
            if self.selectedrole == "2"{
                for vw in self.arr_ViewToHide{
                    vw.isHidden = false
                }
            }
            else{
                btn_PrimaryContact.isSelected = false
                for vw in self.arr_ViewToHide{
                    vw.isHidden = true
                }
            }
        }
    }
    @IBAction func actionCards(_ sender:UIButton) {
        let sortedArray = unitcards.sorted { $0.key < $1.key }
        let arrRoles = sortedArray.map { $0.value }
        let dropDown_Cards = DropDown()
        dropDown_Cards.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Cards.dataSource = arrRoles//Array(roles.values)
        dropDown_Cards.showFooter = true
        dropDown_Cards.show()
       
        dropDown_Cards.dismissMode = .automatic
        dropDown_Cards.multiSelectionAction = { [unowned self] (indexes: [Int], items: [String]) in
          //  txt_Group.text = item
            selectedIndexes = indexes
            var roles = ""
            for obj in items{
                roles += obj + ", "
            }
            if indexes.count > 0{
            roles.removeLast()
            roles.removeLast()
            }
            txt_CardNo.text = roles
        }
        dropDown_Cards.selectRows(at:Set(selectedIndexes))
        
        
        
       
    }
    @IBAction func actionBuildings(_ sender:UIButton) {
        let sortedArray = buildings.sorted { $0.key < $1.key }
        let arrRoles = sortedArray.map { $0.value }
        let dropDown_Roles = DropDown()
        dropDown_Roles.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Roles.dataSource = arrRoles//Array(roles.values)
        dropDown_Roles.show()
        dropDown_Roles.selectionAction = { [unowned self] (index: Int, item: String) in
            txt_Building.text = item
            self.selectedbuilding = sortedArray[index].key
            self.getBuildingUnitsLists()
            txt_Unit.text = ""
            self.selectedunit = ""
        }
    }
    func setUpUI(){
       
    }
    func showDeleteAlert(deleteIndx: Int){

        self.selectedunitToDelete = "\(array_assignedUnits[deleteIndx].id ?? 0)"
        alertView.delegate = self
        alertView.showInView(self.view_Background, title: "Are you sure you want to\n delete the following\n unit assigned?", okTitle: "Yes", cancelTitle: "Back")
      
    }
    //MARK: ******  PARSING *********
  
    func getBuildingUnitsLists(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
       
        ApiService.get_buildingUnitsList(parameters: ["login_id":userId, "building_id" : self.selectedbuilding], completion: { status, result, error in
           
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
    
    func getAssignedUnitList(){
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.get_AssignedUnitList(parameters: ["login_id":userId, "user": user.id!], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? AssignedUnitBase){
                    self.array_assignedUnits = response.user_units
                     self.roles = response.roles
                     self.buildings = response.buildings
                     
                     self.dataSource.array_assignedUnits = self.array_assignedUnits
                     self.dataSource.roles = self.roles
                     self.dataSource.buildings = self.buildings
                   
                     DispatchQueue.main.async {
                         self.table_Units.reloadData()
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
    func getUnitCardList(){
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.get_UnitCardList(parameters: ["login_id":userId, "unit_no": self.selectedunit], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? UnitCardBase){
                   
                     self.unitcards = response.cards
                     
                    
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
    func assignUnit(){
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        var cardArr = [String]()
        for obj in self.selectedIndexes{
            let key = Array(unitcards)[obj].key
            cardArr.append(key)
        }
        
        
        let params = NSMutableDictionary()
        params.setValue("\(userId)", forKey: "login_id")
        params.setValue(user.id ?? 0, forKey: "user_id")
        params.setValue(self.selectedbuilding, forKey: "building_no")
        params.setValue(self.selectedunit, forKey: "unit_no")
        params.setValue(self.selectedrole, forKey: "role_id")
        params.setValue(btn_PrimaryContact.isSelected ? 1 : 0, forKey: "primary_contact")
        if cardArr.count > 0{
            params.setValue(cardArr, forKey: "card_no")
        }
        ApiService.assign_Unit(parameters: params as! [String : Any], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                if let response = (result as? DeleteUserBase){
                    if response.response == 1{
                      
                        DispatchQueue.main.async {
                            self.alertView_message.delegate = self
                            self.alertView_message.showInView(self.view_Background, title: "Unit has been assigned to the user", okTitle: "Home", cancelTitle: "View User Management")
                        }
                    }
                    else{
                        self.displayErrorAlert(alertStr: "\(response.message)", title: "Alert")
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
    
    func deleteUnitAssigned(){
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        var cardArr = [String]()
        for obj in self.selectedIndexes{
            let key = Array(unitcards)[obj].key
            cardArr.append(key)
        }
        
        
        let params = NSMutableDictionary()
        params.setValue("\(userId)", forKey: "login_id")
        params.setValue(user.id ?? 0, forKey: "user_id")
        params.setValue(self.selectedunitToDelete, forKey: "id")
       

        ApiService.delete_AssignedUnit(parameters: params as! [String : Any], completion: { status, result, error in
            self.isToDelete = false
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                if let response = (result as? DeleteUserBase){
                    self.getUnitCardList()
                    
                    DispatchQueue.main.async {
                        self.alertView_message.delegate = self
                        self.alertView_message.showInView(self.view_Background, title: "Unit has been deleted", okTitle: "Home", cancelTitle: "View User Management")
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
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1{
            super.tableView(tableView, heightForRowAt: indexPath)
        }
        else  if indexPath.row == 2{
            return CGFloat(100 + (array_assignedUnits.count * 205))
        }
        
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    //MARK: UIBUTTON ACTIONS
    @IBAction func actionPrimaryContact(_ sender: UIButton){
        
        sender.isSelected = !sender.isSelected
        
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
    @IBAction func actionBackPressed(_ sender: UIButton){
        self.view.endEditing(true)
        if isToEdit == true{
            self.navigationController?.popViewController(animated: true)
        }
        else{
        alertView.delegate = self
        alertView.showInView(self.view_Background, title: "Are you sure you want to\n leave this page?\nYour changes would not\n be saved.", okTitle: "Yes", cancelTitle: "Back")
        }
    }
  
    @IBAction func actionSubmit(_ sender: UIButton){
        self.view.endEditing(true)
        guard txt_Unit.text!.count  > 0 else {
            displayErrorAlert(alertStr: "Please select the unit", title: "")
            return
        }
        guard txt_Role.text!.count  > 0 else {
            displayErrorAlert(alertStr: "Please select the role", title: "")
            return
        }
        guard txt_Building.text!.count  > 0 else {
            displayErrorAlert(alertStr: "Please select the building", title: "")
            return
        }
        self.assignUnit()
        
      
    }
    @IBAction func actionHome(_ sender: UIButton){
        self.navigationController?.popToRootViewController(animated: true)
        
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

extension AssignUnitsTableViewController: MenuViewDelegate{
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
extension AssignUnitsTableViewController: AlertViewDelegate{
    func onOkClicked() {
        if self.isToDelete == true{
            self.deleteUnitAssigned()
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
       
    }
    
    func onCloseClicked() {
        
    }
    
    func onBackClicked() {
       
    
    }
    
    
}
extension AssignUnitsTableViewController: MessageAlertViewDelegate{
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
       // self.navigationController?.popViewController(animated: true)
    }
    
    
}


extension AssignUnitsTableViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
       
        return true
    }
   
}


class DataSource_AssignUnits: NSObject, UITableViewDataSource, UITableViewDelegate {
    var parentVc: UIViewController!
   
    
    var array_assignedUnits = [UnitAssigned]()
    var roles = [String: String]()
    var buildings = [String: String]()
    var unitsData = [Unit]()
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1;
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return  array_assignedUnits.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "assignUnitCell") as! AssignedUnitsTableViewCell
   
          
        cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 8.0, opacity: 0.35)
        cell.view_Outer.tag = indexPath.row
       
        cell.selectionStyle = .none
      
        let unit = array_assignedUnits[indexPath.row]
        cell.lbl_Role.text = unit.role
        cell.lbl_Unit.text = "#\(unit.unit)"
        cell.lbl_Building.text = "\(unit.building)"
        cell.lbl_AssignedDate.text = unit.created_date
        cell.lbl_PrimaryContact.text = unit.primary_contact
        
        
        cell.btn_Delete.addTarget(self, action: #selector(self.actionDelete(_:)), for: .touchUpInside)
            return cell
      
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 205
    }
    @IBAction func actionDelete(_ sender:UIButton){
        (self.parentVc as! AssignUnitsTableViewController).isToDelete = true
        (self.parentVc as! AssignUnitsTableViewController).showDeleteAlert(deleteIndx:sender.tag)
    }

    
   
    
}

