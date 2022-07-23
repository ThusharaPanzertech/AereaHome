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
    //MARK:  **********  GET PROPERTY LIST *****
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
    //MARK:  **********   USER MANAGEMENT *****
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
    
    
}

