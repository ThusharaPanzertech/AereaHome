//
//  OTPViewController.swift
//  JuiResidenceUser
//
//  Created by Thushara Harish on 05/08/21.
//

import UIKit

class OTPViewController: BaseViewController {
    //Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txt_Otp: UITextField!
    var userEmail: String!
    var userId: Int!
    var isToSetPassword: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }
    //MARK: UIButton Action
    @IBAction func actionResend(_ sender: Any?){
        self.resendOTP()
    }
    @IBAction func actionVerify(_ sender: Any?){
       // kAppDelegate.setHome()
        self.view.endEditing(true)
        if txt_Otp.text!.count > 0 {
            
            
           
            
            self.verifyOTP()
          
            
        }
        else{
            displayErrorAlert(alertStr: "Please enter the otp send to your email", title: "")
        }
    }
    //MARK: ******  PARSING *********
    func verifyOTP(){
        ActivityIndicatorView.show("Loading")
        ApiService.verify_otp(email:userEmail, verificationCode: txt_Otp.text!) { (status, result, error) in
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                if let otpBase = (result as? LoginModal){
                    if otpBase.response == true{
                        if self.isToSetPassword  == false{
                            UserDefaults.standard.setValue("\(self.userId!)", forKey: "UserId")
                            UserDefaults.standard.synchronize()
                        kAppDelegate.setHome()
                        }
                        else{
                            let signinVC = self.storyboard?.instantiateViewController(identifier: "SetPasswordViewController") as! SetPasswordViewController
                              signinVC.email = self.userEmail
                              self.navigationController?.pushViewController(signinVC, animated: true)
                        }
                    }
                    else{
                        self.displayErrorAlert(alertStr: "", title: otpBase.message)
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
    func resendOTP(){
        ActivityIndicatorView.show("Loading")
        ApiService.resendOtp_User(parameters: ["email": userEmail!]) { (status, result, error) in
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                if let otpBase = (result as? VerifyEmailModal){
                    if otpBase.response == 1{
                        self.displayErrorAlert(alertStr: "", title: otpBase.message)
                    }
                    else{
                        self.displayErrorAlert(alertStr: "", title: otpBase.message)
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
extension OTPViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //textField.resignFirstResponder()
        self.actionVerify( nil)
        return false
    }
}
