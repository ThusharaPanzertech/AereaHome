//
//  BuildingSummaryTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 29/07/22.
//

import UIKit
import DropDown
class BuildingSummaryTableViewController: BaseTableViewController {
    
    
      let menu: MenuView = MenuView.getInstance
      var dataSource = DataSource_Building()
      var heightSet = false
      var tableHeight: CGFloat = 0
      var array_BuildingList = [Building]()
      //Outlets
   
      @IBOutlet weak var table_ManageBuilding: UITableView!
      @IBOutlet weak var lbl_UserName: UILabel!
      @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var view_SwitchProperty: UIView!
    @IBOutlet weak var lbl_SwitchProperty: UILabel!
      @IBOutlet weak var view_Background: UIView!
      @IBOutlet weak var view_Footer: UIView!
    
      @IBOutlet weak var imgView_Profile: UIImageView!
      override func viewDidLoad() {
          super.viewDidLoad()
          view_SwitchProperty.layer.borderColor = themeColor.cgColor
          view_SwitchProperty.layer.borderWidth = 1.0
          view_SwitchProperty.layer.cornerRadius = 10.0
          view_SwitchProperty.layer.masksToBounds = true
          lbl_SwitchProperty.text = kCurrentPropertyName
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
          
         
      }

      override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
          return view_Footer
      }
      override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
          return 150

      }

      override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          if indexPath.row == 1{
              
            return  CGFloat(150 * array_BuildingList.count) + 130
             
          }
          return super.tableView(tableView, heightForRowAt: indexPath)
      }
      override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          getBuildingSummaryLists()
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
      
    func getBuildingSummaryLists(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        
        ApiService.get_buildingSummaryList(parameters: ["login_id":userId], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? BuildingSummaryBase){
                     self.array_BuildingList = response.data
                    
                     self.dataSource.array_BuildingList = response.data
                     DispatchQueue.main.async {
                         self.table_ManageBuilding.reloadData()
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
      @IBAction func actionAddNew(_ sender: UIButton){

        let editBuildingVC = kStoryBoardSettings.instantiateViewController(identifier: "AddBuildingTableViewController") as! AddBuildingTableViewController
        self.navigationController?.pushViewController(editBuildingVC, animated: true)
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
  class DataSource_Building: NSObject, UITableViewDataSource, UITableViewDelegate {
      var parentVc: UIViewController!
      var array_BuildingList = [Building]()
      func numberOfSectionsInTableView(tableView: UITableView) -> Int {

          return 1;
      }

       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  array_BuildingList.count
      }

      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
              let cell = tableView.dequeueReusableCell(withIdentifier: "buildingCell") as! BuildingSummaryTableViewCell
         
          cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
          //dropShadow()
          cell.view_Outer.tag = indexPath.row
          let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
          cell.view_Outer.addGestureRecognizer(tap)
          
          
        cell.lbl_Building.text  = array_BuildingList[indexPath.row].building
        cell.lbl_BuildingId.text  = array_BuildingList[indexPath.row].building_no
        cell.view_Outer.addGestureRecognizer(tap)
        cell.btn_Edit.tag = indexPath.row
        cell.btn_Edit.addTarget(self, action: #selector(self.actionEdit(_:)), for: .touchUpInside)
       
          cell.selectionStyle = .none
         
          
              return cell
        
      }
      func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          
          return 150
      }
      @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
         
 
      }
     
      @IBAction func actionEdit(_ sender: UIButton){
          let editBuildingVC = kStoryBoardSettings.instantiateViewController(identifier: "EditBuildingTableViewController") as! EditBuildingTableViewController
          editBuildingVC.buildingData = array_BuildingList[sender.tag]
          self.parentVc.navigationController?.pushViewController(editBuildingVC, animated: true)
      }
      
  }
  extension BuildingSummaryTableViewController: MenuViewDelegate{
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
