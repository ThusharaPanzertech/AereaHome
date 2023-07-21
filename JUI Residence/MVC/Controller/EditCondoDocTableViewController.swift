//
//  EditCondoDocTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 27/12/21.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers
import DropDown
class EditCondoDocTableViewController: BaseTableViewController {
    var arr_FileNames = [String]()
    let menu: MenuView = MenuView.getInstance
    @IBOutlet weak var view_SwitchProperty: UIView!
    @IBOutlet weak var lbl_SwitchProperty: UILabel!
    @IBOutlet weak var spaceContraint: NSLayoutConstraint!
    @IBOutlet weak var txt_CategoryName: UITextField!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var view_Footer: UIView!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var imgView_Profile: UIImageView!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var collection_CondoDoc: UICollectionView!
    @IBOutlet var arr_Buttons: [UIButton]!
    @IBOutlet var btn_Submit: UIButton!
    @IBOutlet var btn_Delete: UIButton!
    var pickerIndex = 0
    var isToAdd: Bool!
    let kFileName = "file_name"
    let kFilePath = "file_path"
    let alertView: AlertView = AlertView.getInstance
    let alertView_message: MessageAlertView = MessageAlertView.getInstance
    var condoDoc: CondoCategory!
    var array_CondoFiles = [CondoFiles]()
    var array_Files = [[String:Any?]]()
    let documentInteractionController = UIDocumentInteractionController()
    var selectedIndexes = [Int]()
    override func viewDidLoad() {
        super.viewDidLoad()
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
        setUpUI()
        setUpCollectionViewLayout()
        if isToAdd == false{
            self.getDeocumentDetail()
            txt_CategoryName.text = self.condoDoc.docs_category
        }
        else{
            btn_Submit.setTitle("Upload", for: .normal)
            array_Files = [[String:Any]]()
            array_Files = [[kFileName:"",kFilePath:nil]]
            arr_FileNames = [""]
        }
        txt_CategoryName.backgroundColor = isToAdd ?  UIColor(red: 208/255, green: 208/255, blue: 208/255, alpha: 1.0) : UIColor.white
    }
    func setUpUI(){
        if isToAdd == true{
            spaceContraint.constant = 50
            txt_CategoryName.backgroundColor = UIColor(red: 208/255, green: 208/255, blue: 208/255, alpha: 1.0)
            arr_Buttons[1].isHidden = true
            arr_Buttons[0].setTitle("Upload", for: .normal)
        }
        else{
          
        }
        txt_CategoryName.layer.cornerRadius = 20.0
        txt_CategoryName.layer.masksToBounds = true
        for btn in arr_Buttons{
            btn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
            btn.layer.cornerRadius = 8.0
        }
        view_Background.layer.cornerRadius = 25.0
        view_Background.layer.masksToBounds = true
      
        imgView_Profile.addborder()
       
        txt_CategoryName.attributedPlaceholder = NSAttributedString(string: txt_CategoryName.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done));
      let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
      toolbar.setItems([spaceButton,doneButton], animated: false)
        txt_CategoryName.inputAccessoryView = toolbar
        
    }
    func reload(){
        collection_CondoDoc.reloadData()
    }
    @objc func done(){
        self.view.endEditing(true)
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
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1{
            let count = isToAdd ? array_Files.count : array_CondoFiles.count + array_Files.count
            let rowCount = count / 2 + count % 2
            
            let cellWidth = (kScreenSize.width - 90)/CGFloat(2.0)

            return CGFloat((Int(cellWidth) * rowCount) + 500)
           
        }
       
        return super.tableView(tableView, heightForRowAt: indexPath)
    
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return view_Footer
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 150

    }
    
    //MARK:UICOLLECTION VIEW LAYOUT
    func setUpCollectionViewLayout(){
       
     
        
        let layout =  UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let cellWidth = (kScreenSize.width - 55)/CGFloat(2.0)
        let size = CGSize(width: cellWidth, height: cellWidth * 0.912)
        layout.itemSize = size
        collection_CondoDoc.collectionViewLayout = layout
    
        self.collection_CondoDoc.reloadData()
        
    }
    //MARK: ******  PARSING *********
    func getDeocumentDetail(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        ApiService.get_CondoDetail(parameters: ["login_id":userId , "id": self.condoDoc.id], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                if let response = (result as? CondoDetailsBase){
                    self.condoDoc = response.docs
                    self.array_CondoFiles = response.docs.files
                    for obj in self.array_CondoFiles{
                        self.arr_FileNames.append(obj.docs_file_name)
                    }
                    DispatchQueue.main.async {
                       
                   self.collection_CondoDoc.reloadData()
                   self.tableView.reloadData()
                    }
                }
        }
            else if error != nil{
              //  self.displayErrorAlert(alertStr: "\(error!.localizedDescription)", title: "Oops")
            }
            else{
              //  self.displayErrorAlert(alertStr: "Something went wrong.Please try again", title: "Oops")
            }
        })
    }
    func createCondoDocument(){
       ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        let params = NSMutableDictionary()
        params.setValue("\(userId)", forKey: "login_id")
        params.setValue("\(self.txt_CategoryName.text!)", forKey: "docs_category")
        var imageFiles = [[String:Any]]()
        for (indx, obj) in self.array_Files.enumerated(){
          //  params.setValue(obj[kFileName]!, forKey: "file_name_\(indx + 1)")
            params.setValue(arr_FileNames[indx], forKey: "file_name_\(indx + 1)")
            if obj[kFilePath] as? URL != nil{
                do {
                    var file_extension = "application/pdf"
                    var strUrl = (obj[kFilePath] as! URL).absoluteString
                    strUrl = (strUrl as! NSString).removingPercentEncoding!
                    let safeURL = strUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                 

                    let url = URL(string: safeURL!)//URL(fileURLWithPath: safeURL)//(obj[kFilePath] as! URL).absoluteString)
                    let fileData = try Data(contentsOf: url!)
               // let fileData = try Data(contentsOf: obj[kFilePath] as! URL)
                    let path = (obj[kFilePath] as! URL).absoluteString
                    let arr = path.components(separatedBy: ".")
                    if arr.count > 0{
                         file_extension = arr.last == "doc" || arr.last == "docx" ? "application/msword" : "application/pdf"
                        
                    }
                    imageFiles.append(["name":"file_\(indx + 1)","image":fileData, "extension": file_extension])
                }
                catch {
                    print("Unable to read file data: ", error)
                }
            }
 }
        
        
        ApiService.create_CondoDocument(files: imageFiles, parameters: params as! [String : Any]) { status, result, error in
            ActivityIndicatorView.hiding()
            
            if status  && result != nil{
                if let response = (result as? CreateCondoBase){
                    if response.response ==  1{
                        
                        self.alertView_message.delegate = self
                        self.alertView_message.showInView(self.view, title: "Condo Document has\nbeen uploaded", okTitle: "Home", cancelTitle: "View Condo Documents")
                    }
                    else{
                        self.displayErrorAlert(alertStr: "\(response.message)", title: "Oops")
                    }
                }
        }
            else if error != nil{
                self.displayErrorAlert(alertStr: "Server busy. Please try again shortly.", title: "Oops")
            }
            else{
                self.displayErrorAlert(alertStr: "Server busy. Please try again shortly.", title: "Oops")
            }
        }
       
    }
    
    
    func editCondoDocument(){
       ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        let params = NSMutableDictionary()
        params.setValue("\(userId)", forKey: "login_id")
        params.setValue("\(self.txt_CategoryName.text!)", forKey: "docs_category")
        params.setValue("\(self.condoDoc.id)", forKey: "id")
        for (indx, obj) in self.array_CondoFiles.enumerated(){
            params.setValue("\(obj.id)", forKey: "file_id_\(indx + 1)")
            params.setValue("\(arr_FileNames[indx])", forKey: "file_name_\(indx + 1)")
        }
        
        var imageFiles = [[String:Any]]()
        for (indx, obj) in self.array_Files.enumerated(){
            params.setValue(obj[kFileName]!, forKey: "file_name_\(indx + array_CondoFiles.count + 1)")
            if obj[kFilePath] as? URL != nil{
                do {
                    var file_extension = "application/pdf"
                    var strUrl = (obj[kFilePath] as! URL).absoluteString
                    strUrl = (strUrl as! NSString).removingPercentEncoding!
                    let safeURL = strUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                 

                    let url = URL(string: safeURL!)//URL(fileURLWithPath: safeURL)//(obj[kFilePath] as! URL).absoluteString)
                    let fileData = try Data(contentsOf: url!)
               // let fileData = try Data(contentsOf: obj[kFilePath] as! URL)
                    let path = (obj[kFilePath] as! URL).absoluteString
                    let arr = path.components(separatedBy: ".")
                    if arr.count > 0{
                         file_extension = arr.last == "doc" || arr.last == "docx" ? "application/msword" : "application/pdf"
                        
                    }
                    imageFiles.append(["name":"file_\(indx + 1 + array_CondoFiles.count)","image":fileData, "extension": file_extension])
                }
                catch {
                    print("Unable to read file data: ", error)
                }
            }
 }
        
        
        ApiService.edit_CondoDocument(files: imageFiles, parameters: params as! [String : Any]) { status, result, error in
            ActivityIndicatorView.hiding()
            
            if status  && result != nil{
                if let response = (result as? CreateCondoBase){
                    if response.response ==  1{
                        
                        self.alertView_message.delegate = self
                        self.alertView_message.showInView(self.view, title: "Condo Document has\nbeen updated", okTitle: "Home", cancelTitle: "View Condo Documents")
                    }
                    else{
                        self.displayErrorAlert(alertStr: "\(response.message)", title: "Oops")
                    }
                }
        }
            else if error != nil{
                self.displayErrorAlert(alertStr: "Server busy. Please try again shortly.", title: "Oops")
            }
            else{
                self.displayErrorAlert(alertStr: "Server busy. Please try again shortly.", title: "Oops")
            }
        }
       
    }
    
    
    func deleteCondoDocument(){
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
     
        let id = condoDoc.id
        let param = [
            "login_id" : userId,
            "id" : id,
          
        ] as [String : Any]

        ApiService.delete_CondoDoc(parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? DeleteUserBase){
                    if response.response == 1{
                        DispatchQueue.main.async {
                            self.alertView_message.delegate = self
                            self.alertView_message.showInView(self.view_Background, title: "Condo document\nhas been deleted", okTitle: "Home", cancelTitle: "View Condo Documents")
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
    func deleteCondoFiles(){
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
     
        let params = NSMutableDictionary()
        params.setValue("\(userId)", forKey: "login_id")
        params.setValue("\(condoDoc.id)", forKey: "cat_id")
        
        for (indx,value) in selectedIndexes.enumerated(){
            let fileid = condoDoc.files[value].id
            params.setValue("\(fileid)", forKey: "file_ids[\(indx)]")
        }
        ApiService.delete_CondoFiles(parameters: params as! [String : Any], completion: { status, result, error in
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? DeleteUserBase){
                    if response.response == 1{
                        DispatchQueue.main.async {
                            self.alertView_message.delegate = self
                            self.alertView_message.showInView(self.view_Background, title: "Condo document\nhas been updated", okTitle: "Home", cancelTitle: "View Condo Documents")
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
    @IBAction func actionBackPressed(_ sender: UIButton){
        self.view.endEditing(true)
        if isToAdd == true{
            alertView.delegate = self
            alertView.showInView(self.view_Background, title: "Are you sure you want to\nleave this page?\nYour changes would not\nbe saved.", okTitle: "Yes", cancelTitle: "Back")
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func actionSave(_ sender: UIButton){
        if sender.currentTitle == "Save"{
            if txt_CategoryName.text == ""{
                self.displayErrorAlert(alertStr: "Please enter category name", title: "Oops")
            }
            if array_Files.count  > 0{
                var flag = false
                var msg = ""
                for obj in array_Files{
                    if  obj[kFilePath] as? URL == nil{
                        flag = true
                        msg = "Please upload file"
                        break
                        
                    }
                }
                if flag == true{
                    displayErrorAlert(alertStr: msg, title: "")
                    return
                }
               
            }
            
            
                if arr_FileNames.count  > 0{
                    var flag = false
                    var msg = ""
                    for obj in arr_FileNames{
                        if obj == "" {
                            flag = true
                            msg =  "Please enter file name"
                            break
                            
                        }
                    }
                    if flag == true{
                        displayErrorAlert(alertStr: msg, title: "")
                        return
                    }
                   
                }
                
                    editCondoDocument()
               
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        }
        else{
            if txt_CategoryName.text == ""{
                self.displayErrorAlert(alertStr: "Please enter category name", title: "Oops")
            }
            if array_Files.count == 0{
                self.displayErrorAlert(alertStr: "Please upload atleast one file", title: "Oops")
            }
            else{
                var flag = false
                var msg = ""
                for obj in array_Files{
                    if /* obj[kFileName] as? String == "" || */obj[kFilePath] as? URL == nil{
                        flag = true
                        msg = "Please upload file"
                        //obj[kFileName] as? String == "" ? "Please enter file name" : "Please upload file"
                        break
                        
                    }
                }
                if flag == true{
                    displayErrorAlert(alertStr: msg, title: "")
                    return
                }
                else{
                createCondoDocument()
                }
                
                
            }
//
        }
    }
    @IBAction func actionDelete(_ sender: UIButton){
        if sender.currentTitle == "Delete"{
        alertView.delegate = self
        alertView.showInView(self.view_Background, title: "Are you sure you want to\n delete the following\n condo document?", okTitle: "Yes", cancelTitle: "Back")
        }
        else{
            deleteCondoFiles()
        }
    }
    @IBAction func actionSelect_DeleteFile(_ sender: UIButton){
        if isToAdd == false{
            if sender.tag < array_CondoFiles.count{
                sender.isSelected = !sender.isSelected
                if sender.isSelected {
                    selectedIndexes.append(sender.tag)
                    let file = selectedIndexes.count == 1 ? "file" : "files"
                    let count = selectedIndexes.count
                    btn_Delete.setTitle("Delete \(count) \(file)", for: .normal)
                }
                else{
                    let indx =  selectedIndexes.firstIndex(of: sender.tag)
                    //selectedIndexes.first(where: { $0 == sender.tag})
                    if indx != nil{
                       
                    selectedIndexes.remove(at: indx!)
                    }
                    if selectedIndexes.count == 0{
                        btn_Delete.setTitle("Delete", for: .normal)
                    }
                    else{
                        let file = selectedIndexes.count == 1 ? "file" : "files"
                        let count = selectedIndexes.count
                        btn_Delete.setTitle("Delete \(count) \(file)", for: .normal)
                        
                    }
                }
                
                self.collection_CondoDoc.reloadData()
                self.tableView.reloadData()
            }
            else{
                self.array_Files.remove(at: sender.tag - array_CondoFiles.count)
                self.collection_CondoDoc.reloadData()
                self.tableView.reloadData()
            }
        }
        else{
            self.array_Files.remove(at: sender.tag)
            self.collection_CondoDoc.reloadData()
            self.tableView.reloadData()
        }
    }
    @IBAction func actionSelectFile(_ sender: UIButton){
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            selectedIndexes.append(sender.tag)
            let file = selectedIndexes.count == 1 ? "file" : "files"
            let count = selectedIndexes.count
            btn_Delete.setTitle("Delete \(count) \(file)", for: .normal)
        }
        else{
            let indx =  selectedIndexes.firstIndex(of: sender.tag)
            //selectedIndexes.first(where: { $0 == sender.tag})
            if indx != nil{
               
            selectedIndexes.remove(at: indx!)
            }
            if selectedIndexes.count == 0{
                btn_Delete.setTitle("Delete", for: .normal)
            }
            else{
                let file = selectedIndexes.count == 1 ? "file" : "files"
                let count = selectedIndexes.count
                btn_Delete.setTitle("Delete \(count) \(file)", for: .normal)
                
            }
        }
        
        self.collection_CondoDoc.reloadData()
        self.tableView.reloadData()
    }
    @IBAction func actionAddNew(_ sender: UIButton){
        if isToAdd == true{
        if array_Files.count < 10{
        let new_File  = [kFileName:"",kFilePath:nil]
        array_Files.append(new_File)
            arr_FileNames.append("")
            collection_CondoDoc.reloadData()
        self.tableView.reloadData()
            self.view.endEditing(true)
           
           // let file = array_Files[sender.tag]
          
        }
        else{
            self.displayErrorAlert(alertStr: "You can upload upto 10 files", title: "Oops")
        }
        }
        else{
            if array_Files.count + array_CondoFiles.count < 10{
            let new_File  = [kFileName:"",kFilePath:nil]
                array_Files.append(new_File)
                arr_FileNames.append("")
                collection_CondoDoc.reloadData()
                self.tableView.reloadData()
                self.view.endEditing(true)
               
               // let file = array_Files[sender.tag]
              
            }
            else{
                self.displayErrorAlert(alertStr: "You can upload upto 10 files", title: "Oops")
            }
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
extension EditCondoDocTableViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isToAdd ? array_Files.count : array_CondoFiles.count + array_Files.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "documentCell", for: indexPath) as! DocumentCollectionViewCell
        cell.view_Outer.layer.cornerRadius = 6.0
        cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.gray, radius: 3.0, opacity: 0.35)
        cell.lbl_Index.text = "\(indexPath.item + 1)"
        cell.view_Outer.tag = indexPath.item
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done));
      let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
      toolbar.setItems([spaceButton,doneButton], animated: false)
        cell.txt_DocumentName.inputAccessoryView = toolbar
        cell.txt_DocumentName.tag = indexPath.item
        cell.txt_DocumentName.delegate = self
        if isToAdd ==  false{
            if indexPath.item < array_CondoFiles.count{
            let file = array_CondoFiles[indexPath.item]
            cell.txt_DocumentName.text = file.docs_file_name
            cell.btn_Icon.setImage(UIImage(named: "unchecked"), for: .normal)
            cell.btn_Icon.setImage(UIImage(named: "checked"), for: .selected)
            cell.btn_Icon.tag = indexPath.item
            cell.btn_Icon.addTarget(self, action: #selector(self.actionSelect_DeleteFile(_:)), for: .touchUpInside)
                cell.imgIcon.image = UIImage(named: "document")
                let indx =  selectedIndexes.firstIndex(of: indexPath.item)
                //selectedIndexes.first(where: { $0 == sender.tag})
                if indx != nil{
                    cell.btn_Icon.isSelected = true
                }
                else{
                    cell.btn_Icon.isSelected = false
                }
            }
            else{
                let file = array_Files[indexPath.item - array_CondoFiles.count]
                if  file[kFilePath] as? URL == nil{
                    cell.imgIcon.image = UIImage(named: "add")
                }
                else{
                    cell.imgIcon.image = UIImage(named: "document")
                }
                cell.txt_DocumentName.text  = file[kFileName] as! String
                cell.imgIcon.tag = indexPath.item// - array_CondoFiles.count
                cell.imgIcon.isUserInteractionEnabled = true
                let tap_Add = UITapGestureRecognizer(target: self, action: #selector(self.handleTapAdd(_:)))
                cell.imgIcon.addGestureRecognizer(tap_Add)
                cell.btn_Icon.setImage(UIImage(named: "delete"), for: .normal)
                cell.btn_Icon.tag = indexPath.item// - array_CondoFiles.count
                cell.btn_Icon.addTarget(self, action: #selector(self.actionSelect_DeleteFile(_:)), for: .touchUpInside)
            }
        }
        else{
            let file = array_Files[indexPath.item]
            if  file[kFilePath] as? URL == nil{
                cell.imgIcon.image = UIImage(named: "add")
            }
            else{
                cell.imgIcon.image = UIImage(named: "document")
            }
            cell.txt_DocumentName.text  = file[kFileName] as! String
            cell.imgIcon.tag = indexPath.item
            cell.imgIcon.isUserInteractionEnabled = true
            let tap_Add = UITapGestureRecognizer(target: self, action: #selector(self.handleTapAdd(_:)))
            cell.imgIcon.addGestureRecognizer(tap_Add)
            cell.btn_Icon.setImage(UIImage(named: "delete"), for: .normal)
            cell.btn_Icon.tag = indexPath.item
            cell.btn_Icon.addTarget(self, action: #selector(self.actionSelect_DeleteFile(_:)), for: .touchUpInside)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        cell.view_Outer.addGestureRecognizer(tap)
        
       
        
        return cell
    }
    @objc @IBAction func actionIcon(_ sender: UIButton){
        self.view.endEditing(true)
       
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        self.view.endEditing(true)
    
    }
    @objc func handleTapAdd(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        self.view.endEditing(true)
        let file = array_Files[(sender! as UITapGestureRecognizer).view!.tag - array_CondoFiles.count]
        if file[kFilePath] as? URL == nil{
         
            self.pickerIndex = (sender! as UITapGestureRecognizer).view!.tag - array_CondoFiles.count
            let importMenu: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF), "com.microsoft.word.doc","org.openxmlformats.wordprocessingml.document"], in: .import)
            if #available(iOS 11.0, *) {
                importMenu.allowsMultipleSelection = false
            }
            importMenu.shouldShowFileExtensions = true
            importMenu.delegate = self
            importMenu.modalPresentationStyle = .formSheet
            self.present(importMenu, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
extension EditCondoDocTableViewController: AlertViewDelegate{
    func onOkClicked() {
        if isToAdd == true{
            self.navigationController?.popViewController(animated: true)
        }
        else{
            self.deleteCondoDocument()

        }
       
    }
    
    func onCloseClicked() {
        
    }
    
    func onBackClicked() {
       
       
    }
    
    
}
extension EditCondoDocTableViewController: MessageAlertViewDelegate{
    func onHomeClicked() {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func onListClicked() {
        selectedRowIndex_Appointment = -1
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

extension EditCondoDocTableViewController: MenuViewDelegate{
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

extension EditCondoDocTableViewController:  UIDocumentMenuDelegate,UIDocumentPickerDelegate,UINavigationControllerDelegate{
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        print("import result : \(myURL)")
        var file = array_Files[pickerIndex]
        file[kFilePath] = myURL
        let filename = myURL.lastPathComponent
        file[kFileName] = filename
        array_Files[pickerIndex] = file
        self.reload()
    }
          

    public func documentMenu(_ documentMenu:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        self.present(documentPicker, animated: true, completion: nil)
    }


    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        self.dismiss(animated: true, completion: nil)
    }

}
extension EditCondoDocTableViewController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        arr_FileNames[textView.tag] = textView.text!
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == placeholderColor {
                textView.text = nil
            textView.textColor = textColor
            }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
               textView.text = "Enter description"
               textView.textColor = placeholderColor
           }
    }
}
