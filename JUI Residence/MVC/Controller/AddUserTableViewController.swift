//
//  AddUserTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 26/07/21.
//

import UIKit
import DropDown
var arr_SelectedPropertyIds = [Int]()
class AddUserTableViewController: BaseTableViewController {

    //Outlets
    @IBOutlet weak var txt_FirstName: UITextField!
    @IBOutlet weak var txt_LastName: UITextField!
    @IBOutlet weak var txt_Contact: UITextField!
    @IBOutlet weak var txt_Email: UITextField!
    @IBOutlet weak var txt_UnitNo: UITextField!
    @IBOutlet weak var txt_Building: UITextField!
    @IBOutlet weak var txt_Card: UITextField!
    @IBOutlet weak var txt_Country: UITextField!
    @IBOutlet weak var txt_Company: UITextField!
    @IBOutlet weak var txt_MailingAddress: UITextView!
    @IBOutlet weak var txt_AssignedRole: UITextField!
    @IBOutlet weak var txt_PostalCode: UITextField!
    @IBOutlet weak var view_SwitchProperty: UIView!
    @IBOutlet weak var lbl_SwitchProperty: UILabel!
    @IBOutlet var arr_Textfields: [UITextField]!
    @IBOutlet var arr_Buttons: [UIButton]!
    @IBOutlet weak var view_Fields: UIView!
    @IBOutlet weak var view_FieldsToHide: UIView!
    @IBOutlet weak var topSpace: NSLayoutConstraint!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var btn_Submit: UIButton!
    @IBOutlet weak var btn_Delete: UIButton!
    @IBOutlet weak var btn_Home: UIButton!
    @IBOutlet weak var btn_UserList: UIButton!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var view_Background1: UIView!
    @IBOutlet weak var imgView_Profile: UIImageView!
    @IBOutlet weak var table_Property: UITableView!
    @IBOutlet var arr_ViewToHide: [UIView]!
    @IBOutlet var topSpaceRole: NSLayoutConstraint!
    var dataSource = DataSource_Property()
    @IBOutlet weak var view_AssignProperty: UIView!
    @IBOutlet var propertyHt: NSLayoutConstraint!
    @IBOutlet weak var btn_PrimaryContact: UIButton!
    var selectedrole = ""
    var isUserRole = false
    let menu: MenuView = MenuView.getInstance
    let alertView: AlertView = AlertView.getInstance
    let alertView_message: MessageAlertView = MessageAlertView.getInstance
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var lbl_MsgTitlee: UILabel!
    @IBOutlet weak var lbl_MsgDesc: UILabel!
    var array_BuildingList = [Building]()
    var isToDelete = false
    var isToShowSucces = false
    var isToEdit: Bool!
    var user: UserModal!
    var userData: Users!
    var unitsData = [Unit]()
    var roles = [String: String]()
    var unitcards = [String: String]()
    var array_country = [String: String]()
  //  var buildings = [String: String]()
    var userRoles = [Role]()
    var selectedunit = ""
    var selectedcountry = ""
    var selectedbuilding = ""
    var array_BuildingUnit = [BuildingUnit]()
    var role = ""
    var role_id = 0
    var country_id = 0
    var selectedIndexes = [Int]()
    override func viewDidLoad() {
        super.viewDidLoad()
        view_AssignProperty.isHidden = true
        propertyHt.constant = 0
        
        viewHeight.constant = 800
        self.view_FieldsToHide.isHidden = true
        self.topSpace.constant = 16
        topSpaceRole.constant = 20
        for vw in self.arr_ViewToHide{
            vw.isHidden = true
        }
        lbl_Title.text = isToEdit ? "User Management - Update User" : "User Management - Add User"
        getCountryList()
        getBuildingSummaryLists()
        view_SwitchProperty.layer.borderColor = themeColor.cgColor
        view_SwitchProperty.layer.borderWidth = 1.0
        view_SwitchProperty.layer.cornerRadius = 10.0
        view_SwitchProperty.layer.masksToBounds = true
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
          let fname = Users.currentUser?.moreInfo?.first_name ?? ""
        let lname = Users.currentUser?.moreInfo?.last_name ?? ""
        self.lbl_UserName.text = "\(fname) \(lname)"
        let role = Users.currentUser?.role
        self.lbl_UserRole.text = role
        txt_MailingAddress.delegate = self
        for txtField in arr_Textfields{
            txtField.layer.cornerRadius = 20.0
            txtField.layer.masksToBounds = true
            txtField.delegate = self
            txtField.textColor = textColor
            txtField.attributedPlaceholder = NSAttributedString(string: txtField.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
        }
        imgView_Profile.addborder()
        txt_MailingAddress.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        if isToEdit == true{
            txt_MailingAddress.textColor = txt_MailingAddress.text == "Mailing Address" ? placeholderColor :
                textColor
        }
        else{
            txt_MailingAddress.textColor = placeholderColor
        }
      
        txt_MailingAddress.layer.cornerRadius = 20.0
        txt_MailingAddress.layer.masksToBounds = true
        view_Fields.layer.cornerRadius = 25.0
        view_Fields.layer.masksToBounds = true
        view_Background.layer.cornerRadius = 25.0
        view_Background.layer.masksToBounds = true
        view_Background1.layer.cornerRadius = 25.0
        view_Background1.layer.masksToBounds = true
        for btn in arr_Buttons{
            btn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
            btn.layer.cornerRadius = 8.0
        }
        getUnitList()
        if self.isToEdit == false{
        btn_Delete.isHidden = true
        }
        else{
            self.txt_Email.textColor = UIColor.gray
            self.txt_Email.isUserInteractionEnabled = false
            self.getUserSummary()
            
        }

        if self.roles.count == 0{
            getRolesList()
        }
        getUserRolesList()
        //ToolBar
          let toolbar = UIToolbar();
          toolbar.sizeToFit()
          let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([spaceButton,doneButton], animated: false)
        txt_MailingAddress.inputAccessoryView = toolbar
        txt_Contact.inputAccessoryView = toolbar
        
        table_Property.dataSource = dataSource
        table_Property.delegate = dataSource
        dataSource.parentVc = self
        table_Property.reloadData()
    }
    @objc func done(){
        self.view.endEditing(true)
    }
//    @IBAction func actionUnit(_ sender:UIButton) {
////        let sortedArray = unitsData.sorted(by:  { $0.1 < $1.1 })
//        let arrUnit = unitsData.map { $0.unit }
//        let dropDown_Unit = DropDown()
//        dropDown_Unit.anchorView = sender // UIView or UIBarButtonItem
//        dropDown_Unit.dataSource = arrUnit//Array(unitsData.values)
//        dropDown_Unit.show()
//        dropDown_Unit.selectionAction = { [unowned self] (index: Int, item: String) in
//            txt_UnitNo.text = item
////            if let key = unitsData.first(where: { $0.unit == item })?.key {
////                print(key)
////            }
//        }
//    }
   
    func setUpUI(){
        if self.isToEdit == true{
            
            txt_FirstName.text = userData.moreInfo?.first_name
            txt_LastName.text = userData.moreInfo?.last_name
            txt_Contact.text = userData.moreInfo?.phone
            txt_Email.text = userData.user?.email
            txt_UnitNo.text = userData.unit?.unit
            txt_Company.text = userData.moreInfo?.company_name
            txt_MailingAddress.text = userData.moreInfo?.mailing_address
          
            //arr userData.moreInfo?.getuser.role_id
            txt_PostalCode.text = userData.moreInfo?.postal_code
            txt_MailingAddress.textColor = txt_MailingAddress.text == "Mailing Address" ? placeholderColor :
                textColor
            
            
                txt_AssignedRole.text = self.roles["\(self.role_id)"]
            if self.role_id == 2{
                for vw in self.arr_ViewToHide{
                    vw.isHidden = false
                }
              //  viewHeight.constant += 50
                topSpaceRole.constant = 45
            }
            else{
                btn_PrimaryContact.isSelected = false
                for vw in self.arr_ViewToHide{
                    vw.isHidden = true
                }
                //viewHeight.constant -= 50
                topSpaceRole.constant = 20
            }
//            if let key =  self.userRoles.first(where: { $0.id! == self.role_id }){
//                        print(key)
//                self.view_FieldsToHide.isHidden = false
//                self.topSpace.constant = 268
//                viewHeight.constant = 1055
//                    }
//
        }
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
    func getBuildingUnitsLists(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
       
        ApiService.get_buildingUnitsList(parameters: ["login_id":userId, "building_id" : self.selectedbuilding], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? BuildingUnitBase){
                     self.array_BuildingUnit = response.data
                    
                   
                     
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
    func getUnitCardList(){
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.get_UnitCardList(parameters: ["login_id":userId, "unit_no": self.selectedunit], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? UnitCardBase){
                   
                     self.unitcards = response.cards
                     
                    
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
    func getCountryList(){
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.get_UserCountryList(parameters: ["login_id":userId, "unit_no": self.selectedunit], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? CountryBase){
                   
                     self.array_country = response.roles
                     if self.isToEdit == true{
                         self.txt_Country.text = self.array_country["\(self.country_id)"]
                         if let countryId = self.array_country.first(where: { $0.value == self.txt_Country.text })?.key {
                             self.selectedcountry = countryId
                         }
                         
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
    func getUserRolesList(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"        //
        ApiService.get_UserRolesList(parameters: ["login_id":userId], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? UserRolesBase){
                    self.userRoles = response.roles
                     self.txt_AssignedRole.text = self.roles["\(self.role_id)"]
                     if self.isToEdit == false{
                         self.txt_AssignedRole.text = self.roles["\(self.role_id)"]
                         if let key =  self.userRoles.first(where: { $0.name! == self.txt_AssignedRole.text }){
                                              print(key)
                             self.isUserRole = true
                                      self.view_FieldsToHide.isHidden = false
                                      self.topSpace.constant = 268
                             self.viewHeight.constant = 1055
                                          }
                         else{
                             self.view_FieldsToHide.isHidden = true
                             self.topSpace.constant = 16
                             self.viewHeight.constant = 800
                             
                             
                           
                         }
                         
                     }
                     else{
                         self.txt_AssignedRole.text = self.roles["\(self.role_id)"]
                         if let key =  self.userRoles.first(where: { $0.name! == self.txt_AssignedRole.text }){
                             self.propertyHt.constant = 0
                             self.view_AssignProperty.isHidden = true
                                          }
                         else{
                             self.propertyHt.constant = CGFloat(90 + (50 * array_Property.count))
                             self.view_AssignProperty.isHidden = false
                             
                             
                           
                         }
                         DispatchQueue.main.async {
                             self.table_Property.reloadData()
                             self.tableView.reloadData()
                         }
                       
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
    func getRolesList(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"        //
        ApiService.get_RolesList(parameters: ["login_id":userId], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? RolesBase){
                    self.roles = response.roles
                   
                   
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
    func getUserSummary(){
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        arr_SelectedPropertyIds.removeAll()
        ApiService.get_UserDetail_With(parameters: ["login_id":userId, "user":user.id!], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? UserInfoModalBase){
                    self.userData = response.users
                     self.dataSource.availableProperties = response.users.available_properties
                     self.dataSource.agent_assigned_property = response.users.agent_assigned_property
                     arr_SelectedPropertyIds = response.users.agent_assigned_property
//                     for prop in response.users.available_properties{
//                         arr_SelectedPropertyIds.append(prop.id)
//                     }
                     if self.userData.moreInfo?.getuser.primary_contact == 0{
                         self.btn_PrimaryContact.isSelected = false
                     }
                     else{
                         self.btn_PrimaryContact.isSelected = true
                     }
                     
                    DispatchQueue.main.async {
                        self.setUpUI()
                        self.table_Property.reloadData()
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
    
    func getUnitList(){
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.get_UnitList(parameters: ["login_id":userId], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? UnitBase){
                    self.unitsData = response.units
                   
                   
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
    
    func createUser(){
        self.lbl_MsgTitlee.text = "User List Added"
        self.lbl_MsgDesc.text = "The requested user has been added\n into the list."
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        var role_Id = ""
        var unit_Id = ""
        if let roleId = roles.first(where: { $0.value == txt_AssignedRole.text })?.key {
            role_Id = roleId
        }
        if let unitId = unitsData.first(where: { $0.unit == txt_UnitNo.text }){
            unit_Id = "\(unitId.id)"
        }
      
        let params = NSMutableDictionary()
        params.setValue("\(userId)", forKey: "login_id")
        params.setValue("\(role_Id)", forKey: "role_id")
        params.setValue("\(txt_FirstName.text!)", forKey: "name")
        params.setValue("\(txt_LastName.text!)", forKey: "last_name")
        params.setValue("\(txt_Contact.text!)", forKey: "phone")
        params.setValue("\(txt_Email.text!)", forKey: "email")
        params.setValue("\(unit_Id)", forKey: "unit_no")
        params.setValue("\(txt_Company.text!)", forKey: "company_name")
        params.setValue("\(txt_MailingAddress.text!)", forKey: "mailing_address")
        params.setValue("\(txt_PostalCode.text!)", forKey: "postal_code")
        params.setValue("\(self.selectedbuilding)", forKey: "building_no")
        params.setValue(self.selectedcountry, forKey: "country")
        
        
        var cardArr = [String]()
        for obj in self.selectedIndexes{
            let key = Array(unitcards)[obj].key
            cardArr.append(key)
        }
        if cardArr.count > 0{
            params.setValue(cardArr, forKey: "card_nos")
        }
        
        params.setValue(btn_PrimaryContact.isSelected ? 1 : 0, forKey: "primary_contact")
        
        
        ApiService.create_User(parameters: params as! [String : Any], completion: { status, result, error in
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? CreateUserBase){
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
    func updateUser(){
        self.lbl_MsgTitlee.text = "User Data Updated"
        self.lbl_MsgDesc.text = "The requested user has been updated\n successfully."
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        var role_Id = ""
        var unit_Id = ""
       
        if let roleId = roles.first(where: { $0.value == txt_AssignedRole.text })?.key {
            role_Id = roleId
        }
        if let unitId = unitsData.first(where: { $0.unit == txt_UnitNo.text }) {
            unit_Id = "\(unitId.id)"
        }
    
        let id = userData.user != nil ? userData.user!.id : 0
        let params = NSMutableDictionary()
        params.setValue("\(userId)", forKey: "login_id")
        params.setValue("\(id!)", forKey: "id")
        params.setValue("\(role_Id)", forKey: "role_id")
        params.setValue("\(txt_FirstName.text!)", forKey: "name")
        params.setValue("\(txt_LastName.text!)", forKey: "last_name")
        params.setValue("\(txt_Contact.text!)", forKey: "phone")
        params.setValue("\(txt_Email.text!)", forKey: "email")
        params.setValue("\(unit_Id)", forKey: "unit_no")
        params.setValue("\(txt_Company.text!)", forKey: "company_name")
        params.setValue("\(txt_MailingAddress.text!)", forKey: "mailing_address")
        params.setValue("\(txt_PostalCode.text!)", forKey: "postal_code")
        params.setValue(self.selectedcountry, forKey: "country")
        
        
        
        let role = self.roles["\(self.role_id)"]
        if let key =  self.userRoles.first(where: { $0.name! == role }){
           
            
            
                         }
        else{
            for prop in self.userData.available_properties{
                if arr_SelectedPropertyIds.contains(prop.id){
                    params.setValue(1, forKey: "property_\(prop.id)")
                }
                else{
                    params.setValue(0, forKey: "property_\(prop.id)")
                }
            }
            
        }
        
        
//        let param = [
//            "login_id" : userId,
//            "id" : id!,
//            "role_id": role_Id,
//            "name" : txt_FirstName.text!,
//            "last_name": txt_LastName.text!,
//            "phone": txt_Contact.text!,
//            "email" : txt_Email.text!,
//            "unit_no": unit_Id,
//            "company_name":txt_Company.text!,
//            "mailing_address": txt_MailingAddress.text!,
//            "postal_code": txt_PostalCode.text!
//        ] as [String : Any]

        ApiService.update_User(parameters: params as! [String : Any], completion: { status, result, error in
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? UpdateUserBase){
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
    
    func deleteUser(){
       
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
     
        let id = userData.user != nil ? userData.user!.id : 0
        let param = [
            "login_id" : userId,
            "user" : id!,
          
        ] as [String : Any]

        ApiService.delete_User(parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
            self.isToDelete = false
            if status  && result != nil{
                 if let response = (result as? DeleteUserBase){
                    if response.response == 1{
                        DispatchQueue.main.async {
                            self.alertView_message.delegate = self
                            self.alertView_message.showInView(self.view_Background, title: "User has been\n deleted", okTitle: "Home", cancelTitle: "View User List")
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
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1{
            return self.isToShowSucces == true ? 0 : viewHeight.constant + propertyHt.constant + 260
        }
        else  if indexPath.row == 2{
            return self.isToShowSucces == false ? 0 : kScreenSize.height - 180
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    //MARK: UIBUTTON ACTIONS
    @IBAction func actionPrimaryContact(_ sender: UIButton){
        
        sender.isSelected = !sender.isSelected
        
    }
    @IBAction func actionSwitchProperty(_ sender:UIButton) {
        self.view.endEditing(true)
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
    
    @IBAction func actionSelectAll(_ sender:UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true{
            arr_SelectedPropertyIds.removeAll()
            for prop in array_Property{
                arr_SelectedPropertyIds.append(prop.id)
              
            }
        }
        else{
            arr_SelectedPropertyIds.removeAll()
        }
        DispatchQueue.main.async {
            self.table_Property.reloadData()
        }
    }
    @IBAction func actionBackPressed(_ sender: UIButton){
        self.view.endEditing(true)
        if isToEdit == true{
            self.navigationController?.popViewController(animated: true)
        }
        else{
        alertView.delegate = self
        alertView.showInView(self.view_Background, title: "Are you sure you want to\n leave this page?\nYour changes would not\n be saved.", okTitle: "Yes", cancelTitle: "Back")
        }
    }
    @IBAction func actionCards(_ sender:UIButton) {
        self.view.endEditing(true)
        let sortedArray = unitcards.sorted { $0.key < $1.key }
        let arrRoles = sortedArray.map { $0.value }
        if arrRoles.count > 0{
            let dropDown_Cards = DropDown()
            dropDown_Cards.anchorView = sender // UIView or UIBarButtonItem
            dropDown_Cards.dataSource = arrRoles//Array(roles.values)
            dropDown_Cards.showFooter = true
            dropDown_Cards.show()
            
            dropDown_Cards.dismissMode = .automatic
            dropDown_Cards.multiSelectionAction = { [unowned self] (indexes: [Int], items: [String]) in
                //  txt_Group.text = item
                selectedIndexes = indexes
                var roles = ""
                for obj in items{
                    roles += obj + ", "
                }
                if indexes.count > 0{
                    roles.removeLast()
                    roles.removeLast()
                }
                txt_Card.text = roles
            }
            dropDown_Cards.selectRows(at:Set(selectedIndexes))
            
        }
        
       
    }
    @IBAction func actionBuildings(_ sender:UIButton) {
        self.view.endEditing(true)
        let sortedArray = array_BuildingList.map { $0.building }
      
       
       
        let dropDown_Roles = DropDown()
        dropDown_Roles.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Roles.dataSource = sortedArray//Array(roles.values)
        dropDown_Roles.show()
        dropDown_Roles.selectionAction = { [unowned self] (index: Int, item: String) in
            txt_Building.text = item
            self.selectedbuilding =   "\(array_BuildingList[index].id)"
            self.getBuildingUnitsLists()
            txt_UnitNo.text = ""
            self.selectedunit = ""
        }
    }
    @IBAction func actionUnit(_ sender:UIButton) {
        
        self.view.endEditing(true)
        if selectedbuilding == ""{
            displayErrorAlert(alertStr: "Please select building", title: "")
        }
        else{
            let arrUnit = array_BuildingUnit.map { $0.unit }
            let dropDown_Unit = DropDown()
            dropDown_Unit.anchorView = sender // UIView or UIBarButtonItem
            dropDown_Unit.dataSource = arrUnit// Array(unitsData.values)
            dropDown_Unit.show()
            dropDown_Unit.selectionAction = { [unowned self] (index: Int, item: String) in
                txt_UnitNo.text = item
                self.selectedunit = "\(array_BuildingUnit[index].id)"
                getUnitCardList()
            }
        }
    }
    @IBAction func actionRoles(_ sender:UIButton) {
        self.view.endEditing(true)
        let sortedArray = roles.sorted { $0.value < $1.value }
        let arrRoles = sortedArray.map { $0.value }
        let dropDown_Roles = DropDown()
        dropDown_Roles.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Roles.dataSource = arrRoles//Array(roles.values)
        dropDown_Roles.show()
        dropDown_Roles.selectionAction = { [unowned self] (index: Int, item: String) in
            txt_AssignedRole.text = item
            
            
            let prop = roles.first(where:{ $0.value == item})
            if prop != nil{
                self.selectedrole  = prop!.key
                
                
                
                
             //   self.selectedrole = roles.keys[index]
                //sortedArray[index].key
                if self.selectedrole == "2"{
                    for vw in self.arr_ViewToHide{
                        vw.isHidden = false
                    }
                    //viewHeight.constant += 50
                    topSpaceRole.constant = 45
                }
                else{
                    btn_PrimaryContact.isSelected = false
                    for vw in self.arr_ViewToHide{
                        vw.isHidden = true
                    }
                    //   viewHeight.constant -= 50
                    topSpaceRole.constant = 20
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            if self.isToEdit == false{
                if let key =  self.userRoles.first(where: { $0.name! == item }){
                    print(key)
                    
                    self.view_FieldsToHide.isHidden = false
                    self.topSpace.constant = 268
                    viewHeight.constant = 1055
                }
                else{
                    self.view_FieldsToHide.isHidden = true
                    self.topSpace.constant = 16
                    viewHeight.constant = 800
                }
            }
        }
    }
    @IBAction func actionCountry(_ sender:UIButton) {
        self.view.endEditing(true)
        let sortedArray = array_country.sorted { $0.key < $1.key }
        let arrRoles = sortedArray.map { $0.value }
        let dropDown_Roles = DropDown()
        dropDown_Roles.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Roles.dataSource = arrRoles//Array(roles.values)
        dropDown_Roles.show()
        dropDown_Roles.selectionAction = { [unowned self] (index: Int, item: String) in
            txt_Country.text = item
            self.selectedcountry = sortedArray[index].key
        }
    }
    @IBAction func actionAddNew(_ sender: UIButton){
//        let addUnitVC = kStoryBoardSettings.instantiateViewController(identifier: "AddEditUnitTableViewController") as! AddEditUnitTableViewController
//        addUnitVC.isToEdit = false
//        self.navigationController?.pushViewController(addUnitVC, animated: true)
        
    }
    @IBAction func actionSubmit(_ sender: UIButton){
        self.view.endEditing(true)
        guard txt_FirstName.text!.count  > 0 else {
            displayErrorAlert(alertStr: "Please enter the first name", title: "")
            return
        }
        guard txt_LastName.text!.count  > 0 else {
            displayErrorAlert(alertStr: "Please enter the last name", title: "")
            return
        }
        if isToEdit == false{
            if self.isUserRole == true{
                guard txt_Building.text!.count  > 0 else {
                    displayErrorAlert(alertStr: "Please select the building", title: "")
                    return
                }
                guard txt_UnitNo.text!.count  > 0 else {
                    displayErrorAlert(alertStr: "Please select the unit", title: "")
                    return
                }
            }
        }
        guard txt_Contact.text!.count  > 0 else {
            displayErrorAlert(alertStr: "Please enter the contact number", title: "")
            return
        }
        
        guard txt_Email.text!.count  > 0 else {
            displayErrorAlert(alertStr: "Please enter the email", title: "")
            return
        }
        guard txt_Email.text!.isValidEmail() == true else {
            displayErrorAlert(alertStr: "Please enter a valid email address", title: "")
            return
        }
        
        guard txt_MailingAddress.text!.count  > 0 else {
            displayErrorAlert(alertStr: "Please enter the mailing address", title: "")
            return
        }
        if isToEdit == true{
            updateUser()
        }
        else{
            if  txt_MailingAddress.textColor == textColor{
                if txt_MailingAddress.text.isEmpty{
                    displayErrorAlert(alertStr: "Please enter the mailing address", title: "")
                }
                else{
                    createUser()
                }
            }
            else{
                displayErrorAlert(alertStr: "Please enter the mailing address", title: "")
            }
                 
      
        }
    }
    @IBAction func actionHome(_ sender: UIButton){
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    @IBAction func actionDelete(_ sender: UIButton){
        showDeleteAlert()
        
    }
    func showDeleteAlert(){
        let fname = Users.currentUser?.moreInfo?.first_name ?? ""
      let lname = Users.currentUser?.moreInfo?.last_name ?? ""
      let name = "\(fname) \(lname)"
        self.isToDelete = true
        alertView.delegate = self
        alertView.showInView(self.view_Background, title: "Are you sure you want to\n delete \(name)?", okTitle: "Yes", cancelTitle: "Back")
      
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

extension AddUserTableViewController: MenuViewDelegate{
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
extension AddUserTableViewController: AlertViewDelegate{
    func onBackClicked() {
      
    }
    
    func onCloseClicked() {
        
    }
    
    func onOkClicked() {
        if self.isToDelete == true{
            self.deleteUser()
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
    
    }
    
    
}
extension AddUserTableViewController: MessageAlertViewDelegate{
    func onHomeClicked() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func onListClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
extension AddUserTableViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == placeholderColor {
                textView.text = nil
            textView.textColor = textColor
            }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
               textView.text = "Mailing Address"
               textView.textColor = placeholderColor
           }
    }
}
extension AddUserTableViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
       
        return true
    }
   
}

class DataSource_Property: NSObject, UITableViewDataSource, UITableViewDelegate {
    var parentVc: UIViewController!
    var availableProperties =  [AvailableProperty]()
    var agent_assigned_property = [Int]()
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1;
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return  availableProperties.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "propertyCell") as! PropertyTableViewCell
        let property = array_Property[indexPath.row]
        
        cell.lbl_ProperyName.text = property.company_name
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
       // cell.view_Outer.addGestureRecognizer(tap)
        cell.btn_Checkbox.tag = property.id
        //indexPath.row
       
       

        if arr_SelectedPropertyIds.contains(property.id){
            cell.btn_Checkbox.isSelected  = true
        }
        else{
            cell.btn_Checkbox.isSelected  = false
        }
        
        
        cell.btn_Checkbox.addTarget(self, action: #selector(self.actionSelectProperty(_:)), for: .touchUpInside)
       
        
            return cell
      
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
      
        DispatchQueue.main.async {
            (self.parentVc as! AddUserTableViewController).table_Property.reloadData()
            (self.parentVc as! AddUserTableViewController).tableView.reloadData()
        
      
        }

    }
  
   
    @IBAction func actionSelectProperty(_ sender: UIButton){
        
        sender.isSelected = !sender.isSelected
      //  let prop = availableProperties[sender.tag]
        if sender.isSelected == true{
            arr_SelectedPropertyIds.append(sender.tag)
        }
        else{
            let indx =  arr_SelectedPropertyIds.firstIndex(of: sender.tag)
            if indx != nil{
            
                arr_SelectedPropertyIds.remove(at: indx!)
            }
           
        }
        DispatchQueue.main.async {
            (self.parentVc as! AddUserTableViewController).table_Property.reloadData()
        }
        
    }
    
}
