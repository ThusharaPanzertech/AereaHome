//
//  ResetPasswordViewController.swift
//  JuiResidenceUser
//
//  Created by Thushara Harish on 19/08/21.
//

import UIKit

class ResetPasswordViewController: BaseViewController {
    //Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txt_Email: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        txt_Email.delegate = self
    }
    @IBAction func actionCancel(_ sender: Any?){
        self.navigationController?.popViewController(animated: true)
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
        self.getOtp()
        }
    //MARK: ******  PARSING *********
    func getOtp(){
           ActivityIndicatorView.show("Loading")
        ApiService.getOtp_User(parameters: ["email":self.txt_Email.text!], completion: { status, result, error in
            
            
            ActivityIndicatorView.hiding()
            if status  && result != nil{
                if let loginBase = (result as? VerifyEmailModal){
                    if loginBase.response == 2{
                        
                        let alert = UIAlertController(title: loginBase.message, message: "", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            let otpVC = self.storyboard?.instantiateViewController(identifier: "OTPViewController") as! OTPViewController
                            otpVC.userEmail = self.txt_Email.text!
                            otpVC.userId = 0
                            otpVC.isToSetPassword = true
                            self.navigationController?.pushViewController(otpVC, animated: true)
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                        
                        
                        
                        
                        
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
extension ResetPasswordViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
       // self.actionVerify( nil)
        return true
    }
}
