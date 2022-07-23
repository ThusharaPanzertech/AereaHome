//
//  Modal.swift
//  JUI Residence
//
//  Created by Thushara Harish on 25/10/21.
//

import Foundation
import Tailor

struct LoginModal: SafeMappable {
    var message:String = ""
    var response:Int!
    var user_id: Int = 0
    
    init(_ map: [String : Any]) throws {
        user_id <- map.property("user_id")
        message <- map.property("message")
        response <- map.property("response")
    }
}
struct VerifyOtpModal: SafeMappable {
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        message <- map.property("message")
        response <- map.property("response")
    }
}

//MARK: ************** ANNOUNCEMENT ********
struct AnnouncementModalBase: SafeMappable {
    var announcements:[AnnouncementModal] = []
    var file_path:String = ""
    var message:String = ""
    var response:Bool!
    
    init(_ map: [String : Any]) throws {
        if map["data"] != nil{
        announcements <- map.relations("data")
        }
        else{
            announcements <- map.relations("lists")
        }
        file_path <- map.property("file_path")
        message <- map.property("message")
        response <- map.property("response")
        
    }
}

struct AnnouncementModal: SafeMappable {
    var id:Int = 0
    var account_id: Int = 0
    var title:String = ""
    var document:String = ""
    var notes:String = ""
    var upload:String = ""
    var roles:String = ""
    var created_at:String = ""
    var updated_at:String = ""
    
    
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        account_id <- map.property("account_id")
        title <- map.property("title")
        document <- map.property("document")
        notes <- map.property("notes")
        upload <- map.property("upload")
        roles <- map.property("roles")
        created_at <- map.property("created_at")
        updated_at <- map.property("updated_at")
  }
}

struct CreateAnnouncementBase: SafeMappable {
    var announcement:AnnouncementModal!
    var message:String = ""
    var response:Bool!
    
    init(_ map: [String : Any]) throws {
        announcement <- map.relation("user_info")
        
       
        message <- map.property("message")
        response <- map.property("response")
        
    }
}

//MARK: ************** USER SUMMARY ********
struct UserSummaryBase: SafeMappable {
    var users:[UserModal]!
    var message:String = ""
    var roles = [String: String]()
    var response:Bool!
    
    init(_ map: [String : Any]) throws {
        users <- map.relations("users")
        message <- map.property("message")
        roles <- map.property("roles")
        response <- map.property("response")
        
    }
}

struct UserModal: SafeMappable {
    
    var cardInfo : CardInfo!
    
    
    
    init(_ map: [String : Any]) throws {
        cardInfo <- map.relation("card")
       
        
  }
}
struct CardInfo: SafeMappable {
   
    
    var id:Int!
    var account_id:Int!
    var role_id:Int!
    var unit_no = 0
    var account_enabled:Int!
    
    var name:String!
    var email:String!
    var created_at:String = ""
    var updated_at:String = ""
    var userInfo: UserInfo?
    var getunit: GetUnit?
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        account_id <- map.property("account_id")
        role_id <- map.property("role_id")
        unit_no <- map.property("unit_no")
        account_enabled <- map.property("account_enabled")
        name <- map.property("name")
        email <- map.property("email")
        userInfo <- map.relation("userinfo")
        created_at <- map.property("created_at")
        updated_at <- map.property("updated_at")
        getunit <- map.relation("getunit")
    }
}
//MARK: ************** ROLES details ********
struct RolesBase: SafeMappable {
    var roles = [String: String]()
    var data = [Role]()
    var message:String = ""
    var response:Bool!
    
    init(_ map: [String : Any]) throws {
        roles <- map.property("roles")
        data <- map.relations("data")
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
//MARK: ************** UNIT details ********
struct UnitBase: SafeMappable {
    var units:[Unit] = []
    //= [String: String]()
    var message:String = ""
    var response:Bool!
    
    init(_ map: [String : Any]) throws {
        units <- map.relations("units")
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
//MARK: ************** LOGIN details ********

struct DashboardInfoModalBase: SafeMappable {
    var menu:[DashboardMenu] = []
    var settings:[DashboardMenu] = []
    var message:String = ""
    var response:Int = 0
  
    init(_ map: [String : Any]) throws {
        menu <- map.relations("menu")
        settings <- map.relations("settings")
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
struct DashboardMenu: SafeMappable {
    var menus_lists:[DashboardMenuList] = []
    var menu_group:String = ""
  
    init(_ map: [String : Any]) throws {
        menus_lists <- map.relations("menus_lists")
        menu_group <- map.property("menu_group")
        
    }
}
struct DashboardMenuList: SafeMappable {
    var name:String = ""
    var id = 0
    var permission = 0
  
    init(_ map: [String : Any]) throws {
        name <- map.property("name")
        id <- map.property("id")
        permission <- map.property("permission")
        
    }
}
struct LoginInfoModalBase: SafeMappable {
    var data: LoginData!
    var modules:[Module] = []
    var message:String = ""
    var response:Bool!
  
    init(_ map: [String : Any]) throws {
        data <- map.relation("data")
        modules <- map.relations("modules")
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
struct LoginData: SafeMappable {
    var id = 0
    var account_id = 0
    var role_id = 0
    var building_no = 0
    var unit_no = 0
    var name = ""
    var email = ""
    var email_verified_at = ""
    var account_enabled = 0
    
    
  
    var permissions:[Permissions] = []
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        account_id <- map.property("account_id")
        role_id <- map.property("role_id")
        building_no <- map.property("building_no")
        unit_no <- map.property("unit_no")
        name <- map.property("name")
        email <- map.property("email")
        email_verified_at <- map.property("email_verified_at")
        account_enabled <- map.property("account_enabled")
        
        
        
        
        permissions <- map.relations("permission")
       
  }
}





//MARK: ************** USER details ********
struct UserInfoModalBase: SafeMappable {
    var users: Users!
    var message:String = ""
    var response:Bool!
  
    init(_ map: [String : Any]) throws {
        users <- map.relation("users")
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
struct Users: SafeMappable {
    var user:User?
    var role:Role?
    var moreInfo:MoreInfo?
    var unit:Unit?
    var property:Property?
    var permissions:[Permissions] = []
    static var currentUser:Users? = nil
    var file_path: String!
    init(_ map: [String : Any]) throws {
        user <- map.relation("user")
        role <- map.relation("role")
        moreInfo <- map.relation("moreinfo")
        unit <- map.relation("unit")
        property <- map.relation("property")
        permissions <- map.relations("permissions")
        file_path <- map.property("file_path")
        
  }
}
struct User: SafeMappable {
    var id:Int!
    var account_id:Int!
    var role_id:Int!
    var unit_no = 0
    var name:String!
    var email:String!
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        account_id <- map.property("account_id")
        role_id <- map.property("role_id")
        unit_no <- map.property("unit_no")
        name <- map.property("name")
        email <- map.property("email")
        
    }
}
struct UserInfo: SafeMappable {
    var user_id:Int!
    var profile_picture:String!
    var last_name:String!
    var phone:String!
    var unit_no:Int!
    var mailing_address:String!
    var company_name: String!
    
    init(_ map: [String : Any]) throws {
        user_id <- map.property("user_id")
        profile_picture <- map.property("profile_picture")
       
        last_name <- map.property("last_name")
        phone <- map.property("phone")
        unit_no <- map.property("unit_no")
        mailing_address <- map.property("mailing_address")
        company_name <- map.property("company_name")
    }
}

struct Role: SafeMappable {
    var id:Int!
    var status:Int!
    var type:Int!
    var account_id:Int!
    var name:String!
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        account_id <- map.property("account_id")
        name <- map.property("name")
        status <- map.property("status")
        type <- map.property("type")
        
    }
}
struct MoreInfo: SafeMappable {
    var user_id:Int!
    var profile_picture:String!
    var last_name:String!
    var phone:String!
    var postal_code:String!
    var unit_no:Int!
    var mailing_address:String!
    var company_name: String!
    var face_picture:String!
    init(_ map: [String : Any]) throws {
        user_id <- map.property("user_id")
        profile_picture <- map.property("profile_picture")
        last_name <- map.property("last_name")
        phone <- map.property("phone")
        unit_no <- map.property("unit_no")
        mailing_address <- map.property("mailing_address")
        company_name <- map.property("company_name")
        face_picture <- map.property("face_picture")
        postal_code <- map.property("postal_code")
    }
}
struct Unit: SafeMappable {
    var id:Int = 0
    var account_id:Int = 0
    var unit:String = ""
    var size:String = ""
    var share_amount:String = ""
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        account_id <- map.property("account_id")
        unit <- map.property("unit")
        size <- map.property("size")
        share_amount <- map.property("share_amount")
        
    }
}
struct PropertyListBase: SafeMappable {
    var data:[Property] = []
    var current_property = 0
    var response = 0
    var message:String = ""
   
    
    
    init(_ map: [String : Any]) throws {
        data <- map.relations("data")
        current_property <- map.property("current_property")
        response <- map.property("response")
        message <- map.property("message")
       
        
    }
}

struct Property: SafeMappable {
    var id:Int = 0
    var company_name:String = ""
    var company_email:String = ""
    var company_contact:String = ""
    var security_option:String = ""
    var company_logo:String = ""

    var share_amount:String = ""
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        company_name <- map.property("company_name")
        company_email <- map.property("company_email")
        company_contact <- map.property("company_contact")
        security_option <- map.property("security_option")
        company_logo <- map.property("company_logo")
        
    }
}

struct Permissions: SafeMappable {
    var id:Int = 0
    var user_id:Int = 0
    var role_id = 0
    var module_id:String = ""
    var view = 0
    var create = 0
    var edit = 0
    var delete = 0
    var status = 0
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        user_id <- map.property("user_id")
        role_id <- map.property("role_id")
        module_id <- map.property("module_id")
        view <- map.property("view")
        create <- map.property("create")
        edit <- map.property("edit")
        delete <- map.property("delete")
        status <- map.property("status")
        
    }
}


//MARK: ************** CREATE USER  ********
struct CreateUserBase: SafeMappable {
    var user_info:CreateUserInfo!
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        user_info <- map.relation("user_info")
        message <- map.property("message")
        response <- map.property("response")
        
    }
}

struct CreateUserInfo: SafeMappable {
    var userInfo_Basic:UserInfo_Basic!
    var userInfo_More:UserInfo_More!
    
    
    
    init(_ map: [String : Any]) throws {
        userInfo_Basic <- map.relation("basic")
        userInfo_More <- map.relation("more")
       
  }
}
struct UserInfo_Basic: SafeMappable {
   
    var role_id:String = ""
    var unit_no:String = ""
    var name:String = ""
    var email:String = ""
   
    
    
    
    init(_ map: [String : Any]) throws {
      
        role_id <- map.property("role_id")
        unit_no <- map.property("unit_no")
        name <- map.property("name")
        email <- map.property("email")
       
        
  }
}
struct UserInfo_More: SafeMappable {
    var user_id:Int = 0
    var last_name:String = ""
    var phone:String = ""
    var unit_no:String = ""
    var company_name:String = ""
    var mailing_address:String = ""
    var postal_code:String = ""
    
    
    
    init(_ map: [String : Any]) throws {
        user_id <- map.property("user_id")
        last_name <- map.property("last_name")
        phone <- map.property("phone")
        unit_no <- map.property("unit_no")
        company_name <- map.property("company_name")
        mailing_address <- map.property("mailing_address")
        postal_code <- map.property("postal_code")
       
        
  }
}
//MARK: ************** UPDATE USER  ********
struct UpdateUserBase: SafeMappable {
    var data:String = ""
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        data <- map.property("data")
        message <- map.property("message")
        response <- map.property("response")
        
    }
}

//MARK: ************** DELETE USER  ********
struct DeleteUserBase: SafeMappable {
    var data:String = ""
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        data <- map.property("data")
        message <- map.property("message")
        response <- map.property("response")
        
    }
}


//MARK: ************** KEY COLLECTION SUMMARY ********
struct KeyCollectionSummaryBase: SafeMappable {
    var data:[KeyCollectionModal]!
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        data <- map.relations("data")
        message <- map.property("message")
        response <- map.property("response")
        
    }
}

