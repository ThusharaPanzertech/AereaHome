//
//  VisitorWalkinTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 10/03/23.
//

import UIKit
import DropDown

var array_walkinVistors = [[String: String]]()
let kName = "name"
let kMobile = "mobile"
let kVehNo = "vehicleno"
let kIdNo = "idno"

var slotsAvailable = 0
var entrydate = ""
var entrytime = ""


class VisitorWalkinTableViewController: BaseTableViewController {
    
    var arrayFunctionTypes = [VisitorFunctionInfoBase]()
    var selectedFunction: VisitorFunctionInfoBase!
    let alertView: AlertView = AlertView.getInstance
    let alertView_message: MessageAlertView = MessageAlertView.getInstance
    //Outlets
    @IBOutlet weak var view_SwitchProperty: UIView!
    @IBOutlet weak var lbl_SwitchProperty: UILabel!
    
    @IBOutlet var arr_Textfields: [UITextField]!
    @IBOutlet weak var txt_Unit: UITextField!
    @IBOutlet weak var txt_Purpose: UITextField!
    @IBOutlet weak var txt_Comapny: UITextField!
    @IBOutlet weak var txt_Function: UITextField!
    @IBOutlet weak var lbl_FunctionName: UILabel!

    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var imgView_Profile: UIImageView!
    let menu: MenuView = MenuView.getInstance
    @IBOutlet weak var table_VisitorList: UITableView!
    var dataSource = DataSource_VisitorWalkinList()
    var unitsData = [Unit]()
    var hideFunctionInfo = true
    var hideCompanyInfo = false
    var id_required = false
    var arr_VisitingPurpose = [String: String]()
   var selected_purposeId = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slotsAvailable = 0
        array_walkinVistors = [[kName:"", kMobile:"", kIdNo:"", kVehNo:""]]
        
        lbl_SwitchProperty.text = kCurrentPropertyName
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
        table_VisitorList.dataSource = dataSource
        table_VisitorList.delegate = dataSource
        dataSource.parentVc = self
        dataSource.unitsData = self.unitsData
        setUpUI()
       
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
     
        let dateStr = formatter.string(from:  Date())
       
      
        formatter.dateFormat =  "hh:mm a"
        let timeStr = formatter.string(from:  Date())
        
