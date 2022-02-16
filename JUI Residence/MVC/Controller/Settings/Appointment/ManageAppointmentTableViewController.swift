//
//  ManageAppointmentTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 27/09/21.
//

import UIKit

class ManageAppointmentTableViewController: BaseTableViewController {
    fileprivate var singleDate: Date = Date()
    fileprivate var multipleDates_TakeOver: [Date] = []
    fileprivate var multipleDates_Inspection: [Date] = []
    let alertView: AlertView = AlertView.getInstance
    let alertView_message: MessageAlertView = MessageAlertView.getInstance
    var array_TakeOverTimings = [String]()
    var array_InspectionTimings = [String]()
    @IBOutlet weak var ht_takeOverDates: NSLayoutConstraint!
    @IBOutlet weak var ht_takeOverTime: NSLayoutConstraint!
    @IBOutlet weak var ht_InspectionDates: NSLayoutConstraint!
    @IBOutlet weak var ht_InspectionTime: NSLayoutConstraint!
    var propertyInfo : PropertyInfo!
    //Outlets
    var isTakeOver: Bool!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var txt_PropertyName: UITextField!
    @IBOutlet weak var txtView_TakeOverTiming: UITextView!
    @IBOutlet weak var txtView_TakeOverDates: UITextView!
    @IBOutlet weak var txtView_InspectionTiming: UITextView!
    @IBOutlet weak var txtView_InspectionDates: UITextView!
    @IBOutlet weak var txtView_InspectionNotes: UITextView!
    @IBOutlet weak var txtView_TakeOverNotes: UITextView!
    @IBOutlet weak var collection_TakeOverTiming: UICollectionView!
    @IBOutlet weak var collection_InspectionTiming: UICollectionView!
    
    @IBOutlet weak var btn_Submit: UIButton!
    @IBOutlet var arr_TextViews: [UITextView]!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var imgView_Profile: UIImageView!
    var isUnitTakeOver: Bool!
    
