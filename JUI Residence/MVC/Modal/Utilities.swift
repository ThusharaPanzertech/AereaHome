//
//  Utilities.swift
//  LumiereStaff
//
//  Created by Panzer Tech Pte Ltd on 30/10/19.
//  Copyright © 2019 test.com. All rights reserved.
//

import Foundation
import UIKit

class Utilities
{
    static func makeFileName() ->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMddHHmmssSSS"
        let filename = dateFormatter.string(from: Date()) as String
        return filename
    }
}
extension String {
    func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
    
    func isValidPassword() -> Bool {
        let passwordRegex = ".*[^A-Za-z0-9].*"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
}
extension UIViewController{
    
    func displayErrorAlert(alertStr : String , title : String) {
        
        let alert = UIAlertController(title: title, message: alertStr, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    // MARK:- Alert
    /*
    func displayAlert(alertStr : String , title : String, delegate: NoInternetViewControllerDelegate, screen: String, requestType: apiRequestType) {
        
        if(alertStr.lowercased().contains("internet connection")){
        
            let selectDatesVC = kStoryboardMain1.instantiateViewController(withIdentifier: "NoInternetViewController") as! NoInternetViewController
            selectDatesVC.modalPresentationStyle = .overFullScreen
            selectDatesVC.view.backgroundColor = UIColor.clear
            
            selectDatesVC.delegate = delegate
            selectDatesVC.screentype = requestType
            selectDatesVC.screenTitle = screen
            
            self.present(selectDatesVC, animated: true, completion: nil)
        }
        else{
            let alert = UIAlertController(title: title, message: alertStr, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }*/
}
