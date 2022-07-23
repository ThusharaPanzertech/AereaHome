//
//  AddEditCard_DeviceTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 17/06/22.
//

import UIKit
import DropDown
class AddEditCard_DeviceTableViewController: BaseTableViewController {
    
    //Outlets
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_SuccessTitle: UILabel!
    @IBOutlet weak var lbl_SuccessDesc: UILabel!
    @IBOutlet weak var btn_ViewList: UIButton!
    @IBOutlet weak var txt_Unit: UITextField!
    @IBOutlet weak var txt_CardNo: UITextField!
    @IBOutlet weak var txt_Status: UITextField!
    @IBOutlet weak var lbl_Unit: UILabel!
    @IBOutlet weak var lbl_CardNo: UILabel!
    @IBOutlet weak var lbl_Status: UILabel!

    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var view_Background1: UIView!
    @IBOutlet weak var imgView_Profile: UIImageView!
    @IBOutlet weak var btn_Unit: UIButton!
    @IBOutlet weak var dropdown_Unit: UIImageView!
    @IBOutlet weak var btn_Submit: UIButton!
    @IBOutlet weak var btn_Delete: UIButton!
    @IBOutlet  var arr_Btns: [UIButton]!
    @IBOutlet weak var bottomSpace: NSLayoutConstraint!
    @IBOutlet  var arr_Textfields: [UITextField]!
    var isCardAccess: Bool!
    var isToDelete = false
    var unitsData = [Unit]()
    var locationssData = [DeviceLocation]()
    var cardInfo: Card!
    var deviceInfo: Device!
    var isToEdit: Bool!
    let alertView: AlertView = AlertView.getInstance
    let alertView_message: MessageAlertView = MessageAlertView.getInstance
    let menu: MenuView = MenuView.getInstance
    var isToShowSucces = false
    override func viewDidLoad() {
        super.viewDidLoad()
        let fname = Users.currentUser?.user?.name ?? ""
        let lname = Users.currentUser?.moreInfo?.last_name ?? ""
        self.lbl_UserName.text = "\(fname) \(lname)"
        let role = Users.currentUser?.role?.name ?? ""
        self.lbl_UserRole.text = role
        imgView_Profile.addborder()
        for btn in arr_Btns{
            btn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
            btn.layer.cornerRadius = 8.0
        }
        for txtfield in arr_Textfields{
            txtfield.layer.cornerRadius = 20.0
            txtfield.layer.masksToBounds = true
            txtfield.delegate = self
            txtfield.textColor = textColor
            txtfield.attributedPlaceholder = NSAttributedString(string: txtfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
            txtfield.backgroundColor = isToEdit ? UIColor.white : UIColor(red: 208/255, green: 208/255, blue: 208/255, alpha: 1.0)
        
        }
        view_Background1.layer.cornerRadius = 25.0
        view_Background1.layer.masksToBounds = true
        if isCardAccess {
            
            lbl_Title.text = isToEdit ? "Edit Access Card" : "Add Access Card"
            self.txt_Status.placeholder = "Please select status"
            self.txt_CardNo.placeholder = "Please enter card no"
            self.txt_Unit.placeholder = "Please select Unit no"
            self.lbl_Status.text = "Status"
            self.lbl_CardNo.text = "Card No"
            self.lbl_Unit.text = "Unit No"
            self.btn_ViewList.setTitle("View CardList", for: .normal)
            if self.cardInfo != nil{
                if let unitId = unitsData.first(where: { $0.id == cardInfo.unit_no }) {
                    self.txt_Unit.text = "#" + unitId.unit
                }
                else{
                    self.txt_Unit.text = ""
                }
                      self.txt_Status.text = cardInfo.status == 1 ? "Active" :  cardInfo.status == 2 ? "Inactive" :  cardInfo.status == 3 ? "Faulty" :  cardInfo.status == 4 ? "Loss" :  cardInfo.status == 5 ? "Stolen" :""
                
                      self.txt_CardNo.text = self.cardInfo.card
                self.txt_Unit.alpha = 0.5
                      self.txt_Unit.isUserInteractionEnabled = false
                self.btn_Unit.isUserInteractionEnabled = false
                      btn_Delete.isHidden = false
                      btn_Submit.setTitle("Save", for: .normal)
                dropdown_Unit.removeFromSuperview()
                lbl_SuccessTitle.text = "Card Updated"
                lbl_SuccessDesc.text = "Card details updated successfully."
                  }
                  else{
                      self.txt_Unit.alpha = 1.0
                      btn_Delete.isHidden = true
                      self.txt_Unit.isUserInteractionEnabled = true
                      self.btn_Unit.isUserInteractionEnabled = true
                      
                      btn_Submit.setTitle("Submit", for: .normal)
                      bottomSpace.constant = 40
                      lbl_SuccessTitle.text = "Card Added"
                      lbl_SuccessDesc.text = "Card details added into the list."
                  }
            
            
        }
        else{
            self.btn_ViewList.setTitle("View Device List", for: .normal)
            lbl_Title.text = isToEdit ?  "Edit New Device" : "Add New Device"
            btn_Unit.removeFromSuperview()
            dropdown_Unit.removeFromSuperview()
            self.txt_CardNo.placeholder = "Enter device name"
            self.txt_Unit.placeholder = "Enter serial no"
            self.txt_Status.placeholder = "Select installation location"
            self.lbl_Status.text = "Location"
            self.lbl_CardNo.text = "Device Name"
            self.lbl_Unit.text = "Serial No"
            self.getInstallationLocation()
            if self.deviceInfo != nil{
                btn_Delete.isHidden = false
                btn_Submit.setTitle("Save", for: .normal)
          lbl_SuccessTitle.text = "Device Updated"
          lbl_SuccessDesc.text = "Device details updated successfully."
                
                txt_Unit.text = deviceInfo.device_serial_no
                txt_CardNo.text = deviceInfo.device_name
                txt_Status.text = deviceInfo.location
          
            }
            else{
                btn_Submit.setTitle("Submit", for: .normal)
                bottomSpace.constant = 40
                lbl_SuccessTitle.text = "Device Added"
                lbl_SuccessDesc.text = "Device details added into the list."
            
            }
        }
//        if self.unitInfo != nil{
//            self.txt_Unit.text = unitInfo.unit
//            self.txt_Size.text = self.unitInfo.size
//            self.txt_Share.text = self.unitInfo.share_amount
//
//            self.txt_Unit.isUserInteractionEnabled = false
//            btn_Delete.isHidden = false
//            btn_Submit.setTitle("Save", for: .normal)
//        }
//        else{
//            btn_Delete.isHidden = true
//            self.txt_Unit.isUserInteractionEnabled = true
//            btn_Submit.setTitle("Submit", for: .normal)
//            bottomSpace.constant = 40
//        }
       
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
    func createCard(){
       ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        var unit = 0
        if let unitId = unitsData.first(where: { $0.unit == txt_Unit.text }) {
            unit = unitId.id
        }
        else{
            self.txt_Unit.text = ""
        }
        let param = [
            "login_id" : userId,
            "unit_no" : unit,
            "card" : txt_CardNo.text!,
           // "size" : txt_Size.text!
            
        ] as [String : Any]

        ApiService.create_Card(parameters: param, completion: { status, result, error in
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
    func updateCard(){
        ActivityIndicatorView.show("Loading")
         let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
         var unit = 0
         if let unitId = unitsData.first(where: { $0.unit == txt_Unit.text }) {
             unit = unitId.id
         }
         else{
             self.txt_Unit.text = ""
         }
         let param = [
             "login_id" : userId,
             "id": cardInfo.id,
             "unit_no" : cardInfo.unit_no,
             "card" : txt_CardNo.text!,
             "status" : txt_Status.text! == "Active" ? 1 :
                txt_Status.text! == "Inactive" ? 2 :
                txt_Status.text! == "Faulty" ? 3 :
                txt_Status.text! == "Loss" ? 4 :
                txt_Status.text! == "Stolen" ? 5 :
                "",
             "remarks" : ""
                
             
         ] as [String : Any]

         ApiService.update_Card(parameters: param, completion: { status, result, error in
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
    
    func deleteCard(){
       
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
       
        let param = [
            "login_id" : userId,
            "id" : self.cardInfo.id,
          
        ] as [String : Any]

        ApiService.delete_Card(parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
            self.isToDelete  = false
            if status  && result != nil{
                 if let response = (result as? DeleteUserBase){
                    if response.response == 1{
                        DispatchQueue.main.async {
                            self.alertView_message.delegate = self
                            self.alertView_message.showInView(self.view_Background, title: "Card has been\n deleted", okTitle: "Home", cancelTitle: "View Cards List")
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
 
    
    //MARK: ******  PARSING *********
    func getInstallationLocation(){
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.get_deviceLocationSummary(parameters: ["login_id":userId], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? DeviceLocationBase){
                    self.locationssData = response.locations
                    
                 
                
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
    func createDevice(){
       ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        var locationId = 0
        if let location = locationssData.first(where: { $0.building == txt_Status.text }) {
            locationId = location.id
        }
        else{
            self.txt_Unit.text = ""
        }
        let param = [
            "login_id" : userId,
            "device_serial_no" : txt_Unit.text!,
            "device_name" : txt_CardNo.text!,
            "locations" : locationId
            
        ] as [String : Any]

        ApiService.create_Device(parameters: param, completion: { status, result, error in
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
    func updateDevice(){
        ActivityIndicatorView.show("Loading")
         let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
         var locationId = 0
         if let location = locationssData.first(where: { $0.building == txt_Status.text }) {
             locationId = location.id
         }
         else{
             self.txt_Unit.text = ""
         }
         let param = [
             "login_id" : userId,
             "device_serial_no" : txt_Unit.text!,
             "device_name" : txt_CardNo.text!,
             "locations" : locationId,
             "id": deviceInfo.id
             
         ] as [String : Any]

         ApiService.edit_Device(parameters: param, completion: { status, result, error in
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
    
    func deleteDevice(){
       
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
       
        let param = [
            "login_id" : userId,
            "id" : self.deviceInfo.id,
          
        ] as [String : Any]

        ApiService.delete_Device(parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
            self.isToDelete  = false
            if status  && result != nil{
                 if let response = (result as? DeleteUserBase){
                    if response.response == 1{
                        DispatchQueue.main.async {
                            self.alertView_message.delegate = self
                            self.alertView_message.showInView(self.view_Background, title: "Device has been\n deleted", okTitle: "Home", cancelTitle: "View Device List")
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
    @IBAction func actionDelete(_ sender: UIButton){
        showDeleteAlert()
        
    }
    func showDeleteAlert(){
        let title = isCardAccess ? "Card" : "Device"
        isToDelete = true
        alertView.delegate = self
        alertView.showInView(self.view_Background, title: "Are you sure you want to\n delete the following \(title)?", okTitle: "Yes", cancelTitle: "Back")
      
    }
    @IBAction func actionCreateCard(_ sender: UIButton){
        if isCardAccess{
        let cardno = txt_CardNo.text?.replacingOccurrences(of: " ", with: "")
             if txt_CardNo.text == ""{
                displayErrorAlert(alertStr: "Please enter card number", title: "")
            }
            else if cardno == ""{
                displayErrorAlert(alertStr: "Please enter a valid card number", title: "")
            }
        else if txt_Unit.text == ""{
            displayErrorAlert(alertStr: "Please enter unit", title: "")
        }
       
        else if txt_Status.text == ""{
            displayErrorAlert(alertStr: "Please select card status", title: "")
        }
       
        else{
            if isToEdit == true {
                updateCard()
            }
            else{
                self.createCard()
            }
        }
        }
        else{
            let devicename = txt_CardNo.text?.replacingOccurrences(of: " ", with: "")
                 if txt_CardNo.text == ""{
                    displayErrorAlert(alertStr: "Please enter device name", title: "")
                }
                else if devicename == ""{
                    displayErrorAlert(alertStr: "Please enter a valid device name", title: "")
                }
            else if txt_Unit.text == ""{
                displayErrorAlert(alertStr: "Please enter serial no", title: "")
            }
           
            else if txt_Status.text == ""{
                displayErrorAlert(alertStr: "Please select installation location", title: "")
            }
           
            else{
                if isToEdit == true {
                    updateDevice()
                }
                else{
                    self.createDevice()
                }
            }
        }
    }
    @IBAction func actionBackPressed(_ sender: UIButton){
        if isToEdit{
            self.navigationController?.popViewController(animated: true)
        }
        else{
        alertView.delegate = self
        alertView.showInView(self.view_Background, title: "Are you sure you want to\n leave this page?\nYour changes would not\n be saved.", okTitle: "Back", cancelTitle: "Yes")
        }
    }
    @IBAction func actionStatus(_ sender:UIButton) {
        if isCardAccess{
        let arrStatus = [ "Active", "Inactive", "Faulty", "Loss", "Stolen"]
        let dropDown_Status = DropDown()
        dropDown_Status.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Status.dataSource = arrStatus//statusData.map({$0.value})//Array(statusData.values)
        dropDown_Status.show()
        dropDown_Status.selectionAction = { [unowned self] (index: Int, item: String) in
            txt_Status.text = item
           
        }
        }
        else{
            let dropDown_Status = DropDown()
            dropDown_Status.anchorView = sender // UIView or UIBarButtonItem
            dropDown_Status.dataSource = locationssData.map({$0.building})//Array(statusData.values)
            dropDown_Status.show()
            dropDown_Status.selectionAction = { [unowned self] (index: Int, item: String) in
                txt_Status.text = item
        }
        }
    }
    @IBAction func actionUnit(_ sender:UIButton) {
       // let sortedArray = unitsData.sorted(by:  { $0.1 < $1.1 })
        if isCardAccess{
        let arrUnit = unitsData.map { $0.unit }
        let dropDown_Unit = DropDown()
        dropDown_Unit.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Unit.dataSource = arrUnit// Array(unitsData.values)
        dropDown_Unit.show()
        dropDown_Unit.selectionAction = { [unowned self] (index: Int, item: String) in
            
           
            txt_Unit.text = item
            
            
        }
        }
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
extension AddEditCard_DeviceTableViewController: MenuViewDelegate{
    func onMenuClicked(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            self.menu.contractMenu()
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
extension AddEditCard_DeviceTableViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
       
        return true
    }
   
}
extension AddEditCard_DeviceTableViewController: AlertViewDelegate{
    func onBackClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func onCloseClicked() {
        
    }
    
    func onOkClicked() {
        if isToDelete == true{
            if isCardAccess{
                deleteCard()
            }
            else{
                self.deleteDevice()
            }
        }
    }
    
    
}
extension AddEditCard_DeviceTableViewController: MessageAlertViewDelegate{
    func onHomeClicked() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func onListClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
