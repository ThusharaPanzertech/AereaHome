//
//  NewResidentFileUploadsTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 29/04/22.
//

import UIKit
import DropDown
class NewResidentFileUploadsTableViewController: BaseTableViewController {

    //Outlets
    var keyCollectionId = 0
    var reason = ""
    @IBOutlet weak var table_ResidentFile : UITableView!
    @IBOutlet weak var view_SwitchProperty: UIView!
    @IBOutlet weak var lbl_SwitchProperty: UILabel!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var imgView_Profile: UIImageView!
    @IBOutlet weak var lbl_NoRecords: UILabel!
    var array_ResidentFileUpload = [ResidentFileModal]()
    var dataSource = DataSource_ResidentFileNew()
    let alertView: AlertView = AlertView.getInstance
    let alertView_message: MessageAlertView = MessageAlertView.getInstance
    let menu: MenuView = MenuView.getInstance
    override func viewDidLoad() {
        super.viewDidLoad()
        view_SwitchProperty.layer.borderColor = themeColor.cgColor
        view_SwitchProperty.layer.borderWidth = 1.0
        view_SwitchProperty.layer.cornerRadius = 10.0
        view_SwitchProperty.layer.masksToBounds = true
        lbl_SwitchProperty.text = kCurrentPropertyName
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
      
        setUpUI()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showBottomMenu()
        lbl_NoRecords.isHidden = true
        getNewFileUploads()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.closeMenu()
    }
    //MARK: ******  PARSING *********
    func getNewFileUploads(){
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.get_ResidentFileSummaryNew(parameters: ["login_id":userId], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? ResidentFileSummaryBase){
                    self.array_ResidentFileUpload = response.data
                    
                    self.dataSource.array_ResidentFileUpload = self.array_ResidentFileUpload
                    if self.array_ResidentFileUpload.count == 0{
                        self.lbl_NoRecords.isHidden = false
                    }
                    else{
                        self.lbl_NoRecords.isHidden = true
                    }
                     
                     
                    DispatchQueue.main.async {
                        self.table_ResidentFile.reloadData()
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
    
    
    func approve_decline_FilUpload(isToApprove:Bool){
       
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
       

       
        table_ResidentFile.dataSource = dataSource
        table_ResidentFile.delegate = dataSource
        dataSource.parentVc = self
    }

    //MARK: UIButton Action
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
    @IBAction func actionApprove(_ sender: UIButton){
        self.approve_decline_FilUpload(isToApprove: true)
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


    
extension NewResidentFileUploadsTableViewController: AlertViewDelegate{
    func onBackClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func onCloseClicked() {
        
    }
    
    func onOkClicked() {
        self.approve_decline_FilUpload(isToApprove: false)
    }
    
    
}
extension NewResidentFileUploadsTableViewController: MessageAlertViewDelegate{
    func onHomeClicked() {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func onListClicked() {
        selectedRowIndex_Appointment = -1
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
extension NewResidentFileUploadsTableViewController: MenuViewDelegate{
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

   
   


class DataSource_ResidentFileNew: NSObject, UITableViewDataSource, UITableViewDelegate {

    var parentVc: UIViewController!
    var array_ResidentFileUpload = [ResidentFileModal]()

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array_ResidentFileUpload.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "residentCell") as! ResidentFileTableViewCell
        cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
      
        let fileInfo = array_ResidentFileUpload[indexPath.row]
        
        cell.lbl_UploadBy.text = fileInfo.user.name
        //cell.lbl_BookedBy.text = fileInfo.submission.getname?.name  ?? "-"
        cell.lbl_UnitNo.text = "\(fileInfo.user.getunit?.unit ?? "")"
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.date(from: fileInfo.submission.created_at)
        let dateUpdated = formatter.date(from: fileInfo.submission.updated_at)
        formatter.dateFormat = "dd/MM/yy"
        let dateStr = formatter.string(from: date ?? Date())
        let dateStrUpdated = formatter.string(from: dateUpdated ?? Date())
        
       
        cell.lbl_UploadDate.text = dateStr
        cell.lbl_UpdatedAt.text = dateStrUpdated
       // cell.lbl_UploadBy.text = fileInfo
        
        cell.lbl_Status.text = fileInfo.submission.status == 0 ? "New" :
            fileInfo.submission.status == 1  ? "Processing" : fileInfo.submission.status == 2 ? "Processed" : ""
        cell.lbl_Category.text = fileInfo.cat?.docs_category
        cell.view_Outer.tag = indexPath.row
     //   cell.btn_Edit.tag = indexPath.row
      //  cell.btn_Edit.addTarget(self, action: #selector(self.actionEdit(_:)), for: .touchUpInside)
     //   let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
    //    cell.view_Outer.addGestureRecognizer(tap)
       
            return cell
      
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return  220
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        let filedata = array_ResidentFileUpload[(sender! as UITapGestureRecognizer).view!.tag]

            let infoVC = kStoryBoardMenu.instantiateViewController(identifier: "ResidentFileDetailsTableViewController") as! ResidentFileDetailsTableViewController
        infoVC.residentFileData = filedata
        self.parentVc.navigationController?.pushViewController(infoVC, animated: true)
          
        
    }
    
    @IBAction func actionEdit(_ sender:UIButton){
       
        let filedata = array_ResidentFileUpload[sender.tag]

            let infoVC = kStoryBoardMenu.instantiateViewController(identifier: "ResidentFileDetailsTableViewController") as! ResidentFileDetailsTableViewController
        infoVC.residentFileData = filedata
        self.parentVc.navigationController?.pushViewController(infoVC, animated: true)
          
       
       
    }
}

