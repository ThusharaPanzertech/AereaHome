//
//  EditUserTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 26/07/21.
//

import UIKit

class EditUserTableViewController: BaseTableViewController {
    let menu: MenuView = MenuView.getInstance
    var dataSource = DataSource_EditUser()
    var array_Modules = [String]()
    var heightSet = false
    var tableHeight: CGFloat = 0
    var isToEdit: Bool!
    //Outlets
    @IBOutlet weak var table_Access: UITableView!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var txt_FirstName: UITextField!
    @IBOutlet weak var txt_LastName: UITextField!
    @IBOutlet weak var txt_Contact: UITextField!
    @IBOutlet weak var txt_Email: UITextField!
    @IBOutlet weak var txt_UnitNo: UITextField!
    @IBOutlet weak var txt_Company: UITextField!
    @IBOutlet weak var txt_MailingAddress: UITextView!
    @IBOutlet weak var txt_AssignedRole: UITextField!
    @IBOutlet weak var txt_Password: UITextField!
    @IBOutlet weak var txt_PostalCode: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let fname = Users.currentUser?.user?.name ?? ""
        let lname = Users.currentUser?.moreInfo?.last_name ?? ""
        self.lbl_UserName.text = "\(fname) \(lname)"
        let role = Users.currentUser?.role?.name ?? ""
        self.lbl_UserRole.text = role
        array_Modules =  ["Announcement", "Appointment - Unit Take Over","Appointment - Joint Inspection", "Defects List", "Defects Location", "Facility Booking", "Facility Type", "Feedback", "Feedback Options", "Property Management", "Property Management", "Role Management", "Unit Management"
                          ]
        
        table_Access.dataSource = dataSource
        table_Access.delegate = dataSource
        dataSource.array_Modules = self.array_Modules
        dataSource.parentVc = self
        table_Access.reloadData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableHeight = self.table_Access.contentSize.height == 0 ? self.table_Access.contentSize.height + 665 : self.table_Access.contentSize.height + 665
        if self.tableHeight > 0 && heightSet == false{
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.heightSet = true
        }
       }
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1{

            return tableHeight > 0 ?  tableHeight   :  super.tableView(tableView, heightForRowAt: indexPath)
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
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
    //MARK: UIBUTTON ACTIONS
    @IBAction func actionAddNew(_ sender: UIButton){
        let addUnitVC = kStoryBoardSettings.instantiateViewController(identifier: "AddEditUnitTableViewController") as! AddEditUnitTableViewController
        addUnitVC.isToEdit = false
        self.navigationController?.pushViewController(addUnitVC, animated: true)
        
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
class DataSource_EditUser: NSObject, UITableViewDataSource, UITableViewDelegate {
    var array_Modules = [String]()
    var parentVc: UIViewController!
    var filePath = ""
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1;
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  array_Modules.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "editCell") as! EditUserAccessTableViewCell
        let role = array_Modules[indexPath.row]
        cell.view_Outer.backgroundColor = indexPath.row % 2 == 0 ? UIColor.white : UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1.0)
        cell.lbl_RoleName.text =  role.uppercased()
        cell.view_Outer.tag = indexPath.row
        
        
        
       
        
       // cell.btn_Delete.addTarget(self, action: #selector(self.actionDelete(_:)), for: .touchUpInside)
        cell.selectionStyle = .none
            return cell
      
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 45
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        /*let service = array_Users[(sender! as UITapGestureRecognizer).view!.tag]
        let addUnitVC = kStoryBoardSettings.instantiateViewController(identifier: "AddEditUnitTableViewController") as! AddEditUnitTableViewController
        addUnitVC.isToEdit = true
        addUnitVC.unitDetails = service
        self.parentVc.navigationController?.pushViewController(addUnitVC, animated: true)*/

    }
    @IBAction func actionDelete(_ sender: UIButton){
    }
    @IBAction func actionEdit(_ sender: UIButton){
        let service = array_Modules[sender.tag]
      /*  let addUnitVC = kStoryBoardSettings.instantiateViewController(identifier: "AddEditUnitTableViewController") as! AddEditUnitTableViewController
        addUnitVC.isToEdit = true
        addUnitVC.unitDetails = service
        self.parentVc.navigationController?.pushViewController(addUnitVC, animated: true)*/
    }
    
}
extension EditUserTableViewController: MenuViewDelegate{
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
