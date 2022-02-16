//
//  FeedbackDetailsTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 27/10/21.
//

import UIKit
import  DropDown

class FeedbackDetailsTableViewController:  BaseTableViewController {
    
    //Outlets
    @IBOutlet weak var lbl_UnitNo: UILabel!
    @IBOutlet weak var lbl_BookedBy: UILabel!
    @IBOutlet weak var lbl_Date: UILabel!
    @IBOutlet weak var lbl_Time: UILabel!
    @IBOutlet weak var lbl_Category: UILabel!
    @IBOutlet weak var lbl_SubmittedDate: UILabel!
    @IBOutlet weak var lbl_Subject: UILabel!
    @IBOutlet weak var txt_Message: UITextView!
    @IBOutlet weak var collection_Photo: UICollectionView!
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
    var array_Images = [String]()
    var feedback: FeedbackModal!
    var unitsData = [String: String]()
    override func viewDidLoad() {
        super.viewDidLoad()
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
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let cellWidth = 60
        let size = CGSize(width: cellWidth, height: 60)
        layout.itemSize = size
        collection_Photo.collectionViewLayout = layout
        let fname = Users.currentUser?.user?.name ?? ""
        let lname = Users.currentUser?.moreInfo?.last_name ?? ""
        self.lbl_UserName.text = "\(fname) \(lname)"
        let role = Users.currentUser?.role?.name ?? ""
        self.lbl_UserRole.text = role
        
            let toolbarDone = UIToolbar.init()
            toolbarDone.sizeToFit()
            let barBtnDone = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done,target: self, action: #selector(self.doneButtonClicked))
            barBtnDone.tintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
            let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            toolbarDone.items = [flexSpace,barBtnDone]
            self.txt_Comment.inputAccessoryView = toolbarDone
            self.txt_Message.inputAccessoryView      = toolbarDone
        self.txt_Comment.delegate = self
        self.txt_Message.delegate = self
        setUpUI()
        txt_Message.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

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
        if feedback.submissions.upload_1 != ""{
            array_Images.append(feedback.submissions.upload_1 )
        }
        if feedback.submissions.upload_2 != ""{
            array_Images.append(feedback.submissions.upload_2 )
        }
        if feedback.submissions.upload_3 != ""{
            array_Images.append(feedback.submissions.upload_3 )
        }
        if feedback.submissions.upload_4 != ""{
            array_Images.append(feedback.submissions.upload_4 )
        }
        txt_Message.text = "Enter notes"
        txt_Message.textColor = placeholderColor
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
        txt_Message.layer.cornerRadius = 20.0
        txt_Message.layer.masksToBounds = true

        for btn in arr_Buttons{
            btn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
            btn.layer.cornerRadius = 8.0
        }
        txt_Status.text = feedback.submissions.status == 0 ? "Open" :
            feedback.submissions.status == 1 ? "Closed" : "In Progress"
        lbl_BookedBy.text = feedback.user_info?.name
        lbl_UnitNo.text = unitsData["\(feedback.user_info?.unit_no ?? 0)"]
        lbl_Category.text = feedback.option?.feedback_option
        txt_Comment.text = feedback.submissions.remarks
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: feedback.submissions.created_at)
        formatter.dateFormat = "dd/MM/yy"
        let dateStr = formatter.string(from: date ?? Date())
        
