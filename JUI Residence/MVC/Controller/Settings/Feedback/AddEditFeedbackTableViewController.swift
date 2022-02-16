//
//  AddEditFeedbackTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 27/09/21.
//

import UIKit

class AddEditFeedbackTableViewController: BaseTableViewController {
    
    //Outlets
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var txt_FeedbackOption: UITextField!
    @IBOutlet weak var lbl_MsgTitle: UILabel!
    @IBOutlet weak var lbl_MsgDesc: UILabel!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var imgView_Profile: UIImageView!
    @IBOutlet weak var btn_Submit: UIButton!
    @IBOutlet weak var btn_Delete: UIButton!
    @IBOutlet  var arr_Btns: [UIButton]!
    @IBOutlet weak var bottomSpace: NSLayoutConstraint!
    var option: FeedbackOption!
    var isToDelete = false
    var isToEdit: Bool!
    let alertView: AlertView = AlertView.getInstance
    let alertView_message: MessageAlertView = MessageAlertView.getInstance
    let menu: MenuView = MenuView.getInstance
    var isToShowSucces = false
    override func viewDidLoad() {
        super.viewDidLoad()
        lbl_MsgTitle.text = "Feedback Option\n Added"
        lbl_MsgDesc.text = "The requested feedback option has\n been added into the list."
        let fname = Users.currentUser?.user?.name ?? ""
        let lname = Users.currentUser?.moreInfo?.last_name ?? ""
        self.lbl_UserName.text = "\(fname) \(lname)"
        let role = Users.currentUser?.role?.name ?? ""
        self.lbl_UserRole.text = role
        imgView_Profile.addborder()
        for btn in arr_Btns{
            btn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
            btn.layer.cornerRadius = 8.0
        }
        txt_FeedbackOption.layer.cornerRadius = 20.0
        txt_FeedbackOption.layer.masksToBounds = true
        txt_FeedbackOption.delegate = self
        txt_FeedbackOption.textColor = textColor
        txt_FeedbackOption.attributedPlaceholder = NSAttributedString(string: txt_FeedbackOption.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
        txt_FeedbackOption.backgroundColor = isToEdit ? UIColor.white : UIColor(red: 208/255, green: 208/255, blue: 208/255, alpha: 1.0)
        
        
        if self.option != nil{
            self.txt_FeedbackOption.text = option.feedback_option
           
            btn_Delete.isHidden = false
            btn_Submit.setTitle("Save", for: .normal)
        }
        else{
            btn_Delete.isHidden = true
            btn_Submit.setTitle("Submit", for: .normal)
            bottomSpace.constant = 40
        }
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        self.showBottomMenu()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.closeMenu()
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1{
            return self.isToShowSucces == true ? 0 : kScreenSize.height - 220
        }
        else  if indexPath.row == 2{
            return self.isToShowSucces == false ? 0 : kScreenSize.height - 210
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
    
    //MARK: ***************  PARSING ***************
    func createFeedbackOption(){
       ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
       
        let param = [
            "login_id" : userId,
            "feedback_option" : txt_FeedbackOption.text!
            
        ] as [String : Any]

        ApiService.create_FeedbackOption(parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? CreateFeedbackOptionBase){
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
        })
    }
    func updateFeedbackOption(){
       ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
       
        let param = [
            "login_id" : userId,
            "feedback_option" : txt_FeedbackOption.text!,
            "id" : "\(self.option.id)"
        ] as [String : Any]

        ApiService.update_FeedbackOption(parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? CreateFeedbackOptionBase){
                    if response.response == 1{
                        self.alertView_message.delegate = self
                        self.alertView_message.showInView(self.view_Background, title: "Feedback Options\n changes has been\n saved", okTitle: "Home", cancelTitle: "View Feedback Options")
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
    
    func deleteFeedbackOption(){
       
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
       
        let param = [
            "login_id" : userId,
            "id" : self.option.id,
          
        ] as [String : Any]

        ApiService.delete_FeedbackOption(parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
            self.isToDelete  = false
            if status  && result != nil{
                 if let response = (result as? DeleteUserBase){
                    if response.response == 1{
                        DispatchQueue.main.async {
                            self.alertView_message.delegate = self
                            self.alertView_message.showInView(self.view_Background, title: "Feedback Option has\n been deleted", okTitle: "Home", cancelTitle: "View Feedback Options")
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
 
    //MARK: BUTTON ACTIONS
    @IBAction func actionDelete(_ sender: UIButton){
        showDeleteAlert()
        
    }
    func showDeleteAlert(){
        isToDelete = true
        alertView.delegate = self
        alertView.showInView(self.view_Background, title: "Are you sure you want to\n delete the following\n feedback option?", okTitle: "Yes", cancelTitle: "Back")
      
    }
    @IBAction func actionCreateRole(_ sender: UIButton){
        let feedbackoption = txt_FeedbackOption.text?.replacingOccurrences(of: " ", with: "")
        if txt_FeedbackOption.text == ""{
            displayErrorAlert(alertStr: "Please enter feedback option", title: "")
        }
        else if feedbackoption == ""{
            displayErrorAlert(alertStr: "Please enter a valid feedback option", title: "")
        }
        
        else{
            if isToEdit == true {
                updateFeedbackOption()
            }
            else{
                self.createFeedbackOption()
            }
            
        }
    }
    @IBAction func actionBackPressed(_ sender: UIButton){
        if isToEdit{
            self.navigationController?.popViewController(animated: true)
        }
        else{
        alertView.delegate = self
        alertView.showInView(self.view_Background, title: "Are you sure you want to\n leave this page?\nYour changes would not\n be saved.", okTitle: "Back", cancelTitle: "Yes")
        }
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
extension AddEditFeedbackTableViewController: MenuViewDelegate{
    func onMenuClicked(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            self.menu.contractMenu()
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
extension AddEditFeedbackTableViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
       
        return true
    }
   
}
extension AddEditFeedbackTableViewController: AlertViewDelegate{
    func onBackClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func onCloseClicked() {
        
    }
    
    func onOkClicked() {
        if isToDelete == true{
        deleteFeedbackOption()
        }
    }
    
    
}
extension AddEditFeedbackTableViewController: MessageAlertViewDelegate{
    func onHomeClicked() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func onListClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
