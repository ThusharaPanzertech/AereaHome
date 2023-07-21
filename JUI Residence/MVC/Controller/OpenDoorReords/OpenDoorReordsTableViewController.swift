//
//  OpenDoorReordsTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 15/03/23.
//

import UIKit
import DropDown

var selectedRowIndex_DoorRecords = -1
class OpenDoorReordsTableViewController:  BaseTableViewController {
    
    
    
    //Outlets
    @IBOutlet weak var lbl_NoRecords: UILabel!
         
    @IBOutlet weak var view_SwitchProperty: UIView!
    @IBOutlet weak var lbl_SwitchProperty: UILabel!
    @IBOutlet weak var datePicker:  UIDatePicker!
    @IBOutlet weak var timePicker:  UIDatePicker!

    @IBOutlet weak var txt_DeviceName: UITextField!
    @IBOutlet weak var txt_Unit: UITextField!
    @IBOutlet weak var txt_OpenDoorType: UITextField!
    @IBOutlet weak var txt_Name: UITextField!
    @IBOutlet weak var txt_StartDate: UITextField!
    @IBOutlet weak var txt_StartTime: UITextField!
    @IBOutlet weak var txt_EndDate: UITextField!
    @IBOutlet weak var txt_EndTime: UITextField!
    
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var imgView_Profile: UIImageView!
    @IBOutlet var arr_Textfields: [UITextField]!
   
    @IBOutlet weak var lbl_Title: UILabel!
    
    var opendoorType: DoorRecordType!
    var openType = "0"
    let menu: MenuView = MenuView.getInstance
    @IBOutlet weak var table_OpenDoorRecordList: UITableView!
    var dataSource = DataSource_OpenDoorList()
    var unitsData = [Unit]()
    var array_RemoteDoorRecord = [DoorRecord]()
    var array_BluetoothDoorRecord = [BluetoothDoorRecordModal]()
    var array_FailedDoorRecord = [FailedDoorRecordModal]()
    var array_CallUnitDoorRecord = [CallUnitDoorRecordModal]()
    var array_QRCodeDoorRecord = [QRCodeDoorRecordModal]()

