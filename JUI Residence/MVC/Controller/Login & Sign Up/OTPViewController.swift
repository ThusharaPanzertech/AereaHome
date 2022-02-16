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
    @IBOutlet weak var btn_ResendOtp: UIButton!
    @IBOutlet weak var lbl_ResendOtp: UILabel!
    var userEmail: String!
    var userId: Int!
    var timer = Timer()
    var count = 30
//     let btnAttr: [NSAttributedString.Key: Any] = [
//        .font: UIFont(name: "Helvetica-Bold", size: 14)!,
//         .foregroundColor: UIColor.white,
//         .underlineStyle: NSUnderlineStyle.single.rawValue
//     ]
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
        btn_ResendOtp.isEnabled = false
        lbl_ResendOtp.alpha = 0.5
        startTimer()
    }
    //MARK: UIButton Action
    @IBAction func actionResend(_ sender: Any?){
        btn_ResendOtp.isEnabled = false
        lbl_ResendOtp.alpha = 0.5
        self.resendOTP()
    }
    func startTimer(){
        self.timer = Timer.scheduledTimer(timeInterval: 1 , target: self, selector: #selector(self.updateTitle), userInfo: nil, repeats: true)
    }
    @objc func updateTitle(){
        count = count - 1
        if count == 0{
            timer.invalidate()
            //timer = nil
            count = 30
            btn_ResendOtp.isEnabled = true
            lbl_ResendOtp.alpha = 1.0
            lbl_ResendOtp.text = "Resend OTP"
//            btn_ResendOtp.setTitle("Resend OTP", for: .normal)
        }
        else{
            lbl_ResendOtp.text = "Resend OTP in \(count) seconds"
           // btn_ResendOtp.setTitle("Resend OTP in \(count)seconds", for: .normal)
        }
    }
    @IBAction func actionVerify(_ sender: Any?){
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
                if let otpBase = (result as? VerifyOtpModal){
                    if otpBase.response == 1{
                        UserDefaults.standard.setValue("\(self.userId!)", forKey: "UserId")
                        UserDefaults.standard.setValue(true, forKey: "Loaded")
                        UserDefaults.standard.synchronize()
                        kAppDelegate.setHome()
                       
                        
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
            self.startTimer()
            if status  && result != nil{
                if let otpBase = (result as? VerifyOtpModal){
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
        self.actionVerify( nil)
        return false
    }
}
