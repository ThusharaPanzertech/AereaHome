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
    static func retrieve_User_Info(email:String, completion:@escaping completionHandler)
    {
        
        let requestUrl = "\(kBaseUrl)"+"\(API.kRetrieveInfo)?email=\(email)"
        ServiceManager.sharedInstance.getMethodAlamofire_With_Header(requestUrl, parameters:[:], isToRefresh: false) { status, response, error in
              if status
              {
                  let data = response?.data
                  do{
                      let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                      
                      let loginModal = try VerifyEmailModal(result as! [String : Any])
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
    static func send_Enquiry(parameters:[String:Any], completion:@escaping completionHandler)
    {
        
        ServiceManager.sharedInstance.postMethod(API.kEnquiry, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let enquiryModal = try EnquiryResponseModal(result as! [String : Any])
                    completion(true,enquiryModal as AnyObject,nil)
                }catch let error {
                    print(error)
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
                    
                    let loginModal = try VerifyEmailModal(result as! [String : Any])
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
    //MARK:  **********  GET OTP USER *****
    static func getOtp_User(parameters:[String:Any], completion:@escaping completionHandler)
    {
        
        ServiceManager.sharedInstance.postMethod(API.kForgetPassword, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let loginModal = try VerifyEmailModal(result as! [String : Any])
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
    //MARK:  **********  SET PASSWORD *****
    static func setPassword_User_With(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
   //     let requestUrl = "\(kBaseUrl)"+"\(API.kLogin)?email=\(email)&password=\(password)"
        
        ServiceManager.sharedInstance.postMethod(API.kSetPassword, parameter: parameters) { status, response, error in
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
    //MARK:  **********  UPDATE PROFILE PICTURE *****
    static func updatePicture_User_With(profilePic: Data?, parameters:[String:Any],completion:@escaping completionHandler)
    {
        var datas = [Data]()
        if profilePic != nil{
        datas.append(profilePic!)
        }
        ServiceManager.sharedInstance.postMethod_UploadData1(API.kUpdateProfilePicture, path: "picture", parameter: parameters, imagedata: datas) { status, response, error in
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
    //MARK:  **********  UPDATE PASSWORD *****
    static func updatePassword_User_With(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kUpdatePassword, parameter: parameters) { status, response, error in
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
    //MARK:  **********  UPDATE ADDRESS *****
    static func updateAddress_User_With(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kUpdateAddress, parameter: parameters) { status, response, error in
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
    //MARK:  **********  GET USER INFO *****
    static func get_User_With(userId: String,completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kGetUserInfo, parameter: ["user_id":userId]) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let loginModal = try UserInfoModalBase(result as! [String : Any])
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
    //MARK:  **********  GET INBOX FOR USER *****
    static func get_Inbox(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kGetInbox, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try InboxModalBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    //MARK:  **********  GET UPCOMING EVENTS FOR USER *****
    static func get_Upcoming(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kGetUpcomingEvents, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try UpcomingModalBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    //MARK:  **********  GET ANNOUNCEMENTS FOR USER *****
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
    //MARK:  **********  CHECK APPOINTMENT FOR USER *****
    static func check_Appointment(type: Appointment,parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        let service =  type == .unitTakeOver ? API.kCheckUnitTakeOver : API.kCheckJointInspection
        ServiceManager.sharedInstance.postMethod(service, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try AppointmentModalBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    //MARK:  **********  BOOK APPOINTMENT FOR USER *****
    static func book_Appointment(type: Appointment,parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        let service =  type == .unitTakeOver ? API.kBookkUnitTakeOver : API.kBookkJointInspection
        ServiceManager.sharedInstance.postMethod(service, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try BookAppointmentModalBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    //MARK:  **********  CHECK APPOINTMENT TIMESLOTS *****
    static func check_AppointmentTimeSlots(type: Appointment,parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        let service =  type == .unitTakeOver ? API.kCheckUnitTakeOverTimeSlots : type == .jointInspection ? API.kCheckJointInspectionTimeSlots : API.kCheckFacilityTimeSlots
        ServiceManager.sharedInstance.postMethod(service, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try AppointmentTimeSlotModalBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    //MARK:  **********  GET DEFECTS LIST FOR USER *****
    static func get_DefectsList(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kGetDefectsList, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try DefectsListModalBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    //MARK:  **********  GET FACILITY LIST FOR USER *****
    static func get_FacilityList(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kGetFacilityList, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try FacilityListModalBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    //MARK:  **********  GET FEEDBACK LIST FOR USER *****
    static func get_FeedbackList(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kGetFeedbackList, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try FeedbackListModalBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    
    
    //MARK:  **********  GET FEEDBACK CATEGORY *****
   static func get_FeedbackCategory(parameters:[String:Any],completion:@escaping completionHandler)
   {
       
       
       ServiceManager.sharedInstance.postMethod(API.kGetFeedbackCategory, parameter: parameters) { status, response, error in
           if status
           {
               let data = response?.data
               do{
                   let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                   
                   let response =  try FeedbackTypeModalBase(result as! [String : Any])
                   completion(true,response as AnyObject,nil)
               }catch let error {
                   print(error)
                   completion(false,nil,error as NSError)
               }
           }
           else
           {
               completion(status,nil,error)
           }
       }
       
       
    
   }
    //MARK:  **********  SUBMIT FEEDBACK FOR USER *****
    static func submit_Feedback(files:[Data]?,parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        let service =  API.kSubmitFeedback
        
        ServiceManager.sharedInstance.postMethodAlamofire_With_Multiple_Data(API.kSubmitFeedback, with: parameters, imagedatas: files) { (status, result, error) in
            if status
            {
                let data = result?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try SubmitFeedbackModalBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
            
        }
        
    }
        
        /*
        ServiceManager.sharedInstance.postMethod(service, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try SubmitFeedbackModalBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
 
        }
        */
        
     
    
//MARK:  **********  SUBMIT DEFECTS FOR USER *****
static func submit_Defects(files:[[String:Any]]?,parameters:[String:Any],completion:@escaping completionHandler)
{
    
    
    
    ServiceManager.sharedInstance.postMethodAlamofire_With_Multiple_Data1(API.kSubmitDefects, with: parameters, imagedatas: files) { (status, result, error) in
        if status
        {
            let data = result?.data
            do{
                let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                
                let response =  try SubmitFeedbackModalBase(result as! [String : Any])
                completion(true,response as AnyObject,nil)
            }catch let error {
                print(error)
                completion(false,nil,error as NSError)
            }
        }
        else
        {
            completion(status,nil,error)
        }
        
    }
    
    
    
    
    
 
}
    //MARK:  **********  GET DEFECTS LOCATION FOR USER *****
    static func get_DefectsType(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kGetDefectsType, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try DefectsTypeModalBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    //MARK:  **********  GET DEFECTS LIST FOR USER *****
    static func get_DefectsLocation(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kGetDefectsLocation, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try DefectsLocationModalBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
   
    
    
    //MARK:  **********  GET FACILITIES TYPE FOR USER *****
    static func get_FacilitiesType(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kGetFacilityType, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try FacilityTypeModalBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    //MARK:  **********  BOOK Facility FOR USER *****
    static func book_Facility(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        ServiceManager.sharedInstance.postMethod(API.kBookFacility, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try BookFacilityModalBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    
    
    
    
    
    //MARK:  **********  DETAILS API *****
    static func get_FacilityDetails(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kFacilityDetail, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try FacilityDetailModalBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    static func get_DefectDetails(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kDefectDetail, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try DefectDetailModalBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    static func get_FeedbackDetails(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        ServiceManager.sharedInstance.postMethod(API.kFeedbackDetail, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try FeedbackDetailModalBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    
    static func get_AnnouncementDetails(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kAnnouncementDetail, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try AnnouncementDetailModalBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    static func get_UnitTakeOverDetails(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        ServiceManager.sharedInstance.postMethod(API.kUnitTakeOvertDetail, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try AppointmentDetailBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    static func get_InspectionDetails(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        ServiceManager.sharedInstance.postMethod(API.kInspectionDetail, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try AppointmentDetailBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    
    static func update_AnnouncementViewStatus(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kUpdateAnnouncementReadStatus, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try AnnouncementStatusUpdate(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }
    
    
    
    //MARK:  ********** CONDO DOCUMENTS *****
    //MARK:  ***************************************
    static func get_CondoCategory(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kgetCondoCategory, parameter: parameters) { status, response, error in
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
    
    static func get_CondoCategoryFiles(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kgetCondoCategoryFiles, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try CondoCategoryFilesBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
    }
    
    
    //MARK:  ********** FORM UPLOAD  *****
    //MARK:  ***************************************
    static func get_DocumentType(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kgetDocumentType, parameter: parameters) { status, response, error in
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
    static func submit_Files(files:[[String:Any]]?,parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        
        ServiceManager.sharedInstance.postMethodAlamofire_With_MultipleFile_Data(API.kResidentFileUpload, with: parameters, imagedatas: files) { (status, result, error) in
            if status
            {
                let data = result?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try SubmitFileBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
            
        }
        
        
        
        
        
     
    }
    
    static func get_FormsList(parameters:[String:Any],completion:@escaping completionHandler)
    {
        
        
        ServiceManager.sharedInstance.postMethod(API.kGetUploadedList, parameter: parameters) { status, response, error in
            if status
            {
                let data = response?.data
                do{
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    let response =  try FormsListModalBase(result as! [String : Any])
                    completion(true,response as AnyObject,nil)
                }catch let error {
                    print(error)
                    completion(false,nil,error as NSError)
                }
            }
            else
            {
                completion(status,nil,error)
            }
        }
        
        
     
    }

    
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
}

/*   ServiceManager.sharedInstance.getMethodAlamofire_With_Header(requestUrl, parameters:[:], isToRefresh: false) { status, response, error in
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
}*/
