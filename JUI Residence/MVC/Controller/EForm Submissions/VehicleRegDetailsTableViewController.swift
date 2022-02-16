//
//  VehicleRegDetailsTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 11/02/22.
//

import UIKit
import DropDown
class VehicleRegDetailsTableViewController: BaseTableViewController {
    let documentInteractionController = UIDocumentInteractionController()
    //Outlets
    var isToDelete = false
    let alertView: AlertView = AlertView.getInstance
    let alertView_message: MessageAlertView = MessageAlertView.getInstance
    let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
    @IBOutlet weak var ht_Collection: NSLayoutConstraint!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var imgView_Profile: UIImageView!
    @IBOutlet weak var lbl_Ticket: UILabel!
    @IBOutlet weak var lbl_SubmittedDate: UILabel!
    @IBOutlet weak var lbl_OwnerName: UILabel!
    @IBOutlet weak var lbl_UnitNo: UILabel!
    @IBOutlet weak var lbl_ContactNo: UILabel!
    @IBOutlet weak var lbl_Email: UILabel!
    @IBOutlet weak var lbl_RegisteredOwner: UILabel!
    @IBOutlet weak var lbl_LicensePlateNo: UILabel!
    @IBOutlet weak var lbl_IULabelNo: UILabel!
    @IBOutlet weak var lbl_DeclaredBy: UILabel!
    @IBOutlet weak var lbl_PersonInCharge: UILabel!
    @IBOutlet weak var lbl_PassportNo: UILabel!
    @IBOutlet weak var lbl_NomineeContact: UILabel!
    @IBOutlet weak var lbl_NomineeEmail: UILabel!
    @IBOutlet weak var lbl_TenancyPeriod: UILabel!
    @IBOutlet weak var lbl_NomRegisteredOwner: UILabel!
    @IBOutlet weak var lbl_NomLicensePlateNo: UILabel!
    @IBOutlet weak var lbl_NomIULabelNo: UILabel!
    
    @IBOutlet weak var collection_Files: UICollectionView!
    @IBOutlet weak var imgView_OwnerSign: UIImageView!
    @IBOutlet weak var imgView_NomineeSign: UIImageView!

    
    
    
    @IBOutlet weak var txt_Status: UITextField!
    @IBOutlet weak var txtView_Remarks: UITextView!
   
    @IBOutlet  var arr_Btns: [UIButton]!
    let menu: MenuView = MenuView.getInstance

    var vehicleRegData: VehicleReg!
   
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
        txtView_Remarks.layer.cornerRadius = 15
        txtView_Remarks.layer.masksToBounds = true
        //ToolBar
          let toolbar = UIToolbar();
          toolbar.sizeToFit()
          let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([spaceButton,doneButton], animated: false)
        txtView_Remarks.inputAccessoryView = toolbar
        if vehicleRegData.submission.remarks != ""{
            txtView_Remarks.text = vehicleRegData.submission.remarks
            txtView_Remarks.textColor =
                textColor
        }
        else{
            txtView_Remarks.text = "Enter Remarks"
            txtView_Remarks.textColor = placeholderColor
        }
        txtView_Remarks.delegate = self
        
      
        setUpUI()
        let fname = Users.currentUser?.user?.name ?? ""
        let lname = Users.currentUser?.moreInfo?.last_name ?? ""
        self.lbl_UserName.text = "\(fname) \(lname)"
        let role = Users.currentUser?.role?.name ?? ""
        self.lbl_UserRole.text = role
        txt_Status.text = vehicleRegData.submission.status == 0 ? "New" :
            vehicleRegData.submission.status == 1 ? "Cancelled" :
            vehicleRegData.submission.status == 2 ? "In Progress" :
            vehicleRegData.submission.status == 3 ? "Approved" :
            vehicleRegData.submission.status == 4 ? "Rejected" :
            vehicleRegData.submission.status == 5 ? "Payment Pending" :
            vehicleRegData.submission.status == 6 ? "Refunded" : ""
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
       
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let moving_date = formatter.date(from: vehicleRegData.submission.request_date)
        let tenancy_start = formatter.date(from: vehicleRegData.submission.tenancy_start)
        let tenancy_end = formatter.date(from: vehicleRegData.submission.tenancy_end)
       
        formatter.dateFormat = "dd/MM/yyyy"
        let moving_dateStr = formatter.string(from: moving_date ?? Date())
        let tenancy_startStr = formatter.string(from: tenancy_start ?? Date())
        let tenancy_endStr = formatter.string(from: tenancy_end ?? Date())
      
        
        lbl_Ticket.text = vehicleRegData.submission.ticket
        lbl_SubmittedDate.text = moving_dateStr
        lbl_OwnerName.text = vehicleRegData.submission.owner_name
        lbl_UnitNo.text = vehicleRegData.unit.unit
        lbl_ContactNo.text = vehicleRegData.submission.contact_no
        lbl_Email.text = vehicleRegData.submission.email
        
