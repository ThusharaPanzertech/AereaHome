//
//  SettingsSubMenuTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 08/07/22.
//

import UIKit
import DropDown
class SettingsSubMenuTableViewController: BaseTableViewController {
    let menu: MenuView = MenuView.getInstance
    var settingsMenu: DashboardMenu!
    var settingsMenu_Filetered = [DashboardMenuList]()
    var array_Modules = [Module]()
    var dictImages = [String:String]()
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var imgView_Logo: UIImageView!
    @IBOutlet weak var view_NoRecords: UIView!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var collection_HomeIcon: UICollectionView!
    @IBOutlet weak var imgView_Profile: UIImageView!
    @IBOutlet weak var view_SwitchProperty: UIView!
    @IBOutlet weak var lbl_SwitchProperty: UILabel!
    var heightSet = false
    var tableHeight: CGFloat = 0
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view_SwitchProperty.layer.borderColor = themeColor.cgColor
        view_SwitchProperty.layer.borderWidth = 1.0
        view_SwitchProperty.layer.cornerRadius = 10.0
        view_SwitchProperty.layer.masksToBounds = true
        lbl_SwitchProperty.text = kCurrentPropertyName
        lbl_Title.text = settingsMenu.menu_group
        imgView_Profile.addborder()
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
      
        dictImages = [kAppointmentSettings:"appointment",kManageRole:"manage_role",kManageUnit:"manage_unit",kFeedbackOptions:"defects_list",kDefectLocation:"defect_inspection",kFacilityType:"facility_booking", kVisitingPurpose:"feedback", kBuildingManagement : "manage_building",
                           kEformSettings1 : "eform_settings",
                          kPaymentSettings: "payment_settings", kUploadFace: "upload_face",kStaffDoorOpen :"digital_access", kStaffRemoteDoorOpen : "digital_access",
                  kStaffBluetoothDoorOpen :"digital_access",kManageProperty: "manage_property", kAppDashboardSettings: "dashboard_settings", kHolidaySettings: "holiday_settings"]
        
        self.setUpCollectionViewLayout()
        for menu in settingsMenu.menus_lists{
            if menu.permission == 1 || menu.permission == 2{
                settingsMenu_Filetered.append(menu)
            }
        }
        collection_HomeIcon.reloadData()
    }
    //MARK: ******  PARSING *********
 
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
    @IBAction func actionAppointmentSettings(_ sender: UIButton){
        let appointmentSettingsTVC = kStoryBoardSettings.instantiateViewController(identifier: "AppointmentSettingsTableViewController") as! AppointmentSettingsTableViewController
        self.navigationController?.pushViewController( appointmentSettingsTVC, animated: true)
    }
    @IBAction func actionManageRole(_ sender: UIButton){
       let rolesTVC = self.storyboard?.instantiateViewController(identifier: "RolesTableViewController") as! RolesTableViewController
        self.navigationController?.pushViewController(rolesTVC, animated: true)
    }
    @IBAction func actionManageUnit(_ sender: UIButton){
        let manageUnitTVC = self.storyboard?.instantiateViewController(identifier: "ManageUnitTableViewController") as! ManageUnitTableViewController
        self.navigationController?.pushViewController(manageUnitTVC, animated: true)
    }
    @IBAction func actionFeedbackOptions(_ sender: UIButton){
        let feedbackOptionsTVC = self.storyboard?.instantiateViewController(identifier: "ServiceSummaryTableViewController") as! ServiceSummaryTableViewController
        feedbackOptionsTVC.service = .feedbackOptions
        self.navigationController?.pushViewController(feedbackOptionsTVC, animated: true)
    }
    @IBAction func actionDefectLocation(_ sender: UIButton){
        let defectLocTVC = self.storyboard?.instantiateViewController(identifier: "ServiceSummaryTableViewController") as! ServiceSummaryTableViewController
        defectLocTVC.service = .defectsLocation
        self.navigationController?.pushViewController(defectLocTVC, animated: true)
    }
    @IBAction func actionFacilityType(_ sender: UIButton){
        let feedbackOptionsTVC = self.storyboard?.instantiateViewController(identifier: "ServiceSummaryTableViewController") as! ServiceSummaryTableViewController
        feedbackOptionsTVC.service = .facilityType
        self.navigationController?.pushViewController(feedbackOptionsTVC, animated: true)
    }
    @IBAction func actionVisitingPurpose(_ sender: UIButton){
        let visitingPurposeTVC = self.storyboard?.instantiateViewController(identifier: "VisitingPurposeTableViewController") as! VisitingPurposeTableViewController
        self.navigationController?.pushViewController(visitingPurposeTVC, animated: true)
    }
    @IBAction func actionPaymentSettings(_ sender: UIButton){
        let paymentSettingsTVC = kStoryBoardSettings.instantiateViewController(identifier: "PaymentSettingsTableViewController") as! PaymentSettingsTableViewController
        self.navigationController?.pushViewController(paymentSettingsTVC, animated: true)
    }
    @IBAction func actionHolidaySettings(_ sender: UIButton){
        let holidaySettingsTVC = kStoryBoardSettings.instantiateViewController(identifier: "HolidaySettingsTableViewController") as! HolidaySettingsTableViewController
        self.navigationController?.pushViewController(holidaySettingsTVC, animated: true)
    }
    @IBAction func actionUploadFace(_ sender: UIButton){
        let faceListTVC = kStoryBoardMenu.instantiateViewController(identifier: "Staff_FaceListTableViewController") as! Staff_FaceListTableViewController
        self.navigationController?.pushViewController(faceListTVC, animated: true)
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
        let settingsTVC = kStoryBoardSettings.instantiateViewController(identifier: "SettingsTableViewController") as! SettingsTableViewController
        self.navigationController?.pushViewController(settingsTVC, animated: true)
    }
    @IBAction func actionRemoteDeviceList(_ sender: UIButton){
        let deviceListTVC = kStoryBoardMenu.instantiateViewController(identifier: "DeviceListTableViewController") as! DeviceListTableViewController
        deviceListTVC.isBluetooth = false
        self.navigationController?.pushViewController(deviceListTVC, animated: true)
    }
    @IBAction func actionBluetoothDeviceList(_ sender: UIButton){
        let deviceListTVC = kStoryBoardMenu.instantiateViewController(identifier: "DeviceListTableViewController") as! DeviceListTableViewController
        deviceListTVC.isBluetooth = true
        self.navigationController?.pushViewController(deviceListTVC, animated: true)
    }
    @IBAction func actionManageBuilding(_ sender: UIButton){
        let buildingListTVC = kStoryBoardSettings.instantiateViewController(identifier: "BuildingSummaryTableViewController") as! BuildingSummaryTableViewController
        self.navigationController?.pushViewController(buildingListTVC, animated: true)
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
    
}
extension SettingsSubMenuTableViewController: MenuViewDelegate{
    func onMenuClicked(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            
            self.navigationController?.popToRootViewController(animated: true)
            break
        case 2:
            self.goToNotification()
            break
        case 3:
          //  self.goToSettings()
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
extension SettingsSubMenuTableViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settingsMenu_Filetered.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCell", for: indexPath) as! HomeIconCollectionViewCell
   
        cell.view_Outer.layer.cornerRadius = 6.0

        cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.gray, radius: 3.0, opacity: 0.35)
    
