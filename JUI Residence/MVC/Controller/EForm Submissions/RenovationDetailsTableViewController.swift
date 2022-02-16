//
//  RenovationDetailsTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 10/02/22.
//

import UIKit
import DropDown
class RenovationDetailsTableViewController:  BaseTableViewController {
    
    //Outlets
    var isToDelete = false
    let alertView: AlertView = AlertView.getInstance
    let alertView_message: MessageAlertView = MessageAlertView.getInstance
    let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
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
    @IBOutlet weak var lbl_CompanyAddress: UILabel!
    @IBOutlet weak var lbl_PersonInCharge: UILabel!
    @IBOutlet weak var lbl_CompanyContactNo: UILabel!
    @IBOutlet weak var lbl_WorkStart: UILabel!
    @IBOutlet weak var lbl_WorkEnd: UILabel!
    @IBOutlet weak var lbl_HackingWorkStart: UILabel!
    @IBOutlet weak var lbl_HackingWorkEnd: UILabel!
    
    
    
    
    
    @IBOutlet weak var txt_Status: UITextField!
    @IBOutlet weak var txtView_Remarks: UITextView!
   
    @IBOutlet  var arr_Btns: [UIButton]!
    let menu: MenuView = MenuView.getInstance
    @IBOutlet weak var table_Renovation: UITableView!
    var dataSource = DataSource_Renovation()

    var renovationData: Renovation!
   
    var unitsData = [String: String]()
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
        if renovationData.submission.remarks != ""{
            txtView_Remarks.text = renovationData.submission.remarks
            txtView_Remarks.textColor =
                textColor
        }
        else{
            txtView_Remarks.text = "Enter Remarks"
            txtView_Remarks.textColor = placeholderColor
        }
        txtView_Remarks.delegate = self
        
        table_Renovation.dataSource = dataSource
        table_Renovation.delegate = dataSource
        dataSource.parentVc = self
        dataSource.renovationData = self.renovationData
        setUpUI()
        let fname = Users.currentUser?.user?.name ?? ""
        let lname = Users.currentUser?.moreInfo?.last_name ?? ""
        self.lbl_UserName.text = "\(fname) \(lname)"
        let role = Users.currentUser?.role?.name ?? ""
        self.lbl_UserRole.text = role
        txt_Status.text = renovationData.submission.status == 0 ? "New" :
            renovationData.submission.status == 1 ? "Cancelled" :
            renovationData.submission.status == 2 ? "In Progress" :
            renovationData.submission.status == 3 ? "Approved" :
            renovationData.submission.status == 4 ? "Rejected" :
            renovationData.submission.status == 5 ? "Payment Pending" :
            renovationData.submission.status == 6 ? "Refunded" : ""
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vw_Table.layer.cornerRadius = 10.0
        vw_Table.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
       
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let moving_date = formatter.date(from: renovationData.submission.reno_date)
        let moving_start = formatter.date(from: renovationData.submission.reno_start)
        let moving_end = formatter.date(from: renovationData.submission.reno_end)
        let hack_start = formatter.date(from: renovationData.submission.hacking_work_start)
        let hack_end = formatter.date(from: renovationData.submission.hacking_work_end)
        formatter.dateFormat = "dd/MM/yyyy"
        let moving_dateStr = formatter.string(from: moving_date ?? Date())
        let moving_startStr = formatter.string(from: moving_start ?? Date())
        let moving_endStr = formatter.string(from: moving_end ?? Date())
        let hack_startStr = formatter.string(from: hack_start ?? Date())
        let hack_endStr = formatter.string(from: hack_end ?? Date())
       
        
        lbl_Ticket.text = renovationData.submission.ticket
        lbl_SubmittedDate.text = moving_dateStr
        lbl_ResidentName.text = renovationData.submission.resident_name
        lbl_UnitNo.text = renovationData.unit.unit
        lbl_ContactNo.text = renovationData.submission.contact_no
        lbl_Email.text = renovationData.submission.email
        lbl_CompanyName.text = renovationData.submission.reno_comp
        lbl_CompanyAddress.text = renovationData.submission.comp_address
        lbl_PersonInCharge.text = renovationData.submission.in_charge_name
        lbl_CompanyContactNo.text = renovationData.submission.comp_contact_no
        lbl_WorkStart.text = moving_startStr
        lbl_WorkEnd.text = moving_endStr
        lbl_HackingWorkStart.text = hack_startStr
        lbl_HackingWorkEnd.text = hack_endStr
        
        
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
        