        lbl_RegisteredOwner.text = vehicleRegData.submission.owner_of_vehicle
        lbl_LicensePlateNo.text = vehicleRegData.submission.licence_no
        lbl_IULabelNo.text = vehicleRegData.submission.iu_number
        lbl_NomineeContact.text = vehicleRegData.submission.nominee_contact_no
        lbl_NomineeEmail.text = vehicleRegData.submission.nominee_email
       
        lbl_NomRegisteredOwner.text = vehicleRegData.submission.owner_of_nominee_vehicle
        lbl_NomLicensePlateNo.text = vehicleRegData.submission.nominee_vehicle_licence_no
        lbl_NomIULabelNo.text = vehicleRegData.submission.nominee_vehicle_iu_number
       
        
        
        
        
        lbl_DeclaredBy.text = vehicleRegData.submission.declared_by
        lbl_PassportNo.text = vehicleRegData.submission.passport_no
        lbl_PersonInCharge.text = vehicleRegData.submission.in_charge_name
        lbl_TenancyPeriod.text = "\(tenancy_startStr) - \(tenancy_endStr)"
       
        
        
        let sign1 = vehicleRegData.submission.owner_signature
//        if let url1 = URL(string: "\(kImageFilePath)/" + sign1) {
//            self.imgView_OwnerSign.af_setImage(
//                        withURL: url1,
//                        placeholderImage: nil,
//                        filter: nil,
//                        imageTransition: .crossDissolve(0.2)
//                    )
//        }
       let image = self.convertBase64StringToImage(imageBase64String: sign1)
       if image != nil{
        self.imgView_OwnerSign.image = image
        }
        
        
        let sign2 = vehicleRegData.submission.owner_signature
//        if let url2 = URL(string: "\(kImageFilePath)/" + sign2) {
//            self.imgView_NomineeSign.af_setImage(
//                        withURL: url2,
//                        placeholderImage: nil,
//                        filter: nil,
//                        imageTransition: .crossDissolve(0.2)
//                    )
//        }
        let image1 = self.convertBase64StringToImage(imageBase64String: sign2)
        if image1 != nil{
         self.imgView_NomineeSign.image = image1
         }
        
        
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
        self.showBottomMenu()
        
        let layout =  UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let cellWidth = (kScreenSize.width - 70)/CGFloat(3.0)
        let size = CGSize(width: cellWidth, height: 140 )
        layout.itemSize = size
        collection_Files.collectionViewLayout = layout
    
