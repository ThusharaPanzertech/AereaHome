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
    }
}
//MARK: ************** ROLES details ********
struct RolesBase: SafeMappable {
    var roles = [String: String]()
    var message:String = ""
    var response:Bool!
    
    init(_ map: [String : Any]) throws {
        roles <- map.property("roles")
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
//MARK: ************** UNIT details ********
struct UnitBase: SafeMappable {
    var units = [String: String]()
    var message:String = ""
    var response:Bool!
    
    init(_ map: [String : Any]) throws {
        units <- map.property("units")
        message <- map.property("message")
        response <- map.property("response")
        
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
    var module_id:String = ""
    var view:String = ""
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        user_id <- map.property("user_id")
        module_id <- map.property("module_id")
        view <- map.property("view")
        
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
   
    var name:String = ""
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        type <- map.property("type")
        group_id <- map.property("group_id")
        orderby <- map.property("orderby")
        status <- map.property("status")
       
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
    
    var status = 0
   
    var payment_options:String = ""
    var refund_amount:String = ""
    var payable_to:String = ""
    var cheque_no:String = ""
    var cheque_bank:String = ""
    var account_holder_name:String = ""
    var account_number:String = ""
    var account_type:String = ""
    var bank_name:String = ""
    var bank_address:String = ""
    var swift_code:String = ""
    var receipt_no:String = ""
    var acknowledged_by:String = ""
    var manager_received:String = ""
    var signature:String = ""
    var remarks:String = ""
  
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        mov_id <- map.property("mov_id")
        status <- map.property("status")
        payment_options <- map.property("payment_options")
        refund_amount <- map.property("refund_amount")
        payable_to <- map.property("payable_to")
        cheque_no <- map.property("cheque_no")
        cheque_bank <- map.property("cheque_bank")
        account_holder_name <- map.property("account_holder_name")
        account_number <- map.property("account_number")
        account_type <- map.property("account_type")
        bank_name <- map.property("bank_name")
        bank_address <- map.property("bank_address")
        swift_code <- map.property("swift_code")
        receipt_no <- map.property("receipt_no")
        acknowledged_by <- map.property("acknowledged_by")
        manager_received <- map.property("manager_received")
        signature <- map.property("signature")
        remarks <- map.property("remarks")
       
       
        
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
    
    var status = 0
   
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
    var unit: Unit!
   
  
    
    init(_ map: [String : Any]) throws {
        submission <- map.relation("submission")
        sub_con <- map.relations("sub_con")
        details <- map.relations("details")
        submitted_by <- map.relation("submitted_by")
        unit <- map.relation("unit")
      
       
        
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
   
  
    
    init(_ map: [String : Any]) throws {
        submission <- map.relation("submission")
        submitted_by <- map.relation("submitted_by")
        unit <- map.relation("unit")
      
       
        
  }
}
struct DoorAccessSubmission: SafeMappable {
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