struct KeyCollectionModal: SafeMappable {
    var submission_info:SubmissionInfo!
    var unit_info:Unit!
    var user_info:User!
   
    
    
    
    init(_ map: [String : Any]) throws {
        submission_info <- map.relation("submission_info")
        unit_info <- map.relation("unit_info")
        user_info <- map.relation("user_info")
       
        
  }
}
struct SubmissionInfo: SafeMappable {
    var id:Int = 0
    var account_id: Int = 0
    var user_id:Int = 0
    var unit_no:Int = 0
    var appt_date: String = ""
    var appt_time: String = ""
    var nricid_1: String = ""
    var nricid_2: String = ""
    var status:Int = 0
    var notification_status: Int = 0
    var reason: String = ""
    var getunit: GetUnit?
    var getname: GetName?
    var created_at:String = ""
    var updated_at:String = ""
     
    
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        account_id <- map.property("account_id")
        user_id <- map.property("user_id")
        unit_no <- map.property("unit_no")
        appt_date <- map.property("appt_date")
        appt_time <- map.property("appt_time")
        nricid_1 <- map.property("nricid_1")
        nricid_2 <- map.property("nricid_2")
        status <- map.property("status")
        notification_status <- map.property("notification_status")
        reason <- map.property("reason")
        getunit <- map.relation("getunit")
        getname <- map.relation("getname")
        created_at <- map.property("created_at")
        updated_at <- map.property("updated_at")
        
  }
}
struct GetUnit: SafeMappable {
    var id:Int = 0
    var account_id = 0
    var unit:String = ""
   
    
    
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        account_id <- map.property("account_id")
        unit <- map.property("unit")
       
        
  }
}
struct GetName: SafeMappable {
    var id:Int = 0
    var account_id = 0
    var role_id:Int = 0
    var unit_no = 0
    var name:String = ""
    var email:String = ""
   
    
    
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        account_id <- map.property("account_id")
        role_id <- map.property("role_id")
        unit_no <- map.property("unit_no")
        name <- map.property("name")
        email <- map.property("email")
       
        
  }
}
//MARK: ************** FEEDBACK ********
struct FeedbackOptionsBase: SafeMappable {
    var options = [String: String]()
    var message:String = ""
    var response:Bool!
    