        self.collection_Files.reloadData()
    }
  
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.closeMenu()
    }
    
    @objc func done(){
        self.view.endEditing(true)
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0

    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1{
            let rowCount = vehicleRegData.documents.count / 3 + vehicleRegData.documents.count % 3
            
            ht_Collection.constant = CGFloat(140 * rowCount) + 10

            return CGFloat(140 * rowCount) + 1425
           
        }
       
        return super.tableView(tableView, heightForRowAt: indexPath)
    
    }
    func showBottomMenu(){
    
    menu.delegate = self
    menu.showInView(self.view, title: "", message: "")
  
}
func closeMenu(){
    menu.removeView()
}
    func setUpUI(){
       
        
        txt_Status.layer.cornerRadius = 20.0
        txt_Status.layer.masksToBounds = true
        view_Background.layer.cornerRadius = 25.0
        view_Background.layer.masksToBounds = true
      
        imgView_Profile.addborder()
       
        for btn in arr_Btns{
            btn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
          
            btn.layer.cornerRadius = 10.0 }
       
    }
    //MARK: ***************  PARSING ***************
    func  deleteVehicleReg(){
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
       
        let param = [
            "login_id" : userId,
            "id" : vehicleRegData.submission.id,
          
        ] as [String : Any]

        ApiService.delete_EForm(formType: eForm.vehicleReg, parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
            self.isToDelete  = false
            if status  && result != nil{
                 if let response = (result as? DeleteUserBase){
                    if response.response == 1{
                        DispatchQueue.main.async {
                            self.alertView_message.delegate = self
                            self.alertView_message.showInView(self.view_Background, title: "Vehicle IU Registration\n Application has been deleted", okTitle: "Home", cancelTitle: "View Summary")
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
    func  updateVehicleReg(){
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
       
        let param = [
            "login_id" : userId,
            "id" : vehicleRegData.submission.id,
            "remarks": txtView_Remarks.text!,
            "status":  txt_Status.text ==  "New" ? 0 :
                txt_Status.text ==  "Cancelled" ? 1 :
                txt_Status.text ==  "In Progress" ? 2 :
                txt_Status.text ==  "Approved" ? 3 :
                txt_Status.text ==  "Rejected" ? 4 : 0
               
          
        ] as [String : Any]

        ApiService.update_EForm(formType: .vehicleReg, parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
            self.isToDelete  = false
            if status  && result != nil{
                 if let response = (result as? DeleteUserBase){
                    if response.response == 1{
                        DispatchQueue.main.async {
                            self.alertView_message.delegate = self
                            self.alertView_message.showInView(self.view_Background, title: "Vehicle IU Registration\n Application has been updated", okTitle: "Home", cancelTitle: "View Summary")
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

   
    //MARK: UIBUTTON ACTION
    @IBAction func actionStatus(_ sender:UIButton) {
        
        let arrStatus = [ "New", "Approved", "In Progress", "Cancelled", "Rejected"]
        let dropDown_Status = DropDown()
        dropDown_Status.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Status.dataSource = arrStatus//statusData.map({$0.value})//Array(statusData.values)
        dropDown_Status.show()
        dropDown_Status.selectionAction = { [unowned self] (index: Int, item: String) in
            txt_Status.text = item
           
            
        }
    }
    @IBAction func actionUpdate(_ sender:UIButton) {
        if txt_Status.text == ""{
            self.displayErrorAlert(alertStr: "Please enter status", title: "")
        }
        else if txtView_Remarks.textColor == placeholderColor{
            self.displayErrorAlert(alertStr: "Please enter management remarks", title: "")
        }
        else{
            self.updateVehicleReg()
        }
    }
    @IBAction func actionDelete(_ sender: UIButton){
        showDeleteAlert()
        
    }
    func showDeleteAlert(){
        isToDelete = true
        alertView.delegate = self
        alertView.showInView(self.view_Background, title: "Are you sure you want to\n delete the following\n vehicle IU registration application?", okTitle: "Yes", cancelTitle: "Back")
      
    }
    
    //MARK: MENU ACTIONS
    
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

extension VehicleRegDetailsTableViewController: MenuViewDelegate{
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

   
   



extension VehicleRegDetailsTableViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
       
            
        
    }
}
extension VehicleRegDetailsTableViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == placeholderColor {
                textView.text = nil
            textView.textColor = textColor
            }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
               textView.text = "Enter Remarks"
               textView.textColor = placeholderColor
           }
    }
}
extension VehicleRegDetailsTableViewController: AlertViewDelegate{
    func onBackClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func onCloseClicked() {
        
    }
    
    func onOkClicked() {
        if isToDelete == true{
            deleteVehicleReg()
        }
    }
    
    
}
extension VehicleRegDetailsTableViewController: MessageAlertViewDelegate{
    func onHomeClicked() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func onListClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
extension VehicleRegDetailsTableViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vehicleRegData.documents.count
        
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "docCell", for: indexPath) as! DocumentCollectionViewCell
        let file = self.vehicleRegData.documents[indexPath.item]
        let arr1 = file.file_original.components(separatedBy: ".")
        if arr1.count > 1{
           
            cell.lbl_DocumentName.text = "\(file.file_original)"
        }
        else{
            let arr = file.file_original.components(separatedBy: ".")
            let file_extension = arr.count > 0 ? ".\(String(describing: arr.last!))" : ""
            cell.lbl_DocumentName.text = "\(file.file_original)\(file_extension)"
        }
        cell.view_Outer.tag = indexPath.item
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        cell.view_Outer.addGestureRecognizer(tap)
        
        return cell
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        let file = vehicleRegData.documents[(sender! as UITapGestureRecognizer).view!.tag]
        var filename =  ""
        let arr1 = file.file_original.components(separatedBy: ".")
        if arr1.count > 1{
           
            filename = "\(file.file_original)"
        }
        else{
            let arr = file.file_original.components(separatedBy: ".")
            let file_extension = arr.count > 0 ? ".\(String(describing: arr.last!))" : ""
            filename = "\(file.file_original)\(file_extension)"
        }
        
        
        let urlString =  "\(kImageFilePath)" +  file.file_original
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
extension VehicleRegDetailsTableViewController: UIDocumentInteractionControllerDelegate{
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController
    {
        UINavigationBar.appearance().tintColor = UIColor.white
        return self
    }
   
    func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController) {
          //  documentInteractionController = nil
       }
}
extension URL {
    var typeIdentifier: String? {
        return (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
    }
    var localizedName: String? {
        return (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName
    }
}
