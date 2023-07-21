//
//  ResidentFileDetailsTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 29/04/22.
//

import UIKit
import DropDown

class ResidentFileDetailsTableViewController: BaseTableViewController {

    //Outlets
    @IBOutlet weak var view_SwitchProperty: UIView!
    @IBOutlet weak var lbl_SwitchProperty: UILabel!
    @IBOutlet weak var lbl_UnitNo: UILabel!
    @IBOutlet weak var lbl_UploadBy: UILabel!
    @IBOutlet weak var lbl_UploadDate: UILabel!
    @IBOutlet weak var lbl_Category: UILabel!
    @IBOutlet weak var lbl_Message: UILabel!
   
    
    @IBOutlet weak var collection_Files: UICollectionView!
    @IBOutlet weak var txt_Status: UITextField!
    @IBOutlet weak var txt_Comment: UITextView!
    
    
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var imgView_Profile: UIImageView!
    @IBOutlet weak var view_Outer: UIView!
    @IBOutlet var arr_Buttons: [UIButton]!
    let alertView: AlertView = AlertView.getInstance
    let alertView_message: MessageAlertView = MessageAlertView.getInstance
    let menu: MenuView = MenuView.getInstance
    var unitsData = [Unit]()
    var residentFileData: ResidentFileModal!
    var array_Images = [String]()
    let documentInteractionController = UIDocumentInteractionController()
    var isToDelete = false
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
        let layout =  UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let cellWidth = (kScreenSize.width - 76)/CGFloat(3.0)
        let size = CGSize(width: cellWidth, height: 140 )
        layout.itemSize = size
        collection_Files.collectionViewLayout = layout
    
          let fname = Users.currentUser?.moreInfo?.first_name ?? ""
        let lname = Users.currentUser?.moreInfo?.last_name ?? ""
        self.lbl_UserName.text = "\(fname) \(lname)"
        let role = Users.currentUser?.role
        self.lbl_UserRole.text = role
        
            let toolbarDone = UIToolbar.init()
            toolbarDone.sizeToFit()
            let barBtnDone = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done,target: self, action: #selector(self.doneButtonClicked))
            barBtnDone.tintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
            let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            toolbarDone.items = [flexSpace,barBtnDone]
            self.txt_Comment.inputAccessoryView = toolbarDone
        self.txt_Comment.delegate = self
        setUpUI()

