//
//  FeedbackTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 30/07/21.
//

import UIKit
import CalendarDateRangePickerViewController
import DropDown
var selectedRowIndex_Feedback = -1
class FeedbackTableViewController: BaseTableViewController {
    
    //Outlets
    @IBOutlet weak var view_SwitchProperty: UIView!
    @IBOutlet weak var lbl_SwitchProperty: UILabel!
    @IBOutlet weak var txt_Category: UITextField!
    @IBOutlet weak var txt_DateRange: UITextField!
    @IBOutlet weak var txt_Ticket: UITextField!
    @IBOutlet weak var txt_FilterBy: UITextField!
    @IBOutlet weak var txt_Unit: UITextField!
    @IBOutlet weak var view_Footer: UIView!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var imgView_Profile: UIImageView!
    @IBOutlet var arr_Textfields: [UITextField]!
    @IBOutlet weak var btn_NewList: UIButton!
    let menu: MenuView = MenuView.getInstance
    @IBOutlet weak var table_FeedbackList: UITableView!
    var dataSource = DataSource_FeedbackList()
      
    var array_Feedbacks = [FeedbackModal]()
    var startDate = ""
    var endDate = ""
    var feedbackOptions = [FeedbackOption]()
    var unitsData = [Unit]()
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
        getFeedbackTypes()
        getUnitList()
          let fname = Users.currentUser?.moreInfo?.first_name ?? ""
        let lname = Users.currentUser?.moreInfo?.last_name ?? ""
        self.lbl_UserName.text = "\(fname) \(lname)"
        let role = Users.currentUser?.role
        self.lbl_UserRole.text = role
        table_FeedbackList.dataSource = dataSource
        table_FeedbackList.delegate = dataSource
        dataSource.parentVc = self
        setUpUI()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedRowIndex_Feedback = -1
        self.showBottomMenu()
        self.getFeedbackSummary()
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
            return CGFloat((195 * array_Feedbacks.count) + 400)
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
        btn_NewList.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
      
