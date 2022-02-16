//
//  AddUserTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 26/07/21.
//

import UIKit
import DropDown
class AddUserTableViewController: BaseTableViewController {

    //Outlets
    @IBOutlet weak var txt_FirstName: UITextField!
    @IBOutlet weak var txt_LastName: UITextField!
    @IBOutlet weak var txt_Contact: UITextField!
    @IBOutlet weak var txt_Email: UITextField!
    @IBOutlet weak var txt_UnitNo: UITextField!
    @IBOutlet weak var txt_Company: UITextField!
    @IBOutlet weak var txt_MailingAddress: UITextView!
    @IBOutlet weak var txt_AssignedRole: UITextField!
    @IBOutlet weak var txt_PostalCode: UITextField!
    
    @IBOutlet var arr_Textfields: [UITextField]!
    @IBOutlet var arr_Buttons: [UIButton]!
    @IBOutlet weak var view_Fields: UIView!
   
    @IBOutlet weak var btn_Submit: UIButton!
    @IBOutlet weak var btn_Delete: UIButton!
    @IBOutlet weak var btn_Home: UIButton!
    @IBOutlet weak var btn_UserList: UIButton!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var view_Background1: UIView!
    @IBOutlet weak var imgView_Profile: UIImageView!
    let menu: MenuView = MenuView.getInstance
    let alertView: AlertView = AlertView.getInstance
    let alertView_message: MessageAlertView = MessageAlertView.getInstance
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var lbl_MsgTitlee: UILabel!
    @IBOutlet weak var lbl_MsgDesc: UILabel!
    var isToShowSucces = false
    var isToEdit: Bool!
    var user: UserModal!
    var userData: Users!
    var unitsData = [String: String]()
    var roles = [String: String]()
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
        txt_MailingAddress.delegate = self
        for txtField in arr_Textfields{
            txtField.layer.cornerRadius = 20.0
            txtField.layer.masksToBounds = true
            txtField.delegate = self
            txtField.textColor = textColor
            txtField.attributedPlaceholder = NSAttributedString(string: txtField.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
        }
        imgView_Profile.addborder()
        txt_MailingAddress.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        if isToEdit == true{
            txt_MailingAddress.textColor = txt_MailingAddress.text == "Mailing Address" ? placeholderColor :
                textColor
        }
        else{
            txt_MailingAddress.textColor = placeholderColor
        }
      
        txt_MailingAddress.layer.cornerRadius = 20.0
        txt_MailingAddress.layer.masksToBounds = true
        view_Fields.layer.cornerRadius = 25.0
        view_Fields.layer.masksToBounds = true
        view_Background.layer.cornerRadius = 25.0
        view_Background.layer.masksToBounds = true
        view_Background1.layer.cornerRadius = 25.0
        view_Background1.layer.masksToBounds = true
        for btn in arr_Buttons{
            btn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
            btn.layer.cornerRadius = 8.0
        }
        getUnitList()
        if self.isToEdit == false{
        btn_Delete.isHidden = true
        }
        else{
            self.txt_Email.textColor = UIColor.gray
            self.txt_Email.isUserInteractionEnabled = false
            self.getUserSummary()
            
        }

        //ToolBar
          let toolbar = UIToolbar();
          toolbar.sizeToFit()
          let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([spaceButton,doneButton], animated: false)
        txt_MailingAddress.inputAccessoryView = toolbar
        txt_Contact.inputAccessoryView = toolbar
    }
    @objc func done(){
        self.view.endEditing(true)
    }
    @IBAction func actionUnit(_ sender:UIButton) {
        let sortedArray = unitsData.sorted(by:  { $0.1 < $1.1 })
        let arrUnit = sortedArray.map { $0.value }
        let dropDown_Unit = DropDown()
        dropDown_Unit.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Unit.dataSource = arrUnit//Array(unitsData.values)
        dropDown_Unit.show()
        dropDown_Unit.selectionAction = { [unowned self] (index: Int, item: String) in
            txt_UnitNo.text = item
            if let key = unitsData.first(where: { $0.value == item })?.key {
                print(key)
            }
        }
    }
    @IBAction func actionRoles(_ sender:UIButton) {
        let sortedArray = roles.sorted { $0.key < $1.key }
        let arrRoles = sortedArray.map { $0.value }
        let dropDown_Roles = DropDown()
        dropDown_Roles.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Roles.dataSource = arrRoles//Array(roles.values)
        dropDown_Roles.show()
        dropDown_Roles.selectionAction = { [unowned self] (index: Int, item: String) in
            txt_AssignedRole.text = item
            
        }
    }
    func setUpUI(){
        if self.isToEdit == true{
            
            txt_FirstName.text = userData.user?.name
            txt_LastName.text = userData.moreInfo?.last_name
            txt_Contact.text = userData.moreInfo?.phone
            txt_Email.text = userData.user?.email
            txt_UnitNo.text = userData.unit?.unit
            txt_Company.text = userData.moreInfo?.company_name
            txt_MailingAddress.text = userData.moreInfo?.mailing_address
            txt_AssignedRole.text = userData.role?.name
            txt_PostalCode.text = userData.moreInfo?.postal_code
            txt_MailingAddress.textColor = txt_MailingAddress.text == "Mailing Address" ? placeholderColor :
                textColor
        }
    }
    //MARK: ******  PARSING *********
    func getUserSummary(){
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.get_UserDetail_With(parameters: ["login_id":userId, "user":user.cardInfo.id], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? UserInfoModalBase){
                    self.userData = response.users
                   
                    DispatchQueue.main.async {
                        self.setUpUI()
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
    
    func createUser(){
        self.lbl_MsgTitlee.text = "User List Added"
        self.lbl_MsgDesc.text = "The requested user has been added\n into the list."
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        var role_Id = ""
        var unit_Id = ""
        if let roleId = roles.first(where: { $0.value == txt_AssignedRole.text })?.key {
            role_Id = roleId
        }
        if let unitId = unitsData.first(where: { $0.value == txt_UnitNo.text })?.key {
            unit_Id = unitId
        }
        let param = [
            "login_id" : userId,
            "role_id": role_Id,
            "name" : txt_FirstName.text!,
            "last_name": txt_LastName.text!,
            "phone": txt_Contact.text!,
            "email" : txt_Email.text!,
            "unit_no": unit_Id,
            "company_name":txt_Company.text!,
            "mailing_address": txt_MailingAddress.text!,
            "postal_code": txt_PostalCode.text!
        ] as [String : Any]

        ApiService.create_User(parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? CreateUserBase){
                    if response.response == 1{
                        self.isToShowSucces =  true
                        DispatchQueue.main.async {
                        self.tableView.reloadData()
                            let indexPath = NSIndexPath(row: 0, section: 0)
                            self.tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: false)
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
    func updateUser(){
        self.lbl_MsgTitlee.text = "User Data Updated"
        self.lbl_MsgDesc.text = "The requested user has been updated\n successfully."
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        var role_Id = ""
        var unit_Id = ""
        if let roleId = roles.first(where: { $0.value == txt_AssignedRole.text })?.key {
            role_Id = roleId
        }
        if let unitId = unitsData.first(where: { $0.value == txt_UnitNo.text })?.key {
            unit_Id = unitId
        }
        let id = userData.user != nil ? userData.user!.id : 0
        let param = [
            "login_id" : userId,
            "id" : id!,
            "role_id": role_Id,
            "name" : txt_FirstName.text!,
            "last_name": txt_LastName.text!,
            "phone": txt_Contact.text!,
            "email" : txt_Email.text!,
            "unit_no": unit_Id,
            "company_name":txt_Company.text!,
            "mailing_address": txt_MailingAddress.text!,
            "postal_code": txt_PostalCode.text!
        ] as [String : Any]

        ApiService.update_User(parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? UpdateUserBase){
                    if response.response == 1{
                        self.isToShowSucces =  true
                        DispatchQueue.main.async {
                        self.tableView.reloadData()
                            let indexPath = NSIndexPath(row: 0, section: 0)
                            self.tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: false)
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
    
    func deleteUser(){
       
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
     
        let id = userData.user != nil ? userData.user!.id : 0
        let param = [
            "login_id" : userId,
            "user" : id!,
          
        ] as [String : Any]

        ApiService.delete_User(parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? DeleteUserBase){
                    if response.response == 1{
                        DispatchQueue.main.async {
                            self.alertView_message.delegate = self
                            self.alertView_message.showInView(self.view_Background, title: "User has been\n deleted", okTitle: "Home", cancelTitle: "View User List")
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
            return self.isToShowSucces == true ? 0 : super.tableView(tableView, heightForRowAt: indexPath)
        }
        else  if indexPath.row == 2{
            return self.isToShowSucces == false ? 0 : kScreenSize.height - 180
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    //MARK: UIBUTTON ACTIONS
    @IBAction func actionBackPressed(_ sender: UIButton){
        view.endEditing(true)
        if isToEdit == true{
            self.navigationController?.popViewController(animated: true)
        }
        else{
        alertView.delegate = self
        alertView.showInView(self.view_Background, title: "Are you sure you want to\n leave this page?\nYour changes would not\n be saved.", okTitle: "Back", cancelTitle: "Yes")
        }
    }
    @IBAction func actionAddNew(_ sender: UIButton){
//        let addUnitVC = kStoryBoardSettings.instantiateViewController(identifier: "AddEditUnitTableViewController") as! AddEditUnitTableViewController
//        addUnitVC.isToEdit = false
//        self.navigationController?.pushViewController(addUnitVC, animated: true)
        
    }
    @IBAction func actionSubmit(_ sender: UIButton){
        self.view.endEditing(true)
        guard txt_FirstName.text!.count  > 0 else {
            displayErrorAlert(alertStr: "Please enter the first name", title: "")
            return
        }
        guard txt_LastName.text!.count  > 0 else {
            displayErrorAlert(alertStr: "Please enter the last name", title: "")
            return
        }
        guard txt_UnitNo.text!.count  > 0 else {
            displayErrorAlert(alertStr: "Please select the unit", title: "")
            return
        }
        guard txt_Contact.text!.count  > 0 else {
            displayErrorAlert(alertStr: "Please enter the contact number", title: "")
            return
        }
        
        guard txt_Email.text!.count  > 0 else {
            displayErrorAlert(alertStr: "Please enter the email", title: "")
            return
        }
        guard txt_Email.text!.isValidEmail() == true else {
            displayErrorAlert(alertStr: "Please enter a valid email address", title: "")
            return
        }
        guard txt_MailingAddress.text!.count  > 0 else {
            displayErrorAlert(alertStr: "Please enter the mailing address", title: "")
            return
        }
        if isToEdit == true{
            updateUser()
        }
        else{
       createUser()
        }
    }
    @IBAction func actionHome(_ sender: UIButton){
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    @IBAction func actionDelete(_ sender: UIButton){
        showDeleteAlert()
        
    }
    func showDeleteAlert(){
        
        alertView.delegate = self
        alertView.showInView(self.view_Background, title: "Are you sure you want to\n delete the following user?", okTitle: "Yes", cancelTitle: "Back")
      
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

extension AddUserTableViewController: MenuViewDelegate{
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
extension AddUserTableViewController: AlertViewDelegate{
    func onBackClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func onCloseClicked() {
        
    }
    
    func onOkClicked() {
        self.deleteUser()
    
    }
    
    
}
extension AddUserTableViewController: MessageAlertViewDelegate{
    func onHomeClicked() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func onListClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
extension AddUserTableViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == placeholderColor {
                textView.text = nil
            textView.textColor = textColor
            }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
               textView.text = "Mailing Address"
               textView.textColor = placeholderColor
           }
    }
}
extension AddUserTableViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
       
        return true
    }
   
}
