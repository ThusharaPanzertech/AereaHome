//
//  SettingsTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 23/07/21.
//

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
        @IBOutlet weak var collection_Settings: UICollectionView!
        var heightSet = false
        var tableHeight: CGFloat = 0
        var timer = Timer()
        override func viewDidLoad() {
            super.viewDidLoad()
            array_Permissions = ["Manage Property","Manage Role","Manage Unit","Manage Unit Take Over","Manage Joint Inspection","Feedback Options","Defect Location","Facility Type","Manage Password"]
            
            dictImages = [kManageProperty:"manage_property",kManageRole:"manage_role",kManageUnit:"manage_unit",kManageUnitTakeOver:"appointment_unit_takeover",kManageJointInsp:"appointment_jointinspection",kFeedbackOptions:"feedback",kDefectLocation:"defects_list",kFacilityType:"facility_booking",kManagePassword:"manage_password"]
            
            self.setUpCollectionViewLayout()
        }
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            self.tableHeight = self.collection_Settings.contentSize.height == 0 ? self.collection_Settings.contentSize.height + 100 : self.collection_Settings.contentSize.height + 50
            if self.tableHeight > 0 && heightSet == false{
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.heightSet = true
            }
           }
            
        }
        override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if indexPath.row == 1{
                return tableHeight > 0 ?  tableHeight + 420 :  super.tableView(tableView, heightForRowAt: indexPath)
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
            layout.minimumLineSpacing = 25
            layout.minimumInteritemSpacing = 25
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            let cellWidth = (kScreenSize.width - 120)/CGFloat(3.0)
            let size = CGSize(width: cellWidth, height: cellWidth)
            layout.itemSize = size
            collection_Settings.collectionViewLayout = layout
        
            self.collection_Settings.reloadData()
            
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
            let userManagementTVC = self.storyboard?.instantiateViewController(identifier: "UserManagementTableViewController") as! UserManagementTableViewController
            self.navigationController?.pushViewController(userManagementTVC, animated: true)
        }
        @IBAction func actionAnnouncement(_ sender: UIButton){
            let announcementTVC = self.storyboard?.instantiateViewController(identifier: "AnnouncementTableViewController") as! AnnouncementTableViewController
            self.navigationController?.pushViewController(announcementTVC, animated: true)
        }
        @IBAction func actionAppointmemtUnitTakeOver(_ sender: UIButton){
            let appointmentUnitTVC = self.storyboard?.instantiateViewController(identifier: "AppointmentUnitTakeOverTableViewController") as! AppointmentUnitTakeOverTableViewController
            self.navigationController?.pushViewController(appointmentUnitTVC, animated: true)
        }
        @IBAction func actionDefectList(_ sender: UIButton){
            let defectListTVC = self.storyboard?.instantiateViewController(identifier: "DefectsListTableViewController") as! DefectsListTableViewController
            self.navigationController?.pushViewController(defectListTVC, animated: true)
        }
        @IBAction func actionAppointmentJointInspection(_ sender: UIButton){
            let appointmentUnitTVC = self.storyboard?.instantiateViewController(identifier: "AppointmentUnitTakeOverTableViewController") as! AppointmentUnitTakeOverTableViewController
            self.navigationController?.pushViewController(appointmentUnitTVC, animated: true)
        }
        @IBAction func actionFacilityBooking(_ sender: UIButton){
            let facilityBookingTVC = self.storyboard?.instantiateViewController(identifier: "FacilityBookingTableViewController") as! FacilityBookingTableViewController
            self.navigationController?.pushViewController(facilityBookingTVC, animated: true)
        }
        @IBAction func actionFeedback(_ sender: UIButton){
            let feedbackTVC = self.storyboard?.instantiateViewController(identifier: "FeedbackTableViewController") as! FeedbackTableViewController
            self.navigationController?.pushViewController(feedbackTVC, animated: true)
        }
        func goToSettings(){
            let settingsTVC = self.storyboard?.instantiateViewController(identifier: "SettingsTableViewController") as! SettingsTableViewController
            self.navigationController?.pushViewController(settingsTVC, animated: true)
        }
        
    }
    extension SettingsTableViewController: MenuViewDelegate{
        func onMenuClicked(_ sender: UIButton) {
            switch sender.tag {
            case 1:
                self.navigationController?.popToRootViewController(animated: true)
                break
            case 2:
                self.actionUserManagement(sender)
                break
            case 3:
                self.goToSettings()
                break
            case 4:
                break
            case 5:
                self.actionAnnouncement(sender)
                break
            case 6:
                self.actionAppointmemtUnitTakeOver(sender)
                break
            case 7:
                self.actionDefectList(sender)
                break
            case 8:
                self.actionAppointmentJointInspection(sender)
                break
            case 9:
                self.actionFacilityBooking(sender)
                break
            case 10:
                self.actionFeedback(sender)
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
            cell.lbl_NotificationCount.layer.cornerRadius = 10.0
            cell.lbl_NotificationCount.layer.masksToBounds = true
            cell.lbl_NotificationCount.isHidden = true
            let obj = self.array_Permissions[indexPath.item]
            cell.view_Outer.layer.cornerRadius = 10.0
            cell.view_Outer.layer.masksToBounds = true
            cell.view_Outer.layer.borderColor = UIColor.black.cgColor
            cell.view_Outer.layer.borderWidth = 1.0
            cell.lbl_Heading.text = obj
            
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
            let permission = array_Permissions[indexPath.row]
            let img = dictImages[permission]
            cell.img_Icon.image = UIImage(named: img ?? "announcement")
            cell.view_Outer.tag = indexPath.item
            cell.btn_Icon.tag = indexPath.item
            cell.btn_Icon.addTarget(self, action: #selector(HomeTableViewController.actionIcon(_:)), for: .primaryActionTriggered)
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            cell.view_Outer.addGestureRecognizer(tap)
            
            return cell
        }
        @objc @IBAction func actionIcon(_ sender: UIButton){
            self.view.endEditing(true)
            let permission = array_Permissions[sender.tag]
          
           // let module = self.array_Modules.first(where:{ $0.id == Int(permission.module_id)})
          //  if module != nil{
           //     switch module?.name.trimmingTrailingSpaces {
            switch permission {
                case kAnnouncement:
                    self.actionAnnouncement(UIButton())
                case kUnitTakeOver:
                    self.actionAppointmemtUnitTakeOver(UIButton())
                case kDefect:
                    self.actionDefectList(UIButton())
                case kJointInspection:
                    self.actionAppointmentJointInspection(UIButton())
                case kFacilities:
                    self.actionFacilityBooking(UIButton())
                case kFeedback:
                    self.actionFeedback(UIButton())
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
                case kAnnouncement:
                    self.actionAnnouncement(UIButton())
                case kUnitTakeOver:
                    self.actionAppointmemtUnitTakeOver(UIButton())
                case kDefect:
                    self.actionDefectList(UIButton())
                case kJointInspection:
                    self.actionAppointmentJointInspection(UIButton())
                case kFacilities:
                    self.actionFacilityBooking(UIButton())
                case kFeedback:
                    self.actionFeedback(UIButton())
                default:
                    break
                }
                
                
                
           // }
        }
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
        }
    }
        

