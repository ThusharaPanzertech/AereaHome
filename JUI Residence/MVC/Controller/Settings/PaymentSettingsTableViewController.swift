//
//  PaymentSettingsTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 08/07/22.
//

import UIKit

class PaymentSettingsTableViewController: BaseTableViewController {
    
    //Outlets
    @IBOutlet weak var txt_PayableTo: UITextField!
    @IBOutlet weak var txt_AccountHolderName: UITextField!
    @IBOutlet weak var txt_AccountNo: UITextField!
    @IBOutlet weak var txt_AccountType: UITextField!
    @IBOutlet weak var txt_BankName: UITextField!
    @IBOutlet weak var txt_BankAddress: UITextField!
    @IBOutlet weak var txt_BankSwiftCode: UITextField!
    @IBOutlet weak var txt_CashPaymentInfo: UITextView!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var imgView_Profile: UIImageView!
    @IBOutlet var arr_Textfields: [UITextField]!
    var paymentInfo : PaymentInfo!
    let menu: MenuView = MenuView.getInstance
   
    @IBOutlet weak var btn_Cheque: UIButton!
    @IBOutlet weak var btn_Bank: UIButton!
    @IBOutlet weak var btn_Cash: UIButton!
    @IBOutlet weak var btn_Submit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fname = Users.currentUser?.user?.name ?? ""
        let lname = Users.currentUser?.moreInfo?.last_name ?? ""
        self.lbl_UserName.text = "\(fname) \(lname)"
        let role = Users.currentUser?.role?.name ?? ""
        self.lbl_UserRole.text = role
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
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupUI()
        self.getPaymentInfo()
        self.showBottomMenu()
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
    
    func setupUI(){
        for txtField in arr_Textfields{
            txtField.delegate = self
            txtField.layer.cornerRadius = 20.0
            txtField.layer.masksToBounds = true
            txtField.textColor = textColor
            txtField.attributedPlaceholder = NSAttributedString(string: txtField.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
        }
        txt_CashPaymentInfo.layer.cornerRadius = 20.0
        txt_CashPaymentInfo.layer.masksToBounds = true
        view_Background.layer.cornerRadius = 25.0
        view_Background.layer.masksToBounds = true
        //ToolBar
          let toolbar = UIToolbar();
          toolbar.sizeToFit()
          let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([spaceButton,doneButton], animated: false)
        txt_CashPaymentInfo.inputAccessoryView = toolbar
        
        txt_CashPaymentInfo.contentInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        btn_Submit.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
        btn_Submit.layer.cornerRadius = 8.0
    }
    @objc func done(){
        self.view.endEditing(true)
    }
    //MARK: ******  PARSING *********
    func getPaymentInfo(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        
        ApiService.get_PaymentSettings(parameters: ["login_id":userId], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? PaymentInfoSummaryBase){
                     self.paymentInfo = response.data
                     self.txt_PayableTo.text = self.paymentInfo.cheque_payable_to
                     self.txt_AccountHolderName.text = self.paymentInfo.account_holder_name
                     self.txt_AccountNo.text = self.paymentInfo.account_number
                     self.txt_AccountType.text = self.paymentInfo.account_type
                     self.txt_BankName.text = self.paymentInfo.bank_name
                     self.txt_BankAddress.text = self.paymentInfo.bank_address
                     self.txt_BankSwiftCode.text = self.paymentInfo.swift_code
                     self.txt_CashPaymentInfo.text = self.paymentInfo.cash_payment_info
                     if self.txt_CashPaymentInfo.text == ""
                     {
                         self.txt_CashPaymentInfo.text = "Please enter cash payment information"
                         self.txt_CashPaymentInfo.textColor = placeholderColor
                     }
                     else{
                         self.txt_CashPaymentInfo.textColor = textColor
                     }
                    self.tableView.reloadData()
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
    func submitPaymentInfo(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        
        let param = [
            "login_id" : userId,
            "id" : self.paymentInfo.id ?? 0,
            "terms1" : self.btn_Cheque.isSelected == true ? "1" : "0",
            "cheque_payable_to" : txt_PayableTo.text!,
            "terms2" : self.btn_Bank.isSelected == true ? "1" : "0",
            "account_holder_name" : txt_AccountHolderName.text!,
            "account_number" : txt_AccountNo.text!,
            "account_type" : txt_AccountType.text!,
            "bank_name" : txt_BankName.text!,
            "bank_address" : txt_BankAddress.text!,
            "swift_code" : txt_BankSwiftCode.text!,
            "terms3" : self.btn_Cash.isSelected == true ? "1" : "0",
            "cash_payment_info" : txt_CashPaymentInfo.text!
          
        ] as [String : Any]
        
        
        ApiService.submit_PaymentInfo(parameters: param, completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? PaymentInfoSummaryBase){
                     self.displayErrorAlert(alertStr: "Payment Info updated", title: "Alert")
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
    //MARK: UIButton Action
   
    @IBAction func actionCheckbox(_ sender: UIButton){
        sender.isSelected = !sender.isSelected
       /* if sender.tag == 1{
            btn_Cheque.isSelected = true
            btn_Cash.isSelected = false
            btn_Bank.isSelected = false
        }
        else if sender.tag == 2{
            btn_Cheque.isSelected = false
            btn_Cash.isSelected = false
            btn_Bank.isSelected = true
        }
        else{
            btn_Cheque.isSelected = false
            btn_Cash.isSelected = true
            btn_Bank.isSelected = false
        }
        */
    }
    
    @IBAction func actionSubmit(_ sender: UIButton){
        self.submitPaymentInfo()
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

extension PaymentSettingsTableViewController: MenuViewDelegate{
    func onMenuClicked(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            self.menu.contractMenu()
            self.navigationController?.popToRootViewController(animated: true)
            break
        case 2:
            self.actionInbox(sender)
            break
        case 3:
            self.goToSettings()
            break
        case 4:
            self.actionLogout(sender)
            break
        case 5:
            self.menu.contractMenu()
            self.actionAnnouncement(sender)
            break
        case 6:
            self.menu.contractMenu()
            self.actionAppointmemtUnitTakeOver(sender)
            break
        case 7:
            self.menu.contractMenu()
            self.actionDefectList(sender)
            break
        case 8:
            self.menu.contractMenu()
            self.actionAppointmentJointInspection(sender)
            break
        case 9:
            self.menu.contractMenu()
            self.actionFacilityBooking(sender)
            break
        case 10:
            self.menu.contractMenu()
            self.actionFeedback(sender)
            break
        default:
            break
        }
    }
    
    func onCloseClicked(_ sender: UIButton) {
        
    }
    
    
}
extension PaymentSettingsTableViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
extension PaymentSettingsTableViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == placeholderColor {
                textView.text = nil
            textView.textColor = textColor
            }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
               textView.text = "Please enter cash payment information"
               textView.textColor = placeholderColor
           }
    }
}
