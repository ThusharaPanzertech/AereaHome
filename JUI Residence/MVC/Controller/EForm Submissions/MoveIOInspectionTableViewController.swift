//
//  MoveIOInspectionTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 15/02/22.
//

import UIKit
import DropDown
var arr_DamageDesc : [[String: Any]] = [[kId: "", kDesc:"", kImage: ""]]
class MoveIOInspectionTableViewController:  BaseTableViewController {
   
    var eForm : String!
    let menu: MenuView = MenuView.getInstance
    var isToShowSucces = false
     //Outlets
    @IBOutlet weak var view_SwitchProperty: UIView!
    @IBOutlet weak var lbl_SwitchProperty: UILabel!
    @IBOutlet weak var datePicker:  UIDatePicker!
     @IBOutlet weak var lbl_UserName: UILabel!
     @IBOutlet weak var lbl_UserRole: UILabel!
     @IBOutlet weak var lbl_Title: UILabel!
     @IBOutlet weak var lbl_SubTitle: UILabel!
    @IBOutlet weak var lbl_SuccessTitle: UILabel!
    @IBOutlet weak var lbl_SuccessSubTitle: UILabel!
     @IBOutlet weak var btn_Next: UIButton!
     @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var view_Background1: UIView!
     @IBOutlet weak var imgView_Profile: UIImageView!
    @IBOutlet var arr_Buttons: [UIButton]!
    @IBOutlet var arr_Views: [UIView]!
    @IBOutlet var arr_TextFields: [UITextField]!
    @IBOutlet var arr_AmtTextFields: [UITextField]!
    @IBOutlet var arr_AmtLabels: [UILabel]!
    
    @IBOutlet weak var txt_Management: UITextField!
    @IBOutlet weak var txt_ActualDate: UITextField!
    @IBOutlet weak var txt_UnitInspection: UITextField!
    @IBOutlet weak var btn_UnitInOrder: UIButton!
    
  //  @IBOutlet weak var txt_OwnerName: UITextField!
    @IBOutlet weak var btn_NotInOrder: UIButton!
    @IBOutlet weak var txt_AmtDeducted: UITextField!
    @IBOutlet weak var txt_AmtBalance: UITextField!
 //   @IBOutlet weak var txt_ReceivedBy: UITextField!
 //   @IBOutlet weak var txt_NRIC1: UITextField!
    @IBOutlet weak var txt_AmtClaimable: UITextField!
    @IBOutlet weak var txt_AmtRecvd: UITextField!
    @IBOutlet weak var txt_AcknowledgeBy: UITextField!
    @IBOutlet weak var txt_NRIC1: UITextField!
    
    
    @IBOutlet weak var table_Ht: NSLayoutConstraint!
    @IBOutlet weak var table_Damages: UITableView!
    var dataSource = DataSource_MoveIOInspection()
    //@IBOutlet weak var txt_SignDate: UITextField!
    @IBOutlet weak var imgView_signature1 : UIImageView!
 //   @IBOutlet weak var imgView_signature2 : UIImageView!
 //   @IBOutlet weak var imgView_signature3 : UIImageView!
    @IBOutlet weak var imgView_signature4 : UIImageView!
  
