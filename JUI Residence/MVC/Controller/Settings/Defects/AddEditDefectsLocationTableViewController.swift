//
//  AddEditDefectsLocationTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 27/09/21.
//

import UIKit
import DropDown
class AddEditDefectsLocationTableViewController: BaseTableViewController {
    
    //Outlets
    @IBOutlet weak var view_SwitchProperty: UIView!
    @IBOutlet weak var lbl_SwitchProperty: UILabel!
    @IBOutlet weak var collection_DefectTypes: UICollectionView!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var txt_DefectLocation: UITextField!
    @IBOutlet weak var lbl_MsgTitle: UILabel!
    @IBOutlet weak var lbl_MsgDesc: UILabel!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var imgView_Profile: UIImageView!
    @IBOutlet weak var btn_Submit: UIButton!
    @IBOutlet weak var btn_Delete: UIButton!
    @IBOutlet  var arr_Btns: [UIButton]!
   // @IBOutlet weak var bottomSpace: NSLayoutConstraint!
    var location: DefectLocation!
    var isToDelete = false
    var isToEdit: Bool!
    let alertView: AlertView = AlertView.getInstance
    let alertView_message: MessageAlertView = MessageAlertView.getInstance
    let menu: MenuView = MenuView.getInstance
    var isToShowSucces = false
    var array_Defect_Types = [String]()//[[String : String]]()
    var locationBase: DefectsLocationDetailsBase!
    override func viewDidLoad() {
        super.viewDidLoad()
        view_SwitchProperty.layer.borderColor = themeColor.cgColor
        view_SwitchProperty.layer.borderWidth = 1.0
        view_SwitchProperty.layer.cornerRadius = 10.0
        view_SwitchProperty.layer.masksToBounds = true
        setUpCollectionViewLayout()
        lbl_SwitchProperty.text = kCurrentPropertyName
        lbl_MsgTitle.text = "Defect Location\n Added"
        lbl_MsgDesc.text = "The requested defect location has\n been added into the list."
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
        txt_DefectLocation.layer.cornerRadius = 20.0
        txt_DefectLocation.layer.masksToBounds = true
        txt_DefectLocation.delegate = self
        txt_DefectLocation.textColor = textColor
        txt_DefectLocation.attributedPlaceholder = NSAttributedString(string: txt_DefectLocation.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
        txt_DefectLocation.backgroundColor = isToEdit ? UIColor.white : UIColor(red: 208/255, green: 208/255, blue: 208/255, alpha: 1.0)
        
        
        if self.location != nil{
            self.txt_DefectLocation.text = location.defect_location
           
            btn_Delete.isHidden = false
            btn_Submit.setTitle("Save", for: .normal)
        }
        else{
            array_Defect_Types = [""]
            btn_Delete.isHidden = true
            btn_Submit.setTitle("Submit", for: .normal)
         //    bottomSpace.constant = 40
        }
       
       
    }
    //MARK:UICOLLECTION VIEW LAYOUT
    func setUpCollectionViewLayout(){
       
     
        
        let layout =  UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let cellWidth = (kScreenSize.width - 50)/CGFloat(2.0)
        let size = CGSize(width: cellWidth, height: 90)
        layout.itemSize = size
        collection_DefectTypes.collectionViewLayout = layout
       
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if location != nil{
        getDefectLocationDetails()
        }
        self.showBottomMenu()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.closeMenu()
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1{
            let rowCount = array_Defect_Types.count / 2 + array_Defect_Types.count % 2
            return CGFloat(self.isToShowSucces == true ? 0 : (110 * rowCount) + 530)
                
                
                
                
               // super.tableView(tableView, heightForRowAt: indexPath)//kScreenSize.height - 220
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
    
    //MARK: ******  PARSING *********
    func getDefectLocationDetails(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"        //
        ApiService.get_DefectLocationDetails(parameters: ["login_id":userId, "id":location.id], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? DefectsLocationDetailsBase){
                    self.locationBase = response
                    for obj in response.location.types{
                        self.array_Defect_Types.append(obj.defect_type)
                    }
                    self.collection_DefectTypes.reloadData()
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
    func createDefectLocation(){
       ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        let params = NSMutableDictionary()
        params.setValue("\(userId)", forKey: "login_id")
        params.setValue("\(self.txt_DefectLocation.text!)", forKey: "defect_location")
        
        for (indx, type) in self.array_Defect_Types.enumerated(){
            params.setValue(type, forKey: "defect_type_\(indx + 1)")
        }
        let count =  (self.array_Defect_Types.count + 1)
        for i in count...10{
            params.setValue("", forKey: "defect_type_\(i)")
        }
        ApiService.create_DefectLocation(parameters: params as! [String : Any], completion: { status, result, error in
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? CreateFeedbackOptionBase){
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
    func updateDefectLocation(){
       ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
       
        let params = NSMutableDictionary()
        params.setValue("\(userId)", forKey: "login_id")
        params.setValue("\(self.location.id)", forKey: "id")
        params.setValue("\(self.txt_DefectLocation.text!)", forKey: "defect_location")
        
        for (indx, type) in self.array_Defect_Types.enumerated(){
            params.setValue(type, forKey: "defect_type_\(indx + 1)")
            if indx < locationBase.location.types.count{
                params.setValue(locationBase.location.types[indx].id, forKey: "type_id_\(indx + 1)")
            }
        }
        let count =  (self.array_Defect_Types.count + 1)
        for i in count...10{
            params.setValue("", forKey: "defect_type_\(i)")
        }

        ApiService.update_DefectLocation(parameters: params as! [String : Any], completion: { status, result, error in
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? CreateFeedbackOptionBase){
                    if response.response == 1{
                        self.alertView_message.delegate = self
                        self.alertView_message.showInView(self.view_Background, title: "Defects Location \n changes has been\n saved", okTitle: "Home", cancelTitle: "View Defects Location")
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
    
    func deleteDefectLocation(){
       
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
       
        let param = [
            "login_id" : userId,
            "id" : self.location.id,
          
        ] as [String : Any]

        ApiService.delete_DefectLocation(parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
            self.isToDelete  = false
            if status  && result != nil{
                 if let response = (result as? DeleteUserBase){
                    if response.response == 1{
                        DispatchQueue.main.async {
                            self.alertView_message.delegate = self
                            self.alertView_message.showInView(self.view_Background, title: "Defect Location has\n been deleted", okTitle: "Home", cancelTitle: "View Defect Locations")
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
    @IBAction func actionAddNew(_ sender: UIButton){
        let type = ""
        self.array_Defect_Types.append(type)
        self.collection_DefectTypes.reloadData()
        self.tableView.reloadData()
    }
    @IBAction func actionDelete(_ sender: UIButton){
        showDeleteAlert()
        
    }
    func showDeleteAlert(){
        isToDelete = true
        alertView.delegate = self
        alertView.showInView(self.view_Background, title: "Are you sure you want to\n delete the following\n defect location?", okTitle: "Yes", cancelTitle: "Back")
      
    }
    @IBAction func actionCreateRole(_ sender: UIButton){
        let location = txt_DefectLocation.text?.replacingOccurrences(of: " ", with: "")
        if txt_DefectLocation.text == ""{
            displayErrorAlert(alertStr: "Please enter defect location", title: "")
        }
        else if txt_DefectLocation.text == ""{
            displayErrorAlert(alertStr: "Please enter a valid defect location", title: "")
        }
        
        else{
            var flag = false
            for obj in self.array_Defect_Types{
                if obj == "" || obj.replacingOccurrences(of: " ", with: "") == ""{
                    flag = true
                }
            }
            if flag == true{
                displayErrorAlert(alertStr: "Please enter a valid defect type", title: "")
            }
            
            else{
            
            if isToEdit == true {
                updateDefectLocation()
            }
            else{
                self.createDefectLocation()
            }
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
extension AddEditDefectsLocationTableViewController: MenuViewDelegate{
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
extension AddEditDefectsLocationTableViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
       
        return true
    }
   
}
extension AddEditDefectsLocationTableViewController: AlertViewDelegate{
    func onBackClicked() {
       
    }
    
    func onCloseClicked() {
        
    }
    
    func onOkClicked() {
        if isToDelete == true{
        deleteDefectLocation()
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
}
extension AddEditDefectsLocationTableViewController: MessageAlertViewDelegate{
    func onHomeClicked() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func onListClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

extension AddEditDefectsLocationTableViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return  array_Defect_Types.count
        
       
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "typeCell", for: indexPath) as! DefectTypeCollectionViewCell

       
        cell.lbl_Title.text = "Type \(indexPath.item + 1)"
        cell.txt_DefectType.text = array_Defect_Types[indexPath.item]
        cell.txt_DefectType.tag = indexPath.item
        cell.txt_DefectType.layer.cornerRadius = 20.0
        cell.txt_DefectType.layer.masksToBounds = true
        cell.txt_DefectType.delegate = self
        cell.txt_DefectType.textColor = textColor
        cell.txt_DefectType.attributedPlaceholder = NSAttributedString(string: cell.txt_DefectType.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
        cell.txt_DefectType.addTarget(self, action: #selector(valueChanged), for: .editingChanged)
        cell.txt_DefectType.backgroundColor = isToEdit ? UIColor.white : UIColor(red: 208/255, green: 208/255, blue: 208/255, alpha: 1.0)
            return cell
       
    }
    @objc func valueChanged(_ textField: UITextField){
        array_Defect_Types[textField.tag] = textField.text!
    }
    }