    init(_ map: [String : Any]) throws {
        options <- map.property("options")
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
struct FeedbackModalBase: SafeMappable {
    var data: [FeedbackModal]!
    var message:String = ""
    var response:Int = 0
    
    init(_ map: [String : Any]) throws {
        data <- map.relations("data")
        message <- map.property("message")
        response <- map.property("response")
        
    }
}

struct FeedbackDetailBase: SafeMappable {
    var feedback: FeedbackModal!
    var message:String = ""
    var response:Int = 0
    
    init(_ map: [String : Any]) throws {
        feedback <- map.relation("feedback")
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
struct FeedbackModal: SafeMappable {
    var submissions:FeedbackSubmission!
    var option:FeedbackOption?
    var user_info:User?
   
    
    
    
    init(_ map: [String : Any]) throws {
        submissions <- map.relation("submissions")
        option <- map.relation("option")
        user_info <- map.relation("user_info")
       
        
  }
}

struct FeedbackOption: SafeMappable {
    var id:Int = 0
    var account_id = 0
    var status:Int = 0
    var feedback_option:String = ""
   
  
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        account_id <- map.property("account_id")
        status <- map.property("status")
        feedback_option <- map.property("feedback_option")
     
       
        
  }
}
struct FeedbackSubmission: SafeMappable {
    var id:Int = 0
    var account_id = 0
    var status:Int = 0
    var ticket:String = ""
    var fb_option: Int = 0
    
    var upload_1:String = ""
    var upload_2:String = ""
    var upload_3:String = ""
    var upload_4:String = ""
    var upload_5:String = ""
    var notes:String = ""
    var subject:String = ""
    var user_id:Int = 0
    var view_status:Int = 0
    var remarks:String = ""
    var created_at:String = ""
    var updated_at:String = ""
    
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        account_id <- map.property("account_id")
        status <- map.property("status")
        ticket <- map.property("ticket")
        fb_option <- map.property("fb_option")
        upload_1 <- map.property("upload_1")
        upload_2 <- map.property("upload_2")
        upload_3 <- map.property("upload_3")
        upload_5 <- map.property("upload_5")
        upload_1 <- map.property("upload_1")
        subject  <- map.property("subject")
        notes <- map.property("notes")
        view_status <- map.property("view_status")
        user_id <- map.property("user_id")
        status <- map.property("status")
        remarks <- map.property("remarks")
        created_at <- map.property("created_at")
        updated_at <- map.property("updated_at")
        
  }
}

//MARK: ************** DEFECTS ********
struct DefectsModalBase: SafeMappable {
    var data: [Defects]!
    var message:String = ""
    var response:Int = 0
    
    init(_ map: [String : Any]) throws {
        data <- map.relations("data")
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
struct DefectDetailsModalBase: SafeMappable {
    var booking_info: DefectData!
    var message:String = ""
    var response:Int = 0
    var defect_type: [DefectType]!
    init(_ map: [String : Any]) throws {
        booking_info <- map.relation("booking_info")
        message <- map.property("message")
        response <- map.property("response")
        defect_type  <- map.relations("defect_type")
    }
}
struct Defects: SafeMappable {
    var lists:DefectData!
   
    var user_info:User?
   
    
    var inspection:InspectionApptInfo?
    
    init(_ map: [String : Any]) throws {
        lists <- map.relation("lists")
        user_info <- map.relation("user_info")
        inspection <- map.relation("inspection")
        
  }
}
struct DefectInspectionTimeSlotBase: SafeMappable {
    var data : [DefectInspectionTimeSlot]!
    var message:String = ""
    var response:Bool!
    
    init(_ map: [String : Any]) throws {
        data <- map.relations("data")
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
struct  DefectInspectionTimeSlot: SafeMappable {
    var time:String = ""
    
    init(_ map: [String : Any]) throws {

        time <- map.property("time")

        
    }
}
struct DefectData: SafeMappable {
    var id:Int = 0
    var account_id = 0
    var ref_id = ""
    var ticket = ""
    var notes = ""
    var user_id:Int = 0
    var status:Int = 0
    
    
    
    var signature:String = ""
    var inspection_owner_signature:String = ""
    var inspection_team_signature:String = ""
    var handover_owner_signature:String = ""
    var handover_team_signature:String = ""
   
    var remarks:String = ""
   
  var completion_date = ""
   
    var view_status:Int = 0
    var inspection_status:Int = 0
    var handover_status:Int = 0
    
    var created_at:String = ""
    var updated_at:String = ""
    
    var inspection:InspectionApptInfo?
    var submissions = [SubmittedDefects]()
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        account_id <- map.property("account_id")
        ref_id <- map.property("ref_id")
        ticket <- map.property("ticket")
        notes <- map.property("notes")
        user_id <- map.property("user_id")
        status <- map.property("status")
        completion_date <- map.property("completion_date")
        signature <- map.property("signature")
        inspection_owner_signature <- map.property("inspection_owner_signature")
        inspection_team_signature <- map.property("inspection_team_signature")
        handover_owner_signature <- map.property("handover_owner_signature")
        handover_team_signature <- map.property("handover_team_signature")
        
        view_status <- map.property("view_status")
        inspection_status <- map.property("inspection_status")
        handover_status <- map.property("handover_status")
        remarks <- map.property("remarks")
       
       
      
        
        user_id <- map.property("user_id")
       
        created_at <- map.property("created_at")
        updated_at <- map.property("updated_at")
        inspection <- map.relation("inspection")
        submissions <- map.relations("submissions")
  }
}
struct SubmittedDefects: SafeMappable {
    var id:Int = 0
    var def_id:Int = 0
    var defect_location:Int = 0
    var defect_type:Int = 0
    var upload:String = ""
    var notes:String = ""
    var user_id:Int = 0
    var status:Int = 0
    var remarks:String = ""
    var created_at:String = ""
    var updated_at:String = ""
    var owner_status = 0
    var handover_message = ""
    var defect_status = 0
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        def_id <- map.property("id")
        defect_location <- map.property("defect_location")
        defect_type <- map.property("defect_type")
        upload <- map.property("upload")
        notes <- map.property("notes")
        user_id <- map.property("user_id")
        status <- map.property("status")
        remarks <- map.property("remarks")
        created_at <- map.property("created_at")
        updated_at <- map.property("updated_at")
        handover_message <- map.property("handover_message")
        owner_status <- map.property("owner_status")
        defect_status <- map.property("defect_status")
  }
}
struct InspectionApptInfo: SafeMappable {
    var id:Int = 0
    var account_id: Int = 0
    var user_id:Int = 0
    var unit_no:Int = 0
    var appt_date: String = ""
    var appt_time: String = ""
    var nricid_1: String = ""
    var nricid_2: String = ""
    var status:Int = 0
    var progress_date: String = ""
    var reminder_in_days: String = ""
    var reminder_emails: String = ""
    var email_message: String = ""
    var reminder_email_send_on: String = ""
    var reminder_email_status = 0
    var notification_status: Int = 0
    var reason: String = ""
    
    
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        account_id <- map.property("account_id")
        user_id <- map.property("user_id")
        unit_no <- map.property("unit_no")
        appt_date <- map.property("appt_date")
        appt_time <- map.property("appt_time")
        nricid_1 <- map.property("nricid_1")
        nricid_2 <- map.property("nricid_2")
        status <- map.property("status")
        
        progress_date <- map.property("progress_date")
        reminder_in_days <- map.property("reminder_in_days")
        reminder_emails <- map.property("reminder_emails")
        email_message <- map.property("email_message")
        reminder_email_send_on <- map.property("reminder_email_send_on")
        reminder_email_status <- map.property("reminder_email_status")
        
        notification_status <- map.property("notification_status")
        reason <- map.property("reason")
       
        
  }
}
struct SignatureUpdateModal: SafeMappable {
    var message:String = ""
    var response: Int = 0
    var result: Int = 0
    
    init(_ map: [String : Any]) throws {
        result <- map.property("result")
        message <- map.property("message")
        response <- map.property("response")
    }
}

//MARK: ************** FACILITY ********
struct FacilityOptionsBase: SafeMappable {
    var options = [String: String]()
    var message:String = ""
    var response:Bool!
    
    init(_ map: [String : Any]) throws {
        options <- map.property("options")
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
struct FacilityModalBase: SafeMappable {
    var data: [FacilityModal]!
    var message:String = ""
    var response:Int = 0
    
    init(_ map: [String : Any]) throws {
        data <- map.relations("data")
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
struct FacilityModal: SafeMappable {
    var submissions:FacilitySubmission!
    var type:FacilityOption?
    var user_info:User?
   
    
    
    
    init(_ map: [String : Any]) throws {
        submissions <- map.relation("submissions")
        type <- map.relation("type")
        user_info <- map.relation("user_info")
       
        
  }
}

struct FacilityOption: SafeMappable {
    var id:Int = 0
    var account_id = 0
    var status:Int = 0
    var facility_type:String = ""
    var timing:String = ""
    var notes:String = ""
    var created_at:String = ""
    var updated_at:String = ""
    var allowed_size:Int = 0
    var next_booking_allowed = 0
    var allowed_booking_for:Int = 0
    var next_booking_allowed_days:Int = 0
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        account_id <- map.property("account_id")
        status <- map.property("status")
        facility_type <- map.property("facility_type")
     
        timing <- map.property("timing")
        notes <- map.property("notes")
        created_at <- map.property("created_at")
        updated_at <- map.property("updated_at")
        allowed_size <- map.property("allowed_size")
        next_booking_allowed <- map.property("next_booking_allowed")
        allowed_booking_for <- map.property("allowed_booking_for")
        next_booking_allowed_days <- map.property("next_booking_allowed_days")
        
  }
}
struct FacilitySubmission: SafeMappable {
    var id:Int = 0
    var account_id = 0
    var status:Int = 0
    var unit_no:Int = 0
    var type_id: Int = 0
    var user_id:Int = 0
    
    var booking_date:String = ""
    var booking_time:String = ""
    var reason:String = ""
   
  
   
    var view_status:Int = 0
    var notification_status:Int = 0
    var created_at:String = ""
    var updated_at:String = ""
    
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        account_id <- map.property("account_id")
        status <- map.property("status")
        unit_no <- map.property("unit_no")
        type_id <- map.property("type_id")
        booking_date <- map.property("booking_date")
        booking_time <- map.property("booking_time")
        reason <- map.property("reason")
       
      
        view_status <- map.property("view_status")
        user_id <- map.property("user_id")
        status <- map.property("status")
        notification_status <- map.property("notification_status")
        created_at <- map.property("created_at")
        updated_at <- map.property("updated_at")
        
  }
}
struct FacilityTimeSlotBase: SafeMappable {
    var data : [FacilityTimeSlot]!
    var message:String = ""
    var response:Bool!
    
    init(_ map: [String : Any]) throws {
        data <- map.relations("data")
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
struct FacilityTimeSlot: SafeMappable {
    var time:String = ""
    var count:Int!
    
    init(_ map: [String : Any]) throws {
        time <- map.property("time")
        count <- map.property("count")
        
    }
}
//MARK: ************** SETTINGS PROPERTY  ********
struct PropertyInfoModalBase: SafeMappable {
    var property:PropertyInfo!
    var message:String = ""
    var response:Bool!
    
    init(_ map: [String : Any]) throws {
        
        property <- map.relation("property")
        
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
struct PropertyInfo: SafeMappable {
    var id:Int = 0
    var company_name:String = ""
    var company_email:String = ""
    var company_contact:String = ""
    var security_option:String = ""
    var company_logo:String = ""
    var share_amount:String = ""
    var takeover_timing:String = ""
    var inspection_timing:String = ""
    var takeover_blockout_days:String = ""
    var inspection_blockout_days:String = ""
    var takeover_notes:String = ""
    var inspection_notes:String = ""
    var visitor_limit:Int = 0
    var visitors_allowed:Int = 0
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        company_name <- map.property("company_name")
        company_email <- map.property("company_email")
        company_contact <- map.property("company_contact")
        security_option <- map.property("security_option")
        company_logo <- map.property("company_logo")
        takeover_timing <- map.property("takeover_timing")
        inspection_timing <- map.property("inspection_timing")
        takeover_blockout_days <- map.property("takeover_blockout_days")
        inspection_blockout_days <- map.property("inspection_blockout_days")
        takeover_notes <- map.property("takeover_notes")
        inspection_notes <- map.property("inspection_notes")
        visitor_limit <- map.property("visitor_limit")
        visitors_allowed <- map.property("visitors_allowed")
        
    }
}


//MARK: ************** SETTINGS ROLE  ********
struct RoleSummaryBase: SafeMappable {
    var roles:[RoleInfo]!
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        
        roles <- map.relations("data")
        
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
struct RoleInfo: SafeMappable {
    var id:Int = 0
    var name:String = ""
    var status:Int = 0
    var type:Int = 0
    var account_id:Int = 0
    
    var permissions: [RolePermissions]!
   
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        account_id <- map.property("account_id")
        name <- map.property("name")
        status <- map.property("status")
        type <- map.property("type")
        permissions <- map.relations("permissions")
        
        
    }
}
struct RoleDetailsBase: SafeMappable {
    var role:RoleInfo!
    
    var message:String = ""
    var response:Int!
    var modules: [Module]!
    var access = [String: Any]()
    init(_ map: [String : Any]) throws {
        
        role <- map.relation("role")
        
        message <- map.property("message")
        response <- map.property("response")
        modules <- map.relations("modules")
        access <- map.property("access")
        
    }
}

struct RolePermissions: SafeMappable {
    var id:Int = 0
    var role_id:Int = 0
    var view:Int = 0
    var create:Int = 0
    var edit:Int = 0
    var delete:Int = 0
    var status:Int = 0
    var module_id:String = ""
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        role_id <- map.property("role_id")
        view <- map.property("view")
        create <- map.property("create")
        edit <- map.property("edit")
        delete <- map.property("delete")
        status <- map.property("status")
        module_id <- map.property("module_id")
        
    }
}
struct Module: SafeMappable {
    var id:Int = 0
    var type:Int = 0
    var group_id:Int = 0
    var orderby:Int = 0
    var status:Int = 0
    var menu_position = 0
   
    var name:String = ""
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        type <- map.property("type")
        group_id <- map.property("group_id")
        orderby <- map.property("orderby")
        status <- map.property("status")
        menu_position <- map.property("menu_position")
        name <- map.property("name")
        
    }
}
struct CreateRoleBase: SafeMappable {
    var data:Role!
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        data <- map.relation("data")
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
//MARK: ************** SETTINGS UNIT  ********
struct UnitSummaryBase: SafeMappable {
    var data:[UnitInfo]!
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        
        data <- map.relations("data")
        
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
struct UnitInfo: SafeMappable {
    var id:Int = 0
    var unit:String = ""
    var size:String = ""
    var share_amount:String = ""
    
    
    var status:Int = 0
    var account_id:Int = 0
    
   
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        account_id <- map.property("account_id")
        unit <- map.property("unit")
        size <- map.property("size")
        share_amount <- map.property("share_amount")
        status <- map.property("status")
        
        
    }
}
struct CreateUnitBase: SafeMappable {
    var data:UnitInfo!
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        data <- map.relation("data")
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
//MARK: ************** SETTINGS FEEDBACK OPTION  ********
struct FeedbackOptionSummaryBase: SafeMappable {
    var data:[FeedbackOption]!
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        
        data <- map.relations("data")
        
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
struct CreateFeedbackOptionBase: SafeMappable {
    var data:FeedbackOption!
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        data <- map.relation("data")
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
//MARK: ************** SETTINGS DEFECT LOCATION  ********
struct DefectLocationSummaryBase: SafeMappable {
    var data:[DefectLocation]!
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        
        data <- map.relations("data")
        
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
struct DefectLocation: SafeMappable {
    var id:Int = 0
    var account_id = 0
    var status:Int = 0
    var defect_location:String = ""
    var  types : [DefectType]!
  
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        account_id <- map.property("account_id")
        status <- map.property("status")
        defect_location <- map.property("defect_location")
        types <- map.relations("types")
       
        
  }
}
struct DefectType: SafeMappable {
    var id:Int = 0
    var location_id = 0
    var account_id = 0
    var status:Int = 0
    var defect_type:String = ""
  
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        location_id <- map.property("location_id")
        
        account_id <- map.property("account_id")
        status <- map.property("status")
        defect_type <- map.property("defect_type")
     
       
        
  }
}
struct DefectsLocationDetailsBase: SafeMappable {
    
    var message:String = ""
    var response:Int!
    var location: DefectLocation!
    var types = [String: Any]()
    init(_ map: [String : Any]) throws {
        
        location <- map.relation("locations")
        message <- map.property("message")
        response <- map.property("response")
        types <- map.property("types")
        
    }
}
//MARK: ************** SETTINGS FACILITY TYPE  ********
struct FacilityTypeSummaryBase: SafeMappable {
    var data:[FacilityType]!
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        
        data <- map.relations("data")
        
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
struct FacilityType: SafeMappable {
    var id:Int = 0
    var account_id = 0
    var status:Int = 0
    var facility_type:String = ""
    var  timing = ""
    var  notes = ""
    var next_booking_allowed:Int = 0
    var allowed_booking_for:Int = 0
    var next_booking_allowed_days:Int = 0
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        account_id <- map.property("account_id")
        status <- map.property("status")
        facility_type <- map.property("facility_type")
        timing <- map.property("timing")
        notes <- map.property("notes")
        next_booking_allowed <- map.property("next_booking_allowed")
        allowed_booking_for <- map.property("allowed_booking_for")
        next_booking_allowed_days <- map.property("next_booking_allowed_days")
       
        
  }
}
//MARK: ************** SETTINGS VISITING PURPOSE  ********
struct VisitingPurposeSummaryBase: SafeMappable {
    var data:[VisitingPurpose]!
    var propertyInfo: PropertyInfo!
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        
        data <- map.relations("data")
        propertyInfo <- map.relation("propertyInfo")
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
struct VisitingPurpose: SafeMappable {
    var id:Int = 0
    var account_id:Int = 0
    var visiting_purpose:String = ""
    var limit_set:Int = 0
    var compinfo_required:Int = 0
    var cat_dropdown:Int = 0
    var sub_category:String = ""
    var status:Int = 0
    var id_required:Int = 0
    
    var subcategory:[SubCategory]!
   
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        account_id <- map.property("account_id")
        visiting_purpose <- map.property("visiting_purpose")
        limit_set <- map.property("limit_set")
        compinfo_required <- map.property("compinfo_required")
        cat_dropdown <- map.property("cat_dropdown")
        sub_category <- map.property("sub_category")
        status <- map.property("status")
        id_required <- map.property("id_required")
        subcategory <- map.relations("subcategory")
        
    }
}
struct VisitingPurposeInfoBase: SafeMappable {
    var purpose:VisitingPurpose!
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        
        purpose <- map.relation("purpose")
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
struct SubCategory: SafeMappable {
    var id:Int = 0
    var account_id = 0
    var status:Int = 0
    var sub_category:String = ""
    
    var type_id:Int = 0
    
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        account_id <- map.property("account_id")
        status <- map.property("status")
        type_id <- map.property("type_id")
        sub_category <- map.property("sub_category")
       
  }
}
//MARK: ************** EFORM SUBMISSIONS  ********
struct MoveInOutSummaryBase: SafeMappable {
    var data:[MoveInOut]!
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        
        data <- map.relations("data")
        
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
struct MoveInOut: SafeMappable {
    var submission:MoveInOutSubmission!
    var sub_con:[MoveInOutContractor]!
    var submitted_by:MoveInOutSubmittedBy!
    var inspection:MoveInOutInspection!
    var defects:[MoveInOutDefects]!
    var payment:MoveInOutPayment!
    var unit: Unit!
   
  
    
    init(_ map: [String : Any]) throws {
        submission <- map.relation("submission")
        sub_con <- map.relations("sub_con")
        submitted_by <- map.relation("submitted_by")
        unit <- map.relation("unit")
        payment <- map.relation("payment")
        inspection <- map.relation("inspection")
        defects  <- map.relations("defects")
       
        
  }
}
struct MoveInOutSubmission: SafeMappable {
    var id:Int = 0
    var form_type:Int = 0
    
    var unit_no = 0
    var account_id = 0
    var user_id:Int = 0
    var status = 0
    var view_status = 0
    var ticket:String = ""
    var moving_date:String = ""
    var resident_name:String = ""
    var remarks:String = ""
    var contact_no:String = ""
    var email:String = ""
    var mover_comp:String = ""
    var in_charge_name:String = ""
    var comp_address:String = ""
    var comp_contact_no:String = ""
    var moving_start:String = ""
    var moving_end:String = ""
    var sub_con:[MoveInOutContractor]!
  
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        form_type <- map.property("form_type")
        unit_no <- map.property("unit_no")
        account_id <- map.property("account_id")
        user_id <- map.property("user_id")
        status <- map.property("status")
        view_status <- map.property("view_status")
        ticket <- map.property("ticket")
        moving_date <- map.property("moving_date")
        resident_name <- map.property("resident_name")
        contact_no <- map.property("contact_no")
        email <- map.property("email")
        remarks <- map.property("remarks")
        mover_comp <- map.property("mover_comp")
        in_charge_name <- map.property("in_charge_name")
        comp_address <- map.property("comp_address")
        comp_contact_no <- map.property("comp_contact_no")
        moving_start <- map.property("moving_start")
        moving_end <- map.property("moving_end")
        sub_con <- map.relations("sub_con")
        
     
       
        
  }
}
struct MoveInOutContractor: SafeMappable {
    var id:Int = 0
    var mov_id = 0
    var status:Int = 0
    var workman:String = ""
    var nric:String = ""
    var permit_expiry:String = ""
  
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        mov_id <- map.property("mov_id")
        status <- map.property("status")
        workman <- map.property("workman")
        nric <- map.property("nric")
        permit_expiry <- map.property("permit_expiry")
     
       
        
  }
}
struct MoveInOutSubmittedBy: SafeMappable {
    var id:Int = 0
    var role_id = 0
    var account_id = 0
    var unit_no:Int = 0
    var name:String = ""
    var email:String = ""
  
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        role_id <- map.property("role_id")
        account_id <- map.property("account_id")
        unit_no <- map.property("unit_no")
        name <- map.property("name")
        email <- map.property("email")
     
       
        
  }
}
struct MoveInOutPayment: SafeMappable {
    var id:Int = 0
    var mov_id:Int = 0
    var reg_id:Int = 0
    var status = 0
   
    var manager_id:Int = 0
   
    var bt_received_date:String = ""
    var bt_amount_received:String = ""
    var cash_amount_received:String = ""
    var cash_received_date:String = ""
    var date_of_signature:String = ""
    
    
    var payment_option:Int = 0
    var cheque_amount:String = ""
    var cheque_no:String = ""
    var cheque_bank:String = ""
   
    var receipt_no:String = ""
    var acknowledged_by:String = ""
    var manager_received:String = ""
    var signature:String = ""
    var remarks:String = ""
  
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        reg_id <- map.property("reg_id")
        mov_id <- map.property("mov_id")
        status <- map.property("status")
        manager_id <- map.property("manager_id")
        payment_option <- map.property("payment_option")
        cheque_amount <- map.property("cheque_amount")
        cheque_no <- map.property("cheque_no")
        cheque_bank <- map.property("cheque_bank")
       
        receipt_no <- map.property("receipt_no")
        acknowledged_by <- map.property("acknowledged_by")
        manager_received <- map.property("manager_received")
        signature <- map.property("signature")
        remarks <- map.property("remarks")
        
        bt_received_date <- map.property("bt_received_date")
        bt_amount_received <- map.property("bt_amount_received")
        cash_amount_received <- map.property("cash_amount_received")
        cash_received_date <- map.property("cash_received_date")
        date_of_signature <- map.property("date_of_signature")
       
       
       
        
  }
}

struct MoveInOutDefects: SafeMappable {
    var id:Int = 0
    var mov_id:Int = 0
    
    var account_id = 0
   
    var notes:String = ""
    var image_base64:String = ""
    var view_status = 0
 
  
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        mov_id <- map.property("mov_id")
        account_id <- map.property("account_id")
        notes <- map.property("notes")
        image_base64 <- map.property("image_base64")
        view_status <- map.property("view_status")
       
        
  }
}
struct MoveInOutInspection: SafeMappable {
    var id:Int = 0
    var mov_id:Int = 0
    var reno_id:Int = 0
    var status = 0
    var manager_id:Int = 0
    
    var manager_received:String = ""
    var manager_signature:String = ""
    var date_of_signature:String = ""
    var date_of_completion:String = ""
    var inspected_by:String = ""
    var unit_in_order_or_not:Int = 0
    var amount_received_by:String = ""
    var amount_deducted:String = ""
    var refunded_amount:String = ""
    var resident_nric:String = ""
    var resident_signature:String = ""
    var resident_signature_date:String = ""
    var acknowledged_by:String = ""
    var amount_claimable:String = ""
    var actual_amount_received:String = ""
  
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        mov_id <- map.property("mov_id")
        reno_id <- map.property("reno_id")
        manager_id <- map.property("manager_id")
        status <- map.property("status")
        manager_received <- map.property("manager_received")
        manager_signature <- map.property("manager_signature")
        date_of_signature <- map.property("date_of_signature")
        date_of_completion <- map.property("date_of_completion")
        inspected_by <- map.property("inspected_by")
        unit_in_order_or_not <- map.property("unit_in_order_or_not")
        amount_received_by <- map.property("amount_received_by")
        amount_deducted <- map.property("amount_deducted")
        refunded_amount <- map.property("refunded_amount")
        resident_nric <- map.property("resident_nric")
        resident_signature <- map.property("resident_signature")
        resident_signature_date <- map.property("resident_signature_date")
        acknowledged_by <- map.property("acknowledged_by")
        amount_claimable <- map.property("amount_claimable")
        actual_amount_received <- map.property("actual_amount_received")
       
       
        
  }
}
//RENOVATION
struct RenovationSummaryBase: SafeMappable {
    var data:[Renovation]!
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        
        data <- map.relations("data")
        
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
struct Renovation: SafeMappable {
    var submission:RenovationSubmission!
    var sub_con:[RenovationContractor]!
    var details:[RenovationDetails]!
    var submitted_by:RenovationSubmittedBy!
    var payment:RenovationPayment!
    var inspection:MoveInOutInspection!
    var defects:[MoveInOutDefects]!
    var unit: Unit!
   
  
    
    init(_ map: [String : Any]) throws {
        submission <- map.relation("submission")
        sub_con <- map.relations("sub_con")
        details <- map.relations("details")
        submitted_by <- map.relation("submitted_by")
        payment <- map.relation("payment")
        inspection <- map.relation("inspection")
        unit <- map.relation("unit")
      
        defects <- map.relations("defects")
        
  }
}
struct RenovationPayment: SafeMappable {
    var id:Int = 0
    var reno_id:Int = 0
    var manager_id:Int = 0
    var status = 0
   
    var payment_option:Int = 0
    var cheque_amount:String = ""
    var cheque_bank:String = ""
    var cheque_no:String = ""
    var bt_received_date:String = ""
    var bt_amount_received:String = ""
    var cash_amount_received:String = ""
    var cash_received_date:String = ""
    var receipt_no:String = ""
    var acknowledged_by:String = ""
    var manager_received:String = ""
    var signature:String = ""
    var date_of_signature:String = ""
    var remarks:String = ""
  
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        reno_id <- map.property("reno_id")
        manager_id <- map.property("manager_id")
        status <- map.property("status")
        payment_option <- map.property("payment_option")
        cheque_amount <- map.property("cheque_amount")
        cheque_bank <- map.property("cheque_bank")
        cheque_no <- map.property("cheque_no")
        bt_received_date <- map.property("bt_received_date")
        bt_amount_received <- map.property("bt_amount_received")
        cash_amount_received <- map.property("cash_amount_received")
        cash_received_date <- map.property("cash_received_date")
        receipt_no <- map.property("receipt_no")
        acknowledged_by <- map.property("acknowledged_by")
        manager_received <- map.property("manager_received")
        signature <- map.property("signature")
        date_of_signature <- map.property("date_of_signature")
       
        remarks <- map.property("remarks")
       
       
        
  }
}
struct RenovationDetails: SafeMappable {
    var id:Int = 0
    var reno_id = 0
    var detail = ""
    var status:Int = 0
   
  
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        reno_id <- map.property("reno_id")
        detail <- map.property("detail")
        status <- map.property("status")
      
       
        
  }
}
struct RenovationSubmission: SafeMappable {
    var id:Int = 0
    var form_type:Int = 0
    var unit_no = 0
    var account_id = 0
    var user_id:Int = 0
    var status = 0
    var view_status = 0
    var ticket:String = ""
    var reno_date:String = ""
    var resident_name:String = ""
    var contact_no:String = ""
    var email:String = ""
    var reno_comp:String = ""
    var in_charge_name:String = ""
    var comp_address:String = ""
    var comp_contact_no:String = ""
    var reno_start:String = ""
    var reno_end:String = ""
    var hacking_work_start:String = ""
    var hacking_work_end:String = ""
    var owner_name:String = ""
    var owner_signature:String = ""
    var nominee_name:String = ""
    var nominee_signature:String = ""
    var date_of_sign:String = ""
    var nominee_contact_no:String = ""
    var remarks:String = ""
    var sub_con:[MoveInOutContractor]!
  
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        form_type <- map.property("form_type")
        unit_no <- map.property("unit_no")
        account_id <- map.property("account_id")
        user_id <- map.property("user_id")
        status <- map.property("status")
        view_status <- map.property("view_status")
        ticket <- map.property("ticket")
        reno_date <- map.property("reno_date")
        resident_name <- map.property("resident_name")
        contact_no <- map.property("contact_no")
        email <- map.property("email")
        reno_comp <- map.property("reno_comp")
        in_charge_name <- map.property("in_charge_name")
        comp_address <- map.property("comp_address")
        comp_contact_no <- map.property("comp_contact_no")
        reno_start <- map.property("reno_start")
        reno_end <- map.property("reno_end")
        hacking_work_start <- map.property("hacking_work_start")
        hacking_work_end <- map.property("hacking_work_end")
        owner_name <- map.property("owner_name")
        owner_signature <- map.property("owner_signature")
        
        nominee_name <- map.property("nominee_name")
        nominee_signature <- map.property("nominee_signature")
        date_of_sign <- map.property("date_of_sign")
        nominee_contact_no <- map.property("nominee_contact_no")
        remarks <- map.property("remarks")
        sub_con <- map.relations("sub_con")
        
     
       
        
  }
}
struct RenovationContractor: SafeMappable {
    var id:Int = 0
    var reno_id = 0
    var status:Int = 0
    var workman:String = ""
    var nric:String = ""
    var permit_expiry:String = ""
  
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        reno_id <- map.property("reno_id")
        status <- map.property("status")
        workman <- map.property("workman")
        nric <- map.property("nric")
        permit_expiry <- map.property("permit_expiry")
     
       
        
  }
}
struct RenovationSubmittedBy: SafeMappable {
    var id:Int = 0
    var role_id = 0
    var account_id = 0
    var unit_no:Int = 0
    var name:String = ""
    var email:String = ""
  
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        role_id <- map.property("role_id")
        account_id <- map.property("account_id")
        unit_no <- map.property("unit_no")
        name <- map.property("name")
        email <- map.property("email")
  }
}

