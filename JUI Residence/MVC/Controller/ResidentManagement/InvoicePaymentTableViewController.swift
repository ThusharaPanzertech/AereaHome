//
//  InvoicePaymentTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 17/04/23.
//

import UIKit
import DropDown

enum PaymentMode{
    case cash
    case cheque
    case banktransfer
    case waiver
}

var array_Allocation = [[String:String]]()
class InvoicePaymentTableViewController: BaseTableViewController {
    
    
    //Outlets
    @IBOutlet weak var view_SwitchProperty: UIView!
    @IBOutlet weak var lbl_SwitchProperty: UILabel!
    @IBOutlet weak var txt_BatchNo: UITextField!
    @IBOutlet weak var txt_Status: UITextField!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var imgView_Profile: UIImageView!
    @IBOutlet var arr_Textfields: [UITextField]!
    
    @IBOutlet weak var lbl_Building: UILabel!
    @IBOutlet weak var lbl_Unit: UILabel!
    @IBOutlet weak var lbl_InvoiceAmount: UILabel!
    @IBOutlet weak var lbl_ReceivedAmount: UILabel!
    @IBOutlet weak var lbl_BalanceAmount: UILabel!
    
    @IBOutlet weak var txt_PaymentOption: UITextField!
    @IBOutlet weak var datePicker:  UIDatePicker!
    //Cheque Info
    @IBOutlet weak var txt_ChequeAmount: UITextField!
    @IBOutlet weak var txt_ChequeNo: UITextField!
    @IBOutlet weak var txt_ChequeDate: UITextField!
    @IBOutlet weak var txt_ChequeBank: UITextField!
    @IBOutlet weak var txt_ChequeReceipt: UITextField!
   //Waiver
    @IBOutlet weak var txt_WaiverAmount: UITextField!
    @IBOutlet weak var txt_WaiverDate: UITextField!
    @IBOutlet weak var txt_WaiverNote: UITextView!
    //Cash Info
    @IBOutlet weak var txt_CashAmount: UITextField!
    @IBOutlet weak var txt_CashDate: UITextField!
    @IBOutlet weak var txt_CashReceipt: UITextField!
    //Bank Transfer
    @IBOutlet weak var txt_BankAmount: UITextField!
    @IBOutlet weak var txt_BankDate: UITextField!
    @IBOutlet weak var txt_BankReceipt: UITextField!
    
    
    //@IBOutlet weak var lbl_ChequeNo: UILabel!
    var invoice: InvoiceReportInfo!
    var invoiceData: InvoiceData!
    var modeSelected = false
    var paymentMode : PaymentMode!

    let menu: MenuView = MenuView.getInstance
    @IBOutlet weak var table_InvoiceList: UITableView!
    var dataSource = DataSource_InvoiceData()
    var buildings = [String: String]()
    var array_Invoices = [BatchInfo]()
    var selectedMonth = ""
    var selectedInvoiceId = ""
    
