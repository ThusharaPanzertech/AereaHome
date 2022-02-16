//
//  EFormSummaryTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 07/02/22.
//

import UIKit
import DropDown
enum eForm{
    case moveInOut
    case renovation
    case doorAccess
    case vehicleReg
    case updateAddress
    case updateParticulars
}


class EFormSummaryTableViewController: BaseTableViewController {
    
    //Outlets
    let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
    @IBOutlet weak var view_Footer: UIView!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var imgView_Profile: UIImageView!
    @IBOutlet var arr_Textfields: [UITextField]!
    @IBOutlet weak var txt_Status: UITextField!
    @IBOutlet weak var txt_Ticket: UITextField!
    @IBOutlet weak var txt_Name: UITextField!
    @IBOutlet weak var txt_Unit: UITextField!
    @IBOutlet weak var btn_NewList: UIButton!
    let menu: MenuView = MenuView.getInstance
    @IBOutlet weak var table_EFormSubmissions: UITableView!
    var dataSource = DataSource_EFormSubmissions()
      var formName = ""
    var formType : eForm!
    var arr_MoveInOut = [MoveInOut]()
    var arr_Renovation = [Renovation]()
    var arr_DoorAccess = [DoorAccess]()
    var arr_UpdateAddress = [UpdateAddress]()
    var arr_UpdateParticulars = [UpdateParticulars]()
    var arr_VehicleReg = [VehicleReg]()
    var unitsData = [String: String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        lbl_Title.text = formName
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
        table_EFormSubmissions.dataSource = dataSource
        table_EFormSubmissions.delegate = dataSource
        dataSource.parentVc = self
        dataSource.formType = self.formType
        setUpUI()
        let fname = Users.currentUser?.user?.name ?? ""
        let lname = Users.currentUser?.moreInfo?.last_name ?? ""
        self.lbl_UserName.text = "\(fname) \(lname)"
        let role = Users.currentUser?.role?.name ?? ""
        self.lbl_UserRole.text = role
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getEFormSummary(isToSearch: false, param: ["login_id":userId])
       
        
        
        self.showBottomMenu()
    }
    func getEFormSummary(isToSearch: Bool, param:[String : Any]?){
        
        if formType == .moveInOut {
            getSummary_MoveInOut(isToSearch: isToSearch, param: param)
        }
        else if formType == .renovation{
            getSummary_Renovation(isToSearch: isToSearch, param: param)
        }
        else if formType == .vehicleReg{
            getSummary_VehicleReg(isToSearch: isToSearch, param: param)
        }
        else if formType == .doorAccess {
            getSummary_DoorAccess(isToSearch: isToSearch, param: param)
        }
        else if formType == .updateAddress{
            getSummary_UpdateAddress(isToSearch: isToSearch, param: param)
        }
        else if formType == .updateParticulars{
            getSummary_UpdateParticulars(isToSearch: isToSearch, param: param)
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.closeMenu()
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return view_Footer
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0

    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       let count = formType == .moveInOut ?  arr_MoveInOut.count :
        formType == .renovation ?  arr_Renovation.count :
        formType == .vehicleReg ?  arr_VehicleReg.count :
        formType == .doorAccess ?  arr_DoorAccess.count :
        formType == .updateAddress ?  arr_UpdateAddress.count :
        formType == .updateParticulars ?  arr_UpdateParticulars.count : 0
        
        if indexPath.row == 1{
            return CGFloat((252 * count) + 350) +  30
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
            txtField.delegate = self
            txtField.layer.cornerRadius = 20.0
            txtField.layer.masksToBounds = true
            txtField.textColor = textColor
            txtField.attributedPlaceholder = NSAttributedString(string: txtField.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
        }
        btn_NewList.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
      
        btn_NewList.layer.cornerRadius = 10.0
    }
    
    
    
    func getSummary_MoveInOut(isToSearch: Bool, param:[String : Any]?){
        ActivityIndicatorView.show("Loading")
        
        //
        
        ApiService.get_MoveInOutSummary(isToSearch: isToSearch, parameters: param!, completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? MoveInOutSummaryBase){
                    self.arr_MoveInOut = response.data
                    self.dataSource.arr_MoveInOut = response.data
                   
                    self.table_EFormSubmissions.reloadData()
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
    func getSummary_Renovation(isToSearch: Bool, param:[String : Any]?){
        ActivityIndicatorView.show("Loading")
     //   let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.get_RenovationSummary(isToSearch: isToSearch, parameters: param!, completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? RenovationSummaryBase){
                    self.arr_Renovation = response.data
                    self.dataSource.arr_Renovation = response.data
                   
                    self.table_EFormSubmissions.reloadData()
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
    func getSummary_DoorAccess(isToSearch: Bool, param:[String : Any]?){
        ActivityIndicatorView.show("Loading")
        //let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.get_DoorAccessSummary(isToSearch: isToSearch, parameters: param!, completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? DoorAccessSummaryBase){
                    self.arr_DoorAccess = response.data
                    self.dataSource.arr_DoorAccess = response.data
                   
                    self.table_EFormSubmissions.reloadData()
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
    func getSummary_VehicleReg(isToSearch: Bool, param:[String : Any]?){
        ActivityIndicatorView.show("Loading")
       // let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.get_VehicleRegSummary(isToSearch: isToSearch, parameters: param!, completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? VehicleRegSummaryBase){
                    self.arr_VehicleReg = response.data
                    self.dataSource.arr_VehicleReg = response.data
                   
                    self.table_EFormSubmissions.reloadData()
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
    func getSummary_UpdateAddress(isToSearch: Bool, param:[String : Any]?){
        ActivityIndicatorView.show("Loading")
       // let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.get_UpdateAddressSummary(isToSearch: isToSearch, parameters: param!, completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? UpdateAddressSummaryBase){
                    self.arr_UpdateAddress = response.data
                    self.dataSource.arr_UpdateAddress = response.data
                   
                    self.table_EFormSubmissions.reloadData()
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
    func getSummary_UpdateParticulars(isToSearch: Bool, param:[String : Any]?){
        ActivityIndicatorView.show("Loading")
  //      let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.get_UpdateParticularsSummary(isToSearch: isToSearch, parameters: param!, completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? UpdateParticularsSummaryBase){
                    self.arr_UpdateParticulars = response.data
                    self.dataSource.arr_UpdateParticulars = response.data
                   
                    self.table_EFormSubmissions.reloadData()
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
    func searchEForms(){
       
            if txt_Ticket.text == "" && txt_Unit.text == "" && txt_Name.text == "" && txt_Status.text == "" {
                self.getEFormSummary(isToSearch: false, param: ["login_id":userId])
            }
            else{
            
          
                
            ActivityIndicatorView.show("Loading")
            let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
            var param = [String : Any]()
            if txt_Ticket.text != ""{
                param = [
                    "login_id" : userId,
                    "option": "ticket",
                    
                    "ticket" : txt_Ticket.text!
                    
                ] as [String : Any]
            }
            else if txt_Status.text != ""{
                param = [
                    "login_id" : userId,
                    "option": "status",
                   
                    "status" : txt_Status.text ==  "New" ? 0 :
                        txt_Status.text ==  "Cancelled" ? 1 :
                        txt_Status.text ==  "In Progress" ? 2 :
                        txt_Status.text ==  "Approved" ? 3 :
                        txt_Status.text ==  "Rejected" ? 4 : 0
                       
                    
                ] as [String : Any]
            }
            else if txt_Unit.text != ""{
                param = [
                    "login_id" : userId,
                    "option": "unit",
                    "unit" : txt_Unit.text!
                    
                ] as [String : Any]
            }
            else if txt_Name.text != ""{
                param = [
                    "login_id" : userId,
                    "option": "name",
                    "name" : txt_Name.text!,
                   
                    
                ] as [String : Any]
            }
            
            
                self.getEFormSummary(isToSearch: true, param: param)
        }
        
        
        
    }
    //MARK: UIBUTTON ACTION
    @IBAction func actionUnit(_ sender:UIButton) {
        let sortedArray = unitsData.sorted(by:  { $0.1 < $1.1 })
        let arrUnit = sortedArray.map { $0.value }
        let dropDown_Unit = DropDown()
        dropDown_Unit.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Unit.dataSource = arrUnit// Array(unitsData.values)
        dropDown_Unit.show()
        dropDown_Unit.selectionAction = { [unowned self] (index: Int, item: String) in
            txt_Name.text = ""
            txt_Status.text = ""
            txt_Ticket.text = ""
            txt_Unit.text = item
            self.searchEForms()
            
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
            txt_Name.text = ""
            txt_Ticket.text = ""
            txt_Unit.text = ""
            self.searchEForms()
            
        }
    }
        @IBAction func actionNewDefects(_ sender: UIButton){
            let defectTVC = self.storyboard?.instantiateViewController(identifier: "NewDefectsTableViewController") as! NewDefectsTableViewController
            defectTVC.appointmentType = .defect
            self.navigationController?.pushViewController(defectTVC, animated: true)
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
class DataSource_EFormSubmissions: NSObject, UITableViewDataSource, UITableViewDelegate {
    var formType : eForm!
    var parentVc: UIViewController!
    var arr_MoveInOut = [MoveInOut]()
    var arr_Renovation = [Renovation]()
    var arr_DoorAccess = [DoorAccess]()
    var arr_UpdateAddress = [UpdateAddress]()
    var arr_UpdateParticulars = [UpdateParticulars]()
    var arr_VehicleReg = [VehicleReg]()
func numberOfSectionsInTableView(tableView: UITableView) -> Int {

    return 1;
}

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  formType == .moveInOut ?  arr_MoveInOut.count :
        formType == .renovation ?  arr_Renovation.count :
        formType == .vehicleReg ?  arr_VehicleReg.count :
        formType == .doorAccess ?  arr_DoorAccess.count :
        formType == .updateAddress ?  arr_UpdateAddress.count :
        formType == .updateParticulars ?  arr_UpdateParticulars.count : 0
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "eformSummaryCell") as! EFormSummaryTableViewCell
        cell.selectionStyle = .none
           
        cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
        cell.btn_Edit.addTarget(self, action: #selector(self.actionEdit(_:)), for: .touchUpInside)
        cell.view_Outer.tag = indexPath.row
        cell.btn_Edit.tag = indexPath.row
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        cell.view_Outer.addGestureRecognizer(tap)
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        cell.btn_Payment.addTarget(self, action: #selector(self.actionPayment(_:)), for: .touchUpInside)
        cell.btn_Payment.tag = indexPath.row
        
        cell.btn_Inspection.addTarget(self, action: #selector(self.actionInspection(_:)), for: .touchUpInside)
        cell.btn_Inspection.tag = indexPath.row
       
        if formType == .moveInOut {
            let info = arr_MoveInOut[indexPath.row]
            
            let moving_date = formatter.date(from: info.submission.moving_date)
            let moving_start = formatter.date(from: info.submission.moving_start)
            let moving_end = formatter.date(from: info.submission.moving_end)
            formatter.dateFormat = "dd/MM/yyyy"
            
            let moving_dateStr = formatter.string(from: moving_date ?? Date())
            let moving_startStr = formatter.string(from: moving_start ?? Date())
            let moving_endStr = formatter.string(from: moving_end ?? Date())
            
            cell.lbl_TicketNo.text = info.submission.ticket
            cell.lbl_Status.text = info.submission.status == 0 ? "New" :
                info.submission.status == 1 ? "Cancelled" :
                info.submission.status == 2 ? "In Progress" :
                info.submission.status == 3 ? "Approved" :
                info.submission.status == 4 ? "Rejected" :
                info.submission.status == 5 ? "Payment Pending" :
                info.submission.status == 6 ? "Refunded" : ""
            cell.lbl_UnitNo.text = info.unit.unit
            cell.lbl_SubmittedDate.text = moving_dateStr
            cell.lbl_TenancyStart.text = moving_startStr
            cell.lbl_TenancyEnd.text = moving_endStr
            cell.lbl_SubmittedBy.text = info.submitted_by.name
            
            cell.btn_Payment.isHidden = false
            cell.btn_Inspection.isHidden = false
        }
        else if formType == .renovation{
            cell.btn_Payment.isHidden = false
            cell.btn_Inspection.isHidden = false
            
            let info = arr_Renovation[indexPath.row]
            
            let moving_date = formatter.date(from: info.submission.reno_date)
            let moving_start = formatter.date(from: info.submission.reno_start)
            let moving_end = formatter.date(from: info.submission.reno_end)
            formatter.dateFormat = "dd/MM/yyyy"
            
            let moving_dateStr = formatter.string(from: moving_date ?? Date())
            let moving_startStr = formatter.string(from: moving_start ?? Date())
            let moving_endStr = formatter.string(from: moving_end ?? Date())
            
            
            cell.lbl_TicketNo.text = info.submission.ticket
            cell.lbl_Status.text = info.submission.status == 0 ? "New" :
                info.submission.status == 1 ? "Cancelled" :
                info.submission.status == 2 ? "In Progress" :
                info.submission.status == 3 ? "Approved" :
                info.submission.status == 4 ? "Rejected" :
                info.submission.status == 5 ? "Payment Pending" :
                info.submission.status == 6 ? "Refunded" : ""
            cell.lbl_UnitNo.text = info.unit.unit
            cell.lbl_SubmittedDate.text = moving_dateStr
            cell.lbl_TenancyStart.text = moving_startStr
            cell.lbl_TenancyEnd.text =  moving_endStr
            cell.lbl_SubmittedBy.text = info.submitted_by.name
        }
        else if formType == .vehicleReg{
            cell.btn_Payment.isHidden = false
            cell.btn_Inspection.isHidden = true
            let info = arr_VehicleReg[indexPath.row]
            
            let moving_date = formatter.date(from: info.submission.request_date)
            let moving_start = formatter.date(from: info.submission.tenancy_start)
            let moving_end = formatter.date(from: info.submission.tenancy_end)
            formatter.dateFormat = "dd/MM/yyyy"
            
            let moving_dateStr = formatter.string(from: moving_date ?? Date())
            let moving_startStr = formatter.string(from: moving_start ?? Date())
            let moving_endStr = formatter.string(from: moving_end ?? Date())
            
            cell.lbl_TicketNo.text = info.submission.ticket
            cell.lbl_Status.text = info.submission.status == 0 ? "New" :
                info.submission.status == 1 ? "Cancelled" :
                info.submission.status == 2 ? "In Progress" :
                info.submission.status == 3 ? "Approved" :
                info.submission.status == 4 ? "Rejected" :
                info.submission.status == 5 ? "Payment Pending" :
                info.submission.status == 6 ? "Refunded" : ""
            cell.lbl_UnitNo.text = info.unit.unit
            cell.lbl_SubmittedDate.text = moving_dateStr
            cell.lbl_TenancyStart.text = moving_startStr
            cell.lbl_TenancyEnd.text =  moving_endStr
            cell.lbl_SubmittedBy.text = info.submitted_by.name
        }
        else if formType == .doorAccess {
            cell.btn_Payment.isHidden = true
            cell.btn_Inspection.isHidden = true
            let info = arr_DoorAccess[indexPath.row]
            
            let moving_date = formatter.date(from: info.submission.request_date)
            let moving_start = formatter.date(from: info.submission.tenancy_start)
            let moving_end = formatter.date(from: info.submission.tenancy_end)
            formatter.dateFormat = "dd/MM/yyyy"
            
            let moving_dateStr = formatter.string(from: moving_date ?? Date())
            let moving_startStr = formatter.string(from: moving_start ?? Date())
            let moving_endStr = formatter.string(from: moving_end ?? Date())
            
            cell.lbl_TicketNo.text = info.submission.ticket
            cell.lbl_Status.text = info.submission.status == 0 ? "New" :
                info.submission.status == 1 ? "Cancelled" :
                info.submission.status == 2 ? "In Progress" :
                info.submission.status == 3 ? "Approved" :
                info.submission.status == 4 ? "Rejected" :
                info.submission.status == 5 ? "Payment Pending" :
                info.submission.status == 6 ? "Refunded" : ""
            cell.lbl_UnitNo.text = info.unit.unit
            cell.lbl_SubmittedDate.text = moving_dateStr
            cell.lbl_TenancyStart.text = moving_startStr
            cell.lbl_TenancyEnd.text = moving_endStr
            cell.lbl_SubmittedBy.text = info.submitted_by.name
        }
        else if formType == .updateAddress{
            cell.btn_Payment.isHidden = true
            cell.btn_Inspection.isHidden = true
            let info = arr_UpdateAddress[indexPath.row]
            
            let moving_date = formatter.date(from: info.submission.request_date)
            let moving_start = formatter.date(from: info.submission.date_of_sign)
            let moving_end = formatter.date(from: info.submission.date_of_sign)
            formatter.dateFormat = "dd/MM/yyyy"
            
            let moving_dateStr = formatter.string(from: moving_date ?? Date())
            let moving_startStr = formatter.string(from: moving_start ?? Date())
            let moving_endStr = formatter.string(from: moving_end ?? Date())
            
            cell.lbl_TicketNo.text = info.submission.ticket
            cell.lbl_Status.text = info.submission.status == 0 ? "New" :
                info.submission.status == 1 ? "Cancelled" :
                info.submission.status == 2 ? "In Progress" :
                info.submission.status == 3 ? "Approved" :
                info.submission.status == 4 ? "Rejected" :
                info.submission.status == 5 ? "Payment Pending" :
                info.submission.status == 6 ? "Refunded" : ""
            cell.lbl_UnitNo.text = info.unit.unit
            cell.lbl_SubmittedDate.text = moving_dateStr
            cell.lbl_TenancyStart.text = moving_startStr
            cell.lbl_TenancyEnd.text = moving_endStr
            cell.lbl_SubmittedBy.text = info.submission.user.name
        }
        else if formType == .updateParticulars{
            cell.btn_Payment.isHidden = true
            cell.btn_Inspection.isHidden = true
            let info = arr_UpdateParticulars[indexPath.row]
            
            let moving_date = formatter.date(from: info.submission.request_date)
            let moving_start = formatter.date(from: info.submission.tenancy_start)
            let moving_end = formatter.date(from: info.submission.tenancy_end)
            formatter.dateFormat = "dd/MM/yyyy"
            
            let moving_dateStr = formatter.string(from: moving_date ?? Date())
            let moving_startStr = formatter.string(from: moving_start ?? Date())
            let moving_endStr = formatter.string(from: moving_end ?? Date())
            
            cell.lbl_TicketNo.text = info.submission.ticket
            cell.lbl_Status.text = info.submission.status == 0 ? "New" :
                info.submission.status == 1 ? "Cancelled" :
                info.submission.status == 2 ? "In Progress" :
                info.submission.status == 3 ? "Approved" :
                info.submission.status == 4 ? "Rejected" :
                info.submission.status == 5 ? "Payment Pending" :
                info.submission.status == 6 ? "Refunded" : ""
            cell.lbl_UnitNo.text = info.unit.unit
            cell.lbl_SubmittedDate.text = moving_dateStr
            cell.lbl_TenancyStart.text = moving_startStr
            cell.lbl_TenancyEnd.text = moving_endStr
            cell.lbl_SubmittedBy.text = info.submission.user.name
        }
        
        
        
        return cell
      
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 252
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        if formType == .moveInOut {
            
            let moveIODetailsTVC = self.parentVc.storyboard?.instantiateViewController(identifier: "MoveIODetailsTableViewController") as! MoveIODetailsTableViewController
            moveIODetailsTVC.moveInOutData = arr_MoveInOut[(sender! as UITapGestureRecognizer).view!.tag]
            self.parentVc.navigationController?.pushViewController(moveIODetailsTVC, animated: true)
           
        }
        else  if formType == .renovation {
            
            let renovationDetailsTVC = self.parentVc.storyboard?.instantiateViewController(identifier: "RenovationDetailsTableViewController") as! RenovationDetailsTableViewController
            renovationDetailsTVC.renovationData = arr_Renovation[(sender! as UITapGestureRecognizer).view!.tag]
            self.parentVc.navigationController?.pushViewController(renovationDetailsTVC, animated: true)
           
        }
        else  if formType == .doorAccess {
            
            let renovationDetailsTVC = self.parentVc.storyboard?.instantiateViewController(identifier: "DoorAccessDetailsTableViewController") as! DoorAccessDetailsTableViewController
            renovationDetailsTVC.doorAccessData = arr_DoorAccess[(sender! as UITapGestureRecognizer).view!.tag]
            self.parentVc.navigationController?.pushViewController(renovationDetailsTVC, animated: true)
           
        }
        else  if formType == .vehicleReg {
            
            let renovationDetailsTVC = self.parentVc.storyboard?.instantiateViewController(identifier: "VehicleRegDetailsTableViewController") as! VehicleRegDetailsTableViewController
            renovationDetailsTVC.vehicleRegData = arr_VehicleReg[(sender! as UITapGestureRecognizer).view!.tag]
            self.parentVc.navigationController?.pushViewController(renovationDetailsTVC, animated: true)
           
        }
        else  if formType == .updateAddress {
            
            let renovationDetailsTVC = self.parentVc.storyboard?.instantiateViewController(identifier: "UpdateAddressTableViewController") as! UpdateAddressTableViewController
            renovationDetailsTVC.updateAddressData = arr_UpdateAddress[(sender! as UITapGestureRecognizer).view!.tag]
            self.parentVc.navigationController?.pushViewController(renovationDetailsTVC, animated: true)
           
        }
        else  if formType == .updateParticulars {
            
            let renovationDetailsTVC = self.parentVc.storyboard?.instantiateViewController(identifier: "UpdateParticularsTableViewController") as! UpdateParticularsTableViewController
            renovationDetailsTVC.updateParticularsData = arr_UpdateParticulars[(sender! as UITapGestureRecognizer).view!.tag]
            self.parentVc.navigationController?.pushViewController(renovationDetailsTVC, animated: true)
           
        }
        
    }
    @IBAction func actionInspection(_ sender:UIButton){
        if formType == .moveInOut {
            
            let moveIODetailsTVC = self.parentVc.storyboard?.instantiateViewController(identifier: "MoveIOInspectionTableViewController") as! MoveIOInspectionTableViewController
            moveIODetailsTVC.moveInOutData = arr_MoveInOut[sender.tag]
            self.parentVc.navigationController?.pushViewController(moveIODetailsTVC, animated: true)
           
        }
        else  if formType == .renovation {
            
            let renovationDetailsTVC = self.parentVc.storyboard?.instantiateViewController(identifier: "RenovationDetailsTableViewController") as! RenovationDetailsTableViewController
            renovationDetailsTVC.renovationData = arr_Renovation[sender.tag]
            self.parentVc.navigationController?.pushViewController(renovationDetailsTVC, animated: true)
           
        }
       
    }
    @IBAction func actionPayment(_ sender:UIButton){
        if formType == .moveInOut {
            
            let moveIODetailsTVC = self.parentVc.storyboard?.instantiateViewController(identifier: "EFormPaymentTableViewController") as! EFormPaymentTableViewController
            moveIODetailsTVC.moveInOutData = arr_MoveInOut[sender.tag]
            self.parentVc.navigationController?.pushViewController(moveIODetailsTVC, animated: true)
           
        }
        else  if formType == .renovation {
            
            let renovationDetailsTVC = self.parentVc.storyboard?.instantiateViewController(identifier: "RenovationDetailsTableViewController") as! RenovationDetailsTableViewController
            renovationDetailsTVC.renovationData = arr_Renovation[sender.tag]
            self.parentVc.navigationController?.pushViewController(renovationDetailsTVC, animated: true)
           
        }
        else  if formType == .doorAccess {
            
            let renovationDetailsTVC = self.parentVc.storyboard?.instantiateViewController(identifier: "DoorAccessDetailsTableViewController") as! DoorAccessDetailsTableViewController
            renovationDetailsTVC.doorAccessData = arr_DoorAccess[sender.tag]
            self.parentVc.navigationController?.pushViewController(renovationDetailsTVC, animated: true)
           
        }
    }
    @IBAction func actionEdit(_ sender:UIButton){
        if formType == .moveInOut {
            
            let moveIODetailsTVC = self.parentVc.storyboard?.instantiateViewController(identifier: "MoveIODetailsTableViewController") as! MoveIODetailsTableViewController
            moveIODetailsTVC.moveInOutData = arr_MoveInOut[sender.tag]
            self.parentVc.navigationController?.pushViewController(moveIODetailsTVC, animated: true)
           
        }
        else  if formType == .renovation {
            
            let renovationDetailsTVC = self.parentVc.storyboard?.instantiateViewController(identifier: "RenovationDetailsTableViewController") as! RenovationDetailsTableViewController
            renovationDetailsTVC.renovationData = arr_Renovation[sender.tag]
            self.parentVc.navigationController?.pushViewController(renovationDetailsTVC, animated: true)
           
        }
        else  if formType == .doorAccess {
            
            let renovationDetailsTVC = self.parentVc.storyboard?.instantiateViewController(identifier: "DoorAccessDetailsTableViewController") as! DoorAccessDetailsTableViewController
            renovationDetailsTVC.doorAccessData = arr_DoorAccess[sender.tag]
            self.parentVc.navigationController?.pushViewController(renovationDetailsTVC, animated: true)
           
        }
        else  if formType == .vehicleReg {
            
            let renovationDetailsTVC = self.parentVc.storyboard?.instantiateViewController(identifier: "VehicleRegDetailsTableViewController") as! VehicleRegDetailsTableViewController
            renovationDetailsTVC.vehicleRegData = arr_VehicleReg[sender.tag]
            self.parentVc.navigationController?.pushViewController(renovationDetailsTVC, animated: true)
           
        }
        else  if formType == .updateAddress {
            
            let renovationDetailsTVC = self.parentVc.storyboard?.instantiateViewController(identifier: "UpdateAddressTableViewController") as! UpdateAddressTableViewController
            renovationDetailsTVC.updateAddressData = arr_UpdateAddress[sender.tag]
            self.parentVc.navigationController?.pushViewController(renovationDetailsTVC, animated: true)
           
        }
        else  if formType == .updateParticulars {
            
            let renovationDetailsTVC = self.parentVc.storyboard?.instantiateViewController(identifier: "UpdateParticularsTableViewController") as! UpdateParticularsTableViewController
            renovationDetailsTVC.updateParticularsData = arr_UpdateParticulars[sender.tag]
            self.parentVc.navigationController?.pushViewController(renovationDetailsTVC, animated: true)
           
        }
    }
}
extension EFormSummaryTableViewController: MenuViewDelegate{
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

   
   



extension EFormSummaryTableViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        txt_Status.text = ""
        
        txt_Unit.text = ""
        if textField == txt_Name{
            txt_Ticket.text = ""
        }
        else{
            txt_Name.text = ""
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
       
            self.searchEForms()
        
    }
}