//Door Access

struct DoorAccessSummaryBase: SafeMappable {
    var data:[DoorAccess]!
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        
        data <- map.relations("data")
        
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
struct DoorAccess: SafeMappable {
    var submission:DoorAccessSubmission!
    var submitted_by:DoorAccessSubmittedBy!
    var unit: Unit!
    var payment:MoveInOutPayment!
    var acknowledgement : DoorAccessAcknowledgement!
    
    init(_ map: [String : Any]) throws {
        submission <- map.relation("submission")
        submitted_by <- map.relation("submitted_by")
        unit <- map.relation("unit")
        payment  <- map.relation("payment")
        acknowledgement  <- map.relation("acknowledgement")
        
  }
}
struct DoorAccessSubmission: SafeMappable {
    var id:Int = 0
    var form_type:Int = 0
    
    var unit_no = 0
    var account_id = 0
    var user_id:Int = 0
    var status = 0
    var view_status = 0
    var ticket:String = ""
    var request_date:String = ""
    var owner_name:String = ""
    var contact_no:String = ""
    var email:String = ""
    var declared_by:String = ""
    var mover_comp:String = ""
    var in_charge_name:String = ""
    var passport_no:String = ""
    var nominee_contact_no:String = ""
    var nominee_email:String = ""
    var no_of_card_required = 0
    var no_of_schlage_required = 0
    var comp_address:String = ""
    var comp_contact_no:String = ""
    var tenancy_start:String = ""
    var tenancy_end:String = ""
    var owner_signature:String = ""
    var date_of_sign:String = ""
    var remarks:String = ""
    
  
  
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        form_type <- map.property("form_type")
        unit_no <- map.property("unit_no")
        account_id <- map.property("account_id")
        user_id <- map.property("user_id")
        status <- map.property("status")
        view_status <- map.property("view_status")
        ticket <- map.property("ticket")
        request_date <- map.property("request_date")
        owner_name <- map.property("owner_name")
        contact_no <- map.property("contact_no")
        email <- map.property("email")
        declared_by <- map.property("declared_by")
        mover_comp <- map.property("mover_comp")
        in_charge_name <- map.property("in_charge_name")
        passport_no <- map.property("passport_no")
        nominee_contact_no <- map.property("nominee_contact_no")
        nominee_email <- map.property("nominee_email")
        no_of_card_required <- map.property("no_of_card_required")
        no_of_schlage_required <- map.property("no_of_schlage_required")
        comp_address <- map.property("comp_address")
        comp_contact_no <- map.property("comp_contact_no")
        tenancy_start <- map.property("tenancy_start")
        tenancy_end <- map.property("tenancy_end")
        owner_signature <- map.property("owner_signature")
        date_of_sign <- map.property("date_of_sign")
        remarks <- map.property("remarks")

        
     
       
        
  }
}

