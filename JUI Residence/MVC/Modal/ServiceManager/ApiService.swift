//
//  ApiService.swift
//  LumiereStaff
//
//  Created by Panzer Tech Pte Ltd on 30/10/19.
//  Copyright © 2019 test.com. All rights reserved.
//

import Foundation
import Alamofire
class ApiService{
    static let sharedInstance = ApiService()
    
    var isTaskRunning = Bool()
    var progressHandler: ((_ isRunning:Bool,_ progress:Progress?,_ error:Error?) -> Void)?
    typealias completionHandler = (_ status:Bool, _ result:AnyObject?,_ error:NSError?)->Void
    typealias progressClosure = (_ status:Progress)->Void
    //MARK:  **********  SIGN IN USER *****
    
    static func loginHistoryLogs(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kHistoryLog, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try LoginHistoryLog(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func logoutHistoryLogs(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kLogoutHistoryLogs, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try LoginHistoryLog(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }

  
    //MARK:  **********  RESENDS OTP USER *****
    static func resendOtp_User(parameters:[String:Any], completion:@escaping completionHandler)
    {
        
        ServiceManager.sharedInstance.postMethod(API.kResendOtp, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let otpModal = try VerifyOtpModal(result as! [String : Any])
                    completion(true,otpModal as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
    }
 
 
    //MARK:  **********  SIGN IN USER *****
    static func login_User_With(email:String, password: String,completion:@escaping completionHandler)
    {
        
   //     let requestUrl = "\(kBaseUrl)"+"\(API.kLogin)?email=\(email)&password=\(password)"
        
        ServiceManager.sharedInstance.postMethod(API.kLogin, parameter: ["email":email,"password":password]) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let loginModal = try LoginModal(result as! [String : Any])
                    completion(true,loginModal as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func verify_otp(email:String, verificationCode: String,completion:@escaping completionHandler)
    {
        
        ServiceManager.sharedInstance.postMethod(API.kVerifyOTP, parameter: ["email":email,"verificationcode":verificationCode]) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let verifyOtpModal = try VerifyOtpModal(result as! [String : Any])
                    completion(true,verifyOtpModal as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    
    static func get_User_With(userId: String,completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kGetUserInfo, parameter: ["login_id":userId]) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let loginModal = try LoginInfoModalBase(result as! [String : Any])
                    completion(true,loginModal as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func get_DashboardInfo(userId: String,completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kGetDashboardInfo, parameter: ["login_id":userId]) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let loginModal = try DashboardInfoModalBase(result as! [String : Any])
                    completion(true,loginModal as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    //MARK:  **********  GET ROLES LIST *****
    static func get_RolesList(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kGetRoles, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let userBase = try RolesBase(result as! [String : Any])
                    completion(true,userBase as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    
    static func get_UserRolesList(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kGetUserRoles, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let userBase = try UserRolesBase(result as! [String : Any])
                    completion(true,userBase as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    //MARK:  **********  GET COUNTRY LIST *****
    static func get_UserCountryList(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kGetCountry, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let userBase = try CountryBase(result as! [String : Any])
                    completion(true,userBase as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    //MARK:  **********  GET CARD UNIT LIST *****
    static func get_UnitCardList(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kGetUnitCard, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let userBase = try UnitCardBase(result as! [String : Any])
                    completion(true,userBase as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    //MARK:  **********  GET ASSIGNED UNIT LIST *****
    static func get_AssignedUnitList(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kGetAssignedUnits, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let userBase = try AssignedUnitBase(result as! [String : Any])
                    completion(true,userBase as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func assign_Unit(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kAssignUnit, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let userBase = try DeleteUserBase(result as! [String : Any])
                    completion(true,userBase as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func delete_AssignedUnit(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kDeleteAssignednUnit, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let userBase = try DeleteUserBase(result as! [String : Any])
                    completion(true,userBase as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    
    //MARK:  **********  GET UNIT LIST *****
    static func get_UnitList(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kGetUnits, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let userBase = try UnitBase(result as! [String : Any])
                    completion(true,userBase as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func search_UnitList(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kSearchUnits, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let userBase = try SearchUnitBase(result as! [String : Any])
                    completion(true,userBase as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func get_UnitListTyps(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kGetUnitListType, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try UnitListTypeBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    //MARK:  **********  GET PROPERTY LIST *****
    static func switch_Property(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kSwitchProperty, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let userBase = try PropertyListBase(result as! [String : Any])
                    completion(true,userBase as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func get_PropertyList(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kGetPropertyList, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let userBase = try PropertyListBase(result as! [String : Any])
                    completion(true,userBase as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    //MARK:  **********  CREATE USER *****
    static func create_User(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kCreateUser, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let userBase = try CreateUserBase(result as! [String : Any])
                    completion(true,userBase as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    //MARK:  **********  UPDATE USER *****
    static func update_User(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kUpdateUser, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let userBase = try UpdateUserBase(result as! [String : Any])
                    completion(true,userBase as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    //MARK:  **********  DELETE USER *****
    static func delete_User(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kDeleteUser, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let userBase = try DeleteUserBase(result as! [String : Any])
                    completion(true,userBase as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    
    //MARK:  **********  ACTIVATE USER *****
    static func activate_user(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kActivateUser, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let userBase = try MessageBase(result as! [String : Any])
                    completion(true,userBase as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    
    //MARK:  **********  DEACTIVATE USER  *****
    static func deactivate_user(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kDeactivateUser, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let userBase = try MessageBase(result as! [String : Any])
                    completion(true,userBase as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    
    
    
    //MARK:  **********  GET USERD DETAIL INFO *****
    static func get_UserDetail_With(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kGetUserData, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let userBase = try UserInfoModalBase(result as! [String : Any])
                    completion(true,userBase as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    //MARK:  **********   ANNOUNCEMENTS  *****
    static func get_Announcement(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kGetAnnouncement, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try AnnouncementModalBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    
    static func create_Announcement(parameters:[String:Any],files:[Data]?, completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethodAlamofire_With_Multiple_Data(API.kCreateAnnouncement,  with: parameters, imagedatas: files) { (status, result, error) in
        
            if status
            {
                let data = result?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try CreateAnnouncementBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    static func search_Announcement(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kSearchAnnouncement, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try AnnouncementModalBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    static func delete_Announcement(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kDeleteAnnouncement, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let userBase = try DeleteUserBase(result as! [String : Any])
                    completion(true,userBase as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    //MARK:  **********   SYSTEM ACCESS *****
    static func get_SystemAccessSummary(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kGetSystemAccessList, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try UserAccessSummaryBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    
    static func update_SystemAccess(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kUpdateSystemAccess, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try DeleteUserBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    //MARK:  **********   USER MANAGEMENT *****
    static func get_UserAccessSummary(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kGetUserAccessList, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try UserAccessSummaryBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    static func search_UserAccessSummary(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kSearchUserAccessList, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try UserAccessSummaryBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    
    static func submit_UserAccess(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kSubmitUserAccess, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try UserAccessUpdateBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    
    
    static func get_UserSummary(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kGetUserList, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try UserSummaryBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    
    static func search_User(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kSearchUser, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try UserSummaryBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    //MARK:  **********   VISITOR MANAGEMENT  *****
    static func get_VisitorSummary(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kGetVisitorSummary, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try VisitorSummaryModalBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    static func search_VisitorSummary(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kSearchVisitorSummary, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try VisitorSummaryModalBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    static func get_VisitorInfo(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kGetVisitorInfo, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try VisitorInfoModalBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    
    static func delete_visitorBooking(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kDeleteVisitorBooking, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try DeleteUserBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func get_VisitorAvailabilty(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kGetVisitorAvailability, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try VisitorAvaiabiltyBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    static func get_VisitorFunctions(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kGetVisitorFunction, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try VisitorFunctionBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    static func update_visitorBooking(parameters:[String:Any],completion:@escaping completionHandler)
    {
        //  ServiceManager.sharedInstance.postMethodAlamofire_With_Array(API.kUpdateVisitorBooking, with: parameters, arraydatas: ["267,268,269"]) { (status, response, error) in
        
        
       ServiceManager.sharedInstance.postMethod(API.kUpdateVisitorBooking, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try UpdateVisitorBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func register_VisitorWalkin(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kRegisterVisitorWalkin, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try WalkinVisitorBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    //MARK:  **********   KEY COLECTION  *****
    static func get_KeyCollectionSummary(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kKeyCollectionSummary, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try KeyCollectionSummaryBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    static func get_KeyCollectionInfo(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kKeyCollectionInfo, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try KeyCollectionInfoBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    static func search_KeyCollection(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kSearchKeyCollection, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try KeyCollectionSummaryBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    
    static func get_NewKeyCollectionSummary(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kKeyCollectionSummaryNew, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try KeyCollectionSummaryBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    
    static func delete_KeyCollection(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kDeleteKeyCollection, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let userBase = try DeleteUserBase(result as! [String : Any])
                    completion(true,userBase as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    
    static func edit_KeyCollection(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kEditKeyCollection, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let userBase = try DeleteUserBase(result as! [String : Any])
                    completion(true,userBase as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func approve_decline_KeyCollection(isToApprove : Bool, parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(isToApprove ? API.kApproveKeyCollection : API.kDeclineKeyCollection, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let userBase = try DeleteUserBase(result as! [String : Any])
                    completion(true,userBase as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    //MARK:  **********   FEEDBACK  *****
    static func get_FeedbackOptions(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kGetFeedbackOptions, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let userBase = try FeedbackOptionsBase(result as! [String : Any])
                    completion(true,userBase as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    
    static func get_feedbackSummary(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kGetFeedbackSummary, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try FeedbackModalBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func get_FeedbackDetail(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kGetFeedbackDetail, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try FeedbackDetailBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    
    
    static func get_newFeedbacks(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kGetNewFeedback, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try FeedbackModalBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    
    static func search_feedback(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kFeedbackSearch, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try FeedbackModalBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    static func delete_Feedback(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kDeleteFeedback, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let userBase = try DeleteUserBase(result as! [String : Any])
                    completion(true,userBase as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func update_Feedback(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kEditFeedback, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let userBase = try DeleteUserBase(result as! [String : Any])
                    completion(true,userBase as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }




    //MARK:  **********   FACILITIES  *****
    static func get_FacilityOptions(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kGetFacilityOptions, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let userBase = try FacilityOptionsBase(result as! [String : Any])
                    completion(true,userBase as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    
    static func get_facilitySummary(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kGetFacilitySummary, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try FacilityModalBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    static func get_facilityInfo(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kGetFacilityInfo, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try FacilityInfoBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    static func get_newFacilityBookings(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kGetNewFacilities, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try FacilityModalBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    static func search_facility(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kFacilitySearch, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try FacilityModalBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    static func delete_Facility(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kCancelFacility, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let userBase = try DeleteUserBase(result as! [String : Any])
                    completion(true,userBase as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func edit_Facility(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kEditFacility, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let userBase = try DeleteUserBase(result as! [String : Any])
                    completion(true,userBase as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    
    static func get_FacilityTimings(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kGetFacilityTimeSlots, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let userBase = try FacilityTimeSlotBase(result as! [String : Any])
                    completion(true,userBase as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    
    static func update_Facility(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kEditFacility, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let userBase = try DeleteUserBase(result as! [String : Any])
                    completion(true,userBase as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func approve_decline_Facility(isToApprove : Bool, parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(isToApprove ? API.kApproveFacility : API.kDeclineFacility, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let userBase = try DeleteUserBase(result as! [String : Any])
                    completion(true,userBase as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    //MARK:  **********   DEFECTS  *****
  
    
    static func get_defectsSummary(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kGetDefectsSummary, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try DefectsModalBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    static func search_Defects(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kDefectSearch, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try DefectsModalBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    static func get_DefectDetail(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kGetDefectDetail, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try DefectDetailsModalBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    static func delete_Defect(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kDeleteDefect, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let userBase = try DeleteUserBase(result as! [String : Any])
                    completion(true,userBase as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func updateDefect_InspectionSignature_With(signature: Data?, parameters:[String:Any],completion:@escaping completionHandler)
    {
        var datas = [Data]()
        if signature != nil{
        datas.append(signature!)
        }
        ServiceManager.sharedInstance.postMethod_UploadData1(API.kUpdateDefectInspectionSignature, path: "signature", parameter: parameters, imagedata: datas) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let responseModal = try SignatureUpdateModal(result as! [String : Any])
                    completion(true,responseModal as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func update_HandoverSignature_With(signature: Data?, parameters:[String:Any],completion:@escaping completionHandler)
    {
        var datas = [Data]()
        if signature != nil{
        datas.append(signature!)
        }
        ServiceManager.sharedInstance.postMethod_UploadData1(API.kUpdateHandoverSignature, path: "signature", parameter: parameters, imagedata: datas) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let responseModal = try SignatureUpdateModal(result as! [String : Any])
                    completion(true,responseModal as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func get_InspectionTimings(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kGetInspectionTimings, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let timeslots = try DefectInspectionTimeSlotBase(result as! [String : Any])
                    completion(true,timeslots as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func update_InspectionAppointment(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kEditInspectionAppt, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try DeleteUserBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    static func cancel_InspectionAppointment(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kCancelInspectionAppt, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try DeleteUserBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    //MARK:  **********   SETTINGS  *****
    //MARK:  **********   PROPERTY  *****
    static func get_PropertyInfo(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kSettings_PropertyInfo, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try PropertyInfoModalBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    
    static func update_Property(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kSettings_PropertyEdit, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let userBase = try DeleteUserBase(result as! [String : Any])
                    completion(true,userBase as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    
    
    
    //MARK:  **********   ROLES  *****
    static func get_RoleSummary(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kSettings_RoleSummary, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try RoleSummaryBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func get_RoleDetails(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kSettings_RoleInfo, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try RoleDetailsBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func create_Role(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kSettings_CreateRole, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try CreateRoleBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func update_Role(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kSettings_EditRole, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let userBase = try DeleteUserBase(result as! [String : Any])
                    completion(true,userBase as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    
    static func delete_Role(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kSettings_DeleteRole, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try DeleteUserBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    
    
    //MARK:  **********   UNIT  *****
    static func get_UnitSummary(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kSettings_UnitsSummary, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try UnitSummaryBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func delete_Unit(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kSettings_DeleteUnit, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try DeleteUserBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func create_Unit(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kSettings_CreateUnit, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try CreateUnitBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func update_Unit(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kSettings_EditUnit, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try CreateUnitBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    
    
    //MARK:  **********   FEEDBACK OPTIONS  *****
    static func get_FeedbackOptionsSummary(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kSettings_FeedbackOption, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try FeedbackOptionSummaryBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func create_FeedbackOption(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kSettings_CreateFeedbackOption, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try CreateFeedbackOptionBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func update_FeedbackOption(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kSettings_EditFeedbackOption, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try CreateFeedbackOptionBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    
    static func delete_FeedbackOption(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kSettings_DeleteFeedbackOption, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try DeleteUserBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    //MARK:  **********   DEFECT LOCATION OPTIONS  *****
    static func get_DefectsLocationSummary(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kSettings_DefectsLocList, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try DefectLocationSummaryBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    
    static func get_DefectLocationDetails(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kSettings_DefectsLocInfo, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try DefectsLocationDetailsBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    
    static func create_DefectLocation(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kSettings_CreateDefectsLoc, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try CreateFeedbackOptionBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func update_DefectLocation(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kSettings_EditDefectsLoc, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try CreateFeedbackOptionBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    
    static func delete_DefectLocation(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kSettings_DeleteDefectsLoc, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try DeleteUserBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    
    //MARK:  **********   FACILITY TYPE OPTIONS  *****
    static func get_FacilityTypeSummary(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kSettings_FacilityTypeList, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try FacilityTypeSummaryBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func create_FacilityType(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kSettings_CreateFacilityType, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try CreateFeedbackOptionBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func update_FacilityType(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kSettings_EditFacilityType, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try CreateFeedbackOptionBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func delete_FacilityType(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kSettings_DeleteFacilityType, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try DeleteUserBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    //MARK:  **********   RESIDENTS FILE UPLOAD  *****
    static func get_ResidentFileSummary(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kGetResidentFileSummary, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try ResidentFileSummaryBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    static func get_ResidentFileDetail(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kGetResidentFileInfo, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try ResidentFileInfoBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    static func get_ResidentFileSummaryNew(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kGetResidentFileSummaryNew, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try ResidentFileSummaryBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    static func search_ResidentFiles(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kResidentFileSearch, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try ResidentFileSummaryBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    
    static func get_NewResidentFileUploads(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kKeyCollectionSummaryNew, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try KeyCollectionSummaryBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    static func delete_ResidentFileUpload(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kDeleteResidentFileUpload, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let userBase = try DeleteUserBase(result as! [String : Any])
                    completion(true,userBase as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func update_ResidentFileUpload(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kEditResidentFile, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let userBase = try DeleteUserBase(result as! [String : Any])
                    completion(true,userBase as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }



  /*  static func delete_KeyCollection(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kDeleteKeyCollection, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let userBase = try DeleteUserBase(result as! [String : Any])
                    completion(true,userBase as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    */
    static func edit_ResidentFile(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kEditKeyCollection, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let userBase = try DeleteUserBase(result as! [String : Any])
                    completion(true,userBase as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    //MARK:  **********   VISITING PURPOSE  *****
    static func get_VisitingPurpose(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kSettings_VisitingPurposeSummary, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try VisitingPurposeSummaryBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func get_VisitingPurposeDetails(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kSettings_VisitingPurposeInfo, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try VisitingPurposeInfoBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    
    //MARK:  **********   EFORM SUBMISSIONS  *****
    static func get_eformDetail(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kEForm_SettingsInfo, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try eFormSettingsInfoBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    static func get_MoveInOutSummary(isToSearch: Bool, parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        let service = isToSearch ? API.kEForm_MoveInOutSearch : API.kEForm_MoveInOutSummary
        ServiceManager.sharedInstance.postMethod(service, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try MoveInOutSummaryBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func get_MoveInOutInfo( parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        let service =  API.kEForm_MoveInOutInfo
        ServiceManager.sharedInstance.postMethod(service, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try MoveInOutInfoBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    
    static func get_RenovationInfo( parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        let service =  API.kEForm_RenovationInfo
        ServiceManager.sharedInstance.postMethod(service, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try RenovationInfoBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func get_DoorAccessInfo( parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        let service =  API.kEForm_DoorAccessInfo
        ServiceManager.sharedInstance.postMethod(service, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try DoorAccessInfoBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func get_VehicleRegInfo( parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        let service =  API.kEForm_VehicleRegInfo
        ServiceManager.sharedInstance.postMethod(service, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try VehicleRegInfoBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func delete_EForm(formType: eForm,parameters:[String:Any],completion:@escaping completionHandler)
    {
        let service = formType == .moveInOut ? API.kEForm_MoveInOutDelete :
            formType == .renovation ? API.kEForm_RenovationDelete :
            formType == .doorAccess ? API.kEForm_DoorAccessDelete :
            formType == .vehicleReg ? API.kEForm_VehicleRegDelete :
            formType == .updateAddress ? API.kEForm_UpdateAddressDelete :
            formType == .updateParticulars ? API.kEForm_UpdateParticularsDelete : ""
            
        
        ServiceManager.sharedInstance.postMethod(service, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try DeleteUserBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func update_EForm(formType: eForm,parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        let service = formType == .moveInOut ? API.kEForm_MoveInOutUpdate :
            formType == .renovation ? API.kEForm_RenovationUpdate :
            formType == .doorAccess ? API.kEForm_DoorAccessUpdate :
            formType == .vehicleReg ? API.kEForm_VehicleRegUpdate :
            formType == .updateAddress ? API.kEForm_UpdateAddressUpdate :
            formType == .updateParticulars ? API.kEForm_UpdateParticularsUpdate : ""
        ServiceManager.sharedInstance.postMethod(service, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try DeleteUserBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func get_RenovationSummary(isToSearch: Bool,parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        let service = isToSearch ? API.kEForm_RenovationSearch : API.kEForm_RenovationSummary
        ServiceManager.sharedInstance.postMethod(service, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try RenovationSummaryBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func get_DoorAccessSummary(isToSearch: Bool,parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        let service = isToSearch ? API.kEForm_DoorAccessSearch : API.kEForm_DoorAccessSummary
        ServiceManager.sharedInstance.postMethod(service, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try DoorAccessSummaryBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func get_VehicleRegSummary(isToSearch: Bool,parameters:[String:Any],completion:@escaping completionHandler)
    {
        let service = isToSearch ? API.kEForm_VehicleRegSearch : API.kEForm_VehicleRegSummary
        
        ServiceManager.sharedInstance.postMethod(service, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try VehicleRegSummaryBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func get_VehicleRegDetails(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        ServiceManager.sharedInstance.postMethod(API.kEForm_VehicleRegDetails, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try VehicleRegBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func get_UpdateAddressSummary(isToSearch: Bool,parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        let service = isToSearch ? API.kEForm_UpdateAddressSearch : API.kEForm_UpdateAddressSummary
        ServiceManager.sharedInstance.postMethod(service, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try UpdateAddressSummaryBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func get_UpdateAddressInfo(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        let service = API.kEForm_UpdateAddressInfo
        ServiceManager.sharedInstance.postMethod(service, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try UpdateAddressInfoSummaryBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    
    static func get_UpdateParticularsSummary(isToSearch: Bool,parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        let service = isToSearch ? API.kEForm_UpdateParticularsSearch : API.kEForm_UpdateParticularsSummary
        ServiceManager.sharedInstance.postMethod(service, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try UpdateParticularsSummaryBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func get_UpdateParticularInfo(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        let service =  API.kEForm_UpdateParticularInfo
        ServiceManager.sharedInstance.postMethod(service, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try UpdateParticularsInfoBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    
    static func submit_MoveIOPayment(signature: Data?, parameters:[String:Any],completion:@escaping completionHandler)
    {
        var datas = [Data]()
        if signature != nil{
        datas.append(signature!)
        }
        ServiceManager.sharedInstance.postMethod_UploadData1(API.kEForm_MoveInOutPayment, path: "signature", parameter: parameters, imagedata: datas) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let loginModal = try MoveIOInspectionBase(result as! [String : Any])
                    completion(true,loginModal as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
       
    }
    static func submit_MoveIOInspection(files:[[String:Any]]?,parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        
        ServiceManager.sharedInstance.postMethodAlamofire_With_Multiple_Data1(API.kEForm_MoveInOutInspection, with: parameters, imagedatas: files) { (status, result, error) in
            if status
            {
                let data = result?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try MoveIOInspectionBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
            
        }
        
        
        
        
        
     
    }
    static func submit_RenovationInspection(files:[[String:Any]]?,parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        
        ServiceManager.sharedInstance.postMethodAlamofire_With_Multiple_Data1(API.kEForm_RenovationInspection, with: parameters, imagedatas: files) { (status, result, error) in
            if status
            {
                let data = result?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try RenovationInspectionBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
            
        }
        
        
        
        
        
     
    }
    static func submit_RenovationPayment(signature: Data?, parameters:[String:Any],completion:@escaping completionHandler)
    {
        var datas = [Data]()
        if signature != nil{
        datas.append(signature!)
        }
        ServiceManager.sharedInstance.postMethod_UploadData1(API.kEForm_RenovationPayment, path: "signature", parameter: parameters, imagedata: datas) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let loginModal = try RenovationInspectionBase(result as! [String : Any])
                    completion(true,loginModal as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
       
    }
    static func submit_DoorAccessPayment(signature: Data?, parameters:[String:Any],completion:@escaping completionHandler)
    {
        var datas = [Data]()
        if signature != nil{
        datas.append(signature!)
        }
        ServiceManager.sharedInstance.postMethod_UploadData1(API.kEForm_DoorAccessPayment, path: "signature", parameter: parameters, imagedata: datas) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let loginModal = try MoveIOInspectionBase(result as! [String : Any])
                    completion(true,loginModal as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
       
    }
    
    static func submit_DoorAccessAcknowledgement(signature: Data?, parameters:[String:Any],completion:@escaping completionHandler)
    {
        var datas = [Data]()
        if signature != nil{
        datas.append(signature!)
        }
        ServiceManager.sharedInstance.postMethod_UploadData1(API.kEForm_DoorAccessAcknowledgement, path: "signature", parameter: parameters, imagedata: datas) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let loginModal = try MoveIOInspectionBase(result as! [String : Any])
                    completion(true,loginModal as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
       
    }
    
    
    //MARK: ******************* CARD ACCESS MANAGEMENT ****************
    static func get_cardSummary(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kGetCardSummary, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try CardsSummaryModal(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    static func search_cardSummary(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kSearchCardSummary, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try CardsSummaryModal(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    static func delete_Card(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kDeleteCard, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try DeleteUserBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func create_Card(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kAddCard, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try CreateUnitBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func update_Card(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kEditCard, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try CreateUnitBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
   
  /*  static func search_feedback(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kFeedbackSearch, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try FeedbackModalBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    } */
    //MARK: ******************* DEVICE MANAGEMENT ****************
    
    static func get_deviceSummary(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kGetDeviceSummary, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try DeviceSummaryModal(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    static func search_deviceSummary(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kSearchDeviceSummary, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try DeviceSummaryModal(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    static func get_deviceLocationSummary(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kGetDeviceLocation, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try DeviceLocationBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    static func create_Device(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kAddDevice, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try CreateUnitBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
  //editdevice
    static func edit_Device(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kEditDevice, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try CreateUnitBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func delete_Device(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kDeleteDevice, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try DeleteUserBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func restart_Device(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kRestarteDevice, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try DeleteUserBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    
    //MARK: ******************* CONDO DOCUMENT ****************
    
    
    static func get_CondoCategory(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kGetCondoCategory, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try CondoCategoryBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    static func get_CondoDetail(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kGetCondoDetail, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try CondoDetailsBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    static func create_CondoDocument(files:[[String:Any]]?,parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        
        ServiceManager.sharedInstance.postMethodAlamofire_With_MultipleFile_Data(API.kCreateCondoDoc, with: parameters, imagedatas: files) { (status, result, error) in
            if status
            {
                let data = result?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try CreateCondoBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
            
        }
        
   }
    static func edit_CondoDocument(files:[[String:Any]]?,parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        
        ServiceManager.sharedInstance.postMethodAlamofire_With_MultipleFile_Data(API.kEditCondoDoc, with: parameters, imagedatas: files) { (status, result, error) in
            if status
            {
                let data = result?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try CreateCondoBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
            
        }
        
   }
    
    static func delete_CondoDoc(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kDeleteCondoDoc, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let userBase = try DeleteUserBase(result as! [String : Any])
                    completion(true,userBase as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    
    static func delete_CondoFiles(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kDeleteCondoFiles, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let userBase = try DeleteUserBase(result as! [String : Any])
                    completion(true,userBase as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    
    
    
    static func get_PaymentSettings(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kGetPaymentInfo, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try PaymentInfoSummaryBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    
    static func submit_PaymentInfo(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kSubmitPaymentInfo, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try PaymentInfoSummaryBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    
    static func get_HolidayInfo(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kGetHolidayInfo, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try HolidayInfoSummaryBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func submit_HolidayInfo(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kSubmitHolidayInfo, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try HolidayInfoSummaryBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    
    
    //MARK:  **********   STAFF DIGITAL ACCESS  *****
    static func get_faceUploadsList(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kGetFaceIds, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try FaceIdSummaryBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func get_staffRolesList(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kGetStaffRolesList, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try StaffRoleBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func get_buildingSummaryList(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kGetBuildingSummaryList, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try BuildingSummaryBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func create_buildingList(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kCreateBuildingList, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try BuildingSummaryBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func edit_buildingList(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kEditBuildingList, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try BuildingSummaryBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func delete_buildingList(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kDeleteBuildingList, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try BuildingSummaryBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func get_faceOptions(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kGetFaceOptions, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try FaceOptionSummaryBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func get_userByRole(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kGetUserByRole, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try UserByRoleSummaryBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func get_buildingUnitsList(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kGetBuildingUnitsList, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try BuildingUnitBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    
    static func upload_StaffFace_With(face: Data?, parameters:[String:Any],completion:@escaping completionHandler)
    {
        var datas = [Data]()
        if face != nil{
        datas.append(face!)
        }
        ServiceManager.sharedInstance.postMethod_UploadData1(API.kUploadStaffFace, path: "picture", parameter: parameters, imagedata: datas) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let responseModal = try SignatureUpdateModal(result as! [String : Any])
                    completion(true,responseModal as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    
    static func delete_StaffFace(parameters:[String:Any],completion:@escaping completionHandler)
    {
      
            
        
        ServiceManager.sharedInstance.postMethod(API.kDeleteFaceId, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try DeleteUserBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func get_ThinmooDeviceList(isBluetooth: Bool, parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        let service = isBluetooth ? API.kGetBluetoothDevices : API.kGetRemoteDevices
        
        ServiceManager.sharedInstance.postMethod(service, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try DeviceListModalBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    
    //MARK:  ********** GET THINMOO ACCESS TOKEN *****
    static func getThinmooAccessToken(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kGetThinmooToken, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try ThinmooTokenBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    //MARK:  ********** Assign devces *****
    static func get_assignedDeviceList(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kAssignDeviceList, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try AssignDeviceBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func update_assignedDeviceList(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kUpdateAssignDevice, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try DeleteUserBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    //MARK:  **********  INSERT BLUETOOTH THINMOO RECORD *****
    static func insert_thinmooRecord(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kInsertThinmooRecord, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try ThinmooRecordBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    
    
    //MARK:  **********   OPEN DOOR RECORDS  *****
    static func get_NormalDoorRecord(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kGetNormalDoorRecord, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try DoorRecordsBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    static func search_NormalDoorRecord(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kSearchNormalDoorRecord, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try DoorRecordsBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    static func get_BluetoothDoorRecord(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kGetBluetoothDoorRecord, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try BluetoothDoorRecordsBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func search_BluetoothDoorRecord(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kSearchBluetoothDoorRecord, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try BluetoothDoorRecordsBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    
    
    
    
    static func get_FailedDoorRecord(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kGetFailedDoorRecord, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try FailedDoorRecordsBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func search_FailedDoorRecord(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kSearchFailedDoorRecord, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try FailedDoorRecordsBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    
    
    
    static func get_CallUnitDoorRecord(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kGetCallUnitDoorRecord, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try CallUnitDoorRecordsBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func search_CallUnitDoorRecord(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kSearchCallUnitDoorRecord, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try CallUnitDoorRecordsBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    
    
    
    static func get_QRCodeDoorRecord(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kGetQRCodeDoorRecord, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try QRCodeDoorRecordsBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func search_QRCodeDoorRecord(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kSearchQRCodeDoorRecord, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try QRCodeDoorRecordsBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    
    //MARK:  **********   UNIT LIST TYPE SUMMARY  *****
    static func get_UnitListTypeSummary(unitlisttype:UnitListType,parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kGetUnitListTypeSummary, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    if unitlisttype == .contactinfo{
                        let response =  try ContactInfoBase(result as! [String : Any])
                        completion(true,response as AnyObject,nil)
                    }
                    else if unitlisttype == .keycollection{
                        let response =  try KeyCollectionSummaryBase(result as! [String : Any])
                        completion(true,response as AnyObject,nil)
                    }
                    
                    else if unitlisttype == .defects{
                        let response =  try DefectsModalBase(result as! [String : Any])
                        completion(true,response as AnyObject,nil)
                    }
                    else if unitlisttype == .facilitybooking{
                        let response =  try FacilityModalBase(result as! [String : Any])
                        completion(true,response as AnyObject,nil)
                    }
                    else if unitlisttype == .feedback{
                        let response =  try FeedbackModalBase(result as! [String : Any])
                        completion(true,response as AnyObject,nil)
                    }
                    else if unitlisttype == .moveinout{
                        let response =  try MoveInOutSummaryBase(result as! [String : Any])
                        completion(true,response as AnyObject,nil)
                    }
                    else if unitlisttype == .renovation{
                        let response =  try RenovationSummaryBase(result as! [String : Any])
                        completion(true,response as AnyObject,nil)
                    }
                    else if unitlisttype == .dooraccess{
                        let response =  try DoorAccessSummaryBase(result as! [String : Any])
                        completion(true,response as AnyObject,nil)
                    }
                    else if unitlisttype == .vehiclereg{
                        let response =  try VehicleRegSummaryBase(result as! [String : Any])
                        completion(true,response as AnyObject,nil)
                    }
                    else if unitlisttype == .updateAddress{
                        let response =  try UpdateAddressSummaryBase(result as! [String : Any])
                        completion(true,response as AnyObject,nil)
                    }
                    else if unitlisttype == .updateParticulars{
                        let response =  try UpdateParticularsSummaryBase(result as! [String : Any])
                        completion(true,response as AnyObject,nil)
                    }
                    else if unitlisttype == .accesscardmanagement{
                        let response =  try CardInfoBase(result as! [String : Any])
                        completion(true,response as AnyObject,nil)
                    }
                    else if unitlisttype == .visitormanagement{
                        let response =  try VisitorSummaryModalBase(result as! [String : Any])
                        completion(true,response as AnyObject,nil)
                    }
                    else if unitlisttype == .residentmanagement{
                        let response =  try ResidentMgmtBase(result as! [String : Any])
                        completion(true,response as AnyObject,nil)
                    }
                   
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    //MARK:  **********   RESIDENT MANAGEMENT  *****
    static func get_BatchInvoiceSummary(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kGetBatchInvoiceSummary, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try BatchSummaryBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func search_BatchInvoiceSummary(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kSearchBatchInvoiceSummary, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try BatchSummaryBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func get_InvoiceSummary(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kGetInvoiceSummary, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try InvoiceSummaryBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func search_InvoiceSummary(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kSearchInvoiceSummary, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try InvoiceSummaryBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func get_InvoiceDetail(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kGetInvoiceDetail, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try InvoiceDataBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func delete_BatchInvoice(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kDeleteBatchInvoice, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let userBase = try DeleteUserBase(result as! [String : Any])
                    completion(true,userBase as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    static func update_InvoicePayment(parameters:[String:Any],completion:@escaping completionHandler)
    {
        ServiceManager.sharedInstance.postMethod(API.kUpdateInvoicePayment, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let userBase = try DeleteUserBase(result as! [String : Any])
                    completion(true,userBase as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    
    
    //MARK:  **********  GET NOTIFICATIONS FOR USER *****
    static func get_NotificationSummary(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kGetNotification, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try NotificationBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    static func update_NotificationStatus(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kUpdateNotification, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try NotificationUpdateBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
}

