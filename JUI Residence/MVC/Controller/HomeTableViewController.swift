//
//  HomeTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 15/07/21.
//

import UIKit

class HomeTableViewController: BaseTableViewController {
    let menu: MenuView = MenuView.getInstance
   // var array_Permissions = [Permissions]()
   // var array_Modules = [Module]()
    var array_Menus = [DashboardMenu]()
    var array_Property = [Property]()
    //[String]()
    var dictImages = [String:String]()
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var imgView_Logo: UIImageView!
    @IBOutlet weak var view_NoRecords: UIView!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var collection_HomeIcon: UICollectionView!
    
    
    @IBOutlet weak var imgView_Profile: UIImageView!
    
    var unitsData = [Unit]()
    var heightSet = false
    var tableHeight: CGFloat = 0
    var timer = Timer()
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
        self.getLoginInfo()
        getUserSummary()
        getUnitList()
        getPropertyList()
        imgView_Profile.addborder()
       // array_Permissions = [kUserManagement,kAnnouncement,kKeyCollection,kDefectList,kDefectInspection,kFacilities,kFeedback, kCondoDocument, kResidentsFileUpload, kVisitorManagement, kManagePassword, kEFormSubmission]
        dictImages = [kManageRole:"manage_role",kUserManagement:"user_management",kAnnouncement:"announcemenmt",kKeyCollection:"key_collection",kDefectList:"defects_list",kDefectInspection:"defect_inspection",kFacilities:"facility_booking", kFeedback:"feedback",
                   kCondoDocument: "condo_document", kResidentsFileUpload: "resident_file", kVisitorManagement: "visitor_management", kManagePassword: "manage_password", kEFormSubmission: "condo_document",kDigitalAccess:"digital_access",kStaffDigitalAccess: "digital_access", kCardAcess: "card_access", kDeviceManagement: "device_mgmt", kSettings: "settings"]
        
