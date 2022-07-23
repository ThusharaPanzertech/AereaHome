//
//  NewDefectsTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 26/12/21.
//

import UIKit
enum AppointmentType{
    case feedback
    case facility
    case defect
}
class NewDefectsTableViewController: BaseTableViewController {

    //Outlets
    var array_Facilities = [FacilityModal]()
    var array_Feedbacks = [FeedbackModal]()
    var feedbackOptions = [String: String]()
    var unitsData = [Unit]()
    var facilityOptions = [String: String]()
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var imgView_Profile: UIImageView!
    @IBOutlet weak var table_DefectsList: UITableView!
    @IBOutlet weak var view_CancelInvitation: UIView!
    @IBOutlet weak var view_CancelContent: UIView!
    @IBOutlet weak var txt_Reason: UITextView!
    var dataSource = DataSource_NewDefectsList()
    let alertView: AlertView = AlertView.getInstance
    let alertView_message: MessageAlertView = MessageAlertView.getInstance
    let menu: MenuView = MenuView.getInstance
    var facilityId = 0
    var appointmentType: AppointmentType!
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
        table_DefectsList.dataSource = dataSource
        table_DefectsList.delegate = dataSource
        dataSource.parentVc = self
        dataSource.appointmentType = self.appointmentType
        dataSource.unitsData = self.unitsData
        setUpUI()
        if appointmentType == .feedback{
            getNewFeedbacks()
        }
        else  if appointmentType == .facility{
            getNewFacilityBookings()
        }
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showBottomMenu()
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
    func setUpUI(){
       
        lbl_Title.text = self.appointmentType == .defect ? "Defect List" :
            self.appointmentType == .facility ? "Facilities" :
            "Feedbacks"
        
        view_Background.layer.cornerRadius = 25.0
        view_Background.layer.masksToBounds = true
      
        imgView_Profile.addborder()
       

        txt_Reason.layer.borderWidth = 1.0
        txt_Reason.layer.borderColor = UIColor.lightGray.cgColor
        txt_Reason.layer.masksToBounds = true
        txt_Reason.layer.cornerRadius = 3.0
        let toolbarDone = UIToolbar.init()
        toolbarDone.sizeToFit()
        let barBtnDone = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done,
                                              target: self, action: #selector(doneButtonAction))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbarDone.items = [spaceButton, barBtnDone] // You can even add cancel button too
        txt_Reason.inputAccessoryView = toolbarDone
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.doneButtonAction))
        view_CancelInvitation.addGestureRecognizer(tap)
        txt_Reason.backgroundColor = .white
    }
    //MARK: ********   PARSING ********
    func getFeedbackDetail(id: Int){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        ApiService.get_FeedbackDetail(parameters: ["login_id":userId ?? "0", "id": id], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                if let response = (result as? FeedbackDetailBase){
                    let feedback = response.feedback
                    let feedbackDetailsVC = self.storyboard?.instantiateViewController(identifier: "FeedbackDetailsTableViewController") as! FeedbackDetailsTableViewController
                    feedbackDetailsVC.feedback = feedback
                    feedbackDetailsVC.unitsData = self.unitsData
                    self.navigationController?.pushViewController(feedbackDetailsVC, animated: true)
                }
        }
            else if error != nil{
              //  self.displayErrorAlert(alertStr: "\(error!.localizedDescription)", title: "Oops")
            }
            else{
              //  self.displayErrorAlert(alertStr: "Something went wrong.Please try again", title: "Oops")
            }
        })
    }
    func getNewFeedbacks(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.get_newFeedbacks(parameters: ["login_id":userId], completion: { status, result, error in
           
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
                    self.table_DefectsList.reloadData()
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
    func getNewFacilityBookings(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.get_newFacilityBookings(parameters: ["login_id":userId], completion: { status, result, error in
           
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
                    self.table_DefectsList.reloadData()
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
    func approve_decline_Facility(isToApprove:Bool){
       
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
     
        let param = [
            "login_id" : userId,
            "id" : facilityId,
            "reason": isToApprove ? "" : txt_Reason.text!
        ] as [String : Any]

        ApiService.approve_decline_Facility(isToApprove : isToApprove ,parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? DeleteUserBase){
                    if response.response == 1{
                        DispatchQueue.main.async {
                            let msg = isToApprove ? "Facility booking has\n been confirmed" : "Facility booking has\n been cancelled"
                            self.alertView_message.delegate = self
                            self.alertView_message.showInView(self.view_Background, title: msg, okTitle: "Home", cancelTitle: "View Facility Bookings")
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
    
    //MARK: UIButton Action
    @IBAction func actionApprove(_ sender: UIButton){
        self.approve_decline_Facility(isToApprove: true)
//        let title = self.appointmentType == .defect ? "Defect List" : "Facility booking"
//        alertView_message.delegate = self
//        alertView_message.showInView(self.view, title: "\(title) has been\n approved", okTitle: "Home", cancelTitle: "View \(title)")
    }
    @IBAction func actionDecline(_ sender: UIButton){
        self.approve_decline_Facility(isToApprove: false)
//        let title = self.appointmentType == .defect ? "Defect List" : "Facility booking"
//        alertView.delegate = self
//        alertView.showInView(self.view_Background, title: "Are you sure you want to\n decline the following key\n \(title)?", okTitle: "Yes", cancelTitle: "Back")
    }
    @IBAction func actionRead(_ sender: UIButton){
        alertView_message.delegate = self
        alertView_message.showInView(self.view, title: "Feedback has\n been read", okTitle: "Home", cancelTitle: "View Feedbacks")
    }
    @IBAction func actionHold(_ sender: UIButton){
        alertView_message.delegate = self
        alertView_message.showInView(self.view, title: "Feedback holded", okTitle: "Home", cancelTitle: "View Feedbacks")
//        alertView.delegate = self
//        alertView.showInView(self.view_Background, title: "Are you sure you want to\n decline the following key\n defect list?", okTitle: "Yes", cancelTitle: "Back")
    }
    @IBAction func actionApproveFacility(_ sender: UIButton){
        alertView_message.delegate = self
        alertView_message.showInView(self.view, title: "Facility Booking has\nbeen approved", okTitle: "Home", cancelTitle: "View Facility Bookings")
    }
    @IBAction func actionDeclineFacility(_ sender: UIButton){
        alertView.delegate = self
        alertView.showInView(self.view_Background, title: "Are you sure you want to\n decline the following\n facility booking?", okTitle: "Yes", cancelTitle: "Back")
    }
    func showCancelAlert(){
        txt_Reason.text = ""
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .transitionCrossDissolve, animations: { [self] in
        }, completion: { [self] finished in
            self.view.addSubview(self.view_CancelInvitation)
            self.view_CancelInvitation.frame = self.view.bounds
            self.tableView.isScrollEnabled = false
        
        })
            
    }
    @IBAction func actionCancel(_ sender: UIButton){
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .transitionCrossDissolve, animations: { [self] in
        }, completion: { [self] finished in
           
            self.view_CancelInvitation.removeFromSuperview()
            self.tableView.isScrollEnabled = true
        })
    }
    @IBAction func actionDeclineFacilityRequest(_ sender: UIButton){
        if txt_Reason.text.isEmpty {
            displayErrorAlert(alertStr: "Please enter reason", title: "")
        }
        else {
            let stripped = txt_Reason.text.trimmingCharacters(in: .whitespacesAndNewlines)
            if stripped.isEmpty{
                displayErrorAlert(alertStr: "Please enter a valid reason", title: "")
            }
            else{
                approve_decline_Facility(isToApprove: false)
            }
        }
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


class DataSource_NewDefectsList: NSObject, UITableViewDataSource, UITableViewDelegate {
    var array_Feedbacks = [FeedbackModal]()
    var array_Facilities = [FacilityModal]()
    var feedbackOptions = [String: String]()
    var facilityOptions = [String: String]()
    var unitsData = [Unit]()
    var parentVc: UIViewController!
    var appointmentType: AppointmentType!
func numberOfSectionsInTableView(tableView: UITableView) -> Int {

    return 1;
}

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  appointmentType == .feedback ? array_Feedbacks.count :
            appointmentType == .facility ? array_Facilities.count : 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if appointmentType == .defect{
            let cell = tableView.dequeueReusableCell(withIdentifier: "defectsListCell") as! DefectsListTableViewCell
            
           
        cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
        cell.btn_Approve.addTarget(self, action: #selector(self.approve(_:)), for: .touchUpInside)
        cell.btn_Decline.addTarget(self, action: #selector(self.decline(_:)), for: .touchUpInside)
        return cell
        }
        else  if appointmentType == .facility{
            let cell = tableView.dequeueReusableCell(withIdentifier: "facilityCell") as! FacilityTableViewCell
            
            
            
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
            cell.lbl_BookedBy.text = facility.user_info?.name
            cell.lbl_Status.text = facility.submissions.status == 0 ? "New" :
                facility.submissions.status == 1  ? "Cancelled" : facility.submissions.status == 2 ? "Confirmed" : ""
            
           
        cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
        cell.btn_Approve.addTarget(self, action: #selector(self.approve(_:)), for: .touchUpInside)
        cell.btn_Decline.addTarget(self, action: #selector(self.decline(_:)), for: .touchUpInside)
        return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "feedbackCell") as! FeedbackTableViewCell
            
            let feedback = array_Feedbacks[indexPath.row]
            
            cell.lbl_TicketNo.text = feedback.submissions.ticket
            cell.lbl_Status.text = feedback.submissions.status == 0 ? "Open" :
                feedback.submissions.status == 1 ? "Closed" : "In Progress"
            cell.lbl_SubmittedBy.text = feedback.user_info?.name
            let unitno = feedback.user_info?.unit_no ?? 0
            if let unitId = unitsData.first(where: { $0.id == unitno }) {
                cell.lbl_UnitNo.text = "#" + unitId.unit
            }
            else{
            cell.lbl_UnitNo.text = ""
            }
            
            
         //   cell.lbl_UnitNo.text = unitsData["\(feedback.user_info?.unit_no ?? 0)"]
            cell.lbl_Category.text = feedback.option?.feedback_option
            cell.selectionStyle = .none
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = formatter.date(from: feedback.submissions.created_at)
            formatter.dateFormat = "dd/MM/yy"
            let dateStr = formatter.string(from: date ?? Date())
            
            let dateUpdated = formatter.date(from: feedback.submissions.updated_at)
            let dateStrUpdated = formatter.string(from: dateUpdated ?? Date())
           
            cell.lbl_SubmittedDate.text = dateStr
            
            
            cell.lbl_UpdatedOn.text =  dateStrUpdated
            
            
           
        cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
        cell.btn_Read.addTarget(self, action: #selector(self.read(_:)), for: .touchUpInside)
        cell.btn_Hold.addTarget(self, action: #selector(self.hold(_:)), for: .touchUpInside)
        return cell
        }
      
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return appointmentType == .feedback ? 350 : 280
    }
    @IBAction func approve(_ sender: UIButton){
        let facility = self.array_Facilities[sender.tag]
        (self.parentVc as! NewDefectsTableViewController).facilityId = facility.submissions.id
        (self.parentVc as! NewDefectsTableViewController).actionApprove(sender)
    }
    
    @IBAction func decline(_ sender: UIButton){
        let facility = self.array_Facilities[sender.tag]
        (self.parentVc as! NewDefectsTableViewController).facilityId = facility.submissions.id
        (self.parentVc as! NewDefectsTableViewController).actionDeclineFacility(sender)
       
     //   (self.parentVc as! NewDefectsTableViewController).actionDecline(sender)
    }
    @IBAction func read(_ sender: UIButton){
        let fb = array_Feedbacks[sender.tag]
        (self.parentVc as! NewDefectsTableViewController).getFeedbackDetail(id: fb.submissions.id)
        //actionRead(sender)
    }
    
    @IBAction func hold(_ sender: UIButton){
        (self.parentVc as! NewDefectsTableViewController).actionHold(sender)
    }
   
   
}
extension NewDefectsTableViewController: AlertViewDelegate{
    func onBackClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func onCloseClicked() {
        
    }
    
    func onOkClicked() {
        if self.appointmentType == .defect{
        alertView_message.delegate = self
        alertView_message.showInView(self.view_Background, title: "Defect List has\n been declined", okTitle: "Home", cancelTitle: "View Defect List")
        }
        else if self.appointmentType == .facility{
            self.showCancelAlert()
//            alertView_message.delegate = self
//            alertView_message.showInView(self.view_Background, title: "Facility booking has\n been declined", okTitle: "Home", cancelTitle: "View Facility Bookings")
        }
    }
    
    
}
extension NewDefectsTableViewController: MessageAlertViewDelegate{
    func onHomeClicked() {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func onListClicked() {
        selectedRowIndex_Appointment = -1
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
extension NewDefectsTableViewController: MenuViewDelegate{
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

   
   


