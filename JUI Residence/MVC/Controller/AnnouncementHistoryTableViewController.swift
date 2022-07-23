//
//  AnnouncementHistoryTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 26/07/21.
//

import UIKit
import CalendarDateRangePickerViewController
import DropDown

class AnnouncementHistoryTableViewController: BaseTableViewController {

    //Outlets
    @IBOutlet weak var txt_DateRange: UITextField!
    @IBOutlet weak var txt_AssignedRole: UITextField!
    @IBOutlet weak var table_Announcement: UITableView!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var view_Footer: UIView!
    @IBOutlet weak var imgView_Profile: UIImageView!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var btn_NewAppointment: UIButton!
    var dateRangePickerViewController : CalendarDateRangePickerViewController!
    var dataSource = DataSource_AnnouncementHistory()
    let menu: MenuView = MenuView.getInstance
    var array_Announcements = [AnnouncementModal]()
    var tableHeight: CGFloat = 0
    var heightSet = false
    var startDate = ""
    var endDate = ""
    var roles = [String: String]()
    var array_roles = [Role]()
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
        
        txt_DateRange.textColor = textColor
        txt_DateRange.attributedPlaceholder = NSAttributedString(string: txt_DateRange.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
    
        txt_AssignedRole.textColor = textColor
        txt_AssignedRole.attributedPlaceholder = NSAttributedString(string: txt_AssignedRole.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
    
        view_Background.layer.cornerRadius = 25.0
        view_Background.layer.masksToBounds = true
        table_Announcement.dataSource = dataSource
        table_Announcement.delegate = dataSource
        dataSource.parentVc = self
        
        txt_DateRange.layer.cornerRadius = 20.0
        txt_DateRange.layer.masksToBounds = true
        txt_AssignedRole.layer.cornerRadius = 20.0
        txt_AssignedRole.layer.masksToBounds = true
        imgView_Profile.addborder()
        btn_NewAppointment.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
      
        btn_NewAppointment.layer.cornerRadius = 10.0
        self.getRolesList()

    }
    
   
  
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //self.tableHeight = self.table_Announcement.contentSize.height
             //   print(self.tableHeight)
        if self.tableHeight > 0 && heightSet == false{
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.heightSet = true
        }
       }
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1{
            return tableHeight > 0 ?  tableHeight + 400 :  super.tableView(tableView, heightForRowAt: indexPath)
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return view_Footer
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 150

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAnnouncements()
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
    
    //MARK: ******  PARSING *********
    func getRolesList(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"        //
        ApiService.get_RolesList(parameters: ["login_id":userId], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? RolesBase){
                    self.roles = response.roles
                     self.array_roles = response.data
                   
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
    func getAnnouncements(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.get_Announcement(parameters: ["login_id":userId], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? AnnouncementModalBase){
                    self.array_Announcements = response.announcements
                    kImageFilePath = response.file_path
                    if(self.array_Announcements.count > 0){
                        self.array_Announcements = self.array_Announcements.sorted(by: { $0.created_at > $1.created_at })
                    }
                    self.dataSource.array_Announcements = self.array_Announcements
                    if self.array_Announcements.count == 0{

                    }
                    else{
                       // self.view_NoRecords.removeFromSuperview()
                    }
                    var ht: CGFloat = 0
                    for obj in self.array_Announcements{
                    let labelHeight = self.heightForView(text:obj.title, font:UIFont(name: "Helvetica-Bold", size: 17.0)!, width:kScreenSize.width - 75)

                    ht = ht + 70 + labelHeight
                    }
                    self.tableHeight = ht
                    self.table_Announcement.reloadData()
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
    func searchAnnouncements(){
        self.heightSet = false
        var role_Id = ""
        if let roleId = roles.first(where: { $0.value == txt_AssignedRole.text })?.key {
            role_Id = roleId
        }
        
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.search_Announcement(parameters: ["login_id":userId, "startdate": self.startDate, "enddate":self.endDate, "roles":role_Id], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? AnnouncementModalBase){
                    self.array_Announcements = response.announcements
                    if(self.array_Announcements.count > 0){
                        self.array_Announcements = self.array_Announcements.sorted(by: { $0.created_at > $1.created_at })
                    }
                    self.dataSource.array_Announcements = self.array_Announcements
                    if self.array_Announcements.count == 0{

                    }
                    else{
                       // self.view_NoRecords.removeFromSuperview()
                    }
                    DispatchQueue.main.async {
                    self.table_Announcement.reloadData()
                    self.tableView.reloadData()
                        self.heightSet = true
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
    @IBAction func actionDateRangex(_ sender: UIButton){
        let dateRangePickerViewController = CalendarDateRangePickerViewController(collectionViewLayout: UICollectionViewFlowLayout())
          dateRangePickerViewController.delegate = self
          //dateRangePickerViewController.selectedStartDate = Date()
         // dateRangePickerViewController.selectedEndDate = Date()
        var components = Calendar.current.dateComponents([.year], from: Date())
        if let startDateOfYear = Calendar.current.date(from: components) {
            components.year = 1
            components.day = -1
            let lastDateOfYear = Calendar.current.date(byAdding: components, to: startDateOfYear)
            dateRangePickerViewController.minimumDate = startDateOfYear
             dateRangePickerViewController.maximumDate = lastDateOfYear
        }
        //   let minimumDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())
        
        //let maximumDate = Calendar.current.date(byAdding: .year, value: 1, to: Date())
        
        
     //   dateRangePickerViewController.minimumDate = minimumDate
     //   dateRangePickerViewController.maximumDate = maximumDate
        
       

        
        
          let navigationController = UINavigationController(rootViewController: dateRangePickerViewController)
        //dateRangePickerViewController.collectionView.scrollToItem(at:IndexPath(item: 3, section: 16), at: .bottom, animated: false)
          self.navigationController?.present(navigationController, animated: true, completion: nil)
       
    }
    @IBAction func actionRoles(_ sender:UIButton) {
//        let sortedArray = roles.sorted { $0.key < $1.key }
//        let arrRoles = sortedArray.map { $0.value }
        
      //  let sortedArray = roles.sorted { $0.key < $1.key }
        let arrRoles = array_roles.map { $0.name! }
        let dropDown_Roles = DropDown()
        dropDown_Roles.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Roles.dataSource = arrRoles//Array(roles.values)
        dropDown_Roles.show()
        dropDown_Roles.selectionAction = { [unowned self] (index: Int, item: String) in
            txt_AssignedRole.text = item
           
            self.searchAnnouncements()
            
        }
    }
    @IBAction func actionNewAnnouncement(_ sender: UIButton){
        let announcementTVC = self.storyboard?.instantiateViewController(identifier: "AnnouncementTableViewController") as! AnnouncementTableViewController
        announcementTVC.roles = self.roles
        self.navigationController?.pushViewController(announcementTVC, animated: true)
    }
    //MARK: MENU ACTIONS
    
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
class DataSource_AnnouncementHistory: NSObject, UITableViewDataSource, UITableViewDelegate {
    var array_Announcements = [AnnouncementModal]()
    var parentVc: UIViewController!
   
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
   
func numberOfSectionsInTableView(tableView: UITableView) -> Int {

    return 1;
}

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  array_Announcements.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "announcementHistoryCell") as! AnnouncementHistoryTableViewCell
        cell.selectionStyle = .none
        
        let announcement = array_Announcements[indexPath.row]
        cell.lbl_Title.text = announcement.title
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.date(from: announcement.created_at)
        formatter.dateFormat = "dd MMM yyyy"
        let dateStr = formatter.string(from: date ?? Date())
        cell.selectionStyle = .none
       
        cell.lbl_Date.text = "Submitted on \(dateStr)"
        
        cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
      
        cell.view_Outer.layer.cornerRadius = 10.0
       
        cell.view_Outer.tag = indexPath.row
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        cell.view_Outer.addGestureRecognizer(tap)
        return cell
      
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let announcement = array_Announcements[indexPath.row]
        let labelHeight = self.heightForView(text:announcement.title, font:UIFont(name: "Helvetica-Bold", size: 17.0)!, width:kScreenSize.width - 75)

        return 70 + labelHeight
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let announcement = array_Announcements[indexPath.row]
        let announcementDetailsVC = self.parentVc.storyboard?.instantiateViewController(identifier: "AnnouncementDetailsTableViewController") as! AnnouncementDetailsTableViewController
        announcementDetailsVC.announcement = announcement
        self.parentVc.navigationController?.pushViewController(announcementDetailsVC, animated: true)
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        let announcement = array_Announcements[(sender! as UITapGestureRecognizer).view!.tag]
        let announcementDetailsVC = self.parentVc.storyboard?.instantiateViewController(identifier: "AnnouncementDetailsTableViewController") as! AnnouncementDetailsTableViewController
        announcementDetailsVC.announcement = announcement
//        let unreadList = self.array_AnnouncementViewStatus.first(where:{ $0.a_id == Int(announcement.id)})
//        if unreadList?.view_status == 0{
//            announcementDetailsVC.updateStatus = true
//        }
        self.parentVc.navigationController?.pushViewController(announcementDetailsVC, animated: true)
       
    }
   
}
extension AnnouncementHistoryTableViewController: MenuViewDelegate{
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
extension AnnouncementHistoryTableViewController: CalendarDateRangePickerViewControllerDelegate{
    func didTapDoneWithDateRange(startDate: Date!, endDate: Date!) {
        //fromDate = startDate
      //  toDate = endDate
        
        self.startDate  = self.getDateString(date: startDate, format: "yyyy-MM-dd")
        self.endDate = self.getDateString(date: endDate, format: "yyyy-MM-dd")
        
        let fromDate = self.getDateString(date: startDate, format: "dd/MM/yy")
        let toDate = self.getDateString(date: endDate, format: "dd/MM/yy")
        self.txt_DateRange.text = "\(fromDate) - \(toDate)"
        self.searchAnnouncements()
        self.navigationController?.dismiss(animated: true, completion: nil)
       
    }
    
    func didTapCancel() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    func getDateString(date: Date, format: String) -> String{
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
       
        formatter.dateFormat = format//"dd/MM/yy"
        let dateStr = formatter.string(from: date ?? Date())
        
       
        
        return dateStr
    }
}
