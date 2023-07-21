//
//  ResidentFileUploadTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 28/12/21.
//

import UIKit
import DropDown
var selectedRowIndex_FileUpload = -1
class ResidentFileUploadTableViewController: BaseTableViewController {
    //Outlets
    @IBOutlet weak var txt_Category: UITextField!
    @IBOutlet weak var txt_Status: UITextField!
    @IBOutlet weak var txt_UnitNo: UITextField!
    @IBOutlet weak var txt_Month: UITextField!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var imgView_Profile: UIImageView!
    @IBOutlet weak var btn_NewAppointment: UIButton!
    @IBOutlet weak var view_Footer: UIView!
    @IBOutlet weak var table_ResidentFile: UITableView!
    @IBOutlet weak var view_SwitchProperty: UIView!
    @IBOutlet weak var lbl_SwitchProperty: UILabel!
    @IBOutlet var arrTextFields: [UITextField]!
    var array_ResidentFileUpload = [ResidentFileModal]()
    var dataSource = DataSource_ResidentFile()
    let menu: MenuView = MenuView.getInstance
    var array_Condos = [CondoCategory]()
    var unitsData = [Unit]()
    var selectedMonth = ""
    
    var selectedStatus = ""
    var selectedCategory = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        getCondoCategory()
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
        table_ResidentFile.dataSource = dataSource
        table_ResidentFile.delegate = dataSource
        dataSource.parentVc = self
        setUpUI()
       
    }
    func setUpUI(){
        for field in arrTextFields{
            field.layer.cornerRadius = 20.0
            field.layer.masksToBounds = true
            field.delegate = self
            field.textColor = textColor
            field.attributedPlaceholder = NSAttributedString(string: field.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
        }
        let expiryDatePicker = MonthYearPickerView()
        expiryDatePicker.onDateSelected = { (month: Int, year: Int) in
            let string = String(format: "%02d/%d", month, year)
            NSLog(string) // should show something like 05/2015
           
            self.txt_Month.text = string
           
            
            self.selectedMonth = String(format: "%d-%02d",  year, month) + "-01"
            
           
        }
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
      let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
      toolbar.setItems([spaceButton,doneButton], animated: false)
    // add toolbar to textField
        txt_Month.inputAccessoryView = toolbar
     // add datepicker to textField
        txt_Month.inputView = expiryDatePicker
        
        
        view_Background.layer.cornerRadius = 25.0
        view_Background.layer.masksToBounds = true
      
        imgView_Profile.addborder()
        btn_NewAppointment.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
      
        btn_NewAppointment.layer.cornerRadius = 10.0


    }
    @objc func donedatePicker(){
        view.endEditing(true)
        
            
            if txt_Month.text == ""{
                if (txt_Month.inputView as! MonthYearPickerView).years.count > 0{
                    let month = (txt_Month.inputView as! MonthYearPickerView).month
                    let year = (txt_Month.inputView as! MonthYearPickerView).years[0]
                    
                let string = String(format: "%02d/%d", month, year)
                NSLog(string) // should show something like 05/2015
               
                self.txt_Month.text = string
                    self.selectedMonth = String(format: "%d-%02d",  year, month) + "-01"
                    
                }
          
      
        }
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return view_Footer
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 150

    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1{
            let ht = selectedRowIndex_FileUpload == -1  ?  (array_ResidentFileUpload.count * 145) + 410 : ((array_ResidentFileUpload.count - 1) * 145) + 210 + 410
            return CGFloat(ht)
        }
     
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedRowIndex_FileUpload = -1
        getResidentFileSummary()
        self.showBottomMenu()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.closeMenu()
    }
    func showBottomMenu(){
        
        menu.delegate = self
        menu.showInView(self.view, title: "", message: "")
       // self.menu.loadCollection(array_Permissions: global_array_Permissions, array_Modules: global_array_Modules)
    }
    func closeMenu(){
        menu.removeView()
    }
    override func getBackgroundImageName() -> String {
        let imgdefault = ""//UserInfoModalBase.currentUser?.data.property.defect_bg ?? ""
        return imgdefault
    }
    
    //MARK: ******  PARSING *********
    func getCondoCategory(){
       // ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.get_CondoCategory(parameters: ["login_id":userId], completion: { status, result, error in
           
        //    ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? CondoCategoryBase){
                    self.array_Condos = response.data
                  
                }
        }
            else if error != nil{
            }
            else{
              //  self.displayErrorAlert(alertStr: "Something went wrong.Please try again", title: "Alert")
            }
        })
    }
    
    func searchResidentFileSummary(){
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.search_ResidentFiles(parameters: ["login_id":userId,"unit" : txt_UnitNo.text!,"status": self.selectedStatus,"category": self.selectedCategory, "month" : self.selectedMonth], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? ResidentFileSummaryBase){
                    self.array_ResidentFileUpload = response.data
                    
                    self.dataSource.array_ResidentFileUpload = self.array_ResidentFileUpload
                    if self.array_ResidentFileUpload.count == 0{

                    }
                    else{
                       // self.view_NoRecords.removeFromSuperview()
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
    func getResidentFileSummary(){
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.get_ResidentFileSummary(parameters: ["login_id":userId], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? ResidentFileSummaryBase){
                    self.array_ResidentFileUpload = response.data
                    
                    self.dataSource.array_ResidentFileUpload = self.array_ResidentFileUpload
                    if self.array_ResidentFileUpload.count == 0{

                    }
                    else{
                       // self.view_NoRecords.removeFromSuperview()
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
//MARK: UIBUTTON ACTION
    @IBAction func actionClear(_ sender:UIButton) {
        self.txt_Status.text = ""
        txt_Category.text = ""
        txt_UnitNo.text = ""
        txt_Month.text = ""
        selectedStatus = ""
        selectedCategory = ""
        selectedMonth = ""
        self.getResidentFileSummary()
        
        
    }
    @IBAction func actionSearch(_ sender:UIButton) {
        
       
        self.searchResidentFileSummary()
        
        
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
    @IBAction func actionCategory(_ sender: UIButton){
        let dropDown_Category = DropDown()
        dropDown_Category.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Category.dataSource = array_Condos.map { $0.docs_category }// Array(unitsData.values)
        dropDown_Category.show()
        dropDown_Category.selectionAction = { [unowned self] (index: Int, item: String) in
            txt_Category.text = item
            txt_Category.backgroundColor = .white
            
            let condo = array_Condos[index]
            selectedCategory = "\(condo.id)"
            }
        }
    @IBAction func actionStatus(_ sender:UIButton) {
        let arrStatus = [ "All", "New", "Processing", "Processed"]
        let dropDown_Status = DropDown()
        dropDown_Status.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Status.dataSource = arrStatus//statusData.map({$0.value})//Array(statusData.values)
        dropDown_Status.show()
        dropDown_Status.selectionAction = { [unowned self] (index: Int, item: String) in
            txt_Status.text = item
            txt_Status.backgroundColor = .white
            self.selectedStatus = item == "All" ? "" : "\(index - 1)"
        }
    }
    @IBAction func actionUnit(_ sender:UIButton) {
        //  let sortedArray = unitsData.sorted(by:  { $0.1 < $1.1 })
        let arrUnit = unitsData.map { $0.unit }
        let dropDown_Unit = DropDown()
        dropDown_Unit.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Unit.dataSource = arrUnit// Array(unitsData.values)
        dropDown_Unit.show()
        dropDown_Unit.selectionAction = { [unowned self] (index: Int, item: String) in
            
            txt_UnitNo.text = item
            txt_UnitNo.backgroundColor = .white
            
        }
    }
    @IBAction func actionNewUpload(_ sender: UIButton){
        let newUploadsTVC = self.storyboard?.instantiateViewController(identifier: "NewResidentFileUploadsTableViewController") as! NewResidentFileUploadsTableViewController
        self.navigationController?.pushViewController(newUploadsTVC, animated: true)
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
class DataSource_ResidentFile: NSObject, UITableViewDataSource, UITableViewDelegate {

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
        cell.lbl_UnitNo.text = "#\(fileInfo.user.getunit?.unit ?? "")"
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.date(from: fileInfo.submission.created_at)
        formatter.dateFormat = "dd/MM/yy"
        let dateStr = formatter.string(from: date ?? Date())
        
        cell.lbl_New.layer.cornerRadius = 11.0
        cell.lbl_New.layer.masksToBounds = true
        if fileInfo.submission.view_status == 0{
            cell.lbl_New.isHidden = false
        }
        else{
            cell.lbl_New.isHidden = true
        }
       
        cell.lbl_UploadDate.text = dateStr
        
       // cell.lbl_UploadBy.text = fileInfo
        
        cell.lbl_Status.text = fileInfo.submission.status == 0 ? "New" :
            fileInfo.submission.status == 1  ? "Processing" : fileInfo.submission.status == 2 ? "Processed" : ""
        cell.lbl_Category.text = fileInfo.cat?.docs_category
        cell.view_Outer.tag = indexPath.row
        cell.btn_Edit.tag = indexPath.row
        cell.btn_Edit.addTarget(self, action: #selector(self.actionEdit(_:)), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        cell.view_Outer.addGestureRecognizer(tap)
        if indexPath.row != selectedRowIndex_FileUpload{
            for vw in cell.arrViews{
                vw.isHidden = true
            }
        }
        else{
            for vw in cell.arrViews{
                vw.isHidden = false
            }
        }
        cell.img_Arrow.image = indexPath.row == selectedRowIndex_FileUpload ? UIImage(named: "up_arrow") : UIImage(named: "down_arrow")
        return cell
      
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return indexPath.row == selectedRowIndex_FileUpload ? 210 : 145
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        selectedRowIndex_FileUpload = (sender! as UITapGestureRecognizer).view!.tag
        DispatchQueue.main.async {
            (self.parentVc as! ResidentFileUploadTableViewController).table_ResidentFile.reloadData()
            (self.parentVc as! ResidentFileUploadTableViewController).tableView.reloadData()
        
      
        }
        
    }
    
    @IBAction func actionEdit(_ sender:UIButton){
       
        let filedata = array_ResidentFileUpload[sender.tag]

            let infoVC = kStoryBoardMenu.instantiateViewController(identifier: "ResidentFileDetailsTableViewController") as! ResidentFileDetailsTableViewController
        infoVC.residentFileData = filedata
        self.parentVc.navigationController?.pushViewController(infoVC, animated: true)
          
       
       
    }
}


extension ResidentFileUploadTableViewController: MenuViewDelegate{
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

   
   

extension ResidentFileUploadTableViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
