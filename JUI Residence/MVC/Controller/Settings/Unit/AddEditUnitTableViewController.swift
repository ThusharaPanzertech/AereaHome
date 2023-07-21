//
//  AddEditUnitTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 26/09/21.
//

import UIKit
import DropDown
class AddEditUnitTableViewController: BaseTableViewController {
    
    //Outlets
    @IBOutlet weak var view_SwitchProperty: UIView!
    @IBOutlet weak var lbl_SwitchProperty: UILabel!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var txt_Unit: UITextField!
    @IBOutlet weak var txt_Size: UITextField!
    @IBOutlet weak var txt_Share: UITextField!
    @IBOutlet weak var txt_Building: UITextField!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var imgView_Profile: UIImageView!
    @IBOutlet weak var btn_Submit: UIButton!
    @IBOutlet weak var btn_Delete: UIButton!
    @IBOutlet  var arr_Btns: [UIButton]!
    @IBOutlet weak var bottomSpace: NSLayoutConstraint!
    @IBOutlet  var arr_Textfields: [UITextField]!
    var isToDelete = false
    var unitInfo: UnitInfo!
    var isToEdit: Bool!
    let alertView: AlertView = AlertView.getInstance
    let alertView_message: MessageAlertView = MessageAlertView.getInstance
    let menu: MenuView = MenuView.getInstance
    var isToShowSucces = false
    var array_BuildingList = [Building]()
    override func viewDidLoad() {
        super.viewDidLoad()
        getBuildingSummaryLists()
          let fname = Users.currentUser?.moreInfo?.first_name ?? ""
        let lname = Users.currentUser?.moreInfo?.last_name ?? ""
        self.lbl_UserName.text = "\(fname) \(lname)"
        let role = Users.currentUser?.role
        self.lbl_UserRole.text = role
        imgView_Profile.addborder()
        for btn in arr_Btns{
            btn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
            btn.layer.cornerRadius = 8.0
        }
        lbl_SwitchProperty.text = kCurrentPropertyName
        view_SwitchProperty.layer.borderColor = themeColor.cgColor
        view_SwitchProperty.layer.borderWidth = 1.0
        view_SwitchProperty.layer.cornerRadius = 10.0
        view_SwitchProperty.layer.masksToBounds = true
        for txtfield in arr_Textfields{
            txtfield.layer.cornerRadius = 20.0
            txtfield.layer.masksToBounds = true
            txtfield.delegate = self
            txtfield.textColor = textColor
            txtfield.attributedPlaceholder = NSAttributedString(string: txtfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
            txtfield.backgroundColor = isToEdit ? UIColor.white : UIColor(red: 208/255, green: 208/255, blue: 208/255, alpha: 1.0)
        
        }
        if self.unitInfo != nil{
            self.txt_Unit.text = unitInfo.unit
            self.txt_Size.text = self.unitInfo.size
            self.txt_Share.text = self.unitInfo.share_amount
            self.txt_Building.text = self.unitInfo.buildinginfo.building
            self.txt_Unit.isUserInteractionEnabled = false
            btn_Delete.isHidden = false
            btn_Submit.setTitle("Save", for: .normal)
        }
        else{
            btn_Delete.isHidden = true
            self.txt_Unit.isUserInteractionEnabled = true
            btn_Submit.setTitle("Submit", for: .normal)
            bottomSpace.constant = 40
        }
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        self.showBottomMenu()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.closeMenu()
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1{
            return self.isToShowSucces == true ? 0 : kScreenSize.height - 220
        }
        else  if indexPath.row == 2{
            return self.isToShowSucces == false ? 0 : kScreenSize.height - 210
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
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
    
    //MARK: ***************  PARSING ***************
    func getBuildingSummaryLists(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        
        ApiService.get_buildingSummaryList(parameters: ["login_id":userId], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? BuildingSummaryBase){
                     self.array_BuildingList = response.data
                    
                    
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
    func createUnit(){
       ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        let building = array_BuildingList.first(where:{ $0.building == txt_Building.text})
        var buildingid = 0
                   if building != nil{
                       buildingid = building!.id
                       
                   }
        let param = [
            "login_id" : userId,
            "unit" : txt_Unit.text!,
            "share_amount" : txt_Share.text!,
            "size" : txt_Size.text!,
            "building_id": buildingid
            
        ] as [String : Any]

        ApiService.create_Unit(parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? CreateUnitBase){
                    if response.response == 1{
                        self.isToShowSucces =  true
                        DispatchQueue.main.async {
                        self.tableView.reloadData()
                            let indexPath = NSIndexPath(row: 0, section: 0)
                            self.tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: false)
                        }
                    }
                    else{
                        self.displayErrorAlert(alertStr: response.message, title: "Alert")
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
    func updateUnit(){
       ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        let building = array_BuildingList.first(where:{ $0.building == txt_Building.text})
        var buildingid = 0
                   if building != nil{
                       buildingid = building!.id
                       
                   }
        let param = [
            "login_id" : userId,
            "unit" : txt_Unit.text!,
            "share_amount" : txt_Share.text!,
            "size" : txt_Size.text!,
            "id" : "\(self.unitInfo.id)",
            "building_id" : buildingid
        ] as [String : Any]

        ApiService.update_Unit(parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? CreateUnitBase){
                    if response.response == 1{
                        self.alertView_message.delegate = self
                        self.alertView_message.showInView(self.view_Background, title: "Unit changes has\n been saved", okTitle: "Home", cancelTitle: "View Unit List")
                    }
                    else{
                        self.displayErrorAlert(alertStr: response.message, title: "Alert")
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
    
    func deleteUnit(){
       
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
       
        let param = [
            "login_id" : userId,
            "id" : self.unitInfo.id,
          
        ] as [String : Any]

        ApiService.delete_Unit(parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
            self.isToDelete  = false
            if status  && result != nil{
                 if let response = (result as? DeleteUserBase){
                    if response.response == 1{
                        DispatchQueue.main.async {
                            self.alertView_message.delegate = self
                            self.alertView_message.showInView(self.view_Background, title: "Unit has been\n deleted", okTitle: "Home", cancelTitle: "View Units List")
                        }
                    }
                    else{
                        self.displayErrorAlert(alertStr: response.message, title: "Alert")
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
 
    //MARK: BUTTON ACTIONS
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
    @IBAction func actionBuilding(_ sender:UIButton) {

        let dropDown_Building = DropDown()
        dropDown_Building.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Building.dataSource = array_BuildingList.map { $0.building }// Array(unitsData.values)
        dropDown_Building.show()
        dropDown_Building.selectionAction = { [unowned self] (index: Int, item: String) in
            txt_Building.text = item
//            let prop = array_Property.first(where:{ $0.company_name == item})
//            if prop != nil{
//                kCurrentPropertyId = prop!.id
//                getPropertyListInfo()
//            }
        
        }
    }
    @IBAction func actionDelete(_ sender: UIButton){
        showDeleteAlert()
        
    }
    func showDeleteAlert(){
        isToDelete = true
        alertView.delegate = self
        alertView.showInView(self.view_Background, title: "Are you sure you want to\n delete the following unit?", okTitle: "Yes", cancelTitle: "Back")
      
    }
    @IBAction func actionCreateRole(_ sender: UIButton){
        let unit = txt_Unit.text?.replacingOccurrences(of: " ", with: "")
        if txt_Unit.text == ""{
            displayErrorAlert(alertStr: "Please enter role name", title: "")
        }
        else if unit == ""{
            displayErrorAlert(alertStr: "Please enter a valid role name", title: "")
        }
        else if txt_Share.text == ""{
            displayErrorAlert(alertStr: "Please enter share amount", title: "")
        }
        else if txt_Size.text == ""{
            displayErrorAlert(alertStr: "Please enter unit size", title: "")
        }
        else if txt_Building.text == ""{
            displayErrorAlert(alertStr: "Please select building", title: "")
        }
        else{
            if isToEdit == true {
                updateUnit()
            }
            else{
                self.createUnit()
            }
            
        }
    }
    @IBAction func actionBackPressed(_ sender: UIButton){
        self.view.endEditing(true)
        if isToEdit{
            self.navigationController?.popViewController(animated: true)
        }
        else{
        alertView.delegate = self
        alertView.showInView(self.view_Background, title: "Are you sure you want to\n leave this page?\nYour changes would not\n be saved.", okTitle: "Yes", cancelTitle: "Back")
        }
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
extension AddEditUnitTableViewController: MenuViewDelegate{
    func onMenuClicked(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            self.menu.contractMenu()
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
extension AddEditUnitTableViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
       
        return true
    }
   
}
extension AddEditUnitTableViewController: AlertViewDelegate{
    func onBackClicked() {
       
    }
    
    func onCloseClicked() {
        
    }
    
    func onOkClicked() {
        if isToDelete == true{
        deleteUnit()
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
}
extension AddEditUnitTableViewController: MessageAlertViewDelegate{
    func onHomeClicked() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func onListClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