        btn_NewList.layer.cornerRadius = 10.0
    }
    //MARK: ******  PARSING *********
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
    func getFeedbackTypes(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"        //
        ApiService.get_FeedbackOptions(parameters: ["login_id":userId], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? FeedbackOptionsBase){
                    self.feedbackOptions = response.options
                   
                   
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
    func getFeedbackSummary(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.get_feedbackSummary(parameters: ["login_id":userId], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? FeedbackModalBase){
                    self.array_Feedbacks = response.data
                    if(self.array_Feedbacks.count > 0){
                        self.array_Feedbacks = self.array_Feedbacks.sorted(by: { $0.submissions.created_at > $1.submissions.created_at })
                    }
                    self.dataSource.array_Feedbacks = self.array_Feedbacks
                    if self.array_Feedbacks.count == 0{

                    }
                    else{
                       // self.view_NoRecords.removeFromSuperview()
                    }
                    self.table_FeedbackList.reloadData()
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
    func searchFeedbacks(){
        let filterByDict = ["Earliest Date" : "created_at","Category": "fb_option","Status": "status"]
        let filter = filterByDict[txt_FilterBy.text!] ?? "created_at"
        if txt_Category.text == "" && txt_Unit.text == "" && txt_DateRange.text == "" && txt_Ticket.text == "" && txt_FilterBy.text == ""{
                self.getFeedbackSummary()
            }
            else{
            var fb_Id = ""
           // var unit_Id = ""
            if let fbId = feedbackOptions.first(where: { $0.feedback_option == txt_Category.text })?.id {
                fb_Id = "\(fbId)"
            }
            if let unitId = unitsData.first(where: { $0.unit == txt_Unit.text }) {
           //     unit_Id = unitId
            }
                
            ActivityIndicatorView.show("Loading")
            let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
            var param = [String : Any]()
           
                param = [
                    "login_id" : userId,
                    "ticket" : txt_Ticket.text!,
                    "filter" : filter,
                    "category" : fb_Id,
                    "unit" : txt_Unit.text!,
                    "fromdate" : self.startDate,
                    "todate" : self.endDate,
                    
                ] as [String : Any]
            
           
            
               
                ApiService.search_feedback(parameters: param, completion: { status, result, error in
                   
                    ActivityIndicatorView.hiding()
                    if status  && result != nil{
                         if let response = (result as? FeedbackModalBase){
                            self.array_Feedbacks = response.data
                            if(self.array_Feedbacks.count > 0){
                               // self.array_Feedbacks = self.array_Feedbacks.sorted(by: { $0.submissions.created_at > $1.submissions.created_at })
                            }
                            self.dataSource.array_Feedbacks = self.array_Feedbacks
                            if self.array_Feedbacks.count == 0{

                            }
                            else{
                               // self.view_NoRecords.removeFromSuperview()
                            }
                            self.table_FeedbackList.reloadData()
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
        self.searchFeedbacks()
    }
    @IBAction func actionClear(_ sender:UIButton) {
        self.txt_Category.text = ""
        txt_DateRange.text = ""
        txt_Ticket.text = ""
        txt_Unit.text = ""
        txt_FilterBy.text = ""
         startDate = ""
         endDate = ""
        self.getFeedbackSummary()
        
        
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
    @IBAction func actionUnit(_ sender:UIButton) {
       // let sortedArray = unitsData.sorted(by:  { $0.1 < $1.1 })
        let arrUnit = unitsData.map { $0.unit }
        let dropDown_Unit = DropDown()
        dropDown_Unit.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Unit.dataSource = arrUnit// Array(unitsData.values)
        dropDown_Unit.show()
        dropDown_Unit.selectionAction = { [unowned self] (index: Int, item: String) in
            
            txt_Unit.text = item
            
            
        }
    }
        @IBAction func actionNewDefects(_ sender: UIButton){
            let defectTVC = self.storyboard?.instantiateViewController(identifier: "NewDefectsTableViewController") as! NewDefectsTableViewController
            defectTVC.appointmentType = .feedback
            defectTVC.unitsData = self.unitsData
            self.navigationController?.pushViewController(defectTVC, animated: true)
        }
    @IBAction func actionFilterBy(_ sender:UIButton) {
       
        let dropDown_Filter = DropDown()
        dropDown_Filter.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Filter.dataSource = ["Earliest Date","Category","Status"]// Array(unitsData.values)
        dropDown_Filter.show()
        dropDown_Filter.selectionAction = { [unowned self] (index: Int, item: String) in
            txt_FilterBy.text = item
           
            
        }
    }
    @IBAction func actionCategory(_ sender:UIButton) {
       // let sortedArray = feedbackOptions.sorted { $0.key < $1.key }
        let arrfeedbackOptions = feedbackOptions.map { $0.feedback_option }
        let dropDown_feedbackOptions = DropDown()
        dropDown_feedbackOptions.anchorView = sender // UIView or UIBarButtonItem
        dropDown_feedbackOptions.dataSource = arrfeedbackOptions//Array(roles.values)
        dropDown_feedbackOptions.show()
        dropDown_feedbackOptions.selectionAction = { [unowned self] (index: Int, item: String) in
            txt_Category.text = item
           
            
        }
    }
    @IBAction func actionDateRange(_ sender: UIButton){
        let dateRangePickerViewController = CalendarDateRangePickerViewController(collectionViewLayout: UICollectionViewFlowLayout())
          dateRangePickerViewController.delegate = self
          //dateRangePickerViewController.selectedStartDate = Date()
         // dateRangePickerViewController.selectedEndDate = Date()
          
//           let minimumDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())
//        
//           let maximumDate = Calendar.current.date(byAdding: .year, value: 1, to: Date())
//        
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
class DataSource_FeedbackList: NSObject, UITableViewDataSource, UITableViewDelegate {
    var feedbackOptions = [String: String]()
    var unitsData = [Unit]()
    var parentVc: UIViewController!
    var array_Feedbacks = [FeedbackModal]()
func numberOfSectionsInTableView(tableView: UITableView) -> Int {

    return 1;
}

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  array_Feedbacks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "feedbackCell") as! FeedbackTableViewCell
        let feedback = array_Feedbacks[indexPath.row]
        
        cell.lbl_TicketNo.text = feedback.submissions.ticket
        cell.lbl_Status.text = feedback.submissions.status == 0 ? "Open" :
            feedback.submissions.status == 1 ? "Closed" : "In Progress"
        cell.lbl_SubmittedBy.text = feedback.user_info?.name
        if let unitId = unitsData.first(where: { $0.id == feedback.user_info?.unit_no }) {
            cell.lbl_UnitNo.text = "#" + unitId.unit
        }
        else{
        cell.lbl_UnitNo.text = ""
        }
        //unitsData["\(feedback.user_info?.unit_no ?? 0)"]
        cell.lbl_Category.text = feedback.option?.feedback_option
        cell.selectionStyle = .none
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat =  "yyyy-MM-dd HH:mm:ss"
        let date = formatter.date(from: feedback.submissions.created_at)
        let dateUpdated = formatter.date(from: feedback.submissions.updated_at)
        formatter.dateFormat = "dd/MM/yy"
        let dateStr = formatter.string(from: date ?? Date())
        
        
        let dateStrUpdated = formatter.string(from: dateUpdated ?? Date())
       
        cell.lbl_SubmittedDate.text = dateStr
        
        cell.img_Arrow.image = indexPath.row == selectedRowIndex_Feedback ? UIImage(named: "up_arrow") : UIImage(named: "down_arrow")
        cell.lbl_UpdatedOn.text =  dateStrUpdated
        cell.btn_Edit.tag = indexPath.row
           
        cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
        cell.btn_Edit.addTarget(self, action: #selector(self.actionEdit(_:)), for: .touchUpInside)
        cell.view_Outer.tag = indexPath.row
       
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        cell.view_Outer.addGestureRecognizer(tap)
        if indexPath.row != selectedRowIndex_Feedback{
            for vw in cell.arrViews{
                vw.isHidden = true
            }
        }
        else{
            for vw in cell.arrViews{
                vw.isHidden = false
            }
        }
        
        return cell
      
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == selectedRowIndex_Feedback ? 250 : 145
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        selectedRowIndex_Feedback = (sender! as UITapGestureRecognizer).view!.tag
        DispatchQueue.main.async {
            (self.parentVc as! FeedbackTableViewController).tableView.reloadData()
        (self.parentVc as! FeedbackTableViewController).table_FeedbackList.reloadData()
      
        }
       
       
    }
    @IBAction func actionEdit(_ sender:UIButton){
        let feedback = array_Feedbacks[sender.tag]
        let feedbackDetailsVC = self.parentVc.storyboard?.instantiateViewController(identifier: "FeedbackDetailsTableViewController") as! FeedbackDetailsTableViewController
        feedbackDetailsVC.feedback = feedback
        feedbackDetailsVC.unitsData = unitsData
        self.parentVc.navigationController?.pushViewController(feedbackDetailsVC, animated: true)
       
    }
}
extension FeedbackTableViewController: MenuViewDelegate{
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

   
   




extension FeedbackTableViewController: CalendarDateRangePickerViewControllerDelegate{
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
extension FeedbackTableViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
       
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
       
           
        
    }
   
}