    let menu: MenuView = MenuView.getInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionViewLayout()
        imgView_Profile.addborder()
        view_Background.layer.cornerRadius = 25.0
        view_Background.layer.masksToBounds = true
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
        btn_Submit.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
        btn_Submit.layer.cornerRadius = 8.0
        txt_PropertyName.layer.cornerRadius = 20.0
        txt_PropertyName.layer.masksToBounds = true
        txt_PropertyName.delegate = self
        txt_PropertyName.textColor = textColor
        txt_PropertyName.attributedPlaceholder = NSAttributedString(string: txt_PropertyName.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
        
        
        for txtview in self.arr_TextViews{
            txtview.layer.cornerRadius = 20.0
            txtview.layer.masksToBounds = true
            txtview.contentInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        }
        
        txt_PropertyName.text = self.propertyInfo.company_name
        txtView_TakeOverDates.text = self.propertyInfo.takeover_blockout_days
        if self.propertyInfo.takeover_blockout_days.count > 0{
            let arr = self.propertyInfo.takeover_blockout_days.components(separatedBy: ",")
            for obj in arr{
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.dateFormat = "yyyy-MM-dd"
                let date = formatter.date(from: obj)
                self.multipleDates_TakeOver.append(date ?? Date())
            }
            self.txtView_TakeOverDates.text = self.propertyInfo.takeover_blockout_days
        }
        if self.propertyInfo.inspection_blockout_days.count > 0{
            let arr = self.propertyInfo.inspection_blockout_days.components(separatedBy: ",")
            for obj in arr{
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.dateFormat = "yyyy-MM-dd"
                let date = formatter.date(from: obj)
                self.multipleDates_Inspection.append(date ?? Date())
            }
            self.txtView_InspectionDates.text = self.propertyInfo.inspection_blockout_days
        }
        
        if self.propertyInfo.takeover_timing.count > 0{
            var timing_New = self.propertyInfo.takeover_timing.replacingOccurrences(of: ", ", with: ",")
            timing_New = self.propertyInfo.takeover_timing.replacingOccurrences(of: " ,", with: ",")
            let arr = timing_New.components(separatedBy: ",")
            for obj in arr{
                self.array_TakeOverTimings.append(obj)
            }
            self.collection_TakeOverTiming.reloadData()
        }
        if self.propertyInfo.inspection_timing.count > 0{
            var timing_New = self.propertyInfo.inspection_timing.replacingOccurrences(of: ", ", with: ",")
            timing_New = self.propertyInfo.inspection_timing.replacingOccurrences(of: " ,", with: ",")
            let arr = timing_New.components(separatedBy: ",")
            for obj in arr{
                self.array_InspectionTimings.append(obj)
            }
        }
        self.txtView_InspectionNotes.text = self.propertyInfo.inspection_notes
        self.txtView_TakeOverNotes.text = self.propertyInfo.takeover_notes
        
        DispatchQueue.main.async {
        self.collection_TakeOverTiming.reloadData()
        self.collection_InspectionTiming.reloadData()
        self.tableView.reloadData()
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1{
            
            let count1 = array_TakeOverTimings.count + 1
            let ht_Coll1 = (Int(count1/3) + (Int(count1%3) > 0 ? 1  : 0) ) * 55 + 50
            
            let count2 = array_InspectionTimings.count + 1
            let ht_Coll2 = (Int(count2/3) + (Int(count2%3) > 0 ? 1  : 0) ) * 55 + 50
            
            let ht_date1 = self.heightForView(text:txtView_TakeOverDates.text, font:UIFont(name: "Helvetica-Bold", size: 17.0)!, width:kScreenSize.width - 80) + 30
            
            let ht_date2 = self.heightForView(text:txtView_InspectionDates.text, font:UIFont(name: "Helvetica-Bold", size: 17.0)!, width:kScreenSize.width - 80) + 30
            
            ht_takeOverDates.constant = ht_date1
            ht_takeOverTime.constant = CGFloat(ht_Coll1)
            ht_InspectionDates.constant = ht_date2
            ht_InspectionTime.constant = CGFloat(ht_Coll2)
            return CGFloat(1300 + ht_Coll1 + ht_Coll2) + ht_date1 + ht_date2
           
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
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
       // self.menu.loadCollection(array_Permissions: global_array_Permissions, array_Modules: global_array_Modules)
    }
    func closeMenu(){
        menu.removeView()
    }
    override func getBackgroundImageName() -> String {
        let imgdefault = ""//UserInfoModalBase.currentUser?.data.property.defect_bg ?? ""
        return imgdefault
    }
    //MARK:UICOLLECTION VIEW LAYOUT
    func setUpCollectionViewLayout(){
       
     
        
        let layout =  UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let cellWidth = (kScreenSize.width - 100)/CGFloat(3.0)
        let size = CGSize(width: cellWidth, height: 55)
        layout.itemSize = size
        collection_TakeOverTiming.collectionViewLayout = layout
       
        
        let layout1 =  UICollectionViewFlowLayout()
        layout1.minimumLineSpacing = 15
        layout1.minimumInteritemSpacing = 10
        layout1.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let cellWidth1 = (kScreenSize.width - 100)/CGFloat(3.0)
        let size1 = CGSize(width: cellWidth1, height: 55)
        layout1.itemSize = size1
        collection_InspectionTiming.collectionViewLayout = layout1
        
    }
    //MARK: UIBUTTON ACTIONS
    @IBAction func actionTakeOverDates(_ sender: UIButton){
        self.closeMenu()
        isTakeOver = true
        let selector = UIStoryboard(name: "WWCalendarTimeSelector", bundle: nil).instantiateInitialViewController() as! WWCalendarTimeSelector
        selector.delegate = self
        selector.optionCurrentDate = singleDate
        selector.optionCurrentDates = Set(multipleDates_TakeOver)
        selector.optionCurrentDateRange.setStartDate(multipleDates_TakeOver.first ?? singleDate)
        selector.optionCurrentDateRange.setEndDate(multipleDates_TakeOver.last ?? singleDate)
        selector.optionSelectionType = WWCalendarTimeSelectorSelection.multiple
        selector.optionMultipleSelectionGrouping = .simple
        present(selector, animated: true, completion: nil)
    }
    @IBAction func actionAddTakeOverTime(_ sender: UIButton){
        self.closeMenu()
        isTakeOver = true
        let selector = UIStoryboard(name: "WWCalendarTimeSelector", bundle: nil).instantiateInitialViewController() as! WWCalendarTimeSelector
        selector.delegate = self
        selector.optionCurrentDate = singleDate
        selector.optionCurrentDates = Set(multipleDates_TakeOver)
        selector.optionCurrentDateRange.setStartDate(multipleDates_TakeOver.first ?? singleDate)
        selector.optionCurrentDateRange.setEndDate(multipleDates_TakeOver.last ?? singleDate)
        selector.optionStyles.showDateMonth(false)
        selector.optionStyles.showMonth(false)
        selector.optionStyles.showYear(false)
        selector.optionStyles.showTime(true)
        present(selector, animated: true, completion: nil)
    }
    @IBAction func actionAddInspectionTime(_ sender: UIButton){
        self.closeMenu()
        isTakeOver = false
        let selector = UIStoryboard(name: "WWCalendarTimeSelector", bundle: nil).instantiateInitialViewController() as! WWCalendarTimeSelector
        selector.delegate = self
        selector.optionCurrentDate = singleDate
        selector.optionCurrentDates = Set(multipleDates_TakeOver)
        selector.optionCurrentDateRange.setStartDate(multipleDates_TakeOver.first ?? singleDate)
        selector.optionCurrentDateRange.setEndDate(multipleDates_TakeOver.last ?? singleDate)
        selector.optionStyles.showDateMonth(false)
        selector.optionStyles.showMonth(false)
        selector.optionStyles.showYear(false)
        selector.optionStyles.showTime(true)
        present(selector, animated: true, completion: nil)
    }
    
    @IBAction func actionInspectionDates(_ sender: UIButton){
        self.closeMenu()
        isTakeOver = false
        let selector = UIStoryboard(name: "WWCalendarTimeSelector", bundle: nil).instantiateInitialViewController() as! WWCalendarTimeSelector
        selector.delegate = self
        selector.optionCurrentDate = singleDate
        selector.optionCurrentDates = Set(multipleDates_Inspection)
        selector.optionCurrentDateRange.setStartDate(multipleDates_Inspection.first ?? singleDate)
        selector.optionCurrentDateRange.setEndDate(multipleDates_Inspection.last ?? singleDate)
        selector.optionSelectionType = WWCalendarTimeSelectorSelection.multiple
        selector.optionMultipleSelectionGrouping = .simple
        present(selector, animated: true, completion: nil)
    }
    @IBAction func actionBackPressed(_ sender: UIButton){
        alertView.delegate = self
        alertView.showInView(self.view_Background, title: "Are you sure you want to\n leave this page?\nYour changes would not\n be saved.", okTitle: "Back", cancelTitle: "Yes")
    }
    @IBAction func actionSubmit(_ sender: UIButton){
        
        self.view.endEditing(true)
        if txt_PropertyName.text == ""{
            displayErrorAlert(alertStr: "Please enter property name", title: "")
        }
        else if  txtView_TakeOverDates.text == ""{
            displayErrorAlert(alertStr: "Please enter the unit take over dates", title: "")
        }
        else if  array_TakeOverTimings.count == 0{
            displayErrorAlert(alertStr: "Please enter the unit take over timings", title: "")
        }
        else if  txtView_InspectionDates.text == ""{
            displayErrorAlert(alertStr: "Please enter the inspection dates", title: "")
        }
        else if  array_InspectionTimings.count == 0{
            displayErrorAlert(alertStr: "Please enter the inspection timings", title: "")
        }
        
        else{
        updateProperty()
        }
    }
    //MARK: ******  PARSING *********
    func updateProperty(){
       
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        
     
        let id = self.propertyInfo.id
       
        
        let param = [
            "login_id" : userId,
            "id" : id,
            "company_name": txt_PropertyName.text!,
            "takeover_timing" : array_TakeOverTimings.joined(separator: ","),
            "takeover_notes": txtView_TakeOverNotes.text!,
            "inspection_timing" : array_InspectionTimings.joined(separator: ","),
            "inspection_blockout_days" : txtView_InspectionDates.text!,
            "takeover_blockout_days" : txtView_TakeOverDates.text!,
            "inspection_notes" : txtView_InspectionNotes.text!
        ] as [String : Any]

        ApiService.update_Property(parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? DeleteUserBase){
                    if response.response == 1{
                        DispatchQueue.main.async {
                            self.alertView_message.delegate = self
                            self.alertView_message.showInView(self.view_Background, title: "Appointment\nsettings changes has\n been submitted", okTitle: "Home", cancelTitle: "View appointment settings")
                        }
                    }
                    else{
                        self.displayErrorAlert(alertStr: response.message, title: "Alert")
                    }
                   
                   
                }
        }
            else if error != nil{
                self.alertView_message.delegate = self
                self.alertView_message.showInView(self.view_Background, title: "Appointment\nsettings changes has\n been submitted", okTitle: "Home", cancelTitle: "View appointment settings")
               // self.displayErrorAlert(alertStr: "\(error!.localizedDescription)", title: "Alert")
            }
            else{
                self.displayErrorAlert(alertStr: "Something went wrong.Please try again", title: "Alert")
            }
        })
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
        let announcementTVC = kStoryBoardMain.instantiateViewController(identifier: "AnnouncementTableViewController") as! AnnouncementTableViewController
        self.navigationController?.pushViewController(announcementTVC, animated: true)
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
extension ManageAppointmentTableViewController: MenuViewDelegate{
    func onMenuClicked(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            self.menu.contractMenu()
            self.navigationController?.popToRootViewController(animated: true)
            break
        case 2:
            self.actionInbox(sender)
            break
        case 3:
            self.goToSettings()
            break
        case 4:
            self.actionLogout(sender)
            break
        case 5:
            self.menu.contractMenu()
            self.actionAnnouncement(sender)
            break
        case 6:
            self.menu.contractMenu()
            self.actionAppointmemtUnitTakeOver(sender)
            break
        case 7:
            self.menu.contractMenu()
            self.actionDefectList(sender)
            break
        case 8:
            self.menu.contractMenu()
            self.actionAppointmentJointInspection(sender)
            break
        case 9:
            self.menu.contractMenu()
            self.actionFacilityBooking(sender)
            break
        case 10:
            self.menu.contractMenu()
            self.actionFeedback(sender)
            break
        default:
            break
        }
    }
    
