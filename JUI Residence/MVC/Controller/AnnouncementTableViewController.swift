//
//  AnnouncementTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 26/07/21.
//

import UIKit
import DropDown
class AnnouncementTableViewController: BaseTableViewController {
    //Outlets
    var selectedIndexes = [Int]()
    @IBOutlet weak var txt_Group: UITextField!
    @IBOutlet weak var txt_Subject: UITextView!
    @IBOutlet weak var txt_Message: UITextView!
    @IBOutlet weak var collection_Images: UICollectionView!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var view_Fields: UIView!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var view_Background1: UIView!
    @IBOutlet var arr_Buttons: [UIButton]!
    @IBOutlet weak var view_Photo: UIView!
    @IBOutlet weak var imgView_Profile: UIImageView!
    var array_Images = [UIImage]()
    let menu: MenuView = MenuView.getInstance
    var imagePicker = UIImagePickerController()
    var isToShowSucces = false
    let alertView: AlertView = AlertView.getInstance
    var roles = [String: String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        let fname = Users.currentUser?.user?.name ?? ""
        let lname = Users.currentUser?.moreInfo?.last_name ?? ""
        self.lbl_UserName.text = "\(fname) \(lname)"
        let role = Users.currentUser?.role?.name ?? ""
        self.lbl_UserRole.text = role
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
    }
    func setUpUI(){
        let toolbarDone = UIToolbar.init()
        toolbarDone.sizeToFit()
        let barBtnDone = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done,target: self, action: #selector(self.doneButtonClicked))
        barBtnDone.tintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbarDone.items = [flexSpace,barBtnDone]
        self.txt_Subject.inputAccessoryView = toolbarDone
        self.txt_Message.inputAccessoryView      = toolbarDone
        txt_Message.layer.masksToBounds = true
        txt_Message.layer.cornerRadius = 10.0
        txt_Message.text = "Enter additional notes"
        txt_Message.textColor = placeholderColor
        txt_Message.delegate = self
        txt_Group.textColor = textColor
        txt_Group.attributedPlaceholder = NSAttributedString(string: txt_Group.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
        txt_Subject.layer.masksToBounds = true
        txt_Subject.layer.cornerRadius = 10.0
        txt_Subject.text = "Enter file title"
        txt_Subject.textColor = placeholderColor
        txt_Subject.delegate = self
        txt_Message.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

        txt_Subject.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

        view_Photo.layer.masksToBounds = true
        view_Photo.layer.cornerRadius = 10.0
        txt_Group.layer.cornerRadius = 20.0
        txt_Group.layer.masksToBounds = true
        let layout =  UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let cellWidth = 60
        let size = CGSize(width: cellWidth, height: 60)
        layout.itemSize = size
        collection_Images.collectionViewLayout = layout
        
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
        imgView_Profile.addborder()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      //  self.getDefectsList()
        self.showBottomMenu()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.closeMenu()
    }
    @objc func doneButtonClicked(){
        self.view.endEditing(true)
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
            return self.isToShowSucces == true ? 0 : super.tableView(tableView, heightForRowAt: indexPath)
        }
        else  if indexPath.row == 2{
            return self.isToShowSucces == false ? 0 : kScreenSize.height - 180
        }
       
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    //MARK: UIBUTTON ACTIONS
    @IBAction func actionRoles(_ sender:UIButton) {
        let sortedArray = roles.sorted { $0.key < $1.key }
        let arrRoles = sortedArray.map { $0.value }
        let dropDown_Roles = DropDown()
        dropDown_Roles.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Roles.dataSource = arrRoles//Array(roles.values)
        dropDown_Roles.showFooter = true
        dropDown_Roles.show()
       
        dropDown_Roles.dismissMode = .automatic
        dropDown_Roles.multiSelectionAction = { [unowned self] (indexes: [Int], items: [String]) in
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
            txt_Group.text = roles
        }
        dropDown_Roles.selectRows(at:Set(selectedIndexes))
    }
    func action(){
        
    }
    @IBAction func actionSubmit(_ sender: UIButton){
        self.view.endEditing(true)
        guard txt_Group.text!.count  > 0 else {
            displayErrorAlert(alertStr: "Please select the groups", title: "")
            return
        }
        guard  txt_Subject.textColor != placeholderColor else {
            displayErrorAlert(alertStr: "Please enter the subject", title: "")
            return
        }
        guard txt_Message.textColor != placeholderColor else {
            displayErrorAlert(alertStr: "Please enter the notes", title: "")
            return
        }
        self.createAnnouncement()
    }
    //MARK: ******  PARSING *********
    func createAnnouncement(){
        var imageFiles = [Data]()
        for img in self.array_Images
        {
            let imgData = img.jpegData(compressionQuality: 0.5)! as NSData
            imageFiles.append(imgData as Data)
        }
        ActivityIndicatorView.show("Loading")
        
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        var role_IdArr = [String]()
        for obj in self.selectedIndexes{
            let key = Array(roles)[obj].key
            role_IdArr.append(key)
        }
        let  role_Id = role_IdArr.joined(separator: ",")
//        if let roleId = roles.first(where: { $0.value == txt_Group.text })?.key {
//            role_Id = roleId
//        }
        ApiService.create_Announcement(parameters: ["login_id":userId, "role_array[0]":role_Id, "title": txt_Subject.text!,"notes": txt_Message.text! ], files: imageFiles, completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? CreateAnnouncementBase){
                   
                    DispatchQueue.main.async {
                        if response.response == true{
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
        }
            else if error != nil{
                self.displayErrorAlert(alertStr: "\(error!.localizedDescription)", title: "Alert")
            }
            else{
                self.displayErrorAlert(alertStr: "Something went wrong.Please try again", title: "Alert")
            }
        })
    }
    @IBAction func actionHome(_ sender: UIButton){
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    @IBAction func actionBackPressed(_ sender: UIButton){
        alertView.delegate = self
        alertView.showInView(self.view_Background, title: "Are you sure you want to\n leave this page?\nYour changes would not\n be saved.", okTitle: "Back", cancelTitle: "Yes")
    }
    @IBAction func actionUploadPhoto(_ sender: UIButton) {
        self.view.endEditing(true)
        let alert = UIAlertController(title: "Photo Upload", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default , handler:{ (UIAlertAction)in
            self.openPhotoLibrary()
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .default , handler:{ (UIAlertAction)in
            self.dismissPicker()
        }))
        
        //uncomment for iPad Support
        //alert.popoverPresentationController?.sourceView = self.view

        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    func dismissPicker(){
        imagePicker.dismiss(animated: true, completion: nil)
    }
    //MARK: Open Camera / Gallery
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            self.displayErrorAlert(alertStr: "You don't have camera", title: "")
        }
    }
    
    func openPhotoLibrary(){
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
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
       
        self.navigationController?.popViewController(animated: true)
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
extension AnnouncementTableViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell
        if indexPath.row < array_Images.count{
        let img = array_Images[indexPath.item]
        cell.view_img.image = img
        }
        else{
            cell.view_img.image = UIImage(named: "add_photo")
            cell.btn_img.addTarget(self, action:  #selector(self.actionUploadPhoto(_:)), for: .primaryActionTriggered)
//            let tap = UITapGestureRecognizer(target: self, action: #selector(self.actionUploadPhoto(_:)))
//            cell.view_img.addGestureRecognizer(tap)
            
        }
        return cell
    }
    @IBAction func actionShowPhoto(_ sender: UIButton){
        
       
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
    
extension  AnnouncementTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker .dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let choosenImage = info[.editedImage] as! UIImage
        self.array_Images.append(choosenImage)
        self.collection_Images.reloadData()
        let item = self.collectionView(self.collection_Images, numberOfItemsInSection: 0) - 1
        let lastItemIndex = IndexPath(item: item, section: 0)
        self.collection_Images.scrollToItem(at: lastItemIndex, at: .top, animated: true)
        picker.dismiss(animated: true, completion: nil)
        
       
    }
}
extension AnnouncementTableViewController: MenuViewDelegate{
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
extension AnnouncementTableViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == placeholderColor {
                textView.text = nil
                textView.textColor = textColor
            }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = textView == txt_Subject ? "Enter file title" : "Enter additional notes"
               textView.textColor = placeholderColor
           }
    }
}
extension AnnouncementTableViewController: AlertViewDelegate{
    func onBackClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func onCloseClicked() {
        
    }
    
    func onOkClicked() {
       
    }
    
    
}
