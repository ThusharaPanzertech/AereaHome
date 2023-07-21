//
//  VisitorDetaisTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 06/03/23.
//

import UIKit
import DropDown

var array_VehicleNo = [String]()
var array_Entering = [Int]()
class VisitorDetaisTableViewController: BaseTableViewController {
    
    
    let alertView: AlertView = AlertView.getInstance
    let alertView_message: MessageAlertView = MessageAlertView.getInstance
    //Outlets
    @IBOutlet weak var view_SwitchProperty: UIView!
    @IBOutlet weak var lbl_SwitchProperty: UILabel!
    

    @IBOutlet weak var lbl_BookingId: UILabel!
    @IBOutlet weak var lbl_UnitNo: UILabel!
    @IBOutlet weak var lbl_VisitDate: UILabel!
    @IBOutlet weak var lbl_InvitedBy: UILabel!
    @IBOutlet weak var lbl_Purpose: UILabel!
    @IBOutlet weak var lbl_Property: UILabel!

    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var imgView_Profile: UIImageView!
    let menu: MenuView = MenuView.getInstance
    @IBOutlet weak var table_VisitorList: UITableView!
    var dataSource = DataSource_VisitorDetailsList()
    var unitsData = [Unit]()
    var visitor : VisitorSummary!
    var visitorInfo : VisitorDetailsBase!
    var isToDelete = false
    var arr_VisitingPurpose = [String: String]()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        array_VehicleNo = [String]()
        array_Entering = [Int]()
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
       
