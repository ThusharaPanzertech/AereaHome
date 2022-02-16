//
//  InitialViewController.swift
//  JuiResidenceUser
//
//  Created by Thushara Harish on 17/08/21.
//

import UIKit

class InitialViewController: BaseViewController {
    //Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txt_Email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txt_Email.delegate = self
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
    }
    @IBAction func actionVerify(_ sender: Any?){
        self.view.endEditing(true)
        guard txt_Email.text!.count  > 0 else {
            displayErrorAlert(alertStr: "Please enter the registered email", title: "")
            return
        }
        guard txt_Email.text!.isValidEmail() == true else {
            displayErrorAlert(alertStr: "Please enter a valid email address", title: "")
            return
        }
        self.retrieveInfo()
        }
    
    //MARK: ******  PARSING *********
    func retrieveInfo(){
        ActivityIndicatorView.show("Loading")
        ApiService.retrieve_User_Info(email: txt_Email.text!, completion: { status, result, error in
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                if let loginBase = (result as? VerifyEmailModal){
                    if loginBase.response == 1{
                        let signinVC = self.storyboard?.instantiateViewController(identifier: "SignInViewController") as! SignInViewController
                        signinVC.email = self.txt_Email.text!
                        self.navigationController?.pushViewController(signinVC, animated: true)
                    }
                    else if loginBase.response == 0{
                        self.view.endEditing(true)
                        self.displayErrorAlert(alertStr: "", title: loginBase.message)
                    }
                    else{
                        let otpVC = self.storyboard?.instantiateViewController(identifier: "OTPViewController") as! OTPViewController
                        otpVC.userEmail = self.txt_Email.text!
                        otpVC.userId = 0
                        otpVC.isToSetPassword = true
                        self.navigationController?.pushViewController(otpVC, animated: true)
                        
                      //  let signinVC = self.storyboard?.instantiateViewController(identifier: "SetPasswordViewController") as! SetPasswordViewController
                      //  signinVC.email = self.txt_Email.text!
                     //   self.navigationController?.pushViewController(signinVC, animated: true)
                        //self.view.endEditing(true)
                        //self.displayErrorAlert(alertStr: "", title: loginBase.message)
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
extension InitialViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //textField.resignFirstResponder()
        self.actionVerify( nil)
        return false
    }
}
