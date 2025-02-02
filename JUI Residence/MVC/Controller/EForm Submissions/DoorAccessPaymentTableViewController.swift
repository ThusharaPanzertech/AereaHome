//
//  DoorAccessPaymentTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 16/02/22.
//

import UIKit
import DropDown
class DoorAccessPaymentTableViewController: BaseTableViewController {
    
    var eForm : String!
    let menu: MenuView = MenuView.getInstance
    var isToShowSucces = false
     //Outlets
    @IBOutlet weak var view_SwitchProperty: UIView!
    @IBOutlet weak var lbl_SwitchProperty: UILabel!
     @IBOutlet weak var lbl_UserName: UILabel!
     @IBOutlet weak var lbl_UserRole: UILabel!
     @IBOutlet weak var lbl_Title: UILabel!
     @IBOutlet weak var lbl_SubTitle: UILabel!
    @IBOutlet weak var lbl_SuccessTitle: UILabel!
    @IBOutlet weak var lbl_SuccessSubTitle: UILabel!
     @IBOutlet weak var btn_Next: UIButton!
     @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var view_Background1: UIView!
     @IBOutlet weak var imgView_Profile: UIImageView!
    @IBOutlet var arr_Buttons: [UIButton]!
    @IBOutlet var arr_Views: [UIView]!
    @IBOutlet var arr_TextFields: [UITextField]!
    @IBOutlet weak var txt_Cheque: UITextField!
    @IBOutlet weak var txt_Bank: UITextField!
    @IBOutlet weak var txt_Amount: UITextField!
    @IBOutlet weak var txt_ReceiptNo: UITextField!
    @IBOutlet weak var txt_Acknowledge: UITextField!
    @IBOutlet weak var txt_Manager: UITextField!
    @IBOutlet weak var txt_AccHolder: UITextField!
    @IBOutlet weak var txt_AccType: UITextField!
    @IBOutlet weak var txt_AccNo: UITextField!
    @IBOutlet weak var txt_BankName: UITextField!
    @IBOutlet weak var txt_SwiftCode: UITextField!
    @IBOutlet weak var txt_BankAddress: UITextField!
   
    //@IBOutlet weak var txt_SignDate: UITextField!
    @IBOutlet weak var imgView_signature1 : UIImageView!
  
    let view_Signature: SignatureView = SignatureView.getInstance
    var signature1 : UIImage!
    var doorAccessData: DoorAccess!
    var formType : eForm!
    
     override func viewDidLoad() {
         super.viewDidLoad()
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([spaceButton,doneButton], animated: false)
    //    txtView_Address.inputAccessoryView = toolbar
       
       

     //   lbl_SuccessTitle.text = "Change of Mailing\nAddress Application\nhas been submitted"
     //   lbl_SuccessSubTitle.text = "Your form has been submitted and we \nwill get back to you on the status of the\napplication"
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
        for btn in arr_Buttons{
            btn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
            btn.layer.cornerRadius = 8.0
        }
         view_Background.layer.cornerRadius = 25.0
         view_Background.layer.masksToBounds = true
        view_Background1.layer.cornerRadius = 25.0
        view_Background1.layer.masksToBounds = true
         view_SwitchProperty.layer.borderColor = themeColor.cgColor
         view_SwitchProperty.layer.borderWidth = 1.0
         view_SwitchProperty.layer.cornerRadius = 10.0
         view_SwitchProperty.layer.masksToBounds = true
         lbl_SwitchProperty.text = kCurrentPropertyName
        //self.lbl_Title.text = formType == .moveInOut ? "Moving In & Out Application" : "Renovation Work Application"
        //self.lbl_SubTitle.text = "(For official use only)"
        
        for vw in arr_Views{
            vw.layer.cornerRadius = 20.0
            vw.layer.masksToBounds = true
        }
        
        for field in arr_TextFields{
            field.layer.cornerRadius = 20.0
               field.layer.masksToBounds = true
            field.delegate = self
               field.textColor = UIColor(red: 93/255, green: 93/255, blue: 93/255, alpha: 1.0)
               field.attributedPlaceholder = NSAttributedString(string: field.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
               field.backgroundColor = UIColor(red: 208/255, green: 208/255, blue: 208/255, alpha: 1.0)
        }
       
        self.tableView.reloadData()
     }
   
    @objc func done(){self.view.endEditing(true)
    }


     override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1{
           
            return CGFloat(self.isToShowSucces == true ? 0 :  super.tableView(tableView, heightForRowAt: indexPath))
        }
        else  if indexPath.row == 2{
            return self.isToShowSucces == false ? 0 : super.tableView(tableView, heightForRowAt: indexPath)
        }
     
       return super.tableView(tableView, heightForRowAt: indexPath)
    }
     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         self.showBottomMenu()
    