        let permission = settingsMenu_Filetered[indexPath.row]
       // cell.lbl_Heading.text = per
       // let module = self.array_Modules.first(where:{ $0.id == Int(permission.module_id)})
        cell.lbl_Heading.text = permission.name//module?.name
        
       // if module != nil{
            let img = dictImages[(permission.name.trimmingTrailingSpaces)]
            cell.img_Icon.image = UIImage(named: img ?? "announcement")
//        }
//        else{
//            cell.img_Icon.image = UIImage(named:"announcement")
//        }
 
       // cell.lbl_Heading.text = obj
      //  let permission = array_Permissions[indexPath.row]
        /*let module = self.array_Modules.first(where:{ $0.id == Int(obj.module_id)})
        cell.lbl_Heading.text = module?.name
        if module?.name == "Announcement"{
            let count = UserInfoModalBase.currentUser?.data.notifications?.announcement
            if count != nil{
            if count! > 0{
                cell.lbl_NotificationCount.isHidden = false
                cell.lbl_NotificationCount.text = "\(count!)"
            }
            }
        }
        if module != nil{
            let img = dictImages[(module?.name.trimmingTrailingSpaces)!]
            cell.img_Icon.image = UIImage(named: img ?? "announcement")
        }
        else{
            cell.img_Icon.image = UIImage(named:"announcement")
        }
 */
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
        let permission = settingsMenu_Filetered[sender.tag]

        if permission.permission == 1{
        switch permission.name.trimmingTrailingSpaces {
        case kAppointmentSettings:
           
            self.actionAppointmentSettings(UIButton())
        case kManageRole:
            self.actionManageRole(UIButton())
        case kManageUnit:
            self.actionManageUnit(UIButton())
        case kFeedbackOptions:
            self.actionFeedbackOptions(UIButton())
        case kDefectLocation:
            self.actionDefectLocation(UIButton())
        case kFacilityType:
            self.actionFacilityType(UIButton())
        case kVisitingPurpose:
            self.actionVisitingPurpose(UIButton())
        case kPaymentSettings:
            self.actionPaymentSettings(UIButton())
        case kHolidaySettings:
            self.actionHolidaySettings(UIButton())
        case kUploadFace:
            self.actionUploadFace(UIButton())
        case kStaffRemoteDoorOpen:
            self.actionRemoteDeviceList(UIButton())
        case  kStaffBluetoothDoorOpen:
            self.actionBluetoothDeviceList(UIButton())
        case kBuildingManagement:
            self.actionManageBuilding(UIButton())
            default:
                break
            }
        }
        else{
            self.showSubscriptionAlert(title:permission.name.trimmingTrailingSpaces)
        }
            
            
      //  }
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
        let permission = settingsMenu_Filetered[(sender! as UITapGestureRecognizer).view!.tag]
       // let module = self.array_Modules.first(where:{ $0.id == Int(permission.module_id)})
     //   if module != nil{
        if permission.permission == 1{
           switch permission.name.trimmingTrailingSpaces {
            case kAppointmentSettings:
                self.actionAppointmentSettings(UIButton())
            case kManageRole:
                self.actionManageRole(UIButton())
            case kManageUnit:
                self.actionManageUnit(UIButton())
            case kFeedbackOptions:
                self.actionFeedbackOptions(UIButton())
            case kDefectLocation:
                self.actionDefectLocation(UIButton())
            case kFacilityType:
                self.actionFacilityType(UIButton())
            case kVisitingPurpose:
                self.actionVisitingPurpose(UIButton())
           case kPaymentSettings:
               self.actionPaymentSettings(UIButton())
           case kHolidaySettings:
               self.actionHolidaySettings(UIButton())
           case kUploadFace:
               self.actionUploadFace(UIButton())
           case kBuildingManagement:
               self.actionManageBuilding(UIButton())
            default:
                break
            }
        }
        else{
            self.showSubscriptionAlert(title:permission.name.trimmingTrailingSpaces)
        }
            
       // }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
    


