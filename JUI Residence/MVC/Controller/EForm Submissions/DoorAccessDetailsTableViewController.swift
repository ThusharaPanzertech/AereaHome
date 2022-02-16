//
//  DoorAccessDetailsTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 10/02/22.
//

import UIKit
import DropDown
class DoorAccessDetailsTableViewController:BaseTableViewController {
    
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
    @IBOutlet weak var lbl_Ticket: UILabel!
    @IBOutlet weak var lbl_SubmittedDate: UILabel!
    @IBOutlet weak var lbl_OwnerName: UILabel!
    @IBOutlet weak var lbl_UnitNo: UILabel!
    @IBOutlet weak var lbl_ContactNo: UILabel!
    @IBOutlet weak var lbl_Email: UILabel!
    @IBOutlet weak var lbl_DeclaredBy: UILabel!
    @IBOutlet weak var lbl_PassportNo: UILabel!
    @IBOutlet weak var lbl_PersonInCharge: UILabel!
    @IBOutlet weak var lbl_CompanyContactNo: UILabel!
    @IBOutlet weak var lbl_CompanyEmail: UILabel!
    @IBOutlet weak var lbl_TenancyPeriod: UILabel!
    @IBOutlet weak var lbl_ResidentCard: UILabel!
    @IBOutlet weak var lbl_SchlageCard: UILabel!
    @IBOutlet weak var imgView_OwnerSign: UIImageView!
    @IBOutlet weak var imgView_NomineeSign: UIImageView!
    
    
    
    
    @IBOutlet weak var txt_Status: UITextField!
    @IBOutlet weak var txtView_Remarks: UITextView!
   
    @IBOutlet  var arr_Btns: [UIButton]!
    let menu: MenuView = MenuView.getInstance

    var doorAccessData: DoorAccess!
   
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
        if doorAccessData.submission.remarks != ""{
            txtView_Remarks.text = doorAccessData.submission.remarks
            txtView_Remarks.textColor =
                textColor
        }
        else{
            txtView_Remarks.text = "Enter Remarks"
            txtView_Remarks.textColor = placeholderColor
        }
        txtView_Remarks.delegate = self
        
      
        setUpUI()
        let fname = Users.currentUser?.user?.name ?? ""
        let lname = Users.currentUser?.moreInfo?.last_name ?? ""
        self.lbl_UserName.text = "\(fname) \(lname)"
        let role = Users.currentUser?.role?.name ?? ""
        self.lbl_UserRole.text = role
        txt_Status.text = doorAccessData.submission.status == 0 ? "New" :
            doorAccessData.submission.status == 1 ? "Cancelled" :
            doorAccessData.submission.status == 2 ? "In Progress" :
            doorAccessData.submission.status == 3 ? "Approved" :
            doorAccessData.submission.status == 4 ? "Rejected" :
            doorAccessData.submission.status == 5 ? "Payment Pending" :
            doorAccessData.submission.status == 6 ? "Refunded" : ""
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
       
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let moving_date = formatter.date(from: doorAccessData.submission.request_date)
        let tenancy_start = formatter.date(from: doorAccessData.submission.tenancy_start)
        let tenancy_end = formatter.date(from: doorAccessData.submission.tenancy_end)
       