      //  self.setUpTimer()
        self.setUpCollectionViewLayout()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view_Background.roundCorners(corners: [.topLeft, .topRight], radius: 25.0)
        self.tableHeight = self.collection_HomeIcon.contentSize.height == 0 ? self.collection_HomeIcon.contentSize.height + 180 : self.collection_HomeIcon.contentSize.height + 180
        if self.tableHeight > 0 && heightSet == false{
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.heightSet = true
        }
       }
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1{
            return tableHeight > 0 ?  tableHeight  :  super.tableView(tableView, heightForRowAt: indexPath)
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        self.showBottomMenu()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.closeMenu()
    }
    //MARK: ******  PARSING *********
    func getLoginInfo(){
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        self.array_Menus.removeAll()
      //  self.array_Settings.removeAll()
        ApiService.get_DashboardInfo(userId:"\(userId)" , completion: { status, result, error in
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                if let userBase = (result as? DashboardInfoModalBase){
                    if userBase.response == 1{
                        self.array_Menus = userBase.menu
               //         self.array_Settings = userBase.settings
                        DispatchQueue.main.async {
                                    self.heightSet = false
                                    self.collection_HomeIcon.reloadData()
                                    self.tableView.reloadData()
                                }
                        }
                    else{
                        self.view.endEditing(true)
                        self.displayErrorAlert(alertStr: "", title: userBase.message)
                    }
                }
        }
            else if error != nil{
                self.displayErrorAlert(alertStr: "\(error!.localizedDescription)", title: "Oops")
            }
            else{
                self.displayErrorAlert(alertStr: "Something went wrong.Please try again", title: "Oops")
            }
        })
 /*       ApiService.get_User_With(userId:"\(userId)" , completion: { status, result, error in
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                if let userBase = (result as? LoginInfoModalBase){
                    if userBase.response == true{
                        
                        
                       
                        let permissionarray = userBase.data.permissions
                        self.array_Permissions.removeAll()
                        self.array_Modules = userBase.modules
                            for obj in permissionarray{
                                let module = self.array_Modules.first(where:{ $0.id == Int(obj.module_id)})
                                if module != nil{
                                    if obj.view == 1 && module!.menu_position == 1{
                                   
                                    self.array_Permissions.append(obj)
                                }}
                                DispatchQueue.main.async {
                                    self.heightSet = false
                                    self.collection_HomeIcon.reloadData()
                                    self.tableView.reloadData()
                                }
                        }
                    }
                    else{
                        self.view.endEditing(true)
                        self.displayErrorAlert(alertStr: "", title: userBase.message)
                    }
                }
        }
            else if error != nil{
                self.displayErrorAlert(alertStr: "\(error!.localizedDescription)", title: "Oops")
            }
            else{
                self.displayErrorAlert(alertStr: "Something went wrong.Please try again", title: "Oops")
            }
        }) */
    }
    func getPropertyList(){
        //ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.get_PropertyList(parameters: ["login_id":userId], completion: { status, result, error in
           
         //   ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? PropertyListBase){
                    self.array_Property = response.data
                     kCurrentPropertyId = response.current_property
                   
                }
        }
            else if error != nil{
             //   self.displayErrorAlert(alertStr: "\(error!.localizedDescription)", title: "Alert")
            }
            else{
             //   self.displayErrorAlert(alertStr: "Something went wrong.Please try again", title: "Alert")
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
    func getUserSummary(){
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.get_UserDetail_With(parameters: ["login_id":userId, "user":userId], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? UserInfoModalBase){
                    Users.currentUser = response.users
                   
                    DispatchQueue.main.async {
                        let fname = Users.currentUser?.user?.name ?? ""
                        let lname = Users.currentUser?.moreInfo?.last_name ?? ""
                        self.lbl_UserName.text = "\(fname) \(lname)"
                        let role = Users.currentUser?.role?.name ?? ""
                        self.lbl_UserRole.text = role
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
    //MARK:UICOLLECTION VIEW LAYOUT
    func setUpCollectionViewLayout(){
       
     
        
        let layout =  UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let cellWidth = (kScreenSize.width - 80)/CGFloat(2.0)
        let size = CGSize(width: cellWidth, height: 160)
        layout.itemSize = size
        collection_HomeIcon.collectionViewLayout = layout
    
        self.collection_HomeIcon.reloadData()
        
    }
    override func getBackgroundImageName() -> String {
        let imgdefault = ""// UserInfoModalBase.currentUser?.data.property.default_bg ?? ""
        return imgdefault
    }
    func showBottomMenu(){
        
        menu.delegate = self
        menu.showInView(self.view, title: "", message: "")
    }
    func closeMenu(){
        menu.removeView()
    }
   
    //MARK: UIButton Action
    @IBAction func actionUserManagement(_ sender: UIButton){
        let userManagementTVC = kStoryBoardMain.instantiateViewController(identifier: "UserManagementTableViewController") as! UserManagementTableViewController
        self.navigationController?.pushViewController(userManagementTVC, animated: true)
    }
    @IBAction func actionAnnouncement(_ sender: UIButton){
        
        let announcementTVC = self.storyboard?.instantiateViewController(identifier: "AnnouncementHistoryTableViewController") as! AnnouncementHistoryTableViewController
        self.navigationController?.pushViewController(announcementTVC, animated: true)
    }
    @IBAction func actionAppointmemtUnitTakeOver(_ sender: UIButton){
        let appointmentUnitTVC = self.storyboard?.instantiateViewController(identifier: "AppointmentUnitTakeOverTableViewController") as! AppointmentUnitTakeOverTableViewController
        appointmentUnitTVC.appointment = .keyCollection
        self.navigationController?.pushViewController(appointmentUnitTVC, animated: true)
    }
    @IBAction func actionDefectList(_ sender: UIButton){
        let defectListTVC = self.storyboard?.instantiateViewController(identifier: "DefectsListTableViewController") as! DefectsListTableViewController
        defectListTVC.unitsData = self.unitsData
        self.navigationController?.pushViewController(defectListTVC, animated: true)
    }
    @IBAction func actionAppointmentJointInspection(_ sender: UIButton){
        let appointmentUnitTVC = self.storyboard?.instantiateViewController(identifier: "AppointmentUnitTakeOverTableViewController") as! AppointmentUnitTakeOverTableViewController
        appointmentUnitTVC.appointment = .defectInspection
        self.navigationController?.pushViewController(appointmentUnitTVC, animated: true)
    }
    @IBAction func actionFacilityBooking(_ sender: UIButton){
        let facilityBookingTVC = self.storyboard?.instantiateViewController(identifier: "FacilityBookingTableViewController") as! FacilityBookingTableViewController
        facilityBookingTVC.unitsData = self.unitsData
        self.navigationController?.pushViewController(facilityBookingTVC, animated: true)
    }
    @IBAction func actionFeedback(_ sender: UIButton){
        let feedbackTVC = self.storyboard?.instantiateViewController(identifier: "FeedbackTableViewController") as! FeedbackTableViewController
        self.navigationController?.pushViewController(feedbackTVC, animated: true)
    }
    @IBAction func actionCondoDocument(_ sender: UIButton){
        let condoTVC = kStoryBoardMenu.instantiateViewController(identifier: "CondoDocumentsTableViewController") as! CondoDocumentsTableViewController
        self.navigationController?.pushViewController(condoTVC, animated: true)
    }
    @IBAction func actionResidentFileUpload(_ sender: UIButton){
        let residentTVC = kStoryBoardMenu.instantiateViewController(identifier: "ResidentFileUploadTableViewController") as! ResidentFileUploadTableViewController
        self.navigationController?.pushViewController(residentTVC, animated: true)
    }
    @IBAction func actionEForms(_ sender: UIButton){
        let residentTVC = kStoryBoardMenu.instantiateViewController(identifier: "EFormTypesTableViewController") as! EFormTypesTableViewController
        residentTVC.unitsData = self.unitsData
        self.navigationController?.pushViewController(residentTVC, animated: true)
    }
    @IBAction func actionManageRole(_ sender: UIButton){
       let rolesTVC = self.storyboard?.instantiateViewController(identifier: "RolesTableViewController") as! RolesTableViewController
        self.navigationController?.pushViewController(rolesTVC, animated: true)
    }
    @IBAction func actionStaffDigitalAccess(_ sender: UIButton){
        let permission = array_Menus[sender.tag]
        let settingsSubmenuTVC = kStoryBoardSettings.instantiateViewController(identifier: "SettingsSubMenuTableViewController") as! SettingsSubMenuTableViewController
        settingsSubmenuTVC.settingsMenu = permission
        self.navigationController?.pushViewController(settingsSubmenuTVC, animated: true)
         }
    @IBAction func actionCardManagement(_ sender: UIButton){
        let cardTVC = kStoryBoardMenu.instantiateViewController(identifier: "CardSummaryTableViewController") as! CardSummaryTableViewController
        cardTVC.isCardAccess = true
        cardTVC.unitsData = self.unitsData
        self.navigationController?.pushViewController(cardTVC, animated: true)
    }
    @IBAction func actionDeviceManagement(_ sender: UIButton){
        let deviceTVC = kStoryBoardMenu.instantiateViewController(identifier: "CardSummaryTableViewController") as! CardSummaryTableViewController
        deviceTVC.isCardAccess = false
        deviceTVC.unitsData = self.unitsData
        self.navigationController?.pushViewController(deviceTVC, animated: true)
    }
    func goToSettings(){
        let settingsTVC = kStoryBoardSettings.instantiateViewController(identifier: "SettingsTableViewController") as! SettingsTableViewController
        self.navigationController?.pushViewController(settingsTVC, animated: true)
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
    
}
extension HomeTableViewController: MenuViewDelegate{
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
extension HomeTableViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array_Menus.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCell", for: indexPath) as! HomeIconCollectionViewCell
       // cell.lbl_NotificationCount.layer.cornerRadius = 10.0
       // cell.lbl_NotificationCount.layer.masksToBounds = true
       // cell.lbl_NotificationCount.isHidden = true
       // let obj = self.array_Permissions[indexPath.item]
        cell.view_Outer.layer.cornerRadius = 6.0
//        cell.view_Outer.layer.masksToBounds = true
//        cell.view_Outer.layer.borderColor = UIColor.black.cgColor
//        cell.view_Outer.layer.borderWidth = 1.0
       // cell.view_Outer.dropShadow()
        cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.gray, radius: 3.0, opacity: 0.35)
      //  cell.view_Outer.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 2, scale: true)

//        cell.lbl_Heading.text = obj
        let menu = array_Menus[indexPath.row]
       // cell.lbl_Heading.text = per
       // let module = self.array_Modules.first(where:{ $0.id == Int(permission.module_id)})
        cell.lbl_Heading.text = menu.menu_group//module?.name
        
      //  if module != nil{
        let img = dictImages[menu.menu_group]//[(module?.name.trimmingTrailingSpaces)!]
            cell.img_Icon.image = UIImage(named: img ?? "announcement")
       // }
       // else{
       //     cell.img_Icon.image = UIImage(named:"announcement")
       // }
 
        
        
        
        cell.view_Outer.tag = indexPath.item
        cell.btn_Icon.tag = indexPath.item
        cell.btn_Icon.addTarget(self, action: #selector(HomeTableViewController.actionIcon(_:)), for: .primaryActionTriggered)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        cell.view_Outer.addGestureRecognizer(tap)
//        let img = dictImages[permission]
//        cell.img_Icon.image = UIImage(named: img ?? "announcement")
        return cell
    }
    func showSubscriptionAlert(title:String){
        self.displayErrorAlert(alertStr: "\(title) is currently not available in your subscription. Please contact us to find out more on how to unlock this function for your property.", title: "")
    }
    @objc @IBAction func actionIcon(_ sender: UIButton){
        self.view.endEditing(true)
      
        
       
        let menu = array_Menus[sender.tag]
        if menu.menus_lists.count > 0{
            let permission = menu.menus_lists[0].permission
            if permission == 1 || menu.menu_group == kEFormSubmission{
        switch menu.menu_group{//module?.name.trimmingTrailingSpaces {
       // switch permission {
        case kUserManagement:
            self.actionUserManagement(UIButton())
            case kAnnouncement:
                self.actionAnnouncement(UIButton())
            case kKeyCollection:
                self.actionAppointmemtUnitTakeOver(UIButton())
            case kDefectList:
                self.actionDefectList(UIButton())
            case kDefectInspection:
                self.actionAppointmentJointInspection(UIButton())
            case kFacilities:
                self.actionFacilityBooking(UIButton())
            case kFeedback:
                self.actionFeedback(UIButton())
            case kCondoDocument:
                self.actionCondoDocument(UIButton())
        case kResidentsFileUpload:
            self.actionResidentFileUpload(UIButton())
        case kEFormSubmission:
            self.actionEForms(UIButton())
        case kCardAcess:
            self.actionCardManagement(UIButton())
        case kDeviceManagement:
            self.actionDeviceManagement(UIButton())
        case kSettings:
            self.goToSettings()
        case kManageRole:
            self.actionManageRole(UIButton())
        case kStaffDigitalAccess:
            self.actionStaffDigitalAccess(sender)
            default:
                break
            }
            }
            else if permission == 2{
                self.showSubscriptionAlert(title:menu.menu_group)
            }
        }
            
            
       // }
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        self.view.endEditing(true)
        let menu = array_Menus[(sender! as UITapGestureRecognizer).view!.tag]
       // let module = self.array_Modules.first(where:{ $0.id == Int(permission.module_id)})
      //  if module != nil{
        switch menu.menu_group{//module?.name.trimmingTrailingSpaces {
       // switch permission{
            case kAnnouncement:
                self.actionAnnouncement(UIButton())
            case kUnitTakeOver:
                self.actionAppointmemtUnitTakeOver(UIButton())
            case kDefectList:
                self.actionDefectList(UIButton())
            case kJointInspection:
                self.actionAppointmentJointInspection(UIButton())
            case kFacilities:
                self.actionFacilityBooking(UIButton())
            case kFeedback:
                self.actionFeedback(UIButton())
            case kCondoDocument:
                self.actionCondoDocument(UIButton())
            case kResidentsFileUpload:
                self.actionResidentFileUpload(UIButton())
            case kSettings:
                self.goToSettings()
        case kManageRole:
            self.actionManageRole(UIButton())
        case kStaffDigitalAccess:
            let btn = UIButton()
            btn.tag = (sender! as UITapGestureRecognizer).view!.tag
            self.actionStaffDigitalAccess(btn)
            default:
                break
            }
            
            
            
       // }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
    

