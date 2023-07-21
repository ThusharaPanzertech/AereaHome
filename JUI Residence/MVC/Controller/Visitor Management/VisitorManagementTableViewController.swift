//
//  VisitorManagementTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 02/03/23.
//

import UIKit
import DropDown

var selectedRowIndex_Visitor = -1
class VisitorManagementTableViewController: BaseTableViewController {
   
  
        
        //Outlets
        @IBOutlet weak var view_SwitchProperty: UIView!
        @IBOutlet weak var lbl_SwitchProperty: UILabel!
        @IBOutlet weak var datePicker:  UIDatePicker!
    
        @IBOutlet weak var txt_Purpose: UITextField!
        @IBOutlet weak var txt_Unit: UITextField!
        @IBOutlet weak var txt_VisitDate: UITextField!
        @IBOutlet weak var txt_BookingType: UITextField!
        @IBOutlet weak var txt_BookingId: UITextField!
        @IBOutlet weak var view_Footer: UIView!
        @IBOutlet weak var lbl_UserName: UILabel!
        @IBOutlet weak var lbl_UserRole: UILabel!
        @IBOutlet weak var view_Background: UIView!
        @IBOutlet weak var imgView_Profile: UIImageView!
        @IBOutlet var arr_Textfields: [UITextField]!
        @IBOutlet weak var btn_NewList: UIButton!
        let menu: MenuView = MenuView.getInstance
        @IBOutlet weak var table_VisitorList: UITableView!
        var dataSource = DataSource_VisitorList()
        var unitsData = [Unit]()
        var array_Visitors = [VisitorSummary]()
    var selected_purposeId = ""
    var bookingType = ""
        var arr_VisitingPurpose = [String: String]()
        override func viewDidLoad() {
            super.viewDidLoad()
            lbl_SwitchProperty.text = kCurrentPropertyName
            view_SwitchProperty.layer.borderColor = themeColor.cgColor
            view_SwitchProperty.layer.borderWidth = 1.0
            view_SwitchProperty.layer.cornerRadius = 10.0
            view_SwitchProperty.layer.masksToBounds = true
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
            table_VisitorList.dataSource = dataSource
            table_VisitorList.delegate = dataSource
            dataSource.parentVc = self
            dataSource.unitsData = self.unitsData
            setUpUI()
            self.configureDatePicker()
            
        }
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            selectedRowIndex_Visitor = -1
            self.showBottomMenu()
            getVisitorSummary()
        }
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            self.closeMenu()
        }
        override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            return view_Footer
        }
        override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return 150

        }
        override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           
            if indexPath.row == 1{
                let ht = selectedRowIndex_Visitor == -1  ?  (array_Visitors.count * 140) + 450 : ((array_Visitors.count - 1) * 140) + 265 + 450
                return CGFloat(ht)
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
                txtField.layer.cornerRadius = 20.0
                txtField.layer.masksToBounds = true
                txtField.delegate = self
                txtField.textColor = textColor
                txtField.attributedPlaceholder = NSAttributedString(string: txtField.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
            }
            btn_NewList.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
          
            btn_NewList.layer.cornerRadius = 10.0
        }
    func configureDatePicker(){
      //Formate Date
       datePicker.datePickerMode = .date
        

        //ToolBar
          let toolbar = UIToolbar();
          toolbar.sizeToFit()
          let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
         let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        txt_VisitDate.inputView = datePicker
   // add toolbar to textField
        txt_VisitDate.inputAccessoryView = toolbar
    }
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "dd/MM/yy"
        
      
        txt_VisitDate.text = formatter.string(from: datePicker.date)
        
            self.view.endEditing(true)
        
      
        
    }

    @objc func cancelDatePicker(){
       self.view.endEditing(true)
     }
        //MARK: ******  PARSING *********
       
       
        func getVisitorSummary(){
            ActivityIndicatorView.show("Loading")
            let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
            //
            ApiService.get_VisitorSummary(parameters: ["login_id":userId], completion: { status, result, error in
               
                ActivityIndicatorView.hiding()
                if status  && result != nil{
                     if let response = (result as? VisitorSummaryModalBase){
                        self.array_Visitors = response.data
                         self.arr_VisitingPurpose = response.purposes
                         self.dataSource.array_Visitors = self.array_Visitors
                         self.dataSource.arr_VisitingPurpose = self.arr_VisitingPurpose
                       
                        self.table_VisitorList.reloadData()
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
        func searchVisitor(){
         
            
            
            
            
            if txt_Unit.text == "" && txt_Purpose.text == "" && txt_BookingId.text == "" && txt_VisitDate.text == "" && txt_BookingType.text == ""{
                    self.getVisitorSummary()
                }
                else{
              
              
                    
                ActivityIndicatorView.show("Loading")
                let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
                    var unit_Id = ""
                    if let unitId = unitsData.first(where: { $0.unit == txt_Unit.text }){
                        unit_Id = "\(unitId.id)"
                    }
                   
                    let formatter = DateFormatter()
                    formatter.locale = Locale(identifier: "en_US_POSIX")
                    formatter.dateFormat = "dd/MM/yy"
                    let dateStr = formatter.date(from: txt_VisitDate.text! )
                 
                    formatter.dateFormat = "yyyy-MM-dd"
                 let dateStr_today = formatter.string(from: dateStr ?? Date())
                    
                   
                    let params = NSMutableDictionary()
                    params.setValue("\(userId)", forKey: "login_id")
                    params.setValue(txt_Unit.text!, forKey: "unit")
                    params.setValue(selected_purposeId, forKey: "purpose")
                    params.setValue(bookingType, forKey: "booking_type")
                    params.setValue(txt_BookingId.text, forKey: "bookingid")
                    params.setValue(dateStr_today, forKey: "date")
                    
               
                
                    ApiService.search_VisitorSummary(parameters:params as! [String : Any], completion: { status, result, error in
                       
                        ActivityIndicatorView.hiding()
                        if status  && result != nil{
                             if let response = (result as? VisitorSummaryModalBase){
                                self.array_Visitors = response.data
                                 self.arr_VisitingPurpose = response.purposes
                                 self.dataSource.array_Visitors = self.array_Visitors
                                 self.dataSource.arr_VisitingPurpose = self.arr_VisitingPurpose
                               
                                self.table_VisitorList.reloadData()
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
        @IBAction func actionSearch(_ sender:UIButton) {
            self.searchVisitor()
        }
        @IBAction func actionClear(_ sender:UIButton) {
            self.txt_Purpose.text = ""
            txt_Unit.text = ""
            txt_BookingId.text = ""
            txt_BookingType.text = ""
            txt_VisitDate.text = ""
            selected_purposeId = ""
            bookingType = ""
            self.getVisitorSummary()
            
            
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
            @IBAction func actionNewWalkin(_ sender: UIButton){
                let visitorTVC = self.storyboard?.instantiateViewController(identifier: "VisitorWalkinTableViewController") as! VisitorWalkinTableViewController
                visitorTVC.arr_VisitingPurpose = self.arr_VisitingPurpose
                visitorTVC.unitsData = self.unitsData
                self.navigationController?.pushViewController(visitorTVC, animated: true)
            }
        @IBAction func actionUnit(_ sender:UIButton) {
          //  let sortedArray = unitsData.sorted(by:  { $0.1 < $1.1 })
            let arrUnit = unitsData.map { $0.unit }
            let dropDown_Unit = DropDown()
            dropDown_Unit.anchorView = sender // UIView or UIBarButtonItem
            dropDown_Unit.dataSource = arrUnit// Array(unitsData.values)
            dropDown_Unit.show()
            dropDown_Unit.selectionAction = { [unowned self] (index: Int, item: String) in
               
                txt_Unit.text = item
               
                
            }
        }
      
        
        @IBAction func actionVisitingPurpose(_ sender:UIButton) {
            let sortedArray = arr_VisitingPurpose.sorted { $0.key < $1.key }
            let arrfacilityOptions = sortedArray.map { $0.value }
            let dropDown_arrfacilityOptions = DropDown()
            dropDown_arrfacilityOptions.anchorView = sender // UIView or UIBarButtonItem
            dropDown_arrfacilityOptions.dataSource = arrfacilityOptions//Array(roles.values)
            dropDown_arrfacilityOptions.show()
            dropDown_arrfacilityOptions.selectionAction = { [unowned self] (index: Int, item: String) in
                txt_Purpose.text = item
                selected_purposeId = sortedArray[index].key
                
            }
        }
      @IBAction func actionBookingType(_ sender:UIButton) {
        let dropDown_arrOptions = DropDown()
          dropDown_arrOptions.anchorView = sender // UIView or UIBarButtonItem
          dropDown_arrOptions.dataSource = ["Pre Registration", "Walk-In"]//Array(roles.values)
          dropDown_arrOptions.show()
          dropDown_arrOptions.selectionAction = { [unowned self] (index: Int, item: String) in
            txt_BookingType.text = item
           
              bookingType = "\(index + 1)"
              
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
    class DataSource_VisitorList: NSObject, UITableViewDataSource, UITableViewDelegate {
        var unitsData = [Unit]()
        var facilityOptions = [String: String]()
        var parentVc: UIViewController!
        var array_Visitors = [VisitorSummary]()
        
        var arr_VisitingPurpose = [String: String]()
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1;
    }

         func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return  array_Visitors.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: "vistorCell") as! VisitorTableViewCell
                
            cell.selectionStyle = .none
            cell.btn_Edit.tag = indexPath.row
            cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
            cell.btn_Edit.addTarget(self, action: #selector(self.actionEdit(_:)), for: .touchUpInside)
            cell.view_Outer.tag = indexPath.row
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            cell.view_Outer.addGestureRecognizer(tap)
            if indexPath.row != selectedRowIndex_Visitor{
                for vw in cell.arrViews{
                    vw.isHidden = true
                }
            }
            else{
                for vw in cell.arrViews{
                    vw.isHidden = false
                }
            }
            let visitor = array_Visitors[indexPath.row]
            cell.lbl_BookingId.text = visitor.ticket
            cell.img_Arrow.image = indexPath.row == selectedRowIndex_Visitor ? UIImage(named: "up_arrow") : UIImage(named: "down_arrow")
            cell.lbl_UnitNo.text = "#" + visitor.unit
            cell.lbl_InvitedBy.text =  visitor.invited_by
            cell.lbl_DateOfVisit.text = visitor.date_of_visit
            cell.lbl_VisitorNo.text = "\(visitor.visitor_count)"
            cell.lbl_VisitingPurpose.text = visitor.purpose
            cell.lbl_Status.text = visitor.status
            cell.lbl_New.layer.cornerRadius = 11.0
            cell.lbl_New.layer.masksToBounds = true
            if visitor.view_status == 0{
                cell.lbl_New.isHidden = false
            }
            else{
                cell.lbl_New.isHidden = true
            }
          
            return cell
          
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return indexPath.row == selectedRowIndex_Visitor ? 265 : 140
        }
        
        @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
            // handling code
            selectedRowIndex_Visitor = (sender! as UITapGestureRecognizer).view!.tag
            DispatchQueue.main.async {
                (self.parentVc as! VisitorManagementTableViewController
                ).tableView.reloadData()
            (self.parentVc as! VisitorManagementTableViewController).table_VisitorList.reloadData()
          
            }
           
           
        }
        @IBAction func actionEdit(_ sender:UIButton){
            let visitor = array_Visitors[sender.tag]
            let editVisitorVC = self.parentVc.storyboard?.instantiateViewController(identifier: "VisitorDetaisTableViewController") as! VisitorDetaisTableViewController
            editVisitorVC.visitor = visitor
            self.parentVc.navigationController?.pushViewController(editVisitorVC, animated: true)
           
        }
    }
    extension VisitorManagementTableViewController: MenuViewDelegate{
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

       
    extension VisitorManagementTableViewController: UITextFieldDelegate{
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    }





   