    var arr_OpenType = [String: String]()
    var arr_Devices = [String: String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        lbl_NoRecords.isHidden = true
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
        table_OpenDoorRecordList.dataSource = dataSource
        table_OpenDoorRecordList.delegate = dataSource
        dataSource.parentVc = self
        dataSource.unitsData = self.unitsData
        dataSource.opendoorType = self.opendoorType
        setUpUI()
        self.configureDatePicker()
        
    }
    func getSummary(){
        if self.opendoorType == .remote{
            getRemoteSummary()
        }
        else if self.opendoorType == .bluetooth{
            getBluetoothSummary()
        }
        else if self.opendoorType == .failed{
            getFailedSummary()
        }
        else if self.opendoorType == .callunit{
            getCallUnitSummary()
        }
        else if self.opendoorType == .qrcode{
            getqrCodeSummary()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedRowIndex_DoorRecords = -1
        self.showBottomMenu()
        self.getSummary()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.closeMenu()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var count = 0
        var rowHt = 0
        switch opendoorType{
        case .remote:
            count = array_RemoteDoorRecord.count
            rowHt = 288
            break
        case .bluetooth:
            count = array_BluetoothDoorRecord.count
            rowHt = 288
            break
        case .failed:
            count = array_FailedDoorRecord.count
            rowHt = 341
            break
        case .callunit:
            count = array_CallUnitDoorRecord.count
            rowHt = 288
            break
        case .qrcode:
            count = array_QRCodeDoorRecord.count
            rowHt = 288
            break
        case .none:
            break
        }
        if indexPath.row == 6{
            let ht = selectedRowIndex_DoorRecords == -1  ?  (count * 140) + 50 : ((count - 1) * 140) + 50 + rowHt
            return CGFloat(ht)
        }
        else if indexPath.row == 1{
            return opendoorType == .remote ? super.tableView(tableView, heightForRowAt: indexPath) :
            opendoorType == .bluetooth ? super.tableView(tableView, heightForRowAt: indexPath) :
            opendoorType == .failed ? super.tableView(tableView, heightForRowAt: indexPath) :
            opendoorType == .callunit ? super.tableView(tableView, heightForRowAt: indexPath) :
            super.tableView(tableView, heightForRowAt: indexPath)
        }
        else if indexPath.row == 2{
            return opendoorType == .remote ? 0 :
            opendoorType == .bluetooth ? super.tableView(tableView, heightForRowAt: indexPath) :
            opendoorType == .failed ? super.tableView(tableView, heightForRowAt: indexPath) :
            opendoorType == .callunit ? super.tableView(tableView, heightForRowAt: indexPath) :
            super.tableView(tableView, heightForRowAt: indexPath)
        }
        else if indexPath.row == 3{
            return opendoorType == .remote ? 0 :
            opendoorType == .bluetooth ? super.tableView(tableView, heightForRowAt: indexPath) :
            opendoorType == .failed ? super.tableView(tableView, heightForRowAt: indexPath) :
            opendoorType == .callunit ? 0 :
            0
            
        }
        else if indexPath.row == 4{
            return opendoorType == .remote ? super.tableView(tableView, heightForRowAt: indexPath) :
            opendoorType == .bluetooth ? 0 :
            opendoorType == .failed ? 0 :
            opendoorType == .callunit ? 0 :
            0
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
       
        var title = ""
        switch opendoorType{
        case .remote:
            title = "Digital Access - Open Door Record"
            break
        case .bluetooth:
            title = "Bluetooth - Open Door Record"
            break
        case .failed:
            title = "Failed Open Door Record"
            break
        case .callunit:
            title = "Call Unit Record"
            break
        case .qrcode:
            title = "QR Code Open Door Record"
            break
        case .none:
            break
        }
        lbl_Title.text = title
    }
func configureDatePicker(){
  //Formate Date
  
    //Formate Date
      datePicker.datePickerMode = .date
     
//        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
      let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
       let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

      toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)

      let toolbar1 = UIToolbar();
      toolbar1.sizeToFit()
      let doneButton1 = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker1));
    

    toolbar1.setItems([cancelButton,spaceButton,doneButton1], animated: false)
 // add toolbar to textField
      txt_StartDate.inputAccessoryView = toolbar
     txt_EndDate.inputAccessoryView = toolbar
  // add datepicker to textField
    txt_StartDate.inputView = datePicker
    txt_EndDate.inputView = datePicker
      
      
      
      timePicker.datePickerMode = .time
      txt_StartTime.inputAccessoryView = toolbar1
    txt_EndTime.inputAccessoryView = toolbar1
      txt_StartTime.inputView = timePicker
    txt_EndTime.inputView = timePicker
    
    
}
@objc func donedatePicker(){
    
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd/MM/yy"
    
    if txt_StartDate.isFirstResponder{
        txt_StartDate.text = formatter.string(from: datePicker.date)
    }
    else{
        txt_EndDate.text = formatter.string(from: datePicker.date)
    }
    
        self.view.endEditing(true)
    
  
    
}
    @objc func donedatePicker1(){
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "hh:mm a"
        if txt_StartTime.isFirstResponder{
            txt_StartTime.text = formatter.string(from: timePicker.date)
        }
        else{
            txt_EndTime.text = formatter.string(from: timePicker.date)
        }
        
    
       
            self.view.endEditing(true)
        
    }

