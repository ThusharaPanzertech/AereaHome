//
//  AppDelegate.swift
//  JUI Residence
//
//  Created by Thushara Harish on 13/07/21.
//

import UIKit
import UserNotifications
import Firebase


var kFCMToken = ""
var kDeviceToken = ""

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //create the notificationCenter
        let center  = UNUserNotificationCenter.current()
            center.delegate = self
        if #available(iOS 10.0, *) {
         // For iOS 10 display notification (sent via APNS)

         let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
         UNUserNotificationCenter.current().requestAuthorization(
             options: authOptions,
             completionHandler: {_, _ in })
     } else {
         let settings: UIUserNotificationSettings =
             UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
         application.registerUserNotificationSettings(settings)
     }
     application.registerForRemoteNotifications()
        
        if UserDefaults.standard.value(forKey: "UserId") != nil{
        self.setHome()
        }
        else{
                self.setLogin()
        }
        LibDevModel.initBluetooth()
        LibDevModel.onBluetoothStateOver { state in
            print(state)
          //  typedef NS_ENUM(NSInteger, CBCentralManagerState) {
           //            CBCentralManagerStateUnknown = 0, // = 0
           //            CBCentralManagerStateResetting,  // = 1
           //            CBCentralManagerStateUnsupported, // = 2
           //            CBCentralManagerStateUnauthorized, // = 3
           //            CBCentralManagerStatePoweredOff, // = 4
           //            CBCentralManagerStatePoweredOn, // = 5
        }
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
        UIApplication.shared.applicationIconBadgeNumber = 0
       
        return true
    }

    func setHome(){
        let homeVC = kStoryBoardMain.instantiateViewController(withIdentifier: "HomeTableViewController") as! HomeTableViewController
        kAppDelegate.window?.rootViewController = UINavigationController(rootViewController: homeVC)
    }
   
    func setLogin(){
         kCurrentPropertyId = 0
         kCurrentPropertyName = ""
        let homeVC = kStoryBoardMain.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        kAppDelegate.window?.rootViewController = UINavigationController(rootViewController: homeVC)
    }

    
    func updateLogStatus(){
//        Model : Apple Phone 11 Pro
//        Os: IOS 14.8
        let modelName = UIDevice.modelName
        let systemVersion = UIDevice.current.systemVersion
        let device_info = "Model : \(modelName)\nOS : \(systemVersion)"
        let userId =   UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
        ApiService.loginHistoryLogs(parameters: ["user_id": userId, "login_from": "1", "device_info": device_info, "device_token" : kDeviceToken, "fcm_token"  : kFCMToken ]) { status, result, error in
            if status  && result != nil{
            }
        
            else if error != nil{
               
            }
            else{
              
            }
        }
      
    }
    func updateLogoutLogs(){
       
        
        let userId = Users.currentUser?.user?.id ?? 0
        //UserDefaults.standard.value(forKey: "UserId") as? String ?? "0"
       
        ApiService.logoutHistoryLogs(parameters: ["user_id": userId, "login_from": "1", "fcm_token"  : kFCMToken ]) { status, result, error in
            if status  && result != nil{
            }
        
            else if error != nil{
               
            }
            else{
              
            }
        }
    }
}

