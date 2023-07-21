//
//  AssignDevicesTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 03/07/23.
//

import UIKit
import DropDown
var arr_Selection = [String:[String:[Int]]]()
var arr_SelectionHeader = [String:[Int]]()
var arr_DeviceCall = [String:Int]()
class AssignDevicesTableViewController: BaseTableViewController {
    //Outlets
    @IBOutlet weak var view_SwitchProperty: UIView!
    @IBOutlet weak var lbl_SwitchProperty: UILabel!
  
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var imgView_Profile: UIImageView!

    let menu: MenuView = MenuView.getInstance
    @IBOutlet weak var table_DeviceList: UITableView!
    var dataSource = DataSource_AssignDevices()
    var user: UserModal!
   var array_AssignDeviceLst = [AssignDevice]()
    let alertView_message: MessageAlertView = MessageAlertView.getInstance
    var isUser = false
    override func viewDidLoad() {
        super.viewDidLoad()
        lbl_Title.text = "Manage Device(s): \(self.user!.name) \(self.user!.last_name)"
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
        table_DeviceList.dataSource = dataSource
        table_DeviceList.delegate = dataSource
        dataSource.parentVc = self
        setUpUI()
        getDeviceSummaryLists()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //selectedRowIndex_Feedback = -1
        self.showBottomMenu()
        
       
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.closeMenu()
    }
   
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
        var ht = 0
        if indexPath.row == 1{
           
            for obj in self.array_AssignDeviceLst{
                let callht = obj.devices.count == 1   ? 0 :100
                ht = ht + (100 * obj.devices.count) + 100 + callht
            }
            let headerht =  self.isUser ? 70 : 50
            ht = ht + ( headerht * array_AssignDeviceLst.count ) + 150
            return CGFloat(ht)
        
        }
        if indexPath.row == 2{
           
           
            return  self.array_AssignDeviceLst.count == 0 ? 0 :  super.tableView(tableView, heightForRowAt: indexPath)
        
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
       
        lbl_SwitchProperty.text = kCurrentPropertyName
        
        view_Background.layer.cornerRadius = 25.0
        view_Background.layer.masksToBounds = true
      
        imgView_Profile.addborder()
       
     
       
    }
    //MARK: ******  PARSING *********
   
    
    func getDeviceSummaryLists(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        
        ApiService.get_assignedDeviceList(parameters: ["login_id":userId, "user": self.user.id!], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? AssignDeviceBase){
                     self.array_AssignDeviceLst = response.data
                     self.isUser = response.type == "user"
                     self.dataSource.array_AssignDeviceLst = self.array_AssignDeviceLst
                     self.dataSource.isUser = self.isUser
                   //  arr_Selection = [String:[String:[Int]]]()
                 //    var arr_SelectionHeader = [String:[Int]]()
                     arr_Selection.removeAll()
                     arr_SelectionHeader.removeAll()
                     arr_DeviceCall.removeAll()
                     for (idx,data) in self.array_AssignDeviceLst.enumerated(){
                         arr_SelectionHeader["\(idx)"] = [0,0]
                         var detail = [String:[Int]]()
                         for (indx,obj) in data.devices.enumerated(){
                             detail["\(indx)"] = [obj.user_bluethooth_checked_status, obj.user_remote_checked_status]
                         }
                         arr_Selection["\(idx)"] = detail
                         arr_DeviceCall["\(idx)"] = data.receive_call
                     }
                     
                     
                     DispatchQueue.main.async {
                         self.table_DeviceList.reloadData()
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
    func updateAssignDevice(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        
        
        
        
        let params = NSMutableDictionary()
        params.setValue("\(userId)", forKey: "login_id")
        params.setValue("\(self.user.id!)", forKey: "user")
        if self.isUser == true{
            for (idx,data) in self.array_AssignDeviceLst.enumerated(){
                let detail = arr_Selection["\(idx)"]
                let dataId = data.id

                let call = arr_DeviceCall["\(idx)"]
                params.setValue("\(call ?? 0)", forKey: "receive_device_cal_\(dataId)")
                for (indx,dataObj) in data.devices.enumerated(){
                    if detail != nil{
                        let access = detail!["\(indx)"]
                        if access != nil{
                            let bluetoothAccess = access![0]
                            let remoteAccess = access![1]
                            params.setValue("\(bluetoothAccess)", forKey: "unit_\(dataId)_device_\(dataObj.id)")
                            params.setValue("\(remoteAccess)", forKey: "unit_\(dataId)_device_remote_\(dataObj.id)")
                        }
                    }
                }
                
            }
        }
        else{
            for (idx,data) in self.array_AssignDeviceLst.enumerated(){
                let detail = arr_Selection["\(idx)"]
                let dataId = data.id
                //receive_device_cal_
                let call = arr_DeviceCall["\(idx)"]
                params.setValue("\(call ?? 0)", forKey: "receive_device_cal_\(dataId)")
                for (indx,dataObj) in data.devices.enumerated(){
                    if detail != nil{
                        let access = detail!["\(indx)"]
                        if access != nil{
                            let bluetoothAccess = access![0]
                            let remoteAccess = access![1]
                            params.setValue("\(bluetoothAccess)", forKey: "building_\(dataId)_device_\(dataObj.id)")
                            params.setValue("\(remoteAccess)", forKey: "building_\(dataId)_device_remote_0\(dataObj.id)")
                        }
                    }
                }
                
            }
        }
        
        
        ApiService.update_assignedDeviceList(parameters: params as! [String : Any], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? DeleteUserBase){
                     DispatchQueue.main.async {
                         self.alertView_message.delegate = self
                         self.alertView_message.showInView(self.view_Background, title: "Devices assigned successfully", okTitle: "Home", cancelTitle: "View User Management")
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
    @IBAction func actionSubmit(_ sender:UIButton) {
        self.updateAssignDevice()
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

class DataSource_AssignDevices: NSObject, UITableViewDataSource, UITableViewDelegate {
    var parentVc: UIViewController!
    var array_AssignDeviceLst = [AssignDevice]()
    var isUser = false
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return array_AssignDeviceLst.count;

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  array_AssignDeviceLst.count == 0 ? 0 : array_AssignDeviceLst[section].devices.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if array_AssignDeviceLst[indexPath.section].devices.count == 0{
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "deviceCell") as! DeviceTableViewCell
               
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "deviceCallCell") as! DeviceCallTableViewCell
                
                return cell
            }
        }
        else{
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "deviceCell") as! DeviceTableViewCell
                let dataAccess = arr_SelectionHeader["\(indexPath.section)"]
                if dataAccess != nil{
                    cell.btn_Remote.isSelected = (dataAccess![1] != 0)
                    cell.btn_Bluetooth.isSelected = (dataAccess![0] != 0)
                }
                
                cell.btn_Remote.tag = indexPath.section
                cell.btn_Bluetooth.tag =  indexPath.section
                
                cell.btn_Remote.addTarget(self, action: #selector(self.actionSelectAll_Remote(_:)), for: .touchUpInside)
                cell.btn_Bluetooth.addTarget(self, action: #selector(self.actionSelectAll_Bluetooth(_:)), for: .touchUpInside)
                
                
                
                return cell
            }
            else if indexPath.row == array_AssignDeviceLst[indexPath.section].devices.count + 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: "deviceCallCell") as! DeviceCallTableViewCell
                
                cell.btn_ReceiveCall.tag =  indexPath.section
                
                cell.btn_ReceiveCall.addTarget(self, action: #selector(self.actionReceiveCall(_:)), for: .touchUpInside)
                
                if let data = arr_DeviceCall["\(indexPath.section)"]{
                    cell.txt_ReceiveCall.text = data == 0 ? "No" : "Yes"
                }
                return cell
            }
            
           
            else{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "deviceDetailCell") as! DeviceTableViewCell
                let device = array_AssignDeviceLst[indexPath.section].devices[indexPath.row - 1]
                cell.lbl_DeviceName.text = device.device_name
                cell.lbl_SerialNo.text = device.device_serial_no
                cell.lbl_Location.text = device.location
                let indx = indexPath.row - 1
                let selection = arr_Selection["\(indexPath.section)"]
                if selection != nil{
                    let selectiondetail = selection!["\(indx)"]
                    if selectiondetail != nil{
                        let bluetooth = selectiondetail![0]
                        let remote = selectiondetail![1]
                        cell.btn_Bluetooth.isSelected = (bluetooth != 0)
                        cell.btn_Remote.isSelected = (remote != 0)
                        
                    }
                }
                cell.btn_Remote.tag = indx
                cell.btn_Bluetooth.tag = indx
                
                cell.btn_Remote.addTarget(self, action: #selector(self.actionChangeRemoteAccess(_:)), for: .touchUpInside)
                cell.btn_Bluetooth.addTarget(self, action: #selector(self.actionChangeBluetoothAccess(_:)), for: .touchUpInside)
                
                return cell
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if array_AssignDeviceLst.count == 0{
            return 95
        }
        else{
            if indexPath.row == 0 {
                return 98
            }
      
            else if indexPath.row == array_AssignDeviceLst[indexPath.section].devices.count + 1{
                return array_AssignDeviceLst[indexPath.section].devices.count == 0 ? 1 : 95
            }
            else {
                return 95
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if array_AssignDeviceLst.count == 0{
            return nil
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! AssignDeviceHeaderTableViewCell
            let device = array_AssignDeviceLst[section]
            cell.lbl_Building.text = device.building
            cell.lbl_Unit.text = "#\(device.unit)"
            
            cell.lbl_UnitTitle.isHidden = self.isUser == false
            cell.lbl_Unit.isHidden = self.isUser == false
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if array_AssignDeviceLst.count == 0{
            return 0
        }
        else{
            return self.isUser ? 68 : 50
            
            
        }
        
    }
    @IBAction func actionReceiveCall(_ sender:UIButton) {

        let dropDown_Unit = DropDown()
        dropDown_Unit.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Unit.dataSource = ["Yes","No"]
        dropDown_Unit.show()
        dropDown_Unit.selectionAction = { [unowned self] (index: Int, item: String) in
            if index == 0{
                arr_DeviceCall["\(sender.tag)"] = 1
            }
            else{
                arr_DeviceCall["\(sender.tag)"] = 0
            }
            DispatchQueue.main.async {
                
                (self.parentVc as! AssignDevicesTableViewController).table_DeviceList.reloadData()
            }
            
        }
    }
    @IBAction func actionSelectAll_Bluetooth(_ sender:UIButton){
        sender.isSelected = !sender.isSelected
        let dataAccess = arr_SelectionHeader["\(sender.tag)"]
        
        if dataAccess != nil{
            let remote = dataAccess![1]
            let bluetooth = sender.isSelected ? 1 : 0
            arr_SelectionHeader["\(sender.tag)"] = [bluetooth, remote]
            
            let access = arr_Selection["\(sender.tag)"]
           
           
            for (indx,obj) in array_AssignDeviceLst[sender.tag].devices.enumerated(){
                let remote1 = access!["\(indx)"]![1]
                let bluetooth1 = sender.isSelected ? 1 : 0
                arr_Selection["\(sender.tag)"]!["\(indx)"] =  [bluetooth1, remote1]
                }
            DispatchQueue.main.async {
                
                (self.parentVc as! AssignDevicesTableViewController).table_DeviceList.reloadData()
            }
            
            
        }
    }
    @IBAction func actionSelectAll_Remote(_ sender:UIButton){
        sender.isSelected = !sender.isSelected
        
        let dataAccess = arr_SelectionHeader["\(sender.tag)"]
        
        if dataAccess != nil{
            let bluetooth = dataAccess![0]
            let remote = sender.isSelected ? 1 : 0
            arr_SelectionHeader["\(sender.tag)"] = [bluetooth, remote]
            let access = arr_Selection["\(sender.tag)"]
           
           
            for (indx,obj) in array_AssignDeviceLst[sender.tag].devices.enumerated(){
                let bluetooth1 = access!["\(indx)"]![0]
                let remote1 = sender.isSelected ? 1 : 0
                arr_Selection["\(sender.tag)"]!["\(indx)"] =  [bluetooth1, remote1]
                }
            DispatchQueue.main.async {
                
                (self.parentVc as! AssignDevicesTableViewController).table_DeviceList.reloadData()
            }
        }
    }
    @IBAction func actionChangeBluetoothAccess(_ sender:UIButton){
        sender.isSelected = !sender.isSelected
        
        let buttonPosition = sender.convert(CGPoint.zero, to: (self.parentVc as! AssignDevicesTableViewController).table_DeviceList)
        let indexPath = (self.parentVc as! AssignDevicesTableViewController).table_DeviceList.indexPathForRow(at: buttonPosition)
        if indexPath != nil{
            let selection = arr_Selection["\(indexPath!.section)"]
            if selection != nil{
                let selectiondetail = selection!["\(sender.tag)"]
                if selectiondetail != nil{
                    var bluetooth = selectiondetail![0]
                    let remote = selectiondetail![1]
                    
                    
                    bluetooth = sender.isSelected ? 1 : 0
                    arr_Selection["\(indexPath!.section)"]!["\(sender.tag)"] = [bluetooth, remote]
                    DispatchQueue.main.async {
                        
                        (self.parentVc as! AssignDevicesTableViewController).table_DeviceList.reloadData()
                    }
                }
            }
        }
    }
    @IBAction func actionChangeRemoteAccess(_ sender:UIButton){
        sender.isSelected = !sender.isSelected
        
        let buttonPosition = sender.convert(CGPoint.zero, to: (self.parentVc as! AssignDevicesTableViewController).table_DeviceList)
        let indexPath = (self.parentVc as! AssignDevicesTableViewController).table_DeviceList.indexPathForRow(at: buttonPosition)
        if indexPath != nil{
            let selection = arr_Selection["\(indexPath!.section)"]
            if selection != nil{
                let selectiondetail = selection!["\(sender.tag)"]
                if selectiondetail != nil{
                    let bluetooth = selectiondetail![0]
                    var remote = selectiondetail![1]
                    
                    
                    remote = sender.isSelected ? 1 : 0
                    arr_Selection["\(indexPath!.section)"]!["\(sender.tag)"] = [bluetooth, remote]
                    DispatchQueue.main.async {
                        
                        (self.parentVc as! AssignDevicesTableViewController).table_DeviceList.reloadData()
                    }
                }
            }
        }
      
    }
}
extension AssignDevicesTableViewController: MenuViewDelegate{
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
extension AssignDevicesTableViewController : MessageAlertViewDelegate{
    func onHomeClicked() {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func onListClicked() {
        //self.getDeviceSummaryLists()
        var controller: UIViewController!
        for cntroller in self.navigationController!.viewControllers as Array {
            if cntroller.isKind(of: OpionsTableViewController.self) {
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