        if self.doorAccessData.payment != nil{
            self.txt_Manager.text = self.doorAccessData.payment.manager_received
            self.txt_Acknowledge.text = self.doorAccessData.payment.acknowledged_by
            self.txt_ReceiptNo.text = self.doorAccessData.payment.receipt_no
            self.txt_Bank.text = self.doorAccessData.payment.cheque_bank
            self.txt_Cheque.text = self.doorAccessData.payment.cheque_no
            
            
            
            
            
            
//            txt_AccHolder.text = self.doorAccessData.payment.account_holder_name
//            txt_AccType.text = self.doorAccessData.payment.account_type
//            txt_AccNo.text = self.doorAccessData.payment.account_number
//            txt_BankName.text = self.doorAccessData.payment.bank_name
//            txt_SwiftCode.text = self.doorAccessData.payment.swift_code
//            txt_BankAddress.text = self.doorAccessData.payment.bank_address
        let sign1 = self.doorAccessData.payment.signature
        let image = self.convertBase64StringToImage(imageBase64String: sign1)
        if image != nil{
         self.imgView_signature1.image = image
         }
        }
        
       
       
     }
     override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
         
         self.closeMenu()
     }
    func showBottomMenu(){
    
    menu.delegate = self
    menu.showInView(self.view, title: "", message: "")
  
}
func closeMenu(){
    menu.removeView()
}

     override func getBackgroundImageName() -> String {
         let imgdefault = ""//UserInfoModalBase.currentUser?.data.property.defect_bg ?? ""
         return imgdefault
     }
     //MARK: ******  PARSING *********
    func submitAppication(){
       let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        let dateStr_today = formatter.string(from:  Date())
        
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
       
        let params = NSMutableDictionary()
        params.setValue("\(userId)", forKey: "login_id")
        params.setValue("\(doorAccessData.submission.id)", forKey: "id")
        if doorAccessData.payment != nil{
            params.setValue("\(doorAccessData.payment.id)", forKey: "payment_id")
        }
            
       
        params.setValue(txt_Cheque.text!, forKey: "cheque_no")
        params.setValue(txt_Bank.text!, forKey: "cheque_bank")
        params.setValue(txt_AccHolder.text!, forKey: "account_holder_name")
        params.setValue(txt_AccNo.text!, forKey: "account_number")
        params.setValue(txt_AccType.text!, forKey: "account_type")
        params.setValue(txt_BankName.text!, forKey: "bank_name")
        params.setValue(txt_BankAddress.text!, forKey: "bank_address")
        params.setValue(txt_SwiftCode.text!, forKey: "swift_code")
        params.setValue(txt_ReceiptNo.text!, forKey: "receipt_no")
        params.setValue(txt_Acknowledge.text!, forKey: "acknowledged_by")
        params.setValue(txt_Manager.text!, forKey: "manager_received")
        params.setValue(dateStr_today, forKey: "date_of_signature")
        
       
        var data : Data!
     if signature1 != nil{
        data = signature1.jpegData(compressionQuality: 0.5)! as NSData as Data
     }
    
       
        ApiService.submit_DoorAccessPayment(signature: data, parameters: params as! [String : Any]) { status, result, error in
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                if let response = (result as? MoveIOInspectionBase){
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
    @IBAction func actionHome(_ sender: UIButton){
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func actionSubmittedForms(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionSign1(_ sender: UIButton){
        self.view_Signature.delegate = self
        self.view_Signature.showInView(self.view, parent:self, tag: 1, name: txt_Manager.text!)
       
        
    }
      
    
    @IBAction func actionSubmit(_sender: UIButton){
       
//        self.isToShowSucces =  true
//        DispatchQueue.main.async {
//        self.tableView.reloadData()
//            let indexPath = NSIndexPath(row: 0, section: 0)
//            self.tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: false)
//        }
         
        guard txt_Amount.text!.count  > 0 else {
            displayErrorAlert(alertStr: "Please enter amount", title: "")
            return
        }
        guard txt_Cheque.text!.count  > 0 else {
            displayErrorAlert(alertStr: "Please enter cheque number", title: "")
            return
        }
        guard txt_Bank.text!.count  > 0 else {
            displayErrorAlert(alertStr: "Please enter bank details", title: "")
            return
        }
        guard txt_ReceiptNo.text!.count  > 0 else {
            displayErrorAlert(alertStr: "Please enter official receipt number", title: "")
            return
        }
    guard txt_Acknowledge.text!.count  > 0 else {
        displayErrorAlert(alertStr: "Please enter acknowledge by resident", title: "")
        return
    }
    guard txt_Manager.text!.count  > 0 else {
        displayErrorAlert(alertStr: "Please enter name of manager received", title: "")
        return
    }
    
      
       
      
      
        if signature1 == nil{
            displayErrorAlert(alertStr: "Please enter the name and signature of the management", title: "")
            return
        }
        else{
            submitAppication()
        }
        
        
 
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




extension DoorAccessPaymentTableViewController:SignatureViewDelegate{
    func onDoneClicked(image: UIImage, name: String, signView: SignatureView) {
        if signView.tag == 1{
            self.signature1 = image
            self.imgView_signature1.image = image
        }
       
    }
    
    
}
extension DoorAccessPaymentTableViewController: AlertViewDelegate{
    func onBackClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func onCloseClicked() {
        
    }
    
    func onOkClicked() {
       
    }
    
    
}

extension DoorAccessPaymentTableViewController: MessageAlertViewDelegate{
    func onHomeClicked() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func onListClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
extension DoorAccessPaymentTableViewController: MenuViewDelegate{
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
extension DoorAccessPaymentTableViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
       
            
        
    }
}

