//
//  SignatureView.swift
//  JuiResidenceUser
//
//  Created by Thushara Harish on 24/01/22.
//

import UIKit
protocol SignatureViewDelegate {
    func onDoneClicked(image: UIImage, name:String, signView: SignatureView)
}
class SignatureView: UIView {
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var btn_Home: UIButton!
    fileprivate var parentView: UIView?
    fileprivate var parentController: BaseTableViewController?
    var signature: UIImage!
    @IBOutlet weak var vwSignature: YPDrawSignatureView!
    var isSignatureDrawn = false
    var delegate: SignatureViewDelegate!
    class var getInstance: SignatureView{
        
        let obj = Bundle.main.loadNibNamed("SignatureView",
                                           owner: self,
                                           options: nil)
        return obj![0] as! SignatureView
    }
    open func showInView(_ view: UIView?,   parent: BaseTableViewController, tag: Int, name: String){
        self.parentView = view
        txtName.text = name
        //ToolBar
          let toolbar = UIToolbar();
          toolbar.sizeToFit()
          let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([spaceButton,doneButton], animated: false)
        txtName.inputAccessoryView = toolbar
        
        
        
        self.vwSignature.clear()
        self.tag = tag
        self.parentController = parent
        vwSignature.layer.cornerRadius = 20.0
        vwSignature.layer.masksToBounds = true
        txtName.layer.cornerRadius = 20.0
        txtName.layer.masksToBounds = true
        txtName.delegate = self
        txtName.textColor = UIColor(red: 93/255, green: 93/255, blue: 93/255, alpha: 1.0)
        txtName.attributedPlaceholder = NSAttributedString(string: txtName.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
        txtName.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
        view_Background.layer.cornerRadius = 25.0
        view_Background.layer.masksToBounds = true
        btn_Home.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
       
        btn_Home.layer.cornerRadius = 8.0
       
        
        
        self.frame = CGRect(x: 0, y: 0, width: kScreenSize.width, height: kScreenSize.height)//view!.bounds
        view!.bringSubviewToFront(self)
      //  view?.addSubview(self)
        kAppDelegate.window!.addSubview(self)
        vwSignature.delegate = self
    }
    @objc func done(){
        txtName.resignFirstResponder()
    }
    func closeAlert(){
        self.removeFromSuperview()
    }
    @IBAction func actionClose(_ sender: UIButton) {
        closeAlert()
    }
    @IBAction func actionClearSignature(_ sender: UIButton) {
        self.vwSignature.clear()
    }
    @IBAction func actionDone(_ sender: UIButton) {
        if isSignatureDrawn == false{
            self.parentController?.displayErrorAlert(alertStr: "", title: "Please sign to proceed")
            
        }
        else if txtName.text == "" || txtName.text!.count < 2{
            self.parentController?.displayErrorAlert(alertStr: "", title: "Please enter valid name")

        }
        else{
             if let signatureImage = self.vwSignature.getSignature(scale: 10) {
                self.signature = signatureImage
                self.closeAlert()
                self.delegate.onDoneClicked(image: signature, name: txtName.text!, signView: self)
            }
    }
        
        
            
    }
   
   
}

extension SignatureView: YPSignatureDelegate{
    func didStart(_ view: YPDrawSignatureView) {
        print("Started Drawing")
    }
    
    
    func didFinish(_ view: YPDrawSignatureView) {
        print("Finished Drawing")
        isSignatureDrawn = true
    }
}
extension SignatureView: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
       
        return true
    }
   
}


@IBDesignable
class DashedLineView : UIView {
    @IBInspectable var perDashLength: CGFloat = 2.0
    @IBInspectable var spaceBetweenDash: CGFloat = 2.0
    @IBInspectable var dashColor: UIColor = UIColor.lightGray


    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let  path = UIBezierPath()
        if self.height >  self.width {
            let  p0 = CGPoint(x: self.bounds.midX, y: self.bounds.minY)
            path.move(to: p0)

            let  p1 = CGPoint(x: self.bounds.midX, y: self.bounds.maxY)
            path.addLine(to: p1)
            path.lineWidth =  self.width

        } else {
            let  p0 = CGPoint(x: self.bounds.minX, y: self.bounds.midY)
            path.move(to: p0)

            let  p1 = CGPoint(x: self.bounds.maxX, y: self.bounds.midY)
            path.addLine(to: p1)
            path.lineWidth =  self.height
        }

        let  dashes: [ CGFloat ] = [ perDashLength, spaceBetweenDash ]
        path.setLineDash(dashes, count: dashes.count, phase: 0.0)

        path.lineCapStyle = .butt
        dashColor.set()
        path.stroke()
    }

       private var width : CGFloat {
           return self.bounds.width
       }

       private var height : CGFloat {
           return self.bounds.height
       }
   }
