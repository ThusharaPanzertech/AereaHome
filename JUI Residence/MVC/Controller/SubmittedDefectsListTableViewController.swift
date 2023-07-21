//
//  SubmittedDefectsListTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 27/07/21.
//

import UIKit
import DropDown

class SubmittedDefectsListTableViewController: BaseTableViewController {
    //Outlets
    @IBOutlet weak var view_SwitchProperty: UIView!
    @IBOutlet weak var lbl_SwitchProperty: UILabel!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var view_apptBackground: UIView!
    @IBOutlet weak var imgView_Profile: UIImageView!
    @IBOutlet var arr_Buttons: [UIButton]!
    @IBOutlet var btn_editAppt: UIButton!
    @IBOutlet weak var lbl_TicketNo: UILabel!
    @IBOutlet weak var lbl_UnitNo: UILabel!
    @IBOutlet weak var txt_Status: UITextField!
    @IBOutlet weak var lbl_ApptDate: UILabel!
    @IBOutlet weak var lbl_ApptTime: UILabel!
    @IBOutlet weak var lbl_ApptStatus: UILabel!
    @IBOutlet weak var lbl_Reason: UILabel!
    @IBOutlet weak var table_DefectsList: UITableView!
    let alertView: AlertView = AlertView.getInstance
    let alertView_message: MessageAlertView = MessageAlertView.getInstance
    var dataSource = DataSource_SubmittedDefectsList()
    let menu: MenuView = MenuView.getInstance
    var defect: Defects!
    var defectDetail: DefectData!
    var unitsData = [Unit]()
    var defectTypes = [DefectType]()
    var arr_DefectLocation = [DefectLocation]()
    let view_Signature: SignatureView = SignatureView.getInstance
    var mgmtCommentsStatusArray = [[String:String]]()
    var signatureImageMgmt: UIImage!
    var isSignatureDrawn = false
    override func viewDidLoad() {
        super.viewDidLoad()
        view_SwitchProperty.layer.borderColor = themeColor.cgColor
        view_SwitchProperty.layer.borderWidth = 1.0
        view_SwitchProperty.layer.cornerRadius = 10.0
        view_SwitchProperty.layer.masksToBounds = true
        self.mgmtCommentsStatusArray.removeAll()
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
        table_DefectsList.dataSource = dataSource
        table_DefectsList.delegate = dataSource
        dataSource.parentVc = self
        view_apptBackground.backgroundColor = .clear
        view_apptBackground.layer.cornerRadius = 10.0
        view_apptBackground.layer.borderColor = themeColorMain.cgColor
        view_apptBackground.layer.borderWidth = 1.0
        //addShadow(offset: CGSize.init(width: 0, height: 3), color: themeColor, radius: 10.0, opacity: 0.35)
       
        setUpUI()
       
            getDefectDetail()
       
        self.getDefectLocation()
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        if indexPath.row == 1{
            return defectDetail == nil ? 680 : CGFloat((350 * defectDetail.submissions.count) + 660)
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    
    }
    func setUpUI(){
        txt_Status.textColor = textColor
        txt_Status.attributedPlaceholder = NSAttributedString(string: txt_Status.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
        txt_Status.layer.cornerRadius = 20.0
        txt_Status.layer.masksToBounds = true
       
        for btn in arr_Buttons{
        btn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
        btn.layer.cornerRadius = 8.0
        }
        
        view_Background.layer.cornerRadius = 25.0
        view_Background.layer.masksToBounds = true
      
        imgView_Profile.addborder()
       
        let data = defect == nil ? defectDetail : defect.lists
        let inspection = defect == nil ? defectDetail.inspection : defect.inspection
        self.lbl_TicketNo.text = data!.ticket
        let unit = defect == nil ? defectDetail.unit_no : defect.user_info?.unit_no ?? 0
            if let unitId = unitsData.first(where: { $0.id == unit }) {
                lbl_UnitNo.text = "#" + unitId.unit
            }
            else{
                lbl_UnitNo.text = ""
            }
        
       
        txt_Status.text =  data!.status == 0 ? "Open" : data!.status == 1  ? "Closed" : data!.status == 2 ?  "In Progress" : data!.status == 3 ? "On Schedule" : data!.status == 4  ? "Done" : ""
        lbl_Reason.text = "-"
        if inspection != nil{
            btn_editAppt.isHidden = false
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: defect.inspection!.appt_date)
        formatter.dateFormat = "dd/MM/yy"
        let dateStr = formatter.string(from: date ?? Date())
        
            lbl_ApptDate.text = dateStr
            lbl_ApptTime.text = defect.inspection!.appt_time
            
            lbl_ApptStatus.text = defect.inspection!.status == 0 ? "New" :
                defect.inspection!.status == 1  ? "Cancelled" :
                defect.inspection!.status == 2 ? "On Schedule" :
                defect.inspection!.status == 3 ?   "Done" :
            defect.inspection!.status == 4  ? "In Progress" : ""
            
            lbl_Reason.text = defect.inspection?.reason == "" ?  "-" : defect.inspection?.reason
        }
        else{
            btn_editAppt.isHidden = true
            lbl_ApptDate.text = "-"
            lbl_ApptTime.text = "-"
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
    //MARK: ******  PARSING *********
    func getDefectDetail(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        let id = defect == nil ? defectDetail.id : self.defect.lists.id
        ApiService.get_DefectDetail(parameters: ["login_id":userId , "id": id], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                if let response = (result as? DefectDetailsModalBase){
                    self.defectDetail = response.booking_info
                    self.dataSource.defectDetail = response.booking_info
                    self.defectTypes = response.defect_type
                    self.dataSource.defectTypes = response.defect_type
                    for def in self.defectDetail.submissions{
                        let defid = def.id
                        let stat = "\(def.status)"
                        
                        let status = ["id": "\(defid)", "status": "\(stat)"]
                        self.mgmtCommentsStatusArray.append(status)
                    }
                    self.dataSource.mgmtCommentsStatusArray = self.mgmtCommentsStatusArray
                    DispatchQueue.main.async {
                       
                   self.table_DefectsList.reloadData()
                   self.tableView.reloadData()
                    }
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
    func getDefectLocation(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.get_DefectsLocationSummary(parameters: ["login_id":userId], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? DefectLocationSummaryBase){
                    self.arr_DefectLocation = response.data
                    self.dataSource.arr_DefectLocation = response.data
                   
                     
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
   
    func  deleteDefectList(){
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
       
        let param = [
            "login_id" : userId,
            "id" : self.defect.lists.id,
          
        ] as [String : Any]

        ApiService.delete_Defect(parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
            
            if status  && result != nil{
                 if let response = (result as? DeleteUserBase){
                    if response.response == 1{
                        DispatchQueue.main.async {
                            self.alertView_message.delegate = self
                            self.alertView_message.showInView(self.view_Background, title: "Defect List has\n been deleted", okTitle: "Home", cancelTitle: "View Defect List")
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
    func updateManagementSignatureImage(){
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        let status =  txt_Status.text == "Open" ? "0" : txt_Status.text == "Closed" ? "1" :
        txt_Status.text ==  "In Progress" ? "2" :
        txt_Status.text ==  "On Schedule" ? "3" :
        txt_Status.text ==  "Done"  ? "4" : ""
        
        let params = NSMutableDictionary()
        params.setValue("\(userId)", forKey: "login_id")
        params.setValue("\(self.defect.lists.id)", forKey: "id")
        params.setValue("\(status)", forKey: "status")
        if defect.inspection != nil{
        params.setValue("\(self.defect.inspection!.appt_date)", forKey: "appt_date")
        params.setValue("\(self.defect.inspection!.appt_time)", forKey: "appt_time")
        params.setValue("\(self.defect.inspection!.appt_date)", forKey: "inspection_status")
        }
        else{
            params.setValue("", forKey: "appt_date")
            params.setValue("", forKey: "appt_time")
            params.setValue("", forKey: "inspection_status")
        }
        
        
        
        for data in self.mgmtCommentsStatusArray{
            let id = data["id"]
            let stats = data["status"]
            
            params.setValue("\(stats ?? "")", forKey: "defect_status[\(id!)]")
            //agree_status.append(["\(id!)":"\(stats)"])
        }
        
        
        ApiService.updateDefect_InspectionSignature_With(signature: self.signatureImageMgmt.jpegData(compressionQuality: 0.5)! as NSData as Data, parameters: params as! [String : Any], completion: { status, result, error in
            
       
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                if let responseBase = (result as? SignatureUpdateModal){
                    if responseBase.response == 1{
                        self.alertView_message.delegate = self
                        self.alertView_message.showInView(self.view_Background, title: "Joint inspection status changes has been saved", okTitle: "Home", cancelTitle: "View Defect Lists")
                        
                        //                        let alert = UIAlertController(title: "Signature updated successfully", message: "", preferredStyle: UIAlertController.Style.alert)
                        //                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                        //                            self.navigationController?.popViewController(animated: true)
                        //                        }))
                        //
                        //                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    else{
                        if responseBase.response == 2 || responseBase.message == "Ticket Closed"{
                            self.alertView_message.delegate = self
                            self.alertView_message.showInView(self.view_Background, title: "Ticket Closed", okTitle: "Home", cancelTitle: "View Defect Lists")
                            //                        let alert = UIAlertController(title: "Ticket Closed", message: "", preferredStyle: UIAlertController.Style.alert)
                            //                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                            //                            self.navigationController?.popViewController(animated: true)
                            //                        }))
                            //
                            //                        self.present(alert, animated: true, completion: nil)
                            
                            
                        }
                        else{
                            self.displayErrorAlert(alertStr: "", title: responseBase.message)
                        }
                    }
                }
        }
            else if error != nil{
                self.displayErrorAlert(alertStr: "\(error!.localizedDescription)", title: "Oops")
            }
            else{
                self.displayErrorAlert(alertStr: "Something went wrong.Please try again", title: "Oops")
            }
        })
    }
   func actionSubmitSignature(){
        if isSignatureDrawn == false  || self.signatureImageMgmt == nil{
            self.displayErrorAlert(alertStr: "Management signature is required", title: "Alert")
        }
        else{
            self.updateManagementSignatureImage()
        }
    }
    //MARK: UIButton ACTIONS
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
    @IBAction func actionStatus(_ sender:UIButton) {
       
        let dropDown_Status = DropDown()
        dropDown_Status.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Status.dataSource = ["Open", "On Schedule", "In Progress", "Closed"]// Array(unitsData.values)
        dropDown_Status.show()
        dropDown_Status.selectionAction = { [unowned self] (index: Int, item: String) in
            
            txt_Status.text = item
           
           
            
        }
    }
    @IBAction func actionSave(_ sender: UIButton){
        if txt_Status.text == ""{
            self.displayErrorAlert(alertStr: "", title: "Please select defect status")
        }
        else{
            var flag = 0
            for data in mgmtCommentsStatusArray{
                if data["status"] == "0"{
                    flag = 1
                    break
                }
            }
            if flag == 1{
                self.displayErrorAlert(alertStr: "", title: "Please select management comment")
            }
            else{
                self.view_Signature.delegate = self
                  let fname = Users.currentUser?.moreInfo?.first_name ?? ""
                let lname = Users.currentUser?.moreInfo?.last_name ?? ""
                self.view_Signature.showInView(self.view, parent:self, tag: 1, name:  "\(fname) \(lname)")
            }
        }
       
//        alertView_message.delegate = self
//        alertView_message.showInView(self.view_Background, title: "Defect list changes\n has been saved", okTitle: "Home", cancelTitle: "View defect List")
    }
    @IBAction func actionDelete(_ sender: UIButton){
        
        alertView.delegate = self
        alertView.showInView(self.view_Background, title: "Are you sure you want to\n delete the following\n defect list?", okTitle: "Yes", cancelTitle: "Back")
    }
   
    @IBAction func actionEditAppt(_ sender: UIButton){
        let editApptTVC = kStoryBoardMain.instantiateViewController(identifier: "EditJointInspectionTableViewController") as! EditJointInspectionTableViewController
        editApptTVC.defectDetail = self.defectDetail
        self.navigationController?.pushViewController(editApptTVC, animated: true)
    
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
class DataSource_SubmittedDefectsList: NSObject, UITableViewDataSource, UITableViewDelegate {
    var mgmtCommentsStatusArray = [[String:String]]()
    var defectDetail: DefectData!
    var arr_DefectLocation = [DefectLocation]()
    var parentVc: UIViewController!
    var defectTypes = [DefectType]()
func numberOfSectionsInTableView(tableView: UITableView) -> Int {

    return 1;
}

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return  defectDetail != nil ? defectDetail.submissions.count : 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "defectsListCell") as! SubmittedDefectsListTableViewCell
        cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
        cell.view_Outer.tag = indexPath.row
        cell.selectionStyle = .none
        
        
        cell.lbl_Indx.text = "\(indexPath.row + 1)"
        let defect = defectDetail.submissions[indexPath.row]
        cell.lbl_Remarks.text = defect.notes
        let loc = self.arr_DefectLocation.first(where:{ $0.id == defect.defect_location})
        cell.lbl_Location.text =  loc?.defect_location
        let defecttype = defectTypes.first(where:{ $0.id == defect.defect_type})
        if defecttype != nil{
            cell.lbl_DefectType.text = defecttype!.defect_type
        }
        else{
            cell.lbl_DefectType.text = ""
        }
        cell.btn_Photo.tag = indexPath.row
        if let url = URL(string: "\(kImageFilePath)/" + defect.upload) {
            cell.img_Photo.af_setImage(withURL: url)
            cell.btn_Photo.addTarget(self, action: #selector(self.actionShowPhoto(_:)), for: .touchUpInside)
           
        } else {
           
        }
        cell.btn_Comment.tag = defect.id
        cell.btn_Comment.addTarget(self, action: #selector(self.actionComment(_:)), for: .touchUpInside)
        let option =  self.mgmtCommentsStatusArray.first(where:{ $0["id"] == "\(defect.id)" })
        if option != nil{
            if option!["status"] == "2"{
                cell.txt_Comment.text = "Need to rectify"
            }
            else   if option!["status"] == "3"{
                cell.txt_Comment.text = "Not an issue"
            }
            else{
                cell.txt_Comment.text = ""
            }
        }
            return cell
      
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    @IBAction func actionShowPhoto(_ sender: UIButton){
        
        let defect = defectDetail.submissions[sender.tag]
        let imgPreviewVC = kStoryBoardMain.instantiateViewController(withIdentifier: "PhotoViewController") as! PhotoViewController
        var selectedIndex = 0
        var arr = [String]()
        
        if let url = URL(string: "\(kImageFilePath)/" + defect.upload) {
        
        imgPreviewVC.arrayImages = ["\(kImageFilePath)/" + defect.upload]
        imgPreviewVC.index = 0//sender.tag
        imgPreviewVC.modalPresentationStyle = .fullScreen
            self.parentVc.present(imgPreviewVC, animated: false, completion: nil)
        }
        }
    @IBAction func actionComment(_ sender:UIButton) {
       
        let dropDown_Status = DropDown()
        dropDown_Status.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Status.dataSource = ["Need to rectify", "Not an issue"]// Array(unitsData.values)
        dropDown_Status.show()
        dropDown_Status.selectionAction = { [unowned self] (index: Int, item: String) in
            var indx = 0
            var option =  self.mgmtCommentsStatusArray.first(where:{ $0["id"] == "\(sender.tag)" })
            if option != nil{
                indx = mgmtCommentsStatusArray.firstIndex(of:option!) ?? 0
                option!["status"] = index == 0 ? "2"  : "3"
                self.mgmtCommentsStatusArray[indx] = option!
            }
            (self.parentVc as! SubmittedDefectsListTableViewController).mgmtCommentsStatusArray = self.mgmtCommentsStatusArray
            (self.parentVc as! SubmittedDefectsListTableViewController).table_DefectsList.reloadData()
      
           
            
        }
    }
}

extension SubmittedDefectsListTableViewController: AlertViewDelegate{
    func onBackClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func onCloseClicked() {
        
    }
    
    func onOkClicked() {
        self.deleteDefectList()
//        alertView_message.delegate = self
//        alertView_message.showInView(self.view_Background, title: "Defect list changes\n has been saved", okTitle: "Home", cancelTitle: "View defect List")
    }
    
    
}
extension SubmittedDefectsListTableViewController : MessageAlertViewDelegate{
    func onHomeClicked() {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func onListClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
extension SubmittedDefectsListTableViewController: MenuViewDelegate{
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

   
   


extension SubmittedDefectsListTableViewController:SignatureViewDelegate{
    func onDoneClicked(image: UIImage, name: String, signView: SignatureView) {
        if signView.tag == 1{
            self.isSignatureDrawn = true
            self.signatureImageMgmt = image
            self.actionSubmitSignature()
//            self.signature1 = image
//            self.imgView_signature1.image = image
        }
       
    }
    
    
}
