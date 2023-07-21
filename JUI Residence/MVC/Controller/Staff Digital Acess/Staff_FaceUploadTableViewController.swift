//
//  Staff_FaceUploadTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 20/07/22.
//

import UIKit
import DropDown
class Staff_FaceUploadTableViewController:  BaseTableViewController {
    let menu: MenuView = MenuView.getInstance
    let alertView_upload: UploadOptionsView = UploadOptionsView.getInstance
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var imgView_Face: UIImageView!
    @IBOutlet weak var view_SwitchProperty: UIView!
    @IBOutlet weak var lbl_SwitchProperty: UILabel!
    
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var imgView_Profile: UIImageView!
    @IBOutlet weak var btn_Upload: UIButton!
    
    var imagePicker = UIImagePickerController()
    var image_Face: UIImage!
    var faceAdded = false
    override func viewDidLoad() {
        super.viewDidLoad()
        view_SwitchProperty.layer.borderColor = themeColor.cgColor
        view_SwitchProperty.layer.borderWidth = 1.0
        view_SwitchProperty.layer.cornerRadius = 10.0
        view_SwitchProperty.layer.masksToBounds = true
        lbl_SwitchProperty.text = kCurrentPropertyName
        imgView_Profile.addborder()
        let profilePic = Users.currentUser?.moreInfo?.profile_picture ?? ""
        if let url1 = URL(string: "\(kImageFilePath)/" + profilePic) {
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
      
      
        btn_Upload.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
        btn_Upload.layer.cornerRadius = 8.0
      
        if image_Face != nil{
            self.imgView_Face.image = image_Face
            faceAdded = true
        }
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view_Background.roundCorners(corners: [.topLeft, .topRight], radius: 25.0)
    }
    //MARK: ******  PARSING *********

    func updateFaceImage(){
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
       
        let params = NSMutableDictionary()
        params.setValue("\(userId)", forKey: "login_id")
        params.setValue("\(userId)", forKey: "user_id")
        params.setValue("1", forKey: "option")
        
       
    
        
        
        ApiService.upload_StaffFace_With(face: self.imgView_Face.image!.jpegData(compressionQuality: 0.5)! as NSData as Data, parameters: params as! [String : Any], completion: { status, result, error in
            
       
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                if let responseBase = (result as? SignatureUpdateModal){
                    if responseBase.response == 1{
                        let alert = UIAlertController(title: "Face updated successfully", message: "", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                            var controller: UIViewController!
                            for cntroller in self.navigationController!.viewControllers as Array {
                                if cntroller.isKind(of: Staff_FaceListTableViewController.self) {
                                    controller = cntroller
                                    break
                                }
                            }
                            if controller != nil{
                                self.navigationController!.popToViewController(controller, animated: true)
                            }
                            else{
                                self.navigationController?.popViewController(animated: true)
                            }
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                   
                    else{
                        self.displayErrorAlert(alertStr: "", title: responseBase.message)
                    }
                }
        }
            else if error != nil{
                self.displayErrorAlert(alertStr: "\(error!.localizedDescription)", title: "Oops")
            }
            else{
                self.displayErrorAlert(alertStr: "Something went wrong.Please try again", title: "Oops")
            }
        })
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        self.showBottomMenu()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.closeMenu()
    }
   
    
  
    override func getBackgroundImageName() -> String {
        let imgdefault = ""
        return imgdefault
    }
    func showBottomMenu(){
        
        menu.delegate = self
        menu.showInView(self.view, title: "", message: "")
    }
    func closeMenu(){
        menu.removeView()
    }
   
    //MARK: UIButton Action
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
    @IBAction func actionNext(_ sender: UIButton){
        if faceAdded == true{
        self.updateFaceImage()
        }
        else{
            self.displayErrorAlert(alertStr: "Please upload a face to continue", title: "")
        }
    }
    @IBAction func actionUpload(_ sender:UIButton) {
        DispatchQueue.main.async {
            self.alertView_upload.delegate = self
            self.alertView_upload.showInView(self.view_Background)
        }
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
        let settingsTVC = kStoryBoardSettings.instantiateViewController(identifier: "SettingsTableViewController") as! SettingsTableViewController
        self.navigationController?.pushViewController(settingsTVC, animated: true)
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
    
}
extension Staff_FaceUploadTableViewController: MenuViewDelegate{
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




extension  Staff_FaceUploadTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker .dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let choosenImage = info[.editedImage] as! UIImage
        self.imgView_Face.image = choosenImage
        picker.dismiss(animated: true, completion: nil)
        
       
    }
}
extension Staff_FaceUploadTableViewController: UploadOptionsViewDelegate{
    func onCameraClicked() {
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
    
    func onGalleryClicked() {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
}
