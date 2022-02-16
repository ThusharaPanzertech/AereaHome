//
//  EditFacilityTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 27/12/21.
//

import UIKit
import DropDown
class EditFacilityTableViewController: BaseTableViewController {
    
    //Outlets
    @IBOutlet weak var datePicker:  UIDatePicker!
    @IBOutlet weak var lbl_Facility: UILabel!
    @IBOutlet weak var lbl_BookedBy: UILabel!
    @IBOutlet weak var lbl_Date: UILabel!
    @IBOutlet weak var lbl_Time: UILabel!
    @IBOutlet weak var txt_Status: UITextField!
    @IBOutlet weak var txt_NewDate: UITextField!
    @IBOutlet weak var txt_NewTime: UITextField!
    @IBOutlet var arr_Textfields: [UITextField]!
    
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var imgView_Profile: UIImageView!
    @IBOutlet weak var view_Outer: UIView!
    @IBOutlet var arr_Buttons: [UIButton]!
    let alertView: AlertView = AlertView.getInstance
    let alertView_message: MessageAlertView = MessageAlertView.getInstance
    let menu: MenuView = MenuView.getInstance
    var facility: FacilityModal!
    var arrFacilityTimings = [FacilityTimeSlot]()
    var currentStatus = ""
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
        getFacilityTimeSlots()
       
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
        for txtField in arr_Textfields{
            txtField.layer.cornerRadius = 20.0
            txtField.layer.masksToBounds = true
        }
        view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
        view_Outer.layer.cornerRadius = 10.0
        txt_Status.layer.cornerRadius = 20.0
        txt_Status.layer.masksToBounds = true
        
        view_Background.layer.cornerRadius = 25.0
        view_Background.layer.masksToBounds = true
      
        imgView_Profile.addborder()
       
        self.configureDatePicker()
        for btn in arr_Buttons{
            btn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
            btn.layer.cornerRadius = 8.0
        }
        
        lbl_Facility.text = facility.type?.facility_type
        lbl_Time.text = facility.submissions.booking_time
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat =  "yyyy-MM-dd"
        let date = formatter.date(from: facility.submissions.booking_date)
        formatter.dateFormat = "dd/MM/yy"
        let dateStr = formatter.string(from: date ?? Date())
        lbl_Date.text = dateStr
        lbl_BookedBy.text = facility.user_info?.name
        txt_Status.text = facility.submissions.status == 0 ? "New" :
            facility.submissions.status == 1  ? "Cancelled" : facility.submissions.status == 2 ? "Confirmed" : ""
        currentStatus = facility.submissions.status == 0 ? "New" :
            facility.submissions.status == 1  ? "Cancelled" : facility.submissions.status == 2 ? "Confirmed" : ""
    }
    func configureDatePicker(){
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
      
        //ToolBar
          let toolbar = UIToolbar();
          toolbar.sizeToFit()
          let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
         let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)

   // add toolbar to textField
        txt_NewDate.inputAccessoryView = toolbar
    // add datepicker to textField
        txt_NewDate.inputView = datePicker

      }
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "dd/MM/yy"
            txt_NewDate.text = formatter.string(from: datePicker.date)
            self.view.endEditing(true)
        txt_NewTime.text = ""
        
        formatter.dateFormat = "yyyy-MM-dd"
     //   let selectedDate = formatter.string(from: datePicker.date)
