//
//  MoveIODetailsTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 09/02/22.
//

import UIKit
import DropDown
class MoveIODetailsTableViewController: BaseTableViewController {
    
    //Outlets
    var isToDelete = false
    let alertView: AlertView = AlertView.getInstance
    let alertView_message: MessageAlertView = MessageAlertView.getInstance
    let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
    @IBOutlet weak var view_SwitchProperty: UIView!
    @IBOutlet weak var lbl_SwitchProperty: UILabel!
    @IBOutlet weak var view_Footer: UIView!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var imgView_Profile: UIImageView!
    @IBOutlet weak var ht_Table: NSLayoutConstraint!
    @IBOutlet weak var lbl_Ticket: UILabel!
    @IBOutlet weak var vw_Table: UIView!
    @IBOutlet weak var lbl_SubmittedDate: UILabel!
    @IBOutlet weak var lbl_ResidentName: UILabel!
    @IBOutlet weak var lbl_UnitNo: UILabel!
    @IBOutlet weak var lbl_ContactNo: UILabel!
    @IBOutlet weak var lbl_Email: UILabel!
    @IBOutlet weak var lbl_CompanyName: UILabel!
    @IBOutlet weak var lbl_PersonInCharge: UILabel!
    @IBOutlet weak var lbl_CompanyContactNo: UILabel!
    @IBOutlet weak var lbl_WorkStart: UILabel!
    @IBOutlet weak var lbl_WorkEnd: UILabel!
   
    var unit: Unit!
    
    
    
    @IBOutlet weak var txt_Status: UITextField!
    @IBOutlet weak var txtView_Remarks: UITextView!
   
    @IBOutlet  var arr_Btns: [UIButton]!
    let menu: MenuView = MenuView.getInstance
    @IBOutlet weak var table_Contractors: UITableView!
    var dataSource = DataSource_MoveInOut()

    var moveInOutData: MoveInOut!
   
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
        txtView_Remarks.layer.cornerRadius = 15
        txtView_Remarks.layer.masksToBounds = true
        //ToolBar
          let toolbar = UIToolbar();
          toolbar.sizeToFit()
          let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([spaceButton,doneButton], animated: false)
        txtView_Remarks.inputAccessoryView = toolbar
        if moveInOutData.submission.remarks != ""{
            txtView_Remarks.text = moveInOutData.submission.remarks
            txtView_Remarks.textColor =
                textColor
        }
        else{
            txtView_Remarks.text = "Enter Remarks"
            txtView_Remarks.textColor = placeholderColor
        }
        txtView_Remarks.delegate = self
        
