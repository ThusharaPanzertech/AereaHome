//
//  AppointmentUnitTakeOverTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 26/07/21.
//

import UIKit
import DropDown

var selectedRowIndex_Appointment = -1
class AppointmentUnitTakeOverTableViewController: BaseTableViewController {
    //Outlets
    var selectedMonth = ""
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var txt_Status: UITextField!
    @IBOutlet weak var txt_UnitNo: UITextField!
    @IBOutlet weak var txt_Month: UITextField!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var imgView_Profile: UIImageView!
    @IBOutlet weak var btn_NewAppointment: UIButton!
    @IBOutlet weak var view_Footer: UIView!
    @IBOutlet weak var table_AppointmentUnitTakeOver: UITableView!
    @IBOutlet var arrTextFields: [UITextField]!
    var array_KeyCollection = [KeyCollectionModal]()
    var unitsData = [String: String]()
    var dataSource = DataSource_AppointmentUnitTakeOver()
    let menu: MenuView = MenuView.getInstance
    var appointment: Appointment!
    var statusData = ["1":"Cancelled","2":"On Schedule","3" :"Done"]
        //["1":"Active","2":"Inactive", "3":"Faulty","4":"Loss","5":"Stolen"]
    //["1":"Cancelled","2":"On Schedule","3" :"Done"]
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
        let fname = Users.currentUser?.user?.name ?? ""
        let lname = Users.currentUser?.moreInfo?.last_name ?? ""
        self.lbl_UserName.text = "\(fname) \(lname)"
        let role = Users.currentUser?.role?.name ?? ""
        self.lbl_UserRole.text = role
        selectedRowIndex_Appointment = -1
        lbl_title.text = appointment == .keyCollection ? "Key Collection" : "Defect Inspection"
        table_AppointmentUnitTakeOver.dataSource = dataSource
        table_AppointmentUnitTakeOver.delegate = dataSource
        dataSource.appointment = self.appointment
        dataSource.parentVc = self
        setUpUI()
        getUnitList()
    }
    func setUpUI(){
        for field in arrTextFields{
            field.layer.cornerRadius = 20.0
            field.layer.masksToBounds = true
            field.textColor = textColor
            field.attributedPlaceholder = NSAttributedString(string: field.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
           
        }
        view_Background.layer.cornerRadius = 25.0
        view_Background.layer.masksToBounds = true
      
        imgView_Profile.addborder()
        btn_NewAppointment.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
      
        btn_NewAppointment.layer.cornerRadius = 10.0

        let expiryDatePicker = MonthYearPickerView()
        expiryDatePicker.onDateSelected = { (month: Int, year: Int) in
            let string = String(format: "%02d/%d", month, year)
            NSLog(string) // should show something like 05/2015
            self.txt_Status.text = ""
            self.txt_Month.text = string
            self.txt_UnitNo.text = ""
            
            self.selectedMonth = String(format: "%d-%02d",  year, month)
           
        }
         
      
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
      let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
      toolbar.setItems([spaceButton,doneButton], animated: false)
    // add toolbar to textField
        txt_Month.inputAccessoryView = toolbar
     // add datepicker to textField
        txt_Month.inputView = expiryDatePicker

    }
    @objc func donedatePicker(){
        view.endEditing(true)
        if appointment == .keyCollection{
        self.searchKeyCollectionSummary()
        }
    }
    //MARK: ******  PARSING *********
    func getKeyCollectionSummary(){
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.get_KeyCollectionSummary(parameters: ["login_id":userId], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? KeyCollectionSummaryBase){
                    self.array_KeyCollection = response.data
                    
                    self.dataSource.array_KeyCollection = self.array_KeyCollection
                    if self.array_KeyCollection.count == 0{

                    }
                    else{
                       // self.view_NoRecords.removeFromSuperview()
                    }
                    DispatchQueue.main.async {
                        self.table_AppointmentUnitTakeOver.reloadData()
                        self.tableView.reloadData()
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
    func searchKeyCollectionSummary(){
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        var statusId = ""
        if let status = statusData.first(where: { $0.value == txt_Status.text })?.key {
            statusId = status
        }
        if txt_Status.text == "" && txt_UnitNo.text == "" && txt_Month.text == "" {
            self.getKeyCollectionSummary()
        }
        else{
        
            var param = [String : Any]()
            if txt_Status.text != ""{
                param = [
                    "login_id" : userId,
                    "option": "status",
                    "status" : statusId
                    
                ] as [String : Any]
            }
            else if txt_Month.text != ""{
                param = [
                    "login_id" : userId,
                    "option": "month",
                    "month" : selectedMonth
                    
                ] as [String : Any]
            }
            else if txt_UnitNo.text != ""{
                param = [
                    "login_id" : userId,
                    "option": "unit",
                    "unit" : txt_UnitNo.text!
                    
                ] as [String : Any]
            }
        
        ActivityIndicatorView.show("Loading")
      //  let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.search_KeyCollection(parameters:param, completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? KeyCollectionSummaryBase){
                    self.array_KeyCollection = response.data
                    
                    self.dataSource.array_KeyCollection = self.array_KeyCollection
                    if self.array_KeyCollection.count == 0{

                    }
                    else{
                       // self.view_NoRecords.removeFromSuperview()
                    }
                    DispatchQueue.main.async {
                        self.table_AppointmentUnitTakeOver.reloadData()
                        self.tableView.reloadData()
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
    func getUnitList(){
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.get_UnitList(parameters: ["login_id":userId], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? UnitBase){
                    self.unitsData = response.units
                    self.dataSource.unitsData = response.units
                   
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
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return view_Footer
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 150

    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 1{
            if self.appointment == .keyCollection{
                let ht = selectedRowIndex_Appointment == -1  ?  (array_KeyCollection.count * 100) + 310 : ((array_KeyCollection.count - 1) * 100) + 210 + 310
                return CGFloat(ht)
            }
            else{
                return  (3 * 210)  + 310
            }
           // return tableHeight > 0 ?  tableHeight   :  super.tableView(tableView, heightForRowAt: indexPath)
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedRowIndex_Appointment = -1
        if appointment == .keyCollection{
        getKeyCollectionSummary()
        }
        self.showBottomMenu()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.closeMenu()
    }
    func showBottomMenu(){
        
        menu.delegate = self
        menu.showInView(self.view, title: "", message: "")
       // self.menu.loadCollection(array_Permissions: global_array_Permissions, array_Modules: global_array_Modules)
    }
    func closeMenu(){
        menu.removeView()
    }
    override func getBackgroundImageName() -> String {
        let imgdefault = ""//UserInfoModalBase.currentUser?.data.property.defect_bg ?? ""
        return imgdefault
    }
//MARK: UIBUTTON ACTION
    @IBAction func actionStatus(_ sender:UIButton) {
        
        let sortedArray = statusData.sorted { $0.key < $1.key }
        let arrStatus = sortedArray.map { $0.value }
        let dropDown_Status = DropDown()
        dropDown_Status.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Status.dataSource = arrStatus//statusData.map({$0.value})//Array(statusData.values)
        dropDown_Status.show()
        dropDown_Status.selectionAction = { [unowned self] (index: Int, item: String) in
            txt_Status.text = item
            txt_Month.text = ""
            txt_UnitNo.text = ""
            if appointment == .keyCollection{
            searchKeyCollectionSummary()
            }
            
        }
    }
    @IBAction func actionUnit(_ sender:UIButton) {
        let sortedArray = unitsData.sorted(by:  { $0.1 < $1.1 })
        let arrUnit = sortedArray.map { $0.value }
        let dropDown_Unit = DropDown()
        dropDown_Unit.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Unit.dataSource = arrUnit//Array(unitsData.values)
        dropDown_Unit.show()
        dropDown_Unit.selectionAction = { [unowned self] (index: Int, item: String) in
            txt_Status.text = ""
            txt_Month.text = ""
            txt_UnitNo.text = item
            if appointment == .keyCollection{
            searchKeyCollectionSummary()
            }
            
        }
    }
    @IBAction func actionMonth(_ sender: UIButton){
        let expiryDatePicker = MonthYearPickerView()
        expiryDatePicker.onDateSelected = { (month: Int, year: Int) in
            let string = String(format: "%02d/%d", month, year)
            NSLog(string) // should show something like 05/2015
            self.txt_Status.text = ""
            self.txt_Month.text = string
            self.txt_UnitNo.text = ""
        }
    }
    @IBAction func actionNewAppointment(_ sender: UIButton){
        let announcementTVC = self.storyboard?.instantiateViewController(identifier: "NewAppointmentTableViewController") as! NewAppointmentTableViewController
        self.navigationController?.pushViewController(announcementTVC, animated: true)
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
class DataSource_AppointmentUnitTakeOver: NSObject, UITableViewDataSource, UITableViewDelegate {

    var parentVc: UIViewController!
    var appointment: Appointment!
    var array_KeyCollection = [KeyCollectionModal]()
    var unitsData = [String: String]()
    
func numberOfSectionsInTableView(tableView: UITableView) -> Int {

    return 1;
}

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.appointment == .keyCollection  ? array_KeyCollection.count : 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "appointmentUnitCell") as! AppointmentUnitTakeOverTableViewCell
        cell.selectionStyle = .none
        cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
        if self.appointment == .keyCollection {
        let apptInfo = self.array_KeyCollection[indexPath.row]
        cell.lbl_BookedBy.text = apptInfo.submission_info.getname?.name  ?? "-"
        cell.lbl_UnitNo.text = apptInfo.submission_info.getunit?.unit ?? "-"
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: apptInfo.submission_info.appt_date)
        formatter.dateFormat = "dd/MM/yy"
        let dateStr = formatter.string(from: date ?? Date())
        
       
        cell.lbl_AppointmentDate.text = dateStr
        
        
        cell.lbl_AppointmentTime.text =  apptInfo.submission_info.appt_time
        cell.lbl_Status.text =  apptInfo.submission_info.status == 1 ? "Cancelled" : apptInfo.submission_info.status == 2  ? "On Schedule" : apptInfo.submission_info.status == 3 ? "Done" : ""
            
           
        cell.view_Outer.tag = indexPath.row
        cell.btn_Edit.tag = indexPath.row
        }
        cell.btn_Edit.addTarget(self, action: #selector(self.actionEdit(_:)), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        cell.view_Outer.addGestureRecognizer(tap)
        if self.appointment == .keyCollection{
        if indexPath.row != selectedRowIndex_Appointment{
            for vw in cell.arrViews{
                vw.isHidden = true
            }
        }
        else{
            for vw in cell.arrViews{
                vw.isHidden = false
            }
        }
        }
        else{
            cell.img_Arrow.isHidden = true
            for vw in cell.arrViews{
                vw.isHidden = false
            }
        }
            return cell
      
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return self.appointment == .keyCollection ? indexPath.row == selectedRowIndex_Appointment ? 210 : 100 : 210
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if self.appointment == .keyCollection{
        selectedRowIndex_Appointment = (sender! as UITapGestureRecognizer).view!.tag
        DispatchQueue.main.async {
            (self.parentVc as! AppointmentUnitTakeOverTableViewController).tableView.reloadData()
        (self.parentVc as! AppointmentUnitTakeOverTableViewController).table_AppointmentUnitTakeOver.reloadData()
      
        }
        }
        else{
            
        }
    }
    
    @IBAction func actionEdit(_ sender:UIButton){
        if self.appointment == .keyCollection{
            let apptInfo = self.array_KeyCollection[sender.tag]
        let editAppointmentVC = self.parentVc.storyboard?.instantiateViewController(identifier: "EditAppointmentTableViewController") as! EditAppointmentTableViewController
            editAppointmentVC.keyCollection = apptInfo
        self.parentVc.navigationController?.pushViewController(editAppointmentVC, animated: true)
        }
        else{
            let editAppointmentVC = self.parentVc.storyboard?.instantiateViewController(identifier: "EditInspectionTableViewController") as! EditInspectionTableViewController
          
            self.parentVc.navigationController?.pushViewController(editAppointmentVC, animated: true)
        }
       
    }
}


extension AppointmentUnitTakeOverTableViewController: MenuViewDelegate{
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

