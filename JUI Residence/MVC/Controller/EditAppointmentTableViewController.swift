//
//  EditAppointmentTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 26/07/21.
//

import UIKit
import DropDown
class EditAppointmentTableViewController: BaseTableViewController {

    //Outlets
    @IBOutlet weak var lbl_UnitNo: UILabel!
    @IBOutlet weak var lbl_BookedBy: UILabel!
    @IBOutlet weak var lbl_Date: UILabel!
    @IBOutlet weak var lbl_Time: UILabel!
    @IBOutlet weak var lbl_NRIC: UILabel!
    @IBOutlet weak var lbl_Reason: UILabel!
    @IBOutlet weak var txt_Status: UITextField!
    var statusData = ["1":"Cancelled","2":"On Schedule","3" :"Done"]
    
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var imgView_Profile: UIImageView!
    @IBOutlet weak var view_Outer: UIView!
    @IBOutlet var arr_Buttons: [UIButton]!
    let alertView: AlertView = AlertView.getInstance
    let alertView_message: MessageAlertView = MessageAlertView.getInstance
    let menu: MenuView = MenuView.getInstance
    var keyCollection: KeyCollectionModal!
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
        view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
        view_Outer.layer.cornerRadius = 10.0
        txt_Status.layer.cornerRadius = 20.0
        txt_Status.layer.masksToBounds = true
        
        view_Background.layer.cornerRadius = 25.0
        view_Background.layer.masksToBounds = true
      
        imgView_Profile.addborder()
       

        for btn in arr_Buttons{
            btn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
            btn.layer.cornerRadius = 8.0
        }
        
        lbl_BookedBy.text = keyCollection.submission_info.getname?.name
        lbl_UnitNo.text = keyCollection.submission_info.getunit?.unit
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: keyCollection.submission_info.appt_date)
        formatter.dateFormat = "dd/MM/yy"
        let dateStr = formatter.string(from: date ?? Date())
       
        lbl_Date.text = dateStr
        
        
        lbl_Time.text =  keyCollection.submission_info.appt_time
        
        lbl_NRIC.text =  keyCollection.submission_info.nricid_1
        txt_Status.text =    keyCollection.submission_info.status == 1 ? "Cancelled" : keyCollection.submission_info.status == 2  ? "On Schedule" : keyCollection.submission_info.status == 3 ? "Done" : ""
        lbl_Reason.text = keyCollection.submission_info.reason
       
    }
    //MARK: ******  PARSING *********
    func updateKeyCollection(){
       
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        var statusId = ""
        if let status = statusData.first(where: { $0.value == txt_Status.text })?.key {
            statusId = status
        }
        let id = keyCollection.submission_info.id
        let param = [
            "login_id" : userId,
            "id" : id,
            "status": statusId,
            "appt_date":keyCollection.submission_info.appt_date,
            "appt_time": keyCollection.submission_info.appt_time
          
        ] as [String : Any]

        ApiService.edit_KeyCollection(parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? DeleteUserBase){
                    if response.response == 1{
                        DispatchQueue.main.async {
                            self.alertView_message.delegate = self
                            self.alertView_message.showInView(self.view_Background, title: "Key Collection\n changes has been\n saved", okTitle: "Home", cancelTitle: "View Key Collecion")
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
    
    func deleteKeyCollection(){
       
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
     
        let id = keyCollection.submission_info.id
        let param = [
            "login_id" : userId,
            "id" : id,
          
        ] as [String : Any]

        ApiService.delete_KeyCollection(parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? DeleteUserBase){
                    if response.response == 1{
                        DispatchQueue.main.async {
                            self.alertView_message.delegate = self
                            self.alertView_message.showInView(self.view_Background, title: "Key Collection\n has been cancelled", okTitle: "Home", cancelTitle: "View Key Collection")
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
              
                
            }
        }
    @IBAction func actionSave(_ sender: UIButton){
        self.updateKeyCollection()
    }
    @IBAction func actionCancelBooking(_ sender: UIButton){
        alertView.delegate = self
        alertView.showInView(self.view_Background, title: "Are you sure you want to\n cancel the following key\ncollection appointment?", okTitle: "Yes", cancelTitle: "Back")
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


    
extension EditAppointmentTableViewController: AlertViewDelegate{
    func onBackClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func onCloseClicked() {
        
    }
    
    func onOkClicked() {
        self.deleteKeyCollection()
    }
    
    
}
extension EditAppointmentTableViewController: MessageAlertViewDelegate{
    func onHomeClicked() {
        selectedRowIndex_Appointment = -1
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func onListClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
extension EditAppointmentTableViewController: MenuViewDelegate{
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

   
   