    let alertView_message: MessageAlertView = MessageAlertView.getInstance
    let alertView: AlertView = AlertView.getInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        array_Allocation.removeAll()
        view_SwitchProperty.layer.borderColor = themeColor.cgColor
        view_SwitchProperty.layer.borderWidth = 1.0
        view_SwitchProperty.layer.cornerRadius = 10.0
        view_SwitchProperty.layer.masksToBounds = true
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
        table_InvoiceList.dataSource = dataSource
        table_InvoiceList.delegate = dataSource
        dataSource.parentVc = self
        setUpUI()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showBottomMenu()
        self.getInvoiceDetail()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.closeMenu()
    }
  
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if paymentMode == nil{
            if indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 6{
                return 0
            }
            else{
                return super.tableView(tableView, heightForRowAt: indexPath)
            }
        }
        else{
            if indexPath.row == 2{
                           return paymentMode == .cash ?  super.tableView(tableView, heightForRowAt: indexPath) : 0
                           //CGFloat((192 * array_Invoices.count) + 400)
                       }
           
            else  if indexPath.row == 3{
                return paymentMode == .cheque ?  super.tableView(tableView, heightForRowAt: indexPath) : 0
                //CGFloat((192 * array_Invoices.count) + 400)
            }
            else if indexPath.row == 4{
                return paymentMode == .banktransfer ?  super.tableView(tableView, heightForRowAt: indexPath) : 0
                //CGFloat((192 * array_Invoices.count) + 400)
            }
            else if indexPath.row == 5{
                return paymentMode == .waiver ?  super.tableView(tableView, heightForRowAt: indexPath) : 0
                //CGFloat((192 * array_Invoices.count) + 400)
            }
            else if indexPath.row == 6{
                let count = invoiceData == nil ? 0 : invoiceData.details.count
                return CGFloat((225 * count) + 120)
            }
            else{
                return super.tableView(tableView, heightForRowAt: indexPath)
                
            }
        }
      
    
    }
    func showBottomMenu(){
    
    menu.delegate = self
    menu.showInView(self.view, title: "", message: "")
  
}
func closeMenu(){
    menu.removeView()
}
    func setUpUI(){
       
        lbl_SwitchProperty.text = kCurrentPropertyName
        
        view_Background.layer.cornerRadius = 25.0
        view_Background.layer.masksToBounds = true
      
        imgView_Profile.addborder()
       
        for txtField in arr_Textfields{
            txtField.delegate = self
            txtField.layer.cornerRadius = 20.0
            txtField.layer.masksToBounds = true
            txtField.textColor = textColor
            txtField.attributedPlaceholder = NSAttributedString(string: txtField.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
        }
      
    
//        let expiryDatePicker = MonthYearPickerView()
//        expiryDatePicker.onDateSelected = { (month: Int, year: Int) in
//            let string = String(format: "%02d/%d", month, year)
//            NSLog(string) // should show something like 05/2015
//
//            self.txt_Status.text = string
//
//
//            self.selectedMonth = String(format: "%d-%02d",  year, month)
//
//        }
         
      
//        let toolbar = UIToolbar();
//        toolbar.sizeToFit()
//        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
//      let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
//      toolbar.setItems([spaceButton,doneButton], animated: false)
//    // add toolbar to textField
//        txt_Status.inputAccessoryView = toolbar
//     // add datepicker to textField
//        txt_Status.inputView = expiryDatePicker
        

    }
    @objc func donedatePicker(){
        view.endEditing(true)
       
            
            if txt_Status.text == ""{
                if (txt_Status.inputView as! MonthYearPickerView).years.count > 0{
                    let month = (txt_Status.inputView as! MonthYearPickerView).month
                    let year = (txt_Status.inputView as! MonthYearPickerView).years[0]
                    
                let string = String(format: "%02d/%d", month, year)
                NSLog(string) // should show something like 05/2015
               
                self.txt_Status.text = string
               
                }
            }
      
        
    }
    func showDeleteAlert(deleteIndx: Int){
//        isToDelete = true
//        self.indexToDelete = deleteIndx
        self.selectedInvoiceId = "\(array_Invoices[deleteIndx].id)"
        alertView.delegate = self
        alertView.showInView(self.view_Background, title: "Are you sure you want to\n delete the following\n defect list?", okTitle: "Yes", cancelTitle: "Back")
      
    }
    //MARK: ******  PARSING *********
    func submitInvoicePayment(){
        var total = 0
        for (index, obj) in array_Allocation.enumerated(){
            if obj["\(index)"] != ""{
                total = total + Int( obj["\(index)"] ?? "0")!
            }
        }
        let totalAmountStr = paymentMode == .cheque ? txt_ChequeAmount.text! :
        paymentMode == .cash ? txt_CashAmount.text! :
        paymentMode == .banktransfer ? txt_BankAmount.text! :
        paymentMode == .waiver ? txt_WaiverAmount.text! :
        ""
        let totalAmount = Int(totalAmountStr) ?? 0
        if total == 0{
            self.displayErrorAlert(alertStr: "", title: "Allocation amount should not be empty")
        }
        else if total != totalAmount{
            self.displayErrorAlert(alertStr: "", title: " Amount and allocation amount does not match")
            
        }
        else{
            ActivityIndicatorView.show("Loading")
            let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
            //
            let params = NSMutableDictionary()
            params.setValue("\(userId)", forKey: "login_id")
            params.setValue("\(invoice.invoice_info.id)", forKey: "id")
            if paymentMode != nil{
                let mode = paymentMode == .cheque ? 1 :
                paymentMode == .cash ? 3 :
                paymentMode == .banktransfer ? 2 :
                paymentMode == .waiver ? 6 : 0
                params.setValue("\(mode)", forKey: "payment_option")
                
                if paymentMode == .cheque{
                    params.setValue(txt_ChequeAmount.text!, forKey: "cheque_amount")
                    params.setValue(txt_ChequeNo.text!, forKey: "cheque_no")
                    params.setValue(txt_ChequeDate.text!, forKey: "cheque_received_date")
                    params.setValue(txt_ChequeBank.text!, forKey: "cheque_bank")
                    params.setValue(txt_ChequeReceipt.text!, forKey: "receipt_no")
                }
                else   if paymentMode == .cash{
                    params.setValue(txt_CashAmount.text!, forKey: "cash_amount_received")
                    params.setValue(txt_CashDate.text!, forKey: "cash_received_date")
                    params.setValue(txt_CashReceipt.text!, forKey: "receipt_no")
                    
                }
                else   if paymentMode == .banktransfer{
                    params.setValue(txt_BankAmount.text!, forKey: "bt_amount_received")
                    params.setValue(txt_BankDate.text!, forKey: "bt_received_date")
                    params.setValue(txt_BankReceipt.text!, forKey: "receipt_no")
                    
                }
                else   if paymentMode == .waiver{
                    params.setValue(txt_WaiverAmount.text!, forKey: "credit_amount")
                    params.setValue(txt_WaiverDate.text!, forKey: "credit_date")
                    params.setValue(txt_WaiverNote.text!, forKey: "credit_notes")
                    
                }
                for (index, data) in invoiceData.details.enumerated(){
                    params.setValue(data.id, forKey: "info_detail[\(index)]")
                    params.setValue(data.reference_no, forKey: "reference[\(data.id)]")
                    params.setValue(data.balance, forKey: "bal_amount[\(data.id)]")
                    let obj = array_Allocation[index]
                    if obj["\(index)"] != ""{
                        params.setValue(obj["\(index)"], forKey: "amount[\(data.id)]")
                    }
                    
                    
                }
            }
            
            
            
            
            
            
            
            
            
            
            
            
            ApiService.update_InvoicePayment(parameters: params as! [String : Any], completion: { status, result, error in
                ActivityIndicatorView.hiding()
                if status  && result != nil{
                    if let response = (result as? DeleteUserBase){
                        if response.response == 1{
                            DispatchQueue.main.async {
                                self.alertView_message.delegate = self
                                self.alertView_message.showInView(self.view_Background, title: "Batch Invoice has\n been deleted", okTitle: "Home", cancelTitle: "View announcement")
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
    }
   
    
   
    func getInvoiceDetail(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.get_InvoiceDetail(parameters: ["login_id":userId, "id": invoice.invoice_info.id], completion: { status, result, error in
            array_Allocation.removeAll()
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? InvoiceDataBase){
                     self.invoiceData = response.data
                     
                     for (indx, _) in self.invoiceData.details.enumerated(){
                         array_Allocation.append(["\(indx)":""])
                     }
                     self.dataSource.invoiceData = response.data

                     self.lbl_Unit.text = "#\(self.invoiceData.unit_info)"
                     self.lbl_Building.text = "#\(self.invoiceData.building_info)"
                     self.lbl_InvoiceAmount.text = "$\(self.invoiceData.invoice_info.invoice_amount)"
                     self.lbl_BalanceAmount.text = "$\(self.invoiceData.invoice_info.balance_amount)"
                     let recvdamt =  (Double(self.invoiceData.invoice_info.invoice_amount) ?? 0) - (Double(self.invoiceData.invoice_info.balance_amount) )
                     self.lbl_ReceivedAmount.text = "$\(recvdamt)"
                    self.table_InvoiceList.reloadData()
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
  
    @IBAction func actionSubmit(_ sender: UIButton){
        if self.paymentMode == nil{
            self.displayErrorAlert(alertStr: "", title: "Plese select the payment mode")
        }
        else if paymentMode == .cheque{
            if txt_ChequeNo.text == "" || txt_ChequeBank.text == "" || txt_ChequeDate.text == "" || txt_ChequeReceipt.text == "" || txt_ChequeAmount.text == ""{
                self.displayErrorAlert(alertStr: "", title: "Plese provide the cheque payment information")
            }
            else{
                self.submitInvoicePayment()
            }
        }
        else if paymentMode == .cash{
            if txt_CashDate.text == "" || txt_CashAmount.text == "" || txt_CashReceipt
                .text == "" {
                self.displayErrorAlert(alertStr: "", title: "Please provide the cash payment information")
            }
            else{
                self.submitInvoicePayment()
            }
        }
        else if paymentMode == .banktransfer{
            if txt_BankDate.text == "" || txt_BankAmount.text == "" || txt_BankReceipt.text == "" {
                self.displayErrorAlert(alertStr: "", title: "Please provide the bank transfer payment information")
            }
            else{
                self.submitInvoicePayment()
            }
        }
        else if paymentMode == .waiver{
            if txt_WaiverNote.text == "" || txt_WaiverDate.text == "" || txt_WaiverAmount.text == "" {
                self.displayErrorAlert(alertStr: "", title: "Please provide the waiver payment information")
            }
            else{
                self.submitInvoicePayment()
            }
        }
    }
      
  
    @IBAction func actionPaymentMode(_ sender:UIButton) {
        let arrStatus = [ "Cash", "Cheque", "Bank Tansfer", "Waiver"]
        let dropDown_Status = DropDown()
        dropDown_Status.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Status.dataSource = arrStatus//statusData.map({$0.value})//Array(statusData.values)
        dropDown_Status.show()
        dropDown_Status.selectionAction = { [unowned self] (index: Int, item: String) in
            txt_PaymentOption.text = item
            modeSelected = true
            self.paymentMode = index == 0 ? .cash :
            index == 1 ? .cheque :
            index == 2 ? .banktransfer :
                .waiver
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.table_InvoiceList.reloadData()
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
class DataSource_InvoiceData: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var invoiceData: InvoiceData!
    var unitsData = [Unit]()
    var parentVc: UIViewController!
   
func numberOfSectionsInTableView(tableView: UITableView) -> Int {

    return 1;
}

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return  invoiceData == nil ? 0 : invoiceData.details.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "invoiceDetailCell") as! InvoiceDetailTableViewCell
        let invoice = invoiceData.details[indexPath.row]
        
        cell.lbl_Detail.text = invoice.detail
        cell.lbl_Amount.text = invoice.total_amount
        let paid = (Double(invoice.total_amount) ?? 0) - (Double(invoice.balance) ?? 0)
        cell.lbl_Paid.text = "\(paid)"
        cell.lbl_Balance.text = invoice.balance
       
        cell.selectionStyle = .none
        
        cell.txt_Allocation.layer.cornerRadius = 20.0
        cell.txt_Allocation.layer.masksToBounds = true
        cell.txt_Allocation.tag = indexPath.row
        cell.txt_Allocation.addTarget(self, action: #selector(allocationValueChanged), for: .editingChanged)
           
        cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
       
        cell.view_Outer.tag = indexPath.row
        let bal = Double(invoice.balance) ?? 0
        cell.lbl_Allocation.isHidden =  bal == 0
        cell.txt_Allocation.isHidden =  bal == 0
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
//        cell.view_Outer.addGestureRecognizer(tap)
      
        
        return cell
      
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 225
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
       
       
       
    }
    @objc func allocationValueChanged(_ textField: UITextField){
        array_Allocation[textField.tag] = ["\(textField.tag)":textField.text!]
    }
    @IBAction func actionDelete(_ sender:UIButton){
        (self.parentVc as! ManageBatchInvoiceTableViewController).showDeleteAlert(deleteIndx:sender.tag)
    }
    @IBAction func actionEdit(_ sender:UIButton){
//        let feedback = array_Feedbacks[sender.tag]
//        let feedbackDetailsVC = self.parentVc.storyboard?.instantiateViewController(identifier: "FeedbackDetailsTableViewController") as! FeedbackDetailsTableViewController
//        feedbackDetailsVC.feedback = feedback
//        feedbackDetailsVC.unitsData = unitsData
//        self.parentVc.navigationController?.pushViewController(feedbackDetailsVC, animated: true)
       
    }
}
extension InvoicePaymentTableViewController: MenuViewDelegate{
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

   
   






extension InvoicePaymentTableViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
       
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
       
           
        
    }
   
}
extension InvoicePaymentTableViewController: MessageAlertViewDelegate{
func onHomeClicked() {
    self.navigationController?.popToRootViewController(animated: true)
}

func onListClicked() {
  //  self.getInvoiceSummary()
}


}
extension InvoicePaymentTableViewController: AlertViewDelegate{
    func onBackClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func onCloseClicked() {
        
    }
    
    func onOkClicked() {
       // self.deletInvoice()
    
    }
    
    
}