        table_Contractors.dataSource = dataSource
        table_Contractors.delegate = dataSource
        dataSource.parentVc = self
        dataSource.moveInOutData = self.moveInOutData
        setUpUI()
          let fname = Users.currentUser?.moreInfo?.first_name ?? ""
        let lname = Users.currentUser?.moreInfo?.last_name ?? ""
        self.lbl_UserName.text = "\(fname) \(lname)"
        let role = Users.currentUser?.role
        self.lbl_UserRole.text = role
        txt_Status.text = moveInOutData.submission.status == 0 ? "New" :
            moveInOutData.submission.status == 1 ? "Cancelled" :
            moveInOutData.submission.status == 2 ? "In Progress" :
            moveInOutData.submission.status == 3 ? "Approved" :
            moveInOutData.submission.status == 4 ? "Rejected" :
            moveInOutData.submission.status == 5 ? "Payment Pending" :
            moveInOutData.submission.status == 6 ? "Refunded" : ""
        view_SwitchProperty.layer.borderColor = themeColor.cgColor
        view_SwitchProperty.layer.borderWidth = 1.0
        view_SwitchProperty.layer.cornerRadius = 10.0
        view_SwitchProperty.layer.masksToBounds = true
        lbl_SwitchProperty.text = kCurrentPropertyName
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vw_Table.layer.cornerRadius = 10.0
        vw_Table.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
       
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        let moving_date = formatter.date(from: moveInOutData.submission.moving_date)
        let moving_start = formatter.date(from: moveInOutData.submission.moving_start)
        let moving_end = formatter.date(from: moveInOutData.submission.moving_end)
        formatter.dateFormat = "dd/MM/yy"
        let moving_dateStr = formatter.string(from: moving_date ?? Date())
        let moving_startStr = formatter.string(from: moving_start ?? Date())
        let moving_endStr = formatter.string(from: moving_end ?? Date())
       
        
        lbl_Ticket.text = moveInOutData.submission.ticket
        lbl_SubmittedDate.text = moving_dateStr
        lbl_ResidentName.text = moveInOutData.submission.resident_name
        //lbl_UnitNo.text = moveInOutData.unit?.unit
        let unit = self.unit
        lbl_UnitNo.text = unit == nil ? "" : "#\(unit!.unit)"
        lbl_ContactNo.text = moveInOutData.submission.contact_no
        lbl_Email.text = moveInOutData.submission.email
        lbl_CompanyName.text = moveInOutData.submission.mover_comp
        lbl_PersonInCharge.text = moveInOutData.submission.in_charge_name
        lbl_CompanyContactNo.text = moveInOutData.submission.comp_contact_no
        lbl_WorkStart.text = moving_startStr
        lbl_WorkEnd.text = moving_endStr
        
        
        self.showBottomMenu()
    }
  
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.closeMenu()
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return view_Footer
    }
    @objc func done(){
        self.view.endEditing(true)
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0

    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let count = moveInOutData.sub_con.count
        ht_Table.constant = CGFloat(40 + (45 * count))
        if indexPath.row == 1{
            return CGFloat((45 * count) + 995) +  50
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
       
        txt_Status.layer.cornerRadius = 20.0
        txt_Status.layer.masksToBounds = true
        
        view_Background.layer.cornerRadius = 25.0
        view_Background.layer.masksToBounds = true
      
        imgView_Profile.addborder()
       
        for btn in arr_Btns{
            btn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
          
            btn.layer.cornerRadius = 10.0 }
       
    }
    //MARK: ***************  PARSING ***************
    func  deleteMoveInOut(){
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
       
        let param = [
            "login_id" : userId,
            "id" : moveInOutData.submission.id,
          
        ] as [String : Any]

        ApiService.delete_EForm(formType: eForm.moveInOut, parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
            self.isToDelete  = false
            if status  && result != nil{
                 if let response = (result as? DeleteUserBase){
                    if response.response == 1{
                        DispatchQueue.main.async {
                            self.alertView_message.delegate = self
                            self.alertView_message.showInView(self.view_Background, title: "Move In Out Application has\n been deleted", okTitle: "Home", cancelTitle: "View Summary")
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
    func  updateMoveInOut(){
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
       
        let param = [
            "login_id" : userId,
            "id" : moveInOutData.submission.id,
            "remarks": txtView_Remarks.text!,
            "status":  txt_Status.text ==  "New" ? 0 :
                txt_Status.text ==  "Cancelled" ? 1 :
                txt_Status.text ==  "In Progress" ? 2 :
                txt_Status.text ==  "Approved" ? 3 :
                txt_Status.text ==  "Rejected" ? 4 :
                txt_Status.text ==  "Payment Pending" ? 5 :
                txt_Status.text ==  "Refunded" ? 6 : 0
               
          
        ] as [String : Any]

        ApiService.update_EForm(formType: .moveInOut, parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
            self.isToDelete  = false
            if status  && result != nil{
                 if let response = (result as? DeleteUserBase){
                    if response.response == 1{
                        DispatchQueue.main.async {
                            self.alertView_message.delegate = self
                            self.alertView_message.showInView(self.view_Background, title: "Move In Out Application has\n been updated", okTitle: "Home", cancelTitle: "View Summary")
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
    @IBAction func actionStatus(_ sender:UIButton) {
        
        let arrStatus = [ "New", "Approved", "In Progress", "Cancelled", "Rejected", "Payment Pending", "Refunded"]
        let dropDown_Status = DropDown()
        dropDown_Status.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Status.dataSource = arrStatus//statusData.map({$0.value})//Array(statusData.values)
        dropDown_Status.show()
        dropDown_Status.selectionAction = { [unowned self] (index: Int, item: String) in
            txt_Status.text = item
           
            
        }
    }
    @IBAction func actionUpdate(_ sender:UIButton) {
        if txt_Status.text == ""{
            self.displayErrorAlert(alertStr: "Please enter status", title: "")
        }
        else if txtView_Remarks.textColor == placeholderColor{
            self.displayErrorAlert(alertStr: "Please enter management remarks", title: "")
        }
        else{
            self.updateMoveInOut()
        }
    }
    @IBAction func actionDelete(_ sender: UIButton){
        showDeleteAlert()
        
    }
    func showDeleteAlert(){
        isToDelete = true
        alertView.delegate = self
        alertView.showInView(self.view_Background, title: "Are you sure you want to\n delete the following\n move in out application?", okTitle: "Yes", cancelTitle: "Back")
      
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
    @IBAction func actionAnnouncement(_ sender: UIButton){
        self.menu.contractMenu()
//        let announcementTVC = kStoryBoardMain.instantiateViewController(identifier: "AnnouncementTableViewController") as! AnnouncementTableViewController
//        self.navigationController?.pushViewController(announcementTVC, animated: true)
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
class DataSource_MoveInOut: NSObject, UITableViewDataSource, UITableViewDelegate {
    var parentVc: UIViewController!
    var moveInOutData: MoveInOut!
func numberOfSectionsInTableView(tableView: UITableView) -> Int {

    return 1;
}

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  moveInOutData.sub_con.count
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "workerCell") as! EFormSubContractorTableViewCell
        cell.selectionStyle = .none
           
        cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
        cell.view_Outer.tag = indexPath.row
       
        let data = moveInOutData.sub_con[indexPath.row]
        
       
       
        cell.lbl_Indx.text = "\(indexPath.row + 1)"
       
        cell.lbl_Worker.text = data.workman
        cell.lbl_Passport.text = data.id_number
       // cell.lbl_ExpiryDate.text = expdateStr
        
        let idType   = data.id_type == 1 ? "Passport" :
        data.id_type == 2 ? "NRIC"   :
        "Work Permit"
        if data.id_type == 3{
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let expdate = formatter.date(from: data.permit_expiry)
            formatter.dateFormat = "dd/MM/yy"
            let expdateStr = formatter.string(from: expdate ?? Date())
            cell.lbl_ExpiryDate.text = expdateStr
        }
        else{
            cell.lbl_ExpiryDate.text = "-"
        }
        
        
        
        cell.selectionStyle = .none
        return cell
      
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
 
}
extension MoveIODetailsTableViewController: MenuViewDelegate{
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

   
   



extension MoveIODetailsTableViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
       
            
        
    }
}
extension MoveIODetailsTableViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == placeholderColor {
                textView.text = nil
            textView.textColor = textColor
            }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
               textView.text = "Enter Remarks"
               textView.textColor = placeholderColor
           }
    }
}
extension MoveIODetailsTableViewController: AlertViewDelegate{
    func onBackClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func onCloseClicked() {
        
    }
    
    func onOkClicked() {
        if isToDelete == true{
            deleteMoveInOut()
        }
    }
    
    
}
extension MoveIODetailsTableViewController: MessageAlertViewDelegate{
    func onHomeClicked() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func onListClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
