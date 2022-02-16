//
//  MenuView.swift
//  JUI Residence
//
//  Created by Thushara Harish on 29/07/21.
//
import Foundation
import UIKit

protocol MenuViewDelegate {
    func onMenuClicked(_ sender: UIButton)
    func onCloseClicked(_ sender: UIButton)
}
var menuType : MenuType = .home
class MenuView: UIView {

    @IBOutlet weak var imgHome: UIImageView!
    @IBOutlet weak var imgSettings: UIImageView!
    @IBOutlet weak var imgLogout: UIImageView!
    fileprivate var parentView: UIView?
    fileprivate var overlayView: UIView?
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var view_Outer: UIView!
    @IBOutlet weak var img_arrow: UIImageView!
    var delegate: MenuViewDelegate?
    var isExpanded = false
    class var getInstance: MenuView{
        
        let obj = Bundle.main.loadNibNamed("MenuView",
                                           owner: self,
                                           options: nil)
        return obj![0] as! MenuView
    }
    func expandMenu(){
        
//        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseOut, animations: { [self] in
//            // rotation
//            img_arrow.transform =  CGAffineTransform(rotationAngle: CGFloat(M_PI))
//            // used triangle image below
//            self.frame = CGRect(x: 0, y: self.parentView!.frame.size.height - 275, width: (self.parentView!.frame.size.width), height: 275)
//        }, completion: { finished in
//        
//        })
        
        
        /*
        var frameRect = self.frame
        frameRect.origin.x = self.parentView!.frame.size.width/2 - self.frame.size.width/2
        frameRect.origin.y = self.parentView!.frame.size.height/2 - self.frame.size.height/2
        self.frame = frameRect
        
       */
        
       
       
    }
    func contractMenu(){
       
        
//
//        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseOut, animations: { [self] in
//            img_arrow.transform =  CGAffineTransform(rotationAngle: CGFloat(0))
//            self.frame = CGRect(x: 0, y: self.parentView!.frame.size.height - 100, width: (self.parentView!.frame.size.width), height: 275)
//        }, completion: { finished in
//
//        })
        
       
        
    }
    open func showInView(_ view: UIView?, title: String, message: String){
        if menuType == .home{
            self.imgHome.image = UIImage(named: "home_selected")
            self.imgSettings.image = UIImage(named: "settings")
            self.imgLogout.image = UIImage(named: "logout")
        }
        else if menuType == .settings{
            self.imgHome.image = UIImage(named: "home")
            self.imgSettings.image = UIImage(named: "settings_selected")
            self.imgLogout.image = UIImage(named: "logout")
        }
        else{
            self.imgHome.image = UIImage(named: "home")
            self.imgSettings.image = UIImage(named: "settings")
            self.imgLogout.image = UIImage(named: "logout")
        }
        view_Background.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 3.0, opacity: 0.35)
        self.parentView = view
        self.layer.cornerRadius = 25
        view_Background.layer.cornerRadius = 23
        self.frame = CGRect(x: 0, y: view!.frame.size.height - 80, width: (view?.frame.size.width)!, height: 80)
           
        
        self.isHidden = true
        kAppDelegate.window!.addSubview(self)
        self.isHidden = false
        
        
    }
    @IBAction func onExpand(_ sender: UIButton) {
        if self.isExpanded == false{
            isExpanded = true
            self.expandMenu()
        }
        else{
            isExpanded = false
        self.contractMenu()
        }
    }
    
    @IBAction func onClose(_ sender: UIButton) {
        if let delegate = self.delegate{
            delegate.onCloseClicked(sender)
        }
        removeView()
    }
    @IBAction func onMenu(_ sender: UIButton) {
        menuType = sender.tag == 1 ? .home : sender.tag == 2 ? .settings : .logout
        if sender.tag == 1{
            self.imgHome.image = UIImage(named: "home_selected")
            self.imgSettings.image = UIImage(named: "settings")
            self.imgLogout.image = UIImage(named: "logout")
        }
        else if sender.tag == 2{
            self.imgHome.image = UIImage(named: "home")
            self.imgSettings.image = UIImage(named: "settings_selected")
            self.imgLogout.image = UIImage(named: "logout")
        }
        else{
            self.imgHome.image = UIImage(named: "home")
            self.imgSettings.image = UIImage(named: "settings")
            self.imgLogout.image = UIImage(named: "logout")
        }
        if let delegate = self.delegate{
            delegate.onMenuClicked(sender)
        }
       // removeView()
    }
    
    func removeView(){
        self.removeFromSuperview()
       /* var frameRect = self.frame
        
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
        }*/
    }
    
    fileprivate func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
}
