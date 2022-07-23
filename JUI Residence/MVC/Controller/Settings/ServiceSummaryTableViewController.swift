//
//  ServiceSummaryTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 26/09/21.
//

import UIKit

class ServiceSummaryTableViewController: BaseTableViewController {
    
    //  var array_Property = [UserModal]()
    
      let menu: MenuView = MenuView.getInstance
      var dataSource = DataSource_ServiceSummary()
      var heightSet = false
      var tableHeight: CGFloat = 0
      var arr_FeedbackOptions = [FeedbackOption]()
      var arr_DefectLocation = [DefectLocation]()
      var arr_FaciltyType = [FacilityType]()
      //Outlets
   
    var service: ServiceType!
      @IBOutlet weak var table_FeedbackOptions: UITableView!
      @IBOutlet weak var lbl_UserName: UILabel!
      @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var lbl_Title: UILabel!
      @IBOutlet weak var view_Background: UIView!
      @IBOutlet weak var view_Footer: UIView!
     
      @IBOutlet weak var imgView_Profile: UIImageView!
    var unitsData = [Unit]()
      override func viewDidLoad() {
          super.viewDidLoad()
        lbl_Title.text = service == .feedbackOptions ? "Feedback Options" :
            service == .defectsLocation ? "Defect Location" :
        "Facility Type"
          let fname = Users.currentUser?.user?.name ?? ""
          let lname = Users.currentUser?.moreInfo?.last_name ?? ""
          self.lbl_UserName.text = "\(fname) \(lname)"
          let role = Users.currentUser?.role?.name ?? ""
          self.lbl_UserRole.text = role
          imgView_Profile.addborder()
        dataSource.service = self.service
        table_FeedbackOptions.dataSource = dataSource
        table_FeedbackOptions.delegate = dataSource
          dataSource.parentVc = self
        table_FeedbackOptions.reloadData()
          UITextField.appearance().attributedPlaceholder = NSAttributedString(string: UITextField().placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])

        
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
          view_Background.layer.cornerRadius = 25.0
          view_Background.layer.masksToBounds = true
          
         
      }

      override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
          return view_Footer
      }
      override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
          return 150

      }

      override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          if indexPath.row == 1{
            let count = service == .feedbackOptions ? arr_FeedbackOptions.count :
                service == .facilityType ? arr_FaciltyType.count :
                arr_DefectLocation.count
            return service == .facilityType ?  CGFloat(175 * count) + 130 : CGFloat(100 * count) + 130
             
          }
          return super.tableView(tableView, heightForRowAt: indexPath)
      }
      override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
        if service == .feedbackOptions{
        getFeedbackOptions()
        }
        else  if service == .facilityType{
            getFacilityTypes()
        }
       
        else{
            self.getDefectLocation()
        }
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
      override func getBackgroundImageName() -> String {
          let imgdefault = ""//UserInfoModalBase.currentUser?.data.property.defect_bg ?? ""
          return imgdefault
      }
      //MARK: ******  PARSING *********
      
      func getFeedbackOptions(){
          ActivityIndicatorView.show("Loading")
          let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
          //
          ApiService.get_FeedbackOptionsSummary(parameters: ["login_id":userId], completion: { status, result, error in
             
              ActivityIndicatorView.hiding()
              if status  && result != nil{
                   if let response = (result as? FeedbackOptionSummaryBase){
                      self.arr_FeedbackOptions = response.data
                      self.dataSource.arr_FeedbackOptions = response.data
                     
                      self.table_FeedbackOptions.reloadData()
                      self.tableView.reloadData()
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
    func getDefectLocation(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.get_DefectsLocationSummary(parameters: ["login_id":userId], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? DefectLocationSummaryBase){
                    self.arr_DefectLocation = response.data
                    self.dataSource.arr_DefectLocation = response.data
                   
                    self.table_FeedbackOptions.reloadData()
                    self.tableView.reloadData()
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
    func getFacilityTypes(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.get_FacilityTypeSummary(parameters: ["login_id":userId], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? FacilityTypeSummaryBase){
                    self.arr_FaciltyType = response.data
                    self.dataSource.arr_FaciltyType = response.data
                   
                    self.table_FeedbackOptions.reloadData()
                    self.tableView.reloadData()
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
    
      @IBAction func actionAddNew(_ sender: UIButton){
        if service == .feedbackOptions{
        let addeditOptionVC = kStoryBoardSettings.instantiateViewController(identifier: "AddEditFeedbackTableViewController") as! AddEditFeedbackTableViewController
        addeditOptionVC.isToEdit = false
        self.navigationController?.pushViewController(addeditOptionVC, animated: true)
        }
        else  if service == .facilityType{
            let addeditOptionVC = kStoryBoardSettings.instantiateViewController(identifier: "AddEditFacilityTableViewController") as! AddEditFacilityTableViewController
            addeditOptionVC.isToEdit = false
            self.navigationController?.pushViewController(addeditOptionVC, animated: true)
        }
        else{
            let addeditOptionVC = kStoryBoardSettings.instantiateViewController(identifier: "AddEditDefectsLocationTableViewController") as! AddEditDefectsLocationTableViewController
            addeditOptionVC.isToEdit = false
            self.navigationController?.pushViewController(addeditOptionVC, animated: true)
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
  class DataSource_ServiceSummary: NSObject, UITableViewDataSource, UITableViewDelegate {
      var parentVc: UIViewController!
      var propertyInfo : PropertyInfo!
      var filePath = ""
    var arr_FeedbackOptions = [FeedbackOption]()
    var arr_DefectLocation = [DefectLocation]()
    var arr_FaciltyType = [FacilityType]()
    var service: ServiceType!
      func numberOfSectionsInTableView(tableView: UITableView) -> Int {

          return 1;
      }

       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  service == .feedbackOptions ?  arr_FeedbackOptions.count :
            service == .facilityType ? arr_FaciltyType.count :
            arr_DefectLocation.count
      }

      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if service == .facilityType{
            let cell = tableView.dequeueReusableCell(withIdentifier: "facilityCell") as! FacilityTypeTableViewCell
            cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
            //dropShadow()
            cell.view_Outer.tag = indexPath.row
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            cell.view_Outer.addGestureRecognizer(tap)
            let facility = arr_FaciltyType[indexPath.row]
            cell.lbl_NextBooking.text =  facility.next_booking_allowed == 1 ? "None" :
                facility.next_booking_allowed == 2 ? "Month" :
            "Days"
            cell.lbl_Facility.text  = facility.facility_type
            cell.lbl_BookingAvailable.text = "\(facility.allowed_booking_for)"
          cell.view_Outer.addGestureRecognizer(tap)
          cell.btn_Edit.tag = indexPath.row
          cell.btn_Edit.addTarget(self, action: #selector(self.actionEdit(_:)), for: .touchUpInside)
         
            cell.selectionStyle = .none
           
            
            return cell
             
        }
        else{
        let cell = tableView.dequeueReusableCell(withIdentifier: "roleCell") as! RoleTableViewCell
         
          cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
          //dropShadow()
          cell.view_Outer.tag = indexPath.row
          let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
          cell.view_Outer.addGestureRecognizer(tap)
          
        cell.lbl_Title.text = service == .feedbackOptions ? "Feedback Options" : "Location"
        cell.lbl_Role.text  = service == .feedbackOptions ? arr_FeedbackOptions[indexPath.row].feedback_option : arr_DefectLocation[indexPath.row].defect_location
        cell.view_Outer.addGestureRecognizer(tap)
        cell.btn_Edit.tag = indexPath.row
        cell.btn_Edit.addTarget(self, action: #selector(self.actionEdit(_:)), for: .touchUpInside)
       
          cell.selectionStyle = .none
         
          
              return cell
        }
        
      }
      func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          
        return  service == .facilityType ? 175 :  92
      }
      @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
         
        if service == .feedbackOptions{
        let addeditOptionVC = kStoryBoardSettings.instantiateViewController(identifier: "AddEditFeedbackTableViewController") as! AddEditFeedbackTableViewController
        addeditOptionVC.isToEdit = true
        addeditOptionVC.option = arr_FeedbackOptions[(sender! as UITapGestureRecognizer).view!.tag]
        self.parentVc.navigationController?.pushViewController(addeditOptionVC, animated: true)
        }
        else  if service == .facilityType{
            let addeditOptionVC = kStoryBoardSettings.instantiateViewController(identifier: "AddEditFacilityTableViewController") as! AddEditFacilityTableViewController
            addeditOptionVC.isToEdit = true
            addeditOptionVC.facility = arr_FaciltyType[(sender! as UITapGestureRecognizer).view!.tag]
            self.parentVc.navigationController?.pushViewController(addeditOptionVC, animated: true)
       
        }
        else{
            let addeditOptionVC = kStoryBoardSettings.instantiateViewController(identifier: "AddEditDefectsLocationTableViewController") as! AddEditDefectsLocationTableViewController
            addeditOptionVC.isToEdit = true
            addeditOptionVC.location = arr_DefectLocation[(sender! as UITapGestureRecognizer).view!.tag]
            self.parentVc.navigationController?.pushViewController(addeditOptionVC, animated: true)
          
        }
      }
     
    @IBAction func actionEdit(_ sender: UIButton){
        if service == .feedbackOptions{
        let addeditOptionVC = kStoryBoardSettings.instantiateViewController(identifier: "AddEditFeedbackTableViewController") as! AddEditFeedbackTableViewController
        addeditOptionVC.isToEdit = true
        addeditOptionVC.option = arr_FeedbackOptions[sender.tag]
        self.parentVc.navigationController?.pushViewController(addeditOptionVC, animated: true)
        }
        else  if service == .facilityType{
            let addeditOptionVC = kStoryBoardSettings.instantiateViewController(identifier: "AddEditFacilityTableViewController") as! AddEditFacilityTableViewController
            addeditOptionVC.isToEdit = true
            addeditOptionVC.facility = arr_FaciltyType[sender.tag]
            self.parentVc.navigationController?.pushViewController(addeditOptionVC, animated: true)
        }
        else{
            let addeditOptionVC = kStoryBoardSettings.instantiateViewController(identifier: "AddEditDefectsLocationTableViewController") as! AddEditDefectsLocationTableViewController
            addeditOptionVC.isToEdit = true
            addeditOptionVC.location = arr_DefectLocation[sender.tag]
            self.parentVc.navigationController?.pushViewController(addeditOptionVC, animated: true)
          
        }
      }
      
  }
  extension ServiceSummaryTableViewController: MenuViewDelegate{
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
