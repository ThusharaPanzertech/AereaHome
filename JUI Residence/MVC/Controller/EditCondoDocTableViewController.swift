//
//  EditCondoDocTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 27/12/21.
//

import UIKit

class EditCondoDocTableViewController: BaseTableViewController {
    let menu: MenuView = MenuView.getInstance
    @IBOutlet weak var spaceContraint: NSLayoutConstraint!
    @IBOutlet weak var txt_CategoryName: UITextField!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var view_Footer: UIView!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var imgView_Profile: UIImageView!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var collection_CondoDoc: UICollectionView!
    @IBOutlet var arr_Buttons: [UIButton]!
    var isToAdd: Bool!
    let alertView: AlertView = AlertView.getInstance
    let alertView_message: MessageAlertView = MessageAlertView.getInstance
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
        let fname = Users.currentUser?.user?.name ?? ""
        let lname = Users.currentUser?.moreInfo?.last_name ?? ""
        self.lbl_UserName.text = "\(fname) \(lname)"
        let role = Users.currentUser?.role?.name ?? ""
        self.lbl_UserRole.text = role
        setUpUI()
        setUpCollectionViewLayout()
    }
    func setUpUI(){
        if isToAdd == true{
            spaceContraint.constant = 50
            txt_CategoryName.backgroundColor = UIColor(red: 208/255, green: 208/255, blue: 208/255, alpha: 1.0)
            arr_Buttons[1].isHidden = true
            arr_Buttons[0].setTitle("Upload", for: .normal)
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
    //MARK: UIBUTTON ACTIONS
    @IBAction func actionBackPressed(_ sender: UIButton){
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
        alertView_message.delegate = self
        alertView_message.showInView(self.view, title: "Document changes\n has been saved", okTitle: "Home", cancelTitle: "View Condo Documents")
        }
        else{
            alertView_message.delegate = self
            alertView_message.showInView(self.view, title: "Condo Document has\nbeen uploaded", okTitle: "Home", cancelTitle: "View Condo Documents")
        }
    }
    @IBAction func actionDelete(_ sender: UIButton){
        alertView.delegate = self
        alertView.showInView(self.view_Background, title: "Are you sure you want to\n delete the following\n condo document?", okTitle: "Yes", cancelTitle: "Back")
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
extension EditCondoDocTableViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "documentCell", for: indexPath) as! DocumentCollectionViewCell
        cell.view_Outer.layer.cornerRadius = 6.0
        cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.gray, radius: 3.0, opacity: 0.35)
        cell.lbl_Index.text = "\(indexPath.item + 1)"
        cell.view_Outer.tag = indexPath.item
       // cell.btn_Icon.tag = indexPath.item
       // cell.btn_Icon.addTarget(self, action: #selector(HomeTableViewController.actionIcon(_:)), for: .primaryActionTriggered)
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
extension EditCondoDocTableViewController: AlertViewDelegate{
    func onBackClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func onCloseClicked() {
        
    }
    
    func onOkClicked() {
        if isToAdd == true{
            self.navigationController?.popViewController(animated: true)
        }
        else{
        alertView_message.delegate = self
        alertView_message.showInView(self.view_Background, title: "Condo document\nhas been deleted", okTitle: "Home", cancelTitle: "View Condo Documentts")
        }
       
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

