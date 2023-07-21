//
//  ManageBatchInvoiceTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 11/04/23.
//

import UIKit
import DropDown

class ManageBatchInvoiceTableViewController: BaseTableViewController {
    
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

    let menu: MenuView = MenuView.getInstance
    @IBOutlet weak var table_InvoiceList: UITableView!
    var dataSource = DataSource_InvoiceList()
    var buildings = [String: String]()
    var array_Invoices = [BatchInfo]()
    var selectedMonth = ""
    var selectedInvoiceId = ""
    
    let alertView_message: MessageAlertView = MessageAlertView.getInstance
    let alertView: AlertView = AlertView.getInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            return CGFloat((192 * array_Invoices.count) + 400)
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
      
    
        let expiryDatePicker = MonthYearPickerView()
        expiryDatePicker.onDateSelected = { (month: Int, year: Int) in
            let string = String(format: "%02d/%d", month, year)
            NSLog(string) // should show something like 05/2015
           
            self.txt_Status.text = string
           
            
            self.selectedMonth = String(format: "%d-%02d",  year, month)
           
        }
         
      
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
      let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
      toolbar.setItems([spaceButton,doneButton], animated: false)
    // add toolbar to textField
        txt_Status.inputAccessoryView = toolbar
     // add datepicker to textField
        txt_Status.inputView = expiryDatePicker
        

    }
    @objc func donedatePicker(){
        view.endEditing(true)
       
            
          //  if txt_Status.text == ""{
                if (txt_Status.inputView as! MonthYearPickerView).years.count > 0{
                    let month = (txt_Status.inputView as! MonthYearPickerView).month
                    let year = (txt_Status.inputView as! MonthYearPickerView).years[0]
                    
                let string = String(format: "%02d/%d", month, year)
                NSLog(string) // should show something like 05/2015
               
                self.txt_Status.text = string
                    self.selectedMonth = String(format: "%d-%02d",  year, month)
                }
         //   }
      
        
    }
    func showDeleteAlert(deleteIndx: Int){
//        isToDelete = true
//        self.indexToDelete = deleteIndx
        self.selectedInvoiceId = "\(array_Invoices[deleteIndx].id)"
        alertView.delegate = self
        alertView.showInView(self.view_Background, title: "Are you sure you want to\n delete the batch?", okTitle: "Yes", cancelTitle: "Back")
      
    }
    //MARK: ******  PARSING *********
    func deletInvoice(){
       
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
     
        let id = selectedInvoiceId
        let param = [
            "login_id" : userId,
            "batch_id" : id,
          
        ] as [String : Any]

        ApiService.delete_BatchInvoice(parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? DeleteUserBase){
                    if response.response == 1{
                        DispatchQueue.main.async {
                            self.alertView_message.delegate = self
                            self.alertView_message.showInView(self.view_Background, title: "Batch Invoice has\n been deleted", okTitle: "Home", cancelTitle: "Manage Batch Invoice")
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
        ApiService.get_BatchInvoiceSummary(parameters: ["login_id":userId], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? BatchSummaryBase){
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
        if txt_BatchNo.text == "" && txt_Status.text == ""{
            self.getInvoiceSummary()
        }
        else{
            ActivityIndicatorView.show("Loading")
            let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
            //
            ApiService.search_BatchInvoiceSummary(parameters: ["login_id":userId, "month": self.selectedMonth, "batch_file_no": txt_BatchNo.text!], completion: { status, result, error in
                
                ActivityIndicatorView.hiding()
                if status  && result != nil{
                    if let response = (result as? BatchSummaryBase){
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
        }}
    
    //MARK: UIBUTTON ACTION
    @IBAction func actionSearch(_ sender:UIButton) {
        self.searchInvoices()
    }
    @IBAction func actionClear(_ sender:UIButton) {
        self.txt_Status.text = ""
        txt_BatchNo.text = ""
        self.selectedMonth = ""
        self.getInvoiceSummary()
        
        
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
        alertView.showInView(self.view_Background, title: "Are you sure you want to\n delete the batch?", okTitle: "Yes", cancelTitle: "Back")
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
class DataSource_InvoiceList: NSObject, UITableViewDataSource, UITableViewDelegate {
    var buildings = [String: String]()
    var unitsData = [Unit]()
    var parentVc: UIViewController!
    var array_Invoices = [BatchInfo]()
func numberOfSectionsInTableView(tableView: UITableView) -> Int {

    return 1;
}

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  array_Invoices.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "batchListCell") as! BatchInvoiceTableViewCell
        let invoice = array_Invoices[indexPath.row]
        
        cell.lbl_BatchNo.text = invoice.batch_no
        cell.lbl_CreatedBy.text = invoice.created_by
        cell.lbl_NoofInvoice.text = "\(invoice.count)"
       
        cell.selectionStyle = .none
        
        
        cell.btn_View.tag = indexPath.row
        cell.btn_Print.tag = indexPath.row
        cell.btn_Delete.tag = indexPath.row
        
        cell.lbl_CreatedDate.text = invoice.created_date
        
      
      //  cell.btn_Edit.tag = indexPath.row
           
        cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
        cell.btn_Delete.addTarget(self, action: #selector(self.actionDelete(_:)), for: .touchUpInside)
        cell.view_Outer.tag = indexPath.row
       
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        cell.view_Outer.addGestureRecognizer(tap)
      
        
        return cell
      
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 192
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
       
       
       
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
extension ManageBatchInvoiceTableViewController: MenuViewDelegate{
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

   
   






extension ManageBatchInvoiceTableViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
       
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
       
           
        
    }
   
}
extension ManageBatchInvoiceTableViewController: MessageAlertViewDelegate{
func onHomeClicked() {
    self.navigationController?.popToRootViewController(animated: true)
}

func onListClicked() {
    self.getInvoiceSummary()
}


}
extension ManageBatchInvoiceTableViewController: AlertViewDelegate{
    func onBackClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func onCloseClicked() {
        
    }
    
    func onOkClicked() {
        self.deletInvoice()
    
    }
    
    
}
