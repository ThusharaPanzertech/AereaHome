//
//  UpdateAddressTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 10/02/22.
//

import UIKit
import DropDown
class UpdateAddressTableViewController: BaseTableViewController {
    
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
    @IBOutlet weak var lbl_UnitNo: UILabel!
    @IBOutlet weak var lbl_ContactNo: UILabel!
    @IBOutlet weak var lbl_Email: UILabel!
    @IBOutlet weak var lbl_DeclaredBy: UILabel!
    @IBOutlet weak var lbl_Address: UILabel!
  
    @IBOutlet weak var imgView_OwnerSign: UIImageView!
    @IBOutlet weak var imgView_NomineeSign: UIImageView!
    
    @IBOutlet weak var view_SwitchProperty: UIView!
    @IBOutlet weak var lbl_SwitchProperty: UILabel!
    
    
    @IBOutlet weak var txt_Status: UITextField!
    @IBOutlet weak var txtView_Remarks: UITextView!
   
    @IBOutlet  var arr_Btns: [UIButton]!
    let menu: MenuView = MenuView.getInstance

    var updateAddressData: UpdateAddress!
   
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
       
        txtView_Remarks.delegate = self
        view_SwitchProperty.layer.borderColor = themeColor.cgColor
        view_SwitchProperty.layer.borderWidth = 1.0
        view_SwitchProperty.layer.cornerRadius = 10.0
        view_SwitchProperty.layer.masksToBounds = true
        lbl_SwitchProperty.text = kCurrentPropertyName
        setUpUI()
          let fname = Users.currentUser?.moreInfo?.first_name ?? ""
        let lname = Users.currentUser?.moreInfo?.last_name ?? ""
        self.lbl_UserName.text = "\(fname) \(lname)"
        let role = Users.currentUser?.role
        self.lbl_UserRole.text = role
        txt_Status.text = updateAddressData.submission.status == 0 ? "New" :
            updateAddressData.submission.status == 1 ? "Cancelled" :
            updateAddressData.submission.status == 2 ? "In Progress" :
            updateAddressData.submission.status == 3 ? "Approved" :
            updateAddressData.submission.status == 4 ? "Rejected" :
            updateAddressData.submission.status == 5 ? "Payment Pending" :
            updateAddressData.submission.status == 6 ? "Refunded" : ""
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
       
       
    
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
       
        if updateAddressData.submission.remarks != ""{
            txtView_Remarks.text = updateAddressData.submission.remarks
            txtView_Remarks.textColor =
                textColor
        }
        else{
            txtView_Remarks.text = "Enter Remarks"
            txtView_Remarks.textColor = placeholderColor
        }
        
        
        getAddressInfo()
        txt_Status.layer.cornerRadius = 20.0
        txt_Status.layer.masksToBounds = true
        view_Background.layer.cornerRadius = 25.0
        view_Background.layer.masksToBounds = true
      
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        let moving_date = formatter.date(from: updateAddressData.submission.request_date)
     
        formatter.dateFormat = "dd/MM/yy"
        let moving_dateStr = formatter.string(from: moving_date ?? Date())
       
      
        
        lbl_Ticket.text = updateAddressData.submission.ticket
        lbl_SubmittedDate.text = moving_dateStr
       // lbl_UnitNo.text = updateAddressData.unit?.unit
        let unit = updateAddressData.unit?.unit
        lbl_UnitNo.text = unit == nil ? "" : "#\(unit!)"
        lbl_ContactNo.text = updateAddressData.submission.contact_no
        lbl_Email.text = updateAddressData.submission.email
        lbl_DeclaredBy.text = updateAddressData.submission.owner_name
        lbl_Address.text = updateAddressData.submission.address
        
     
        
        
        imgView_Profile.addborder()
       