        txt_Comment.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

       
    }
    @objc func doneButtonClicked(){
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
    func setUpUI(){
       
        txt_Comment.text = "Enter comment"
        txt_Comment.textColor = placeholderColor
        view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
        view_Outer.layer.cornerRadius = 10.0
        txt_Status.layer.cornerRadius = 20.0
        txt_Status.layer.masksToBounds = true
        
        txt_Status.textColor = textColor
        txt_Status.attributedPlaceholder = NSAttributedString(string: txt_Status.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
        view_Background.layer.cornerRadius = 25.0
        view_Background.layer.masksToBounds = true
      
        imgView_Profile.addborder()
        txt_Comment.layer.cornerRadius = 20.0
        txt_Comment.layer.masksToBounds = true
      
        for btn in arr_Buttons{
            btn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
            btn.layer.cornerRadius = 8.0
        }
        
        lbl_UploadBy.text = residentFileData.user.name
        lbl_UnitNo.text = "#\(residentFileData.unit.unit)"
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let submission = residentFileData.submission == nil ? residentFileData.data : residentFileData.submission
        let date = formatter.date(from: submission!.created_at)
        formatter.dateFormat = "dd/MM/yy"
        let dateStr = formatter.string(from: date ?? Date())
        
       
        lbl_UploadDate.text = dateStr
        
        
        txt_Status.text = submission!.status == 0 ? "New" :
        submission!.status == 1  ? "Processing" : submission!.status == 2 ? "Processed" : ""
        lbl_Category.text = residentFileData.cat?.docs_category
        
  
        txt_Comment.text = submission!.remarks
        lbl_Message.text = submission!.notes
        
      
        
           
    }
    //MARK: ******  PARSING *********
    func deletFileUpload(){
     
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        let submission = residentFileData.submission == nil ? residentFileData.data : residentFileData.submission
        
        let id = submission!.id
        let param = [
            "login_id" : userId,
            "id" : id,
          
        ] as [String : Any]

        ApiService.delete_ResidentFileUpload(parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
            self.isToDelete = false
            if status  && result != nil{
                 if let response = (result as? DeleteUserBase){
                    if response.response == 1{
                        DispatchQueue.main.async {
                            self.alertView_message.delegate = self
                            self.alertView_message.showInView(self.view_Background, title: "File Upload has been\n deleted", okTitle: "Home", cancelTitle: "View Uploads")
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
    func updateStatus(){
       
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        let submission = residentFileData.submission == nil ? residentFileData.data : residentFileData.submission
        
        let id = submission!.id
        let param = [
            "login_id" : userId,
            "id" : id,
            "remarks": txt_Comment.text!,
            "status": txt_Status.text == "New" ? 0 :
                txt_Status.text == "Processing" ? 1 :
            2
        ] as [String : Any]
       
        ApiService.update_ResidentFileUpload(parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? DeleteUserBase){
                    if response.response == 1{
                        DispatchQueue.main.async {
                            self.alertView_message.delegate = self
                            self.alertView_message.showInView(self.view_Background, title: "Resident file upload changes have been saved", okTitle: "Home", cancelTitle: "View Resident file Uploads")
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
    

    //MARK: UIButton Action
    @IBAction func actionBackPressed(_ sender: UIButton){
        self.view.endEditing(true)
        alertView.delegate = self
        alertView.showInView(self.view_Background, title: "Are you sure you want to\n leave this page?\nYour changes would not\n be saved.",okTitle: "Yes", cancelTitle: "Back")
    }
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
    @IBAction func actionStatus(_ sender:UIButton) {
       
        let dropDown_Unit = DropDown()
        dropDown_Unit.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Unit.dataSource = ["New","Processing","Processed"]
        dropDown_Unit.show()
        dropDown_Unit.selectionAction = { [unowned self] (index: Int, item: String) in
          
            txt_Status.text = item
        }
    }
    @IBAction func actionSave(_ sender: UIButton){
       updateStatus()
    }
    @IBAction func actionDelete(_ sender: UIButton){
        isToDelete = true
        alertView.delegate = self
        alertView.showInView(self.view_Background, title: "Are you sure you want to\n delete the following\nfile upload?", okTitle: "Yes", cancelTitle: "Back")
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


    
extension ResidentFileDetailsTableViewController: AlertViewDelegate{
    func onOkClicked() {
        if isToDelete == true{
            deletFileUpload()
        }
        else{
            self.navigationController?.popViewController(animated: true)
            
        }
    }
    
    func onCloseClicked() {
        
    }
    
    func onBackClicked() {
        
    }
    
    
}
extension ResidentFileDetailsTableViewController: MessageAlertViewDelegate{
    func onHomeClicked() {
        selectedRowIndex_Appointment = -1
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func onListClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
extension ResidentFileDetailsTableViewController: MenuViewDelegate{
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

   
   



extension ResidentFileDetailsTableViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return residentFileData.files.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "documentCell", for: indexPath) as! DocumentCollectionViewCell
       
        let file = residentFileData.files[indexPath.item]
        cell.lbl_DocumentName.text = file.docs_file_name
        cell.view_Outer.tag = indexPath.item
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        cell.view_Outer.addGestureRecognizer(tap)
       
        return cell
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        let file = residentFileData.files[(sender! as UITapGestureRecognizer).view!.tag]
        var filename =  ""
        let arr1 = file.docs_file_name.components(separatedBy: ".")
        if arr1.count > 1{
           
            filename = "\(file.docs_file_name)"
        }
        else{
            let arr = file.docs_file.components(separatedBy: ".")
            let file_extension = arr.count > 0 ? ".\(String(describing: arr.last!))" : ""
            filename = "\(file.docs_file_name)\(file_extension)"
        }
        
        
        let urlString =  "\(kImageFilePath)" +  file.docs_file
        guard let url = URL(string: urlString) else { return }
        ActivityIndicatorView.show("Loading")
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            let tmpURL = FileManager.default.temporaryDirectory
                .appendingPathComponent(filename)
            //(response?.suggestedFilename ?? "fileName.csv")
            do {
                try data.write(to: tmpURL)
                DispatchQueue.main.async {
                    self.share(url: tmpURL)
                }
            } catch {
                ActivityIndicatorView.hiding()
                print(error)
            }

        }.resume()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
       func share(url: URL) {
        ActivityIndicatorView.hiding()
           documentInteractionController.url = url
           documentInteractionController.uti = url.typeIdentifier ?? "public.data, public.content"
           documentInteractionController.name = url.localizedName ?? url.lastPathComponent
            documentInteractionController.delegate = self
           documentInteractionController.presentOptionsMenu(from: view.frame, in: view, animated: true)
       }
}
    
extension ResidentFileDetailsTableViewController: UIDocumentInteractionControllerDelegate{
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController
    {
        UINavigationBar.appearance().tintColor = UIColor.white
        return self
    }
   
    func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController) {
          //  documentInteractionController = nil
       }
}
extension ResidentFileDetailsTableViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == placeholderColor {
                textView.text = nil
                textView.textColor = textColor
            }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter comment"
               textView.textColor = placeholderColor
           }
    }
}
