//
//  ManagePasswordTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 27/09/21.
//

import UIKit

class ManagePasswordTableViewController: BaseTableViewController {
    //Outlets
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var txt_OldPassword: UITextField!
    @IBOutlet weak var txt_NewPassword: UITextField!
    @IBOutlet weak var txt_ConfirmPassword: UITextField!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btn_Submit: UIButton!
    var selectedFeedbackName = ""
    let menu: MenuView = MenuView.getInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        self.showBottomMenu()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.closeMenu()
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
extension ManagePasswordTableViewController: MenuViewDelegate{
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
