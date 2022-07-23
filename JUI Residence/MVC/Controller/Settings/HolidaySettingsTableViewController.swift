//
//  HolidaySettingsTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 12/07/22.
//

import UIKit

class HolidaySettingsTableViewController: BaseTableViewController {
    
    //Outlets
   
    @IBOutlet weak var txt_Holidays: UITextView!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var imgView_Profile: UIImageView!

    var holidayInfo: HolidayInfo!
    let menu: MenuView = MenuView.getInstance
   
    fileprivate var singleDate: Date = Date()
    fileprivate var multipleDates_Holidays: [Date] = []
    
    @IBOutlet weak var btn_Submit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fname = Users.currentUser?.user?.name ?? ""
        let lname = Users.currentUser?.moreInfo?.last_name ?? ""
        self.lbl_UserName.text = "\(fname) \(lname)"
        let role = Users.currentUser?.role?.name ?? ""
        self.lbl_UserRole.text = role
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
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupUI()
        getHolidayInfo()
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
    
    override func getBackgroundImageName() -> String {
        let imgdefault = ""//UserInfoModalBase.currentUser?.data.property.defect_bg ?? ""
        return imgdefault
    }
    
    func setupUI(){
        txt_Holidays.textColor = textColor
        txt_Holidays.layer.cornerRadius = 20.0
        txt_Holidays.layer.masksToBounds = true
        view_Background.layer.cornerRadius = 25.0
        view_Background.layer.masksToBounds = true
        //ToolBar
          let toolbar = UIToolbar();
          toolbar.sizeToFit()
          let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([spaceButton,doneButton], animated: false)
        txt_Holidays.inputAccessoryView = toolbar
        
        txt_Holidays.contentInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        btn_Submit.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
        btn_Submit.layer.cornerRadius = 8.0
    }
    @objc func done(){
        self.view.endEditing(true)
    }
    //MARK: ******  PARSING *********
    func getHolidayInfo(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        
        ApiService.get_HolidayInfo(parameters: ["login_id":userId], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? HolidayInfoSummaryBase){
                     self.holidayInfo = response.data
                    
                     self.txt_Holidays.text = self.holidayInfo.public_holidays
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
    func submitHolidayInfo(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        
        let param = [
            "login_id" : userId,
            "id" : self.holidayInfo.id ?? 0,
            "public_holidays" : txt_Holidays.text!,
           
        ] as [String : Any]
        
        
        ApiService.submit_HolidayInfo(parameters: param, completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? HolidayInfoSummaryBase){
                     self.displayErrorAlert(alertStr: "Holiday dates updated", title: "Alert")
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
   
    @IBAction func actionHolidayDates(_ sender: UIButton){
        self.closeMenu()
        let selector = UIStoryboard(name: "WWCalendarTimeSelector", bundle: nil).instantiateInitialViewController() as! WWCalendarTimeSelector
        selector.delegate = self
        selector.optionCurrentDate = singleDate
        selector.optionCurrentDates = Set(multipleDates_Holidays)
        selector.optionCurrentDateRange.setStartDate(multipleDates_Holidays.first ?? singleDate)
        selector.optionCurrentDateRange.setEndDate(multipleDates_Holidays.last ?? singleDate)
        selector.optionSelectionType = WWCalendarTimeSelectorSelection.multiple
        selector.optionMultipleSelectionGrouping = .simple
        present(selector, animated: true, completion: nil)
    }
    
    @IBAction func actionSubmit(_ sender: UIButton){
        if txt_Holidays.text == ""{
            displayErrorAlert(alertStr: "Plaese selsct the holiday dates", title: "Alert")
        }
        else{
        self.submitHolidayInfo()
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

extension HolidaySettingsTableViewController: MenuViewDelegate{
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
extension HolidaySettingsTableViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
extension HolidaySettingsTableViewController: UITextViewDelegate{
   /* func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == placeholderColor {
                textView.text = nil
            textView.textColor = textColor
            }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
               textView.text = "Please enter cash payment information"
               textView.textColor = placeholderColor
           }
    }*/
}
extension HolidaySettingsTableViewController: WWCalendarTimeSelectorProtocol{
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        print("Selected \n\(date)\n---")
        singleDate = date
       
        
    }
    
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, dates: [Date]) {
        print("Selected Multiple Dates \n\(dates)\n---")
        if let date = dates.first {
           singleDate = date
        }
        else {
        }
        self.showBottomMenu()
        multipleDates_Holidays = dates
      
        var selectedDates = ""
        for obj in dates{
            let date = obj.stringFromFormat("yyyy-MM-dd")
            selectedDates += date + ","
        }
        if dates.count > 0{
            selectedDates.removeLast()
        }
        txt_Holidays.text = selectedDates
       
        
        DispatchQueue.main.async {
       
        self.tableView.reloadData()
        }
    }
}
