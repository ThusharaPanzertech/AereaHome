//
//  EFormPaymentTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 14/02/22.
//

import UIKit
import DropDown
class EFormPaymentTableViewController: BaseTableViewController {
    var settingsInfo: eFormSettingsInfo!
    var eForm : String!

    let menu: MenuView = MenuView.getInstance
    var isToShowSucces = false
     //Outlets
    @IBOutlet weak var datePicker:  UIDatePicker!
     @IBOutlet weak var lbl_UserName: UILabel!
     @IBOutlet weak var lbl_UserRole: UILabel!
     @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_PayableTo: UILabel!
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
    
    @IBOutlet weak var txt_PaymentMode: UITextField!
    
    @IBOutlet weak var txt_ChequeAmt: UITextField!
    @IBOutlet weak var txt_ChequeBank: UITextField!
    @IBOutlet weak var txt_ChequeNo: UITextField!
    @IBOutlet weak var txt_ChequeReceiptNo: UITextField!
    
    @IBOutlet weak var txt_BankTransferDate: UITextField!
    @IBOutlet weak var txt_BankTransferAmt: UITextField!
    @IBOutlet weak var txt_BankTransferReceiptNo: UITextField!

    @IBOutlet weak var txt_CashDate: UITextField!
    @IBOutlet weak var txt_CashAmt: UITextField!
    @IBOutlet weak var txt_CashReceiptNo: UITextField!
    
    
 //   @IBOutlet weak var txt_Acknowledge: UITextField!
    @IBOutlet weak var txt_Manager: UITextField!
   
    //@IBOutlet weak var txt_SignDate: UITextField!
    @IBOutlet weak var imgView_signature1 : UIImageView!
  
    let view_Signature: SignatureView = SignatureView.getInstance
    var signature1 : UIImage!
    var moveInOutData: MoveInOut!
    var renovationData: Renovation!
    var doorAceessData: DoorAccess!
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
        self.configureDatePicker()
       