        let dateUpdated = formatter.date(from: feedback.submissions.updated_at)
        let dateStrUpdated = formatter.string(from: dateUpdated ?? Date())
        lbl_Date.text = dateStr
        lbl_SubmittedDate.text = dateStrUpdated
        formatter.dateFormat = "HH:mm a"
        let timeStr = formatter.string(from: date ?? Date())
        lbl_Time.text = timeStr
        lbl_Subject.text = feedback.submissions.subject
        txt_Message.text = feedback.submissions.notes
        
           
    }
    //MARK: ******  PARSING *********
    func deletFeedback(){
       
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
     
        let id = feedback.submissions.id
        let param = [
            "login_id" : userId,
            "id" : id,
          
        ] as [String : Any]

        ApiService.delete_Feedback(parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? DeleteUserBase){
                    if response.response == 1{
                        DispatchQueue.main.async {
                            self.alertView_message.delegate = self
                            self.alertView_message.showInView(self.view_Background, title: "Feedback has been\n deleted", okTitle: "Home", cancelTitle: "View Feedbacks")
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
    func updateFeedback(){
       
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
     
        let id = feedback.submissions.id
        let param = [
            "login_id" : userId,
            "id" : id,
            "remarks": txt_Comment.text!,
            "status": txt_Status.text == "Open" ? 0 :
                txt_Status.text == "Closed" ? 1 :
            2
        ] as [String : Any]

        ApiService.update_Feedback(parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? DeleteUserBase){
                    if response.response == 1{
                        DispatchQueue.main.async {
                            self.alertView_message.delegate = self
                            self.alertView_message.showInView(self.view_Background, title: "Feedback changes\n has been saved", okTitle: "Home", cancelTitle: "View Feedbacks")
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
    @IBAction func actionStatus(_ sender:UIButton) {
       
        let dropDown_Unit = DropDown()
        dropDown_Unit.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Unit.dataSource = ["Open","In Progress","Closed"]
        dropDown_Unit.show()
        dropDown_Unit.selectionAction = { [unowned self] (index: Int, item: String) in
          
            txt_Status.text = item
        }
    }
    @IBAction func actionSave(_ sender: UIButton){
       updateFeedback()
    }
    @IBAction func actionDelete(_ sender: UIButton){
        alertView.delegate = self
        alertView.showInView(self.view_Background, title: "Are you sure you want to\n delete the following\nfeedback?", okTitle: "Yes", cancelTitle: "Back")
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


    
extension FeedbackDetailsTableViewController: AlertViewDelegate{
    func onBackClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func onCloseClicked() {
        
    }
    
    func onOkClicked() {
        deletFeedback()
    }
    
    
}
extension FeedbackDetailsTableViewController: MessageAlertViewDelegate{
    func onHomeClicked() {
        selectedRowIndex_Appointment = -1
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func onListClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
extension FeedbackDetailsTableViewController: MenuViewDelegate{
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

   
   



extension FeedbackDetailsTableViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  array_Images.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell
       
        let img = array_Images[indexPath.item]
        if let url1 = URL(string: "\(kImageFilePath)/" + img) {
          //  self.imgView_Profile.af_setImage(withURL: url1)
            cell.view_img.af_setImage(
                        withURL: url1,
                        placeholderImage: UIImage(named: "loader"),
                        filter: nil,
                        imageTransition: .crossDissolve(0.2)
                    )
        }
//        if let url = URL(string: "\(kImageFilePath)/" + img) {
//            cell.view_img.af_setImage(withURL: url)
//
//
//        }
        return cell
    }
    @IBAction func actionShowPhoto(_ sender: UIButton){
        /*
        let img = array_Images[sender.tag]
        let imgPreviewVC = self.storyboard?.instantiateViewController(withIdentifier: "PhotoViewController") as! PhotoViewController
        var selectedIndex = 0
        var arr = [String]()
        for (indx,obj) in array_Images.enumerated(){
                arr.append("\(self.filePath!)/" + obj)
                if obj == img{
                    selectedIndex = indx
                }
            }
           
        
        imgPreviewVC.arrayImages = arr//["\(self.filePath!)/" + defects.upload]
        imgPreviewVC.index = selectedIndex//sender.tag
        imgPreviewVC.modalPresentationStyle = .fullScreen
        self.present(imgPreviewVC, animated: false, completion: nil)*/
        }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
    
extension FeedbackDetailsTableViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == placeholderColor {
                textView.text = nil
                textView.textColor = textColor
            }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = textView == txt_Message ? "Enter subject" : "Enter comment"
               textView.textColor = placeholderColor
           }
    }
}
