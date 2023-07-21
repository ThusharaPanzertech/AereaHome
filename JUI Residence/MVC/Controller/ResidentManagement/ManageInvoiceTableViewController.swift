//
//  ManageInvoiceTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 12/04/23.
//

import UIKit
import DropDown
class ManageInvoiceTableViewController: BaseTableViewController {
    
    //Outlets
    @IBOutlet weak var view_SwitchProperty: UIView!
    @IBOutlet weak var lbl_SwitchProperty: UILabel!
    @IBOutlet weak var txt_InvoiceNo: UITextField!
    @IBOutlet weak var txt_BatchNo: UITextField!
    @IBOutlet weak var txt_Building: UITextField!
    @IBOutlet weak var txt_Unit: UITextField!
    @IBOutlet weak var txt_StartDate: UITextField!
    @IBOutlet weak var txt_EndDate: UITextField!
    @IBOutlet weak var txt_Status: UITextField!

    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var imgView_Profile: UIImageView!
    @IBOutlet var arr_Textfields: [UITextField]!
    @IBOutlet weak var datePicker:  UIDatePicker!
    let menu: MenuView = MenuView.getInstance
    @IBOutlet weak var table_InvoiceList: UITableView!
    var dataSource = DataSource_IndividualInvoiceList()
    var buildings = [String: String]()
    var array_Invoices = [InvoiceReportInfo]()
    var selectedMonth = ""
    var selectedInvoiceId = ""
    var selectedBuildingId = ""
    let alertView_message: MessageAlertView = MessageAlertView.getInstance
    let alertView: AlertView = AlertView.getInstance
    var unitsData = [Unit]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureDatePicker()
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
        self.getInvoiceSummary()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.closeMenu()
    }
  
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        if indexPath.row == 1{
            return CGFloat((300 * array_Invoices.count) + 500)
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
      
    
       
    }
  
    func showDeleteAlert(deleteIndx: Int){
//        isToDelete = true
//        self.indexToDelete = deleteIndx
      //  self.selectedInvoiceId = "\(array_Invoices[deleteIndx].id)"
        alertView.delegate = self
        alertView.showInView(self.view_Background, title: "Are you sure you want to\n delete the following\n defect list?", okTitle: "Yes", cancelTitle: "Back")
      
    }
    //MARK: ******  PARSING *********
    func deletInvoice(){
       
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
     
        let id = selectedInvoiceId
        let param = [
            "login_id" : userId,
            "id" : id,
          
        ] as [String : Any]

        ApiService.delete_BatchInvoice(parameters: param, completion: { status, result, error in
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
    
   
    
   
    func getInvoiceSummary(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.get_InvoiceSummary(parameters: ["login_id":userId], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? InvoiceSummaryBase){
                    self.array_Invoices = response.data
                     self.buildings = response.buildings
                    
                    self.dataSource.array_Invoices = self.array_Invoices
                    if self.array_Invoices.count == 0{

                    }
                    else{
                       // self.view_NoRecords.removeFromSuperview()
                    }
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
    func searchInvoices(){
           
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        var start_dateStr = ""
        var end_dateStr = ""
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd/MM/yy"//"yyyy-MM-dd"
        if txt_StartDate.text!.count > 0{
           let  start_date = formatter.date(from: txt_StartDate.text!)
            formatter.dateFormat = "yyyy-MM-dd"
            if start_date != nil{
                start_dateStr = formatter.string(from: start_date!)
            }
           
        }
        
        if txt_EndDate.text!.count > 0{
           let  end_date = formatter.date(from: txt_EndDate.text!)
            formatter.dateFormat = "yyyy-MM-dd"
            if end_date != nil{
                end_dateStr = formatter.string(from: end_date! )
            }
          
           
        }
       
       
        
        let status = txt_Status.text == "Payment Pending" ? "1" :
        
        txt_Status.text == "Partially Paid" ?  "2" :
        txt_Status.text == "Paid" ?  "3" :
        ""
        
        ApiService.search_InvoiceSummary(parameters: ["login_id":userId, "batch_file_no": txt_BatchNo.text!, "invoice_no" : txt_InvoiceNo.text!, "unit": txt_Unit.text!,"fromdate" : start_dateStr, "todate": end_dateStr, "building": self.selectedBuildingId,"status": status], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? InvoiceSummaryBase){
                    self.array_Invoices = response.data
                     self.buildings = response.buildings
                    
                    self.dataSource.array_Invoices = self.array_Invoices
                    if self.array_Invoices.count == 0{

                    }
                    else{
                       // self.view_NoRecords.removeFromSuperview()
                    }
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
    func configureDatePicker(){
      //Formate Date
       datePicker.datePickerMode = .date
        
        // Get right now as it's `DateComponents`.
        let now = Calendar.current.dateComponents(in: .current, from: Date())

        // Create the start of the day in `DateComponents` by leaving off the time.
        let today = DateComponents(year: now.year, month: now.month, day: now.day)
        let dateToday = Calendar.current.date(from: today)!

       
        
        
        datePicker.minimumDate = Date()
      
        //ToolBar
          let toolbar = UIToolbar();
          toolbar.sizeToFit()
          let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
         let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)

   // add toolbar to textField
        txt_StartDate.inputAccessoryView = toolbar
        txt_EndDate.inputAccessoryView = toolbar
    // add datepicker to textField
        txt_StartDate.inputView = datePicker
        txt_EndDate.inputView = datePicker

      }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "dd/MM/yy"
        if txt_StartDate.isFirstResponder{
            txt_StartDate.text = formatter.string(from: datePicker.date)
        }
        else{
            txt_EndDate.text = formatter.string(from: datePicker.date)
        }
            self.view.endEditing(true)
        
      
        
    }

    @objc func cancelDatePicker(){
       self.view.endEditing(true)
     }
    
    //MARK: UIBUTTON ACTION
    @IBAction func actionSearch(_ sender:UIButton) {
        self.searchInvoices()
    }
    @IBAction func actionClear(_ sender:UIButton) {
        self.txt_Status.text = ""
        txt_BatchNo.text = ""
       txt_Unit.text = ""
        txt_EndDate.text = ""
        txt_StartDate.text = ""
        txt_InvoiceNo.text = ""
        txt_Building.text = ""
        selectedBuildingId = ""
        self.getInvoiceSummary()
        
        
    }
    
    @IBAction func actionBuilding(_ sender: UIButton){
        
        let arrUnit = buildings.sorted { $0.key < $1.key }
        let sortedArray = arrUnit.map { $0.value }
      let dropDown_arrOptions = DropDown()
        dropDown_arrOptions.anchorView = sender // UIView or UIBarButtonItem
        dropDown_arrOptions.dataSource = sortedArray
        dropDown_arrOptions.show()
        dropDown_arrOptions.selectionAction = { [unowned self] (index: Int, item: String) in

            
            txt_Building.text = item
            self.selectedBuildingId   = arrUnit[index].key
            
      }
        
        
       
    }
    @IBAction func actionStatus(_ sender:UIButton) {
        let arrStatus = [ "Payment Pending", "Partially Paid", "Paid"]
        let dropDown_Status = DropDown()
        dropDown_Status.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Status.dataSource = arrStatus//statusData.map({$0.value})//Array(statusData.values)
        dropDown_Status.show()
        dropDown_Status.selectionAction = { [unowned self] (index: Int, item: String) in
            txt_Status.text = item
           
            
        }
    }
    @IBAction func actionUnit(_ sender:UIButton) {
        //  let sortedArray = unitsData.sorted(by:  { $0.1 < $1.1 })
        let arrUnit = unitsData.map { $0.unit }
        let dropDown_Unit = DropDown()
        dropDown_Unit.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Unit.dataSource = arrUnit// Array(unitsData.values)
        dropDown_Unit.show()
        dropDown_Unit.selectionAction = { [unowned self] (index: Int, item: String) in
            
            txt_Unit.text = item
           
            
        }
    }
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
  
    @IBAction func actionDelete(_ sender: UIButton){
        alertView.delegate = self
        alertView.showInView(self.view_Background, title: "Are you sure you want to\n delete the invoice?", okTitle: "Yes", cancelTitle: "Back")
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
class DataSource_IndividualInvoiceList: NSObject, UITableViewDataSource, UITableViewDelegate {
    var buildings = [String: String]()
    var unitsData = [Unit]()
    var parentVc: UIViewController!
    var array_Invoices = [InvoiceReportInfo]()
func numberOfSectionsInTableView(tableView: UITableView) -> Int {

    return 1;
}

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  array_Invoices.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "batchListCell") as! IndividualInvoiceTableViewCell
        let invoice = array_Invoices[indexPath.row]
        
        cell.lbl_BatchNo.text = invoice.invoice_info.batch_file_no
        cell.lbl_InvoiceNo.text = invoice.invoice_info.invoice_no
        cell.lbl_Building.text = "\(invoice.building.building)"
        cell.lbl_UnitNo.text = invoice.unit == nil ? ""  : "#\(invoice.unit.unit)"
        cell.selectionStyle = .none
        
        
        cell.btn_View.tag = indexPath.row
        cell.btn_Print.tag = indexPath.row
        cell.btn_Delete.tag = indexPath.row
        cell.btn_Payment.tag = indexPath.row
        
        cell.lbl_TotalAmount.text = "\(invoice.invoice_amount)"
        cell.lbl_PaymentStatus.text = invoice.status_lable
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        let invoice_date = formatter.date(from: invoice.invoice_info.invoice_date)
        let due_date = formatter.date(from: invoice.invoice_info.due_date)
        formatter.dateFormat = "dd/MM/yy"
        let invoice_dateStr = formatter.string(from: invoice_date ?? Date())
            let due_dateStr = formatter.string(from: due_date ?? Date())
        
        cell.lbl_InvoiceDate.text = invoice_dateStr
        cell.lbl_DueDate.text = due_dateStr
        
    
      //  cell.btn_Edit.tag = indexPath.row
           
        cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
        cell.btn_Delete.addTarget(self, action: #selector(self.actionDelete(_:)), for: .touchUpInside)
        cell.btn_Payment.addTarget(self, action: #selector(self.actionPayment(_:)), for: .touchUpInside)
        cell.view_Outer.tag = indexPath.row
       
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        cell.view_Outer.addGestureRecognizer(tap)
      
        
        return cell
      
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
       
       
       
    }
    @IBAction func actionDelete(_ sender:UIButton){
        (self.parentVc as! ManageBatchInvoiceTableViewController).showDeleteAlert(deleteIndx:sender.tag)
    }
    @IBAction func actionPayment(_ sender:UIButton){
        let invoice = array_Invoices[sender.tag]
               let paymentVC = self.parentVc.storyboard?.instantiateViewController(identifier: "InvoicePaymentTableViewController") as! InvoicePaymentTableViewController
               paymentVC.invoice = invoice
       //        feedbackDetailsVC.unitsData = unitsData
        (self.parentVc as! ManageInvoiceTableViewController).navigationController?.pushViewController(paymentVC, animated: true)
              
    }
    
    @IBAction func actionEdit(_ sender:UIButton){
//        let feedback = array_Feedbacks[sender.tag]
//        let feedbackDetailsVC = self.parentVc.storyboard?.instantiateViewController(identifier: "FeedbackDetailsTableViewController") as! FeedbackDetailsTableViewController
//        feedbackDetailsVC.feedback = feedback
//        feedbackDetailsVC.unitsData = unitsData
//        self.parentVc.navigationController?.pushViewController(feedbackDetailsVC, animated: true)
       
    }
}
extension ManageInvoiceTableViewController: MenuViewDelegate{
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

   
   






extension ManageInvoiceTableViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
       
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
       
           
        
    }
   
}
extension ManageInvoiceTableViewController: MessageAlertViewDelegate{
func onHomeClicked() {
    self.navigationController?.popToRootViewController(animated: true)
}

func onListClicked() {
    self.getInvoiceSummary()
}


}
extension ManageInvoiceTableViewController: AlertViewDelegate{
    func onBackClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func onCloseClicked() {
        
    }
    
    func onOkClicked() {
        self.deletInvoice()
    
    }
    
    
}
