//
//  UnitListTypeTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 22/03/23.
//

import UIKit
import DropDown

enum UnitListType: Int{
    case contactinfo = 7
    case keycollection = 2
    case defects = 3
    case facilitybooking = 5
    case feedback = 6
    case moveinout = 40
    case renovation = 41
    case dooraccess = 42
    case vehiclereg = 43
    case updateAddress = 44
    case updateParticulars = 45
    case accesscardmanagement = 38
    case visitormanagement = 34
    case residentmanagement = 60
}
let kContactinfo = "Contact Info"

let kMoveinout = "E-Moving In & Out"
let kRenovation = "E-Renovation Registration"
let kDooraccess = "E-Access Card Registration"
let kVehiclereg = "E-Registration for Vehicle IU"
let kUpdateAddress = "E-Change of Mailing Address"
let kUpdateParticular = "E-Update of Particulars"
let kAccesscardmanagement = "Access Card Management"
let kVisitormanagement = "Visitors Management"
let kResidentmanagement = "Resident Management"


let array_UnitListsType = [kContactinfo, kKeyCollection, kDefectList, kFeedback, kFacilities, kMoveinout, kRenovation, kDooraccess, kVehiclereg, kUpdateAddress, kUpdateParticular, kAccesscardmanagement, kVisitormanagement, kResidentmanagement]

let array_UnitListsTypes = [UnitListType.contactinfo, UnitListType.keycollection, UnitListType.defects, UnitListType.feedback, UnitListType.facilitybooking, UnitListType.moveinout, UnitListType.renovation, UnitListType.dooraccess, UnitListType.vehiclereg, UnitListType.updateAddress, UnitListType.updateParticulars, UnitListType.accesscardmanagement, UnitListType.visitormanagement, UnitListType.residentmanagement]



class UnitListTypeTableViewController:  BaseTableViewController {
    
    let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
    
    //Outlets
    @IBOutlet weak var view_SwitchProperty: UIView!
    @IBOutlet weak var lbl_SwitchProperty: UILabel!
  
    @IBOutlet weak var txt_Building: UITextField!
    @IBOutlet weak var txt_Unit: UITextField!
    @IBOutlet weak var txt_Type: UITextField!
//    @IBOutlet weak var lbl_UnitCode: UILabel!
//    @IBOutlet weak var lbl_UnitSize: UILabel!
//    @IBOutlet weak var lbl_UnitShare: UILabel!
   
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var imgView_Profile: UIImageView!
    @IBOutlet var arr_Textfields: [UITextField]!
   
    @IBOutlet weak var lbl_Title: UILabel!
 //   @IBOutlet weak var collection_unitlisttype:UICollectionView!
   
    let menu: MenuView = MenuView.getInstance
    @IBOutlet weak var table_UnitListType: UITableView!
    var dataSource = DataSource_UnitListType()
    var unitsData = [Unit]()
    var array_ContactInfo = [UserModal]()
    var array_KeyCollection = [KeyCollectionModal]()
    var array_Defects = [Defects]()
    var array_FacilityBooking = [FacilityModal]()
    var array_Feedback = [FeedbackModal]()
    var arr_MoveInOut = [MoveInOut]()
    var arr_Renovation = [RenovationSubmission]()
    var arr_DoorAccess = [DoorAccessSubmission]()
    var arr_UpdateAddress = [UpdateAddress]()
    var arr_UpdateParticulars = [UpdateParticulars]()
    var arr_VehicleReg = [VehicleReg]()
    var array_Cards = [Card]()
    var array_Visitors = [VisitorSummary]()
    var array_Resident = [ResidentMgmt]()
    var array_BuildingList = [Building]()
    var roles = [String: String]()
    var unit_selected: Unit!
    var building_id: Int!
    var unit:Int!
    
    var selectedListType: UnitListType = .contactinfo
    var selectedListTypeIndex = 0
    
