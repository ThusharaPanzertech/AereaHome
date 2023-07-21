//
//  AddEditFacilityTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 27/09/21.
//

import UIKit
import DropDown

class AddEditFacilityTableViewController:BaseTableViewController {
    fileprivate var singleDate: Date = Date()
    fileprivate var multipleDates: [Date] = []
    //Outlets
    @IBOutlet  var arr_ViewsToHide: [UIView]!
    @IBOutlet weak var view_SwitchProperty: UIView!
    @IBOutlet weak var lbl_SwitchProperty: UILabel!
    @IBOutlet weak var space_NextBooking: NSLayoutConstraint!
    @IBOutlet weak var ht_Collection: NSLayoutConstraint!
    @IBOutlet weak var ht_Notes: NSLayoutConstraint!
    @IBOutlet weak var collection_FacilityTiming: UICollectionView!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var txt_NoOfDays: UITextField!
    @IBOutlet weak var txt_FacilityName: UITextField!
    @IBOutlet weak var txt_BookingAvailable: UITextField!
    @IBOutlet weak var txt_NextBooking: UITextField!
    @IBOutlet weak var txt_Notes: UITextView!
    @IBOutlet weak var lbl_MsgTitle: UILabel!
    @IBOutlet weak var lbl_MsgDesc: UILabel!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var imgView_Profile: UIImageView!
    @IBOutlet weak var btn_Submit: UIButton!
    @IBOutlet weak var btn_Delete: UIButton!
    @IBOutlet  var arr_Btns: [UIButton]!
    @IBOutlet  var arr_Textfield: [UITextField]!
    @IBOutlet weak var bottomSpace: NSLayoutConstraint!
    var timeInterval = ""
    var array_FacilityTimings = [String]()
    var isInterval: Bool!
    var facility: FacilityType!
    var isToDelete = false
    var isToEdit: Bool!
    let alertView: AlertView = AlertView.getInstance
    let alertView_message: MessageAlertView = MessageAlertView.getInstance
    let menu: MenuView = MenuView.getInstance
    var isToShowSucces = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionViewLayout()
        lbl_MsgTitle.text = "Facility Type\n Added"
        lbl_MsgDesc.text = "The requested facility type has\n been added into the list."
          let fname = Users.currentUser?.moreInfo?.first_name ?? ""
        let lname = Users.currentUser?.moreInfo?.last_name ?? ""
        self.lbl_UserName.text = "\(fname) \(lname)"
        let role = Users.currentUser?.role
        self.lbl_UserRole.text = role
        imgView_Profile.addborder()
        for btn in arr_Btns{
            btn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
            btn.layer.cornerRadius = 8.0
        }
        for field in arr_Textfield{
            field.layer.cornerRadius = 20.0
            field.layer.masksToBounds = true
            field.delegate = self
            field.textColor = textColor
            field.attributedPlaceholder = NSAttributedString(string: field.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
            field.backgroundColor = isToEdit ? UIColor.white : UIColor(red: 208/255, green: 208/255, blue: 208/255, alpha: 1.0)
        }
        view_SwitchProperty.layer.borderColor = themeColor.cgColor
        view_SwitchProperty.layer.borderWidth = 1.0
        view_SwitchProperty.layer.cornerRadius = 10.0
        view_SwitchProperty.layer.masksToBounds = true
        collection_FacilityTiming.layer.cornerRadius = 15
        collection_FacilityTiming.layer.masksToBounds = true
        lbl_SwitchProperty.text = kCurrentPropertyName
        txt_Notes.layer.cornerRadius = 15
        txt_Notes.layer.masksToBounds = true
            collection_FacilityTiming.backgroundColor = isToEdit ? UIColor.white : UIColor(red: 208/255, green: 208/255, blue: 208/255, alpha: 1.0)
        txt_Notes.backgroundColor = isToEdit ? UIColor.white : UIColor(red: 208/255, green: 208/255, blue: 208/255, alpha: 1.0)
        if self.facility != nil{
            self.txt_FacilityName.text = facility.facility_type
            txt_NextBooking.text =  facility.next_booking_allowed == 1 ? "None" :
                facility.next_booking_allowed == 2 ? "Month" :
            "Days"
            if facility.next_booking_allowed  == 3{
                space_NextBooking.constant = 130
                for vw in arr_ViewsToHide{
                    vw.isHidden = false
                }
                txt_NoOfDays.text = "\(facility.next_booking_allowed_days)"
            }
            else{
                space_NextBooking.constant = 20
                for vw in arr_ViewsToHide{
                    vw.isHidden = true
                }
            }
            txt_BookingAvailable.text = "\(facility.allowed_booking_for)"
            btn_Delete.isHidden = false
            btn_Submit.setTitle("Save", for: .normal)
            let timing = facility.timing.components(separatedBy: ",")
            for obj in timing{
              let  time = obj.replacingOccurrences(of: "-", with: "\n-")
                array_FacilityTimings.append(time)
                self.collection_FacilityTiming.reloadData()
            }
        }
        else{
            btn_Delete.isHidden = true
            btn_Submit.setTitle("Submit", for: .normal)
            bottomSpace.constant = 40
            space_NextBooking.constant = 20
            for vw in arr_ViewsToHide{
                vw.isHidden = true
            }
        }
        //ToolBar
          let toolbar = UIToolbar();
          toolbar.sizeToFit()
          let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([spaceButton,doneButton], animated: false)
        txt_Notes.inputAccessoryView = toolbar
        txt_NoOfDays.inputAccessoryView = toolbar
        txt_BookingAvailable.inputAccessoryView = toolbar
       // txt_Notes.a
        if isToEdit == true{
            txt_Notes.textColor = txt_Notes.text == "Facility Notes" ? placeholderColor :
                textColor
        }
        else{
            txt_Notes.textColor = placeholderColor
        }
        txt_Notes.delegate = self
        if isToEdit == true{
        let htmlData = NSString(string:facility.notes).data(using: String.Encoding.unicode.rawValue)
         
         let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
         
         let attributedString = try! NSMutableAttributedString(data: htmlData!, options: options, documentAttributes: nil)
         
         attributedString.addAttribute(NSAttributedString.Key.font,
                                       value: UIFont(name: "Helvetica-Bold", size: 15.0)!,
                                       range: NSRange(location: 0, length: attributedString.length))
         attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                       value: UIColor.black,
                                       range: NSRange(location: 0, length: attributedString.length))
        var height: CGFloat!
        if isValidHtmlString(facility.notes) == true{
        txt_Notes.attributedText = attributedString
            height = attributedString.height(containerWidth: kScreenSize.width - 50)
        }
        else{
            txt_Notes.text = facility.notes
            height = self.heightForView(text:"\(facility.notes)", font:UIFont(name: "Helvetica-Bold", size: 15.0)!, width:kScreenSize.width - 50)
        }
        ht_Notes.constant = height < 250 ? 250 : height + 100
        self.tableView.reloadData()
        }
    }
    @objc func done(){
        self.view.endEditing(true)
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
    collection_FacilityTiming.collectionViewLayout = layout
    
}
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        self.showBottomMenu()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.closeMenu()
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1{
            let count1 = array_FacilityTimings.count + 1
            let ht_Coll1 = (Int(count1/3) + (Int(count1%3) > 0 ? 1  : 0) ) * 55 + 50
            ht_Collection.constant = CGFloat(ht_Coll1)
            return CGFloat(self.isToShowSucces == true ? 0 :  ht_Coll1 + 700 + Int(ht_Notes.constant))
        }
        else  if indexPath.row == 2{
            return self.isToShowSucces == false ? 0 : kScreenSize.height - 210
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
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
    
    //MARK: ***************  PARSING ***************
    func createFacilityType(){
       ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        var timing = array_FacilityTimings.joined(separator: ",")
        timing = timing.replacingOccurrences(of: "\n", with: "")
        let nxt_booking  = txt_NextBooking.text == "Days" ? txt_NoOfDays.text : ""
        let param = [
            "login_id" : userId,
            "facility_type" : txt_FacilityName.text!,
            "next_booking_allowed" : txt_NextBooking.text == "None" ? 1 : txt_NextBooking.text == "Month" ? 2 : 3,
            "allowed_booking_for" : txt_BookingAvailable.text!,
            "next_booking_allowed_days": nxt_booking!,
            "timing" : timing,
            "notes" : txt_Notes.text!
            
        ] as [String : Any]

        ApiService.create_FacilityType(parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? CreateFeedbackOptionBase){
                    if response.response == 1{
                        self.isToShowSucces =  true
                        DispatchQueue.main.async {
                        self.tableView.reloadData()
                            let indexPath = NSIndexPath(row: 0, section: 0)
                            self.tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: false)
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
    func updateFacilityType(){
        ActivityIndicatorView.show("Loading")
         let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
         var timing = array_FacilityTimings.joined(separator: ",")
         timing = timing.replacingOccurrences(of: "\n", with: "")
        let nxt_booking  = txt_NextBooking.text == "Days" ? txt_NoOfDays.text : ""
         let param = [
             "login_id" : userId,
             "facility_type" : txt_FacilityName.text!,
             "next_booking_allowed" : txt_NextBooking.text == "None" ? 1 : txt_NextBooking.text == "Month" ? 2 : 3,
             "allowed_booking_for" : txt_BookingAvailable.text!,
            "next_booking_allowed_days": nxt_booking!,
             "timing" : timing,
             "notes" : txt_Notes.text!,
            "id": self.facility.id
             
         ] as [String : Any]

        ApiService.update_FacilityType(parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? CreateFeedbackOptionBase){
                    if response.response == 1{
                        self.alertView_message.delegate = self
                        self.alertView_message.showInView(self.view_Background, title: "Facility Type\n changes has been\n saved", okTitle: "Home", cancelTitle: "View Facility Types")
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
    
    func deleteFacilityType(){
       
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
       
        let param = [
            "login_id" : userId,
            "id" : self.facility.id,
          
        ] as [String : Any]

        ApiService.delete_FacilityType(parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
            self.isToDelete  = false
            if status  && result != nil{
                 if let response = (result as? DeleteUserBase){
                    if response.response == 1{
                        DispatchQueue.main.async {
                            self.alertView_message.delegate = self
                            self.alertView_message.showInView(self.view_Background, title: "Facility Type has\n been deleted", okTitle: "Home", cancelTitle: "View Facility Types")
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
 
    //MARK: BUTTON ACTIONS
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
    @IBAction func action_NextBookingAvailable(_ sender:UIButton) {
       
        let dropDown_NextBooking = DropDown()
        dropDown_NextBooking.anchorView = sender // UIView or UIBarButtonItem
        dropDown_NextBooking.dataSource = ["None", "Month", "Days"]
        dropDown_NextBooking.show()
        dropDown_NextBooking.selectionAction = { [unowned self] (index: Int, item: String) in
            txt_NextBooking.text = item
            if item  == "Days"{
                space_NextBooking.constant = 130
                for vw in arr_ViewsToHide{
                    vw.isHidden = false
                }
            }
            else{
                space_NextBooking.constant = 20
                for vw in arr_ViewsToHide{
                    vw.isHidden = true
                }
            }
            
        }
    }
    @IBAction func actionFacilityTimeSlots(_ sender: UIButton){
        self.closeMenu()
        let dropDown_NextBooking = DropDown()
        dropDown_NextBooking.anchorView = sender // UIView or UIBarButtonItem
        dropDown_NextBooking.dataSource = [ "Time", "Time Interval"]
        dropDown_NextBooking.show()
        dropDown_NextBooking.selectionAction = { [unowned self] (index: Int, item: String) in
            
            if index == 0{
                self.isInterval = false
            }
            else{
                self.isInterval = true
            }
            self.showTimePicker()
        }
        
        
    }
    func showTimePicker(){
        self.dismiss(animated: true, completion: nil)
        let selector = UIStoryboard(name: "WWCalendarTimeSelector", bundle: nil).instantiateInitialViewController() as! WWCalendarTimeSelector
        selector.delegate = self
        selector.optionCurrentDate = singleDate
        selector.optionCurrentDates = Set(multipleDates)
        selector.optionCurrentDateRange.setStartDate(multipleDates.first ?? singleDate)
        selector.optionCurrentDateRange.setEndDate(multipleDates.last ?? singleDate)
        selector.optionStyles.showDateMonth(false)
        selector.optionStyles.showMonth(false)
        selector.optionStyles.showYear(false)
        selector.optionStyles.showTime(true)
        present(selector, animated: true, completion: nil)
    }
    @IBAction func actionDelete(_ sender: UIButton){
        showDeleteAlert()
        
    }
    func showDeleteAlert(){
        isToDelete = true
        alertView.delegate = self
        alertView.showInView(self.view_Background, title: "Are you sure you want to\n delete the following\n facility type?", okTitle: "Yes", cancelTitle: "Back")
      
    }
    @IBAction func actionCreateRole(_ sender: UIButton){
        let feedbackoption = txt_FacilityName.text?.replacingOccurrences(of: " ", with: "")
        if txt_FacilityName.text == ""{
            displayErrorAlert(alertStr: "Please enter facility name", title: "")
        }
        else if feedbackoption == ""{
            displayErrorAlert(alertStr: "Please enter a valid facility name", title: "")
        }
        else if  txt_BookingAvailable.text == ""{
            displayErrorAlert(alertStr: "Please enter booking available", title: "")
        }
        else if  txt_NextBooking.text == ""{
            displayErrorAlert(alertStr: "Please enter next booking allowed", title: "")
        }
        else if  txt_NextBooking.text == "Days" && txt_NoOfDays.text == ""{
            displayErrorAlert(alertStr: "Please enter the number of days", title: "")
        }
        else if array_FacilityTimings.count == 0{
            displayErrorAlert(alertStr: "Please enter the time slots", title: "")
        }
        else{
            if isToEdit == true {
                updateFacilityType()
            }
            else{
                self.createFacilityType()
            }
            
        }
    }
    @IBAction func actionBackPressed(_ sender: UIButton){
        self.view.endEditing(true)
        if isToEdit{
            self.navigationController?.popViewController(animated: true)
        }
        else{
        alertView.delegate = self
        alertView.showInView(self.view_Background, title: "Are you sure you want to\n leave this page?\nYour changes would not\n be saved.", okTitle: "Yes", cancelTitle: "Back")
        }
    }
    //MARK: MENU ACTIONS
  
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
extension AddEditFacilityTableViewController: MenuViewDelegate{
    func onMenuClicked(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            self.menu.contractMenu()
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
extension AddEditFacilityTableViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
       
        return true
    }
   
}
extension AddEditFacilityTableViewController: AlertViewDelegate{
    func onBackClicked() {
    }
    
    func onCloseClicked() {
        
    }
    
    func onOkClicked() {
        if isToDelete == true{
            deleteFacilityType()
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
}
extension AddEditFacilityTableViewController: MessageAlertViewDelegate{
    func onHomeClicked() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func onListClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
extension AddEditFacilityTableViewController: WWCalendarTimeSelectorProtocol{
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        print("Selected \n\(date)\n---")
        singleDate = date
        if isInterval == false{
        self.showBottomMenu()
            let time = date.stringFromFormat("h':'mm a")
           
       
            if !self.array_FacilityTimings.contains(time){
                self.array_FacilityTimings.append(time)
                DispatchQueue.main.async {
                self.collection_FacilityTiming.reloadData()
                self.tableView.reloadData()
                }
            
            }
        }
        else{
            let time = date.stringFromFormat("h':'mm a")
            if self.timeInterval == ""{
                
            self.timeInterval = "\(time)-"
            self.showTimePicker()
            }
            else{
                self.timeInterval =  self.timeInterval + "\(time)"
                self.timeInterval = self.timeInterval.replacingOccurrences(of: "-", with: "\n-")
                if !self.array_FacilityTimings.contains(self.timeInterval){
                    self.array_FacilityTimings.append(self.timeInterval)
                    DispatchQueue.main.async {
                    self.collection_FacilityTiming.reloadData()
                    self.tableView.reloadData()
                        self.timeInterval = ""
                    }
            }
        }
        
    }
    }
    }
extension AddEditFacilityTableViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return  array_FacilityTimings.count + 1
        
        
       
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "takeoverCell", for: indexPath) as! TimingCollectionViewCell
        cell.view_Outer.layer.cornerRadius = 6.0

        cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.gray, radius: 3.0, opacity: 0.35)
       
            if indexPath.row < array_FacilityTimings.count{
                cell.btn_Add.isHidden = true
                cell.btn_Close.isHidden = false
                cell.lbl_Time.isHidden = false
                cell.view_Outer.backgroundColor = .white
                cell.lbl_Time.text = self.array_FacilityTimings[indexPath.item]
                cell.btn_Close.tag = indexPath.row
                cell.btn_Close.addTarget(self, action: #selector(AddEditFacilityTableViewController.actionRemoveTakeOverTime(_:)), for: .primaryActionTriggered)
            }
            else{
               
                cell.btn_Add.isHidden = false
                cell.btn_Close.isHidden = true
                cell.lbl_Time.isHidden = true
                cell.view_Outer.backgroundColor = .clear
                cell.btn_Add.addTarget(self, action: #selector(AddEditFacilityTableViewController.actionFacilityTimeSlots(_:)), for: .primaryActionTriggered)
            }
          
                return cell
        
        }
     
      
      
    
    @IBAction func actionRemoveTakeOverTime(_ sender: UIButton){
       
            self.array_FacilityTimings.remove(at: sender.tag)
        DispatchQueue.main.async {
            self.collection_FacilityTiming.reloadData()
            self.tableView.reloadData()
        }
        
    }
}
extension AddEditFacilityTableViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == placeholderColor {
                textView.text = nil
            textView.textColor = textColor
            }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
               textView.text = "Facility Notes"
               textView.textColor = placeholderColor
           }
    }
}
extension NSAttributedString {

    func height(containerWidth: CGFloat) -> CGFloat {

        let rect = self.boundingRect(with: CGSize.init(width: containerWidth, height: CGFloat.greatestFiniteMagnitude),
                                     options: [.usesLineFragmentOrigin, .usesFontLeading],
                                     context: nil)
        return ceil(rect.size.height)
    }

    func width(containerHeight: CGFloat) -> CGFloat {

        let rect = self.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: containerHeight),
                                     options: [.usesLineFragmentOrigin, .usesFontLeading],
                                     context: nil)
        return ceil(rect.size.width)
    }
}
