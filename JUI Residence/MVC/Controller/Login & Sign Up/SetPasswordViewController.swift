//
//  SetPasswordViewController.swift
//  JuiResidenceUser
//
//  Created by Thushara Harish on 17/08/21.
//

import UIKit

class SetPasswordViewController: BaseViewController {
    //Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txt_ConfirmPassword: UITextField!
    @IBOutlet weak var txt_Password: UITextField!
    var email = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: UIButton Action
    @IBAction func actionSubmit(_ sender: Any?){
        self.view.endEditing(true)
            
            guard txt_Password.text!.count  > 0 else {
                displayErrorAlert(alertStr: "Please enter password", title: "")
                return
            }
            guard txt_ConfirmPassword.text!.count  > 0 else {
                displayErrorAlert(alertStr: "Please enter confirm password", title: "")
                return
            }
        guard txt_ConfirmPassword.text! == txt_Password.text! else {
                displayErrorAlert(alertStr: "Password and Confirm Password Mismatch!", title: "")
                return
            }
           
            
            self.setPassword()
          
            
      
    }
  
    func setPassword(){
        ActivityIndicatorView.show("Loading")
        ApiService.setPassword_User_With(parameters: ["email":self.email,"password":txt_Password.text!,"confirmpassword":txt_ConfirmPassword.text!], completion: { status, result, error in
            
       
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                if let loginBase = (result as? LoginModal){
                    if loginBase.response == true{
                       
                        UserDefaults.standard.setValue(true, forKey: "Loaded")
                        UserDefaults.standard.synchronize()
                        UserDefaults.standard.setValue("\(loginBase.user)", forKey: "UserId")
                        UserDefaults.standard.synchronize()
                        var savedArray = UserDefaults.standard.array(forKey: "arrayIds") as? [String]
                        if savedArray != nil{
                            if savedArray!.count > 0{
                                if savedArray!.contains("\(loginBase.user)"){
                                    kAppDelegate.setHome()
                                }
                                else{
                                    savedArray!.append("\(loginBase.user)")
                                    UserDefaults.standard.removeObject(forKey: "arrayIds")
                                    UserDefaults.standard.set(savedArray, forKey: "arrayIds")
                                    kAppDelegate.setHome()
//                                    let otpVC = self.storyboard?.instantiateViewController(identifier: "OTPViewController") as! OTPViewController
//                                    otpVC.userEmail = self.email
//                                    otpVC.userId = loginBase.user
//
//                                    self.navigationController?.pushViewController(otpVC, animated: true)
//
                                    }
                            }
                            else{
                                savedArray = [String]()
                                savedArray!.append("\(loginBase.user)")
                                UserDefaults.standard.set(savedArray, forKey: "arrayIds")
                                kAppDelegate.setHome()
//                                let otpVC = self.storyboard?.instantiateViewController(identifier: "OTPViewController") as! OTPViewController
//                                otpVC.userEmail = self.email
//                                otpVC.userId = loginBase.user
//
//                                self.navigationController?.pushViewController(otpVC, animated: true)
//
                            }
                        }
                        else{
                            savedArray = [String]()
                            savedArray!.append("\(loginBase.user)")
                            UserDefaults.standard.set(savedArray, forKey: "arrayIds")
                            kAppDelegate.setHome()
//                            let otpVC = self.storyboard?.instantiateViewController(identifier: "OTPViewController") as! OTPViewController
//                            otpVC.userEmail = self.email
//                            otpVC.userId = loginBase.user
//
//                            self.navigationController?.pushViewController(otpVC, animated: true)
                        }
                        //kAppDelegate.setHome()
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
        })
    }
}
extension SetPasswordViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField  == txt_Password{
           
            txt_ConfirmPassword.becomeFirstResponder()
        }
        else{
            self.actionSubmit(nil)
        }
        
        return false
    }
}
