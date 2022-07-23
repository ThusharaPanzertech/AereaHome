//
//  EditJointInspectionTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 25/05/22.
//

import UIKit
import DropDown

class EditJointInspectionTableViewController: BaseTableViewController {

    //Outlets
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var txt_Date: UITextField!
    @IBOutlet weak var txt_TimeSlot: UITextField!
    @IBOutlet weak var txt_ApptStatus: UITextField!
    @IBOutlet weak var txt_HandoverDate: UITextField!
    @IBOutlet weak var txt_Reminder: UITextField!
    @IBOutlet weak var txtView_email: UITextView!
    @IBOutlet weak var txtView_message: UITextView!
    @IBOutlet var arr_ViewsToHide: [UIView]!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var view_apptBackground: UIView!
    @IBOutlet weak var imgView_Profile: UIImageView!
    @IBOutlet weak var btn_Submit: UIButton!
    @IBOutlet weak var datePicker:  UIDatePicker!
    @IBOutlet var arr_Buttons: [UIButton]!
    @IBOutlet weak var collection_TimeSlot: UICollectionView!
    @IBOutlet weak var topSpace: NSLayoutConstraint!
    let alertView: AlertView = AlertView.getInstance
    let alertView_message: MessageAlertView = MessageAlertView.getInstance
    let menu: MenuView = MenuView.getInstance
    var defectDetail: DefectData!
    var array_Time = [String]()
    var array_TakenSlots = [String]()
    var selected_Time = ""
    
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
        showDatePicker()
        getInspectionTimings()
        collection_TimeSlot.dataSource = self
        collection_TimeSlot.delegate = self
        let layout =  UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let cellWidth = (kScreenSize.width - 120)/CGFloat(3.0)
        let size = CGSize(width: cellWidth, height: 40)
        layout.itemSize = size
        collection_TimeSlot.collectionViewLayout = layout
    
        self.collection_TimeSlot.reloadData()
        
