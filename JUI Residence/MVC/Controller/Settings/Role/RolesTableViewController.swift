//
//  RolesTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 11/01/22.
//

import UIKit

class RolesTableViewController: BaseTableViewController {
    
    //  var array_Property = [UserModal]()
    
      let menu: MenuView = MenuView.getInstance
      var dataSource = DataSource_Roles()
      var heightSet = false
      var tableHeight: CGFloat = 0
      var arr_Roles = [RoleInfo]()
      //Outlets
   
      @IBOutlet weak var table_ManageRoles: UITableView!
      @IBOutlet weak var lbl_UserName: UILabel!
      @IBOutlet weak var lbl_UserRole: UILabel!
     
      @IBOutlet weak var view_Background: UIView!
      @IBOutlet weak var view_Footer: UIView!
     
      @IBOutlet weak var imgView_Profile: UIImageView!
      var unitsData = [String: String]()
      override func viewDidLoad() {
          super.viewDidLoad()
          let fname = Users.currentUser?.user?.name ?? ""
          let lname = Users.currentUser?.moreInfo?.last_name ?? ""
          self.lbl_UserName.text = "\(fname) \(lname)"
          let role = Users.currentUser?.role?.name ?? ""
          self.lbl_UserRole.text = role
          imgView_Profile.addborder()
        table_ManageRoles.dataSource = dataSource
        table_ManageRoles.delegate = dataSource
          dataSource.parentVc = self
        table_ManageRoles.reloadData()
          UITextField.appearance().attributedPlaceholder = NSAttributedString(string: UITextField().placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])

        
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
          
         
      }

      override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
          return view_Footer
      }
      override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
          return 150

      }

      override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          if indexPath.row == 1{
              
            return  CGFloat(120 * arr_Roles.count) + 130
             
          }
          return super.tableView(tableView, heightForRowAt: indexPath)
      }
      override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          getRolesSummary()
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
      
      func getRolesSummary(){
          ActivityIndicatorView.show("Loading")
          let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
          //
          ApiService.get_RoleSummary(parameters: ["login_id":userId], completion: { status, result, error in
             
              ActivityIndicatorView.hiding()
              if status  && result != nil{
                   if let response = (result as? RoleSummaryBase){
                      self.arr_Roles = response.roles
                      self.dataSource.arr_Roles = response.roles
                     
                      self.table_ManageRoles.reloadData()
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
      
      //MARK: UIBUTTON ACTIONS
    
      @IBAction func actionAddNew(_ sender: UIButton){

        let addRoleVC = kStoryBoardSettings.instantiateViewController(identifier: "AddRoleTableViewController") as! AddRoleTableViewController
        self.navigationController?.pushViewController(addRoleVC, animated: true)
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
  class DataSource_Roles: NSObject, UITableViewDataSource, UITableViewDelegate {
      var parentVc: UIViewController!
      var propertyInfo : PropertyInfo!
      var filePath = ""
    var arr_Roles = [RoleInfo]()
      func numberOfSectionsInTableView(tableView: UITableView) -> Int {

          return 1;
      }

       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  arr_Roles.count
      }

      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
              let cell = tableView.dequeueReusableCell(withIdentifier: "roleCell") as! RoleTableViewCell
         
          cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
          //dropShadow()
          cell.view_Outer.tag = indexPath.row
          let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
          cell.view_Outer.addGestureRecognizer(tap)
          
          
        cell.lbl_Role.text  = arr_Roles[indexPath.row].name
        cell.view_Outer.addGestureRecognizer(tap)
        cell.btn_Edit.tag = indexPath.row
        cell.btn_Edit.addTarget(self, action: #selector(self.actionEdit(_:)), for: .touchUpInside)
       
          cell.selectionStyle = .none
         
          
              return cell
        
      }
      func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          
          return 92
      }
      @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
         
 
      }
     
      @IBAction func actionEdit(_ sender: UIButton){
          let editRoleVC = kStoryBoardSettings.instantiateViewController(identifier: "EditRoleTableViewController") as! EditRoleTableViewController
        editRoleVC.roleInfo = arr_Roles[sender.tag]
          self.parentVc.navigationController?.pushViewController(editRoleVC, animated: true)
      }
      
  }
  extension RolesTableViewController: MenuViewDelegate{
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
