//
//  DeviceListTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 20/07/22.
//

import UIKit

class DeviceListTableViewController:  BaseTableViewController {
    let menu: MenuView = MenuView.getInstance
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var lbl_Title: UILabel!
    
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var imgView_Profile: UIImageView!
    @IBOutlet weak var collection_DeviceList: UICollectionView!
    
    var array_devices = [DeviceListModal]()
    var heightSet = false
    var tableHeight: CGFloat = 0
    var isBluetooth: Bool!
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
      
        lbl_Title.text = isBluetooth ? kStaffBluetoothDoorOpen : kStaffRemoteDoorOpen
        setUpCollectionViewLayout()
        self.getDeviceLists()
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view_Background.roundCorners(corners: [.topLeft, .topRight], radius: 25.0)
        self.tableHeight = self.collection_DeviceList.contentSize.height == 0 ? self.collection_DeviceList.contentSize.height + 240 : self.collection_DeviceList.contentSize.height + 240
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
    //MARK:UICOLLECTION VIEW LAYOUT
    func setUpCollectionViewLayout(){
       
     
        
        let layout =  UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let cellWidth = (kScreenSize.width - 70)/CGFloat(2.0)
        let size = CGSize(width: cellWidth, height: 150)
        layout.itemSize = size
        collection_DeviceList.collectionViewLayout = layout
    
        self.collection_DeviceList.reloadData()
        
    }
    //MARK: ******  PARSING *********
    func getDeviceLists(){
        ActivityIndicatorView.show("Loading")
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        //
        ApiService.get_ThinmooDeviceList(isBluetooth: isBluetooth, parameters: ["login_id":userId], completion: { status, result, error in
           
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                 if let response = (result as? DeviceListModalBase){
                    self.array_devices = response.devices
                     DispatchQueue.main.async {
                      
                     self.collection_DeviceList.reloadData()
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
  
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        self.showBottomMenu()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.closeMenu()
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
extension DeviceListTableViewController: MenuViewDelegate{
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
    
    func getThinmooToken(device : DeviceData){
        ActivityIndicatorView.show("Loading")
        let propertyId = kCurrentPropertyId
        ApiService.getThinmooAccessToken(parameters: ["property":propertyId ]) { status, result, error in
           ActivityIndicatorView.hiding()
            if status  && result != nil{
                if let response = (result as? ThinmooTokenBase){
                    
                    let token = response.token
                    self.callRemoteDoorOpen(device: device, token: token)
                    
                }
                
                
            }
            
        
            else if error != nil{
               
            }
            else{
              
            }
        }
    }
    func callRemoteDoorOpen(device : DeviceData, token: String){
        let userId = UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        let propertyId = kCurrentPropertyId
         let url = URL(string: "https://api-cloud.thinmoo.com/sqDoor/extapi/remoteOpenDoor")!
         var request = URLRequest(url: url)
         request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
         request.httpMethod = "POST"
         let parameters: [String: Any] = [
             "accessToken": token,
             "extCommunityUuid": propertyId,
             "devSn": device.devSn,
             "delay":"5",
             "empUuid": userId
         ]
         request.httpBody = parameters.percentEncoded()

         let task = URLSession.shared.dataTask(with: request) { data, response, error in
             guard let data = data,
                 let response = response as? HTTPURLResponse,
                 error == nil else {                                              // check for fundamental networking error
                 print("error", error ?? "Unknown error")
                 return
             }

             guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                 print("statusCode should be 2xx, but is \(response.statusCode)")
                 print("response = \(response)")
               //  self.displayToastMessage("Response: \(response)")
                 return
             }

             let responseString = String(data: data, encoding: .utf8)
            // let str = "{\"code\":0,\"msg\":\"成功\",\"time\":\"50ms\",\"data\":0}"
             let jsonDict = self.convertStringToDictionary(text: responseString!)
             if jsonDict != nil{
                 let msg = jsonDict!["msg"] as? String
                 let code = jsonDict!["code"] as? Int
                 if msg != nil && code != nil{
                 if msg == "成功" || code == 0{
                     DispatchQueue.main.async {
                         self.displayToastMessage("Success")
                     }
                    
                 }
                     else if code == 99999{
                         self.getThinmooToken(device: device)
                     }
                 }
             }
             print("responseString = \(responseString)")
         }

         task.resume()
    }
    func convertStringToDictionary(text: String) -> [String:Any]? {
                      if let data = text.data(using: .utf8) {
                          do {
                              let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]
                              return json
                          } catch {
                              print("Something went wrong")
                          }
                      }
                      return nil
                  }
    func openDoor_Bluetooth(device : DeviceListModal){
        let model = LibDevModel()
       
        model.devSn = device.thinmoo.devSn
        model.devMac = device.thinmoo.devMac
        model.eKey = device.thinmoo.appEkey
        model.devType = Int32(device.thinmoo.deviceModelValue)
        ActivityIndicatorView.show("Loading")

       let returnData = LibDevModel.openDoor(model)
       
        if returnData == 0{
            LibDevModel.onControlOver { ret, msgDict in
                if ret == 0{
                    ActivityIndicatorView.hiding()
                    self.displayToastMessage("Open door success")
             //       self.insertThinmooRecord(device: device, status: 1)
                }
                else{
                    ActivityIndicatorView.hiding()
                   var msg = ""
                    switch ret{
                    case -101:
                        msg  = "Bluetooth on the phone is not turn on"
                    case -104:
                        msg  = "Failed to open the door"
                    case -105:
                        msg  = "No response from Device"
                    case -106:
                        msg  = "Device is not around"
                      default:
                        msg = "\(ret)"
                    }
                    self.displayErrorAlert(alertStr: "Operation device failure - \(msg) ", title: "Oops")
                   // self.insertThinmooRecord(device: device, status: 0)
                }
            }
        }
        else{
            ActivityIndicatorView.hiding()
            var msg = ""
             switch returnData{
             case -101:
                 msg  = "Bluetooth on the phone is not turn on"
             case -104:
                 msg  = "Failed to open the door"
             case -105:
                 msg  = "No response from Device"
             case -106:
                 msg  = "Device is not around"
               default:
                 msg = "\(returnData)"
             }
             self.displayErrorAlert(alertStr: "Operation device failure - \(msg) ", title: "Oops")
            
          //  self.displayToastMessage("Operation device failure，ret= \(returnData)")
     //       self.insertThinmooRecord(device: device, status: 0)
        }
    }
    
}



extension DeviceListTableViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array_devices.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "deviceCell", for: indexPath) as! DeviceCollectionViewCell
   
        cell.view_Outer.layer.cornerRadius = 15.0

        cell.view_Outer.tag = indexPath.item
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        cell.view_Outer.addGestureRecognizer(tap)
        
    
        let device = array_devices[indexPath.row]
        cell.view_Bg.layer.cornerRadius = 45
        cell.view_Bg.layer.masksToBounds = true
        
        cell.lbl_DeviceName.text = device.thinmoo.devName
        cell.view_Outer.tag = indexPath.item
        cell.btn_icon.tag = indexPath.item
        cell.btn_icon.addTarget(self, action: #selector(self.actionIcon(_:)), for: .primaryActionTriggered)
        return cell
    }
    @IBAction func actionIcon(_ sender: UIButton){
        if self.isBluetooth{
        let device = array_devices[sender.tag]
       
            self.openDoor_Bluetooth(device: device)
        }
        else{
            let device = array_devices[sender.tag]
            self.getThinmooToken(device: device.thinmoo)
        }
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if self.isBluetooth{
        let device = array_devices[(sender! as UITapGestureRecognizer).view!.tag]
       
            self.openDoor_Bluetooth(device: device)
        }
        else{
            let device = array_devices[(sender! as UITapGestureRecognizer).view!.tag]
            self.getThinmooToken(device: device.thinmoo)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
    


extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
