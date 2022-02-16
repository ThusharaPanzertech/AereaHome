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
}