//        let title = self.appointment == .unitTakeOver ? "Key Collection" : "Defect Inspection"
//        if blockOutDates.contains(selectedDate){
//            self.displayErrorAlert(alertStr: "\(title) not available for the selected date", title: "Alert")
//        }
//        else{
        getFacilityTimeSlots()
       // }
        
    }

    @objc func cancelDatePicker(){
       self.view.endEditing(true)
     }
    //MARK: ******  PARSING *********
   
    func getFacilityTimeSlots(){
        ActivityIndicatorView.show("Loading")
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd/mm/yy"
        let date = formatter.date(from: txt_NewDate.text!)
        formatter.dateFormat = "yyyy-MM-dd"
        let dateStr = formatter.string(from: date ?? Date())
        
        
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"        //
        ApiService.get_FacilityTimings(parameters: ["login_id":userId, "date": dateStr, "type" : facility.submissions.type_id], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? FacilityTimeSlotBase){
                    self.arrFacilityTimings = response.data
                   
                   
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
    
    func updateFacility(){
       
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
     
        let id = facility.submissions.id
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd/mm/yy"
        let date = formatter.date(from: txt_NewDate.text!)
        formatter.dateFormat = "yyyy-MM-dd"
        let dateStr = formatter.string(from: date ?? Date())
        
        let param = [
            "login_id" : userId,
            "id" : id,
            "booking_date": dateStr,
            "booking_time" : txt_NewTime.text!,
            "status": txt_Status.text == "New" ? 0 :
                txt_Status.text == "Cancelled" ? 1 : 2
            
        ] as [String : Any]

        ApiService.update_Facility(parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? DeleteUserBase){
                    if response.response == 1{
                        DispatchQueue.main.async {
                            self.alertView_message.delegate = self
                            self.alertView_message.showInView(self.view_Background, title: "Facility changes\n has been saved", okTitle: "Home", cancelTitle: "View Facilities List")
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
    func cancelFacility(){
       
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
     
        let id = facility.submissions.id
        let param = [
            "login_id" : userId,
            "id" : id,
          
        ] as [String : Any]

        ApiService.delete_Facility(parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? DeleteUserBase){
                    if response.response == 1{
                        DispatchQueue.main.async {
                            self.alertView_message.delegate = self
                            self.alertView_message.showInView(self.view_Background, title: "Facility request has\n been cancelled", okTitle: "Home", cancelTitle: "View Facilities List")
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
    @IBAction func actionStatus(_ sender:UIButton) {
       
        let dropDown_Status = DropDown()
        dropDown_Status.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Status.dataSource = ["New", "Confirmed", "Cancelled"]// Array(unitsData.values)
        dropDown_Status.show()
        dropDown_Status.selectionAction = { [unowned self] (index: Int, item: String) in
           
            txt_Status.text = item
          
            
        }
    }
    @IBAction func actionNewTimeSlot(_ sender: UIButton){
        let dropDown_TimeSlot = DropDown()
        dropDown_TimeSlot.anchorView = sender
        dropDown_TimeSlot.dataSource = arrFacilityTimings.map { $0.time }
        dropDown_TimeSlot.show()
        dropDown_TimeSlot.selectionAction = { [unowned self] (index: Int, item: String) in
        sender.setTitle(item, for: .normal)
            
            
            let type =  self.arrFacilityTimings.first(where:{ $0.time == item })
            let count = type?.count ?? 0
            if count != 0{
                self.displayErrorAlert(alertStr: "Timeslot already taken", title: "Alert")
            }
           
        }
       
    }
    @IBAction func actionSave(_ sender: UIButton){
        
        self.view.endEditing(true)
        if txt_Status.text == currentStatus && txt_NewTime.text == "" && txt_NewDate.text == ""{
            displayErrorAlert(alertStr: "Nothing to save", title: "")
        }
        else if txt_NewDate.text!.count  > 0 && txt_NewTime.text == ""{
            displayErrorAlert(alertStr: "Please enter the new  name", title: "")
        }
        else if txt_NewTime.text!.count  > 0 && txt_NewDate.text == ""{
            displayErrorAlert(alertStr: "Please enter the new date", title: "")
        }
        else{
        updateFacility()
        }
//        guard txt_NewTime.text!.count  > 0 else {
//            displayErrorAlert(alertStr: "Please enter the new  name", title: "")
//            return
//        }
//        guard txt_LastName.text!.count  > 0 else {
//            displayErrorAlert(alertStr: "Please enter the last name", title: "")
//            return
//        }
//        guard txt_UnitNo.text!.count  > 0 else {
//            displayErrorAlert(alertStr: "Please select the unit", title: "")
//            return
//        }
//        guard txt_Contact.text!.count  > 0 else {
//            displayErrorAlert(alertStr: "Please enter the contact number", title: "")
//            return
//        }
        
      
    }
    @IBAction func actionCancelBooking(_ sender: UIButton){
        alertView.delegate = self
        alertView.showInView(self.view_Background, title: "Are you sure you want to\n cancel the following\nfacility request?", okTitle: "Yes", cancelTitle: "Back")
    }
    //MARK: MENU ACTIONS
   
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


    
extension EditFacilityTableViewController: AlertViewDelegate{
    func onBackClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func onCloseClicked() {
        
    }
    
    func onOkClicked() {
        self.cancelFacility()
    }
    
    
}
extension EditFacilityTableViewController: MessageAlertViewDelegate{
    func onHomeClicked() {
        selectedRowIndex_Appointment = -1
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func onListClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
extension EditFacilityTableViewController: MenuViewDelegate{
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

   
   


