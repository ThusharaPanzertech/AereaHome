//
//  CardSummaryTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 10/06/22.
//

import UIKit
import DropDown
class CardSummaryTableViewController: BaseTableViewController {
    
    //Outlets
    @IBOutlet weak var view_SwitchProperty: UIView!
    @IBOutlet weak var lbl_SwitchProperty: UILabel!
    @IBOutlet weak var txt_CardNo: UITextField!
    @IBOutlet weak var txt_UnitNo: UITextField!
    @IBOutlet weak var txt_Status: UITextField!
    @IBOutlet weak var view_Footer: UIView!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var imgView_Profile: UIImageView!
    @IBOutlet var arr_Textfields: [UITextField]!
    @IBOutlet weak var btn_Unit: UIButton!
    @IBOutlet weak var dropdown_Unit: UIImageView!
    let menu: MenuView = MenuView.getInstance
    @IBOutlet weak var table_CardList: UITableView!
    var dataSource = DataSource_CardList()
    let alertView: AlertView = AlertView.getInstance
    let alertView_message: MessageAlertView = MessageAlertView.getInstance
    var array_Cards = [Card]()
    var array_Devices = [Device]()
    var unitsData = [Unit]()
    
    var isCardAccess: Bool!
    var isToDelete = false
    var indexToDelete  = 0
    override func viewDidLoad() {
        super.viewDidLoad()
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
        lbl_SwitchProperty.text = kCurrentPropertyName
          let fname = Users.currentUser?.moreInfo?.first_name ?? ""
        let lname = Users.currentUser?.moreInfo?.last_name ?? ""
        self.lbl_UserName.text = "\(fname) \(lname)"
        let role = Users.currentUser?.role
        self.lbl_UserRole.text = role
        table_CardList.dataSource = dataSource
        table_CardList.delegate = dataSource
        dataSource.parentVc = self
        dataSource.isCardAccess = self.isCardAccess
        dataSource.unitsData = self.unitsData
        setUpUI()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showBottomMenu()
        if self.isCardAccess{
            self.getCardSummary()
        }
        else{
           
            self.getDeviceSummary()
           
        }
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
            let ht =  isCardAccess ? 143 : 200
            let count = isCardAccess ? array_Cards.count : array_Devices.count
            return CGFloat((ht * count) + 380)
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
       
        if self.isCardAccess{
            self.lbl_Title.text = "Access Card Management"
            txt_CardNo.placeholder = "Please enter card no"
            txt_UnitNo.placeholder = "Select Unit"
            txt_Status.placeholder = "Select Status"
        }
        else{
            self.lbl_Title.text = "Device Management"
            txt_CardNo.placeholder = "Search by device name"
            txt_UnitNo.placeholder = "Enter Serial no"
            txt_Status.placeholder = "Select Status"
             btn_Unit.isHidden = true
             dropdown_Unit.isHidden = true
        }
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
      
    }
    //MARK: ******  PARSING *********
    
    
    func getCardSummary(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.get_cardSummary(parameters: ["login_id":userId], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? CardsSummaryModal){
                    self.array_Cards = response.cards
                    // self.unitsData = response.units
                    
                     if(self.array_Cards.count > 0){
                        self.array_Cards = self.array_Cards.sorted(by: { $0.created_at > $1.created_at })
                    }
                    self.dataSource.array_Cards = self.array_Cards
                    if self.array_Cards.count == 0{

                    }
                    else{
                       // self.view_NoRecords.removeFromSuperview()
                    }
                    self.table_CardList.reloadData()
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
    func searchCards(){
       
            
           
         
                
            ActivityIndicatorView.show("Loading")
            let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
            var param = [String : Any]()
           
                param = [
                    "login_id" : userId,
                    "unit" : txt_UnitNo.text!,
                    "card" : txt_CardNo.text!,
                    "status" : txt_Status.text! == "Active" ? "1" :
                        txt_Status.text! == "Inactive" ? "2" :
                        txt_Status.text! == "Faulty" ? "3" :
                        txt_Status.text! == "Loss" ? "4" :
                        txt_Status.text! == "Stolen" ? "5" : "",
                    
                ] as [String : Any]
           
           
            
            
                ApiService.search_cardSummary(parameters: param, completion: { status, result, error in
                   
                    ActivityIndicatorView.hiding()
                    if status  && result != nil{
                         if let response = (result as? CardsSummaryModal){
                            self.array_Cards = response.cards
                            // self.unitsData = response.units
                            
                             if(self.array_Cards.count > 0){
                                self.array_Cards = self.array_Cards.sorted(by: { $0.created_at > $1.created_at })
                            }
                            self.dataSource.array_Cards = self.array_Cards
                            if self.array_Cards.count == 0{

                            }
                            else{
                               // self.view_NoRecords.removeFromSuperview()
                            }
                            self.table_CardList.reloadData()
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
    
    
    func getDeviceSummary(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.get_deviceSummary(parameters: ["login_id":userId], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? DeviceSummaryModal){
                    self.array_Devices = response.lists
                    // self.unitsData = response.units
                    
                     if(self.array_Devices.count > 0){
                        
                    }
                    self.dataSource.array_Devices = self.array_Devices
                    if self.array_Devices.count == 0{

                    }
                    else{
                       // self.view_NoRecords.removeFromSuperview()
                    }
                    self.table_CardList.reloadData()
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
    func searchDevices(){
        
        
      
             
         ActivityIndicatorView.show("Loading")
         let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
         var param = [String : Any]()
        
             param = [
                 "login_id" : userId,
                 "status" : txt_Status.text! == "Active" ? "1" :
                     "0",
                 "name" : txt_CardNo.text!,
                 "serial_no" : txt_UnitNo.text!
                 
             ] as [String : Any]
        
        
      
         
         
             ApiService.search_deviceSummary(parameters: param, completion: { status, result, error in
                
                 ActivityIndicatorView.hiding()
                 if status  && result != nil{
                      if let response = (result as? DeviceSummaryModal){
                         self.array_Devices = response.lists
                         // self.unitsData = response.units
                         
                          if(self.array_Devices.count > 0){
                           
                         }
                         self.dataSource.array_Devices = self.array_Devices
                         if self.array_Devices.count == 0{

                         }
                         else{
                            // self.view_NoRecords.removeFromSuperview()
                         }
                         self.table_CardList.reloadData()
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
    func deleteDevice(id: Int){
       
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
       
        let param = [
            "login_id" : userId,
            "id" : self.array_Devices[id].id,
          
        ] as [String : Any]

        ApiService.delete_Device(parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
      self.isToDelete  = false
            if status  && result != nil{
                 if let response = (result as? DeleteUserBase){
                    if response.response == 1{
                        DispatchQueue.main.async {
                            self.alertView_message.delegate = self
                            self.alertView_message.showInView(self.view_Background, title: "Device has been\n deleted", okTitle: "Home", cancelTitle: "View Device List")
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
    func restartDevice(id: Int){
       
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
       
        let param = [
            "login_id" : userId,
            "id" : self.array_Devices[id].id,
          
        ] as [String : Any]

        ApiService.restart_Device(parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
      self.isToDelete  = false
            if status  && result != nil{
                 if let response = (result as? DeleteUserBase){
                    if response.response == 1{
                        DispatchQueue.main.async {
                            self.alertView_message.delegate = self
                            self.alertView_message.showInView(self.view_Background, title: "Device has been\n restarted", okTitle: "Home", cancelTitle: "View Device List")
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
    func showDeleteAlert(deleteIndx: Int){
        isToDelete = true
        self.indexToDelete = deleteIndx
        alertView.delegate = self
        alertView.showInView(self.view_Background, title: "Are you sure you want to\n delete the following\n device?", okTitle: "Yes", cancelTitle: "Back")
      
    }
    //MARK: UIBUTTON ACTION
    @IBAction func actionSearch(_ sender:UIButton) {
        if txt_CardNo.text == "" && txt_Status.text == "" && txt_UnitNo.text == ""{
            if self.isCardAccess{
                self.getCardSummary()
            }
            else{
                self.getDeviceSummary()
            }
        }
        else{
            if self.isCardAccess{
                self.searchCards()
            }
            else{
                self.searchDevices()
            }
        }
    }
    @IBAction func actionClear(_ sender:UIButton) {
        self.txt_Status.text = ""
        txt_CardNo.text = ""
        txt_UnitNo.text = ""
        if self.isCardAccess{
            self.getCardSummary()
        }
        else{
            self.getDeviceSummary()
        }
        
        
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
    @IBAction func actionAddNew(_ sender: UIButton){
        if self.isCardAccess{
            let editCardTVC = kStoryBoardMenu.instantiateViewController(identifier: "AddEditCard_DeviceTableViewController") as! AddEditCard_DeviceTableViewController
            editCardTVC.isToEdit = false
            editCardTVC.isCardAccess = true
            editCardTVC.unitsData = unitsData
            self.navigationController?.pushViewController(editCardTVC, animated: true)
        }
        else{
            let editDeviceTVC = kStoryBoardMenu.instantiateViewController(identifier: "AddEditCard_DeviceTableViewController") as! AddEditCard_DeviceTableViewController
            editDeviceTVC.isToEdit = false
            editDeviceTVC.isCardAccess = false
            editDeviceTVC.unitsData = unitsData
            self.navigationController?.pushViewController(editDeviceTVC, animated: true)
       
        }
    }
    @IBAction func actionUnit(_ sender:UIButton) {
        view.endEditing(true)
       // let sortedArray = unitsData.sorted(by:  { $0.1 < $1.1 })
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
    @IBAction func actionStatus(_ sender:UIButton) {
        view.endEditing(true)
        if isCardAccess{
        let arrStatus = [ "Active", "Inactive", "Faulty", "Loss", "Stolen"]
        let dropDown_Status = DropDown()
        dropDown_Status.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Status.dataSource = arrStatus//statusData.map({$0.value})//Array(statusData.values)
        dropDown_Status.show()
        dropDown_Status.selectionAction = { [unowned self] (index: Int, item: String) in
            txt_Status.text = item
           txt_Status.backgroundColor = .white
        }
        }
        else{
            let arrStatus = [ "Active", "Inactive"]
            let dropDown_Status = DropDown()
            dropDown_Status.anchorView = sender // UIView or UIBarButtonItem
            dropDown_Status.dataSource = arrStatus//statusData.map({$0.value})//Array(statusData.values)
            dropDown_Status.show()
            dropDown_Status.selectionAction = { [unowned self] (index: Int, item: String) in
                txt_Status.text = item
                    txt_Status.backgroundColor = .white
//                txt_CardNo.text = ""
//
//                txt_UnitNo.text = ""
//                searchDevices()
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
class DataSource_CardList: NSObject, UITableViewDataSource, UITableViewDelegate {
    var array_Cards = [Card]()
    var array_Devices = [Device]()
    var unitsData = [Unit]()
    var parentVc: UIViewController!
    var isCardAccess: Bool!
    
func numberOfSectionsInTableView(tableView: UITableView) -> Int {

    return 1;
}

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return  self.isCardAccess ? array_Cards.count : array_Devices.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.isCardAccess{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardSummaryCell") as! CardSummaryTableViewCell
        let card = array_Cards[indexPath.row]
        
        cell.lbl_CardNo.text = card.card
        cell.lbl_Status.text =
            card.status == 1 ? "Active" :  card.status == 2 ? "Inactive" :  card.status == 3 ? "Faulty" :  card.status == 4 ? "Loss" :  card.status == 5 ? "Stolen" :""
       
        if let unitId = unitsData.first(where: { $0.id == card.unit_no }) {
            cell.lbl_UnitNo.text = "#" + unitId.unit
        }
        else{
        cell.lbl_UnitNo.text = ""
        }
       
       
        cell.selectionStyle = .none
       
        
        
        cell.btn_Edit.tag = indexPath.row
           
        cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
        cell.btn_Edit.addTarget(self, action: #selector(self.actionEditCard(_:)), for: .touchUpInside)
        cell.view_Outer.tag = indexPath.row
       
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        cell.view_Outer.addGestureRecognizer(tap)
       
        
        return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "deviceSummaryCell") as! DeviceSummaryTableViewCell
            
            let device = array_Devices[indexPath.row]
            cell.lbl_DeviceNo.text = device.device_name
            cell.lbl_SerialNo.text = device.device_serial_no
            cell.lbl_Model.text = device.model
            cell.lbl_Location.text = device.location
            cell.lbl_Status.text = device.status
            
            cell.selectionStyle = .none
           
            
            
            cell.btn_Edit.tag = indexPath.row
            cell.btn_Refresh.tag = indexPath.row
            cell.btn_Delete.tag = indexPath.row
               
            cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
            cell.btn_Edit.addTarget(self, action: #selector(self.actionEditDevice(_:)), for: .touchUpInside)
            cell.btn_Refresh.addTarget(self, action: #selector(self.actionRestartDevice(_:)), for: .touchUpInside)
            cell.btn_Delete.addTarget(self, action: #selector(self.actionDeleteDevice(_:)), for: .touchUpInside)
            cell.view_Outer.tag = indexPath.row
           
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            cell.view_Outer.addGestureRecognizer(tap)
           
            return cell
        }
      
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  isCardAccess ? 143 : 200
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
     
       
       
    }
    @IBAction func actionEditCard(_ sender:UIButton){
        let card = array_Cards[sender.tag]
        let editCardTVC = kStoryBoardMenu.instantiateViewController(identifier: "AddEditCard_DeviceTableViewController") as! AddEditCard_DeviceTableViewController
        editCardTVC.cardInfo = card
        editCardTVC.isToEdit = true
        editCardTVC.isCardAccess = true
        editCardTVC.unitsData = unitsData
        self.parentVc.navigationController?.pushViewController(editCardTVC, animated: true)
//       
    }
    @IBAction func actionEditDevice(_ sender:UIButton){
        let device = array_Devices[sender.tag]
        let editCardTVC = kStoryBoardMenu.instantiateViewController(identifier: "AddEditCard_DeviceTableViewController") as! AddEditCard_DeviceTableViewController
        editCardTVC.deviceInfo = device
        editCardTVC.isToEdit = true
        editCardTVC.isCardAccess = false
        self.parentVc.navigationController?.pushViewController(editCardTVC, animated: true)

    }
    @IBAction func actionDeleteDevice(_ sender:UIButton){
        (self.parentVc as! CardSummaryTableViewController).showDeleteAlert(deleteIndx:sender.tag)
    }
    @IBAction func actionRestartDevice(_ sender:UIButton){
        (self.parentVc as! CardSummaryTableViewController).restartDevice(id: sender.tag)
    }
}
extension CardSummaryTableViewController: MenuViewDelegate{
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

   
   





extension CardSummaryTableViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
//        if textField == txt_CardNo{
//            txt_UnitNo.text = ""
//            txt_Status.text = ""
//        }
//        else if textField == txt_UnitNo{
//            txt_CardNo.text = ""
//            txt_Status.text = ""
//        }
//        if isCardAccess{
//            searchCards()
//        }
//        else{
//            searchDevices()
//        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.backgroundColor = .white

    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text!.count > 0{
            textField.backgroundColor = UIColor.white
        }
        else{
            textField.backgroundColor = UIColor(red: 208/255, green: 208/255, blue: 208/255, alpha: 1.0)
        }
        
    }
   
}
extension CardSummaryTableViewController: AlertViewDelegate{
    func onBackClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func onCloseClicked() {
        
    }
    
    func onOkClicked() {
       
        if isToDelete == true
        {self.deleteDevice(id: indexToDelete)}
           
        }
    
    
    
}
extension CardSummaryTableViewController: MessageAlertViewDelegate{
    func onHomeClicked() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func onListClicked() {
        self.getDeviceSummary()
    }
    
    
}