struct DoorAccessAcknowledgement: SafeMappable {
    var id:Int = 0
    var reg_id = 0
    var manager_id = 0
    var number_of_access_card:String = ""
    var serial_number_of_card:String = ""
    var acknowledged_by:String = ""
    var manager_issued:String = ""
    var signature:String = ""
    var date_of_signature:String = ""
  
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        reg_id <- map.property("reg_id")
        manager_id <- map.property("manager_id")
        number_of_access_card <- map.property("number_of_access_card")
        serial_number_of_card <- map.property("serial_number_of_card")
        acknowledged_by <- map.property("acknowledged_by")
        manager_issued <- map.property("manager_issued")
        signature <- map.property("signature")
        date_of_signature <- map.property("date_of_signature")
  }
}
struct DoorAccessSubmittedBy: SafeMappable {
    var id:Int = 0
    var role_id = 0
    var account_id = 0
    var unit_no:Int = 0
    var name:String = ""
    var email:String = ""
  
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        role_id <- map.property("role_id")
        account_id <- map.property("account_id")
        unit_no <- map.property("unit_no")
        name <- map.property("name")
        email <- map.property("email")
  }
}


//Vehicle Register

struct VehicleRegSummaryBase: SafeMappable {
    var data:[VehicleReg]!
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        
        data <- map.relations("data")
        
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
struct VehicleReg: SafeMappable {
    var submission:VehicleRegSubmission!
    var submitted_by:DoorAccessSubmittedBy!
    var documents : [VehicleRegDocuments]!
    var unit: Unit!
   
  
    