@objc func cancelDatePicker(){
   self.view.endEditing(true)
 }
    //MARK: ******  PARSING *********
   
   
    func getRemoteSummary(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.get_NormalDoorRecord(parameters: ["login_id":userId], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? DoorRecordsBase){
                    self.array_RemoteDoorRecord = response.data
                     self.arr_OpenType = response.types
                     self.arr_Devices = response.devices
                     self.dataSource.array_RemoteDoorRecord = self.array_RemoteDoorRecord

                     self.dataSource.arr_OpenType = self.arr_OpenType
                     
                     if self.array_RemoteDoorRecord.count == 0{
                         self.lbl_NoRecords.isHidden = false
                     }
                     else{
                         self.lbl_NoRecords.isHidden = true
                     }
                    self.table_OpenDoorRecordList.reloadData()
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
    func searchRemoteSummary(){
        
        if txt_DeviceName.text == "" && txt_OpenDoorType.text == "" && txt_StartDate.text == "" && txt_EndDate.text == ""{
            self.getSummary()
        }
        
        else{
            
            
            
            
            ActivityIndicatorView.show("Loading")
            let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
            let doorName = txt_DeviceName.text!
            let eventType = openType
            var dateStr_start = ""
            var dateStr_end = ""
            if txt_StartDate.text!.count > 0{
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.dateFormat = "dd/MM/yy"
                let date_start = formatter.date(from: txt_StartDate.text! )
                formatter.dateFormat = "yyyy-MM-dd"
                dateStr_start = formatter.string(from: date_start ??  Date())
            }
            
            if txt_EndDate.text!.count > 0{
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.dateFormat = "dd/MM/yy"
                let date_start = formatter.date(from: txt_EndDate.text! )
                formatter.dateFormat = "yyyy-MM-dd"
                dateStr_end = formatter.string(from: date_start ??  Date())
            }
            
            
            //
            ApiService.search_NormalDoorRecord(parameters: ["login_id":userId, "doorName": doorName, "eventType": eventType, "startDate": dateStr_start, "endDate": dateStr_end], completion: { status, result, error in
                
                ActivityIndicatorView.hiding()
                if status  && result != nil{
                    if let response = (result as? DoorRecordsBase){
                        self.array_RemoteDoorRecord = response.data
                        
                        self.dataSource.array_RemoteDoorRecord = self.array_RemoteDoorRecord
                        
                        if self.array_RemoteDoorRecord.count == 0{
                            self.lbl_NoRecords.isHidden = false
                        }
                        else{
                            self.lbl_NoRecords.isHidden = true
                        }
                        self.table_OpenDoorRecordList.reloadData()
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
    }
    func getBluetoothSummary(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.get_BluetoothDoorRecord(parameters: ["login_id":userId], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? BluetoothDoorRecordsBase){
                    self.array_BluetoothDoorRecord = response.data
                    
                     self.dataSource.array_BluetoothDoorRecord = self.array_BluetoothDoorRecord
                     self.arr_Devices = response.devices
                     if self.array_BluetoothDoorRecord.count == 0{
                         self.lbl_NoRecords.isHidden = false
                     }
                     else{
                         self.lbl_NoRecords.isHidden = true
                     }
                    self.table_OpenDoorRecordList.reloadData()
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
    func searchBluetoothSummary(){
        
        
        
        if txt_DeviceName.text == "" && txt_Unit.text == ""  && txt_Name.text == "" && txt_StartDate.text == "" && txt_EndDate.text == ""{
            self.getSummary()
        }
        
        else{
            
            
            
            
            ActivityIndicatorView.show("Loading")
            let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
            let doorName = txt_DeviceName.text!
           
            var dateStr_start = ""
            var dateStr_end = ""
            if txt_StartDate.text!.count > 0{
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.dateFormat = "dd/MM/yy"
                let date_start = formatter.date(from: txt_StartDate.text! )
                formatter.dateFormat = "yyyy-MM-dd"
                dateStr_start = formatter.string(from: date_start ??  Date())
            }
            
            if txt_EndDate.text!.count > 0{
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.dateFormat = "dd/MM/yy"
                let date_start = formatter.date(from: txt_EndDate.text! )
                formatter.dateFormat = "yyyy-MM-dd"
                dateStr_end = formatter.string(from: date_start ??  Date())
            }
            
            
            
            ApiService.search_BluetoothDoorRecord(parameters: ["login_id":userId, "doorName": doorName, "unit": txt_Unit.text!,"name": txt_Name.text!, "startDate": dateStr_start, "endDate": dateStr_end], completion: { status, result, error in
                
                ActivityIndicatorView.hiding()
                if status  && result != nil{
                    if let response = (result as? BluetoothDoorRecordsBase){
                        self.array_BluetoothDoorRecord = response.data
                        if self.array_BluetoothDoorRecord.count == 0{
                            self.lbl_NoRecords.isHidden = false
                        }
                        else{
                            self.lbl_NoRecords.isHidden = true
                        }
                        self.dataSource.array_BluetoothDoorRecord = self.array_BluetoothDoorRecord
                        
                        
                        self.table_OpenDoorRecordList.reloadData()
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
    }
    func getFailedSummary(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.get_FailedDoorRecord(parameters: ["login_id":userId], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? FailedDoorRecordsBase){
                    self.array_FailedDoorRecord = response.data
                     self.arr_Devices = response.devices
                     self.dataSource.array_FailedDoorRecord = self.array_FailedDoorRecord
                     if self.array_FailedDoorRecord.count == 0{
                         self.lbl_NoRecords.isHidden = false
                     }
                     else{
                         self.lbl_NoRecords.isHidden = true
                     }
                     
                    self.table_OpenDoorRecordList.reloadData()
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
    func searchFailedSummary(){
        if txt_DeviceName.text == "" && txt_Unit.text == ""  && txt_Name.text == "" && txt_StartDate.text == "" && txt_EndDate.text == ""{
            self.getSummary()
        }
        
        else{
            
            
            
            
            ActivityIndicatorView.show("Loading")
            let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
            let doorName = txt_DeviceName.text!
            
            var dateStr_start = ""
            var dateStr_end = ""
            if txt_StartDate.text!.count > 0{
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.dateFormat = "dd/MM/yy"
                let date_start = formatter.date(from: txt_StartDate.text! )
                formatter.dateFormat = "yyyy-MM-dd"
                dateStr_start = formatter.string(from: date_start ??  Date())
            }
            
            if txt_EndDate.text!.count > 0{
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.dateFormat = "dd/MM/yy"
                let date_start = formatter.date(from: txt_EndDate.text! )
                formatter.dateFormat = "yyyy-MM-dd"
                dateStr_end = formatter.string(from: date_start ??  Date())
            }
            
            ApiService.search_FailedDoorRecord(parameters:  ["login_id":userId, "doorName": doorName, "unit": txt_Unit.text!,"name": txt_Name.text!, "startDate": dateStr_start, "endDate": dateStr_end], completion: { status, result, error in
                
                ActivityIndicatorView.hiding()
                if status  && result != nil{
                    if let response = (result as? FailedDoorRecordsBase){
                        self.array_FailedDoorRecord = response.data
                        
                        self.dataSource.array_FailedDoorRecord = self.array_FailedDoorRecord
                        
                        if self.array_FailedDoorRecord.count == 0{
                            self.lbl_NoRecords.isHidden = false
                        }
                        else{
                            self.lbl_NoRecords.isHidden = true
                        }
                        self.table_OpenDoorRecordList.reloadData()
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
    }

    func getCallUnitSummary(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.get_CallUnitDoorRecord(parameters: ["login_id":userId], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? CallUnitDoorRecordsBase){
                    self.array_CallUnitDoorRecord = response.data
                     self.arr_Devices = response.devices
                     self.dataSource.array_CallUnitDoorRecord = self.array_CallUnitDoorRecord
                     if self.array_CallUnitDoorRecord.count == 0{
                         self.lbl_NoRecords.isHidden = false
                     }
                     else{
                         self.lbl_NoRecords.isHidden = true
                     }
                     
                    self.table_OpenDoorRecordList.reloadData()
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
    func searchCallUnitSummary(){
        if txt_DeviceName.text == "" && txt_Unit.text == "" && txt_StartDate.text == "" && txt_EndDate.text == ""{
            self.getSummary()
        }
        
        else{
            
            
            
            
            ActivityIndicatorView.show("Loading")
            let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
            let doorName = txt_DeviceName.text!
            
            var dateStr_start = ""
            var dateStr_end = ""
            if txt_StartDate.text!.count > 0{
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.dateFormat = "dd/MM/yy"
                let date_start = formatter.date(from: txt_StartDate.text! )
                formatter.dateFormat = "yyyy-MM-dd"
                dateStr_start = formatter.string(from: date_start ??  Date())
            }
            
            if txt_EndDate.text!.count > 0{
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.dateFormat = "dd/MM/yy"
                let date_start = formatter.date(from: txt_EndDate.text! )
                formatter.dateFormat = "yyyy-MM-dd"
                dateStr_end = formatter.string(from: date_start ??  Date())
            }
            ApiService.search_CallUnitDoorRecord(parameters:  ["login_id":userId, "doorName": doorName, "unit": txt_Unit.text!,"name": txt_Name.text!, "startDate": dateStr_start, "endDate": dateStr_end], completion: { status, result, error in
                
                ActivityIndicatorView.hiding()
                if status  && result != nil{
                    if let response = (result as? CallUnitDoorRecordsBase){
                        self.array_CallUnitDoorRecord = response.data
                        
                        self.dataSource.array_CallUnitDoorRecord = self.array_CallUnitDoorRecord
                        if self.array_CallUnitDoorRecord.count == 0{
                            self.lbl_NoRecords.isHidden = false
                        }
                        else{
                            self.lbl_NoRecords.isHidden = true
                        }
                        
                        self.table_OpenDoorRecordList.reloadData()
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
    }
    func getqrCodeSummary(){
        ActivityIndicatorView.show("Loading")
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.get_QRCodeDoorRecord(parameters: ["login_id":userId], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? QRCodeDoorRecordsBase){
                    self.array_QRCodeDoorRecord = response.data
                    
                     self.dataSource.array_QRCodeDoorRecord = self.array_QRCodeDoorRecord
                     if self.array_QRCodeDoorRecord.count == 0{
                         self.lbl_NoRecords.isHidden = false
                     }
                     else{
                         self.lbl_NoRecords.isHidden = true
                     }
                     
                    self.table_OpenDoorRecordList.reloadData()
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
    func searchqrCodeSummary(){
        if txt_DeviceName.text == "" && txt_Unit.text == "" && txt_StartDate.text == "" && txt_EndDate.text == ""{
            self.getSummary()
        }
        
        else{
            
            
            
            
            ActivityIndicatorView.show("Loading")
            let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
            let doorName = txt_DeviceName.text!
            
            var dateStr_start = ""
            var dateStr_end = ""
            if txt_StartDate.text!.count > 0{
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.dateFormat = "dd/MM/yy"
                let date_start = formatter.date(from: txt_StartDate.text! )
                formatter.dateFormat = "yyyy-MM-dd"
                dateStr_start = formatter.string(from: date_start ??  Date())
            }
            
            if txt_EndDate.text!.count > 0{
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.dateFormat = "dd/MM/yy"
                let date_start = formatter.date(from: txt_EndDate.text! )
                formatter.dateFormat = "yyyy-MM-dd"
                dateStr_end = formatter.string(from: date_start ??  Date())
            }
            ApiService.get_QRCodeDoorRecord(parameters:  ["login_id":userId, "doorName": doorName, "unit": txt_Unit.text!,"name": txt_Name.text!, "startDate": dateStr_start, "endDate": dateStr_end], completion: { status, result, error in
                
                ActivityIndicatorView.hiding()
                if status  && result != nil{
                    if let response = (result as? QRCodeDoorRecordsBase){
                        self.array_QRCodeDoorRecord = response.data
                        
                        self.dataSource.array_QRCodeDoorRecord = self.array_QRCodeDoorRecord
                        if self.array_QRCodeDoorRecord.count == 0{
                            self.lbl_NoRecords.isHidden = false
                        }
                        else{
                            self.lbl_NoRecords.isHidden = true
                        }
                        
                        self.table_OpenDoorRecordList.reloadData()
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
    }
    //MARK: UIBUTTON ACTION
    @IBAction func actionSearch(_ sender:UIButton) {
        if opendoorType == .remote{
            self.searchRemoteSummary()
        }
        else if opendoorType == .bluetooth{
            self.searchBluetoothSummary()
        }
        else if opendoorType == .failed{
            self.searchFailedSummary()
        }
        else if opendoorType == .callunit{
            self.searchCallUnitSummary()
        }
        else if opendoorType == .qrcode{
            self.searchqrCodeSummary()
        }
    }
    @IBAction func actionClear(_ sender:UIButton) {
        self.txt_Unit.text = ""
        txt_EndDate.text = ""
        txt_Name.text = ""
        txt_StartDate.text = ""
        txt_EndTime.text = ""
        txt_StartTime.text = ""
        txt_DeviceName.text = ""
        txt_OpenDoorType.text = ""
        getSummary()
        
        
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
      //  let sortedArray = unitsData.sorted(by:  { $0.1 < $1.1 })
        let arrUnit = unitsData.map { $0.unit }
        let dropDown_Unit = DropDown()
        dropDown_Unit.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Unit.dataSource = arrUnit// Array(unitsData.values)
        dropDown_Unit.show()
        dropDown_Unit.selectionAction = { [unowned self] (index: Int, item: String) in
           
            txt_Unit.text = item
           
            
        }
    }
    @IBAction func actionDevices(_ sender:UIButton) {
      //  let sortedArray = unitsData.sorted(by:  { $0.1 < $1.1 })
        let arrUnit = arr_Devices.sorted { $0.key < $1.key }
        let sortedArray = arrUnit.map { $0.value }
        let dropDown_Unit = DropDown()
        dropDown_Unit.anchorView = sender // UIView or UIBarButtonItem
        dropDown_Unit.dataSource = sortedArray
        dropDown_Unit.show()
        dropDown_Unit.selectionAction = { [unowned self] (index: Int, item: String) in
           
            txt_DeviceName.text = item
           
            
        }
    }
    
    @IBAction func actionVisitingPurpose(_ sender:UIButton) {
       
    }
  @IBAction func actionOpenDoorType(_ sender:UIButton) {
      let arrUnit = arr_OpenType.sorted { $0.key < $1.key }
      let sortedArray = arrUnit.map { $0.value }
    let dropDown_arrOptions = DropDown()
      dropDown_arrOptions.anchorView = sender // UIView or UIBarButtonItem
      dropDown_arrOptions.dataSource = sortedArray
      dropDown_arrOptions.show()
      dropDown_arrOptions.selectionAction = { [unowned self] (index: Int, item: String) in
//        txt_BookingType.text = item
//
//          bookingType = "\(index + 1)"
          
          txt_OpenDoorType.text = item
          openType = arrUnit[index].key
          
    }
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
class DataSource_OpenDoorList: NSObject, UITableViewDataSource, UITableViewDelegate {
    var unitsData = [Unit]()
    var facilityOptions = [String: String]()
    var parentVc: UIViewController!
    var array_RemoteDoorRecord = [DoorRecord]()
    var array_BluetoothDoorRecord = [BluetoothDoorRecordModal]()
    var array_FailedDoorRecord = [FailedDoorRecordModal]()
    var array_CallUnitDoorRecord = [CallUnitDoorRecordModal]()
    var array_QRCodeDoorRecord = [QRCodeDoorRecordModal]()
    var opendoorType: DoorRecordType!
    var arr_OpenType = [String: String]()
func numberOfSectionsInTableView(tableView: UITableView) -> Int {

    return 1;
}

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
         var count = 0
         switch opendoorType{
         case .remote:
             count = array_RemoteDoorRecord.count
             break
         case .bluetooth:
             count = array_BluetoothDoorRecord.count
             break
         case .failed:
             count = array_FailedDoorRecord.count
             break
         case .callunit:
             count = array_CallUnitDoorRecord.count
             break
         case .qrcode:
             count = array_QRCodeDoorRecord.count
             break
         case .none:
             break
         }
         
         return  count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if opendoorType == .remote{
            let cell = tableView.dequeueReusableCell(withIdentifier: "normalRecordCell") as! NormalDoorRecordTableViewCell
            cell.img_Arrow.image = indexPath.row == selectedRowIndex_DoorRecords ? UIImage(named: "up_arrow") : UIImage(named: "down_arrow")
            cell.selectionStyle = .none
            
            cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
           
            cell.view_Outer.tag = indexPath.row
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            cell.view_Outer.addGestureRecognizer(tap)
            
            if indexPath.row != selectedRowIndex_DoorRecords{
                for vw in cell.arrViews{
                    vw.isHidden = true
                }
            }
            else{
                for vw in cell.arrViews{
                    vw.isHidden = false
                }
            }
            let data = array_RemoteDoorRecord[indexPath.row]
            
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let expdate = formatter.date(from: data.eventTime)
            formatter.dateFormat = "dd/MM/yy"
            let expdateStr = formatter.string(from: expdate ?? Date())
            cell.lbl_Opendoordate.text = expdateStr
            
            formatter.dateFormat = "hh:mm a"
            let expdateStr1 = formatter.string(from: expdate ?? Date())
            cell.lbl_Time.text = expdateStr1
            
            
            
            cell.lbl_DeviceName.text = data.devName
            
            cell.lbl_DeviceNo.text = data.devSn
            cell.lbl_PersonName.text =  data.empName
            let type = data.eventType
            
            cell.lbl_OpenDoorType.text = arr_OpenType["\(type)"]
           
            
            return cell
        }
        else if opendoorType == .bluetooth{
            let cell = tableView.dequeueReusableCell(withIdentifier: "bluetoothRecordCell") as! BluetoothDoorRecordTableViewCell
            cell.img_Arrow.image = indexPath.row == selectedRowIndex_DoorRecords ? UIImage(named: "up_arrow") : UIImage(named: "down_arrow")
            cell.view_Outer.tag = indexPath.row
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            cell.view_Outer.addGestureRecognizer(tap)
            cell.selectionStyle = .none
            
            cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
           
           
            if indexPath.row != selectedRowIndex_DoorRecords{
                for vw in cell.arrViews{
                    vw.isHidden = true
                }
            }
            else{
                for vw in cell.arrViews{
                    vw.isHidden = false
                }
            }
            let data = array_BluetoothDoorRecord[indexPath.row]
            
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let expdate = formatter.date(from: data.record.created_at)
            formatter.dateFormat = "dd/MM/yy"
            let expdateStr = formatter.string(from: expdate ?? Date())
            cell.lbl_Opendoordate.text = expdateStr
            
            formatter.dateFormat = "hh:mm a"
            let expdateStr1 = formatter.string(from: expdate ?? Date())
            cell.lbl_Time.text = expdateStr1
            
            
            
            cell.lbl_Unit.text = data.unitinfo
            
            cell.lbl_DeviceNo.text = data.record.devSn
            cell.lbl_PersonName.text =  data.record.user?.name
 
            cell.lbl_DeviceName.text = data.record.devName
            cell.lbl_Action.text = data.action
            cell.lbl_Status.text = data.status
           
            
            return cell
        }
        else if opendoorType == .failed{
            let cell = tableView.dequeueReusableCell(withIdentifier: "failedRecordCell") as! FailedDoorRecordTableViewCell
            cell.img_Arrow.image = indexPath.row == selectedRowIndex_DoorRecords ? UIImage(named: "up_arrow") : UIImage(named: "down_arrow")
            cell.view_Outer.tag = indexPath.row
            cell.selectionStyle = .none
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            cell.view_Outer.addGestureRecognizer(tap)
            cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
           
           
            if indexPath.row != selectedRowIndex_DoorRecords{
                for vw in cell.arrViews{
                    vw.isHidden = true
                }
            }
            else{
                for vw in cell.arrViews{
                    vw.isHidden = false
                }
            }
            let data = array_FailedDoorRecord[indexPath.row]
            
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let expdate = formatter.date(from: data.record.eventtime)
            formatter.dateFormat = "dd/MM/yy"
            let expdateStr = formatter.string(from: expdate ?? Date())
            cell.lbl_Date.text = expdateStr
            
            formatter.dateFormat = "hh:mm a"
            let expdateStr1 = formatter.string(from: expdate ?? Date())
            cell.lbl_Time.text = expdateStr1
            cell.lbl_Unit.text = data.unitinfo
            cell.lbl_Name.text = data.name
            
            
            
            cell.lbl_Device.text = data.record.devname
            
            cell.lbl_DeviceNo.text = data.record.devSn
            cell.lbl_Reason.text =  ""
            
            
            return cell
        }
      else if opendoorType == .callunit{
          let cell = tableView.dequeueReusableCell(withIdentifier: "callUniRecordCell") as! CallUntDoorRecordTableViewCell
          cell.img_Arrow.image = indexPath.row == selectedRowIndex_DoorRecords ? UIImage(named: "up_arrow") : UIImage(named: "down_arrow")
          cell.view_Outer.tag = indexPath.row
          cell.selectionStyle = .none
          let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
          cell.view_Outer.addGestureRecognizer(tap)
          cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
         
         
          if indexPath.row != selectedRowIndex_DoorRecords{
              for vw in cell.arrViews{
                  vw.isHidden = true
              }
          }
          else{
              for vw in cell.arrViews{
                  vw.isHidden = false
              }
          }
          let data = array_CallUnitDoorRecord[indexPath.row]
          
          let formatter = DateFormatter()
          formatter.locale = Locale(identifier: "en_US_POSIX")
          formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
          let expdate = formatter.date(from: data.record.created_at)
          formatter.dateFormat = "dd/MM/yy"
          let expdateStr = formatter.string(from: expdate ?? Date())
          cell.lbl_Date.text = expdateStr
          
          formatter.dateFormat = "hh:mm a"
          let expdateStr1 = formatter.string(from: expdate ?? Date())
          cell.lbl_Time.text = expdateStr1
          
          
          
          cell.lbl_Unit.text = data.unitinfo
          
          cell.lbl_DeviceNo.text = data.record.devSn
         
          
         
          
          return cell
      }
        else{
          let cell = tableView.dequeueReusableCell(withIdentifier: "qrCodeRecordCell") as! QRCodeDoorRecordTableViewCell
            cell.img_Arrow.image = indexPath.row == selectedRowIndex_DoorRecords ? UIImage(named: "up_arrow") : UIImage(named: "down_arrow")
            cell.view_Outer.tag = indexPath.row
          cell.selectionStyle = .none
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            cell.view_Outer.addGestureRecognizer(tap)
          cell.view_Outer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
         
         
          if indexPath.row != selectedRowIndex_DoorRecords{
              for vw in cell.arrViews{
                  vw.isHidden = true
              }
          }
          else{
              for vw in cell.arrViews{
                  vw.isHidden = false
              }
          }
          let data = array_QRCodeDoorRecord[indexPath.row]
          
          let formatter = DateFormatter()
          formatter.locale = Locale(identifier: "en_US_POSIX")
          formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let expdate = formatter.date(from: data.record.created_at)
          formatter.dateFormat = "dd/MM/yy"
          let expdateStr = formatter.string(from: expdate ?? Date())
          cell.lbl_Date.text = expdateStr
          
          formatter.dateFormat = "hh:mm a"
          let expdateStr1 = formatter.string(from: expdate ?? Date())
          cell.lbl_Time.text = expdateStr1
          
          
          
            cell.lbl_BookingId.text = data.record.booking_info.ticket
          
          cell.lbl_Name.text = data.name
            cell.lbl_DeviceNo.text =  data.record.devSn
          
            cell.lbl_Status.text = data.record.message
         
          
          return cell
      }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == selectedRowIndex_DoorRecords ? 265 : 140
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        selectedRowIndex_DoorRecords = (sender! as UITapGestureRecognizer).view!.tag
        DispatchQueue.main.async {
            (self.parentVc as! OpenDoorReordsTableViewController
            ).tableView.reloadData()
        (self.parentVc as! OpenDoorReordsTableViewController).table_OpenDoorRecordList.reloadData()
      
        }
       
       
    }
   
}
extension OpenDoorReordsTableViewController: MenuViewDelegate{
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

   
extension OpenDoorReordsTableViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}







