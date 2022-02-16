//
//  ServiceManager.swift
//  sparX
//
//  Created by Srishti Innovative on 11/12/17.
//  Copyright © 2017 Srishti Innovative. All rights reserved.//

import UIKit
import Alamofire
var f = false
class ServiceManager: NSObject {
   static let sharedInstance = ServiceManager()
    typealias completionHandler = (_ status:Bool, _ result:DataResponse<Any>?,_ error:NSError?)->Void

    public var sessionManager: Alamofire.SessionManager // most of your web service clients will call through sessionManager
    public var backgroundSessionManager: Alamofire.SessionManager // your web services you intend to keep running when the system backgrounds your app will use this
    private override init() {
        self.sessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.default)
        self.backgroundSessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.background(withIdentifier: "com.sics.sportdare.backgroundtransfer"))
    }
    
    //MARK: POST
    
    
    func postMethod_UploadData(_ serviceName : String,path:String,parameter:[String:Any]?,imagedata:Data?, completion : @escaping completionHandler)
    {
        let headers = ["Content-Type":"application/x-www-form-urlencoded"]
        
        upload(multipartFormData: { (multipartFormData) in
            if imagedata != nil
            {
                
                multipartFormData.append(imagedata!, withName: "upload", fileName:"\( Utilities.makeFileName()).png", mimeType: "image/jpeg")
            }
            for (key, value) in parameter! {
                
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
            }
        }, usingThreshold: UInt64.init(), to: "\(kBaseUrl)"+"\(serviceName)", method: .post, headers: headers) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    //Print progress
                    print(progress)
                })
                upload.responseJSON { response in
                    if response.error == nil{
                        completion(true, response , nil)
                    }else
                    {
                        completion(false, response , response.error! as NSError)
                    }
                }
            case .failure(let encodingError):
                completion(false, nil, encodingError as NSError)
            }
        }
    }
    
    func postMethod_UploadData1(_ serviceName : String,path:String,parameter:[String:Any]?,imagedata:[Data]?, completion : @escaping completionHandler)
    {
        let headers = ["Content-Type":"application/x-www-form-urlencoded"]
        upload(multipartFormData: { (multipartFormData) in
            for (indx,data) in imagedata!.enumerated()
            {
                multipartFormData.append(data, withName: path , fileName:"\( Utilities.makeFileName()).png", mimeType: "image/jpeg")
            }
            
            for (key, value) in parameter! {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
            }
        }, usingThreshold: UInt64.init(), to: "\(kBaseUrl)"+"\(serviceName)", method: .post, headers: headers) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    //Print progress
                    print(progress)
                })
                upload.responseJSON { response in
                    if response.error == nil{
                        completion(true, response , nil)
                    }else
                    {
                        completion(false, response , response.error! as NSError)
                    }
                }
               
            case .failure(let encodingError):
                completion(false, nil, encodingError as NSError)
            }
        }
        
    }
    
    func postMethodAlamofire_With_Multiple_Data(_ serviceName : String, with params : [String:Any]?,imagedatas:[Data]?, completion : @escaping completionHandler)
    {
        let headers = ["Content-Type":"application/x-www-form-urlencoded"]
        upload(multipartFormData: { (multipartFormData) in
            for (indx,data) in imagedatas!.enumerated()
            {
//                if indx == 0{
//                    multipartFormData.append(data, withName: "upload" , fileName:"\( Utilities.makeFileName()).png", mimeType: "image/jpeg")
//                }
//                else{
                multipartFormData.append(data, withName: "upload" , fileName:"\( Utilities.makeFileName()).png", mimeType: "image/jpeg")
               // }
                
            }
            
            for (key, value) in params! {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
            }
        }, usingThreshold: UInt64.init(), to: "\(kBaseUrl)"+"\(serviceName)", method: .post, headers: headers) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    //Print progress
                    print(progress)
                })
                upload.responseJSON { response in
                    if response.error == nil{
                        completion(true, response , nil)
                    }else
                    {
                        completion(false, response , response.error! as NSError)
                    }
                }
               
            case .failure(let encodingError):
                completion(false, nil, encodingError as NSError)
            }
        }
        
        
        
       
        
    }
    
    
    func postMethodAlamofire_With_Multiple_Data1(_ serviceName : String, with params : [String:Any]?,imagedatas:[[String:Any]]?, completion : @escaping completionHandler)
    {
        let headers = ["Content-Type":"application/x-www-form-urlencoded"]
        upload(multipartFormData: { (multipartFormData) in
            for (indx,data) in imagedatas!.enumerated()
            {
               
                multipartFormData.append(data["image"] as! Data, withName: data["name"] as! String , fileName:"\(Utilities.makeFileName()).png", mimeType: "image/jpeg")
                
                
            }
            
            for (key, value) in params! {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
            }
        }, usingThreshold: UInt64.init(), to: "\(kBaseUrl)"+"\(serviceName)", method: .post, headers: headers) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    //Print progress
                    print(progress)
                })
                upload.responseJSON { response in
                    if response.error == nil{
                        completion(true, response , nil)
                    }else
                    {
                        completion(false, response , response.error! as NSError)
                    }
                }
               
            case .failure(let encodingError):
                completion(false, nil, encodingError as NSError)
            }
        }
        
        
        
       
        
    }
    
    
    func postMethodAlamofire_With_MultipleFile_Data(_ serviceName : String, with params : [String:Any]?,imagedatas:[[String:Any]]?, completion : @escaping completionHandler)
    {
        let headers = ["Content-Type":"application/x-www-form-urlencoded"]
        upload(multipartFormData: { (multipartFormData) in
            for (indx,data) in imagedatas!.enumerated()
            {
               
                multipartFormData.append(data["image"] as! Data, withName: data["name"] as! String , fileName:"\(Utilities.makeFileName())", mimeType: data["extension"] as! String)
                
                
            }
            
            for (key, value) in params! {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
            }
        }, usingThreshold: UInt64.init(), to: "\(kBaseUrl)"+"\(serviceName)", method: .post, headers: headers) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    //Print progress
                    print(progress)
                })
                upload.responseJSON { response in
                    if response.error == nil{
                        completion(true, response , nil)
                    }else
                    {
                        completion(false, response , response.error! as NSError)
                    }
                }
               
            case .failure(let encodingError):
                completion(false, nil, encodingError as NSError)
            }
        }
        
        
        
       
        
    }
    

    
    func postMethod(_ service : String, parameter:[String:Any]? ,completion :@escaping completionHandler)
    {
      
  
        let headers = ["Content-Type":"application/x-www-form-urlencoded"]
        request("\(kBaseUrl)"+"\(service)", method: .post, parameters: parameter, encoding: URLEncoding.httpBody, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let jsonData):
              //  print("Success with JSON: \(jsonData)")
                let dictionary = jsonData as! NSDictionary
                if  let status = dictionary.object(forKey: "response") as? Bool
                {
                if(status){
                      completion(true,response,nil)
                }else{
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : dictionary.value(forKey: "message")! as! String])
                    _ = dictionary.value(forKey: "message")! as? String
                    
                   completion(false,nil,error)
                }
                }
                else{
                    if  let status = dictionary.object(forKey: "response") as? String
                    {
                        if(status == "success"){
                            completion(true,response,nil)
                        }else{
                            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : dictionary.value(forKey: "message")! as! String])
                            _ = dictionary.value(forKey: "message")! as? String
                            
                            completion(false,nil,error)
                        }
                    }
                    else{
                        if  let status = dictionary.object(forKey: "status") as? String
                        {
                            if(status == "success"){
                                completion(true,response,nil)
                            }else{
                                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : dictionary.value(forKey: "message")! as! String])
                                _ = dictionary.value(forKey: "message")! as? String
                                
                                completion(false,nil,error)
                            }
                        }
                        else{
                        if (dictionary.object(forKey: "data") as? NSArray) != nil{
                        completion(true,response,nil)
                        }
                        else{
                            completion(true,response,nil)
                        }
                        }
                    }
                }
                
            case .failure(let error):
                completion(false, nil, error as NSError)
            }
        }
    }
   
    func postMethod_With_Auth(_ service : String, parameter:[String:Any]? ,completion :@escaping completionHandler)
    {
       
      //    let  headers = ["Content-Type":"application/x-www-form-urlencoded","Authorization": "Bearer \(UserBase.currentUser!.token!)"]
       
    
        let headers = ["Content-Type":"application/x-www-form-urlencoded"]
        request("\(kBaseUrl)"+"\(service)", method: .post, parameters: parameter, encoding: URLEncoding.httpBody, headers: headers).responseJSON { (response) in
                switch response.result {
                case .success( _):
                completion(true, response , nil)
                
                case .failure(let error):
                completion(false, nil, error as NSError)
                }
        }
    }
    
  
    
    
    //MARK: GET
    func getMethodAlamofire(_ url : String, completion :@escaping completionHandler)
    {

        request(url).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success( _):
                completion(true, response , nil)
                
            case .failure(let error):
                completion(false, nil, error as NSError)
            }
        })
        
    }
    func getMethodAlamofire_With_Header(_ url : String,parameters:[String:Any]? , isToRefresh: Bool,completion :@escaping completionHandler)
    {
        
        let headers = ["Content-Type" : "application/json","Accept" : "application/json"]

     
        
       //"http://jui.panzerplayground.com/verifyLoginApi?email=balamurugan.sk@gmail.com&password=newnew"

        Alamofire.request(url,method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in

        switch(response.result) {
        case .success(_):
        if response.result.value != nil

        {
        print("response : \(response.result.value!)")
            completion(true, response , nil)
        }
        else
        {
        print("Error")
        }
        break
        case .failure(_):
        print("Failure : \(response.result.error!)")
            completion(false, nil, response.result.error as NSError?)
        break
        }
        }
        
        
        
        
        
        /*
        
        
        let headers = ["Content-Type":"application/x-www-form-urlencoded"]
      //  let token = isToRefresh == false ? UserBase.currentUser!.token! : UserBase.currentUser!.refreshToken!
      //  let headers = ["Content-Type":"application/x-www-form-urlencoded","Authorization": "Bearer \(token)"]
        request("\(kBaseUrl)"+"\(url)", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success( _):
                completion(true, response , nil)
                
            case .failure(let error):
                completion(false, nil, error as NSError)
            }
        })*/
     
    }
   
    
    
  
}
