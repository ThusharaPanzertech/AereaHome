//
//  EditBuildingTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 01/08/22.
//

import UIKit
import DropDown
class EditBuildingTableViewController: BaseTableViewController {
    
    
    let menu: MenuView = MenuView.getInstance
   
    //Outlets
    @IBOutlet weak var view_SwitchProperty: UIView!
    @IBOutlet weak var lbl_SwitchProperty: UILabel!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var lbl_Message: UILabel!
    
    @IBOutlet weak var txt_Building: UITextField!
    @IBOutlet weak var txt_BuildingNo: UITextField!
    @IBOutlet var arr_Textfields: [UITextField]!
    
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var view_Background1: UIView!
    @IBOutlet weak var view_Footer: UIView!
   
    @IBOutlet weak var imgView_Profile: UIImageView!
    @IBOutlet  var arr_Btns: [UIButton]!
    var buildingData: Building!
    var isToShowSuccess = false
    let alertView: AlertView = AlertView.getInstance
    let alertView_message: MessageAlertView = MessageAlertView.getInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view_SwitchProperty.layer.borderColor = themeColor.cgColor
        view_SwitchProperty.layer.borderWidth = 1.0
        view_SwitchProperty.layer.cornerRadius = 10.0
        view_SwitchProperty.layer.masksToBounds = true
          let fname = Users.currentUser?.moreInfo?.first_name ?? ""
        let lname = Users.currentUser?.moreInfo?.last_name ?? ""
        self.lbl_UserName.text = "\(fname) \(lname)"
        let role = Users.currentUser?.role
        self.lbl_UserRole.text = role
        imgView_Profile.addborder()
        lbl_SwitchProperty.text = kCurrentPropertyName
        UITextField.appearance().attributedPlaceholder = NSAttributedString(string: UITextField().placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])

       // view_Footer.backgroundColor = .red
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
        view_Background.layer.cornerRadius = 25.0
        view_Background.layer.masksToBounds = true
        
        view_Background1.layer.cornerRadius = 25.0
        view_Background1.layer.masksToBounds = true
        
        for field in arr_Textfields{
            field.layer.cornerRadius = 20.0
            field.layer.masksToBounds = true
            field.delegate = self
            field.textColor = textColor
            field.attributedPlaceholder = NSAttributedString(string: field.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
        }
        for btn in arr_Btns{
            btn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
            btn.layer.cornerRadius = 8.0
        }
    }

   
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1{
            
            return  isToShowSuccess ? 0 : super.tableView(tableView, heightForRowAt: indexPath)
           
        }
        else if indexPath.row == 2{
                
            return  isToShowSuccess ? super.tableView(tableView, heightForRowAt: indexPath) : 0
               
            
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showBottomMenu()
        txt_Building.text = buildingData.building
        txt_BuildingNo.text = buildingData.building_no
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.closeMenu()
    }
    func showBottomMenu(){
        
        menu.delegate = self
        menu.showInView(self.view, title: "", message: "")
      
    }
    func closeMenu(){
        menu.removeView()
    }
    override func getBackgroundImageName() -> String {
        let imgdefault = ""//UserInfoModalBase.currentUser?.data.property.defect_bg ?? ""
        return imgdefault
    }
    //MARK: ******  PARSING *********
    func updateBuilding(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        let params = NSMutableDictionary()
        params.setValue("\(userId)", forKey: "login_id")
        params.setValue("\(buildingData.id)", forKey: "id")
        params.setValue("\(txt_Building.text!)", forKey: "building")
        lbl_Message.text = "Building details updated"
        ApiService.edit_buildingList(parameters:params as! [String : Any], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                self.isToShowSuccess = true
                self.tableView.reloadData()
               
        }
            else if error != nil{
                self.isToShowSuccess = true
                self.tableView.reloadData()
               // self.displayErrorAlert(alertStr: "\(error!.localizedDescription)", title: "Alert")
            }
            else{
                self.isToShowSuccess = true
                self.tableView.reloadData()
              //  self.displayErrorAlert(alertStr: "Something went wrong.Please try again", title: "Alert")
            }
        })
    }
    func deleteBuilding(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        let params = NSMutableDictionary()
        params.setValue("\(userId)", forKey: "login_id")
        params.setValue("\(buildingData.id)", forKey: "id")
        params.setValue("\(txt_Building.text!)", forKey: "building")
        lbl_Message.text = "Building deleted"
        ApiService.delete_buildingList(parameters:params as! [String : Any], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                self.isToShowSuccess = true
                self.tableView.reloadData()
               
        }
            else if error != nil{
                self.isToShowSuccess = true
                self.tableView.reloadData()
               // self.displayErrorAlert(alertStr: "\(error!.localizedDescription)", title: "Alert")
            }
            else{
                self.isToShowSuccess = true
                self.tableView.reloadData()
              //  self.displayErrorAlert(alertStr: "Something went wrong.Please try again", title: "Alert")
            }
        })
    }
    
    //MARK: UIBUTTON ACTIONS
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
    @IBAction func actionSave(_ sender: UIButton){
        if txt_Building.text == ""
        {
            self.displayErrorAlert(alertStr: "", title: "Please enter building")
        }
        else{
            updateBuilding()
        }
     
    }
    @IBAction func actionHome(_ sender: UIButton){
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    @IBAction func actionList(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func actionDelete(_ sender: UIButton){
        showDeleteAlert()
        
    }
    func showDeleteAlert(){
        alertView.delegate = self
        alertView.showInView(self.view_Background, title: "Are you sure you want to\n delete the following\n building?", okTitle: "Yes", cancelTitle: "Back")
      
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

extension EditBuildingTableViewController: MenuViewDelegate{
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

extension EditBuildingTableViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
extension EditBuildingTableViewController: AlertViewDelegate{
    func onBackClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func onCloseClicked() {
        
    }
    
    func onOkClicked() {
        deleteBuilding()
        
    }
    
    
}
extension EditBuildingTableViewController: MessageAlertViewDelegate{
    func onHomeClicked() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func onListClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
