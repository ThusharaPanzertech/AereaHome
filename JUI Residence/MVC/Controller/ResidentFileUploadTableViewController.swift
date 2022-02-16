//
//  ResidentFileUploadTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 28/12/21.
//

import UIKit

class ResidentFileUploadTableViewController: BaseTableViewController {
    //Outlets
    @IBOutlet weak var txt_Category: UITextField!
    @IBOutlet weak var txt_Status: UITextField!
    @IBOutlet weak var txt_UnitNo: UITextField!
    @IBOutlet weak var txt_Month: UITextField!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var imgView_Profile: UIImageView!
    @IBOutlet weak var btn_NewAppointment: UIButton!
    @IBOutlet weak var view_Footer: UIView!
    @IBOutlet weak var table_AppointmentUnitTakeOver: UITableView!
    @IBOutlet var arrTextFields: [UITextField]!
    
    var dataSource = DataSource_ResidentFile()
    let menu: MenuView = MenuView.getInstance
    
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
        let fname = Users.currentUser?.user?.name ?? ""
        let lname = Users.currentUser?.moreInfo?.last_name ?? ""
        self.lbl_UserName.text = "\(fname) \(lname)"
        let role = Users.currentUser?.role?.name ?? ""
        self.lbl_UserRole.text = role
        table_AppointmentUnitTakeOver.dataSource = dataSource
        table_AppointmentUnitTakeOver.delegate = dataSource
        dataSource.parentVc = self
        setUpUI()
       
    }
    func setUpUI(){
        for field in arrTextFields{
            field.layer.cornerRadius = 20.0
            field.layer.masksToBounds = true
            field.delegate = self
            field.textColor = textColor
            field.attributedPlaceholder = NSAttributedString(string: field.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
        }
        view_Background.layer.cornerRadius = 25.0
        view_Background.layer.masksToBounds = true
      
        imgView_Profile.addborder()
        btn_NewAppointment.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
      
        btn_NewAppointment.layer.cornerRadius = 10.0


    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return view_Footer
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 150

    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 1{
            
                return  (3 * 210)  + 310
            
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
//MARK: UIBUTTON ACTION
    @IBAction func actionNewUpload(_ sender: UIButton){
//        let announcementTVC = self.storyboard?.instantiateViewController(identifier: "NewAppointmentTableViewController") as! NewAppointmentTableViewController
//        self.navigationController?.pushViewController(announcementTVC, animated: true)
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
class DataSource_ResidentFile: NSObject, UITableViewDataSource, UITableViewDelegate {

    var parentVc: UIViewController!

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "appointmentUnitCell") as! AppointmentUnitTakeOverTableViewCell
        cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
       // cell.lbl_AppointmentDate.text = "11/08/2021"
      //  cell.lbl_AppointmentTime.text = "9:00 AM"
      //  cell.lbl_Status.text = "Pending".uppercased()
       //     cell.lbl_UnitNo.text = "06-\(indexPath.row + 1)"
          
        cell.view_Outer.tag = indexPath.row
        cell.btn_Edit.tag = indexPath.row
        cell.btn_Edit.addTarget(self, action: #selector(self.actionEdit(_:)), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        cell.view_Outer.addGestureRecognizer(tap)
       
            return cell
      
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return  210
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
//        DispatchQueue.main.async {
//            (self.parentVc as! AppointmentUnitTakeOverTableViewController).tableView.reloadData()
//        (self.parentVc as! AppointmentUnitTakeOverTableViewController).table_AppointmentUnitTakeOver.reloadData()
//
//        }
        
    }
    
    @IBAction func actionEdit(_ sender:UIButton){
       
       
       
       
    }
}


extension ResidentFileUploadTableViewController: MenuViewDelegate{
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

   
   

extension ResidentFileUploadTableViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
