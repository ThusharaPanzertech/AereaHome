//
//  ActivityIndicatorView.swift
//  lumiere
//
//  Created by Panzer Tech on 29/5/19.
//  Copyright © 2019 PanzerTech. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

open class ActivityIndicatorView: UIView {
    
   // let defaultTitleFont = customFont.regularFontOfSize18()
    fileprivate var activityIndicatorView:NVActivityIndicatorView!
    fileprivate lazy var titleLabel = UILabel()
    fileprivate var isShowing = false
    
    open class var shared: ActivityIndicatorView {
        struct Singleton {
            static let instance = ActivityIndicatorView(frame: CGRect.zero)
        }
        return Singleton.instance
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        let actualSize = CGSize(width: 80, height: 80)// NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE
        activityIndicatorView = NVActivityIndicatorView(
            frame: CGRect(x: 0, y: 0, width: actualSize.width, height: actualSize.height),
            type:  NVActivityIndicatorType.ballScale,
            color: UIColor.white,
            padding: 0)
        addSubview(activityIndicatorView)
        let width = frame.size.width / 3
        titleLabel.frame = CGRect(x: 0, y: 0, width: width, height: 30)
       // titleLabel.font = defaultTitleFont
        titleLabel.textColor = UIColor.white
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.adjustsFontSizeToFitWidth = true
        addSubview(titleLabel)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func starting(){
        let indicator = ActivityIndicatorView.shared.activityIndicatorView
        indicator?.startAnimating()
    }
    fileprivate func stoping(){
        let indicator = ActivityIndicatorView.shared.activityIndicatorView
        indicator?.stopAnimating()
    }
    
    open class func isOnScreen() -> Bool {
        return  ActivityIndicatorView.shared.isShowing
    }
    
    open class func show(_ title: String)  {
        
        let indicator = ActivityIndicatorView.shared
        indicator.backgroundColor = UIColor(white: 0.0, alpha: 0.6)
        
        indicator.updateFrame()
        
        if indicator.superview == nil {
            //show the spinner
            indicator.alpha = 0.0
            
            guard let containerView = defaultActivityContainer() else {
                fatalError("\n`UIApplication.keyWindow` is `nil`. If you're trying to show a spinner from your view controller's `viewDidLoad` method, do that from `viewWillAppear` instead. Alternatively use `useContainerView` to set a view where the spinner should show")
            }
            containerView.addSubview(indicator)
            UIView.animate(withDuration: 0.33, delay: 0.0, options: .curveEaseOut, animations: {
                indicator.alpha = 1.0
            }, completion: nil)
            
//            #if os(iOS)
//            // Orientation change observer
//            NotificationCenter.default.addObserver(
//                indicator,
//                selector: #selector(ActivityIndicatorView.updateFrame),
//                name:  Notification.Name.,
//                object: nil)
//            #endif
        }
        
        indicator.title = "" //title
        indicator.starting()
        indicator.isShowing = true
        
    }
    open class func hiding(_ completion: (() -> Void)? = nil) {
        
        let indicator = ActivityIndicatorView.shared
        NotificationCenter.default.removeObserver(indicator)
        DispatchQueue.main.async(execute: {
            indicator.stoping()
            if indicator.superview == nil {
                return
            }
            UIView.animate(withDuration: 0.33, delay: 0.0, options: .curveEaseOut, animations: {
                indicator.alpha = 0.0
            }, completion: {_ in
                indicator.alpha = 1.0
                indicator.removeFromSuperview()
                completion?()
                indicator.isShowing = false
            })
        })
    }
    
    //
    // Custom superview for the spinner
    //
    fileprivate static weak var customActivityContainer: UIView? = nil
    
    fileprivate static func defaultActivityContainer() -> UIView? {
        return customActivityContainer ?? UIApplication.shared.keyWindow
    }
    open class func addActivityOnView(_ activityContainer: UIView?) {
        customActivityContainer = activityContainer
    }
    
    @objc open func updateFrame() {
        if let containerView = ActivityIndicatorView.defaultActivityContainer() {
            ActivityIndicatorView.shared.frame = containerView.bounds
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        updateFrame()
    }
    open override var frame: CGRect {
        didSet {
            if frame == CGRect.zero {
                return
            }
            
            guard let indicator = activityIndicatorView else{
                return
            }
            
            indicator.center = center
            let width = frame.size.width / 3
            let height = activityIndicatorView?.frame.size.height
            titleLabel.frame = CGRect(x: 0, y: 0, width: width, height: 30)
            titleLabel.center =  CGPoint(
                x: indicator.center.x,
                y: indicator.center.y + height!)
            
            
            
        }
    }
    
    open var title: String = "" {
        didSet(newTitle) {
            // Do not show spring animation if title hasn't changed.
            if newTitle != title {
                let indicator = ActivityIndicatorView.shared
                
                UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseOut, animations: {
                    indicator.titleLabel.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
                    indicator.titleLabel.alpha = 0.2
                }, completion: {_ in
                    indicator.titleLabel.text = self.title
                    UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 0.35, initialSpringVelocity: 0.0, options: [], animations: {
                        indicator.titleLabel.transform = CGAffineTransform.identity
                        indicator.titleLabel.alpha = 1.0
                    }, completion: nil)
                })
            }
        }
    }
}
