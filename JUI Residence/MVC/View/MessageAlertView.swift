//
//  MessageAlertView.swift
//  JUI Residence
//
//  Created by Thushara Harish on 21/12/21.
//

import UIKit
protocol MessageAlertViewDelegate {
    func onHomeClicked()
    func onListClicked()
}
class MessageAlertView: UIView {
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var btn_Home: UIButton!
    @IBOutlet weak var btn_List: UIButton!
    @IBOutlet weak var lbl_Message: UILabel!
    fileprivate var parentView: UIView?
    var delegate: MessageAlertViewDelegate!
    
    class var getInstance: MessageAlertView{
        
        let obj = Bundle.main.loadNibNamed("MessageAlertView",
                                           owner: self,
                                           options: nil)
        return obj![0] as! MessageAlertView
    }
    open func showInView(_ view: UIView?, title: String, okTitle: String, cancelTitle: String){
        self.parentView = view
        view_Background.layer.cornerRadius = 25.0
        view_Background.layer.masksToBounds = true
        btn_Home.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
       
        btn_Home.layer.cornerRadius = 8.0
        btn_List.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
        if title != ""{
            lbl_Message.text = title
        }
        if okTitle != ""{
            self.btn_Home.setTitle(okTitle, for: .normal)
        }
        if cancelTitle != ""{
            self.btn_List.setTitle(cancelTitle, for: .normal)
        }
        btn_List.layer.cornerRadius = 8.0
        self.frame = CGRect(x: 0, y: 0, width: kScreenSize.width, height: kScreenSize.height)//view!.bounds
        view!.bringSubviewToFront(self)
      //  view?.addSubview(self)
        kAppDelegate.window!.addSubview(self)
    }
    func closeAlert(){
        self.removeFromSuperview()
    }
   
    @IBAction func actionHome(_ sender: UIButton) {
            self.closeAlert()
        self.delegate.onHomeClicked()
    }
    @IBAction func actionList(_ sender: UIButton) {
       
            self.closeAlert()
        self.delegate.onListClicked()
    }
   
}
