//
//  AnnouncementDetailsTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 26/07/21.
//

import UIKit
import AlamofireImage
import DropDown
class AnnouncementDetailsTableViewController: BaseTableViewController {

    //Outlets
    @IBOutlet weak var view_SwitchProperty: UIView!
    @IBOutlet weak var lbl_SwitchProperty: UILabel!
    @IBOutlet weak var lbl_Subject: UILabel!
    @IBOutlet weak var lbl_Time: UILabel!
    @IBOutlet weak var lbl_Announcement: UILabel!
    @IBOutlet weak var btn_Delete: UIButton!
    @IBOutlet weak var collection_Images: UICollectionView!
    
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var view_Fields: UIView!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var imgView_Profile: UIImageView!
    var array_Images = [String]()
    let menu: MenuView = MenuView.getInstance
    let alertView_message: MessageAlertView = MessageAlertView.getInstance
    let alertView: AlertView = AlertView.getInstance
    var announcement: AnnouncementModal!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view_SwitchProperty.layer.borderColor = themeColor.cgColor
        view_SwitchProperty.layer.borderWidth = 1.0
        view_SwitchProperty.layer.cornerRadius = 10.0
        view_SwitchProperty.layer.masksToBounds = true
        lbl_SwitchProperty.text = kCurrentPropertyName
          let fname = Users.currentUser?.moreInfo?.first_name ?? ""
        let lname = Users.currentUser?.moreInfo?.last_name ?? ""
        self.lbl_UserName.text = "\(fname) \(lname)"
        let role = Users.currentUser?.role
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
        setUpUI()
       
    }
    func setUpUI(){
        lbl_Subject.text = announcement.title
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.date(from: announcement.created_at)
        formatter.dateFormat = "dd MMM yyyy"
        let dateStr = formatter.string(from: date ?? Date())
        lbl_Time.text = "Submitted on \(dateStr)"
       // lbl_Announcement.text = announcement.notes
            //"Dear OWNER,\n\n We have great news for you. The wait is finally over!\n\nYou are invited to book an appointment for the taking over of unit after you had made payment for the balance ampunt and the 6 months maintenence funds, both to made payable to the Developer's Maintenence Account.\n\nOnce Payment has been received, you will be able to book a time slot to collect the keys to your unit.\n\nWe look forward to meeting you to hand over the keys.\nMeanwhile, stay safe!\n\nSincerely,\n\nThe Management"
        
        
        let htmlData = NSString(string:announcement.notes).data(using: String.Encoding.unicode.rawValue)
         
         let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
         
         let attributedString = try! NSMutableAttributedString(data: htmlData!, options: options, documentAttributes: nil)
         
         attributedString.addAttribute(NSAttributedString.Key.font,
                                       value: UIFont(name: "Helvetica", size: 16.0)!,
                                       range: NSRange(location: 0, length: attributedString.length))
         attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                       value: UIColor.black,
                                       range: NSRange(location: 0, length: attributedString.length))
         
        
       // var height: CGFloat!
        if isValidHtmlString(announcement.notes) == true{
            lbl_Announcement.attributedText = attributedString
           // height =  attributedString.height(containerWidth: kScreenSize.width - 80)
        }
        else{
            lbl_Announcement.text = announcement.notes
         //   height = self.heightForView(text:"\(announcement.notes)", font:UIFont(name: "Lato-Regular", size: 13.0)!, width:kScreenSize.width - 170)
        }
        
        
        lbl_Announcement.layer.cornerRadius = 5.0
        lbl_Announcement.layer.masksToBounds = true
        
        array_Images = announcement.upload != "" ? [ announcement.upload] : []
            //[UIImage(named: "tile1")!, UIImage(named: "background_signin")!]
        let layout =  UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let cellWidth = 60
        let size = CGSize(width: cellWidth, height: 60)
        layout.itemSize = size
        collection_Images.collectionViewLayout = layout
        view_Background.layer.cornerRadius = 25.0
        view_Background.layer.masksToBounds = true
       // view_Background.roundCorners(corners: [.topLeft, .topRight], radius: 25.0)
        view_Fields.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
        view_Fields.layer.cornerRadius = 10.0
        btn_Delete.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
        btn_Delete.layer.cornerRadius = 8.0
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
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1{
           // let txt =  "Dear OWNER,\n\n We have great news for you. The wait is finally over!\n\nYou are invited to book an appointment for the taking over of unit after you had made payment for the balance ampunt and the 6 months maintenence funds, both to made payable to the Developer's Maintenence Account.\n\nOnce Payment has been received, you will be able to book a time slot to collect the keys to your unit.\n\nWe look forward to meeting you to hand over the keys.\nMeanwhile, stay safe!\n\nSincerely,\n\nThe Management"
            let labelHeight = self.heightForView(text:announcement.notes, font:UIFont(name: "Helvetica-Bold", size: 17.0)!, width:kScreenSize.width - 70)
            return labelHeight + 500
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
    func deletAnnouncement(){
       
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
     
        let id = announcement.id
        let param = [
            "login_id" : userId,
            "id" : id,
          
        ] as [String : Any]

        ApiService.delete_Announcement(parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? DeleteUserBase){
                    if response.response == 1{
                        DispatchQueue.main.async {
                            self.alertView_message.delegate = self
                            self.alertView_message.showInView(self.view_Background, title: "Announcement has\n been deleted", okTitle: "Home", cancelTitle: "View announcement")
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
    @IBAction func actionDelete(_ sender: UIButton){
        alertView.delegate = self
        alertView.showInView(self.view_Background, title: "Are you sure you want to\n delete the following announcement?", okTitle: "Yes", cancelTitle: "Back")
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
extension AnnouncementDetailsTableViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array_Images.count
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
       // cell.view_img.image = img
       
        return cell
    }
    @IBAction func actionShowPhoto(_ sender: UIButton){
        
       
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
extension AnnouncementDetailsTableViewController: MenuViewDelegate{
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
extension AnnouncementDetailsTableViewController: MessageAlertViewDelegate{
func onHomeClicked() {
    self.navigationController?.popToRootViewController(animated: true)
}

func onListClicked() {
    self.navigationController?.popViewController(animated: true)
}


}
extension AnnouncementDetailsTableViewController: AlertViewDelegate{
    func onBackClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func onCloseClicked() {
        
    }
    
    func onOkClicked() {
        self.deletAnnouncement()
    
    }
    
    
}