    let view_Signature: SignatureView = SignatureView.getInstance
    var signature_management : UIImage!
    var signature_owner1 : UIImage!
//    var signature_owner2 : UIImage!
//    var signature_owner3 : UIImage!
    var moveInOutData: MoveInOut!
    var renovationData: Renovation!
    var formType : eForm!
    
    
     override func viewDidLoad() {
         super.viewDidLoad()
        arr_DamageDesc.removeAll()
         
         arr_DamageDesc =   [[kId: "", kDesc:"", kImage: ""]]
        self.configureDatePicker()
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([spaceButton,doneButton], animated: false)
    //    txtView_Address.inputAccessoryView = toolbar
       
        table_Damages.dataSource = dataSource
        table_Damages.delegate = dataSource
        dataSource.parentVc = self
        self.table_Damages.reloadData()
        self.tableView.reloadData()
         lbl_SwitchProperty.text = kCurrentPropertyName
     //   lbl_SuccessTitle.text = "Change of Mailing\nAddress Application\nhas been submitted"
     //   lbl_SuccessSubTitle.text = "Your form has been submitted and we \nwill get back to you on the status of the\napplication"
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
        for btn in arr_Buttons{
            btn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
            btn.layer.cornerRadius = 8.0
        }
         view_Background.layer.cornerRadius = 25.0
         view_Background.layer.masksToBounds = true
        view_Background1.layer.cornerRadius = 25.0
        view_Background1.layer.masksToBounds = true
        
         view_SwitchProperty.layer.borderColor = themeColor.cgColor
         view_SwitchProperty.layer.borderWidth = 1.0
         view_SwitchProperty.layer.cornerRadius = 10.0
         view_SwitchProperty.layer.masksToBounds = true
        self.lbl_Title.text = formType == .moveInOut ? "Moving In & Out Application" : "Renovation Work Application"
        self.lbl_SubTitle.text =  formType == .moveInOut ? "(For official use only - for inspection after moving work)" : "(For official use only - for inspection after renovation work)"
        
        
        for vw in arr_Views{
            vw.layer.cornerRadius = 20.0
            vw.layer.masksToBounds = true
        }
        
        for field in arr_TextFields{
            field.layer.cornerRadius = 20.0
               field.layer.masksToBounds = true
            field.delegate = self
               field.textColor = UIColor(red: 93/255, green: 93/255, blue: 93/255, alpha: 1.0)
               field.attributedPlaceholder = NSAttributedString(string: field.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
               field.backgroundColor = UIColor(red: 208/255, green: 208/255, blue: 208/255, alpha: 1.0)
        }
       
        self.tableView.reloadData()
     }
   
    @objc func done(){self.view.endEditing(true)
    }

    func configureDatePicker(){
      //Formate Date
       datePicker.datePickerMode = .date
        
        // Get right now as it's `DateComponents`.
        let now = Calendar.current.dateComponents(in: .current, from: Date())

        // Create the start of the day in `DateComponents` by leaving off the time.
        let today = DateComponents(year: now.year, month: now.month, day: now.day)
        let dateToday = Calendar.current.date(from: today)!

       
        
        
        datePicker.minimumDate = Date()
      
        //ToolBar
          let toolbar = UIToolbar();
          toolbar.sizeToFit()
          let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
         let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)

   // add toolbar to textField
        txt_ActualDate.inputAccessoryView = toolbar
    // add datepicker to textField
        txt_ActualDate.inputView = datePicker

      }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "dd/MM/yy"
        txt_ActualDate.text = formatter.string(from: datePicker.date)
            self.view.endEditing(true)
        
      
        
    }

    @objc func cancelDatePicker(){
       self.view.endEditing(true)
     }
     override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1{
            table_Ht.constant =  CGFloat( 330 * arr_DamageDesc.count)
            return CGFloat(self.isToShowSucces == true ? 0 :   1580 + 330 * arr_DamageDesc.count)
        }
        else  if indexPath.row == 2{
            return self.isToShowSucces == false ? 0 : super.tableView(tableView, heightForRowAt: indexPath)
        }
     
       return super.tableView(tableView, heightForRowAt: indexPath)
    }
     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         self.showBottomMenu()
        if formType == .moveInOut{
        if moveInOutData.inspection != nil{
            self.txt_Management.text = moveInOutData.inspection.manager_received
            
            self.txt_UnitInspection.text = moveInOutData.inspection.inspected_by
            
            if moveInOutData.inspection.unit_in_order_or_not == 1{
                self.btn_UnitInOrder.isSelected = true
                for field in arr_AmtTextFields{
                    field.isEnabled = false
                    field.alpha = 0.7
                }
                for field in arr_AmtLabels{
                    field.isEnabled = false
                    field.alpha = 0.7
                }
            }
            else if moveInOutData.inspection.unit_in_order_or_not == 2{
                self.btn_NotInOrder.isSelected = true
                for field in arr_AmtTextFields{
                    field.isEnabled = true
                    field.alpha = 1
                }
                for field in arr_AmtLabels{
                    field.isEnabled = true
                    field.alpha = 1
                }
            }
            
            //self.txt_ReceivedBy.text = moveInOutData.inspection.amount_received_by
            self.txt_AmtDeducted.text = moveInOutData.inspection.amount_deducted
            self.txt_AmtBalance.text = moveInOutData.inspection.refunded_amount
          //  self.txt_OwnerName.text = moveInOutData.inspection.amount_received_by
            self.txt_NRIC1.text = moveInOutData.inspection.resident_nric
            self.txt_AmtClaimable.text = moveInOutData.inspection.amount_claimable
            self.txt_AmtRecvd.text = moveInOutData.inspection.actual_amount_received
            self.txt_AcknowledgeBy.text = moveInOutData.inspection.acknowledged_by
         //   self.txt_NRIC2.text = moveInOutData.inspection.resident_nric
           
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd"
            let moving_date = formatter.date(from:moveInOutData.inspection.date_of_completion)
            formatter.dateFormat = "dd/MM/yy"
                let moving_dateStr = formatter.string(from: moving_date ?? Date())
            self.txt_ActualDate.text = moving_dateStr
            
            let sign1 = self.moveInOutData.inspection.manager_signature
            let image = self.convertBase64StringToImage(imageBase64String: sign1)
            if image != nil{
             self.imgView_signature1.image = image
                signature_management = image
             }
            let sign2 = self.moveInOutData.inspection.resident_signature
            let image1 = self.convertBase64StringToImage(imageBase64String: sign2)
            if image1 != nil{
             self.imgView_signature4.image = image1
                signature_owner1 = image1
             }
            arr_DamageDesc.removeAll()
            for obj in moveInOutData.defects{
                let image = self.convertBase64StringToImage(imageBase64String: obj.image_base64)
                let damage = [kId: "\(obj.id)",kDesc:obj.notes, kImage: image ?? UIImage(named: "add_photo")!] as [String : Any]
                arr_DamageDesc.append(damage)
                
            }
            if arr_DamageDesc.count == 0{
                arr_DamageDesc = [[kId: "",kDesc:"", kImage: ""]]
            }
            
            self.table_Damages.reloadData()
        }
        }
        
        else  if formType == .renovation{
            if renovationData.inspection != nil{
                self.txt_Management.text = renovationData.inspection.manager_received
                self.txt_ActualDate.text = renovationData.inspection.date_of_completion
                self.txt_UnitInspection.text = renovationData.inspection.inspected_by
                
                if renovationData.inspection.unit_in_order_or_not == 1{
                    self.btn_UnitInOrder.isSelected = true
                    for field in arr_AmtTextFields{
                        field.isEnabled = false
                        field.alpha = 0.7
                    }
                    for field in arr_AmtLabels{
                        field.isEnabled = false
                        field.alpha = 0.7
                    }
                }
                else if renovationData.inspection.unit_in_order_or_not == 2{
                    self.btn_NotInOrder.isSelected = true
                    for field in arr_AmtTextFields{
                        field.isEnabled = true
                        field.alpha = 1
                    }
                    for field in arr_AmtLabels{
                        field.isEnabled = true
                        field.alpha = 1
                    }
                }
                
                //self.txt_ReceivedBy.text = moveInOutData.inspection.amount_received_by
                self.txt_AmtDeducted.text = renovationData.inspection.amount_deducted
                self.txt_AmtBalance.text = renovationData.inspection.refunded_amount
              //  self.txt_OwnerName.text = moveInOutData.inspection.amount_received_by
                self.txt_NRIC1.text = renovationData.inspection.resident_nric
                self.txt_AmtClaimable.text = renovationData.inspection.amount_claimable
                self.txt_AmtRecvd.text = renovationData.inspection.actual_amount_received
                self.txt_AcknowledgeBy.text = renovationData.inspection.acknowledged_by
             //   self.txt_NRIC2.text = moveInOutData.inspection.resident_nric
               
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.dateFormat = "yyyy-MM-dd"
                let moving_date = formatter.date(from:renovationData.inspection.date_of_completion)
                formatter.dateFormat = "dd/MM/yy"
                    let moving_dateStr = formatter.string(from: moving_date ?? Date())
                self.txt_ActualDate.text = moving_dateStr
                
                let sign1 = self.renovationData.inspection.manager_signature
                let image = self.convertBase64StringToImage(imageBase64String: sign1)
                if image != nil{
                 self.imgView_signature1.image = image
                    signature_management = image
                 }
                let sign2 = self.renovationData.inspection.resident_signature
                let image1 = self.convertBase64StringToImage(imageBase64String: sign2)
                if image1 != nil{
                 self.imgView_signature4.image = image1
                    signature_owner1 = image1
                 }
                arr_DamageDesc.removeAll()
                for obj in renovationData.defects{
                    let image = self.convertBase64StringToImage(imageBase64String: obj.image_base64)
                    let damage = [kId: "\(obj.id)",kDesc:obj.notes, kImage: image ?? UIImage(named: "add_photo")!] as [String : Any]
                    arr_DamageDesc.append(damage)
                    
                }
                if arr_DamageDesc.count == 0{
                    arr_DamageDesc = [[kId: "",kDesc:"", kImage: ""]]
                }
                
                self.table_Damages.reloadData()
               
            }
          
            }
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

     override func getBackgroundImageName() -> String {
         let imgdefault = ""//UserInfoModalBase.currentUser?.data.property.defect_bg ?? ""
         return imgdefault
     }
     //MARK: ******  PARSING *********
    func submitAppication(){
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd/MM/yy"
       
        let moving_date = formatter.date(from:txt_ActualDate.text!)
        formatter.dateFormat = "yyyy-MM-dd"
            let moving_dateStr = formatter.string(from: moving_date ?? Date())
        let today_dateStr = formatter.string(from: Date())
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
       
        let params = NSMutableDictionary()
        params.setValue("\(userId)", forKey: "login_id")
        if formType == .moveInOut{
        params.setValue("\(moveInOutData.submission.id)", forKey: "id")
        if moveInOutData.inspection != nil{
            params.setValue("\(moveInOutData.inspection.id)", forKey: "inspection_id")
        }
        }
        else  if formType == .renovation{
            params.setValue("\(renovationData.submission.id)", forKey: "id")
            if renovationData.inspection != nil{
                params.setValue("\(renovationData.inspection.id)", forKey: "inspection_id")
            }
            }
      
        params.setValue(moving_dateStr, forKey: "date_of_completion")
        params.setValue(txt_UnitInspection.text!, forKey: "inspected_by")
        params.setValue(btn_UnitInOrder.isSelected ? "1" : "2", forKey: "unit_in_order_or_not")
        params.setValue(txt_AmtDeducted.text!, forKey: "amount_deducted")
        params.setValue(txt_AmtBalance.text!, forKey: "refunded_amount")
        params.setValue(txt_AmtClaimable.text!, forKey: "amount_claimable")
        params.setValue(txt_AmtRecvd.text!, forKey: "actual_amount_received")
        params.setValue(txt_AcknowledgeBy.text!, forKey: "acknowledged_by")
        params.setValue(txt_NRIC1.text!, forKey: "resident_nric")
        params.setValue(today_dateStr, forKey: "resident_signature_date")
       
        params.setValue(txt_Management.text!, forKey: "manager_received")
        params.setValue(today_dateStr, forKey: "date_of_signature")
       
       
        var arrData = [[String:Any]]()
     if signature_management != nil{
         arrData.append(["name":"manager_signature","image":(signature_management.jpegData(compressionQuality: 0.5)! as NSData) as Data])
        
     }
        if signature_owner1 != nil{
            
            arrData.append(["name":"resident_signature","image":(signature_owner1.jpegData(compressionQuality: 0.5)! as NSData) as Data])
        }
        for (indx, obj) in arr_DamageDesc.enumerated(){
            params.setValue(obj[kDesc], forKey: "description_\(indx + 1)")
            if obj[kId] as! String != ""{
                params.setValue(obj[kId], forKey: "file_id_\(indx + 1)")
            }
            arrData.append(["name":"file_\(indx + 1)","image":((obj[kImage] as! UIImage).jpegData(compressionQuality: 0.5)! as NSData) as Data])
        }
        
       
        if formType == .moveInOut{
        
        
        ApiService.submit_MoveIOInspection(files: arrData, parameters: params as! [String : Any]) {  status, result, error in
          
        
      
                   
                    ActivityIndicatorView.hiding()
                    if status  && result != nil{
                        if let response = (result as? MoveIOInspectionBase){
                            if response.response == 1{
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
                    else if error != nil{
                        self.displayErrorAlert(alertStr: "\(error!.localizedDescription)", title: "Alert")
                    }
                    else{
                        self.displayErrorAlert(alertStr: "Something went wrong.Please try again", title: "Alert")
                    }
                }
        }
        else if formType == .renovation{
            ApiService.submit_RenovationInspection(files: arrData, parameters: params as! [String : Any]) {  status, result, error in
              
            
          
                       
                        ActivityIndicatorView.hiding()
                        if status  && result != nil{
                            if let response = (result as? RenovationInspectionBase){
                                if response.response == 1{
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
                        else if error != nil{
                            self.displayErrorAlert(alertStr: "\(error!.localizedDescription)", title: "Alert")
                        }
                        else{
                            self.displayErrorAlert(alertStr: "Something went wrong.Please try again", title: "Alert")
                        }
                    }
        }
        
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
    @IBAction func actionAddNew(_ sender: UIButton){
        let new_Defect  = [kId: "", kDesc:"", kImage: ""]
        arr_DamageDesc.append(new_Defect)
        //self.dataSource.array_Defects = self.array_Defects
        table_Damages.reloadData()
        self.tableView.reloadData()
    }
    @IBAction func actionHome(_ sender: UIButton){
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func actionSubmittedForms(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionSign1(_ sender: UIButton){
        self.view_Signature.delegate = self
        let name = sender.tag == 1 ? txt_Management.text :
           
            txt_AcknowledgeBy.text
        self.view_Signature.showInView(self.view, parent:self, tag: sender.tag, name: name ?? "")
       
        
    }
    @IBAction func actionOrder(_ sender: UIButton){
        if sender.tag == 1{
            btn_UnitInOrder.isSelected = true
            btn_NotInOrder.isSelected = false
            for field in arr_AmtTextFields{
                field.isEnabled = false
                field.alpha = 0.7
            }
            for field in arr_AmtLabels{
                field.isEnabled = false
                field.alpha = 0.7
            }
        }
        else{
            btn_UnitInOrder.isSelected = false
            btn_NotInOrder.isSelected = true
            for field in arr_AmtTextFields{
                field.isEnabled = true
                field.alpha = 1
            }
            for field in arr_AmtLabels{
                field.isEnabled = true
                field.alpha = 1
            }
        }
        
    }
    @IBAction func actionSubmit(_sender: UIButton){
       

         
        
        guard txt_Management.text!.count  > 0 else {
            displayErrorAlert(alertStr: "Please enter name of management received", title: "")
            return
        }
        guard txt_ActualDate.text!.count  > 0 else {
            displayErrorAlert(alertStr: "Please enter actual date of completion", title: "")
            return
        }
        guard txt_UnitInspection.text!.count  > 0 else {
            displayErrorAlert(alertStr: "Please enter unit inspection", title: "")
            return
        }
        
    guard signature_management != nil else {
        displayErrorAlert(alertStr: "Please provide the management signature", title: "")
        return
    }
    
    
//        guard txt_ReceivedBy.text!.count  > 0 else {
//            displayErrorAlert(alertStr: "Please enter the name of owner", title: "")
//            return
//        }
        
  
        if btn_UnitInOrder.isSelected == false && btn_NotInOrder.isSelected == false{
            displayErrorAlert(alertStr: "Please select unit in order or not", title: "")
            return
        }
        if btn_NotInOrder.isSelected == true{
        guard txt_AmtDeducted.text!.count  > 0 else {
            displayErrorAlert(alertStr: "Please enter the amount deducted from deposit", title: "")
            return
        }
        guard txt_AmtBalance.text!.count  > 0 else {
            displayErrorAlert(alertStr: "Please enter the amount balance to be refunded", title: "")
            return
        }
            guard txt_AmtClaimable.text!.count  > 0 else {
                displayErrorAlert(alertStr: "Please enter the amount claimable", title: "")
                return
            }
            guard txt_AmtRecvd.text!.count  > 0 else {
                displayErrorAlert(alertStr: "Please enter the actual amount received", title: "")
                return
            }
        }
        guard txt_NRIC1.text!.count  > 0 else {
            displayErrorAlert(alertStr: "Please enter the PP/NRIC of owner", title: "")
            return
        }
       
      
      
        guard txt_AcknowledgeBy.text!.count  > 0 else {
            displayErrorAlert(alertStr: "Please enter acknowledge by name of owner", title: "")
            return
        }
        guard signature_owner1 != nil else {
            displayErrorAlert(alertStr: "Please provide the owner signature", title: "")
            return
        }
        var flag = false
        var msg = ""
        for obj in arr_DamageDesc{
            if obj[kDesc] as? String == "" || obj[kImage] as? UIImage == nil{
                flag = true
                msg = obj[kDesc] as? String == "" ? "Please enter the remarks" : "Please upload the image"
                break
                
            }
        }
        if flag == true{
            displayErrorAlert(alertStr: msg, title: "")
            return
        }
        else{
       
      submitAppication()
        }
        
 
    }
    //MARK: MENU ACTIONS
    
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




extension MoveIOInspectionTableViewController:SignatureViewDelegate{
    func onDoneClicked(image: UIImage, name: String, signView: SignatureView) {
        if signView.tag == 1{
            self.signature_management = image
            self.imgView_signature1.image = image
        }
        else if signView.tag == 2{
            self.signature_owner1 = image
            self.imgView_signature4.image = image
        }
//        else if signView.tag == 3{
//            self.signature_owner2 = image
//            self.imgView_signature3.image = image
//        }
//        else if signView.tag == 4{
//            self.signature_owner3 = image
//            self.imgView_signature4.image = image
//        }
        else{
            
        }
       
    }
    
    
}
extension MoveIOInspectionTableViewController: AlertViewDelegate{
    func onBackClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func onCloseClicked() {
        
    }
    
    func onOkClicked() {
       
    }
    
    
}

extension MoveIOInspectionTableViewController: MessageAlertViewDelegate{
    func onHomeClicked() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func onListClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
extension MoveIOInspectionTableViewController: MenuViewDelegate{
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
extension MoveIOInspectionTableViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
       
            
        
    }
}

class DataSource_MoveIOInspection: NSObject, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    var parentVc: UIViewController!
    var imagePicker = UIImagePickerController()
 var pickerIndex = 0
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1;
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return  arr_DamageDesc.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "inspectionCell") as! EFormInspectionTableViewCell
       
        cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
        //dropShadow()
        cell.view_Outer.tag = indexPath.row
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        cell.view_Outer.addGestureRecognizer(tap)
        cell.txt_Remarks.tag = indexPath.row
        let damage = arr_DamageDesc[indexPath.row]
        if damage[kDesc] as! String != ""{
            cell.txt_Remarks.text =  damage[kDesc] as? String
            cell.txt_Remarks.textColor = textColor
        }
        else{
            cell.txt_Remarks.textColor = placeholderColor
        }
        
        if damage[kImage] as? UIImage != nil{
            cell.img_Defect.image =  damage[kImage] as? UIImage
        }
        else{
        }
        
       
        cell.txt_Remarks.delegate = self
        cell.view_Outer.addGestureRecognizer(tap)
        cell.lbl_Indx.text = "\(indexPath.row + 1)"
        //ToolBar
          let toolbar = UIToolbar();
          toolbar.sizeToFit()
          let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([spaceButton,doneButton], animated: false)
        cell.txt_Remarks.inputAccessoryView = toolbar
        cell.selectionStyle = .none
       
        cell.btn_Close.tag = indexPath.row
        cell.btn_Close.addTarget(self, action: #selector(self.actionClose(_:)), for: .touchUpInside)
        
        cell.btn_AddImage.tag = indexPath.row
        cell.btn_AddImage.addTarget(self, action: #selector(self.actionUploadPhoto(_:)), for: .touchUpInside)
      
        
       
            return cell
      
    }
    @objc func done(){
        self.parentVc.view.endEditing(true)
    }
    @IBAction func actionUploadPhoto(_ sender: UIButton) {
        self.parentVc.view.endEditing(true)
        self.pickerIndex = sender.tag
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

        self.parentVc.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    @IBAction func actionClose(_ sender: UIButton){
       
        arr_DamageDesc.remove(at: sender.tag)
        DispatchQueue.main.async {
            (self.parentVc as! MoveIOInspectionTableViewController).table_Damages.reloadData()
            (self.parentVc as! MoveIOInspectionTableViewController).tableView.reloadData()
            
        }
        
    }
    
    //MARK: Open Camera / Gallery
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            self.parentVc.present(imagePicker, animated: true, completion: nil)
        }
        else{
            self.parentVc.displayErrorAlert(alertStr: "You don't have camera", title: "")
        }
    }
    
    func openPhotoLibrary(){
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        self.parentVc.present(imagePicker, animated: true, completion: nil)
    }
    func dismissPicker(){
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 330
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
       

    }
    func textViewDidChange(_ textView: UITextView) {
        var damage = arr_DamageDesc[textView.tag]
        damage[kDesc] = textView.text!
        arr_DamageDesc[textView.tag] = damage
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == placeholderColor {
                textView.text = nil
            textView.textColor = textColor
            }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
               textView.text = "Enter remarks"
               textView.textColor = placeholderColor
           }
    }
    
}

extension  DataSource_MoveIOInspection: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker .dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let choosenImage = info[.editedImage] as! UIImage
        var damage = arr_DamageDesc[pickerIndex]
        damage[kImage] = choosenImage
        arr_DamageDesc[pickerIndex] = damage
        (self.parentVc as! MoveIOInspectionTableViewController).table_Damages.reloadData()
            
            picker.dismiss(animated: true, completion: nil)
        
       
    }
}