    let alertView: AlertView = AlertView.getInstance
    let alertView_message: MessageAlertView = MessageAlertView.getInstance
    var userIdToActivate = 0
    var isToActivateUser = false
    var isToDeleteUser = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbl_SwitchProperty.text = kCurrentPropertyName
        view_SwitchProperty.layer.borderColor = themeColor.cgColor
        view_SwitchProperty.layer.borderWidth = 1.0
        view_SwitchProperty.layer.cornerRadius = 10.0
        view_SwitchProperty.layer.masksToBounds = true
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
        table_UnitListType.dataSource = dataSource
        table_UnitListType.delegate = dataSource
        dataSource.parentVc = self
        dataSource.unitsData = self.unitsData
        dataSource.selectedListType = self.selectedListType
        building_id = unit_selected.building_id
        unit = unit_selected.id
        setUpUI()
      //  setUpCollectionLayout()
        getRolesList()
        txt_Unit.backgroundColor = UIColor.white
        txt_Building.backgroundColor = UIColor.white
        txt_Type.backgroundColor = UIColor.white
        txt_Type.text = kContactinfo
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.showBottomMenu()
        self.getUnitListTypeSummary()
        txt_Unit.text = unit_selected.unit
        if let building = array_BuildingList.first(where: { $0.id == unit_selected.building_id }) {
            txt_Building.text = building.building
        }
//        lbl_UnitCode.text = unit_selected.code
//        lbl_UnitSize.text = unit_selected.size
//        lbl_UnitShare.text = unit_selected.share_amount
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.closeMenu()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var count = 0
        var rowHt = 0
        switch selectedListType {
        case .contactinfo:
            count = array_ContactInfo.count
            rowHt = 288
            break
        case .keycollection:
            count = array_KeyCollection.count
            rowHt = 150
            break
        case .defects:
            count = array_Defects.count
            rowHt = 305
            break
        case .facilitybooking:
            count = array_FacilityBooking.count
            rowHt = 205
            break
        case .feedback:
            count = array_Feedback.count
            rowHt = 200
            break
        case .moveinout:
            count = arr_MoveInOut.count
            rowHt = 250
            break
        case .renovation:
            count = arr_Renovation.count
            rowHt = 250
            break
        case .dooraccess:
            count = arr_DoorAccess.count
            rowHt = 250
            break
        case .vehiclereg:
            count = arr_VehicleReg.count
            rowHt = 250
            break
        case .updateAddress:
            count = arr_UpdateAddress.count
            rowHt = 195
            break
        case .updateParticulars:
            count = arr_UpdateAddress.count
            rowHt = 250
            break
        case .accesscardmanagement:
            count = array_Cards.count
            rowHt = 143
            break
        case .visitormanagement:
            count = array_Visitors.count
            rowHt = 200
            break
        case .residentmanagement:
            count = array_Resident.count
            rowHt = 263
            break
        
      
        }
        if indexPath.row == 4{
            let ht =  (count * rowHt) + 50
            return CGFloat(ht)
        }
        else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    func showBottomMenu(){
    
    menu.delegate = self
    menu.showInView(self.view, title: "", message: "")
  
}
func closeMenu(){
    menu.removeView()
}
    func setUpUI(){
       
        
        
        view_Background.layer.cornerRadius = 25.0
        view_Background.layer.masksToBounds = true
      
        imgView_Profile.addborder()
       
        for txtField in arr_Textfields{
            txtField.layer.cornerRadius = 20.0
            txtField.layer.masksToBounds = true
            txtField.delegate = self
            txtField.textColor = textColor
            txtField.attributedPlaceholder = NSAttributedString(string: txtField.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
        }
       
       
       
    }
  /*  func setUpCollectionLayout(){
        let layout =  UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//         let font = UIFont(name: "Helvetica", size: 24)
//        let fontAttributes = [NSAttributedString.Key.font: font]
//           let text = "Your Text Here"
//        let size = (text as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
//

       
        let size = CGSize(width: 250, height: 60 )
        layout.itemSize = size
        collection_unitlisttype.collectionViewLayout = layout
        layout.scrollDirection = .horizontal
        self.collection_unitlisttype.reloadData()
    }*/
    //MARK: ******  PARSING *********
   
    func getRolesList(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"        //
        ApiService.get_RolesList(parameters: ["login_id":userId], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? RolesBase){
                    self.roles = response.roles
                     self.dataSource.roles = response.roles
                     self.table_UnitListType.reloadData()
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
    func getTypeId(type: UnitListType) -> Int{
        var count = 0
        
        switch type{
        case .contactinfo:
            count = 7
            break
        case .keycollection:
            count = 2
            break
        case .defects:
            count = 3
            break
        case .facilitybooking:
            count = 5
            break
        case .feedback:
            count = 6
            break
        case .moveinout:
            count = 40
            break
        case .renovation:
            count = 41
            break
        case .dooraccess:
            count = 42
            break
        case .vehiclereg:
            count = 43
            break
        case .updateAddress:
            count = 44
            break
        case .updateParticulars:
            count = 45
            break
        case .accesscardmanagement:
            count = 38
            break
        case .visitormanagement:
            count = 34
            break
        case .residentmanagement:
            count = 60
            break
       
            
        }
        return count
    }
    
    func getUnitListTypeSummary(){
        array_ContactInfo.removeAll()
        array_KeyCollection.removeAll()
        array_Defects.removeAll()
        array_FacilityBooking.removeAll()
        array_Feedback.removeAll()
        arr_MoveInOut.removeAll()
        arr_Renovation.removeAll()
        arr_DoorAccess.removeAll()
        arr_UpdateAddress.removeAll()
        arr_UpdateParticulars.removeAll()
        arr_VehicleReg.removeAll()
        array_Cards.removeAll()
        array_Visitors.removeAll()
        array_Resident.removeAll()
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        let type = self.getTypeId(type: self.selectedListType)
        ApiService.get_UnitListTypeSummary(unitlisttype: self.selectedListType, parameters: ["building_id":self.building_id!, "unit_id":self.unit!, "type": self.selectedListType.rawValue, "login_id": userId], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                if self.selectedListType == .contactinfo{
                    if let response = (result as? ContactInfoBase){
                        self.array_ContactInfo = response.data
                        self.dataSource.array_ContactInfo = self.array_ContactInfo
                        self.table_UnitListType.reloadData()
                        self.tableView.reloadData()
                    }
                }
                else if self.selectedListType == .keycollection{
                    if let response = (result as? KeyCollectionSummaryBase){
                        self.array_KeyCollection = response.data
                        self.dataSource.array_KeyCollection = self.array_KeyCollection
                        self.table_UnitListType.reloadData()
                        self.tableView.reloadData()
                    }
                }
                
                else if self.selectedListType == .defects{
                    if let response = (result as? DefectsModalBase){
                        self.array_Defects = response.data
                        self.dataSource.array_Defects = self.array_Defects
                        self.table_UnitListType.reloadData()
                        self.tableView.reloadData()
                    }
                }
                else if self.selectedListType == .facilitybooking{
                    if let response = (result as? FacilityModalBase){
                        self.array_FacilityBooking = response.data
                        self.dataSource.array_FacilityBooking = self.array_FacilityBooking
                        self.table_UnitListType.reloadData()
                        self.tableView.reloadData()
                    }
                    
                }
                else if self.selectedListType == .feedback{
                    if let response = (result as? FeedbackModalBase){
                        self.array_Feedback = response.data
                        self.dataSource.array_Feedback = self.array_Feedback
                        self.table_UnitListType.reloadData()
                        self.tableView.reloadData()
                    }
                  
                }
                else if self.selectedListType == .moveinout{
                    if let response = (result as? MoveInOutSummaryBase){
                        self.arr_MoveInOut = response.data
                        self.dataSource.arr_MoveInOut = self.arr_MoveInOut
                        self.table_UnitListType.reloadData()
                        self.tableView.reloadData()
                    }
                   
                }
                else if self.selectedListType == .renovation{
                    if let response = (result as? RenovationSummaryBase){
                        self.arr_Renovation = response.data
                        self.dataSource.arr_Renovation = self.arr_Renovation
                        self.table_UnitListType.reloadData()
                        self.tableView.reloadData()
                    }
                    
                }
                else if self.selectedListType == .dooraccess{
                    if let response = (result as? DoorAccessSummaryBase){
                        self.arr_DoorAccess = response.data
                        self.dataSource.arr_DoorAccess = self.arr_DoorAccess
                        self.table_UnitListType.reloadData()
                        self.tableView.reloadData()
                    }
                    
                }
                else if self.selectedListType == .vehiclereg{
                    if let response = (result as? VehicleRegSummaryBase){
                        self.arr_VehicleReg = response.data
                        self.dataSource.arr_VehicleReg = self.arr_VehicleReg
                        self.table_UnitListType.reloadData()
                        self.tableView.reloadData()
                    }
                   
                }
                else if self.selectedListType == .updateAddress{
                    if let response = (result as? UpdateAddressSummaryBase){
                        self.arr_UpdateAddress = response.data
                        self.dataSource.arr_UpdateAddress = self.arr_UpdateAddress
                        self.table_UnitListType.reloadData()
                        self.tableView.reloadData()
                    }
                }
                else if self.selectedListType == .updateParticulars{
                    if let response = (result as? UpdateParticularsSummaryBase){
                        self.arr_UpdateParticulars = response.data
                        self.dataSource.arr_UpdateParticulars = self.arr_UpdateParticulars
                        self.table_UnitListType.reloadData()
                        self.tableView.reloadData()
                    }
                  
                }
                else if self.selectedListType == .accesscardmanagement{
                    if let response = (result as? CardInfoBase){
                        self.array_Cards = response.data
                        self.dataSource.array_Cards = self.array_Cards
                        self.table_UnitListType.reloadData()
                        self.tableView.reloadData()
                    }
                   
                }
                else if self.selectedListType == .visitormanagement{
                    if let response = (result as? VisitorSummaryModalBase){
                        self.array_Visitors = response.data
                        self.dataSource.array_Visitors = self.array_Visitors
                        self.table_UnitListType.reloadData()
                        self.tableView.reloadData()
                    }
                  
                }
                else if self.selectedListType == .residentmanagement{
                    if let response = (result as? ResidentMgmtBase){
                        self.array_Resident = response.data
                        self.dataSource.array_Resident = self.array_Resident
                        self.table_UnitListType.reloadData()
                        self.tableView.reloadData()
                    }
                    
                }
                DispatchQueue.main.async{
                    self.table_UnitListType.reloadData()
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
    func getInfo_MoveInOut(id: Int, redirection: redirectionType, index: Int){
        ActivityIndicatorView.show("Loading")
        
        //
        
        ApiService.get_MoveInOutInfo(parameters: ["login_id" : userId, "id" : id], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? MoveInOutInfoBase){
                    let detail = response.details
                     if redirection == .inspection{
                     let moveIODetailsTVC = kStoryBoardMenu.instantiateViewController(identifier: "MoveIOInspectionTableViewController") as! MoveIOInspectionTableViewController
                     moveIODetailsTVC.moveInOutData = detail
                     moveIODetailsTVC.formType = .moveInOut
                     self.navigationController?.pushViewController(moveIODetailsTVC, animated: true)
                     }
                     else if redirection == .payment{
                         let moveIODetailsTVC = kStoryBoardMenu.instantiateViewController(identifier: "EFormPaymentTableViewController") as! EFormPaymentTableViewController
                         moveIODetailsTVC.moveInOutData = detail
                         moveIODetailsTVC.formType = .moveInOut
                         self.navigationController?.pushViewController(moveIODetailsTVC, animated: true)
                     }
                     else{
                         let moveIODetailsTVC = kStoryBoardMenu.instantiateViewController(identifier: "MoveIODetailsTableViewController") as! MoveIODetailsTableViewController
                         moveIODetailsTVC.moveInOutData = detail
                         moveIODetailsTVC.unit = self.arr_MoveInOut[index].unit
                         self.navigationController?.pushViewController(moveIODetailsTVC, animated: true)
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
    
    
    
  
    
    func getInfo_Renovation(id: Int, redirection: redirectionType, index: Int){
        ActivityIndicatorView.show("Loading")
        //
        ApiService.get_RenovationInfo(parameters: ["login_id" : userId, "id" : id], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? RenovationInfoBase){
                    let detail = response.details
                     if redirection == .inspection{
                     let moveIODetailsTVC = kStoryBoardMenu.instantiateViewController(identifier: "MoveIOInspectionTableViewController") as! MoveIOInspectionTableViewController
                     moveIODetailsTVC.renovationData = detail
                     moveIODetailsTVC.formType = .renovation
                     self.navigationController?.pushViewController(moveIODetailsTVC, animated: true)
                     }
                     else if redirection == .payment{
                         let moveIODetailsTVC = kStoryBoardMenu.instantiateViewController(identifier: "EFormPaymentTableViewController") as! EFormPaymentTableViewController
                         moveIODetailsTVC.renovationData = detail
                         moveIODetailsTVC.formType = .renovation
                         self.navigationController?.pushViewController(moveIODetailsTVC, animated: true)
                     }
                     else{
                         let moveIODetailsTVC = kStoryBoardMenu.instantiateViewController(identifier: "RenovationDetailsTableViewController") as! RenovationDetailsTableViewController
                         moveIODetailsTVC.renovationData = detail
                         moveIODetailsTVC.unit = self.arr_Renovation[index].unit
                         self.navigationController?.pushViewController(moveIODetailsTVC, animated: true)
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
    
   
    func getInfo_DoorAccess(id: Int, redirection: redirectionType, index: Int){
        ActivityIndicatorView.show("Loading")
        //
        ApiService.get_DoorAccessInfo(parameters: ["login_id" : userId, "id" : id], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? DoorAccessInfoBase){
                    let detail = response.details
                     if redirection == .inspection{
                     let moveIODetailsTVC = kStoryBoardMenu.instantiateViewController(identifier: "DoorAccessAcknowledgementTableViewController") as! DoorAccessAcknowledgementTableViewController
                     moveIODetailsTVC.doorAccessData = detail
                     self.navigationController?.pushViewController(moveIODetailsTVC, animated: true)
                     }
                     else if redirection == .payment{
                         let moveIODetailsTVC = kStoryBoardMenu.instantiateViewController(identifier: "EFormPaymentTableViewController") as! EFormPaymentTableViewController
                         moveIODetailsTVC.doorAceessData = detail
                         moveIODetailsTVC.formType = .doorAccess
                         self.navigationController?.pushViewController(moveIODetailsTVC, animated: true)
                     }
                     else{
                         let moveIODetailsTVC = kStoryBoardMenu.instantiateViewController(identifier: "DoorAccessDetailsTableViewController") as! DoorAccessDetailsTableViewController
                         moveIODetailsTVC.doorAccessData = detail
                         moveIODetailsTVC.unit = self.arr_DoorAccess[index].unit
                         self.navigationController?.pushViewController(moveIODetailsTVC, animated: true)
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
    
   
    func getInfo_VehicleReg(id: Int, redirection: redirectionType, index: Int){
        ActivityIndicatorView.show("Loading")
        //
        ApiService.get_VehicleRegInfo(parameters: ["login_id" : userId, "id" : id], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? VehicleRegInfoBase){
                    let detail = response.details
                     let renovationDetailsTVC = kStoryBoardMenu.instantiateViewController(identifier: "VehicleRegDetailsTableViewController") as! VehicleRegDetailsTableViewController
                        renovationDetailsTVC.vehicleRegData = detail
                     renovationDetailsTVC.unit = self.arr_VehicleReg[index].unit
                        self.navigationController?.pushViewController(renovationDetailsTVC, animated: true)
                     
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
    func showActivateAlert(user_id:Int, isToActivate: Bool, index:Int){
        self.userIdToActivate = user_id
        self.isToActivateUser = isToActivate
        let status = isToActivate ? "activate" : "deactivate"
        let username = self.array_ContactInfo[index].name ?? "the user"
        alertView.delegate = self
        alertView.showInView(self.view_Background, title: "Are you sure you want to\n \(status) \(username)?", okTitle: "Yes", cancelTitle: "Back")
    }
    func activateUser(user_id:Int){
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.activate_user(parameters: ["login_id":userId,"user": user_id
                                             ], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? MessageBase){
                     DispatchQueue.main.async {
                         self.alertView_message.delegate = self
                         self.alertView_message.showInView(self.view_Background, title: "User account has been activated", okTitle: "Home", cancelTitle: "View User Management")
                     }
                     self.getUnitListTypeSummary()
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
    func deactivateUser(user_id:Int){
        
        
        
        
        
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.deactivate_user(parameters: ["login_id":userId, "user": user_id], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? MessageBase){
                     DispatchQueue.main.async {
                         self.alertView_message.delegate = self
                         self.alertView_message.showInView(self.view_Background, title: "User account has been deactivated", okTitle: "Home", cancelTitle: "View User Management")
                     }
                     self.getUnitListTypeSummary()
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
        let fname = Users.currentUser?.moreInfo?.first_name ?? ""
      let lname = Users.currentUser?.moreInfo?.last_name ?? ""
      let name = "\(fname) \(lname)"
        isToDeleteUser = true
        alertView.delegate = self
        alertView.showInView(self.view_Background, title: "Are you sure you want to\n delete \(name)?", okTitle: "Yes", cancelTitle: "Back")
      
    }
    func deleteUser(user_id:Int){
       
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
     
      
        let param = [
            "login_id" : userId,
            "user" : user_id,
          
        ] as [String : Any]

        ApiService.delete_User(parameters: param, completion: { status, result, error in
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? DeleteUserBase){
                    if response.response == 1{
                        DispatchQueue.main.async {
                            self.alertView_message.delegate = self
                            self.alertView_message.showInView(self.view_Background, title: "User has been\n deleted", okTitle: "Home", cancelTitle: "View User List")
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
    @IBAction func actionChange(_ sender:UIButton) {
        getUnitListTypeSummary()
    }
    @IBAction func actionClear(_ sender:UIButton) {
        self.txt_Unit.text = ""
        txt_Building.text = ""
        getUnitListTypeSummary()
        
        
    }
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
      
    @IBAction func actionUnit(_ sender:UIButton) {
       // let sortedArray = unitsData.sorted(by:  { $0.1 < $1.1 })
        let arrUnit = unitsData.map { $0.unit }
        let dropDown_Unit = DropDown()
        dropDown_Unit.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Unit.dataSource = arrUnit// Array(unitsData.values)
        dropDown_Unit.show()
        dropDown_Unit.selectionAction = { [unowned self] (index: Int, item: String) in
            txt_Unit.backgroundColor = UIColor.white
            txt_Unit.text = item
            self.unit = unitsData[index].id
            unit_selected = unitsData[index]
            
            if let building = array_BuildingList.first(where: { $0.id == unit_selected.building_id }) {
                txt_Building.text = building.building
                getUnitListTypeSummary()
            }
//            lbl_UnitCode.text = unit_selected.code
//            lbl_UnitSize.text = unit_selected.size
//            lbl_UnitShare.text = unit_selected.share_amount
            
            
        }
    }
      
    @IBAction func actionBuilding(_ sender:UIButton) {
        let arrUnit = array_BuildingList.map { $0.building }
        let dropDown_Unit = DropDown()
        dropDown_Unit.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Unit.dataSource = arrUnit// Array(unitsData.values)
        dropDown_Unit.show()
        dropDown_Unit.selectionAction = { [unowned self] (index: Int, item: String) in
                txt_Building.backgroundColor = UIColor.white
            txt_Building.text = item
            building_id = array_BuildingList[index].id
            getUnitListTypeSummary()
        }
    }
    @IBAction func actionType(_ sender:UIButton) {
        let arrUnit = array_UnitListsType
        let dropDown_Unit = DropDown()
        dropDown_Unit.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Unit.dataSource = arrUnit// Array(unitsData.values)
        dropDown_Unit.show()
        dropDown_Unit.selectionAction = { [unowned self] (index: Int, item: String) in
                txt_Type.backgroundColor = UIColor.white
            txt_Type.text = item
            self.selectedListType = array_UnitListsTypes[index]
            dataSource.selectedListType = self.selectedListType
            DispatchQueue.main.async {
                
                
                
                self.getUnitListTypeSummary()
            }
        }
    }
 /*   @IBAction func actionSelectType(_ sender:UIButton) {
        self.selectedListTypeIndex = sender.tag
        self.selectedListType = array_UnitListsTypes[sender.tag]
        dataSource.selectedListType = self.selectedListType
        DispatchQueue.main.async {
            
            
            self.collection_unitlisttype.reloadData()
            self.getUnitListTypeSummary()
        }
    }
    
  
  
  */
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
class DataSource_UnitListType: NSObject, UITableViewDataSource, UITableViewDelegate {
    var unitsData = [Unit]()
    var parentVc: UIViewController!
    
    var array_ContactInfo = [UserModal]()
    var array_KeyCollection = [KeyCollectionModal]()
    var array_Defects = [Defects]()
    var array_FacilityBooking = [FacilityModal]()
    var array_Feedback = [FeedbackModal]()
    var arr_MoveInOut = [MoveInOut]()
    var arr_Renovation = [RenovationSubmission]()
    var arr_DoorAccess = [DoorAccessSubmission]()
    var arr_UpdateAddress = [UpdateAddress]()
    var arr_UpdateParticulars = [UpdateParticulars]()
    var arr_VehicleReg = [VehicleReg]()
    var array_Cards = [Card]()
    var array_Visitors = [VisitorSummary]()
    var array_Resident = [ResidentMgmt]()
    
    var roles = [String: String]()
    
    var selectedListType: UnitListType!
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 0
        switch selectedListType{
        case .contactinfo:
            count = array_ContactInfo.count
            break
        case .keycollection:
            count = array_KeyCollection.count
            break
        case .defects:
            count = array_Defects.count
            break
        case .facilitybooking:
            count = array_FacilityBooking.count
            break
        case .feedback:
            count = array_Feedback.count
            break
        case .moveinout:
            count = arr_MoveInOut.count
            break
        case .renovation:
            count = arr_Renovation.count
            break
        case .dooraccess:
            count = arr_DoorAccess.count
            break
        case .vehiclereg:
            count = arr_VehicleReg.count
            break
        case .updateAddress:
            count = arr_UpdateAddress.count
            break
        case .updateParticulars:
            count = arr_UpdateAddress.count
            break
        case .accesscardmanagement:
            count = array_Cards.count
            break
        case .visitormanagement:
            count = array_Visitors.count
            break
        case .residentmanagement:
            count = array_Resident.count
            break
        case .none:
            break
            
        }
        
        return  count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if selectedListType == .contactinfo{
            let cell = tableView.dequeueReusableCell(withIdentifier: "contactInfoCell") as! AccessRolesTableViewCell
            cell.btn_Delete.tag = indexPath.row
            cell.btn_Delete.addTarget(self, action: #selector(self.actionDelete(_:)), for: .touchUpInside)
            cell.selectionStyle = .none
            cell.btn_Activate.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
            cell.btn_Activate.layer.cornerRadius = 8.0
            cell.btn_Delete.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
            cell.btn_Delete.layer.cornerRadius = 8.0
            cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
            
            cell.view_Outer.tag = indexPath.row
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            cell.view_Outer.addGestureRecognizer(tap)
          //  cell.img_Arrow.isHidden = true
            
            let user = array_ContactInfo[indexPath.row]
            
            if user.userinfo != nil{
                cell.lbl_FirstName.text = user.name
                cell.lbl_LastName.text = user.userinfo.last_name
                cell.lbl_Phone.text = user.userinfo.phone
                
               // cell.lbl_UnitNo.text = user.unit?.unit
                cell.lbl_AssignedRole.text = user.role
                //self.roles["\(user.role_id ?? 0)"]
             //   cell.lbl_Email.text = user.email
                cell.lbl_StartDate.text = user.created_at
                cell.lbl_EndDate.text = user.end_date
//                let profilePic = user.userinfo.profile_picture ?? ""
//                if let url1 = URL(string: "\(kImageFilePath)/" + profilePic) {
//                   // self.imgView_Profile.af_setImage(withURL: url1)
//                    cell.img_Phone.af_setImage(
//                                withURL: url1,
//                                placeholderImage: UIImage(named: "avatar"),
//                                filter: nil,
//                                imageTransition: .crossDissolve(0.2)
//                            )
//                }
//                else{
//                    cell.img_Phone.image = UIImage(named: "avatar")
//                }
            }
            cell.btn_Edit.tag = indexPath.row
            cell.btn_Edit.addTarget(self, action: #selector(self.actionEditUser(_:)), for: .touchUpInside)
            cell.selectionStyle = .none
            cell.btn_Activate.tag = indexPath.row
            cell.btn_Activate.addTarget(self, action: #selector(self.actionActivate(_:)), for: .touchUpInside)
          
            if user.status == 1{
                cell.btn_Activate.setTitle("Deactivate", for: .normal)
               // setImage(UIImage(named: "activated"), for: .normal)
            }
            else{
                cell.btn_Activate.setTitle("Activate", for: .normal)
                //setImage(UIImage(named: "deactivated"), for: .normal)
            }
            return cell
        }
        else if selectedListType == .keycollection{
            let cell = tableView.dequeueReusableCell(withIdentifier: "keycollectionCell") as! AppointmentUnitTakeOverTableViewCell
            cell.view_Outer.tag = indexPath.row
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            cell.view_Outer.addGestureRecognizer(tap)
            cell.selectionStyle = .none
            
            cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
            
            
            
            let apptInfo = self.array_KeyCollection[indexPath.row]
            cell.lbl_BookedBy.text = apptInfo.submission_info.getname?.name  ?? "-"
          //  cell.lbl_UnitNo.text = apptInfo.submission_info.getunit?.unit ?? "-"
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd"
            let date = formatter.date(from: apptInfo.submission_info.appt_date)
            formatter.dateFormat = "dd/MM/yy"
            let dateStr = formatter.string(from: date ?? Date())
            
            
            cell.lbl_AppointmentDate.text = dateStr
            
            
            cell.lbl_AppointmentTime.text =  apptInfo.submission_info.appt_time
            cell.lbl_Status.text =  apptInfo.submission_info.status == 1 ? "Cancelled" : apptInfo.submission_info.status == 2  ? "On Schedule" : apptInfo.submission_info.status == 3 ? "Done" : ""
            
            
            cell.view_Outer.tag = indexPath.row
            cell.btn_Edit.tag = indexPath.row
            cell.btn_Edit.addTarget(self, action: #selector(self.actionEditKeyCollection(_:)), for: .touchUpInside)
            return cell
        }
        else if selectedListType == .defects{
            let cell = tableView.dequeueReusableCell(withIdentifier: "defectsListCell") as! DefectsListTableViewCell
            cell.selectionStyle = .none
            
            cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
            cell.view_Outer.tag = indexPath.row
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            
            let defect = array_Defects[indexPath.row]
            cell.lbl_TicketNo.text = defect.lists.ticket
            cell.lbl_Reference.text = defect.lists.ref_id == "" ? "-" : defect.lists.ref_id
            if let unitId = unitsData.first(where: { $0.id == defect.user_info?.unit_no ?? 0 }) {
                cell.lbl_UnitNo.text = "#" + unitId.unit
            }
            else{
                cell.lbl_UnitNo.text = ""
            }
            cell.lbl_Status.text =  defect.lists.status == 0 ? "Open" : defect.lists.status == 1  ? "Closed" : defect.lists.status == 2 ?  "In Progress" : defect.lists.status == 3 ? "On Schedule" : defect.lists.status == 4  ? "Done" : ""
            
            if defect.inspection != nil{
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.dateFormat = "yyyy-MM-dd"
                let date = formatter.date(from: defect.inspection!.appt_date)
                formatter.dateFormat = "dd/MM/yy"
                let dateStr = formatter.string(from: date ?? Date())
                
                cell.lbl_ApptDate.text = "\(dateStr) \(defect.inspection!.appt_time)"
                cell.lbl_ApptStatus.text = defect.inspection!.status == 0 ? "New" :
                    defect.inspection!.status == 1  ? "Cancelled" :
                    defect.inspection!.status == 2 ? "On Schedule" :
                    defect.inspection!.status == 3 ?   "Done" :
                defect.inspection!.status == 4  ? "In Progress" : ""
                
              //  cell.lbl_ApptTime.text = defect.inspection!.appt_time
            }
            else{
                cell.lbl_ApptDate.text = "-"
                cell.lbl_ApptStatus.text = "-"
               // cell.lbl_ApptTime.text = "-"
            }
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = formatter.date(from: defect.lists.created_at)
            formatter.dateFormat = "dd/MM/yy"
            cell.lbl_SubmittedDate.text = formatter.string(from: date ?? Date())
            cell.lbl_CompletedDate.text = "-"
            if  defect.lists.status == 1 {
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.dateFormat = "yyyy-MM-dd"
                let date = formatter.date(from: defect.lists!.completion_date)
                formatter.dateFormat = "dd/MM/yy"
                let dateStr = formatter.string(from: date ?? Date())
                
                cell.lbl_CompletedDate.text = dateStr
            }
            cell.btn_Inspection.tag = indexPath.row
            cell.btn_Inspection.addTarget(self, action: #selector(self.actionInspection(_:)), for: .touchUpInside)
            cell.lblNew.layer.cornerRadius = 11.0
            cell.lblNew.layer.masksToBounds = true
            
            if defect.lists.handover_status == 1 || defect.lists.handover_status == 2{
                cell.btn_Handover.isHidden = false
            }
            else{
                cell.btn_Handover.isHidden = true
            }
            if defect.lists.view_status == 0{
                cell.lblNew.isHidden = false
            }
            else{
                cell.lblNew.isHidden = true
            }
            cell.btn_Handover.tag = indexPath.row
            cell.btn_Handover.addTarget(self, action: #selector(self.actionHandover(_:)), for: .touchUpInside)
            cell.btn_Delete.tag = indexPath.row
            cell.btn_Delete.addTarget(self, action: #selector(self.actionDeleteDefect(_:)), for: .touchUpInside)
            
            return cell
        }
        else if selectedListType == .feedback{
            let cell = tableView.dequeueReusableCell(withIdentifier: "feedbackCell") as! FeedbackTableViewCell
            let feedback = array_Feedback[indexPath.row]
            
            cell.lbl_TicketNo.text = feedback.submissions.ticket
            cell.lbl_Status.text = feedback.submissions.status == 0 ? "Open" :
            feedback.submissions.status == 1 ? "Closed" : "In Progress"
            cell.lbl_SubmittedBy.text = feedback.user_info?.name
//            if let unitId = unitsData.first(where: { $0.id == feedback.user_info?.unit_no }) {
//                cell.lbl_UnitNo.text = "#" + unitId.unit
//            }
//            else{
//                cell.lbl_UnitNo.text = ""
//            }
            //unitsData["\(feedback.user_info?.unit_no ?? 0)"]
            cell.lbl_Category.text = feedback.option?.feedback_option
            cell.selectionStyle = .none
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat =  "yyyy-MM-dd HH:mm:ss"
            let date = formatter.date(from: feedback.submissions.created_at)
            let dateUpdated = formatter.date(from: feedback.submissions.updated_at)
            formatter.dateFormat = "dd/MM/yy"
            let dateStr = formatter.string(from: date ?? Date())
            
            
            let dateStrUpdated = formatter.string(from: dateUpdated ?? Date())
            
            cell.lbl_SubmittedDate.text = dateStr
           // cell.img_Arrow.isHidden = true
          //  cell.img_Arrow.image = indexPath.row == selectedRowIndex_Feedback ? UIImage(named: "up_arrow") : UIImage(named: "down_arrow")
            cell.lbl_UpdatedOn.text =  dateStrUpdated
            cell.btn_Edit.tag = indexPath.row
            
            cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
            cell.btn_Edit.addTarget(self, action: #selector(self.actionEditFeedback(_:)), for: .touchUpInside)
            cell.view_Outer.tag = indexPath.row
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            cell.view_Outer.addGestureRecognizer(tap)
//            if indexPath.row != selectedRowIndex_Feedback{
//                for vw in cell.arrViews{
//                    vw.isHidden = true
//                }
//            }
//
//
//            else{
//                for vw in cell.arrViews{
//                    vw.isHidden = false
//                }
//            }
            
            
            
            return cell
        }
        
        
        else if selectedListType == .facilitybooking{
            let cell = tableView.dequeueReusableCell(withIdentifier: "facilityCell") as! FacilityTableViewCell
            
            cell.selectionStyle = .none
            cell.btn_Edit.tag = indexPath.row
            cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
            cell.btn_Edit.addTarget(self, action: #selector(self.actionEditFacility(_:)), for: .touchUpInside)
            cell.view_Outer.tag = indexPath.row
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            cell.view_Outer.addGestureRecognizer(tap)
//            if indexPath.row != selectedRowIndex_Facility{
//                for vw in cell.arrViews{
//                    vw.isHidden = true
//                }
//            }
//            else{
//                for vw in cell.arrViews{
//                    vw.isHidden = false
//                }
//            }
            let facility = array_FacilityBooking[indexPath.row]
            cell.lbl_Facility.text = facility.type?.facility_type
//            if let unitId = unitsData.first(where: { $0.id == facility.user_info?.unit_no ?? 0 }) {
//                cell.lbl_UnitNo.text = "#" + unitId.unit
//            }
//            else{
//                cell.lbl_UnitNo.text = ""
//            }
            // cell.lbl_UnitNo.text = unitsData["\(facility.user_info?.unit_no ?? 0)"]
            cell.lbl_BookingTime.text = facility.submissions.booking_time
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat =  "yyyy-MM-dd"
            let date = formatter.date(from: facility.submissions.booking_date)
            formatter.dateFormat = "dd/MM/yy"
            let dateStr = formatter.string(from: date ?? Date())
            cell.lbl_BookingDate.text = dateStr
            cell.lbl_BookedBy.text = facility.user_info?.name
            cell.lbl_Status.text = facility.submissions.status == 0 ? "New" :
            facility.submissions.status == 1  ? "Cancelled" : facility.submissions.status == 2 ? "Confirmed" : ""
            
            return cell
        }
        else if selectedListType == .accesscardmanagement{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cardSummaryCell") as! CardSummaryTableViewCell
            let card = array_Cards[indexPath.row]
            
            cell.lbl_CardNo.text = card.card
            cell.lbl_Status.text =
                card.status == 1 ? "Active" :  card.status == 2 ? "Inactive" :  card.status == 3 ? "Faulty" :  card.status == 4 ? "Loss" :  card.status == 5 ? "Stolen" :""
           
            if let unitId = unitsData.first(where: { $0.id == card.unit_no }) {
                cell.lbl_UnitNo.text = "#" + unitId.unit
            }
            else{
            cell.lbl_UnitNo.text = ""
            }
           
           
            cell.selectionStyle = .none
           
            
            
            cell.btn_Edit.tag = indexPath.row
               
            cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
            cell.btn_Edit.addTarget(self, action: #selector(self.actionEditCard(_:)), for: .touchUpInside)
            cell.view_Outer.tag = indexPath.row
           
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            cell.view_Outer.addGestureRecognizer(tap)
           
            return cell
        }
        else if selectedListType == .residentmanagement{
            let cell = tableView.dequeueReusableCell(withIdentifier: "residentCell") as! ResidentMgmtTableViewCell
            let info = array_Resident[indexPath.row]
            
            cell.lbl_Invoice.text = info.invoice_info.invoice_no
            cell.lbl_BatchNo.text = info.invoice_info.batch_file_no
            
            cell.lbl_Building.text = info.building.building
            if info.unit != nil{
                cell.lbl_UnitNo.text = "#" + info.unit.unit
            }
            //unitsData["\(feedback.user_info?.unit_no ?? 0)"]
            cell.lbl_Amount.text = info.invoice_info.invoice_amount
            cell.selectionStyle = .none
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat =  "yyyy-MM-dd HH:mm:ss"
            let date = formatter.date(from: info.invoice_info.created_at)
            formatter.dateFormat = "dd/MM/yy"
            let dateStr = formatter.string(from: date ?? Date())
            
            
          //  let dateStrUpdated = formatter.string(from: dateUpdated ?? Date())
            
            cell.lbl_CreatedAt.text = dateStr
           // cell.img_Arrow.isHidden = true
                                                                                                        
            cell.btn_Edit.tag = indexPath.row
            
            cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
           // cell.btn_Edit.addTarget(self, action: #selector(self.actionEditFeedback(_:)), for: .touchUpInside)
            cell.view_Outer.tag = indexPath.row
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            cell.view_Outer.addGestureRecognizer(tap)
//            if indexPath.row != selectedRowIndex_Feedback{
//                for vw in cell.arrViews{
//                    vw.isHidden = true
//                }
//            }
//
//
//            else{
//                for vw in cell.arrViews{
//                    vw.isHidden = false
//                }
//            }
            
            
            
            return cell
        }
        
        
        else if selectedListType == .visitormanagement{
            let cell = tableView.dequeueReusableCell(withIdentifier: "vistorCell") as! VisitorTableViewCell
            
        cell.selectionStyle = .none
        cell.btn_Edit.tag = indexPath.row
        cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
        cell.btn_Edit.addTarget(self, action: #selector(self.actionEditVisitor(_:)), for: .touchUpInside)
        cell.view_Outer.tag = indexPath.row
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        cell.view_Outer.addGestureRecognizer(tap)
       
        let visitor = array_Visitors[indexPath.row]
        cell.lbl_BookingId.text = visitor.ticket
        
      //  cell.lbl_UnitNo.text = "#" + visitor.unit
        cell.lbl_InvitedBy.text =  visitor.invited_by
        cell.lbl_DateOfVisit.text = visitor.date_of_visit
        cell.lbl_VisitorNo.text = "\(visitor.visitor_count)"
        cell.lbl_VisitingPurpose.text = visitor.purpose
        cell.lbl_Status.text = visitor.status
        cell.lbl_New.layer.cornerRadius = 11.0
        cell.lbl_New.layer.masksToBounds = true
        if visitor.view_status == 0{
            cell.lbl_New.isHidden = false
        }
        else{
            cell.lbl_New.isHidden = true
        }
      
        return cell
        }
        
        else{
            
            
            let ident = selectedListType == .updateAddress ? "eformSummaryCell1" : "eformSummaryCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: ident) as! EFormSummaryTableViewCell
            cell.selectionStyle = .none
            
            cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
            cell.btn_Edit.addTarget(self, action: #selector(self.actionEditEForm(_:)), for: .touchUpInside)
            cell.view_Outer.tag = indexPath.row
            cell.btn_Edit.tag = indexPath.row
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            cell.view_Outer.addGestureRecognizer(tap)
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd"
            if cell.btn_Payment != nil{
                cell.btn_Payment.addTarget(self, action: #selector(self.actionPaymentEForm(_:)), for: .touchUpInside)
                cell.btn_Payment.tag = indexPath.row
            }
            if cell.btn_Inspection != nil{
                cell.btn_Inspection.addTarget(self, action: #selector(self.actionInspectionEForm(_:)), for: .touchUpInside)
                cell.btn_Inspection.tag = indexPath.row
            }
            if selectedListType == .moveinout {
                let info = arr_MoveInOut[indexPath.row]
                
                let moving_date = formatter.date(from: info.submission.moving_date)
                let moving_start = formatter.date(from: info.submission.moving_start)
                let moving_end = formatter.date(from: info.submission.moving_end)
                formatter.dateFormat = "dd/MM/yy"
                
                let moving_dateStr = formatter.string(from: moving_date ?? Date())
                let moving_startStr = formatter.string(from: moving_start ?? Date())
                let moving_endStr = formatter.string(from: moving_end ?? Date())
                
                cell.lbl_TicketNo.text = info.submission.ticket
                cell.lbl_Status.text = info.submission.status == 0 ? "New" :
                info.submission.status == 1 ? "Cancelled" :
                info.submission.status == 2 ? "In Progress" :
                info.submission.status == 3 ? "Approved" :
                info.submission.status == 4 ? "Rejected" :
                info.submission.status == 5 ? "Payment Pending" :
                info.submission.status == 6 ? "Refunded" : ""
                let unit = info.unit?.unit
                cell.lbl_UnitNo.text = unit == nil ? "" : "#\(unit!)"
                cell.lbl_SubmittedDate.text = moving_date == nil ? "" : moving_dateStr
                cell.lbl_TenancyStart.text = moving_start == nil ? "" : moving_startStr
                cell.lbl_TenancyEnd.text =  moving_end == nil ? "" :  moving_endStr
                cell.lbl_SubmittedBy.text = info.submitted_by?.name
                
                cell.btn_Payment.isHidden = false
                cell.btn_Inspection.isHidden = false
            }
            else if selectedListType == .renovation{
                cell.btn_Payment.isHidden = false
                cell.btn_Inspection.isHidden = false
                
                let info = arr_Renovation[indexPath.row]
                
                let moving_date = formatter.date(from: info.reno_date)
                let moving_start = formatter.date(from: info.reno_start)
                let moving_end = formatter.date(from: info.reno_end)
                formatter.dateFormat = "dd/MM/yy"
                
                let moving_dateStr = formatter.string(from: moving_date ?? Date())
                let moving_startStr = formatter.string(from: moving_start ?? Date())
                let moving_endStr = formatter.string(from: moving_end ?? Date())
                
                
                cell.lbl_TicketNo.text = info.ticket
                cell.lbl_Status.text = info.status == 0 ? "New" :
                info.status == 1 ? "Cancelled" :
                info.status == 2 ? "In Progress" :
                info.status == 3 ? "Approved" :
                info.status == 4 ? "Rejected" :
                info.status == 5 ? "Payment Pending" :
                info.status == 6 ? "Refunded" : ""
                let unit = info.unit?.unit
                cell.lbl_UnitNo.text = unit == nil ? "" : "#\(unit!)"
                cell.lbl_SubmittedDate.text = moving_date == nil ? "" : moving_dateStr
                cell.lbl_TenancyStart.text =  moving_start == nil ? "" : moving_startStr
                cell.lbl_TenancyEnd.text =   moving_end == nil ? "" : moving_endStr
                cell.lbl_SubmittedBy.text = info.submitted_by?.name
            }
            else if selectedListType == .vehiclereg{
                cell.btn_Payment.isHidden = true
                cell.btn_Inspection.isHidden = true
                let info = arr_VehicleReg[indexPath.row]
                
                let moving_date = formatter.date(from: info.submission.request_date)
                let moving_start = formatter.date(from: info.submission.tenancy_start)
                let moving_end = formatter.date(from: info.submission.tenancy_end)
                formatter.dateFormat = "dd/MM/yy"
                
                let moving_dateStr = formatter.string(from: moving_date ?? Date())
                let moving_startStr = formatter.string(from: moving_start ?? Date())
                let moving_endStr = formatter.string(from: moving_end ?? Date())
                
                cell.lbl_TicketNo.text = info.submission.ticket
                cell.lbl_Status.text = info.submission.status == 0 ? "New" :
                info.submission.status == 1 ? "Cancelled" :
                info.submission.status == 2 ? "In Progress" :
                info.submission.status == 3 ? "Approved" :
                info.submission.status == 4 ? "Rejected" :
                info.submission.status == 5 ? "Payment Pending" :
                info.submission.status == 6 ? "Refunded" : ""
                let unit = info.unit?.unit
                cell.lbl_UnitNo.text = unit == nil ? "" : "#\(unit!)"
                cell.lbl_SubmittedDate.text =  moving_date == nil ? "" : moving_dateStr
                cell.lbl_TenancyStart.text =  moving_start == nil ? "" : moving_startStr
                cell.lbl_TenancyEnd.text =   moving_end == nil ? "" : moving_endStr
                cell.lbl_SubmittedBy.text = info.submitted_by?.name
            }
            else if selectedListType == .dooraccess {
                cell.btn_Payment.isHidden = false
                cell.btn_Inspection.isHidden = false
                let info = arr_DoorAccess[indexPath.row]
                
                let moving_date = formatter.date(from: info.request_date)
                let moving_start = formatter.date(from: info.tenancy_start)
                let moving_end = formatter.date(from: info.tenancy_end)
                formatter.dateFormat = "dd/MM/yy"
                
                let moving_dateStr = formatter.string(from: moving_date ?? Date())
                let moving_startStr = formatter.string(from: moving_start ?? Date())
                let moving_endStr = formatter.string(from: moving_end ?? Date())
                
                cell.lbl_TicketNo.text = info.ticket
                cell.lbl_Status.text = info.status == 0 ? "New" :
                info.status == 1 ? "Cancelled" :
                info.status == 2 ? "In Progress" :
                info.status == 3 ? "Approved" :
                info.status == 4 ? "Rejected" :
                info.status == 5 ? "Payment Pending" :
                info.status == 6 ? "Refunded" : ""
                let unit = info.unit?.unit
                cell.lbl_UnitNo.text = unit == nil ? "" : "#\(unit!)"
                cell.lbl_SubmittedDate.text =  moving_date == nil ? "" : moving_dateStr
                cell.lbl_TenancyStart.text =  moving_start == nil ? "" : moving_startStr
                cell.lbl_TenancyEnd.text =  moving_end == nil ? "" : moving_endStr
                cell.lbl_SubmittedBy.text = info.submitted_by?.name
            }
            else if selectedListType == .updateAddress{
                //            cell.btn_Payment.isHidden = true
                //            cell.btn_Inspection.isHidden = true
                let info = arr_UpdateAddress[indexPath.row]
                
                let moving_date = formatter.date(from: info.submission.request_date)
                let moving_start = formatter.date(from: info.submission.date_of_sign)
                let moving_end = formatter.date(from: info.submission.date_of_sign)
                formatter.dateFormat = "dd/MM/yy"
                
                let moving_dateStr = formatter.string(from: moving_date ?? Date())
                let moving_startStr = formatter.string(from: moving_start ?? Date())
                let moving_endStr = formatter.string(from: moving_end ?? Date())
                
                cell.lbl_TicketNo.text = info.submission.ticket
                cell.lbl_Status.text = info.submission.status == 0 ? "New" :
                info.submission.status == 1 ? "Cancelled" :
                info.submission.status == 2 ? "In Progress" :
                info.submission.status == 3 ? "Approved" :
                info.submission.status == 4 ? "Rejected" :
                info.submission.status == 5 ? "Payment Pending" :
                info.submission.status == 6 ? "Refunded" : ""
                let unit = info.unit?.unit
                cell.lbl_UnitNo.text = unit == nil ? "" : "#\(unit!)"
                cell.lbl_SubmittedDate.text =  moving_date == nil ? "" : moving_dateStr
                //            cell.lbl_TenancyStart.text =  moving_start == nil ? "" : moving_startStr
                //            cell.lbl_TenancyEnd.text =  moving_end == nil ? "" : moving_endStr
                cell.lbl_SubmittedBy.text = info.submission.user?.name
            }
            else if selectedListType == .updateParticulars{
                cell.btn_Payment.isHidden = true
                cell.btn_Inspection.isHidden = true
                let info = arr_UpdateParticulars[indexPath.row]
                
                let moving_date = formatter.date(from: info.submission.request_date)
                let moving_start = formatter.date(from: info.submission.tenancy_start)
                let moving_end = formatter.date(from: info.submission.tenancy_end)
                formatter.dateFormat = "dd/MM/yy"
                
                let moving_dateStr = formatter.string(from: moving_date ?? Date())
                let moving_startStr = formatter.string(from: moving_start ?? Date())
                let moving_endStr = formatter.string(from: moving_end ?? Date())
                
                cell.lbl_TicketNo.text = info.submission.ticket
                cell.lbl_Status.text = info.submission.status == 0 ? "New" :
                info.submission.status == 1 ? "Cancelled" :
                info.submission.status == 2 ? "In Progress" :
                info.submission.status == 3 ? "Approved" :
                info.submission.status == 4 ? "Rejected" :
                info.submission.status == 5 ? "Payment Pending" :
                info.submission.status == 6 ? "Refunded" : ""
                let unit = info.unit?.unit
                cell.lbl_UnitNo.text = unit == nil ? "" : "#\(unit!)"
                cell.lbl_SubmittedDate.text = moving_date == nil ? "" : moving_dateStr
                cell.lbl_TenancyStart.text =  moving_start == nil ? "" : moving_startStr
                cell.lbl_TenancyEnd.text =  moving_end == nil ? "" : moving_endStr
                cell.lbl_SubmittedBy.text = info.submission.user?.name
            }
            
            
            
            return cell
            
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowHt = 0
        switch selectedListType {
        case .contactinfo:

            rowHt = 288
            break
        case .keycollection:

            rowHt = 150
            break
        case .defects:

            rowHt = 305
            break
        case .facilitybooking:

            rowHt = 205
            break
        case .feedback:

            rowHt = 200
            break
        case .moveinout:

            rowHt = 250
            break
        case .renovation:

            rowHt = 250
            break
        case .dooraccess:

            rowHt = 250
            break
        case .vehiclereg:

            rowHt = 250
            break
        case .updateAddress:

            rowHt = 195
            break
        case .updateParticulars:

            rowHt = 250
            break
        case .accesscardmanagement:

            rowHt = 143
            break
        case .visitormanagement:

            rowHt = 200
            break
        case .residentmanagement:

            rowHt = 263
            break
        
      
        case .none:
            rowHt = 0
        }
        return CGFloat(rowHt)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
      
        
        
    }
    
    @IBAction func actionEditKeyCollection(_ sender:UIButton){
        
        let apptInfo = self.array_KeyCollection[sender.tag]
        let editAppointmentVC = kStoryBoardMain.instantiateViewController(identifier: "EditAppointmentTableViewController") as! EditAppointmentTableViewController
        editAppointmentVC.keyCollection = apptInfo
        self.parentVc.navigationController?.pushViewController(editAppointmentVC, animated: true)
        
        
    }
    @IBAction func actionDelete(_ sender: UIButton){
        (self.parentVc as! UnitListTypeTableViewController).userIdToActivate = array_ContactInfo[sender.tag].id
        (self.parentVc as! UnitListTypeTableViewController).showDeleteAlert()
        
    }
    
    @IBAction func actionDeleteDefect(_ sender:UIButton){
        //  (self.parentVc as! DefectsListTableViewController).showDeleteAlert(deleteIndx:sender.tag)
    }
    @IBAction func actionInspection(_ sender:UIButton){
        let submittedDefectsVC = kStoryBoardMain.instantiateViewController(identifier: "SubmittedDefectsListTableViewController") as! SubmittedDefectsListTableViewController
        submittedDefectsVC.defect =  array_Defects[sender.tag]
        submittedDefectsVC.unitsData = self.unitsData
        self.parentVc.navigationController?.pushViewController(submittedDefectsVC, animated: true)
        
    }
    @IBAction func actionHandover(_ sender:UIButton){
        let submittedDefectsVC = kStoryBoardMain.instantiateViewController(identifier: "DefectHandoverTableViewController") as! DefectHandoverTableViewController
        submittedDefectsVC.defect =  array_Defects[sender.tag]
        submittedDefectsVC.unitsData = self.unitsData
        self.parentVc.navigationController?.pushViewController(submittedDefectsVC, animated: true)
        
    }
    @IBAction func actionEditDefect(_ sender:UIButton){
        let submittedDefectsVC = kStoryBoardMain.instantiateViewController(identifier: "SubmittedDefectsListTableViewController") as! SubmittedDefectsListTableViewController
        
        self.parentVc.navigationController?.pushViewController(submittedDefectsVC, animated: true)
        
    }
    @IBAction func actionEditFeedback(_ sender:UIButton){
        let feedback = array_Feedback[sender.tag]
        let feedbackDetailsVC = kStoryBoardMain.instantiateViewController(identifier: "FeedbackDetailsTableViewController") as! FeedbackDetailsTableViewController
        feedbackDetailsVC.feedback = feedback
        feedbackDetailsVC.unitsData = unitsData
        self.parentVc.navigationController?.pushViewController(feedbackDetailsVC, animated: true)
        
    }
    
    @IBAction func actionEditFacility(_ sender:UIButton){
        let facility = array_FacilityBooking[sender.tag]
        let editFacilityVC = kStoryBoardMain.instantiateViewController(identifier: "EditFacilityTableViewController") as! EditFacilityTableViewController
        editFacilityVC.facility = facility
        self.parentVc.navigationController?.pushViewController(editFacilityVC, animated: true)
        
    }
    @IBAction func actionInspectionEForm(_ sender:UIButton){
        if selectedListType == .moveinout {
            (self.parentVc as! UnitListTypeTableViewController).getInfo_MoveInOut(id: arr_MoveInOut[sender.tag].submission.id, redirection: .inspection, index: sender.tag)
            
            
        }
        else  if selectedListType == .renovation {
            (self.parentVc as! UnitListTypeTableViewController).getInfo_Renovation(id: arr_Renovation[sender.tag].id, redirection: .inspection, index: sender.tag)
           
            
        }
        else  if selectedListType == .dooraccess {
            (self.parentVc as! UnitListTypeTableViewController).getInfo_DoorAccess(id: arr_DoorAccess[sender.tag].id, redirection: .inspection, index: sender.tag)
          
            
        }
        
    }
    @IBAction func actionPaymentEForm(_ sender:UIButton){
        if selectedListType == .moveinout {
            (self.parentVc as! UnitListTypeTableViewController).getInfo_MoveInOut(id: arr_MoveInOut[sender.tag].submission.id, redirection: .payment, index: sender.tag)

        }
        else  if selectedListType == .renovation {
            (self.parentVc as! UnitListTypeTableViewController).getInfo_Renovation(id: arr_Renovation[sender.tag].id, redirection: .payment, index: sender.tag)

        }
        else  if selectedListType == .dooraccess {
            (self.parentVc as! UnitListTypeTableViewController).getInfo_DoorAccess(id: arr_DoorAccess[sender.tag].id, redirection: .payment, index: sender.tag)

        }
    }
    @IBAction func actionActivate(_ sender: UIButton){
        
        let user = array_ContactInfo[sender.tag]
        if user.status == 1{
           
          
            (self.parentVc as! UnitListTypeTableViewController).showActivateAlert(user_id: user.id, isToActivate: false, index: sender.tag)
        }
        else{
            (self.parentVc as! UnitListTypeTableViewController).showActivateAlert(user_id: user.id, isToActivate: true, index: sender.tag)
        }
    }
    @IBAction func actionEditUser(_ sender: UIButton){
        let addUserVC = kStoryBoardMain.instantiateViewController(identifier: "AddUserTableViewController") as! AddUserTableViewController
    addUserVC.isToEdit = true
        let user = array_ContactInfo[sender.tag]
        addUserVC.user = user
        addUserVC.roles = self.roles
        addUserVC.country_id = user.userinfo.country
        addUserVC.role_id = user.role_id
        self.parentVc.navigationController?.pushViewController(addUserVC, animated: true)
    }
    @IBAction func actionEditCard(_ sender:UIButton){
        let card = array_Cards[sender.tag]
        let editCardTVC = kStoryBoardMenu.instantiateViewController(identifier: "AddEditCard_DeviceTableViewController") as! AddEditCard_DeviceTableViewController
        editCardTVC.cardInfo = card
        editCardTVC.isToEdit = true
        editCardTVC.isCardAccess = true
        editCardTVC.unitsData = unitsData
        self.parentVc.navigationController?.pushViewController(editCardTVC, animated: true)
//
    }
    @IBAction func actionEditEForm(_ sender:UIButton){
        if selectedListType == .moveinout {
            (self.parentVc as! UnitListTypeTableViewController).getInfo_MoveInOut(id: arr_MoveInOut[sender.tag].submission.id, redirection: .edit, index: sender.tag)

        }
        else  if selectedListType == .renovation {
            (self.parentVc as! UnitListTypeTableViewController).getInfo_Renovation(id: arr_Renovation[sender.tag].id, redirection: .edit, index: sender.tag)
           
        }
        else  if selectedListType == .dooraccess {
            (self.parentVc as! UnitListTypeTableViewController).getInfo_DoorAccess(id: arr_DoorAccess[sender.tag].id, redirection: .edit, index: sender.tag)

           
        }
        else  if selectedListType == .vehiclereg {
            (self.parentVc as! UnitListTypeTableViewController).getInfo_VehicleReg(id: arr_VehicleReg[sender.tag].submission.id, redirection: .edit, index: sender.tag)

        }
        else  if selectedListType == .updateAddress {
            
            let renovationDetailsTVC = kStoryBoardMenu.instantiateViewController(identifier: "UpdateAddressTableViewController") as! UpdateAddressTableViewController
            renovationDetailsTVC.updateAddressData = arr_UpdateAddress[sender.tag]
            self.parentVc.navigationController?.pushViewController(renovationDetailsTVC, animated: true)
           
        }
        else  if selectedListType == .updateParticulars {
            
            let renovationDetailsTVC = kStoryBoardMenu.instantiateViewController(identifier: "UpdateParticularsTableViewController") as! UpdateParticularsTableViewController
            renovationDetailsTVC.updateParticularsData = arr_UpdateParticulars[sender.tag]
            self.parentVc.navigationController?.pushViewController(renovationDetailsTVC, animated: true)
           
        }
    }
    @IBAction func actionEditVisitor(_ sender:UIButton){
        let visitor = array_Visitors[sender.tag]
        let editVisitorVC = kStoryBoardMenu.instantiateViewController(identifier: "VisitorDetaisTableViewController") as! VisitorDetaisTableViewController
        editVisitorVC.visitor = visitor
        self.parentVc.navigationController?.pushViewController(editVisitorVC, animated: true)
       
    }
}
extension UnitListTypeTableViewController: MenuViewDelegate{
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

   
extension UnitListTypeTableViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
/*
extension UnitListTypeTableViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array_UnitListsType.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "unittypecell", for: indexPath) as! UnitListTypeCollectionViewCell
        cell.lbl_UnitListType.text = array_UnitListsType[indexPath.item]
        cell.lbl_UnitListType.layer.cornerRadius = 20.0
        cell.lbl_UnitListType.layer.masksToBounds = true
        if indexPath.item == selectedListTypeIndex{
            cell.lbl_UnitListType.textColor = .white
            cell.lbl_UnitListType.backgroundColor = themeColor
        }
        else{
            cell.lbl_UnitListType.textColor = themeColor
            cell.lbl_UnitListType.backgroundColor = .clear
        }
        cell.btn_Type.tag = indexPath.item
        cell.btn_Type.addTarget(self, action: #selector(self.actionSelectType(_:)), for: .touchUpInside)
       // cell.view_Outer.tag = indexPath.item
      //  let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
     //   cell.view_Outer.addGestureRecognizer(tap)
        
        return cell
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
 
        
        }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = array_UnitListsType[indexPath.item]
        
        let font = UIFont(name: "Helvetica", size: 24)
             let fontAttributes = [NSAttributedString.Key.font: font]
                let text = item
             let size = (text as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
        let cellsize = CGSize(width: size.width + 20, height: 60)
        
        return cellsize
        
        
    }
        
    }




*/
extension UnitListTypeTableViewController: AlertViewDelegate{
    func onBackClicked() {
       
    }
    
    func onCloseClicked() {
        
    }
    
    func onOkClicked() {
        if self.isToActivateUser == true{
            self.activateUser(user_id: self.userIdToActivate)
        }
        else if self.isToDeleteUser == true{
            self.deleteUser(user_id: self.userIdToActivate)
        }
        else{
            self.deactivateUser(user_id: self.userIdToActivate)
        }
    }
    
    
}
extension UnitListTypeTableViewController: MessageAlertViewDelegate{
    func onHomeClicked() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func onListClicked() {
        var controller: UIViewController!
        for cntroller in self.navigationController!.viewControllers as Array {
            if cntroller.isKind(of: OpionsTableViewController.self) {
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
    
    }
    
    
}
