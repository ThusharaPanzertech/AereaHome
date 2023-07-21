//
//  UnitIInfoSummaryTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 21/03/23.
//

import UIKit
import DropDown

class UnitIInfoSummaryTableViewController: BaseTableViewController {
    
    //Outlets
    @IBOutlet weak var view_SwitchProperty: UIView!
    @IBOutlet weak var lbl_SwitchProperty: UILabel!
    @IBOutlet weak var txt_Building: UITextField!
    @IBOutlet weak var txt_Unit: UITextField!
    @IBOutlet weak var txt_Type: UITextField!


    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var imgView_Profile: UIImageView!
    @IBOutlet var arr_Textfields: [UITextField]!

    let menu: MenuView = MenuView.getInstance
    @IBOutlet weak var table_UnitList: UITableView!
    var dataSource = DataSource_UnitList()
      
    var array_UnitListType = [String : String]()
    var array_BuildingList = [Building]()
    var unitsData = [Unit]()
    var unitsArray = [Unit]()
    var selectedType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        table_UnitList.dataSource = dataSource
        table_UnitList.delegate = dataSource
        dataSource.parentVc = self
        setUpUI()
        getBuildingSummaryLists()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //selectedRowIndex_Feedback = -1
        self.showBottomMenu()
        getUnitList()
       
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.closeMenu()
    }
   
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        if indexPath.row == 1{
            return CGFloat((195 * unitsData.count) + 400)
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
       
        for txtField in arr_Textfields{
            txtField.delegate = self
            txtField.layer.cornerRadius = 20.0
            txtField.layer.masksToBounds = true
            txtField.textColor = textColor
            txtField.attributedPlaceholder = NSAttributedString(string: txtField.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
        }
       
    }
    //MARK: ******  PARSING *********
    func getUnitList(){
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.get_UnitList(parameters: ["login_id":userId], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? UnitBase){
                    self.unitsData = response.units
                    self.dataSource.unitsData = response.units
                     if self.unitsArray.count == 0{
                         self.unitsArray = self.unitsData
                     }
                     DispatchQueue.main.async {
                         self.table_UnitList.reloadData()
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
    func searchUnitList(){
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        var bid = 0
        if let building = array_BuildingList.first(where: { $0.building == txt_Building.text }) {
            bid = building.id
        }
        ApiService.search_UnitList(parameters: ["login_id":userId, "building": bid, "unit": txt_Unit.text!], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? SearchUnitBase){
                    self.unitsData = response.units
                    self.dataSource.unitsData = response.units
                   
                     DispatchQueue.main.async {
                         self.table_UnitList.reloadData()
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
    func getBuildingSummaryLists(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        
        ApiService.get_buildingSummaryList(parameters: ["login_id":userId], completion: { status, result, error in
            self.getUnitListType()
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? BuildingSummaryBase){
                     self.array_BuildingList = response.data
                    
                     self.dataSource.array_BuildingList = self.array_BuildingList
                     DispatchQueue.main.async {
                         self.table_UnitList.reloadData()
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
    func getUnitListType(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        
        ApiService.get_UnitListTyps(parameters: ["login_id":userId], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? UnitListTypeBase){
                     self.array_UnitListType = response.type
                    
                   
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
    @IBAction func actionSearch(_ sender:UIButton) {
        //self.searchFeedbacks()
        searchUnitList()
    }
    @IBAction func actionClear(_ sender:UIButton) {
        self.txt_Unit.text = ""
        txt_Type.text = ""
        txt_Building.text = ""
       
        self.getUnitList()
        
        
    }
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
    @IBAction func actionUnit(_ sender:UIButton) {
       // let sortedArray = unitsData.sorted(by:  { $0.1 < $1.1 })
        let arrUnit = unitsArray.map { $0.unit }
        let dropDown_Unit = DropDown()
        dropDown_Unit.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Unit.dataSource = arrUnit// Array(unitsData.values)
        dropDown_Unit.show()
        dropDown_Unit.selectionAction = { [unowned self] (index: Int, item: String) in
            txt_Unit.backgroundColor = UIColor.white
            txt_Unit.text = item
            
            
        }
    }
      
    @IBAction func actionBuilding(_ sender:UIButton) {
        let arrUnit = array_BuildingList.map { $0.building }
        let dropDown_Unit = DropDown()
        dropDown_Unit.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Unit.dataSource = arrUnit// Array(unitsData.values)
        dropDown_Unit.show()
        dropDown_Unit.selectionAction = { [unowned self] (index: Int, item: String) in
            txt_Building.backgroundColor = UIColor.white
            txt_Building.text = item
            
            
        }
    }
   
    @IBAction func actionType(_ sender: UIButton){
        
        let arrUnit = array_UnitListType.sorted { $0.key < $1.key }
        let sortedArray = arrUnit.map { $0.value }
      let dropDown_arrOptions = DropDown()
        dropDown_arrOptions.anchorView = sender // UIView or UIBarButtonItem
        dropDown_arrOptions.dataSource = sortedArray
        dropDown_arrOptions.show()
        dropDown_arrOptions.selectionAction = { [unowned self] (index: Int, item: String) in
  //        txt_BookingType.text = item
  //
  //          bookingType = "\(index + 1)"
            txt_Type.backgroundColor = UIColor.white
            txt_Type.text = item
            self.selectedType   = arrUnit[index].key
            
      }
        
        
       
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
class DataSource_UnitList: NSObject, UITableViewDataSource, UITableViewDelegate {
   
    var unitsData = [Unit]()
    var parentVc: UIViewController!
  
    var array_BuildingList = [Building]()
func numberOfSectionsInTableView(tableView: UITableView) -> Int {

    return 1;
}

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  unitsData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "unitCell") as! UnitInfoTableViewCell
        let unit = unitsData[indexPath.row]
        
        cell.lbl_Id.text = unit.code
        cell.lbl_UnitNo.text = "#" + unit.unit
        cell.lbl_Size.text = unit.size
        cell.lbl_Share.text = unit.share_amount
        if let building = array_BuildingList.first(where: { $0.id == unit.building_id }) {
            cell.lbl_Building.text = building.building
        }
        else{
        cell.lbl_Building.text = ""
        }
        //unitsData["\(feedback.user_info?.unit_no ?? 0)"]
       
        cell.btn_Summary.tag = indexPath.row
           
        cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
        cell.btn_Summary.addTarget(self, action: #selector(self.actionSummary(_:)), for: .touchUpInside)
        cell.view_Outer.tag = indexPath.row
       
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        cell.view_Outer.addGestureRecognizer(tap)
//        if indexPath.row != selectedRowIndex_Feedback{
//            for vw in cell.arrViews{
//                vw.isHidden = true
//            }
//        }
//        else{
//            for vw in cell.arrViews{
//                vw.isHidden = false
//            }
//        }
        
        return cell
      
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 195
        //indexPath.row == selectedRowIndex_Feedback ? 250 : 145
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
//        selectedRowIndex_Feedback = (sender! as UITapGestureRecognizer).view!.tag
//        DispatchQueue.main.async {
//            (self.parentVc as! FeedbackTableViewController).tableView.reloadData()
//        (self.parentVc as! FeedbackTableViewController).table_FeedbackList.reloadData()
//
//        }
       
       
    }
    @IBAction func actionSummary(_ sender:UIButton){
//        let feedback = array_Feedbacks[sender.tag]
        let unitListTypVC = self.parentVc.storyboard?.instantiateViewController(identifier: "UnitListTypeTableViewController") as! UnitListTypeTableViewController
        unitListTypVC.array_BuildingList = self.array_BuildingList
        unitListTypVC.unitsData = self.unitsData
        unitListTypVC.unit_selected = unitsData[sender.tag]
        self.parentVc.navigationController?.pushViewController(unitListTypVC, animated: true)
       
    }
}
extension UnitIInfoSummaryTableViewController: MenuViewDelegate{
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

   
   





extension UnitIInfoSummaryTableViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
       
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text!.count > 0{
            textField.backgroundColor = UIColor.white
        }
        else{
            textField.backgroundColor = UIColor(red: 208/255, green: 208/255, blue: 208/255, alpha: 1.0)
        }
           
        
    }
   
}
