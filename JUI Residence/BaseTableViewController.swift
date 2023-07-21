//
//  BaseTableViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 24/07/21.
//

import UIKit
import Alamofire
class BaseTableViewController: UITableViewController, UIGestureRecognizerDelegate {

    var activeTextField : UITextField?
    
    var activeTextView : UITextView?
    
    override func viewDidLoad() {
       
        
        super.viewDidLoad()
        
        onScreenLoad()
        
        var frame = UIScreen.main.bounds
        frame.origin.y = -frame.size.height

        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.white

        self.tableView.addSubview(view)
        loadBackgroundImage()
        
        
        
        LoadKeyboardEventHandlers()
       // loadDynamicBackground(screenTime: getScreenTime())
    }
    func convertBase64StringToImage (imageBase64String:String) -> UIImage? {
        let imageData = Data(base64Encoded: imageBase64String)
        let image = UIImage(data: imageData!)
        return image
    }
    func getBackgroundImageName() -> String {
        return ""
    }
    func getPropertyListInfo(){
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
       
        ApiService.switch_Property(parameters: ["login_id":userId, "prop_id": kCurrentPropertyId], completion: { status, result, error in
            if status  && result != nil{
                // if let response = (result as? PropertyListBase){
                     self.getPropList()
               // }
        }
            else if error != nil{
            }
            else{
            }
        })
        
    }
    func getPropList(){
        
        let userId =  UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        ApiService.get_PropertyList(parameters: ["login_id":userId], completion: { status, result, error in
            if status  && result != nil{
                 if let response = (result as? PropertyListBase){
//                     kCurrentPropertyId = response.current_property
//                     let prop = response.data.first(where:{ $0.id == response.current_property})
//                     if prop != nil{
//                        // kCurrentPropertyName = prop!.company_name
//                     }
                }
        }
            else if error != nil{
            }
            else{
            }
        })
    }
    @IBAction func actionBack(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    func LoadKeyboardEventHandlers(){
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
            tap.delegate = self
            view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isKind(of: UITableView.self))! {
            return false
        }
        
        if (touch.view?.superview!.isKind(of: UITableView.self))! {
            return false
        }
        
        if (touch.view?.isKind(of: UITableViewCell.self))! {
            return false
        }
        
        if (touch.view?.superview!.isKind(of: UITableViewCell.self))! {
            return false
        }
        
        if (touch.view?.isKind(of: UICollectionView.self))! {
            return false
        }
        
        if (touch.view?.superview!.isKind(of: UICollectionView.self))! {
            return false
        }
        
        if (touch.view?.isKind(of: UICollectionViewCell.self))! {
            return false
        }
        
        if (touch.view?.superview!.isKind(of: UICollectionViewCell.self))! {
            return false
        }
        return true
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += scrollHeight //keyboardSize.height
            }
        }
    }
    
    var scrollHeight : CGFloat = 0
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if(activeTextField !=  nil){
            let kbSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
            
            var visibleRect = self.view.frame;
            
            visibleRect.size.height =  visibleRect.size.height - (kbSize?.height)!
            
            var point = CGPoint.init(x: (activeTextField?.frame.origin.x)!,
                                     y: ((activeTextField?.frame.origin.y)!+(activeTextField?.frame.size.height)!))
            
            var parentView:UIView = (activeTextField?.superview)!
            var parentYpos:CGFloat = 0
            
            while (parentView != self.view) {
                
                parentYpos += parentView.frame.origin.y
                
                if(parentView.superview != nil){
                    parentView = parentView.superview!
                }
                else{
                    return
                }
            }
            point.y += parentYpos
            
            point.y = point.y + 50
            
            if(!visibleRect.contains(point)){
                if self.view.frame.origin.y == 0{
                    
                    let ypos:CGFloat = (activeTextField?.frame.origin.y)! + parentYpos
                    
                    scrollHeight = GetScrollHeight(ypos: ypos,
                                                   keyboardHeight: (kbSize?.height)!)
                    
                    self.view.frame.origin.y -= scrollHeight
                }
            }
        }
    }
    
    func GetScrollHeight(ypos: CGFloat, keyboardHeight: CGFloat) -> CGFloat {
        var scht = keyboardHeight -  (self.view.frame.size.height - ypos)
        
        scht = scht + 100
        
        return scht
    }
    
    func LMTextFiedBeginEditing(textBox: UITextField){
        activeTextField = textBox
        
    }
  
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    func isValidHtmlString(_ value: String) -> Bool {
        if value.isEmpty {
            return false
        }
        return (value.range(of: "<(\"[^\"]*\"|'[^']*'|[^'\">])*>", options: .regularExpression) != nil)
    }
    
    func onScreenLoad(){
        
    }
    var imageView:UIImageView?
    
    func loadBackgroundImage(){
       
      //  let name = self.getBgName()
            if(imageView == nil){
                imageView = UIImageView()
                
                imageView!.frame = self.view.frame
                
                
                imageView!.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.flexibleBottomMargin.rawValue | UIView.AutoresizingMask.flexibleHeight.rawValue | UIView.AutoresizingMask.flexibleRightMargin.rawValue | UIView.AutoresizingMask.flexibleLeftMargin.rawValue | UIView.AutoresizingMask.flexibleTopMargin.rawValue | UIView.AutoresizingMask.flexibleWidth.rawValue)
                //imageView.contentMode = UIView.ContentMode.center
                
                imageView!.contentMode = UIView.ContentMode.scaleAspectFill
                
             //   tableView.backgroundView = imageView!
               // self.view.sendSubviewToBack(imageView!)
               // imageView!.layer.addSublayer(getBackgroudShadow())
            }
      //  imageView!.image = UIImage(named: "background_sofa")
        if self.getBackgroundImageName().count > 0{
       // if name.count > 0{
            let url = FileDownloader.getDownloadedFile(requestURL: self.getBackgroundImageName())
            
            if(url.count > 3){
                imageView!.image = UIImage(contentsOfFile: url)
            }
            else{
            
            
         /*   if let url = URL(string: "\(kImageFilePath)/" + self.getBackgroundImageName()) {
               imageView!.af_setImage(withURL: url)
               // downloadImage(from: url)
            }*/
            }
        }
        else{
            imageView!.image = UIImage(named: "background_sofa")
        }
            
        
    }
    
  /*  func getBgName() -> String{
        let name = String(describing: type(of: self))
        switch name {
        case "HomeTableViewController":
            return UserInfoModalBase.currentUser?.data.property.default_bg ?? ""
        case "SettingsTableViewController":
            return UserInfoModalBase.currentUser?.data.property.default_bg ?? ""
        case "AnnouncementTableViewController":
            return UserInfoModalBase.currentUser?.data.property.announcement_bg ?? ""
        case "AnnouncementDetailsTableViewController":
            return UserInfoModalBase.currentUser?.data.property.announcement_bg ?? ""
        case "AppointmentUnitTakeOverTableViewController":
            return UserInfoModalBase.currentUser?.data.property.takeover_bg ?? ""
        case "HomeTableViewController1":
            return UserInfoModalBase.currentUser?.data.property.default_bg ?? ""
        case "HomeTableViewController2":
            return UserInfoModalBase.currentUser?.data.property.default_bg ?? ""
        case "HomeTableViewController3":
            return UserInfoModalBase.currentUser?.data.property.default_bg ?? ""
        case "HomeTableViewController4":
            return UserInfoModalBase.currentUser?.data.property.default_bg ?? ""
        case "HomeTableViewController5":
            return UserInfoModalBase.currentUser?.data.property.default_bg ?? ""
        case "HomeTableViewController6":
            return UserInfoModalBase.currentUser?.data.property.default_bg ?? ""
        default:
            return ""
        }
    }*/
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                self?.imageView!.image = UIImage(data: data)
            }
        }
    }
    private func getBackgroudShadow() -> CAGradientLayer{
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = self.view.frame.size
        gradientLayer.colors =
            [
             UIColor.black.withAlphaComponent(0.2).cgColor,
                UIColor.black.withAlphaComponent(0.3).cgColor,
             UIColor.black.withAlphaComponent(0.4).cgColor,
             UIColor.black.withAlphaComponent(0.5).cgColor, UIColor.black.withAlphaComponent(0.6).cgColor, UIColor.black.withAlphaComponent(0.7).cgColor]
        
        return gradientLayer
    }
    
  
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
   
    
    func addDoneButtonOnKeyboard()
    {
        let toolbarDone = UIToolbar.init()
        toolbarDone.sizeToFit()
        
        let barBtnDone = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done,
                                              target: self, action: #selector(doneButtonAction))
        
        toolbarDone.items = [barBtnDone] // You can even add cancel button too
        
        
        if(activeTextField != nil){
            activeTextField?.inputAccessoryView = toolbarDone
        }
    }
    
    @objc func doneButtonAction(){
        self.view.endEditing(true)
    }
    
    func displayToastMessage(_ message : String) {
        
        let toastView = UILabel()
        toastView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastView.textColor = UIColor.white
        toastView.textAlignment = .center
        toastView.font = UIFont.systemFont(ofSize: 14)
        toastView.layer.cornerRadius = 25
        toastView.layer.masksToBounds = true
        toastView.text = message
        toastView.numberOfLines = 0
        toastView.alpha = 0
        toastView.translatesAutoresizingMaskIntoConstraints = false
        
        let window = UIApplication.shared.delegate?.window!
        window?.addSubview(toastView)
        
        let horizontalCenterContraint: NSLayoutConstraint = NSLayoutConstraint(item: toastView, attribute: .centerX, relatedBy: .equal, toItem: window, attribute: .centerX, multiplier: 1, constant: 0)
        
        let widthContraint: NSLayoutConstraint = NSLayoutConstraint(item: toastView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 275)
        
        let verticalContraint: [NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=200)-[loginView(==50)]-68-|", options: [.alignAllCenterX, .alignAllCenterY], metrics: nil, views: ["loginView": toastView])
        
        NSLayoutConstraint.activate([horizontalCenterContraint, widthContraint])
        NSLayoutConstraint.activate(verticalContraint)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            toastView.alpha = 1
        }, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(2 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                toastView.alpha = 0
            }, completion: { finished in
                toastView.removeFromSuperview()
            })
        })
    }
    
   
    

  
}
extension URL {
    static var documentsDirectory: URL {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        return try! documentsDirectory.asURL()
    }

    static func urlInDocumentsDirectory(with filename: String) -> URL {
        return documentsDirectory.appendingPathComponent(filename)
    }
}
//extension NSObject{
//    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
//        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
//        label.numberOfLines = 0
//        label.lineBreakMode = NSLineBreakMode.byWordWrapping
//        label.font = font
//        label.text = text
//        
//        label.sizeToFit()
//        return label.frame.height
//    }
//}