    init(_ map: [String : Any]) throws {
        submission <- map.relation("submission")
        documents <- map.relations("documents")
        submitted_by <- map.relation("submitted_by")
        unit <- map.relation("unit")
      
       
        
  }
}
struct VehicleRegSubmission: SafeMappable {
    var id:Int = 0
    var unit_no = 0
    var account_id = 0
    var user_id:Int = 0
    var status = 0
    var view_status = 0
    var ticket:String = ""
    var request_date:String = ""
    var owner_name:String = ""
    var contact_no:String = ""
    var email:String = ""
    var declared_by:String = ""
    var owner_of_vehicle:String = ""
    var licence_no:String = ""
    var iu_number:String = ""
    var in_charge_name:String = ""
    var passport_no:String = ""
    var nominee_contact_no:String = ""
    var nominee_email:String = ""
    var owner_of_nominee_vehicle = ""
    var nominee_vehicle_licence_no = ""
    var nominee_vehicle_iu_number = ""
    
    var nominee_signature:String = ""
    var comp_contact_no:String = ""
    var tenancy_start:String = ""
    var tenancy_end:String = ""
    var owner_signature:String = ""
    var date_of_sign:String = ""
    var remarks:String = ""
    
    var documents : [VehicleRegDocuments]!
  
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        unit_no <- map.property("unit_no")
        account_id <- map.property("account_id")
        user_id <- map.property("user_id")
        status <- map.property("status")
        view_status <- map.property("view_status")
        ticket <- map.property("ticket")
        request_date <- map.property("request_date")
        owner_name <- map.property("owner_name")
        contact_no <- map.property("contact_no")
        email <- map.property("email")
        declared_by <- map.property("declared_by")
        owner_of_vehicle <- map.property("owner_of_vehicle")
        licence_no <- map.property("licence_no")
        iu_number <- map.property("iu_number")
        in_charge_name <- map.property("in_charge_name")
        passport_no <- map.property("passport_no")
        nominee_contact_no <- map.property("nominee_contact_no")
        nominee_email <- map.property("nominee_email")
        owner_of_nominee_vehicle <- map.property("owner_of_nominee_vehicle")
        nominee_vehicle_licence_no <- map.property("nominee_vehicle_licence_no")
        nominee_vehicle_iu_number <- map.property("nominee_vehicle_iu_number")
        nominee_signature <- map.property("nominee_signature")
        comp_contact_no <- map.property("comp_contact_no")
        tenancy_start <- map.property("tenancy_start")
        tenancy_end <- map.property("tenancy_end")
        owner_signature <- map.property("owner_signature")
        date_of_sign <- map.property("date_of_sign")
        remarks <- map.property("remarks")
        documents <- map.relations("documents")

        
     
       
        
  }
}

struct VehicleRegDocuments: SafeMappable {
    var id:Int = 0
    var reg_id = 0
    var cat = 0
    var status:Int = 0
    var file:String = ""
    var file_original:String = ""
    var remarks:String = ""
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        reg_id <- map.property("reg_id")
        cat <- map.property("cat")
        status <- map.property("status")
        file <- map.property("file")
        file_original <- map.property("file_original")
        remarks <- map.property("remarks")
  }
}

struct UpdateAddressSummaryBase: SafeMappable {
    var data:[UpdateAddress]!
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        
        data <- map.relations("data")
        
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
struct UpdateAddress: SafeMappable {
    var submission:UpdateAddressSubmission!
   
    var unit: Unit!
   
  
    
    init(_ map: [String : Any]) throws {
        submission <- map.relation("submission")
        
        unit <- map.relation("unit")
      
       
        
  }
}
struct UpdateAddressSubmission: SafeMappable {
    var id:Int = 0
    var unit_no = 0
    var account_id = 0
    var user_id:Int = 0
    var status = 0
    var view_status = 0
    var ticket:String = ""
    var request_date:String = ""
    var owner_name:String = ""
    var contact_no:String = ""
    var email:String = ""
    var address:String = ""
    var declared_by:String = ""
    var owner_signature:String = ""
    var in_charge_name:String = ""
    var nominee_signature:String = ""
    var date_of_sign:String = ""
    
    var user: CardInfo!
    
    var remarks:String = ""
    
 
  
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        unit_no <- map.property("unit_no")
        account_id <- map.property("account_id")
        user_id <- map.property("user_id")
        status <- map.property("status")
        view_status <- map.property("view_status")
        ticket <- map.property("ticket")
        request_date <- map.property("request_date")
        owner_name <- map.property("owner_name")
        contact_no <- map.property("contact_no")
        email <- map.property("email")
        address <- map.property("address")
        declared_by <- map.property("declared_by")
        owner_signature <- map.property("owner_signature")
        in_charge_name <- map.property("in_charge_name")
        nominee_signature <- map.property("nominee_signature")
        date_of_sign <- map.property("date_of_sign")
        
       
        user <- map.relation("user")
        
        remarks <- map.property("remarks")

        
     
       
        
  }
}

//UpdateParticulars

