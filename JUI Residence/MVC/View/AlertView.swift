//
//  AlertView.swift
//  JUI Residence
//
//  Created by Thushara Harish on 21/12/21.
//

import UIKit

protocol AlertViewDelegate {
    func onBackClicked()
    func onCloseClicked()
    func onOkClicked()
}
class AlertView: UIView {
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var btn_Ok: UIButton!
    @IBOutlet weak var btn_Cancel: UIButton!
    @IBOutlet weak var lbl_Message: UILabel!
    @IBOutlet weak var img_Icon: UIImageView!
    fileprivate var parentView: UIView?
    var delegate: AlertViewDelegate!
    
    class var getInstance: AlertView{
        
        let obj = Bundle.main.loadNibNamed("AlertView",
                                           owner: self,
                                           options: nil)
        return obj![0] as! AlertView
    }
    open func showInView(_ view: UIView?, title: String, okTitle: String, cancelTitle: String){
        self.parentView = view
        view_Background.layer.cornerRadius = 25.0
        view_Background.layer.masksToBounds = true
        btn_Ok.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
       
        btn_Ok.layer.cornerRadius = 8.0
        btn_Cancel.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
        if title != ""{
            lbl_Message.text = title
        }
        if okTitle != ""{
            self.btn_Ok.setTitle(okTitle, for: .normal)
        }
        if cancelTitle != ""{
            self.btn_Cancel.setTitle(cancelTitle, for: .normal)
        }
        btn_Cancel.layer.cornerRadius = 8.0
        self.frame = CGRect(x: 0, y: 0, width: kScreenSize.width, height: kScreenSize.height)//view!.bounds
        view!.bringSubviewToFront(self)
       // view?.addSubview(self)
        kAppDelegate.window!.addSubview(self)
    }
    func closeAlert(){
        self.removeFromSuperview()
       // self.removeView()
    }
    func removeView(){
        var frameRect = self.frame
        
        if let parent = parentView{
            frameRect.origin.y = parent.frame.origin.y - self.frame.height
        }
        
        self.frame = frameRect
        
        //Close wall menu
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromBottom
        
        self.layer.add(transition,
                       forKey: kCATransition)
        
        self.delay(0.5) {
            self.removeFromSuperview()
        }
    }
    
    fileprivate func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    @IBAction func actionOk(_ sender: UIButton) {
        if sender.currentTitle == "Back"{
            self.closeAlert()
        }
        else{
            self.closeAlert()
            self.delegate.onOkClicked()
        }
    }
    @IBAction func actionCancel(_ sender: UIButton) {
        if sender.currentTitle == "Back"{
            self.closeAlert()
        }
        else if sender.currentTitle == "Yes"{
            self.closeAlert()
            self.delegate.onBackClicked()
        }
        else{
            self.delegate.onOkClicked()
        }
    }
   
}
