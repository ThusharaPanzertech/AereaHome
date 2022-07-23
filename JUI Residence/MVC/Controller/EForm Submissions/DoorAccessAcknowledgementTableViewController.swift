//
//  DoorAccessAcknowledgementTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 18/02/22.
//

import UIKit

class DoorAccessAcknowledgementTableViewController: BaseTableViewController {
    
    var eForm : String!
    let menu: MenuView = MenuView.getInstance
    var isToShowSucces = false
     //Outlets
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
    @IBOutlet weak var txt_AccessCardNo: UITextField!
    @IBOutlet weak var txt_SerialNo: UITextField!
    @IBOutlet weak var txt_RecvdBy: UITextField!
    @IBOutlet weak var txt_Manager: UITextField!
   
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
        let fname = Users.currentUser?.user?.name ?? ""
        let lname = Users.currentUser?.moreInfo?.last_name ?? ""
        self.lbl_UserName.text = "\(fname) \(lname)"
        let role = Users.currentUser?.role?.name ?? ""
        self.lbl_UserRole.text = role
        for btn in arr_Buttons{
            btn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
            btn.layer.cornerRadius = 8.0
        }
         view_Background.layer.cornerRadius = 25.0
         view_Background.layer.masksToBounds = true
        view_Background1.layer.cornerRadius = 25.0
        view_Background1.layer.masksToBounds = true
        
       
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
    
        if self.doorAccessData.acknowledgement != nil{
            self.txt_Manager.text = self.doorAccessData.acknowledgement.manager_issued
            self.txt_AccessCardNo.text = self.doorAccessData.acknowledgement.number_of_access_card
            self.txt_SerialNo.text = self.doorAccessData.acknowledgement.serial_number_of_card
            self.txt_RecvdBy.text = self.doorAccessData.acknowledgement.acknowledged_by
            
            
         
        let sign1 = self.doorAccessData.acknowledgement.signature
        let image = self.convertBase64StringToImage(imageBase64String: sign1)
        if image != nil{
            self.signature1 = image
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
        if doorAccessData.acknowledgement != nil{
            params.setValue("\(doorAccessData.acknowledgement.id)", forKey: "ack_id")
        }
            
        if doorAccessData.payment != nil{
            params.setValue(doorAccessData.payment.receipt_no, forKey: "receipt_no")
          
        }
        params.setValue(txt_AccessCardNo.text!, forKey: "number_of_access_card")
        params.setValue(txt_SerialNo.text!, forKey: "serial_number_of_card")
        params.setValue(txt_Manager.text!, forKey: "manager_issued")
        params.setValue(txt_RecvdBy.text, forKey: "acknowledged_by")
        params.setValue(dateStr_today, forKey: "date_of_signature")
        
       
        var data : Data!
     if signature1 != nil{
        data = signature1.jpegData(compressionQuality: 0.5)! as NSData as Data
     }
    
       
        ApiService.submit_DoorAccessAcknowledgement(signature: data, parameters: params as! [String : Any]) { status, result, error in
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
         
      
        guard txt_AccessCardNo.text!.count  > 0 else {
            displayErrorAlert(alertStr: "Please enter the access card number", title: "")
            return
        }
        guard txt_SerialNo.text!.count  > 0 else {
            displayErrorAlert(alertStr: "Please enter the serial number", title: "")
            return
        }
        guard txt_RecvdBy.text!.count  > 0 else {
            displayErrorAlert(alertStr: "Please enter the resident name", title: "")
            return
        }
    guard txt_Manager.text!.count  > 0 else {
        displayErrorAlert(alertStr: "Please enter the name of management", title: "")
        return
    }
   
      
       
      
      
        if signature1 == nil{
            displayErrorAlert(alertStr: "Please enter the signature of the management", title: "")
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




extension DoorAccessAcknowledgementTableViewController:SignatureViewDelegate{
    func onDoneClicked(image: UIImage, name: String, signView: SignatureView) {
        if signView.tag == 1{
            self.signature1 = image
            self.imgView_signature1.image = image
        }
       
    }
    
    
}
extension DoorAccessAcknowledgementTableViewController: AlertViewDelegate{
    func onBackClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func onCloseClicked() {
        
    }
    
    func onOkClicked() {
       
    }
    
    
}

extension DoorAccessAcknowledgementTableViewController: MessageAlertViewDelegate{
    func onHomeClicked() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func onListClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
extension DoorAccessAcknowledgementTableViewController: MenuViewDelegate{
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
extension DoorAccessAcknowledgementTableViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
       
            
        
    }
}