        entrydate = dateStr
        entrytime = timeStr
       // getVisitorInfo()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedRowIndex_Visitor = -1
        self.showBottomMenu()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.closeMenu()
    }
   
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2{
            return self.hideCompanyInfo ? 0 : super.tableView(tableView, heightForRowAt: indexPath)
        }
        else if indexPath.row == 3{
            return self.hideFunctionInfo ? 0 : super.tableView(tableView, heightForRowAt: indexPath)
            
        }
        else if indexPath.row == 4{
            if id_required == true{
                return CGFloat(470 * array_walkinVistors.count + 70)
            }
            else{
                return CGFloat(410 * array_walkinVistors.count + 70)
            }
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
       
        
        
        view_Background.layer.cornerRadius = 25.0
        view_Background.layer.masksToBounds = true
      
        imgView_Profile.addborder()
       
        
         for txtField in arr_Textfields{
             txtField.layer.cornerRadius = 20.0
             txtField.layer.masksToBounds = true
             txtField.delegate = self
             txtField.textColor =  UIColor(red: 93/255, green: 93/255, blue: 93/255, alpha: 1.0)
             txtField.attributedPlaceholder = NSAttributedString(string: txtField.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
         }
     
    }
    func setData(){
       
    }



    //MARK: ******  PARSING *********
   
    func getVisitorAvailability(){
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
     
        let dateStr = formatter.string(from:  Date())
       
      
        
        
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        array_VehicleNo.removeAll()
        array_Entering.removeAll()
        ApiService.get_VisitorAvailabilty(parameters: ["login_id":userId,"purpose" : selected_purposeId, "date": dateStr], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            self.getVisitorFunction()
            if status  && result != nil{
                 if let response = (result as? VisitorAvaiabiltyBase){
                     if response.response == 1{
                         self.displayToastMessage("\(response.slot_available) slot(s) available")
                     }
                     slotsAvailable = response.slot_available
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
    func getVisitorFunction(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        array_VehicleNo.removeAll()
        array_Entering.removeAll()
        ApiService.get_VisitorFunctions(parameters: ["login_id":userId, "id" : selected_purposeId], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
           
            if status  && result != nil{
                 if let response = (result as? VisitorFunctionBase){
                     self.arrayFunctionTypes = response.types
                     
                     let prop = self.arrayFunctionTypes.first(where:{ $0.type.visiting_purpose == self.txt_Purpose.text!})
                     if prop != nil{
                         self.selectedFunction = prop!
                         self.hideCompanyInfo = prop!.type.compinfo_required == 1 ? false : true
                         self.hideFunctionInfo = prop!.type.sub_category == "" ? true : false
                         self.id_required = prop!.type.id_required == 1 ? true : false
                         self.dataSource.id_required = self.id_required
                         self.lbl_FunctionName.text = prop?.type.sub_category
                         
                         DispatchQueue.main.async {
                            
                             self.tableView.reloadData()
                             self.table_VisitorList.reloadData()
                         }
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
    func registerWalkin(){
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        var unit_Id = ""
        if let unitId = unitsData.first(where: { $0.unit == txt_Unit.text }){
            unit_Id = "\(unitId.id)"
        }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
     
        let dateStr = formatter.string(from:  Date())
        var company = ""
       
        let params = NSMutableDictionary()
        params.setValue("\(userId)", forKey: "login_id")
        params.setValue(unit_Id, forKey: "unit_no")
        params.setValue(selected_purposeId, forKey: "visiting_purpose")
        params.setValue(dateStr, forKey: "visiting_date")
        if !hideCompanyInfo{
            company = txt_Comapny.text!
        }
        params.setValue(company, forKey: "company_info_\(selected_purposeId)")
        
        var functionId = ""
        if let unitId = selectedFunction.type.subcategory.first(where: { $0.sub_category == txt_Function.text }){
            functionId = "\(unitId.type_id)"
        }
        params.setValue(functionId, forKey: "sub_cat_\(selected_purposeId)")
      
        for  (index, data) in array_walkinVistors.enumerated(){
            params.setValue(data[kName], forKey: "name_\(index + 1)")
            params.setValue(data[kMobile], forKey: "mobile_\(index + 1)")
            params.setValue(data[kVehNo], forKey: "vehicle_no_\(index + 1)")
            params.setValue(data[kIdNo], forKey: "id_number_\(index + 1)")
            
        }
        
        ActivityIndicatorView.show("Loading")
       
       
        ApiService.register_VisitorWalkin(parameters:params as! [String : Any], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
           
            if status  && result != nil{
                 if let response = (result as? WalkinVisitorBase){
                     DispatchQueue.main.async {
                         self.alertView_message.delegate = self
                         self.alertView_message.showInView(self.view_Background, title: "Visitor registered\n successfully", okTitle: "Home", cancelTitle: "View Visitor Bookings")
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
    
    @IBAction func actionSubmit(_ sender: UIButton){
        if txt_Unit.text == ""{
            displayErrorAlert(alertStr: "Please select the unit", title: "")
        }
        else if txt_Purpose.text == ""{
            displayErrorAlert(alertStr: "Please select the visiting purpose", title: "")
        }
        else if hideCompanyInfo == false &&  txt_Comapny.text == ""{
           
                displayErrorAlert(alertStr: "Please enter the company", title: "")
            
        }
        else if hideFunctionInfo == false &&  txt_Function.text == ""{
           
                displayErrorAlert(alertStr: "Please select the item", title: "")
            
        }
        else if array_walkinVistors.count == 0{
            displayErrorAlert(alertStr: "Please enter atleast one visitor details", title: "")
        }
        else{
            var errormsg = ""
            for data in array_walkinVistors{
               
                if data[kName] == ""{
                    errormsg = "Please enter the visitor name"
                    break
                }
                if data[kMobile] == ""{
                    errormsg = "Please enter the visitor mobile"
                    break
                }
                else if id_required == true && data[kIdNo] == ""{
                    errormsg =  "Please enter the visitor Id"
                    break
                    }
                }
            if errormsg == ""{
                registerWalkin()
            }
            else{
                displayErrorAlert(alertStr: errormsg, title: "")
            }
            }
        }
    
    @IBAction func actionAddNew(_ sender: UIButton){
        if array_walkinVistors.count < slotsAvailable{
            let new_visitor  = [kName:"", kMobile:"", kIdNo:"", kVehNo:""]
            array_walkinVistors.append(new_visitor)
            
            table_VisitorList.reloadData()
            self.tableView.reloadData()
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
  
    @IBAction func actionVisitingPurpose(_ sender:UIButton) {
        let sortedArray = arr_VisitingPurpose.sorted { $0.key < $1.key }
        let arrfacilityOptions = sortedArray.map { $0.value }
        let dropDown_arrfacilityOptions = DropDown()
        dropDown_arrfacilityOptions.anchorView = sender // UIView or UIBarButtonItem
        dropDown_arrfacilityOptions.dataSource = arrfacilityOptions//Array(roles.values)
        dropDown_arrfacilityOptions.show()
        dropDown_arrfacilityOptions.selectionAction = { [unowned self] (index: Int, item: String) in
            txt_Purpose.text = item
           
            selected_purposeId = sortedArray[index].key
            self.getVisitorAvailability()
        }
    }
    @IBAction func actionFunctionType(_ sender:UIButton) {
        if selectedFunction != nil{
       
            let arrfacilityOptions = selectedFunction.type.subcategory.map { $0.sub_category }
        let dropDown_arrfacilityOptions = DropDown()
        dropDown_arrfacilityOptions.anchorView = sender // UIView or UIBarButtonItem
        dropDown_arrfacilityOptions.dataSource = arrfacilityOptions//Array(roles.values)
        dropDown_arrfacilityOptions.show()
            dropDown_arrfacilityOptions.selectionAction = { [unowned self] (index: Int, item: String) in
                txt_Function.text = item
                
                
            }
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
        @IBAction func actionNewWalkin(_ sender: UIButton){
           
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
class DataSource_VisitorWalkinList: NSObject, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    var unitsData = [Unit]()
    var parentVc: UIViewController!
    var visitorInfo : VisitorDetailsBase!
    var id_required = false
    var arr_VisitingPurpose = [String: String]()
func numberOfSectionsInTableView(tableView: UITableView) -> Int {

    return 1;
}

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return  array_walkinVistors.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: VisitorWalkinTableViewCell!
        if self.id_required == false{
            cell = (tableView.dequeueReusableCell(withIdentifier: "vistorCell") as? VisitorWalkinTableViewCell)
        }
        else{
            cell = tableView.dequeueReusableCell(withIdentifier: "vistoridCell") as? VisitorWalkinTableViewCell
        }
        let visitorData = array_walkinVistors[indexPath.row]
        cell.txt_Name.text = visitorData[kName]
        cell.txt_Mobile.text = visitorData[kMobile]
        cell.txt_VehicleNo.text = visitorData[kVehNo]
        if self.id_required{
            cell.txt_Id.text = visitorData[kIdNo]
        }
        cell.lbl_VisitorTitle.text = "Visitor \(indexPath.row + 1) details"
        cell.txt_Name.tag = indexPath.row
        cell.txt_Name.delegate = self
        cell.txt_Name.addTarget(self, action: #selector(nameChanged), for: .editingChanged)
       
        cell.btn_Close.tag = indexPath.row
        cell.btn_Close.addTarget(self, action: #selector(self.actionClose(_:)), for: .touchUpInside)
        cell.txt_Name.tag = indexPath.row
        cell.txt_Mobile.delegate = self
        cell.txt_Mobile.addTarget(self, action: #selector(mobileChanged), for: .editingChanged)
       
        cell.txt_VehicleNo.tag = indexPath.row
        cell.txt_VehicleNo.delegate = self
        cell.txt_VehicleNo.addTarget(self, action: #selector(vehicleChanged), for: .editingChanged)
       
        if  cell.txt_Id != nil{
            cell.txt_Id.tag = indexPath.row
            cell.txt_Id.delegate = self
            cell.txt_Id.addTarget(self, action: #selector(idChanged), for: .editingChanged)
        }
        
        cell.lbl_EntryTime.text = entrytime
        cell.lbl_EntryDate.text = entrydate
        
        cell.selectionStyle = .none
       
        
      
        return cell
      
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return id_required ? 470 : 410
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        selectedRowIndex_Visitor = (sender! as UITapGestureRecognizer).view!.tag
        DispatchQueue.main.async {
            (self.parentVc as! VisitorManagementTableViewController
            ).tableView.reloadData()
        (self.parentVc as! VisitorManagementTableViewController).table_VisitorList.reloadData()
      
        }
       
       
    }
    @objc func nameChanged(_ textField: UITextField){
      
        array_walkinVistors[textField.tag][kName] = textField.text
        
    }
   
    @objc func mobileChanged(_ textField: UITextField){
        array_walkinVistors[textField.tag][kMobile] = textField.text
        
    }
    @objc func vehicleChanged(_ textField: UITextField){
      
        array_walkinVistors[textField.tag][kVehNo] = textField.text
        
    }
   
    @objc func idChanged(_ textField: UITextField){
        array_walkinVistors[textField.tag][kIdNo] = textField.text
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func actionEnteringPremise(_ sender:UIButton){

        var isEntering = array_Entering[sender.tag]
        if sender.isSelected{
            isEntering = 0
        }
        else{
            isEntering = 1
        }
        array_Entering[sender.tag] = isEntering
        (self.parentVc as! VisitorWalkinTableViewController).table_VisitorList.reloadData()
    }
    @IBAction func actionClose(_ sender: UIButton){
       
        array_walkinVistors.remove(at: sender.tag)
        DispatchQueue.main.async {
            (self.parentVc as! VisitorWalkinTableViewController).table_VisitorList.reloadData()
            (self.parentVc as! VisitorWalkinTableViewController).tableView.reloadData()
            
        }
        
    }
}
extension VisitorWalkinTableViewController: MenuViewDelegate{
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

   
extension VisitorWalkinTableViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}






extension VisitorWalkinTableViewController: AlertViewDelegate{
    func onBackClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func onCloseClicked() {
        
    }
    
    func onOkClicked() {
       
    }
    
    
}
extension VisitorWalkinTableViewController: MessageAlertViewDelegate{
    func onHomeClicked() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func onListClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

