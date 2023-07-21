//
//  AddBuildingTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 29/07/22.
//

import UIKit
import DropDown
var array_BuildingList = [String]()
class AddBuildingTableViewController: BaseTableViewController {
    
    
    let menu: MenuView = MenuView.getInstance
    var dataSource = DataSource_AddBuilding()
    var heightSet = false
    var tableHeight: CGFloat = 0
   var isToShowSuccess = false
   
    //Outlets
 
    @IBOutlet weak var table_ManageBuilding: UITableView!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var view_SwitchProperty: UIView!
    @IBOutlet weak var lbl_SwitchProperty: UILabel!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var view_Background1: UIView!
   
    @IBOutlet weak var imgView_Profile: UIImageView!
    @IBOutlet  var arr_Btns: [UIButton]!
    override func viewDidLoad() {
        array_BuildingList = [""]
        super.viewDidLoad()
          let fname = Users.currentUser?.moreInfo?.first_name ?? ""
        let lname = Users.currentUser?.moreInfo?.last_name ?? ""
        self.lbl_UserName.text = "\(fname) \(lname)"
        let role = Users.currentUser?.role
        self.lbl_UserRole.text = role
        imgView_Profile.addborder()
        table_ManageBuilding.dataSource = dataSource
        table_ManageBuilding.delegate = dataSource
        dataSource.parentVc = self
        table_ManageBuilding.reloadData()
        view_SwitchProperty.layer.borderColor = themeColor.cgColor
        view_SwitchProperty.layer.borderWidth = 1.0
        view_SwitchProperty.layer.cornerRadius = 10.0
        view_SwitchProperty.layer.masksToBounds = true
        UITextField.appearance().attributedPlaceholder = NSAttributedString(string: UITextField().placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        lbl_SwitchProperty.text = kCurrentPropertyName
      
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
        for btn in arr_Btns{
            btn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
            btn.layer.cornerRadius = 8.0
        }
        
       
    }

  

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1{
            
            return  isToShowSuccess ? 0 :CGFloat((115 * array_BuildingList.count) + 300)
           
        }
        if indexPath.row == 2{
            return isToShowSuccess ? super.tableView(tableView, heightForRowAt: indexPath) : 0
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
      
    }
    func closeMenu(){
        menu.removeView()
    }
    override func getBackgroundImageName() -> String {
        let imgdefault = ""//UserInfoModalBase.currentUser?.data.property.defect_bg ?? ""
        return imgdefault
    }
    //MARK: ******  PARSING *********
    
  func createBuilding(){
      ActivityIndicatorView.show("Loading")
      let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
      let params = NSMutableDictionary()
      params.setValue("\(userId)", forKey: "login_id")
      for (idx,building) in array_BuildingList.enumerated(){
          params.setValue("\(building)", forKey: "building_\(idx + 1)")
      }
      ApiService.create_buildingList(parameters:params as! [String : Any], completion: { status, result, error in
         
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
    @IBAction func actionHome(_ sender: UIButton){
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    @IBAction func actionList(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func actionSubmit(_ sender: UIButton){
        var flag = false
        for building in array_BuildingList{
            if building == ""{
                flag = true
                break
            }
        }
        if flag == true{
            self.displayErrorAlert(alertStr: "", title: "Please enter building")
        }
        else{
            createBuilding()
        }
     
    }
    @IBAction func actionAddNew(_ sender: UIButton){

        array_BuildingList.append("")
        self.table_ManageBuilding.reloadData()
        self.tableView.reloadData()
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
class DataSource_AddBuilding: NSObject, UITableViewDataSource, UITableViewDelegate {
    var parentVc: UIViewController!
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1;
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return  array_BuildingList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "buildingCell") as! AddBuildingTableViewCell
       
        cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
        //dropShadow()
        cell.view_Outer.tag = indexPath.row
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        cell.view_Outer.addGestureRecognizer(tap)
        
        
      cell.txt_Building.text  = array_BuildingList[indexPath.row]
      cell.view_Outer.addGestureRecognizer(tap)
        cell.txt_Building.tag = indexPath.row
        cell.txt_Building.addTarget(self, action: #selector(buildingValueChanged), for: .editingChanged)
        cell.selectionStyle = .none
       
        
        cell.txt_Building.layer.cornerRadius = 20.0
        cell.txt_Building.layer.masksToBounds = true
        cell.txt_Building.delegate = self
        cell.txt_Building.textColor = textColor
        cell.txt_Building.attributedPlaceholder = NSAttributedString(string: cell.txt_Building.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
        cell.txt_Building.backgroundColor =  UIColor(red: 208/255, green: 208/255, blue: 208/255, alpha: 1.0)
        
        cell.btn_Delete.tag = indexPath.row
        cell.btn_Delete.addTarget(self, action: #selector(self.actionDelete(_:)), for: .touchUpInside)
       
       
        
            return cell
      
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 115
    }
    @objc func buildingValueChanged(_ textField: UITextField){
       array_BuildingList[textField.tag] = textField.text!
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
       

    }
    @IBAction func actionDelete(_ sender: UIButton){
        array_BuildingList.remove(at: sender.tag)
        DispatchQueue.main.async {
            (self.parentVc as! AddBuildingTableViewController).table_ManageBuilding.reloadData()
            (self.parentVc as! AddBuildingTableViewController).tableView.reloadData()
        }
    }
  
    
}
extension DataSource_AddBuilding: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
extension AddBuildingTableViewController: MenuViewDelegate{
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
