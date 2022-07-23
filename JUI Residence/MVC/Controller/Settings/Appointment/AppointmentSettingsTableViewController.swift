//
//  AppointmentSettingsTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 03/01/22.
//

import UIKit

class AppointmentSettingsTableViewController: BaseTableViewController {
    
  //  var array_Property = [UserModal]()
  
    let menu: MenuView = MenuView.getInstance
    var dataSource = DataSource_AppointmentSettings()
    var heightSet = false
    var tableHeight: CGFloat = 0
    var propertyInfo : PropertyInfo!
    //Outlets
 
    @IBOutlet weak var table_ManageProperty: UITableView!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
   
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var view_Footer: UIView!
   
    @IBOutlet weak var imgView_Profile: UIImageView!
    var unitsData = [Unit]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let fname = Users.currentUser?.user?.name ?? ""
        let lname = Users.currentUser?.moreInfo?.last_name ?? ""
        self.lbl_UserName.text = "\(fname) \(lname)"
        let role = Users.currentUser?.role?.name ?? ""
        self.lbl_UserRole.text = role
        imgView_Profile.addborder()
        table_ManageProperty.dataSource = dataSource
        table_ManageProperty.delegate = dataSource
        dataSource.parentVc = self
        table_ManageProperty.reloadData()
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
        return 0

    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1{
            
            return  350
           
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPropertyInfo()
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
    
    func getPropertyInfo(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.get_PropertyInfo(parameters: ["login_id":userId], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? PropertyInfoModalBase){
                    self.propertyInfo = response.property
                    self.dataSource.propertyInfo = response.property
                   
                    self.table_ManageProperty.reloadData()
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
class DataSource_AppointmentSettings: NSObject, UITableViewDataSource, UITableViewDelegate {
    var parentVc: UIViewController!
    var propertyInfo : PropertyInfo!
    var filePath = ""
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1;
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  propertyInfo == nil ? 0 : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "appointmentSettingsCell") as! AppointmentSettingsTableViewCell
       
        cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
        //dropShadow()
        cell.view_Outer.tag = indexPath.row
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        cell.view_Outer.addGestureRecognizer(tap)
        cell.btn_Edit.tag = indexPath.row
        
        cell.lbl_Property.text  = propertyInfo.company_name
        cell.lbl_Contact.text = propertyInfo.company_contact
        cell.lbl_Email.text = propertyInfo.company_email
        let logo = propertyInfo.company_logo
        if let url1 = URL(string: "\(kImageFilePath)/" + logo) {
           // self.imgView_Profile.af_setImage(withURL: url1)
            cell.img_Logo.af_setImage(
                        withURL: url1,
                        placeholderImage: UIImage(named: "loader"),
                        filter: nil,
                        imageTransition: .crossDissolve(0.2)
                    )
        }
        else{
           // self.imgView_Profile.image = UIImage(named: "avatar")
        }
        cell.btn_Edit.addTarget(self, action: #selector(self.actionEdit(_:)), for: .touchUpInside)
        cell.selectionStyle = .none
       
        
            return cell
      
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 200
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
       
//        let editUserVC = kStoryBoardMain.instantiateViewController(identifier: "EditUserTableViewController") as! EditUserTableViewController
//        self.parentVc.navigationController?.pushViewController(editUserVC, animated: true)

    }
    @IBAction func actionDelete(_ sender: UIButton){
    }
    @IBAction func actionEdit(_ sender: UIButton){
        let addUserVC = kStoryBoardSettings.instantiateViewController(identifier: "ManageAppointmentTableViewController") as! ManageAppointmentTableViewController
        addUserVC.propertyInfo = self.propertyInfo

        self.parentVc.navigationController?.pushViewController(addUserVC, animated: true)
    }
    
}
extension AppointmentSettingsTableViewController: MenuViewDelegate{
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