       // getVisitorInfo()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedRowIndex_Visitor = -1
        self.showBottomMenu()
        getVisitorInfo()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.closeMenu()
    }
   
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if visitorInfo != nil{
            if indexPath.row == 1{
                var ht =  visitorInfo.status == 0 ? 380 : 450
                
                
                ht = (visitorInfo.visitors.count * ht) + 650
                return CGFloat(ht)
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
       
     
    }
    func setData(){
        lbl_BookingId.text = self.visitorInfo.ticket
        lbl_UnitNo.text = "#" + self.visitor.unit
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        let visit_date = formatter.date(from: visitorInfo.visiting_date)
       
       
        formatter.dateFormat = "dd/MM/yy"
        let visit_dateStr = formatter.string(from: visit_date ?? Date())

        lbl_VisitDate.text = visit_dateStr
        lbl_InvitedBy.text = self.visitor.invited_by
        lbl_Purpose.text = self.visitor.purpose
        lbl_Property.text = kCurrentPropertyName
    }



    //MARK: ******  PARSING *********
   
   
    func getVisitorInfo(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        array_VehicleNo.removeAll()
        array_Entering.removeAll()
        let id = self.visitor == nil ? self.visitorInfo.id : self.visitor.id
        ApiService.get_VisitorInfo(parameters: ["login_id":userId, "id" :id], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? VisitorInfoModalBase){
                    self.visitorInfo = response.details
                     self.arr_VisitingPurpose = response.purposes
                     self.dataSource.visitorInfo = self.visitorInfo
                     self.dataSource.arr_VisitingPurpose = self.arr_VisitingPurpose
                     for obj in self.visitorInfo.visitors{
                         array_Entering.append(obj.entry_date == "" ? 0 : 1)
                         array_VehicleNo.append(obj.vehicle_no)
                     }
                     DispatchQueue.main.async {
                         self.setData()
                         self.table_VisitorList.reloadData()
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
    func deleteVisitorBooking(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        let params = NSMutableDictionary()
        params.setValue("\(userId)", forKey: "login_id")
        params.setValue("\(visitor.id)", forKey: "id")
       
       
        ApiService.delete_visitorBooking(parameters:params as! [String : Any], completion: { status, result, error in
            self.isToDelete  = false
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                if let response = (result as? DeleteUserBase){
                   if response.response == 1{
                       DispatchQueue.main.async {
                           self.alertView_message.delegate = self
                           self.alertView_message.showInView(self.view_Background, title: "Visitor Booking has\n been deleted", okTitle: "Home", cancelTitle: "View Visitor Bookings")
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
    func updateVisitorBooking(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        let params = NSMutableDictionary()
        params.setValue("\(userId)", forKey: "login_id")
        params.setValue("\(visitor.id)", forKey: "id")
        var ids = [String]()
        for (indx,data) in self.visitorInfo.visitors.enumerated(){
            let veh = array_VehicleNo[indx]
            params.setValue("\(veh)", forKey: "vehicle_no_\(data.id)")
         //   params.setValue("\(visitor.id)", forKey: "id_number_\(data.id)")
            
            ids.append("\(data.id)")
//            params.setValue("\(data.id)", forKey: "visitor_ids[]")
        }
        params.setValue(ids, forKey: "visitor_ids")
        
//        params.setValue("267", forKey: "visitor_ids[]")
//        params.setValue("268", forKey: "visitor_ids[]")
//        params.setValue("269", forKey: "visitor_ids[]")

       
       
        ApiService.update_visitorBooking(parameters:params as! [String : Any], completion: { status, result, error in
            
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                if let response = (result as? UpdateVisitorBase){
                   if response.response == 1{
                       DispatchQueue.main.async {
                           self.alertView_message.delegate = self
                           self.alertView_message.showInView(self.view_Background, title: "Visitor Management changes has been saved", okTitle: "Home", cancelTitle: "View Visitor Bookings")
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
    func searchFacility(){
 /*       let filterByDict = ["Earliest Date" : "created_at","Facility": "type_id","Status": "status"]
        let filter = filterByDict[txt_FilterBy.text!] ?? "created_at"
       
        if txt_Facility.text == "" && txt_Unit.text == "" && txt_DateRange.text == "" && txt_Status.text == "" && txt_FilterBy.text == ""{
                self.getFacilitySummary()
            }
            else{
            var fc_Id = ""
            if let fcId = facilityOptions.first(where: { $0.value == txt_Facility.text })?.key {
                fc_Id = fcId
            }
          
                
            ActivityIndicatorView.show("Loading")
            let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
            var param = [String : Any]()
           
                param = [
                    "login_id" : userId,
                    "status" : txt_Status.text == "Cancelled" ? 1 :
                        txt_Status.text == "Confirmed"  ? 2 : 3,
                    "filter" : filter,
                    "category" : fc_Id,
                    "unit" : txt_Unit.text!,
                    "fromdate" : self.startDate,
                    "todate" : self.endDate,
                    
                ] as [String : Any]
           
           
            
                ApiService.search_facility(parameters: param, completion: { status, result, error in
                   
                    ActivityIndicatorView.hiding()
                    if status  && result != nil{
                         if let response = (result as? FacilityModalBase){
                            self.array_Facilities = response.data
                            if(self.array_Facilities.count > 0){
//                                self.array_Facilities = self.array_Facilities.sorted(by: { $0.submissions.created_at > $1.submissions.created_at })
                            }
                            self.dataSource.array_Facilities = self.array_Facilities
                            if self.array_Facilities.count == 0{

                            }
                            else{
                               // self.view_NoRecords.removeFromSuperview()
                            }
                            self.table_FacilityList.reloadData()
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
        }*/
        }
    func showDeleteAlert(){
        isToDelete = true
        alertView.delegate = self
        alertView.showInView(self.view_Background, title: "Are you sure you want to\n delete the following\n visitor booking?", okTitle: "Yes", cancelTitle: "Back")
      
    }
    //MARK: UIBUTTON ACTION
    @IBAction func actionSave(_ sender: UIButton){
        var flag = false
        for i in 0..<visitorInfo.visitors.count{
           let obj = array_VehicleNo[i]
            if obj == ""{
                flag = true
                break
            }
        }
        if flag == true{
            self.displayErrorAlert(alertStr: "Please enter vehicle number", title: "")
        }
        else{
            self.updateVisitorBooking()
        }
       
        
    }
    @IBAction func actionDelete(_ sender: UIButton){
        showDeleteAlert()
        
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
            let defectTVC = self.storyboard?.instantiateViewController(identifier: "NewDefectsTableViewController") as! NewDefectsTableViewController
            defectTVC.appointmentType = .facility
            defectTVC.unitsData = self.unitsData
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
class DataSource_VisitorDetailsList: NSObject, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    var unitsData = [Unit]()
    var parentVc: UIViewController!
    var visitorInfo : VisitorDetailsBase!
    
    var arr_VisitingPurpose = [String: String]()
func numberOfSectionsInTableView(tableView: UITableView) -> Int {

    return 1;
}

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return  visitorInfo == nil ? 0 :visitorInfo.visitors.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let visitor = visitorInfo.visitors[indexPath.row]
        let cell: VisitorInfoTableViewCell!
        if visitorInfo.status == 0{
            cell = (tableView.dequeueReusableCell(withIdentifier: "vistorCell") as? VisitorInfoTableViewCell)
        }
        else{
            cell = tableView.dequeueReusableCell(withIdentifier: "enteredvistorCell") as? VisitorInfoTableViewCell
        }
        cell.selectionStyle = .none
        cell.btn_Checkbox.tag = indexPath.row
        cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
        cell.btn_Checkbox.addTarget(self, action: #selector(self.actionEnteringPremise(_:)), for: .touchUpInside)
        cell.view_Outer.tag = indexPath.row
        
        cell.lbl_VehicleNo.tag = indexPath.row
        cell.lbl_VehicleNo.delegate = self
        cell.lbl_VehicleNo.addTarget(self, action: #selector(valueChanged), for: .editingChanged)
        cell.lbl_VisitorTitle.text = "Visitor \(indexPath.row + 1) Details"
        
        cell.lbl_Name.text = visitor.name
        
        cell.lbl_Mobile.text =  visitor.mobile
        cell.lbl_Email.text =  visitor.email
        cell.lbl_VehicleNo.text = array_VehicleNo[indexPath.row]
        cell.btn_Checkbox.isSelected = array_Entering[indexPath.row] == 1
        if visitorInfo.status == 2{
            
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let visit_date = formatter.date(from: visitor.entry_date)
           
           
            formatter.dateFormat = "dd/MM/yy"
            let visit_dateStr = formatter.string(from: visit_date ?? Date())
            
            
            
            cell.lbl_EntryDate.text = visit_dateStr
            
            formatter.dateFormat = "hh:mm a"
            let visit_timeStr = formatter.string(from: visit_date ?? Date())
            
            cell.lbl_EntryTime.text = visit_timeStr
        }
        
      
        return cell
      
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let visitor = visitorInfo.visitors[indexPath.row]
        
        return visitorInfo.status == 0 ? 380 : 450
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
    @objc func valueChanged(_ textField: UITextField){
        var vehno = array_VehicleNo[textField.tag]
        vehno = textField.text!
        array_VehicleNo[textField.tag] = vehno
        
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
        (self.parentVc as! VisitorDetaisTableViewController).table_VisitorList.reloadData()
    }
}
extension VisitorDetaisTableViewController: MenuViewDelegate{
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

   
extension VisitorDetaisTableViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}






extension VisitorDetaisTableViewController: AlertViewDelegate{
    func onBackClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func onCloseClicked() {
        
    }
    
    func onOkClicked() {
        if isToDelete == true{
            deleteVisitorBooking()
        }
    }
    
    
}
extension VisitorDetaisTableViewController: MessageAlertViewDelegate{
    func onHomeClicked() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func onListClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

