//
//  AddPropertyTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 26/09/21.
//

import UIKit

class AddPropertyTableViewController: BaseTableViewController {

    //Outlets
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var txt_PropertyName: UITextField!
    @IBOutlet weak var txt_ContactNo: UITextField!
    @IBOutlet weak var txt_Email: UITextField!
    
    @IBOutlet var arr_AddImage: [UIImageView]!
    let menu: MenuView = MenuView.getInstance
    var activeImage: UIImageView!
    var imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
     
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
    //MARK: UIButton Action
    @IBAction func actionUploadPhoto(_ sender: UIButton) {
        self.view.endEditing(true)
        self.activeImage = arr_AddImage.first(where: { $0.tag == sender.tag})
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
extension  AddPropertyTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker .dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let choosenImage = info[.editedImage] as! UIImage
       
            self.activeImage.image = choosenImage
            picker.dismiss(animated: true, completion: nil)
        
       
    }
}
extension AddPropertyTableViewController: MenuViewDelegate{
    func onMenuClicked(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            self.menu.contractMenu()
            self.navigationController?.popToRootViewController(animated: true)
            break
        case 2:
            self.actionInbox(sender)
            break
        case 3:
            self.goToSettings()
            break
        case 4:
            self.actionLogout(sender)
            break
        case 5:
            self.menu.contractMenu()
            self.actionAnnouncement(sender)
            break
        case 6:
            self.menu.contractMenu()
            self.actionAppointmemtUnitTakeOver(sender)
            break
        case 7:
            self.menu.contractMenu()
            self.actionDefectList(sender)
            break
        case 8:
            self.menu.contractMenu()
            self.actionAppointmentJointInspection(sender)
            break
        case 9:
            self.menu.contractMenu()
            self.actionFacilityBooking(sender)
            break
        case 10:
            self.menu.contractMenu()
            self.actionFeedback(sender)
            break
        default:
            break
        }
    }
    
    func onCloseClicked(_ sender: UIButton) {
        
    }
    
    
}
