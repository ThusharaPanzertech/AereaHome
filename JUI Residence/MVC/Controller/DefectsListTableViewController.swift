//
//  DefectsListTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 27/07/21.
//

import UIKit
import DropDown
class DefectsListTableViewController: BaseTableViewController {

    //Outlets
   
    @IBOutlet weak var view_Footer: UIView!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var imgView_Profile: UIImageView!
    @IBOutlet var arr_Textfields: [UITextField]!
    @IBOutlet weak var btn_NewList: UIButton!
    @IBOutlet weak var txt_status: UITextField!
    @IBOutlet weak var txt_unit: UITextField!
    @IBOutlet weak var txt_ticket: UITextField!
    @IBOutlet weak var txt_name: UITextField!
    let menu: MenuView = MenuView.getInstance
    @IBOutlet weak var table_DefectsList: UITableView!
    var dataSource = DataSource_DefectsList()
    var array_Defects = [Defects]()
    var unitsData = [Unit]()
    var isToDelete = false
    var indexToDelete  = 0
    let alertView: AlertView = AlertView.getInstance
    let alertView_message: MessageAlertView = MessageAlertView.getInstance
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
        table_DefectsList.dataSource = dataSource
        table_DefectsList.delegate = dataSource
        dataSource.parentVc = self
        dataSource.unitsData = self.unitsData
        setUpUI()
        let fname = Users.currentUser?.user?.name ?? ""
        let lname = Users.currentUser?.moreInfo?.last_name ?? ""
        self.lbl_UserName.text = "\(fname) \(lname)"
        let role = Users.currentUser?.role?.name ?? ""
        self.lbl_UserRole.text = role
      
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showBottomMenu()
        self.getDefectsSummary()
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
       