        if self.defectDetail.inspection == nil{
            topSpace.constant = 50
            for vw in arr_ViewsToHide{
                vw.isHidden = true
            }
        }
        else{
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd"
            let date = formatter.date(from: defectDetail.inspection!.appt_date)
            formatter.dateFormat = "dd/MM/yy"
            let dateStr = formatter.string(from: date ?? Date())
            
                txt_Date.text = dateStr
                txt_TimeSlot.text = defectDetail.inspection!.appt_time
                
            txt_ApptStatus.text = defectDetail.inspection!.status == 0 ? "New" :
            defectDetail.inspection!.status == 1  ? "Cancelled" :
            defectDetail.inspection!.status == 2 ? "On Schedule" :
            defectDetail.inspection!.status == 3 ?   "Done" :
            defectDetail.inspection!.status == 4  ? "In Progress" : ""
                
            if defectDetail.inspection!.status == 4 {
                topSpace.constant = 400
                for vw in arr_ViewsToHide{
                    vw.isHidden = false
                }
            }
            else{
                topSpace.constant = 50
                for vw in arr_ViewsToHide{
                    vw.isHidden = true
                }
            }
        
        }
        txtView_email.text = "Enter Email"
        txtView_email.textColor = placeholderColor
        txtView_message.text = "Enter Message"
        txtView_message.textColor = placeholderColor
    }
    
    func getInspectionTimings(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        ApiService.get_InspectionTimings(parameters: ["login_id":userId  ], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                if let response = (result as? DefectInspectionTimeSlotBase){
                    self.array_Time = response.data.map{ $0.time }
                    DispatchQueue.main.async {
                       
                   self.collection_TimeSlot.reloadData()
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
    func showDatePicker(){
      //Formate Date
        datePicker.datePickerMode = .date
         // Get right now as it's `DateComponents`.
         let now = Calendar.current.dateComponents(in: .current, from: Date())

         // Create the start of the day in `DateComponents` by leaving off the time.
         let today = DateComponents(year: now.year, month: now.month, day: now.day)
         let dateToday = Calendar.current.date(from: today)!
         
         let twodaysAhead = DateComponents(year: now.year, month: now.month, day: now.day! + 2)
         let date_twodaysAhead = Calendar.current.date(from: twodaysAhead)!
         datePicker.minimumDate = date_twodaysAhead
        

//        //ToolBar
          let toolbar = UIToolbar();
          toolbar.sizeToFit()
          let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
         let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)

   // add toolbar to textField
        txt_Date.inputAccessoryView = toolbar
    // add datepicker to textField
        txt_Date.inputView = datePicker
        txt_HandoverDate.inputAccessoryView = toolbar
        txt_HandoverDate.inputView = datePicker
      }
    @objc func donedatePicker(){
        
            let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "dd/MM/yy"
        if txt_Date.becomeFirstResponder(){
            txt_Date.text = formatter.string(from: datePicker.date)
        }
        else{
            txt_HandoverDate.text = formatter.string(from: datePicker.date)
        }
            self.view.endEditing(true)
        
    }

    @objc func cancelDatePicker(){
       self.view.endEditing(true)
     }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        if indexPath.row == 1{
            return super.tableView(tableView, heightForRowAt: indexPath)
            //defectDetail == nil ? 680 : CGFloat((350 * defectDetail.submissions.count) + 660)
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    
    }
    func setUpUI(){
        txt_Date.textColor = textColor
        txt_Date.attributedPlaceholder = NSAttributedString(string: txt_Date.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
        txt_Date.layer.cornerRadius = 20.0
        txt_Date.layer.masksToBounds = true
        txt_TimeSlot.textColor = textColor
        txt_TimeSlot.layer.cornerRadius = 20.0
        txt_TimeSlot.layer.masksToBounds = true
        txt_ApptStatus.layer.cornerRadius = 20.0
        txt_ApptStatus.layer.masksToBounds = true
        txt_HandoverDate.layer.cornerRadius = 20.0
        txt_HandoverDate.layer.masksToBounds = true
        txt_Reminder.layer.cornerRadius = 20.0
        txt_Reminder.layer.masksToBounds = true
        for btn in arr_Buttons{
            btn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
            btn.layer.cornerRadius = 8.0
        }
        
        view_Background.layer.cornerRadius = 25.0
        view_Background.layer.masksToBounds = true
      
        imgView_Profile.addborder()
       
        txtView_email.layer.cornerRadius = 15
        txtView_email.layer.masksToBounds = true
        txtView_message.layer.cornerRadius = 15
        txtView_message.layer.masksToBounds = true
        //ToolBar
          let toolbar = UIToolbar();
          toolbar.sizeToFit()
          let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([spaceButton,doneButton], animated: false)
        txtView_email.inputAccessoryView = toolbar
        txtView_message.inputAccessoryView = toolbar
        txtView_email.delegate = self
        txtView_message.delegate = self
      
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showBottomMenu()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.closeMenu()
    }
    @objc func done(){
        self.view.endEditing(true)
    }
    func showBottomMenu(){
    
    menu.delegate = self
    menu.showInView(self.view, title: "", message: "")
  
}
func closeMenu(){
    menu.removeView()
}
    //MARK: ******  PARSING *********
    func updateInspection(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd/MM/yy"
        let date_Appt = formatter.date(from: txt_Date.text!)
        let date_Handover = formatter.date(from: txt_HandoverDate.text!)
        formatter.dateFormat = "yyyy-MM-dd"
        let dateStr_Appt = formatter.string(from: date_Appt ?? Date())
        let dateStr_Handover = date_Handover == nil ? "" : formatter.string(from: date_Appt ?? Date())
        
        let status = txt_ApptStatus.text == "New" ? "0" :
        txt_ApptStatus.text ==  "On Schedule" ? "2"  :
        txt_ApptStatus.text ==    "Done" ? "3"  :
        txt_ApptStatus.text ==  "In Progress" ? "4"  : ""
        
        //
        ApiService.update_InspectionAppointment(parameters: ["login_id":userId, "id" : self.defectDetail.id, "appt_date" : dateStr_Appt, "appt_time" :  txt_TimeSlot.text!, "inspection_status" : status, "progress_date" : dateStr_Handover, "reminder_in_days" : txt_Reminder.text!, "reminder_emails" : txtView_email.text! ], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? DeleteUserBase){
                     if response.response == 1{
                         DispatchQueue.main.async {
                             self.alertView_message.delegate = self
                             self.alertView_message.showInView(self.view_Background, title: "Appointment details edited successfully", okTitle: "Home", cancelTitle: "View Defect List")
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
    //MARK: UIButton ACTIONS
        @IBAction func actionStatus(_ sender:UIButton) {
           
            let dropDown_Status = DropDown()
            dropDown_Status.anchorView = sender // UIView or UIBarButtonItem
            dropDown_Status.dataSource = ["New", "On Schedule", "In Progress", "Done"]// Array(unitsData.values)
            dropDown_Status.show()
            dropDown_Status.selectionAction = { [unowned self] (index: Int, item: String) in
                
                txt_ApptStatus.text = item
               
                if index == 2{
                   
                        topSpace.constant = 400
                        for vw in arr_ViewsToHide{
                            vw.isHidden = false
                        }
                    
                   
                }
                else{
                   
                        topSpace.constant = 50
                        for vw in arr_ViewsToHide{
                            vw.isHidden = true
                        }
                    
                }
                
            }
        }
    @IBAction func actionSubmit(_ sender: UIButton){
        if txt_ApptStatus.text == ""{
            self.displayErrorAlert(alertStr: "Please select the appointment status", title: "")
        }
        else if txt_Date.text == ""{
            self.displayErrorAlert(alertStr: "Please select the appointment date", title: "")
        }
        else if txt_TimeSlot.text == ""{
            self.displayErrorAlert(alertStr: "Please select the appointment time", title: "")
        }else{
            if txt_ApptStatus.text == "In Progress"{
                if txt_HandoverDate.text == ""{
                    self.displayErrorAlert(alertStr: "Please select the key handover date", title: "")
                }
                else if txt_Reminder.text == ""{
                    self.displayErrorAlert(alertStr: "Please set the reminder in days", title: "")
                }
                else if txtView_email.text == ""{
                    self.displayErrorAlert(alertStr: "Please enter the email addresses", title: "")
                }
                else{
                    self.updateInspection()
                }
            }
            else{
                self.updateInspection()
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

extension EditJointInspectionTableViewController: AlertViewDelegate{
    func onBackClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func onCloseClicked() {
        
    }
    
    func onOkClicked() {
       // self.deleteDefectList()
//        alertView_message.delegate = self
//        alertView_message.showInView(self.view_Background, title: "Defect list changes\n has been saved", okTitle: "Home", cancelTitle: "View defect List")
    }
    
    
}
extension EditJointInspectionTableViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array_Time.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "timeslotCell", for: indexPath) as! TimeSlotCollectionViewCell
        var time = self.array_Time[indexPath.item].replacingOccurrences(of: " ", with: "")
        time = time.replacingOccurrences(of: "-", with: "\n-")
        cell.lbl_Time.text = time
        cell.view_Outer.layer.cornerRadius = 10.0
        cell.view_Outer.layer.masksToBounds = true
        let timeSel = self.array_Time[indexPath.item]
        cell.view_Outer.backgroundColor = array_TakenSlots.contains(timeSel) ? UIColor.systemGray : UIColor.white
        if timeSel == selected_Time{
            cell.view_Outer.layer.borderColor = UIColor.black.cgColor
            cell.view_Outer.layer.borderWidth = 2.0
        }
        else{
            cell.view_Outer.layer.borderColor = UIColor.black.cgColor
            cell.view_Outer.layer.borderWidth = 0.0
        }
        cell.view_Outer.tag = indexPath.item
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        cell.view_Outer.addGestureRecognizer(tap)
        return cell
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        let time = array_Time[(sender! as UITapGestureRecognizer).view!.tag]
        self.view.endEditing(true)
            if array_TakenSlots.contains(time){
            
            }
            else if time == selected_Time{
                selected_Time = ""
                self.collection_TimeSlot.reloadData()
            }
            else{
                selected_Time = time
                self.txt_TimeSlot.text = time
                self.collection_TimeSlot.reloadData()
            }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
extension EditJointInspectionTableViewController : MessageAlertViewDelegate{
    func onHomeClicked() {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func onListClicked() {
        var controller: UIViewController!
        for cntroller in self.navigationController!.viewControllers as Array {
            if cntroller.isKind(of: DefectsListTableViewController.self) {
                controller = cntroller
               
                break
            }
        }
        if controller != nil{
            self.navigationController!.popToViewController(controller, animated: true)
        }
        else{
        self.navigationController?.popViewController(animated: true)
    }
    
    }
}
extension EditJointInspectionTableViewController: MenuViewDelegate{
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

   
   
extension EditJointInspectionTableViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == placeholderColor {
                textView.text = nil
            textView.textColor = textColor
            }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = textView == txtView_email ?  "Enter Email" : "Enter Message"
               textView.textColor = placeholderColor
           }
    }
}
