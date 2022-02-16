//
//  NewAppointmentTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 24/12/21.
//

import UIKit

class NewAppointmentTableViewController: BaseTableViewController {

    //Outlets
    var keyCollectionId = 0
    var reason = ""
    @IBOutlet weak var table_KeyCollection : UITableView!
    
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var imgView_Profile: UIImageView!
    var array_KeyCollection = [KeyCollectionModal]()
    var dataSource = DataSource_NewAppointments()
    let alertView: AlertView = AlertView.getInstance
    let alertView_message: MessageAlertView = MessageAlertView.getInstance
    let menu: MenuView = MenuView.getInstance
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
      
        setUpUI()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showBottomMenu()
        getNewAppointments()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.closeMenu()
    }
    //MARK: ******  PARSING *********
    func getNewAppointments(){
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.get_NewKeyCollectionSummary(parameters: ["login_id":userId], completion: { status, result, error in
           
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
                        self.table_KeyCollection.reloadData()
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
    
    
    func approve_decline_KeyCollection(isToApprove:Bool){
       
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
     
        let param = [
            "login_id" : userId,
            "id" : keyCollectionId,
            "reason": ""
        ] as [String : Any]

        ApiService.approve_decline_KeyCollection(isToApprove : isToApprove ,parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? DeleteUserBase){
                    if response.response == 1{
                        DispatchQueue.main.async {
                            let msg = isToApprove ? "Key Collection has\n been approved" : "Key Collection has\n been declined"
                            self.alertView_message.delegate = self
                            self.alertView_message.showInView(self.view_Background, title: msg, okTitle: "Home", cancelTitle: "View Key Collection")
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
       

       
        table_KeyCollection.dataSource = dataSource
        table_KeyCollection.delegate = dataSource
        dataSource.parentVc = self
    }

    //MARK: UIButton Action
    @IBAction func actionApprove(_ sender: UIButton){
        self.approve_decline_KeyCollection(isToApprove: true)
    }
    @IBAction func actionDecline(_ sender: UIButton){
        alertView.delegate = self
        alertView.showInView(self.view, title: "Are you sure you want to\n decline the following key\n collection appointment?", okTitle: "Yes", cancelTitle: "Back")
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


    
extension NewAppointmentTableViewController: AlertViewDelegate{
    func onBackClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func onCloseClicked() {
        
    }
    
    func onOkClicked() {
        self.approve_decline_KeyCollection(isToApprove: false)
    }
    
    
}
extension NewAppointmentTableViewController: MessageAlertViewDelegate{
    func onHomeClicked() {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func onListClicked() {
        selectedRowIndex_Appointment = -1
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
extension NewAppointmentTableViewController: MenuViewDelegate{
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

   
   


class DataSource_NewAppointments: NSObject, UITableViewDataSource, UITableViewDelegate {
    var array_KeyCollection = [KeyCollectionModal]()
    var parentVc: UIViewController!
func numberOfSectionsInTableView(tableView: UITableView) -> Int {

    return 1;
}

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  array_KeyCollection.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "keyCollectionCell") as! AppointmentUnitTakeOverTableViewCell
        let apptInfo = self.array_KeyCollection[indexPath.row]
        cell.lbl_BookedBy.text = apptInfo.submission_info.getname?.name
        cell.lbl_UnitNo.text = apptInfo.submission_info.getunit?.unit
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: apptInfo.submission_info.appt_date)
        formatter.dateFormat = "dd/MM/yy"
        let dateStr = formatter.string(from: date ?? Date())
        cell.selectionStyle = .none
       
        cell.lbl_AppointmentDate.text = dateStr
        
        
        cell.lbl_AppointmentTime.text =  apptInfo.submission_info.appt_time
           
        cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
        cell.btn_Approve.tag = indexPath.row
        cell.btn_Decline.tag = indexPath.row
        cell.btn_Approve.addTarget(self, action: #selector(self.approve(_:)), for: .touchUpInside)
        cell.btn_Decline.addTarget(self, action: #selector(self.decline(_:)), for: .touchUpInside)
        return cell
       
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }
    @IBAction func approve(_ sender: UIButton){
        let apptInfo = self.array_KeyCollection[sender.tag]
        (self.parentVc as! NewAppointmentTableViewController).keyCollectionId = apptInfo.submission_info.id
        (self.parentVc as! NewAppointmentTableViewController).actionApprove(sender)
    }
    
    @IBAction func decline(_ sender: UIButton){
        let apptInfo = self.array_KeyCollection[sender.tag]
        (self.parentVc as! NewAppointmentTableViewController).keyCollectionId = apptInfo.submission_info.id
        (self.parentVc as! NewAppointmentTableViewController).actionDecline(sender)
    }
  
   
}
