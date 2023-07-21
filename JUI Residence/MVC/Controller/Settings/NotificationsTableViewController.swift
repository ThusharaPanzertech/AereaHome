//
//  NotificationsTableViewController.swift
//  JuiResidenceUser
//
//  Created by Thushara Harish on 03/05/23.
//

import UIKit
import DropDown
class NotificationsTableViewController:  BaseTableViewController {
    let menu: MenuView = MenuView.getInstance
    var heightSet = false
    var tableHeight: CGFloat = 0
    //Outlets
   @IBOutlet weak var view_SwitchProperty: UIView!
   @IBOutlet weak var lbl_SwitchProperty: UILabel!
    @IBOutlet weak var table_Notifications: UITableView!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var lbl_NoRecords: UILabel!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var view_Footer: UIView!
   
    @IBOutlet weak var imgView_Profile: UIImageView!
    
    var dataSource = DataSource_Notifications()
    var array_Notification = [NotificationDataModal]()
    var unitsData = [Unit]()
    let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
    override func viewDidLoad() {
        super.viewDidLoad()
        getUnitList()
        lbl_SwitchProperty.text = kCurrentPropertyName
        let fname = Users.currentUser?.moreInfo?.first_name ?? ""
        let lname = Users.currentUser?.moreInfo?.last_name ?? ""
        self.lbl_UserName.text = "\(fname) \(lname)"
        let role = Users.currentUser?.role
        self.lbl_UserRole.text = role
        imgView_Profile.addborder()
        table_Notifications.dataSource = dataSource
        table_Notifications.delegate = dataSource
        dataSource.parentVc = self
        table_Notifications.reloadData()
        
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
        view_Background.layer.cornerRadius = 25.0
        view_Background.layer.masksToBounds = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        self.getNotificationSummary()
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view_Background.roundCorners(corners: [.topLeft, .topRight], radius: 25.0)

        self.tableHeight = self.table_Notifications.contentSize.height
             //   print(self.tableHeight)
        if self.tableHeight > 0 && heightSet == false{
        DispatchQueue.main.async {
            
            self.tableView.reloadData()
            self.heightSet = true
        }
       }
        
    }
    //MARK: ******  PARSING *********
    func getNotificationSummary(){
        ActivityIndicatorView.show("Loading")
        
      
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
          
        ApiService.get_NotificationSummary(parameters: ["login_id":userId ], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? NotificationBase){
                     self.array_Notification = response.data.messages
                    if(self.array_Notification.count > 0){
//                        self.array_Notification = self.array_Notification.sorted(by: { $0.list.created_at > $1.list.created_at })
                       
                          //  self.array_Announcements = self.array_Announcements.sorted(by: { $0.view_status < $1.view_status })
                        
                    }
                   // self.array_AnnouncementViewStatus = response.lists
                    self.dataSource.array_Notification = self.array_Notification
                 //   self.dataSource.array_AnnouncementViewStatus = self.array_AnnouncementViewStatus
                     if self.array_Notification.count == 0{
                         self.lbl_NoRecords.isHidden = false
                     }
                     else{
                         self.lbl_NoRecords.isHidden = true
                     }
                    self.table_Notifications.reloadData()
                    self.tableView.reloadData()
                }
        }
            else if error != nil{
                self.displayErrorAlert(alertStr: "\(error!.localizedDescription)", title: "Oops")
            }
            else{
                self.displayErrorAlert(alertStr: "Something went wrong.Please try again", title: "Oops")
            }
        })
    }
    
    func updateNotificationStatus(notif: NotificationDataModal){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"

        //
        ApiService.update_NotificationStatus(parameters: ["login_id":userId , "id": "\(notif.id!)"], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? NotificationUpdateBase){
                    
                        
                    }
                 
        }
            else if error != nil{
                self.displayErrorAlert(alertStr: "\(error!.localizedDescription)", title: "Oops")
            }
            else{
                self.displayErrorAlert(alertStr: "Something went wrong.Please try again", title: "Oops")
            }
        })
    }
    func getUnitList(){
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.get_UnitList(parameters: ["login_id":userId], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? UnitBase){
                    self.unitsData = response.units
                  
                   
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
    //MARK: ******  PARSING DETAILS *********
    func getFeedbackDetail(id: Int){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        ApiService.get_FeedbackDetail(parameters: ["login_id":userId ?? "0", "id": id], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                if let response = (result as? FeedbackDetailBase){
                    let feedback = response.feedback
                    let feedbackDetailsVC = self.storyboard?.instantiateViewController(identifier: "FeedbackDetailsTableViewController") as! FeedbackDetailsTableViewController
                    feedbackDetailsVC.feedback = feedback
                    feedbackDetailsVC.unitsData = self.unitsData
                    self.navigationController?.pushViewController(feedbackDetailsVC, animated: true)
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
    func getDefectDetail(id: Int){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        ApiService.get_DefectDetail(parameters: ["login_id":userId ?? "0", "id": "\(id)"], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                if let response = (result as? DefectDetailsModalBase){
                    let defectDetail = response.booking_info
                    
                   
                    
                    
                    let submittedDefectsVC = kStoryBoardMain.instantiateViewController(identifier: "SubmittedDefectsListTableViewController") as! SubmittedDefectsListTableViewController
                    submittedDefectsVC.defectDetail =  defectDetail
                    submittedDefectsVC.unitsData = self.unitsData
                    self.navigationController?.pushViewController(submittedDefectsVC, animated: true)
                   
                    }
                }
        
            else if error != nil{
               self.displayErrorAlert(alertStr: "\(error!.localizedDescription)", title: "Oops")
            }
            else{
                self.displayErrorAlert(alertStr: "Something went wrong.Please try again", title: "Oops")
            }
        })
    }
 
    
   // func getInfo_MoveInOut(id: Int, redirection: redirectionType, index: Int){
    func getInfo_MoveInOut(id: Int){
        ActivityIndicatorView.show("Loading")
        
        
       
        ApiService.get_MoveInOutInfo(parameters: ["login_id" : userId, "id" : id], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? MoveInOutInfoBase){
                    let detail = response.details
                    
                         let moveIODetailsTVC = kStoryBoardMenu.instantiateViewController(identifier: "MoveIODetailsTableViewController") as! MoveIODetailsTableViewController
                         moveIODetailsTVC.moveInOutData = detail
                       //  moveIODetailsTVC.unit = self.arr_MoveInOut[index].unit
                         self.navigationController?.pushViewController(moveIODetailsTVC, animated: true)
                     
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
    
    
    
  
    
    func getInfo_Renovation(id: Int){
        ActivityIndicatorView.show("Loading")
        //
        ApiService.get_RenovationInfo(parameters: ["login_id" : userId, "id" : id], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? RenovationInfoBase){
                    let detail = response.details
                     
                         let moveIODetailsTVC = kStoryBoardMenu.instantiateViewController(identifier: "RenovationDetailsTableViewController") as! RenovationDetailsTableViewController
                         moveIODetailsTVC.renovationData = detail
                        // moveIODetailsTVC.unit = self.arr_Renovation[index].unit
                         self.navigationController?.pushViewController(moveIODetailsTVC, animated: true)
                     
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
    
   
    func getInfo_DoorAccess(id: Int){
        ActivityIndicatorView.show("Loading")
        //
        ApiService.get_DoorAccessInfo(parameters: ["login_id" : userId, "id" : id], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? DoorAccessInfoBase){
                    let detail = response.details
                    
                         let moveIODetailsTVC = kStoryBoardMenu.instantiateViewController(identifier: "DoorAccessDetailsTableViewController") as! DoorAccessDetailsTableViewController
                         moveIODetailsTVC.doorAccessData = detail
                        // moveIODetailsTVC.unit = self.arr_DoorAccess[index].unit
                         self.navigationController?.pushViewController(moveIODetailsTVC, animated: true)
                     
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
    
   
    func getInfo_VehicleReg(id: Int){
        ActivityIndicatorView.show("Loading")
        //
        ApiService.get_VehicleRegInfo(parameters: ["login_id" : userId, "id" : id], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? VehicleRegInfoBase){
                    let detail = response.details
                     let renovationDetailsTVC = kStoryBoardMenu.instantiateViewController(identifier: "VehicleRegDetailsTableViewController") as! VehicleRegDetailsTableViewController
                        renovationDetailsTVC.vehicleRegData = detail
                    // renovationDetailsTVC.unit = self.arr_VehicleReg[index].unit
                        self.navigationController?.pushViewController(renovationDetailsTVC, animated: true)
                     
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
    
    func getInfo_UpdteAddress(id: Int){
        ActivityIndicatorView.show("Loading")
        //
        ApiService.get_UpdateAddressInfo(parameters: ["login_id" : userId, "id" : id], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? UpdateAddressInfoSummaryBase){
                    let detail = response.details
                     let renovationDetailsTVC = kStoryBoardMenu.instantiateViewController(identifier: "UpdateAddressTableViewController") as! UpdateAddressTableViewController
                     renovationDetailsTVC.updateAddressData = detail
                     self.navigationController?.pushViewController(renovationDetailsTVC, animated: true)
                     
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
    func getInfo_UpdteParticulars(id: Int){
        ActivityIndicatorView.show("Loading")
        //
        ApiService.get_UpdateParticularInfo(parameters: ["login_id" : userId, "id" : id], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? UpdateParticularsInfoBase){
                    let detail = response.data
                     let renovationDetailsTVC = kStoryBoardMenu.instantiateViewController(identifier: "UpdateParticularsTableViewController") as! UpdateParticularsTableViewController
                     renovationDetailsTVC.updateParticularsData = detail
                     self.navigationController?.pushViewController(renovationDetailsTVC, animated: true)
                     
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
    func getInfo_KeyCollection(id: Int){
        ActivityIndicatorView.show("Loading")
        //
        ApiService.get_KeyCollectionInfo(parameters:  ["login_id" : userId, "id" : id]) { status, result, error in
          
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? KeyCollectionInfoBase){
                    let detail = response.data
                    
                 let editAppointmentVC = kStoryBoardMain.instantiateViewController(identifier: "EditAppointmentTableViewController") as! EditAppointmentTableViewController
                     editAppointmentVC.keyCollection = detail
                 self.navigationController?.pushViewController(editAppointmentVC, animated: true)
                     
                }
        }
            else if error != nil{
                self.displayErrorAlert(alertStr: "\(error!.localizedDescription)", title: "Alert")
            }
            else{
                self.displayErrorAlert(alertStr: "Something went wrong.Please try again", title: "Alert")
            }
        }
    }
    func getInfo_Facility(id: Int){
        ActivityIndicatorView.show("Loading")
        //
        ApiService.get_facilityInfo(parameters: ["login_id" : userId, "id" : id], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? FacilityInfoBase){
                     let facility = response.data
                     let editFacilityVC = kStoryBoardMain.instantiateViewController(identifier: "EditFacilityTableViewController") as! EditFacilityTableViewController
                     editFacilityVC.facility = facility
                     self.navigationController?.pushViewController(editFacilityVC, animated: true)
                     
                     
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
    
    func getVisitorInfo(id: Int){
        ActivityIndicatorView.show("Loading")
        
        ApiService.get_VisitorInfo(parameters: ["login_id":userId, "id" :id], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? VisitorInfoModalBase){
                    let visitorInfo = response.details
                     let editVisitorVC = kStoryBoardMenu.instantiateViewController(identifier: "VisitorDetaisTableViewController") as! VisitorDetaisTableViewController
                     editVisitorVC.visitorInfo = visitorInfo
                     self.navigationController?.pushViewController(editVisitorVC, animated: true)
                    
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
    func getResidentFileInfo(id: Int){
        ActivityIndicatorView.show("Loading")
        
        ApiService.get_ResidentFileDetail(parameters: ["login_id":userId, "id" :id], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? ResidentFileInfoBase){
                    let filedata = response.data
                    let infoVC = kStoryBoardMenu.instantiateViewController(identifier: "ResidentFileDetailsTableViewController") as! ResidentFileDetailsTableViewController
                     infoVC.residentFileData = filedata
                     self.navigationController?.pushViewController(infoVC, animated: true)
                     
                    
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

    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1{
            var ht = 0
            
            for obj in array_Notification{
                let title = obj.message
                let labelHeight = self.dataSource.heightForView(text:title, font:UIFont(name: "Helvetica-Bold", size: 16.0)!, width:kScreenSize.width - 95 )
                
                ht =  Int( ht + Int(labelHeight) + 80)
            }
            
            return CGFloat(ht + 250)
            
                // return tableHeight > 0 ?  tableHeight + 230 :  super.tableView(tableView, heightForRowAt: indexPath)
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    //MARK: MENU ACTIONS
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
    @IBAction func actionNotification(_ sender: UIButton){
      
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
//       var controller: UIViewController!
//       for cntroller in self.navigationController!.viewControllers as Array {
//           if cntroller.isKind(of: NotificationsTableViewController.self) {
//               controller = cntroller
//               break
//           }
//       }
//       if controller != nil{
//           self.navigationController!.popToViewController(controller, animated: true)
//       }
//       else{
//           let inboxTVC = kStoryBoardMain.instantiateViewController(identifier: "NotificationsTableViewController") as! NotificationsTableViewController
//           self.navigationController?.pushViewController(inboxTVC, animated: true)
//       }
     
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
class DataSource_Notifications: NSObject, UITableViewDataSource, UITableViewDelegate {

    var array_Notification =  [NotificationDataModal]()
   // var array_AnnouncementViewStatus = [ViewStatusList]()
    var parentVc: UIViewController!
        //["The wait is over!", "How to safeguard yourself from COVID 19?", "Dos and Donts for renovations."]

func numberOfSectionsInTableView(tableView: UITableView) -> Int {

    return 1;
}

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  array_Notification.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell") as! NotificationTableViewCell
        let notification = array_Notification[indexPath.row]
        cell.lbl_Mesage.text = notification.message
        cell.lbl_Title.text = notification.title
      
        
        if notification.admin_view_status == 0{
            cell.view_Outer.backgroundColor =  UIColor.white
            cell.lbl_Mesage.textColor = UIColor(red: 93/255, green: 93/255, blue: 93/255, alpha: 1.0)
            cell.lbl_Date.textColor = UIColor(red: 93/255, green: 93/255, blue: 93/255, alpha: 1.0)
        }
        else{
            cell.view_Outer.backgroundColor =  UIColor(red: 208/255, green: 208/255, blue: 208/255, alpha: 1.0)
            cell.lbl_Mesage.textColor = UIColor(red: 141/255, green: 141/255, blue: 141/255, alpha: 1.0)
            cell.lbl_Date.textColor = UIColor(red: 93/255, green: 93/255, blue: 93/255, alpha: 1.0)
        }
       
        cell.lbl_Date.text = "\(notification.created_at)"
      

        cell.view_Outer.layer.cornerRadius = 10.0
        cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
        //    cell.lbl_IndexNo.text = "\(indexPath.row + 1)."
        cell.view_Outer.tag = indexPath.row
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        cell.view_Outer.addGestureRecognizer(tap)
            return cell
      
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        let parent = self.parentVc as! NotificationsTableViewController
        let notif = array_Notification[(sender! as UITapGestureRecognizer).view!.tag]
        if notif.admin_view_status == 0{
            parent.updateNotificationStatus(notif: notif)
        }
        if notif.type == 2{
            parent.getFeedbackDetail(id: notif.ref_id)
        }
        else  if notif.type == 3{
            parent.getDefectDetail(id: notif.ref_id)
        }
        else  if notif.type == 4{
            parent.getInfo_KeyCollection(id: notif.ref_id)
        }
        else  if notif.type == 6{
            parent.getInfo_Facility(id: notif.ref_id)
        }
        
        else  if notif.type == 7{
            parent.getInfo_MoveInOut(id: notif.ref_id)
        }
        else  if notif.type == 8{
            parent.getInfo_Renovation(id: notif.ref_id)
        }
        else  if notif.type == 9{
            parent.getInfo_DoorAccess(id: notif.ref_id)
        }
        else  if notif.type == 10{
            parent.getInfo_VehicleReg(id: notif.ref_id)
        }
        else  if notif.type == 11{
            parent.getInfo_UpdteAddress(id: notif.ref_id)
        }
        else  if notif.type == 12{
            parent.getInfo_UpdteParticulars(id: notif.ref_id)
        }
        
        else if notif.type == 13{
            parent.getResidentFileInfo(id: notif.ref_id)
        }
        else if notif.type == 14{
            parent.getVisitorInfo(id: notif.ref_id)
        }
       
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let inbox = array_Notification[indexPath.row]
        let title = inbox.message
        let labelHeight = self.heightForView(text:title, font:UIFont(name: "Helvetica-Bold", size: 16.0)!, width:kScreenSize.width - 95 ) 
        
        return labelHeight + 80//labelHeight > 100 ? labelHeight + 100 : 100
    }
  
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notif = array_Notification[indexPath.row]
        if notif.status == 0{
          //  (self.parentVc as! NotificationsTableViewController)
        }

    }
    @IBAction func actionSelect(_ sender: UIButton){
        sender.isSelected = !sender.isSelected
      
    }
}

extension NotificationsTableViewController:  MenuViewDelegate{
    func onMenuClicked(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            
            self.navigationController?.popToRootViewController(animated: true)
            break
        case 2:
           // self.goToNotification()
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
