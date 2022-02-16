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
    var feedbackOptions = [String: String]()
    var unitsData = [String: String]()
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
        getFeedbackTypes()
        getUnitList()
        let fname = Users.currentUser?.user?.name ?? ""
        let lname = Users.currentUser?.moreInfo?.last_name ?? ""
        self.lbl_UserName.text = "\(fname) \(lname)"
        let role = Users.currentUser?.role?.name ?? ""
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
            if txt_Category.text == "" && txt_Unit.text == "" && txt_DateRange.text == "" && txt_Ticket.text == "" {
                self.getFeedbackSummary()
            }
            else{
            var fb_Id = ""
           // var unit_Id = ""
            if let fbId = feedbackOptions.first(where: { $0.value == txt_Category.text })?.key {
                fb_Id = fbId
            }
            if let unitId = unitsData.first(where: { $0.value == txt_Unit.text })?.key {
           //     unit_Id = unitId
            }
                
            ActivityIndicatorView.show("Loading")
            let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
            var param = [String : Any]()
            if txt_Category.text != ""{
                param = [
                    "login_id" : userId,
                    "option": "category",
                    "filter" : filter,
                    "category" : fb_Id
                    
                ] as [String : Any]
            }
            else if txt_Ticket.text != ""{
                param = [
                    "login_id" : userId,
                    "option": "ticket",
                    "filter" : filter,
                    "ticket" : txt_Ticket.text!
                    
                ] as [String : Any]
            }
            else if txt_Unit.text != ""{
                param = [
                    "login_id" : userId,
                    "option": "unit",
                    "filter" : filter,
                    "unit" : txt_Unit.text!
                    
                ] as [String : Any]
            }
            else if txt_DateRange.text != ""{
                param = [
                    "login_id" : userId,
                    "option": "date",
                    "fromdate" : self.startDate,
                    "todate" : self.endDate,
                    "filter" : filter,
                    
                ] as [String : Any]
            }
            
            
                ApiService.search_feedback(parameters: param, completion: { status, result, error in
                   
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
            txt_Category.text = ""
            txt_DateRange.text = ""
            txt_Ticket.text = ""
            txt_Unit.text = item
            self.searchFeedbacks()
            
        }
    }
        @IBAction func actionNewDefects(_ sender: UIButton){
            let defectTVC = self.storyboard?.instantiateViewController(identifier: "NewDefectsTableViewController") as! NewDefectsTableViewController
            defectTVC.appointmentType = .feedback
            self.navigationController?.pushViewController(defectTVC, animated: true)
        }
    @IBAction func actionFilterBy(_ sender:UIButton) {
       
        let dropDown_Filter = DropDown()
        dropDown_Filter.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Filter.dataSource = ["Earliest Date","Category","Status"]// Array(unitsData.values)
        dropDown_Filter.show()
        dropDown_Filter.selectionAction = { [unowned self] (index: Int, item: String) in
            txt_FilterBy.text = item
            self.searchFeedbacks()
            
        }
    }
    @IBAction func actionCategory(_ sender:UIButton) {
        let sortedArray = feedbackOptions.sorted { $0.key < $1.key }
        let arrfeedbackOptions = sortedArray.map { $0.value }
        let dropDown_feedbackOptions = DropDown()
        dropDown_feedbackOptions.anchorView = sender // UIView or UIBarButtonItem
        dropDown_feedbackOptions.dataSource = arrfeedbackOptions//Array(roles.values)
        dropDown_feedbackOptions.show()
        dropDown_feedbackOptions.selectionAction = { [unowned self] (index: Int, item: String) in
            txt_Category.text = item
            txt_DateRange.text = ""
            txt_Ticket.text = ""
            txt_Unit.text = ""
            self.searchFeedbacks()
            
        }
    }
    @IBAction func actionDateRange(_ sender: UIButton){
        let dateRangePickerViewController = CalendarDateRangePickerViewController(collectionViewLayout: UICollectionViewFlowLayout())
          dateRangePickerViewController.delegate = self
          //dateRangePickerViewController.selectedStartDate = Date()
         // dateRangePickerViewController.selectedEndDate = Date()
          
           let minimumDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())
        
           let maximumDate = Calendar.current.date(byAdding: .year, value: 1, to: Date())
        
        
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
class DataSource_FeedbackList: NSObject, UITableViewDataSource, UITableViewDelegate {
    var feedbackOptions = [String: String]()
    var unitsData = [String: String]()
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
        cell.lbl_UnitNo.text = unitsData["\(feedback.user_info?.unit_no ?? 0)"]
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

   
   




extension FeedbackTableViewController: CalendarDateRangePickerViewControllerDelegate{
    func didTapDoneWithDateRange(startDate: Date!, endDate: Date!) {
       
        
        self.startDate  = self.getDateString(date: startDate, format: "yyyy-MM-dd")
        self.endDate = self.getDateString(date: endDate, format: "yyyy-MM-dd")
        
        let fromDate = self.getDateString(date: startDate, format: "dd/MM/yy")
        let toDate = self.getDateString(date: endDate, format: "dd/MM/yy")
        self.txt_DateRange.text = "\(fromDate) - \(toDate)"
        txt_Unit.text = ""
        txt_Ticket.text = ""
        txt_Category.text = ""
        self.searchFeedbacks()
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
        if textField == txt_Ticket{
            txt_Unit.text = ""
        }
        else if textField == txt_Unit{
            txt_Ticket.text = ""
        }
        self.searchFeedbacks()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        txt_Category.text = ""
        txt_DateRange.text = ""
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
       
            self.searchFeedbacks()
        
    }
   
}