        self.lbl_Title.text = formType == .moveInOut ? "Moving In & Out Application" :
            formType == .renovation ? "Renovation Work Application" :
            "Resident Access Card & Main Door Access"
        self.lbl_SubTitle.text = "(For official use only)"
        
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
            if self.isToShowSucces == false {
                return doorAceessData != nil ? 260 : 260
                // super.tableView(tableView, heightForRowAt: indexPath)
            }
            return 0
        }
        if indexPath.row == 2{
            if self.isToShowSucces == false {
            return txt_PaymentMode.text == "Cheque" ?   super.tableView(tableView, heightForRowAt: indexPath) : 0
            }
            return 0
        }
        else  if indexPath.row == 3
        {
            if self.isToShowSucces == false {
            return txt_PaymentMode.text == "Bank Transfer" ?   super.tableView(tableView, heightForRowAt: indexPath) : 0 }
            return 0
        }
        else if indexPath.row == 4{
            if self.isToShowSucces == false {
            return txt_PaymentMode.text == "Cash" ?   super.tableView(tableView, heightForRowAt: indexPath) : 0
            }
            return 0
            }
        else if indexPath.row == 5{
            if self.isToShowSucces == false {
            return    super.tableView(tableView, heightForRowAt: indexPath)
            }
            return 0
            }
        else  if indexPath.row == 6{
            return self.isToShowSucces == false ? 0 : super.tableView(tableView, heightForRowAt: indexPath)
        }
     
       return super.tableView(tableView, heightForRowAt: indexPath)
    }
     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         self.showBottomMenu()
        getEFormSettinfsInfo()
        if formType == .moveInOut{
        if self.moveInOutData.payment != nil{
            self.txt_Manager.text = self.moveInOutData.payment.manager_received
            if self.moveInOutData.payment.payment_option == 1{
                txt_PaymentMode.text = "Cheque"
                txt_ChequeNo.text = self.moveInOutData.payment.cheque_no
                txt_ChequeBank.text = self.moveInOutData.payment.cheque_bank
                txt_ChequeAmt.text = self.moveInOutData.payment.cheque_amount
                txt_ChequeReceiptNo.text = self.moveInOutData.payment.receipt_no
            }
           else  if self.moveInOutData.payment.payment_option == 2{
                txt_PaymentMode.text = "Bank Transfer"
                txt_BankTransferDate.text = self.moveInOutData.payment.bt_amount_received
                txt_BankTransferAmt.text = self.moveInOutData.payment.bt_received_date
                txt_BankTransferReceiptNo.text = self.moveInOutData.payment.receipt_no
            }
           else  if self.moveInOutData.payment.payment_option == 3{
                txt_PaymentMode.text = "Cash"
                txt_CashDate.text = self.moveInOutData.payment.cash_received_date
                txt_CashAmt.text = self.moveInOutData.payment.cash_amount_received
                txt_CashReceiptNo.text = self.moveInOutData.payment.receipt_no
            }
        let sign1 = self.moveInOutData.payment.signature
        let image = self.convertBase64StringToImage(imageBase64String: sign1)
        if image != nil{
         self.imgView_signature1.image = image
            self.signature1 = image
         }
            self.tableView.reloadData()
        }
        }
        else if formType == .renovation{
            if self.renovationData.payment != nil{
                self.txt_Manager.text = self.renovationData.payment.manager_received
                if self.renovationData.payment.payment_option == 1{
                    txt_PaymentMode.text = "Cheque"
                    txt_ChequeNo.text = self.renovationData.payment.cheque_no
                    txt_ChequeBank.text = self.renovationData.payment.cheque_bank
                    txt_ChequeAmt.text = self.renovationData.payment.cheque_amount
                    txt_ChequeReceiptNo.text = self.renovationData.payment.receipt_no
                }
               else  if self.renovationData.payment.payment_option == 2{
                    txt_PaymentMode.text = "Bank Transfer"
                    txt_BankTransferDate.text = self.renovationData.payment.bt_amount_received
                    txt_BankTransferAmt.text = self.renovationData.payment.bt_received_date
                    txt_BankTransferReceiptNo.text = self.renovationData.payment.receipt_no
                }
               else  if self.renovationData.payment.payment_option == 3{
                    txt_PaymentMode.text = "Cash"
                    txt_CashDate.text = self.renovationData.payment.cash_received_date
                    txt_CashAmt.text = self.renovationData.payment.cash_amount_received
                    txt_CashReceiptNo.text = self.renovationData.payment.receipt_no
                }
            let sign1 = self.renovationData.payment.signature
            let image = self.convertBase64StringToImage(imageBase64String: sign1)
            if image != nil{
             self.imgView_signature1.image = image
                self.signature1 = image
             }
                self.tableView.reloadData()
        }
        }
       else if formType == .doorAccess{
        if self.doorAceessData.payment != nil{
            self.txt_Manager.text = self.doorAceessData.payment.manager_received
            if self.doorAceessData.payment.payment_option == 1{
                txt_PaymentMode.text = "Cheque"
                txt_ChequeNo.text = self.doorAceessData.payment.cheque_no
                txt_ChequeBank.text = self.doorAceessData.payment.cheque_bank
                txt_ChequeAmt.text = self.doorAceessData.payment.cheque_amount
                txt_ChequeReceiptNo.text = self.doorAceessData.payment.receipt_no
            }
           else  if self.doorAceessData.payment.payment_option == 2{
                txt_PaymentMode.text = "Bank Transfer"
                txt_BankTransferDate.text = self.doorAceessData.payment.bt_amount_received
                txt_BankTransferAmt.text = self.doorAceessData.payment.bt_received_date
                txt_BankTransferReceiptNo.text = self.doorAceessData.payment.receipt_no
            }
           else  if self.doorAceessData.payment.payment_option == 3{
                txt_PaymentMode.text = "Cash"
                txt_CashDate.text = self.doorAceessData.payment.cash_received_date
                txt_CashAmt.text = self.doorAceessData.payment.cash_amount_received
                txt_CashReceiptNo.text = self.doorAceessData.payment.receipt_no
            }
        let sign1 = self.doorAceessData.payment.signature
        let image = self.convertBase64StringToImage(imageBase64String: sign1)
        if image != nil{
         self.imgView_signature1.image = image
            self.signature1 = image
         }
            self.tableView.reloadData()
        }
        }
     }
    func configureDatePicker(){
      //Formate Date
       datePicker.datePickerMode = .date
        
//        // Get right now as it's `DateComponents`.
//        let now = Calendar.current.dateComponents(in: .current, from: Date())
//
//        // Create the start of the day in `DateComponents` by leaving off the time.
//        let today = DateComponents(year: now.year, month: now.month, day: now.day)
//        let dateToday = Calendar.current.date(from: today)!
//
//
//
//
//        datePicker.minimumDate = Date()
      
        //ToolBar
          let toolbar = UIToolbar();
          toolbar.sizeToFit()
          let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
         let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)

   // add toolbar to textField
        txt_BankTransferDate.inputAccessoryView = toolbar
    // add datepicker to textField
        txt_BankTransferDate.inputView = datePicker
        
        txt_CashDate.inputAccessoryView = toolbar
    // add datepicker to textField
        txt_CashDate.inputView = datePicker
        

      }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "dd/MM/yy"
        
        if txt_PaymentMode.text == "Cash"{
            txt_CashDate.text = formatter.string(from: datePicker.date)
        }
        else{
            txt_BankTransferDate.text = formatter.string(from: datePicker.date)
        }
            self.view.endEditing(true)
        
      
        
    }

    @objc func cancelDatePicker(){
       self.view.endEditing(true)
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
    func getEFormSettinfsInfo(){
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        let id  = self.formType == .moveInOut ? moveInOutData.submission.form_type :
            self.formType == .renovation ? renovationData.submission.form_type :
            self.formType == .doorAccess ? doorAceessData.submission.form_type :
            0
            
        ApiService.get_eformDetail(parameters: ["login_id":userId, "id": id], completion: { [self] status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                if let response = (result as? eFormSettingsInfoBase){
                    self.settingsInfo = response.details
                    let text = NSMutableAttributedString(string: "payable to ")
                    text.addAttribute(NSAttributedString.Key.font,
                                      value: UIFont(name: "Helvetica", size: 16)!,
                                      range: NSRange(location: 0, length: text.length))
                   

                    
                    let payableTo = settingsInfo.payable_to == "" ? "Tiara Land Pte Ltd - Jui Residences MF Account" : settingsInfo.payable_to
                    let text1 = NSMutableAttributedString(string: "\"\(payableTo)\"")
                    text1.addAttribute(NSAttributedString.Key.font,
                                                  value: UIFont(name: "Helvetica-Bold", size: 16)!,
                                                  range: NSRange(location: 0, length: text1.length))
                     text.append(text1)
                    
                    
                    text.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: NSRange(location: 0, length: text.length))
                    
                    
                    
                    
                    self.lbl_PayableTo.attributedText = text
                 //   self.dataSource.settingsInfo = response.details
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
    func submitAppication(){
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
     let dateStr_today = formatter.string(from:  Date())
        
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
       
        let params = NSMutableDictionary()
        params.setValue("\(userId)", forKey: "login_id")
        if formType == .moveInOut{
        params.setValue("\(moveInOutData.submission.id)", forKey: "id")
        if moveInOutData.payment != nil{
            params.setValue("\(moveInOutData.payment.id)", forKey: "payment_id")
        }
            
        }
        else if formType == .renovation{
            params.setValue("\(renovationData.submission.id)", forKey: "id")
            if renovationData.payment != nil{
                params.setValue("\(renovationData.payment.id)", forKey: "payment_id")
            }
        }
        else if formType == .doorAccess{
            params.setValue("\(doorAceessData.submission.id)", forKey: "id")
            if doorAceessData.payment != nil{
                params.setValue("\(doorAceessData.payment.id)", forKey: "payment_id")
            }
        }
        let paymentMode = txt_PaymentMode.text == "Cheque" ? 1 :
        txt_PaymentMode.text == "Bank Transfer" ? 2 :
        txt_PaymentMode.text == "Cash" ? 3 : 0
        params.setValue("\(paymentMode)", forKey: "payment_option")
        params.setValue(paymentMode == 1 ? txt_ChequeAmt.text! : "", forKey: "cheque_amount")
        params.setValue(paymentMode == 1 ? txt_ChequeNo.text! : "", forKey: "cheque_no")
        params.setValue(paymentMode == 1 ? txt_ChequeBank.text! : "", forKey: "cheque_bank")
       
       
        formatter.dateFormat = "dd/MM/yy"
        let date_bank = formatter.date(from: txt_BankTransferDate.text! )
        formatter.dateFormat = "yyyy-MM-dd"
     let dateStr_bank = formatter.string(from: date_bank ??  Date())
        
        params.setValue(paymentMode == 2 ? dateStr_bank : "", forKey: "bt_received_date")
        params.setValue(paymentMode == 2 ? txt_BankTransferAmt.text! : "", forKey: "bt_amount_received")
        
        formatter.dateFormat = "dd/MM/yy"
        let date_cash = formatter.date(from: txt_CashDate.text! )
        formatter.dateFormat = "yyyy-MM-dd"
     let dateStr_cash = formatter.string(from: date_cash ??  Date())
        
        
        params.setValue(paymentMode == 3 ? txt_CashAmt.text! : "", forKey: "cash_amount_received")
        params.setValue(paymentMode == 3 ? dateStr_cash : "", forKey: "cash_received_date")
        params.setValue("", forKey: "acknowledged_by")
        
        params.setValue(paymentMode == 1 ? txt_ChequeAmt.text! : "", forKey: "cheque_amount")
        params.setValue(paymentMode == 1 ? txt_ChequeAmt.text! : "", forKey: "cheque_amount")
        
        let receipt = paymentMode == 1 ? txt_ChequeReceiptNo.text! :
            paymentMode == 2 ? txt_BankTransferReceiptNo.text! :
            txt_CashReceiptNo.text!
        params.setValue("\(receipt)", forKey: "receipt_no")
        
        
        params.setValue(txt_Manager.text!, forKey: "manager_received")
        params.setValue(dateStr_today, forKey: "date_of_signature")
//
       
        var data : Data!
     if signature1 != nil{
        data = signature1.jpegData(compressionQuality: 0.5)! as NSData as Data
     }
    
        if formType == .moveInOut{
        ApiService.submit_MoveIOPayment(signature: data, parameters: params as! [String : Any]) { status, result, error in
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
        else if formType == .renovation{
          //
            ApiService.submit_RenovationPayment(signature: data, parameters: params as! [String : Any]) { status, result, error in
                ActivityIndicatorView.hiding()
                if status  && result != nil{
                    if let response = (result as? RenovationInspectionBase){
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
        else if formType == .doorAccess{
          //
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
     
            }
        
        
    
    
     //MARK: UIBUTTON ACTIONS
    @IBAction func actionHome(_ sender: UIButton){
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func actionSubmittedForms(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionPaymentMode(_ sender:UIButton) {
        
        let arrPayment = [ "Cheque", "Bank Transfer", "Cash"]
        let dropDown_Payment = DropDown()
        dropDown_Payment.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Payment.dataSource = arrPayment//statusData.map({$0.value})//Array(statusData.values)
        dropDown_Payment.show()
        dropDown_Payment.selectionAction = { [unowned self] (index: Int, item: String) in
            txt_PaymentMode.text = item
           
            self.tableView.reloadData()
            
        }
    }
    @IBAction func actionSign1(_ sender: UIButton){
        self.view_Signature.delegate = self
        self.view_Signature.showInView(self.view, parent:self, tag: 1, name: txt_Manager.text!)
       
        
    }
    @IBAction func actionSign2(_ sender: UIButton){
        self.view_Signature.delegate = self
        self.view_Signature.showInView(self.view, parent:self, tag: 2, name: "")
       
        
    }
    @IBAction func actionSubmit(_sender: UIButton){
       
        guard txt_PaymentMode.text!.count  > 0 else {
            displayErrorAlert(alertStr: "Please select the payment mode", title: "")
            return
        }
        if txt_PaymentMode.text == "Cheque"{
           
            
            guard txt_ChequeAmt.text!.count  > 0 else {
                displayErrorAlert(alertStr: "Please enter cheque amount", title: "")
                return
            }
            guard txt_ChequeBank.text!.count  > 0 else {
                displayErrorAlert(alertStr: "Please enter bank name", title: "")
                return
            }
            guard txt_ChequeNo.text!.count  > 0 else {
                displayErrorAlert(alertStr: "Please enter cheque number", title: "")
                return
            }
            guard txt_ChequeReceiptNo.text!.count  > 0 else {
                displayErrorAlert(alertStr: "Please enter cheque receipt number", title: "")
                return
            }
        }
        else if txt_PaymentMode.text == "Bank Transfer"{
          
            guard txt_BankTransferDate.text!.count  > 0 else {
                displayErrorAlert(alertStr: "Please enter bank transfer date", title: "")
                return
            }
            guard txt_BankTransferAmt.text!.count  > 0 else {
                displayErrorAlert(alertStr: "Please enter bank transfer amount", title: "")
                return
            }
            guard txt_BankTransferReceiptNo.text!.count  > 0 else {
                displayErrorAlert(alertStr: "Please enter bank transfer receipt number", title: "")
                return
            }
            
        }
        else if txt_PaymentMode.text == "Cash"{
          
            guard txt_CashAmt.text!.count  > 0 else {
                displayErrorAlert(alertStr: "Please enter amount", title: "")
                return
            }
           
            guard txt_CashReceiptNo.text!.count  > 0 else {
                displayErrorAlert(alertStr: "Please enter the receipt number", title: "")
                return
            }
            guard txt_CashDate.text!.count  > 0 else {
                displayErrorAlert(alertStr: "Please enter cash transfer date", title: "")
                return
            }
        }
     
    guard txt_Manager.text!.count  > 0 else {
        displayErrorAlert(alertStr: "Please enter name of manager received", title: "")
        return
    }
    
      
       
      
      
        if signature1 == nil{
            displayErrorAlert(alertStr: "Please enter the name and signature of the owner", title: "")
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




extension EFormPaymentTableViewController:SignatureViewDelegate{
    func onDoneClicked(image: UIImage, name: String, signView: SignatureView) {
        if signView.tag == 1{
            self.signature1 = image
            self.imgView_signature1.image = image
        }
       
    }
    
    
}
extension EFormPaymentTableViewController: AlertViewDelegate{
    func onBackClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func onCloseClicked() {
        
    }
    
    func onOkClicked() {
       
    }
    
    
}

extension EFormPaymentTableViewController: MessageAlertViewDelegate{
    func onHomeClicked() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func onListClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
extension EFormPaymentTableViewController: MenuViewDelegate{
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
extension EFormPaymentTableViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
       
            
        
    }
}