        formatter.dateFormat = "dd/MM/yyyy"
        let moving_dateStr = formatter.string(from: moving_date ?? Date())
        let tenancy_startStr = formatter.string(from: tenancy_start ?? Date())
        let tenancy_endStr = formatter.string(from: tenancy_end ?? Date())
      
        
        lbl_Ticket.text = doorAccessData.submission.ticket
        lbl_SubmittedDate.text = moving_dateStr
        lbl_OwnerName.text = doorAccessData.submission.owner_name
        lbl_UnitNo.text = doorAccessData.unit.unit
        lbl_ContactNo.text = doorAccessData.submission.contact_no
        lbl_Email.text = doorAccessData.submission.email
        lbl_DeclaredBy.text = doorAccessData.submission.declared_by
        lbl_PassportNo.text = doorAccessData.submission.passport_no
        lbl_PersonInCharge.text = doorAccessData.submission.in_charge_name
        lbl_CompanyContactNo.text = doorAccessData.submission.comp_contact_no
        lbl_CompanyEmail.text = doorAccessData.submission.nominee_email
        lbl_TenancyPeriod.text = "\(tenancy_startStr) - \(tenancy_endStr)"
        lbl_ResidentCard.text = "\(doorAccessData.submission.no_of_card_required)"
        lbl_SchlageCard.text = "\(doorAccessData.submission.no_of_schlage_required)"
        
        
        let sign1 = doorAccessData.submission.owner_signature
        if let url1 = URL(string: "\(kImageFilePath)/" + sign1) {
            self.imgView_OwnerSign.af_setImage(
                        withURL: url1,
                        placeholderImage: nil,
                        filter: nil,
                        imageTransition: .crossDissolve(0.2)
                    )
        }
        
        let sign2 = doorAccessData.submission.owner_signature
        if let url2 = URL(string: "\(kImageFilePath)/" + sign2) {
            self.imgView_NomineeSign.af_setImage(
                        withURL: url2,
                        placeholderImage: nil,
                        filter: nil,
                        imageTransition: .crossDissolve(0.2)
                    )
        }
        
        
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
    func  deleteDoorAceess(){
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
       
        let param = [
            "login_id" : userId,
            "id" : doorAccessData.submission.id,
          
        ] as [String : Any]

        ApiService.delete_EForm(formType: eForm.doorAccess, parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
            self.isToDelete  = false
            if status  && result != nil{
                 if let response = (result as? DeleteUserBase){
                    if response.response == 1{
                        DispatchQueue.main.async {
                            self.alertView_message.delegate = self
                            self.alertView_message.showInView(self.view_Background, title: "Door Aceess Card Application has\n been deleted", okTitle: "Home", cancelTitle: "View Summary")
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
    func  updateDoorAcess(){
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
       
        let param = [
            "login_id" : userId,
            "id" : doorAccessData.submission.id,
            "remarks": txtView_Remarks.text!,
            "status":  txt_Status.text ==  "New" ? 0 :
                txt_Status.text ==  "Cancelled" ? 1 :
                txt_Status.text ==  "In Progress" ? 2 :
                txt_Status.text ==  "Approved" ? 3 :
                txt_Status.text ==  "Rejected" ? 4 : 0
               
          
        ] as [String : Any]

        ApiService.update_EForm(formType: .doorAccess, parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
            self.isToDelete  = false
            if status  && result != nil{
                 if let response = (result as? DeleteUserBase){
                    if response.response == 1{
                        DispatchQueue.main.async {
                            self.alertView_message.delegate = self
                            self.alertView_message.showInView(self.view_Background, title: "Door Access Card Application has\n been updated", okTitle: "Home", cancelTitle: "View Summary")
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
            self.updateDoorAcess()
        }
    }
    @IBAction func actionDelete(_ sender: UIButton){
        showDeleteAlert()
        
    }
    func showDeleteAlert(){
        isToDelete = true
        alertView.delegate = self
        alertView.showInView(self.view_Background, title: "Are you sure you want to\n delete the following\n door access card application?", okTitle: "Yes", cancelTitle: "Back")
      
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

extension DoorAccessDetailsTableViewController: MenuViewDelegate{
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

   
   



extension DoorAccessDetailsTableViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
       
            
        
    }
}
extension DoorAccessDetailsTableViewController: UITextViewDelegate{
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
extension DoorAccessDetailsTableViewController: AlertViewDelegate{
    func onBackClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func onCloseClicked() {
        
    }
    
    func onOkClicked() {
        if isToDelete == true{
            deleteDoorAceess()
        }
    }
    
    
}
extension DoorAccessDetailsTableViewController: MessageAlertViewDelegate{
    func onHomeClicked() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func onListClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
