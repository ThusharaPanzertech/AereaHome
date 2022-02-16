//
//  BaseViewController.swift
//  JUI Residence
//
//  Created by Thushara Harish on 14/07/21.
//

import Foundation
import UIKit

class  BaseViewController : UIViewController, UIGestureRecognizerDelegate{
    
    
    var activeTextField : UITextField?
    
    
    override func viewDidLoad() {
       
        
        super.viewDidLoad()
        
        onScreenLoad()
        
        
        loadBackgroundImage()
        
        
        
        LoadKeyboardEventHandlers()
       // loadDynamicBackground(screenTime: getScreenTime())
    }
    
    func LoadKeyboardEventHandlers(){
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
            tap.delegate = self
            view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isKind(of: UITableView.self))! {
            return false
        }
        
        if (touch.view?.superview!.isKind(of: UITableView.self))! {
            return false
        }
        
        if (touch.view?.isKind(of: UITableViewCell.self))! {
            return false
        }
        
        if (touch.view?.superview!.isKind(of: UITableViewCell.self))! {
            return false
        }
        
        if (touch.view?.isKind(of: UICollectionView.self))! {
            return false
        }
        
        if (touch.view?.superview!.isKind(of: UICollectionView.self))! {
            return false
        }
        
        if (touch.view?.isKind(of: UICollectionViewCell.self))! {
            return false
        }
        
        if (touch.view?.superview!.isKind(of: UICollectionViewCell.self))! {
            return false
        }
        return true
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += scrollHeight //keyboardSize.height
            }
        }
    }
    
    var scrollHeight : CGFloat = 0
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if(activeTextField !=  nil){
            let kbSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
            
            var visibleRect = self.view.frame;
            
            visibleRect.size.height =  visibleRect.size.height - (kbSize?.height)!
            
            var point = CGPoint.init(x: (activeTextField?.frame.origin.x)!,
                                     y: ((activeTextField?.frame.origin.y)!+(activeTextField?.frame.size.height)!))
            
            var parentView:UIView = (activeTextField?.superview)!
            var parentYpos:CGFloat = 0
            
            while (parentView != self.view) {
                
                parentYpos += parentView.frame.origin.y
                
                if(parentView.superview != nil){
                    parentView = parentView.superview!
                }
                else{
                    return
                }
            }
            point.y += parentYpos
            
            point.y = point.y + 50
            
            if(!visibleRect.contains(point)){
                if self.view.frame.origin.y == 0{
                    
                    let ypos:CGFloat = (activeTextField?.frame.origin.y)! + parentYpos
                    
                    scrollHeight = GetScrollHeight(ypos: ypos,
                                                   keyboardHeight: (kbSize?.height)!)
                    
                    self.view.frame.origin.y -= scrollHeight
                }
            }
        }
    }
    
    func GetScrollHeight(ypos: CGFloat, keyboardHeight: CGFloat) -> CGFloat {
        var scht = keyboardHeight -  (self.view.frame.size.height - ypos)
        
        scht = scht + 100
        
        return scht
    }
    
    func LMTextFiedBeginEditing(textBox: UITextField){
        activeTextField = textBox
        
    }
  
    
   
    
    
    
    func onScreenLoad(){
        
    }
    var imageView:UIImageView?
    
    func loadBackgroundImage(){
      //  if(getBackgroundImageName().count > 1){
            
            if(imageView == nil){
                imageView = UIImageView()
                imageView!.frame = self.view.frame
                
                
                imageView!.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.flexibleBottomMargin.rawValue | UIView.AutoresizingMask.flexibleHeight.rawValue | UIView.AutoresizingMask.flexibleRightMargin.rawValue | UIView.AutoresizingMask.flexibleLeftMargin.rawValue | UIView.AutoresizingMask.flexibleTopMargin.rawValue | UIView.AutoresizingMask.flexibleWidth.rawValue)
                
                imageView!.contentMode = UIView.ContentMode.scaleAspectFill
                
                self.view.addSubview(imageView!)
                
                self.view.sendSubviewToBack(imageView!)
               // imageView!.layer.addSublayer(getBackgroudShadow())
            }
            
            imageView!.image = UIImage(named: "background_signin")
            
            
      //  }
    }
    
  
    private func getBackgroudShadow() -> CAGradientLayer{
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = self.view.frame.size
        gradientLayer.colors =
            [
             UIColor.black.withAlphaComponent(0.2).cgColor,
             UIColor.black.withAlphaComponent(0.3).cgColor,
             UIColor.black.withAlphaComponent(0.4).cgColor,
             UIColor.black.withAlphaComponent(0.5).cgColor, UIColor.black.withAlphaComponent(0.6).cgColor, UIColor.black.withAlphaComponent(0.7).cgColor]
        
        return gradientLayer
    }
    
  
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
   
    
    func addDoneButtonOnKeyboard()
    {
        let toolbarDone = UIToolbar.init()
        toolbarDone.sizeToFit()
        
        let barBtnDone = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done,
                                              target: self, action: #selector(doneButtonAction))
        
        toolbarDone.items = [barBtnDone] // You can even add cancel button too
        
        
        if(activeTextField != nil){
            activeTextField?.inputAccessoryView = toolbarDone
        }
    }
    
    @objc func doneButtonAction(){
        
    }
    @IBAction func actionBack(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    func displayToastMessage(_ message : String) {
        
        let toastView = UILabel()
        toastView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastView.textColor = UIColor.white
        toastView.textAlignment = .center
        toastView.font = UIFont.systemFont(ofSize: 14)
        toastView.layer.cornerRadius = 25
        toastView.layer.masksToBounds = true
        toastView.text = message
        toastView.numberOfLines = 0
        toastView.alpha = 0
        toastView.translatesAutoresizingMaskIntoConstraints = false
        
        let window = UIApplication.shared.delegate?.window!
        window?.addSubview(toastView)
        
        let horizontalCenterContraint: NSLayoutConstraint = NSLayoutConstraint(item: toastView, attribute: .centerX, relatedBy: .equal, toItem: window, attribute: .centerX, multiplier: 1, constant: 0)
        
        let widthContraint: NSLayoutConstraint = NSLayoutConstraint(item: toastView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 275)
        
        let verticalContraint: [NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=200)-[loginView(==50)]-68-|", options: [.alignAllCenterX, .alignAllCenterY], metrics: nil, views: ["loginView": toastView])
        
        NSLayoutConstraint.activate([horizontalCenterContraint, widthContraint])
        NSLayoutConstraint.activate(verticalContraint)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            toastView.alpha = 1
        }, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(2 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                toastView.alpha = 0
            }, completion: { finished in
                toastView.removeFromSuperview()
            })
        })
    }
    
   
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
   
}

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius

        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
      }
    
    func dropShadow(){
        let shadowSize : CGFloat = 1.0
          let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
                                                     y: -shadowSize / 2,
                                                     width: self.frame.size.width + shadowSize,
                                                     height: self.frame.size.height + shadowSize))
          self.layer.masksToBounds = false
          self.layer.shadowColor = UIColor.lightGray.cgColor
          self.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
          self.layer.shadowOpacity = 0.5
          self.layer.shadowPath = shadowPath.cgPath
    }
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
           layer.masksToBounds = false
           layer.shadowOffset = offset
           layer.shadowColor = color.cgColor
           layer.shadowRadius = radius
           layer.shadowOpacity = opacity

           let backgroundCGColor = backgroundColor?.cgColor
           backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
       }
    func addborder(){
        layer.cornerRadius = 25.0
        layer.masksToBounds = true
        layer.borderWidth = 1.0
        layer.borderColor = themeColor.cgColor
    }
}