        let count = renovationData.sub_con.count
        ht_Table.constant = CGFloat(40 + (45 * count))
        if indexPath.row == 1{
            return CGFloat((45 * count) + 1110) +  40
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
    func  deleteRenovation(){
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
       
        let param = [
            "login_id" : userId,
            "id" : renovationData.submission.id,
          
        ] as [String : Any]

        ApiService.delete_EForm(formType: eForm.renovation, parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
            self.isToDelete  = false
            if status  && result != nil{
                 if let response = (result as? DeleteUserBase){
                    if response.response == 1{
                        DispatchQueue.main.async {
                            self.alertView_message.delegate = self
                            self.alertView_message.showInView(self.view_Background, title: "Renovation Application has\n been deleted", okTitle: "Home", cancelTitle: "View Summary")
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
    func  updateRenovation(){
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
       
        let param = [
            "login_id" : userId,
            "id" : renovationData.submission.id,
            "remarks": txtView_Remarks.text!,
            "status":  txt_Status.text ==  "New" ? 0 :
                txt_Status.text ==  "Cancelled" ? 1 :
                txt_Status.text ==  "In Progress" ? 2 :
                txt_Status.text ==  "Approved" ? 3 :
                txt_Status.text ==  "Rejected" ? 4 : 0
               
          
        ] as [String : Any]

        ApiService.update_EForm(formType: .renovation, parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
            self.isToDelete  = false
            if status  && result != nil{
                 if let response = (result as? DeleteUserBase){
                    if response.response == 1{
                        DispatchQueue.main.async {
                            self.alertView_message.delegate = self
                            self.alertView_message.showInView(self.view_Background, title: "Renovation Application has\n been updated", okTitle: "Home", cancelTitle: "View Summary")
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
    @IBAction func actionStatus(_ sender:UIButton) {
        
        let arrStatus = [ "New", "Approved", "In Progress", "Cancelled", "Rejected"]
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
            self.updateRenovation()
        }
    }
    @IBAction func actionDelete(_ sender: UIButton){
        showDeleteAlert()
        
    }
    func showDeleteAlert(){
        isToDelete = true
        alertView.delegate = self
        alertView.showInView(self.view_Background, title: "Are you sure you want to\n delete the following\n renovation application?", okTitle: "Yes", cancelTitle: "Back")
      
    }
    
    //MARK: MENU ACTIONS
    
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
class DataSource_Renovation: NSObject, UITableViewDataSource, UITableViewDelegate {
    var parentVc: UIViewController!
    var renovationData: Renovation!
func numberOfSectionsInTableView(tableView: UITableView) -> Int {

    return 1;
}

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  renovationData.sub_con.count
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "workerCell") as! EFormSubContractorTableViewCell
        cell.selectionStyle = .none
           
        cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
        cell.view_Outer.tag = indexPath.row
       
        let data = renovationData.sub_con[indexPath.row]
        
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let expdate = formatter.date(from: data.permit_expiry)
        formatter.dateFormat = "dd/MM/yyyy"
        let expdateStr = formatter.string(from: expdate ?? Date())
        
        cell.lbl_Indx.text = "\(indexPath.row + 1)"
       
        cell.lbl_Worker.text = data.workman
        cell.lbl_Passport.text = data.nric
        cell.lbl_ExpiryDate.text = expdateStr
        
        cell.selectionStyle = .none
        return cell
      
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
 
}
extension RenovationDetailsTableViewController: MenuViewDelegate{
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

   
   



extension RenovationDetailsTableViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
       
            
        
    }
}
extension RenovationDetailsTableViewController: UITextViewDelegate{
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
extension RenovationDetailsTableViewController: AlertViewDelegate{
    func onBackClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func onCloseClicked() {
        
    }
    
    func onOkClicked() {
        if isToDelete == true{
            deleteRenovation()
        }
    }
    
    
}
extension RenovationDetailsTableViewController: MessageAlertViewDelegate{
    func onHomeClicked() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func onListClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