extension AppDelegate : MessagingDelegate{
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")
        kFCMToken =  fcmToken ?? ""
      let dataDict: [String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(
        name: Notification.Name("FCMToken"),
        object: nil,
        userInfo: dataDict
      )
        updateLogStatus()
    }
   

}
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Handle push from foreground")
       
        let userInfo = notification.request.content.userInfo
        let aps = userInfo["aps"] as? [String: Any]
        let alert = aps?["alert"] as? [String: String]
        let title = alert?["title"] ?? ""
        let body = alert?["body"]
        print("title   \(title)")
        print("body   \(body)")
        if UserDefaults.standard.value(forKey: "UserId") != nil{
            if let topController = UIApplication.topViewController() {
                let maintenanceVC = kStoryBoardMain.instantiateViewController(withIdentifier: "NotificationsTableViewController") as! NotificationsTableViewController
                if topController.navigationController != nil{
                    topController.navigationController?.pushViewController(maintenanceVC, animated: false)
                }
            }
        }
       
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
      //  let userInfo = response.notification.request.content.userInfo
       // self.incomingCall()
       
        print("Handle push from background or closed")
            // if you set a member variable in didReceiveRemoteNotification, you  will know if this is from closed or background
        print("\(response.notification.request.content.userInfo)")
       

        let userInfo = response.notification.request.content.userInfo
        let aps = userInfo["aps"] as? [String: Any]
        let alert = aps?["alert"] as? [String: String]
        let title = alert?["title"] ?? ""
        let body = alert?["body"]
        print("title   \(title)")
        print("body   \(body)")
       
        if UserDefaults.standard.value(forKey: "UserId") != nil{
            if let topController = UIApplication.topViewController() {
                let maintenanceVC = kStoryBoardMain.instantiateViewController(withIdentifier: "NotificationsTableViewController") as! NotificationsTableViewController
                if topController.navigationController != nil{
                    topController.navigationController?.pushViewController(maintenanceVC, animated: false)
                }
            }
        }
        completionHandler()
       
    }
    func displayToastMessage(_ message : String) {
        DispatchQueue.main.async {
        
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
    }
    
}
// Push Notificaion
extension AppDelegate {
func registerForPushNotifications() {
    if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            [weak self] (granted, error) in
            print("Permission granted: \(granted)")

            guard granted else {
                print("Please enable \"Notifications\" from App Settings.")
                self?.showPermissionAlert()
                return
            }

            self?.getNotificationSettings()
        }
    } else {
        let settings = UIUserNotificationSettings(types: [.alert, .sound, .badge], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
        UIApplication.shared.registerForRemoteNotifications()
    }
}

@available(iOS 10.0, *)
func getNotificationSettings() {

    UNUserNotificationCenter.current().getNotificationSettings { (settings) in
        print("Notification settings: \(settings)")
        guard settings.authorizationStatus == .authorized else { return }
        DispatchQueue.main.async {
            let settings = UIUserNotificationSettings(types: [.alert, .sound, .badge], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
}
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print(token)
        kDeviceToken = token
        Messaging.messaging().apnsToken = deviceToken
    }
  
    
   
func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("Failed to register: \(error)")
}
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
       // print("didReceiveRemoteNotification \(userInfo)")
        
       
        let aps = userInfo["aps"] as? [String: Any]
        let alert = aps?["alert"] as? [String: String]
        let title = alert?["title"] ?? ""
        let body = alert?["body"]
      //  print("title   \(title)")
      //  print("body   \(body)")
       
        if UserDefaults.standard.value(forKey: "UserId") != nil{
            if let topController = UIApplication.topViewController() {
                let maintenanceVC = kStoryBoardMain.instantiateViewController(withIdentifier: "NotificationsTableViewController") as! NotificationsTableViewController
                if topController.navigationController != nil{
                    topController.navigationController?.pushViewController(maintenanceVC, animated: false)
                }
            }
        }
      
          
    }


func showPermissionAlert() {
    let alert = UIAlertController(title: "WARNING", message: "Please enable access to Notifications in the Settings app.", preferredStyle: .alert)

    let settingsAction = UIAlertAction(title: "Settings", style: .default) {[weak self] (alertAction) in
        self?.gotoAppSettings()
    }

    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)

    alert.addAction(settingsAction)
    alert.addAction(cancelAction)

    DispatchQueue.main.async {
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}

private func gotoAppSettings() {

    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
        return
    }

    if UIApplication.shared.canOpenURL(settingsUrl) {
        UIApplication.shared.openURL(settingsUrl)
    }
}
}