    func onCloseClicked(_ sender: UIButton) {
        
    }
    
    
}
extension ManageAppointmentTableViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
       
        return true
    }
   
}
extension ManageAppointmentTableViewController: WWCalendarTimeSelectorProtocol{
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        print("Selected \n\(date)\n---")
        singleDate = date
        self.showBottomMenu()
        let time = date.stringFromFormat("h':'mm a")
        if isTakeOver == true{
            if !self.array_TakeOverTimings.contains(time){
                self.array_TakeOverTimings.append(time)
                DispatchQueue.main.async {
                self.collection_TakeOverTiming.reloadData()
                self.tableView.reloadData()
                }
            }
        }
        else{
            if !self.array_InspectionTimings.contains(time){
                self.array_InspectionTimings.append(time)
                DispatchQueue.main.async {
                self.collection_InspectionTiming.reloadData()
                self.tableView.reloadData()
                }
            }
        }
        
    }
    
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, dates: [Date]) {
        print("Selected Multiple Dates \n\(dates)\n---")
        if let date = dates.first {
           singleDate = date
      //      dateLabel.text = date.stringFromFormat("d' 'MMMM' 'yyyy', 'h':'mma")
        }
        else {
       //     dateLabel.text = "No Date Selected"
        }
        self.showBottomMenu()
        if isTakeOver == true{
        multipleDates_TakeOver = dates
        }
        else{
            multipleDates_Inspection = dates
        }
        var selectedDates = ""
        for obj in dates{
            let date = obj.stringFromFormat("yyyy-MM-dd")
            selectedDates += date + ","
        }
        if dates.count > 0{
            selectedDates.removeLast()
        }
        if isTakeOver == true{
        txtView_TakeOverDates.text = selectedDates
        }
        else{
            txtView_InspectionDates.text = selectedDates
        }
        
        DispatchQueue.main.async {
       
        self.tableView.reloadData()
        }
    }
}
extension ManageAppointmentTableViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1{
            return  array_TakeOverTimings.count + 1
        }
        else{
            return array_InspectionTimings.count + 1
        }
        
       
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        if collectionView == collection_TakeOverTiming{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "takeoverCell", for: indexPath) as! TimingCollectionViewCell
        cell.view_Outer.layer.cornerRadius = 6.0

        cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.gray, radius: 3.0, opacity: 0.35)
       
            if indexPath.row < array_TakeOverTimings.count{
                cell.btn_Add.isHidden = true
                cell.btn_Close.isHidden = false
                cell.lbl_Time.isHidden = false
                cell.view_Outer.backgroundColor = .white
                cell.lbl_Time.text = self.array_TakeOverTimings[indexPath.item]
                cell.btn_Close.tag = indexPath.row
                cell.btn_Close.addTarget(self, action: #selector(ManageAppointmentTableViewController.actionRemoveTakeOverTime(_:)), for: .primaryActionTriggered)
            }
            else{
               
                cell.btn_Add.isHidden = false
                cell.btn_Close.isHidden = true
                cell.lbl_Time.isHidden = true
                cell.view_Outer.backgroundColor = .clear
                cell.btn_Add.addTarget(self, action: #selector(ManageAppointmentTableViewController.actionAddTakeOverTime(_:)), for: .primaryActionTriggered)
            }
            return cell
        }
        else{
            
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "inspectionCell", for: indexPath) as! TimingCollectionViewCell
            cell.view_Outer.layer.cornerRadius = 6.0

            cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.gray, radius: 3.0, opacity: 0.35)
            if indexPath.row < array_InspectionTimings.count{
                cell.btn_Add.isHidden = true
                cell.btn_Close.isHidden = false
                cell.lbl_Time.isHidden = false
                cell.view_Outer.backgroundColor = .white
                cell.lbl_Time.text = self.array_InspectionTimings[indexPath.item]
                cell.btn_Close.tag = indexPath.row
                cell.btn_Close.addTarget(self, action: #selector(ManageAppointmentTableViewController.actionRemoveInspectionTime(_:)), for: .primaryActionTriggered)
            }
            else{
               
                cell.btn_Add.isHidden = false
                cell.btn_Close.isHidden = true
                cell.lbl_Time.isHidden = true
                cell.view_Outer.backgroundColor = .clear
                cell.btn_Add.addTarget(self, action: #selector(ManageAppointmentTableViewController.actionAddInspectionTime(_:)), for: .primaryActionTriggered)
            }
                return cell
        
        }
     
      
      
    }
    @IBAction func actionRemoveTakeOverTime(_ sender: UIButton){
       
            self.array_TakeOverTimings.remove(at: sender.tag)
        DispatchQueue.main.async {
        self.collection_TakeOverTiming.reloadData()
      //  self.collection_InspectionTiming.reloadData()
        self.tableView.reloadData()
        }
        
    }
    @IBAction func actionRemoveInspectionTime(_ sender: UIButton){
       
            self.array_InspectionTimings.remove(at: sender.tag)
        DispatchQueue.main.async {
       // self.collection_TakeOverTiming.reloadData()
        self.collection_InspectionTiming.reloadData()
        self.tableView.reloadData()
        }
        
    }
}
extension ManageAppointmentTableViewController: AlertViewDelegate{
    func onBackClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func onCloseClicked() {
        
    }
    
    func onOkClicked() {
     //   deletFeedback()
    }
    
    
}
extension ManageAppointmentTableViewController: MessageAlertViewDelegate{
    func onHomeClicked() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func onListClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
