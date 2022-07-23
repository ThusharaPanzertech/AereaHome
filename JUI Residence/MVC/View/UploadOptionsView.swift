//
//  UploadOptionsView.swift
//  JUI Residence
//
//  Created by Thushara Harish on 14/07/22.
//

import UIKit
protocol UploadOptionsViewDelegate {
    func onCameraClicked()
    func onGalleryClicked()
}
class UploadOptionsView: UIView {
    @IBOutlet weak var view_Background: UIView!
    @IBOutlet weak var btn_Camera: UIButton!
    @IBOutlet weak var btn_Close: UIButton!
    @IBOutlet weak var btn_Gallery: UIButton!
    @IBOutlet weak var lbl_Message: UILabel!
    @IBOutlet var arrViews: [UIView]!
    fileprivate var parentView: UIView?
    var delegate: UploadOptionsViewDelegate!
    
    class var getInstance: UploadOptionsView{
        
        let obj = Bundle.main.loadNibNamed("UploadOptionsView",
                                           owner: self,
                                           options: nil)
        return obj![0] as! UploadOptionsView
    }
    open func showInView(_ view: UIView?){
        for vw in self.arrViews{
            vw.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.lightGray, radius: 3.0, opacity: 0.35)
            
            vw.layer.cornerRadius = 10.0
        }
        self.parentView = view
        view_Background.layer.cornerRadius = 25.0
        view_Background.layer.masksToBounds = true
       
        self.frame = CGRect(x: 0, y: 0, width: kScreenSize.width, height: kScreenSize.height)//view!.bounds
        view!.bringSubviewToFront(self)
        kAppDelegate.window!.addSubview(self)
    }
    func closeAlert(){
        self.removeFromSuperview()
    }
   
    @IBAction func actionCamera(_ sender: UIButton) {
            self.closeAlert()
        self.delegate.onCameraClicked()
    }
    @IBAction func actionGallery(_ sender: UIButton) {
       
            self.closeAlert()
        self.delegate.onGalleryClicked()
    }
    
    @IBAction func actionClose(_ sender: UIButton) {
        closeAlert()
    }
}
