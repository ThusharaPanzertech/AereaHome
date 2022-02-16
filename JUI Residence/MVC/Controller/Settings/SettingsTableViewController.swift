//
//  SettingsTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 23/07/21.
//

enum ServiceType {
    case property
    case role
    case feedbackOptions
    case defectsLocation
    case facilityType
}


import UIKit

class SettingsTableViewController: BaseTableViewController {
    let menu: MenuView = MenuView.getInstance
    var array_Permissions = [String]()
    var dictImages = [String:String]()
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var imgView_Logo: UIImageView!
    @IBOutlet weak var view_NoRecords: UIView!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var collection_HomeIcon: UICollectionView!
    
    
    @IBOutlet weak var imgView_Profile: UIImageView!
    
    
    var heightSet = false
    var tableHeight: CGFloat = 0
    var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let fname = Users.currentUser?.user?.name ?? ""
        let lname = Users.currentUser?.moreInfo?.last_name ?? ""
        self.lbl_UserName.text = "\(fname) \(lname)"
        let role = Users.currentUser?.role?.name ?? ""
        self.lbl_UserRole.text = role
        array_Permissions = [kAppointmentSettings,kManageRole,kManageUnit,kFeedbackOptions,kDefectLocation,kFacilityType,kVisitingPurpose]
        dictImages = [kAppointmentSettings:"appointment",kManageRole:"manage_role",kManageUnit:"manage_unit",kFeedbackOptions:"defects_list",kDefectLocation:"defect_inspection",kFacilityType:"facility_booking", kVisitingPurpose:"feedback"]
        
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
extension SettingsTableViewController: MenuViewDelegate{
    func onMenuClicked(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            
            self.navigationController?.popToRootViewController(animated: true)
            break
        case 2:
           // self.goToSettings()
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
extension SettingsTableViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array_Permissions.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCell", for: indexPath) as! HomeIconCollectionViewCell
       // cell.lbl_NotificationCount.layer.cornerRadius = 10.0
       // cell.lbl_NotificationCount.layer.masksToBounds = true
       // cell.lbl_NotificationCount.isHidden = true
        let obj = self.array_Permissions[indexPath.item]
        cell.view_Outer.layer.cornerRadius = 6.0
//        cell.view_Outer.layer.masksToBounds = true
//        cell.view_Outer.layer.borderColor = UIColor.black.cgColor
//        cell.view_Outer.layer.borderWidth = 1.0
       // cell.view_Outer.dropShadow()
        cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.gray, radius: 3.0, opacity: 0.35)
      //  cell.view_Outer.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 2, scale: true)

        cell.lbl_Heading.text = obj
        let permission = array_Permissions[indexPath.row]
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
        let img = dictImages[permission]
        cell.img_Icon.image = UIImage(named: img ?? "announcement")
        return cell
    }
    @objc @IBAction func actionIcon(_ sender: UIButton){
        self.view.endEditing(true)
        let permission = array_Permissions[sender.tag]
      
       // let module = self.array_Modules.first(where:{ $0.id == Int(permission.module_id)})
      //  if module != nil{
       //     switch module?.name.trimmingTrailingSpaces {
        switch permission {
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
           
            default:
                break
            }
            
            
            
       // }
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        self.view.endEditing(true)
        let permission = array_Permissions[(sender! as UITapGestureRecognizer).view!.tag]
        //let module = self.array_Modules.first(where:{ $0.id == Int(permission.module_id)})
       // if module != nil{
           //switch module?.name.trimmingTrailingSpaces {
        switch permission{
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
       
            default:
                break
            }
            
            
            
       // }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
    