struct UpdateParticularsSummaryBase: SafeMappable {
    var data:[UpdateParticulars]!
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        
        data <- map.relations("data")
        
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
struct UpdateParticulars: SafeMappable {
    var submission:UpdateParticularsSubmission!
    var owners: [UpdateParticularsOwner]!
    var tenants: [UpdateParticularsTenant]!
    var unit: Unit!
  
    
    init(_ map: [String : Any]) throws {
        submission <- map.relation("submission")
        owners <- map.relations("owners")
        tenants <- map.relations("tenants")
        
        unit <- map.relation("unit")
      
       
        
  }
}
struct UpdateParticularsSubmission: SafeMappable {
    var id:Int = 0
    var unit_no = 0
    var account_id = 0
    var user_id:Int = 0
    var status = 0
    var view_status = 0
    var ticket:String = ""
    var request_date:String = ""
    var owner_name:String = ""
    var contact_no:String = ""
    var email:String = ""
    var address:String = ""
    var declared_by:String = ""
    var owner_signature:String = ""
    var in_charge_name:String = ""
    var nominee_signature:String = ""
    var date_of_sign:String = ""
    var tenancy_start:String = ""
    var tenancy_end:String = ""
    
    var owners: [UpdateParticularsOwner]!
    var tenants: [UpdateParticularsTenant]!
    var remarks:String = ""
    var user: CardInfo!
 
  
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        unit_no <- map.property("unit_no")
        account_id <- map.property("account_id")
        user_id <- map.property("user_id")
        status <- map.property("status")
        view_status <- map.property("view_status")
        ticket <- map.property("ticket")
        request_date <- map.property("request_date")
        owner_name <- map.property("owner_name")
        contact_no <- map.property("contact_no")
        email <- map.property("email")
        address <- map.property("address")
        declared_by <- map.property("declared_by")
        owner_signature <- map.property("owner_signature")
        in_charge_name <- map.property("in_charge_name")
        nominee_signature <- map.property("nominee_signature")
        date_of_sign <- map.property("date_of_sign")
        tenancy_start <- map.property("tenancy_start")
        tenancy_end <- map.property("tenancy_end")
       
        owners <- map.relations("owners")
        tenants <- map.relations("tenants")
        remarks <- map.property("remarks")

        user <- map.relation("user")
     
       
        
  }
}
struct UpdateParticularsOwner: SafeMappable {
    var id:Int = 0
    var reg_id = 0
    var status:Int = 0
    var owner_name:String = ""
    var owner_nric:String = ""
    var owner_contact_no:String = ""
    var owner_vehicle_no:String = ""
    var owner_photo:String = ""
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        reg_id <- map.property("reg_id")
        status <- map.property("status")
        owner_name <- map.property("owner_name")
        owner_nric <- map.property("owner_nric")
        owner_contact_no <- map.property("owner_contact_no")
        owner_vehicle_no <- map.property("owner_vehicle_no")
        owner_photo <- map.property("owner_photo")
  }
}
struct UpdateParticularsTenant: SafeMappable {
    var id:Int = 0
    var reg_id = 0
    var status:Int = 0
    var tenant_name:String = ""
    var tenant_nric:String = ""
    var tenant_contact_no:String = ""
    var tenant_vehicle_no:String = ""
    var tenant_photo:String = ""
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        reg_id <- map.property("reg_id")
        status <- map.property("status")
        tenant_name <- map.property("tenant_name")
        tenant_nric <- map.property("tenant_nric")
        tenant_contact_no <- map.property("tenant_contact_no")
        tenant_vehicle_no <- map.property("tenant_vehicle_no")
        tenant_photo <- map.property("tenant_photo")
  }
}


struct MoveIOInspectionBase: SafeMappable {
    var data:MoveInOutSubmission!
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        
        data <- map.relation("data")
        
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
struct RenovationInspectionBase: SafeMappable {
    var data:RenovationSubmission!
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        
        data <- map.relation("data")
        
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
//MARK: ************** RESIDENT FILE SUMMARY ********
struct ResidentFileSummaryBase: SafeMappable {
    var data:[ResidentFileModal]!
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        data <- map.relations("data")
        message <- map.property("message")
        response <- map.property("response")
        
    }
}

struct ResidentFileModal: SafeMappable {
    var submission:ResidentFileSubmissionInfo!
    var cat:ResidentFileCategory?
   
    var user: CardInfo!
    var files: [ResidentFile]!
    
    init(_ map: [String : Any]) throws {
        submission <- map.relation("submission")
        cat <- map.relation("cat")
        user <- map.relation("user")
        files <- map.relations("files")
  }
}
struct ResidentFileSubmissionInfo: SafeMappable {
    var id:Int = 0
    var account_id: Int = 0
    var cat_id:Int = 0
    var user_id:Int = 0
    var notes: String = ""
    var remarks: String = ""
    var created_at:String = ""
    var updated_at:String = ""
    
    var status:Int = 0
    var  category: ResidentFileCategory!
    
    
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        account_id <- map.property("account_id")
        cat_id <- map.property("cat_id")
        user_id <- map.property("user_id")
        notes <- map.property("notes")
        remarks <- map.property("remarks")
        created_at <- map.property("created_at")
        status <- map.property("status")
        category <- map.relation("category")
       
        updated_at  <- map.property("updated_at")
  }
}
struct ResidentFile: SafeMappable {
    var id:Int = 0
    var account_id: Int = 0
    var ref_id:Int = 0
    var status:Int = 0
    
   
    var docs_file_name: String = ""
    var original_file_name: String = ""
    var docs_file: String = ""
    var created_at: String = ""
   
    
    
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        account_id <- map.property("account_id")
        ref_id <- map.property("ref_id")
        status <- map.property("status")
        
        docs_file_name <- map.property("docs_file_name")
        original_file_name <- map.property("original_file_name")
        docs_file <- map.property("docs_file")
        created_at <- map.property("created_at")
        
      
       
        
  }
}
struct ResidentFileCategory: SafeMappable {
    var id:Int = 0
    var account_id: Int = 0
    var status:Int = 0
    
   
    var docs_category: String = ""
   
   
    
    
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        account_id <- map.property("account_id")
        status <- map.property("status")
        
        docs_category <- map.property("docs_category")
      
       
        
  }
}
struct eFormSettingsInfoBase: SafeMappable {
    var details:eFormSettingsInfo!
    var response:Int = 0
    var message:String = ""
   
    
    init(_ map: [String : Any]) throws {
        details <- map.relation("details")

        response <- map.property("response")
        message <- map.property("message")
       
    }
}
struct eFormSettingsInfo: SafeMappable {
    var id:Int = 0
    var account_id:Int = 0
    var eform_type:Int = 0
    var general_info:String = ""
    var refund_amount:String = ""
    var payable_to:String = ""
    var payment_mode_cheque:Int = 0
    var payment_mode_bank:Int = 0
    var payment_mode_cash:Int = 0
    var official_notes:String = ""
    
    var hacking_work_permitted_days:Int = 0
    var hacking_work_not_permitted_saturday:Int = 0
    var hacking_work_not_permitted_sunday:Int = 0
    var hacking_work_not_permitted_holiday:Int = 0
    var hacking_work_start_time:String = ""
    var hacking_work_end_time:String = ""
    var status:Int = 0
    
    init(_ map: [String : Any]) throws {

        id <- map.property("id")
        account_id <- map.property("account_id")
        eform_type <- map.property("eform_type")
        general_info <- map.property(general_info)
        refund_amount <- map.property("refund_amount")
        payable_to <- map.property("payable_to")
        payment_mode_cheque <- map.property("payment_mode_cheque")
        payment_mode_bank <- map.property("payment_mode_bank")
        payment_mode_cash <- map.property("payment_mode_cash")
        official_notes <- map.property("official_notes")
        hacking_work_permitted_days <- map.property("hacking_work_permitted_days")
        hacking_work_not_permitted_saturday <- map.property("hacking_work_not_permitted_saturday")
        hacking_work_not_permitted_sunday <- map.property("hacking_work_not_permitted_sunday")
        hacking_work_not_permitted_holiday <- map.property("hacking_work_not_permitted_holiday")
        hacking_work_start_time <- map.property("hacking_work_start_time")
        hacking_work_end_time <- map.property("hacking_work_end_time")
        status <- map.property("status")
       
       
    }
}
//MARK: ************** CARDS ********
struct CardsSummaryModal: SafeMappable {
    var cards:[Card] = []
    var units:[Unit] = []
    var response: Int = 0
    var message:String = ""
    
    
    
    init(_ map: [String : Any]) throws {
        cards <- map.relations("cards")
        units <- map.relations("units")
        response <- map.property("response")
        message <- map.property("message")
       
        
  }
}

struct Card: SafeMappable {
    var id:Int = 0
    var account_id = 0
    var unit_no:Int = 0
    
    var card:String = ""
    var remarks:String = ""
    var status:Int = 0
    var created_at:String = ""
    var updated_at:String = ""
        
   
  
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        account_id <- map.property("account_id")
        status <- map.property("status")
        unit_no <- map.property("unit_no")
        card <- map.property("card")
        remarks <- map.property("remarks")
        created_at <- map.property("created_at")
        updated_at  <- map.property("updated_at")
       
        
  }
}


//MARK: ************** DEVICE ********
struct DeviceSummaryModal: SafeMappable {
    var lists:[Device] = []
    var response: Int = 0
    var message:String = ""
    
    
    
    init(_ map: [String : Any]) throws {
        lists <- map.relations("lists")
        response <- map.property("response")
        message <- map.property("message")
       
        
  }
}