        for btn in arr_Btns{
            btn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
          
            btn.layer.cornerRadius = 10.0 }
       
    }
    //MARK: ***************  PARSING ***************
    func  getAddressInfo(){
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
       
        let param = [
            "login_id" : userId,
            "id" : updateAddressData.submission.id,
          
        ] as [String : Any]

        ApiService.get_UpdateAddressInfo(parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
           
            if status  && result != nil{
                 if let response = (result as? UpdateAddressInfoSummaryBase){
                    if response.response == 1{
                        self.lbl_Address.text = response.details.submission.address
                        if  response.details.submission.remarks != ""{
                            self.txtView_Remarks.text =  response.details.submission.remarks
                            self.txtView_Remarks.textColor =
                                textColor
                        }
                        let sign1 = response.details.submission.owner_signature
                        if let url1 = URL(string: "\(kImageFilePath)/" + sign1) {
                            self.imgView_OwnerSign.af_setImage(
                                        withURL: url1,
                                        placeholderImage: nil,
                                        filter: nil,
                                        imageTransition: .crossDissolve(0.2)
                                    )
                        }
                        
                        let sign2 = response.details.submission.nominee_signature
                        if let url2 = URL(string: "\(kImageFilePath)/" + sign2) {
                            self.imgView_NomineeSign.af_setImage(
                                        withURL: url2,
                                        placeholderImage: nil,
                                        filter: nil,
                                        imageTransition: .crossDissolve(0.2)
                                    )
                        }
                        let image = self.convertBase64StringToImage(imageBase64String: sign1)
                        if image != nil{
                         self.imgView_OwnerSign.image = image
                         }
                         let image1 = self.convertBase64StringToImage(imageBase64String: sign2)
                         if image1 != nil{
                          self.imgView_NomineeSign.image = image1
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
    func  deleteUpdateAddress(){
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
       
        let param = [
            "login_id" : userId,
            "id" : updateAddressData.submission.id,
          
        ] as [String : Any]

        ApiService.delete_EForm(formType: eForm.updateAddress, parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
            self.isToDelete  = false
            if status  && result != nil{
                 if let response = (result as? DeleteUserBase){
                    if response.response == 1{
                        DispatchQueue.main.async {
                            self.alertView_message.delegate = self
                            self.alertView_message.showInView(self.view_Background, title: "Change Mailing Address Application has\n been deleted", okTitle: "Home", cancelTitle: "View Summary")
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
    func  updateAddress(){
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
       
        let param = [
            "login_id" : userId,
            "id" : updateAddressData.submission.id,
            "remarks": txtView_Remarks.text!,
            "status":  txt_Status.text ==  "New" ? 0 :
                txt_Status.text ==  "Cancelled" ? 1 :
                txt_Status.text ==  "In Progress" ? 2 :
                txt_Status.text ==  "Approved" ? 3 :
                txt_Status.text ==  "Rejected" ? 4 : 0
               
          
        ] as [String : Any]

        ApiService.update_EForm(formType: .updateAddress, parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
            self.isToDelete  = false
            if status  && result != nil{
                 if let response = (result as? DeleteUserBase){
                    if response.response == 1{
                        DispatchQueue.main.async {
                            self.alertView_message.delegate = self
                            self.alertView_message.showInView(self.view_Background, title: "Change Mailing Address Application has\n been updated", okTitle: "Home", cancelTitle: "View Summary")
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
            self.updateAddress()
        }
    }
    @IBAction func actionDelete(_ sender: UIButton){
        showDeleteAlert()
        
    }
    func showDeleteAlert(){
        isToDelete = true
        alertView.delegate = self
        alertView.showInView(self.view_Background, title: "Are you sure you want to\n delete the following\n change mailing address application?", okTitle: "Yes", cancelTitle: "Back")
      
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

extension UpdateAddressTableViewController: MenuViewDelegate{
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

   
   



extension UpdateAddressTableViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
       
            
        
    }
}
extension UpdateAddressTableViewController: UITextViewDelegate{
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
extension UpdateAddressTableViewController: AlertViewDelegate{
    func onBackClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func onCloseClicked() {
        
    }
    
    func onOkClicked() {
        if isToDelete == true{
            deleteUpdateAddress()
        }
    }
    
    
}
extension UpdateAddressTableViewController: MessageAlertViewDelegate{
    func onHomeClicked() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func onListClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
