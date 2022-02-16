//
//  SignInViewController.swift
//  JuiResidenceUser
//
//  Created by Thushara Harish on 02/08/21.
//

import UIKit

class SignInViewController: BaseViewController {

    //Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txt_Email: UITextField!
    @IBOutlet weak var txt_Password: UITextField!
    var email = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.email != ""{
            
            
            txt_Email.text = email
        }
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
    }
    //MARK: UIButton Action
    @IBAction func actionSignIn(_ sender: Any?){
       // kAppDelegate.setHome()
        self.view.endEditing(true)
       // if txt_Email.text!.count > 0 && txt_Password.text!.count > 0{
            
            guard txt_Email.text!.count  > 0 else {
                displayErrorAlert(alertStr: "Please enter email", title: "")
                return
            }
            guard txt_Password.text!.count  > 0 else {
                displayErrorAlert(alertStr: "Please enter password", title: "")
                return
            }
            guard txt_Email.text!.isValidEmail() == true else {
                displayErrorAlert(alertStr: "Please enter a valid email address", title: "")
                return
            }
           
            
            self.login(email: txt_Email.text!, password: txt_Password.text!)
          
            
      //  }
      //  else{
      //      displayErrorAlert(alertStr: "All fields are mandatory", title: "")
      //  }
    }
    @IBAction func actionForgetPassword(_ sender: Any?){
        let forgetPswVC = self.storyboard?.instantiateViewController(identifier: "ResetPasswordViewController") as! ResetPasswordViewController
        self.navigationController?.pushViewController(forgetPswVC, animated: true)
        
    }
    //MARK: ******  PARSING *********
    func retrieveInfo(){
        ApiService.retrieve_User_Info(email: txt_Email.text!, completion: { status, result, error in
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                if let loginBase = (result as? VerifyEmailModal){
                    if loginBase.response == 1{
                       
                    }
                    else if  loginBase.response == 0{
                        self.view.endEditing(true)
                        self.displayErrorAlert(alertStr: "", title: loginBase.message)
                    }
                    else{
                      
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
    func login(email:String, password: String){
        ActivityIndicatorView.show("Loading")
        ApiService.login_User_With(email:email, password: password) { (status, result, error) in
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                if let loginBase = (result as? LoginModal){
                    if loginBase.response == true{
                      //  kAppDelegate.setHome()
                      //  UserDefaults.standard.setValue(loginBase.user_id, forKey: "UserId")
                        UserDefaults.standard.setValue(true, forKey: "Loaded")
                        UserDefaults.standard.synchronize()
//                        UserDefaults.standard.setValue("\(loginBase.user_id)", forKey: "UserId")
//                        UserDefaults.standard.synchronize()
                        self.getUserInfo(userId: "\(loginBase.user_id)")
                        var savedArray = UserDefaults.standard.array(forKey: "arrayIds") as? [String]
                        if savedArray != nil{
                            if savedArray!.count > 0{
                                if savedArray!.contains("\(loginBase.user_id)"){
                                    //kAppDelegate.setHome()
                                    let otpVC = self.storyboard?.instantiateViewController(identifier: "OTPViewController") as! OTPViewController
                                    otpVC.userEmail = email
                                    otpVC.userId = loginBase.user_id
                                    otpVC.isToSetPassword = false
                                    self.navigationController?.pushViewController(otpVC, animated: true)
                                }
                                else{
                                    savedArray!.append("\(loginBase.user_id)")
                                    UserDefaults.standard.removeObject(forKey: "arrayIds")
                                    UserDefaults.standard.set(savedArray, forKey: "arrayIds")
                                    let otpVC = self.storyboard?.instantiateViewController(identifier: "OTPViewController") as! OTPViewController
                                    otpVC.userEmail = email
                                    otpVC.userId = loginBase.user_id
                                    otpVC.isToSetPassword = false
                                    self.navigationController?.pushViewController(otpVC, animated: true)
                                        
                                    }
                            }
                            else{
                                savedArray = [String]()
                                savedArray!.append("\(loginBase.user_id)")
                                UserDefaults.standard.set(savedArray, forKey: "arrayIds")
                                let otpVC = self.storyboard?.instantiateViewController(identifier: "OTPViewController") as! OTPViewController
                                otpVC.userEmail = email
                                otpVC.userId = loginBase.user_id
                                otpVC.isToSetPassword = false
                                self.navigationController?.pushViewController(otpVC, animated: true)
                          
                            }
                        }
                        else{
                            savedArray = [String]()
                            savedArray!.append("\(loginBase.user_id)")
                            UserDefaults.standard.set(savedArray, forKey: "arrayIds")
                            let otpVC = self.storyboard?.instantiateViewController(identifier: "OTPViewController") as! OTPViewController
                            otpVC.userEmail = email
                            otpVC.userId = loginBase.user_id
                            otpVC.isToSetPassword = false
                            self.navigationController?.pushViewController(otpVC, animated: true)
                        }
                       
                   
                    }
                    else{
                        self.displayErrorAlert(alertStr: "", title: loginBase.message)
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
    
    func getUserInfo(userId: String){
        ApiService.get_User_With(userId:"\(userId)" , completion: { status, result, error in
        //    ActivityIndicatorView.hiding()
            if status  && result != nil{
                if let userBase = (result as? UserInfoModalBase){
                    if userBase.response == true{
                        // UserInfoModalBase.currentUser = userBase
                        let path = userBase.data.file_path + "/"
                        kImageFilePath = "\(path)"
                        FileDownloader.clearAllFile()
                        var imgs: [String] = []
                        if userBase.data.property != nil{
                            if userBase.data.property.company_logo != nil{
                                imgs.append(kImageFilePath + userBase.data.property.company_logo)
                            }
                            if userBase.data.property.default_bg != nil{
                                imgs.append(kImageFilePath + userBase.data.property.default_bg)
                            }
                            if userBase.data.property.inspection_bg != nil{
                                imgs.append(kImageFilePath + userBase.data.property.inspection_bg)
                            }
                            if userBase.data.property.announcement_bg != nil{
                                imgs.append(kImageFilePath + userBase.data.property.announcement_bg)
                            }
                            if userBase.data.property.defect_bg != nil{
                                imgs.append(kImageFilePath + userBase.data.property.defect_bg)
                            }
                            if userBase.data.property.feedback_bg != nil{
                                imgs.append(kImageFilePath + userBase.data.property.feedback_bg)
                            }
                            if userBase.data.property.facilities_bg != nil{
                                imgs.append(kImageFilePath + userBase.data.property.facilities_bg)
                            }
                            if userBase.data.property.takeover_bg != nil{
                                imgs.append(kImageFilePath + userBase.data.property.takeover_bg)
                            }
                            self.downloadBackgroundImage(imgs: imgs)
                        }
                       
                    }
                    else{
                        
                    }
                }
        }
            else if error != nil{
            }
            else{
            }
        
        })
          
    }
    func downloadBackgroundImage(imgs: [String]){
        
        FileDownloader.downloadFiles(files: imgs)
        
    }
}
extension SignInViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField  == txt_Email{
            if textField.text!.count > 0{
                self.retrieveInfo()
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField  == txt_Email{
            if textField.text!.count > 0{
                self.retrieveInfo()
            }
            txt_Password.becomeFirstResponder()
        }
        else{
            self.actionSignIn(nil)
        }
        
        return false
    }
}
struct ARListModel : Codable
{
    var response : Int?
    var message: String?
   
}
/*  let reqUrl = "http://jui.panzerplayground.com/verifyLoginApi?email=balamurugan.sk@gmail.com&password=newnew"
      //"\(kBaseUrl)\(API.kLogin)"
      print(reqUrl);
      var request = URLRequest(url: URL(string: reqUrl)!)
      request.httpMethod = "GET"
      request.timeoutInterval = 10
      request.addValue("application/json", forHTTPHeaderField: "Content-Type")
  
      
      
      let session = URLSession.shared
      let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
          ActivityIndicatorView.hiding()
          if(response != nil){
              print("response : \(data!)")
              let decoder = JSONDecoder()
               let res = try! decoder.decode(ARListModel.self, from: data!)
              print(res)
              }
          
          else{
             
          }
          if(error != nil){
              print("Network Error \((error?.localizedDescription)!)")
              
          }
      })
      task.resume()
  */
  
class TextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 5)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
@IBDesignable class PaddingLabel: UILabel {

    @IBInspectable var topInset: CGFloat = 8.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 7.0
    @IBInspectable var rightInset: CGFloat = 7.0

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }

    override var bounds: CGRect {
        didSet {
            // ensures this works within stack views if multi-line
            preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
        }
    }
}
