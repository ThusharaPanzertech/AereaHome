//
//  Staff_FaceListTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 14/07/22.
//

import UIKit

class Staff_FaceListTableViewController: BaseTableViewController {
    let menu: MenuView = MenuView.getInstance

    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var imgView_Logo: UIImageView!

    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var view_Face: UIView!
    @IBOutlet weak var collection_FaceList: UICollectionView!
    @IBOutlet weak var imgView_Profile: UIImageView!
   var array_FaceIds = [FaceId]()
    var file_path = ""
    var heightSet = false
    var tableHeight: CGFloat = 0
    var isToDelete = false
    var face_id = 0
    let alertView: AlertView = AlertView.getInstance
    let alertView_message: MessageAlertView = MessageAlertView.getInstance
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let fname = Users.currentUser?.user?.name ?? ""
        let lname = Users.currentUser?.moreInfo?.last_name ?? ""
        self.lbl_UserName.text = "\(fname) \(lname)"
        let role = Users.currentUser?.role?.name ?? ""
        self.lbl_UserRole.text = role
        view_Face.layer.cornerRadius = 25.0
        view_Face.layer.masksToBounds = true
      
       
        self.setUpCollectionViewLayout()
      
       
    }
    //MARK: ******  PARSING *********
    
    func getFaceUploads(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.get_faceUploadsList(parameters: ["login_id":userId], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? FaceIdSummaryBase){
                    self.array_FaceIds = response.data
                     self.file_path = response.file_path
                     DispatchQueue.main.async {
                      
                     self.collection_FaceList.reloadData()
                    self.tableView.reloadData()
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
    func  deleteStaffFace(){
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
       
        let param = [
            "login_id" : userId,
            "id" : face_id,
          
        ] as [String : Any]

        ApiService.delete_StaffFace( parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
            self.isToDelete  = false
            if status  && result != nil{
                 if let response = (result as? DeleteUserBase){
                    if response.response == 1{
                        DispatchQueue.main.async {
                            self.alertView_message.delegate = self
                            self.alertView_message.showInView(self.view_Background, title: "Face has\n been deleted", okTitle: "Home", cancelTitle: "View Face Lists")
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
    func showDeleteAlert(){
        isToDelete = true
        alertView.delegate = self
        alertView.showInView(self.view_Background, title: "Are you sure you want to\n delete the following\n face id?", okTitle: "Yes", cancelTitle: "Back")
      
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view_Background.roundCorners(corners: [.topLeft, .topRight], radius: 25.0)
        self.tableHeight = self.collection_FaceList.contentSize.height == 0 ? self.collection_FaceList.contentSize.height + 240 : self.collection_FaceList.contentSize.height + 240
        if self.tableHeight > 240 && heightSet == false{
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.heightSet = true
        }
       }
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1{
            return tableHeight > 0 ?  tableHeight  :  super.tableView(tableView, heightForRowAt: indexPath)
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        self.showBottomMenu()
        getFaceUploads()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.closeMenu()
    }
   
    
    //MARK:UICOLLECTION VIEW LAYOUT
    func setUpCollectionViewLayout(){
       
     
        
        let layout =  UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let cellWidth = (kScreenSize.width - 50)/CGFloat(2.0)
        let size = CGSize(width: cellWidth, height: cellWidth * 1.09)
        layout.itemSize = size
        collection_FaceList.collectionViewLayout = layout
    
        self.collection_FaceList.reloadData()
        
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
   
  
    func goToSettings(){
        let settingsTVC = kStoryBoardSettings.instantiateViewController(identifier: "SettingsTableViewController") as! SettingsTableViewController
        self.navigationController?.pushViewController(settingsTVC, animated: true)
    }
    @IBAction func actionAddFace(_ sender: UIButton){
        let faceReqTVC = kStoryBoardMenu.instantiateViewController(identifier: "Face_RequirementsTableViewController") as! Face_RequirementsTableViewController
        self.navigationController?.pushViewController(faceReqTVC, animated: true)
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
    
}
extension Staff_FaceListTableViewController: MenuViewDelegate{
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
extension Staff_FaceListTableViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array_FaceIds.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "faceCell", for: indexPath) as! FaceollectionViewCell
   
        cell.view_Outer.layer.cornerRadius = 15.0

  
    
        let face = array_FaceIds[indexPath.row]
        if face.face_picture != ""{
            if let url1 = URL(string: "\(self.file_path)/" + face.face_picture) {
                cell.imgFace.af_setImage(
                            withURL: url1,
                            placeholderImage: UIImage(named: "avatar"),
                            filter: nil,
                            imageTransition: .crossDissolve(0.2)
                        )
            }
     
        }
        cell.imgFace.layer.masksToBounds = true
        cell.lbl_FaceName.text = face.name
        cell.view_Outer.tag = indexPath.item
        cell.btn_Delete.tag = indexPath.item
        cell.btn_Delete.addTarget(self, action: #selector(self.actionDelete(_:)), for: .primaryActionTriggered)
    //    let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
   //     cell.view_Outer.addGestureRecognizer(tap)

        return cell
    }
    @objc @IBAction func actionDelete(_ sender: UIButton){
        let face = array_FaceIds[sender.tag]
        face_id = face.id
        self.showDeleteAlert()
    }
//    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
//
//    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
    


extension Staff_FaceListTableViewController: AlertViewDelegate{
    func onBackClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func onCloseClicked() {
        
    }
    
    func onOkClicked() {
        if isToDelete == true{
            deleteStaffFace()
        }
    }
    
    
}
extension Staff_FaceListTableViewController: MessageAlertViewDelegate{
    func onHomeClicked() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func onListClicked() {
        self.getFaceUploads()
    }
    
    
}