        if indexPath.row == 1{
            return CGFloat((300 * array_Defects.count) + 350)
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
    func showDeleteAlert(deleteIndx: Int){
        isToDelete = true
        self.indexToDelete = deleteIndx
        alertView.delegate = self
        alertView.showInView(self.view_Background, title: "Are you sure you want to\n delete the following\n defect list?", okTitle: "Yes", cancelTitle: "Back")
      
    }
    //MARK: ***************  PARSING ***************
    func  deleteDefectList(){
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
       
        let param = [
            "login_id" : userId,
            "id" : self.array_Defects[indexToDelete].lists.id,
          
        ] as [String : Any]

        ApiService.delete_Defect(parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
            self.isToDelete  = false
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
    func getDefectsSummary(){
        self.array_Defects.removeAll()
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.get_defectsSummary(parameters: ["login_id":userId], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? DefectsModalBase){
                    self.array_Defects = response.data
                    if(self.array_Defects.count > 0){
                      //  self.array_Defects = self.array_Defects.sorted(by: { $0.lists.created_at > $1.lists.created_at })
                    }
                    self.dataSource.array_Defects = self.array_Defects
                    if self.array_Defects.count == 0{

                    }
                    else{
                       // self.view_NoRecords.removeFromSuperview()
                    }
                     DispatchQueue.main.async {
                        
                    self.table_DefectsList.reloadData()
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
    func searchDefects(){
//        let filterByDict = ["Earliest Date" : "created_at","Facility": "fb_option","Status": "status"]
//        let filter = filterByDict[txt_FilterBy.text!] ?? "created_at"
       
            if txt_status.text == "" && txt_unit.text == "" && txt_name.text == "" && txt_ticket.text == "" {
                self.getDefectsSummary()
            }
            else{
           
          
                
            ActivityIndicatorView.show("Loading")
            let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
            var param = [String : Any]()
            if txt_status.text != ""{
                param = [
                    "login_id" : userId,
                    "option": "status",
                    "status" : txt_status.text == "Open" ? "0" : txt_status.text == "Closed" ? "1" : txt_status.text == "In Progress" ? "2" : txt_status.text == "On Schedule" ? "3" : "",
                    
                    
                ] as [String : Any]
            }
            else if txt_ticket.text != ""{
                param = [
                    "login_id" : userId,
                    "option": "ticket",
                    "ticket" : txt_ticket.text!,
                    
                    
                    
                ] as [String : Any]
            }
            else if txt_unit.text != ""{
                param = [
                    "login_id" : userId,
                    "option": "unit",
                    "unit" : txt_unit.text!
                    
                ] as [String : Any]
            }
            else if txt_name.text != ""{
                param = [
                    "login_id" : userId,
                    "option": "name",
                    "name" : txt_name.text!
                    
                ] as [String : Any]
            }
            
            
                ApiService.search_Defects(parameters: param, completion: { status, result, error in
                   
                    ActivityIndicatorView.hiding()
                    if status  && result != nil{
                         if let response = (result as? DefectsModalBase){
                            self.array_Defects = response.data
                            if(self.array_Defects.count > 0){
                                self.array_Defects = self.array_Defects.sorted(by: { $0.lists.created_at > $1.lists.created_at })
                            }
                            self.dataSource.array_Defects = self.array_Defects
                            if self.array_Defects.count == 0{

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
        }
    
    //MARK: UIBUTTON ACTION
        @IBAction func actionNewDefects(_ sender: UIButton){
            let defectTVC = self.storyboard?.instantiateViewController(identifier: "NewDefectsTableViewController") as! NewDefectsTableViewController
            defectTVC.appointmentType = .defect
            self.navigationController?.pushViewController(defectTVC, animated: true)
        }
    @IBAction func actionUnit(_ sender:UIButton) {
       // let sortedArray = unitsData.sorted(by:  { $0.1 < $1.1 })
        let arrUnit = unitsData.map { $0.unit }
        let dropDown_Unit = DropDown()
        dropDown_Unit.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Unit.dataSource = arrUnit// Array(unitsData.values)
        dropDown_Unit.show()
        dropDown_Unit.selectionAction = { [unowned self] (index: Int, item: String) in
            txt_status.text = ""
            txt_name.text = ""
            txt_ticket.text = ""
            txt_unit.text = item
            self.searchDefects()
            
        }
    }
    @IBAction func actionStatus(_ sender:UIButton) {
       
        let dropDown_Status = DropDown()
        dropDown_Status.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Status.dataSource = ["Open", "On Schedule", "In Progress", "Closed"]// Array(unitsData.values)
        dropDown_Status.show()
        dropDown_Status.selectionAction = { [unowned self] (index: Int, item: String) in
            txt_name.text = ""
            txt_unit.text = ""
            txt_status.text = item
            txt_ticket.text = ""
            self.searchDefects()
            
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
class DataSource_DefectsList: NSObject, UITableViewDataSource, UITableViewDelegate {
    var unitsData = [Unit]()
    var parentVc: UIViewController!
    var array_Defects = [Defects]()
func numberOfSectionsInTableView(tableView: UITableView) -> Int {

    return 1;
}

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return  array_Defects.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "defectsListCell") as! DefectsListTableViewCell
        cell.selectionStyle = .none
           
        cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
      //  cell.btn_Edit.addTarget(self, action: #selector(self.actionEdit(_:)), for: .touchUpInside)
        cell.view_Outer.tag = indexPath.row
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
       // cell.view_Outer.addGestureRecognizer(tap)
        
        let defect = array_Defects[indexPath.row]
        cell.lbl_TicketNo.text = defect.lists.ticket
        cell.lbl_Reference.text = defect.lists.ref_id == "" ? "-" : defect.lists.ref_id
        if let unitId = unitsData.first(where: { $0.id == defect.user_info?.unit_no ?? 0 }) {
            cell.lbl_UnitNo.text = "#" + unitId.unit
        }
        else{
        cell.lbl_UnitNo.text = ""
        }
      //  cell.lbl_UnitNo.text =  unitsData["\(defect.user_info?.unit_no ?? 0)"] != nil ? "#" + unitsData["\(defect.user_info?.unit_no ?? 0)"]! : ""
        cell.lbl_Status.text =  defect.lists.status == 0 ? "Open" : defect.lists.status == 1  ? "Closed" : defect.lists.status == 2 ?  "In Progress" : defect.lists.status == 3 ? "On Schedule" : defect.lists.status == 4  ? "Done" : ""
       
        if defect.inspection != nil{
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: defect.inspection!.appt_date)
        formatter.dateFormat = "dd/MM/yy"
        let dateStr = formatter.string(from: date ?? Date())
        
            cell.lbl_ApptDate.text = dateStr
            cell.lbl_ApptTime.text = defect.inspection!.appt_time
        }
        else{
            cell.lbl_ApptDate.text = "-"
            cell.lbl_ApptTime.text = "-"
        }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.date(from: defect.lists.created_at)
        formatter.dateFormat = "dd/MM/yy"
        cell.lbl_SubmittedDate.text = formatter.string(from: date ?? Date())
        cell.lbl_CompletedDate.text = "-"
        if  defect.lists.status == 1 {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd"
            let date = formatter.date(from: defect.lists!.completion_date)
            formatter.dateFormat = "dd/MM/yy"
            let dateStr = formatter.string(from: date ?? Date())
            
                cell.lbl_CompletedDate.text = dateStr
        }
        cell.btn_Inspection.tag = indexPath.row
        cell.btn_Inspection.addTarget(self, action: #selector(self.actionInspection(_:)), for: .touchUpInside)
        cell.lblNew.layer.cornerRadius = 11.0
        cell.lblNew.layer.masksToBounds = true
//        if defect.lists.inspection_status == 1{
//            cell.btn_Inspection.isHidden = false
//        }
//        else{
//            cell.btn_Inspection.isHidden = true
//        }
        if defect.lists.handover_status == 1 || defect.lists.handover_status == 2{
            cell.btn_Handover.isHidden = false
        }
        else{
            cell.btn_Handover.isHidden = true
        }
        if defect.lists.view_status == 0{
            cell.lblNew.isHidden = false
        }
        else{
            cell.lblNew.isHidden = true
        }
        cell.btn_Handover.tag = indexPath.row
        cell.btn_Handover.addTarget(self, action: #selector(self.actionHandover(_:)), for: .touchUpInside)
        cell.btn_Delete.tag = indexPath.row
        cell.btn_Delete.addTarget(self, action: #selector(self.actionDelete(_:)), for: .touchUpInside)
        
        return cell
      
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        let submittedDefectsVC = self.parentVc.storyboard?.instantiateViewController(identifier: "SubmittedDefectsListTableViewController") as! SubmittedDefectsListTableViewController
        submittedDefectsVC.defect =  array_Defects[(sender! as UITapGestureRecognizer).view!.tag]
        submittedDefectsVC.unitsData = self.unitsData
        self.parentVc.navigationController?.pushViewController(submittedDefectsVC, animated: true)
       
       
    }
    @IBAction func actionDelete(_ sender:UIButton){
        (self.parentVc as! DefectsListTableViewController).showDeleteAlert(deleteIndx:sender.tag)
    }
    @IBAction func actionInspection(_ sender:UIButton){
        let submittedDefectsVC = self.parentVc.storyboard?.instantiateViewController(identifier: "SubmittedDefectsListTableViewController") as! SubmittedDefectsListTableViewController
        submittedDefectsVC.defect =  array_Defects[sender.tag]
        submittedDefectsVC.unitsData = self.unitsData
        self.parentVc.navigationController?.pushViewController(submittedDefectsVC, animated: true)
       
    }
    @IBAction func actionHandover(_ sender:UIButton){
        let submittedDefectsVC = self.parentVc.storyboard?.instantiateViewController(identifier: "DefectHandoverTableViewController") as! DefectHandoverTableViewController
        submittedDefectsVC.defect =  array_Defects[sender.tag]
        submittedDefectsVC.unitsData = self.unitsData
        self.parentVc.navigationController?.pushViewController(submittedDefectsVC, animated: true)
       
    }
    @IBAction func actionEdit(_ sender:UIButton){
        let submittedDefectsVC = self.parentVc.storyboard?.instantiateViewController(identifier: "SubmittedDefectsListTableViewController") as! SubmittedDefectsListTableViewController
      
        self.parentVc.navigationController?.pushViewController(submittedDefectsVC, animated: true)
       
    }
}
extension DefectsListTableViewController: MenuViewDelegate{
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

   
   



extension DefectsListTableViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == txt_ticket{
            txt_unit.text = ""
            txt_name.text = ""
            txt_status.text = ""
        }
        else if textField == txt_name{
            txt_unit.text = ""
            txt_ticket.text = ""
            txt_status.text = ""
        }
        self.searchDefects()
        return true
    }
}
extension DefectsListTableViewController: AlertViewDelegate{
    func onBackClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func onCloseClicked() {
        
    }
    
    func onOkClicked() {
        if isToDelete == true{
            self.deleteDefectList()
        }
    }
    
    
}
extension DefectsListTableViewController: MessageAlertViewDelegate{
    func onHomeClicked() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func onListClicked() {
        self.getDefectsSummary()
    }
    
    
}