struct Device: SafeMappable {
    var id:Int = 0
    var device_name = ""
    
    var device_serial_no:String = ""
    var location:String = ""
    var status:String = ""
    var model:String = ""
        
   
  
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        device_name <- map.property("device_name")
        device_serial_no <- map.property("device_serial_no")
        location <- map.property("location")
        model <- map.property("model")
        status <- map.property("status")
        
       
        
  }
}
struct DeviceLocationBase: SafeMappable {
    var locations:[DeviceLocation]!
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        locations <- map.relations("locations")
        message <- map.property("message")
        response <- map.property("response")
        
    }
}

struct DeviceLocation: SafeMappable {
    var id = 0
    var account_id = 0
    var building = ""
    var building_no = ""
    var status = 0
    
   
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        account_id <- map.property("account_id")
        building <- map.property("building")
        building_no <- map.property("building_no")
        status <- map.property("status")
       
       
        
  }
}

//MARK: ************** CARDS ********
struct CondoCategoryBase: SafeMappable {
    var data: [CondoCategory]!
    var message:String = ""
    var response:Int = 0
    
    init(_ map: [String : Any]) throws {
        data <- map.relations("data")
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
struct CondoCategory: SafeMappable {
    var id = 0
    var account_id = 0
    var docs_category = ""
    var status = 0
    var created_at:String = ""
    var updated_at:String = ""
    
    var files = [CondoFiles]()
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        account_id <- map.property("account_id")
        docs_category <- map.property("docs_category")
        status <- map.property("status")
        created_at <- map.property("created_at")
        updated_at <- map.property("updated_at")
       
        files <- map.relations("files")
  }
}
struct CondoDetailsBase: SafeMappable {
    var docs: CondoCategory!
    var img_full_path = ""
    var message:String = ""
    var response:Int = 0
    init(_ map: [String : Any]) throws {
        docs <- map.relation("docs")
        message <- map.property("message")
        response <- map.property("response")
        img_full_path  <- map.property("img_full_path")
    }
}
struct CondoFiles: SafeMappable {
    var id = 0
    var account_id = 0
    var cat_id = 0
    var docs_file_name = ""
    var original_file_name = ""
    var docs_file = ""
    
    var status = 0
    var created_at:String = ""
    var updated_at:String = ""
    
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        account_id <- map.property("account_id")
        cat_id <- map.property("cat_id")
        docs_file_name <- map.property("docs_file_name")
        original_file_name <- map.property("original_file_name")
        docs_file <- map.property("docs_file")
        created_at <- map.property("created_at")
        updated_at <- map.property("updated_at")
        
  }
}
struct CreateCondoBase: SafeMappable {
    var data:CondoCategory!
    var message: String = ""
    var response: Int = 0
    
    init(_ map: [String : Any]) throws {
        data <- map.property("data")
        message <- map.property("message")
        response <- map.property("response")
        
    }
}


struct PaymentInfoSummaryBase: SafeMappable {
    var data:PaymentInfo!
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        
        data <- map.relation("data")
        
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
struct PaymentInfo: SafeMappable {
    var id:Int!
    var account_id:Int!
   
    var cheque_payable_to:String = ""
    var cash_payment_info:String = ""
    var account_holder_name:String = ""
    var account_number:String = ""
    var account_type:String = ""
    var bank_name:String = ""
    var bank_address:String = ""
    var swift_code:String = ""
    
    init(_ map: [String : Any]) throws {
        
        
        id <- map.property("id")
        account_id <- map.property("account_id")
        cheque_payable_to <- map.property("cheque_payable_to")
        cash_payment_info <- map.property("cash_payment_info")
        account_holder_name <- map.property("account_holder_name")
        account_number <- map.property("account_number")
        account_type <- map.property("account_type")
        bank_name <- map.property("bank_name")
        bank_address <- map.property("bank_address")
        swift_code <- map.property("swift_code")
        
        
    }
}
struct HolidayInfoSummaryBase: SafeMappable {
    var data:HolidayInfo!
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        
        data <- map.relation("data")
        
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
struct HolidayInfo: SafeMappable {
    var public_holidays:String = ""
    var id = 0
    var account_id = 0
    init(_ map: [String : Any]) throws {
        
        
        public_holidays <- map.property("public_holidays")
        id <- map.property("id")
        account_id <- map.property("account_id")
        
    }
}
//MARK:  *************** STAFF  DIGITAL ACCESS  *************
struct FaceIdSummaryBase: SafeMappable {
    var data:[FaceId]!
    var message:String = ""
    var response:Int!
    var file_path = ""
    
    init(_ map: [String : Any]) throws {
        
        data <- map.relations("data")
        file_path <- map.property("file_path")
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
struct FaceId: SafeMappable {
    var id = 0
    var submitted_date:String = ""
    var unit = ""
    var name = ""
    var approved_date = ""
    var face_picture = ""
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        submitted_date <- map.property("submitted_date")
        unit <- map.property("unit")
        name <- map.property("name")
        approved_date <- map.property("approved_date")
        face_picture <- map.property("face_picture")
        
        
    }
}
struct StaffRoleBase: SafeMappable {
    var data:[StaffRole]!
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        
        data <- map.relations("data")
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
struct StaffRole: SafeMappable {
    var id = 0
    var account_id = 0
    var name:String = ""
    var status = 0
    var type = 0
   
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        account_id <- map.property("account_id")
        name <- map.property("name")
        status <- map.property("status")
        type <- map.property("type")
       
        
        
    }
}
    struct BuildingSummaryBase: SafeMappable {
        var data:[Building]!
        var message:String = ""
        var response:Int!
        
        init(_ map: [String : Any]) throws {
            
            data <- map.relations("data")
            message <- map.property("message")
            response <- map.property("response")
            
        }
    }
    struct Building: SafeMappable {
        var id = 0
        var account_id = 0
        var building = ""
        var building_no = ""
        var status = 0
        
        init(_ map: [String : Any]) throws {
            id <- map.property("id")
            account_id <- map.property("account_id")
            building <- map.property("building")
            building_no <- map.property("building_no")
            status <- map.property("status")
            
        }
    }

struct BuildingUnitBase: SafeMappable {
    var data:[BuildingUnit]!
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        
        data <- map.relations("data")
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
struct BuildingUnit: SafeMappable {
    var id = 0
    var account_id = 0
    var building_id = 0
    var unit = ""
    var code = ""
    var device_id = 0
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        account_id <- map.property("account_id")
        building_id  <- map.property("building_id")
        unit <- map.property("unit")
        code <- map.property("code")
        device_id <- map.property("device_id")
        
    }
}
struct FaceOptionSummaryBase: SafeMappable {
    var data:[FaceOption]!
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        
        data <- map.relations("data")
        message <- map.property("message")
        response <- map.property("response")
    }
}
struct FaceOption: SafeMappable {
    var id = 0
    var account_id = 0
    var option = ""
    var status = 0
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        account_id <- map.property("account_id")
        option <- map.property("option")
        status <- map.property("status")
        
    }
}
struct UserByRoleSummaryBase: SafeMappable {
    var data:[UserByRole]!
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        
        data <- map.relations("data")
        message <- map.property("message")
        response <- map.property("response")
    }
}
struct UserByRole: SafeMappable {
    var id = 0
    var role = 0
    var name = ""
    var unit_no = 0
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        role <- map.property("role")
        name <- map.property("name")
        unit_no <- map.property("unit_no")
        
    }
}

struct DeviceListModalBase: SafeMappable {
    var devices:[DeviceListModal]  = []
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        devices <- map.relations("devices")
        message <- map.property("msg")
        response <- map.property("response")
        
    }
}
struct DeviceListModal: SafeMappable {
    var thinmoo: DeviceData!
    var moreinfo: DeviceMoreInfo!
    
    init(_ map: [String : Any]) throws {
        thinmoo <- map.relation("thinmoo")
        moreinfo <- map.relation("moreinfo")
       

    }
}
struct DeviceMoreInfo: SafeMappable {
    
   
    
   var  proximity_setting = 0
    
    
    var devSn:String = ""
    var devName:String = ""
    var locations:String = ""
    var status = 0
    
    
    init(_ map: [String : Any]) throws {
        proximity_setting <- map.property("proximity_setting")
       
       
        devSn <- map.property("device_serial_no")
        devName <- map.property("device_name")
        locations <- map.property("locations")
        status <- map.property("status")

    }
}

struct DeviceData: SafeMappable {
    var deviceId:Int = 0
    var devSn = ""
    var devName = ""
    var deviceModelValue = 0
    var appEkey = ""
    var miniEkey = ""
    var devMac = ""
    var communityId = 0
    init(_ map: [String : Any]) throws {
        deviceId <- map.property("deviceId")
        devSn <- map.property("devSn")
        devName <- map.property("devName")
        deviceModelValue <- map.property("deviceModelValue")
        appEkey <- map.property("appEkey")
        miniEkey <- map.property("miniEkey")
        devMac <- map.property("devMac")
        
        communityId <- map.property("communityId")
    }
}
struct ThinmooTokenBase: SafeMappable {
    var message:String = ""
    var response:Bool!
    var token = ""
    
    init(_ map: [String : Any]) throws {
        message <- map.property("message")
        response <- map.property("response")
        token <- map.property("token")
        
    }
}
