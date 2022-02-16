//
//  AppDelegate.swift
//  JUI Residence
//
//  Created by Thushara Harish on 13/07/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if UserDefaults.standard.value(forKey: "UserId") != nil{
        self.setHome()
        }
        else{
                self.setLogin()
        }
        return true
    }

    func setHome(){
        let homeVC = kStoryBoardMain.instantiateViewController(withIdentifier: "HomeTableViewController") as! HomeTableViewController
        kAppDelegate.window?.rootViewController = UINavigationController(rootViewController: homeVC)
    }
   
    func setLogin(){
        let homeVC = kStoryBoardMain.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        kAppDelegate.window?.rootViewController = UINavigationController(rootViewController: homeVC)
    }

}

