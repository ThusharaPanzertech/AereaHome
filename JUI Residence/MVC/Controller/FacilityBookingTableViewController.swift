//
//  FacilityBookingTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 28/07/21.
//

import UIKit
import DropDown
import CalendarDateRangePickerViewController
var selectedRowIndex_Facility = -1
class FacilityBookingTableViewController: BaseTableViewController {
    
    //Outlets
    @IBOutlet weak var view_SwitchProperty: UIView!
    @IBOutlet weak var lbl_SwitchProperty: UILabel!
    @IBOutlet weak var txt_Status: UITextField!
    @IBOutlet weak var txt_DateRange: UITextField!
    @IBOutlet weak var txt_Facility: UITextField!
    @IBOutlet weak var txt_Unit: UITextField!
    @IBOutlet weak var txt_FilterBy: UITextField!
    @IBOutlet weak var view_Footer: UIView!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var imgView_Profile: UIImageView!
    @IBOutlet var arr_Textfields: [UITextField]!
    @IBOutlet weak var btn_NewList: UIButton!
    let menu: MenuView = MenuView.getInstance
    @IBOutlet weak var table_FacilityList: UITableView!
    var dataSource = DataSource_FacilityList()
    var unitsData = [Unit]()
    var array_Facilities = [FacilityModal]()
    var startDate = ""
    var endDate = ""
    var facilityOptions = [String: String]()
    override func viewDidLoad() {
        super.viewDidLoad()
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
        table_FacilityList.dataSource = dataSource
        table_FacilityList.delegate = dataSource
        dataSource.parentVc = self
        dataSource.unitsData = self.unitsData
        setUpUI()
        getFacilityTypes()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedRowIndex_Facility = -1
        self.showBottomMenu()
        getFacilitySummary()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.closeMenu()
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return view_Footer
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 150

    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        if indexPath.row == 1{
            let ht = selectedRowIndex_Facility == -1  ?  (array_Facilities.count * 140) + 500 : ((array_Facilities.count - 1) * 140) + 205 + 500
            return CGFloat(ht)
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
            txtField.textColor = textColor
            txtField.attributedPlaceholder = NSAttributedString(string: txtField.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
        }
        btn_NewList.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
      
        btn_NewList.layer.cornerRadius = 10.0
    }
    //MARK: ******  PARSING *********
   
    func getFacilityTypes(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"        //
        ApiService.get_FacilityOptions(parameters: ["login_id":userId], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? FacilityOptionsBase){
                    self.facilityOptions = response.options
                   
                   
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
    func getFacilitySummary(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.get_facilitySummary(parameters: ["login_id":userId], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? FacilityModalBase){
                    self.array_Facilities = response.data
                    if(self.array_Facilities.count > 0){
                        self.array_Facilities = self.array_Facilities.sorted(by: { $0.submissions.created_at > $1.submissions.created_at })
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
    }
    func searchFacility(){
        let filterByDict = ["Earliest Date" : "created_at","Facility": "type_id","Status": "status"]
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
                    "status" : txt_Status.text == "Cancelled" ? "1" :
                        txt_Status.text == "Confirmed"  ? "2" :
                        txt_Status.text == "New"  ? "3" : "" ,
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
        }
        }
    //MARK: UIBUTTON ACTION
    @IBAction func actionSearch(_ sender:UIButton) {
        self.searchFacility()
    }
    @IBAction func actionClear(_ sender:UIButton) {
        self.txt_Facility.text = ""
        txt_Unit.text = ""
        txt_Status.text = ""
        txt_DateRange.text = ""
        txt_FilterBy.text = ""
        startDate = ""
        endDate = ""
        self.getFacilitySummary()
        
        
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
        @IBAction func actionNewDefects(_ sender: UIButton){
            let defectTVC = self.storyboard?.instantiateViewController(identifier: "NewDefectsTableViewController") as! NewDefectsTableViewController
            defectTVC.appointmentType = .facility
            defectTVC.unitsData = self.unitsData
            self.navigationController?.pushViewController(defectTVC, animated: true)
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
    @IBAction func actionFilterBy(_ sender:UIButton) {
       
        let dropDown_Filter = DropDown()
        dropDown_Filter.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Filter.dataSource = ["Earliest Date","Facility","Status"]// Array(unitsData.values)
        dropDown_Filter.show()
        dropDown_Filter.selectionAction = { [unowned self] (index: Int, item: String) in
            txt_FilterBy.text = item
           
            
        }
    }
    @IBAction func actionStatus(_ sender:UIButton) {
       
        let dropDown_Status = DropDown()
        dropDown_Status.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Status.dataSource = ["New", "Confirmed", "Cancelled"]// Array(unitsData.values)
        dropDown_Status.show()
        dropDown_Status.selectionAction = { [unowned self] (index: Int, item: String) in
           
            txt_Status.text = item
           
            
        }
    }
    @IBAction func actionFacility(_ sender:UIButton) {
        let sortedArray = facilityOptions.sorted { $0.value < $1.value }
        let arrfacilityOptions = sortedArray.map { $0.value }
        let dropDown_arrfacilityOptions = DropDown()
        dropDown_arrfacilityOptions.anchorView = sender // UIView or UIBarButtonItem
        dropDown_arrfacilityOptions.dataSource = arrfacilityOptions//Array(roles.values)
        dropDown_arrfacilityOptions.show()
        dropDown_arrfacilityOptions.selectionAction = { [unowned self] (index: Int, item: String) in
            txt_Facility.text = item
           
            
        }
    }
    @IBAction func actionDateRange(_ sender: UIButton){
        let dateRangePickerViewController = CalendarDateRangePickerViewController(collectionViewLayout: UICollectionViewFlowLayout())
          dateRangePickerViewController.delegate = self
          //dateRangePickerViewController.selectedStartDate = Date()
         // dateRangePickerViewController.selectedEndDate = Date()
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())  // 2022
        let firstDayOfYear = DateComponents(calendar: calendar, year: currentYear).date  // "Jan 1, 2022 at 12:00 AM"

       // let calendar: Calendar = Calendar.current
        let startDate = calendar.startOfYear(Date())

        let endDate = calendar.endOfYear(Date())
        
           let minimumDate = Calendar.current.date(byAdding: .year, value: -1, to: startDate )
        
           let maximumDate = Calendar.current.date(byAdding: .year, value: 1, to: endDate )
        
        
        dateRangePickerViewController.minimumDate = minimumDate
        dateRangePickerViewController.maximumDate = maximumDate
          let navigationController = UINavigationController(rootViewController: dateRangePickerViewController)
          self.navigationController?.present(navigationController, animated: true, completion: nil)
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
class DataSource_FacilityList: NSObject, UITableViewDataSource, UITableViewDelegate {
    var unitsData = [Unit]()
    var facilityOptions = [String: String]()
    var parentVc: UIViewController!
    var array_Facilities = [FacilityModal]()
func numberOfSectionsInTableView(tableView: UITableView) -> Int {

    return 1;
}

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  array_Facilities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "facilityCell") as! FacilityTableViewCell
            
        cell.selectionStyle = .none
        cell.btn_Edit.tag = indexPath.row
        cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
        cell.btn_Edit.addTarget(self, action: #selector(self.actionEdit(_:)), for: .touchUpInside)
        cell.view_Outer.tag = indexPath.row
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        cell.view_Outer.addGestureRecognizer(tap)
        if indexPath.row != selectedRowIndex_Facility{
            for vw in cell.arrViews{
                vw.isHidden = true
            }
        }
        else{
            for vw in cell.arrViews{
                vw.isHidden = false
            }
        }
        let facility = array_Facilities[indexPath.row]
        cell.lbl_Facility.text = facility.type?.facility_type
        if let unitId = unitsData.first(where: { $0.id == facility.user_info?.unit_no ?? 0 }) {
            cell.lbl_UnitNo.text = "#" + unitId.unit
        }
        else{
            cell.lbl_UnitNo.text = ""
        }
       // cell.lbl_UnitNo.text = unitsData["\(facility.user_info?.unit_no ?? 0)"]
        cell.lbl_BookingTime.text = facility.submissions.booking_time
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat =  "yyyy-MM-dd"
        let date = formatter.date(from: facility.submissions.booking_date)
        formatter.dateFormat = "dd/MM/yy"
        let dateStr = formatter.string(from: date ?? Date())
        cell.lbl_BookingDate.text = dateStr
        let fname = facility.user_info?.first_name ?? ""
        let lname = facility.user_info?.last_name ?? ""
        let name = "\(fname) \(lname)"
        cell.lbl_BookedBy.text = name
        cell.lbl_Status.text = facility.submissions.status == 0 ? "New" :
            facility.submissions.status == 1  ? "Cancelled" : facility.submissions.status == 2 ? "Confirmed" : ""
        cell.img_Arrow.image = indexPath.row == selectedRowIndex_Facility ? UIImage(named: "up_arrow") : UIImage(named: "down_arrow")
        return cell
      
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == selectedRowIndex_Facility ? 205 : 140
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        selectedRowIndex_Facility = (sender! as UITapGestureRecognizer).view!.tag
        DispatchQueue.main.async {
            (self.parentVc as! FacilityBookingTableViewController).tableView.reloadData()
        (self.parentVc as! FacilityBookingTableViewController).table_FacilityList.reloadData()
      
        }
       
       
    }
    @IBAction func actionEdit(_ sender:UIButton){
        let facility = array_Facilities[sender.tag]
        let editFacilityVC = self.parentVc.storyboard?.instantiateViewController(identifier: "EditFacilityTableViewController") as! EditFacilityTableViewController
        editFacilityVC.facility = facility
        self.parentVc.navigationController?.pushViewController(editFacilityVC, animated: true)
       
    }
}
extension FacilityBookingTableViewController: MenuViewDelegate{
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

   
extension FacilityBookingTableViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}





extension FacilityBookingTableViewController: CalendarDateRangePickerViewControllerDelegate{
    func didTapDoneWithDateRange(startDate: Date!, endDate: Date!) {
       
        
        self.startDate  = self.getDateString(date: startDate, format: "yyyy-MM-dd")
        self.endDate = self.getDateString(date: endDate, format: "yyyy-MM-dd")
        
        let fromDate = self.getDateString(date: startDate, format: "dd/MM/yy")
        let toDate = self.getDateString(date: endDate, format: "dd/MM/yy")
        self.txt_DateRange.text = "\(fromDate) - \(toDate)"
       
        self.navigationController?.dismiss(animated: true, completion: nil)
       
    }
    
    func didTapCancel() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    func getDateString(date: Date, format: String) -> String{
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
       
        formatter.dateFormat = format//"dd/MM/yy"
        let dateStr = formatter.string(from: date ?? Date())
        
       
        
        return dateStr
    }
}
extension Date {
    func year(using calendar: Calendar = .current) -> Int {
        calendar.component(.year, from: self)
    }
    func firstDayOfYear(using calendar: Calendar = .current) -> Date? {
        DateComponents(calendar: calendar, year: year(using: calendar)).date
    }
}
extension Calendar {
    
    func dayOfWeek(_ date: Date) -> Int {
        var dayOfWeek = self.component(.weekday, from: date) + 1 - self.firstWeekday
        
        if dayOfWeek <= 0 {
            dayOfWeek += 7
        }
        
        return dayOfWeek
    }
    
    func startOfWeek(_ date: Date) -> Date {
        return self.date(byAdding: DateComponents(day: -self.dayOfWeek(date) + 1), to: date)!
    }
    
    func endOfWeek(_ date: Date) -> Date {
        return self.date(byAdding: DateComponents(day: 6), to: self.startOfWeek(date))!
    }
    
    func startOfMonth(_ date: Date) -> Date {
        return self.date(from: self.dateComponents([.year, .month], from: date))!
    }
    
    func endOfMonth(_ date: Date) -> Date {
        return self.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth(date))!
    }
    func startOfYear(_ date: Date) -> Date {
        return self.date(from: self.dateComponents([.year], from: date))!
    }

    func endOfYear(_ date: Date) -> Date {
        return self.date(from: DateComponents(year: self.component(.year, from: date), month: 12, day: 31))!
    }
}
