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

//MARK: ************** USER ACCESS ********

struct UserAccessUpdateBase: SafeMappable {
    
    var message:String = ""
   
    var response:Int!
    
    init(_ map: [String : Any]) throws {
       
        message <- map.property("message")
      
        
        response <- map.property("response")
        
    }
}

struct UserAccessSummaryBase: SafeMappable {
    var users:[UserAccessDataModal]!
    var message:String = ""
    var roles = [String: String]()
    var buildings = [String: String]()
   
    var modules: [Module]!
    var response:Bool!
    
    init(_ map: [String : Any]) throws {
        users <- map.relations("users")
        message <- map.property("message")
       
        roles <- map.property("roles")
        buildings <- map.property("buildings")
        modules <- map.relations("modules")
        response <- map.property("response")
        
    }
}
struct UserAccessDataModal: SafeMappable {
    
  
    var id = 0
    var first_name = ""
    var last_name = ""
    var role = ""
    var  user_id = 0
    var  user_info_id = 0
    var building_id = ""
    var  unit_id = 0
    var unit = ""
    var building = ""
//    var user_access = [String: [String: [Int]]]()
    var user_access =  [String: [Int]]()
    init(_ map: [String : Any]) throws {
       
        first_name <- map.property("first_name")
       
        id <- map.property("id")
        building <- map.property("building")
        last_name <- map.property("last_name")
      
        role <- map.property("role")
        unit <- map.property("unit")
       
        user_id <- map.property("user_id")
       
        user_info_id <- map.property("user_info_id")
      
        building_id <- map.property("building_id")
        unit_id <- map.property("unit_id")
        
        user_access <- map.property("access")
  }
}
//MARK: ************** USER SUMMARY ********
struct UserSummaryBase: SafeMappable {
    var users:[UserModal]!
    var message:String = ""
    var roles = [String: String]()
    var user_roles = [String]()
    var response:Bool!
    
    
    init(_ map: [String : Any]) throws {
        users <- map.relations("users")
        message <- map.property("message")
        roles <- map.property("roles")
        user_roles <- map.property("user_roles")
        response <- map.property("response")
        
    }
}
struct UserDataModal: SafeMappable {
    
  
    var id = 0
    var name:String!
   
    var role:String!
    var unit: String!
    
    init(_ map: [String : Any]) throws {
       
        unit <- map.property("unit")
       
        id <- map.property("id")
       
        name <- map.property("name")
      
        role <- map.property("role")
  }
}

struct UserModal: SafeMappable {
    
    var userinfo : UserInfo_UserSummary!
    var status:Int!
    var id:Int!
    var name = ""
    var last_name = ""
    var email:String!
    var account_enabled:Int!
    var role_id:Int!
    var created_at:String!
    var end_date:String!
    var role:String!
    var unit = ""
    var building = ""
    var user_units: [UnitAssigned]!
    var dateObj = Date()
    
    init(_ map: [String : Any]) throws {
        userinfo <- map.relation("userinfo")
        unit <- map.property("unit")
        status <- map.property("status")
        last_name <- map.property("last_name")
        id <- map.property("id")
        account_enabled <- map.property("account_enabled")
        role_id <- map.property("role_id")
        created_at <- map.property("created_at")
        name <- map.property("name")
        email <- map.property("email")
        end_date <- map.property("end_date")
        role <- map.property("role")
        building <- map.property("building")
        user_units <- map.relations("user_units")
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd/MM/yyyy"
            let date1 = formatter.date(from: created_at)
        dateObj = date1 ?? Date()
  }
}

struct UserInfo_UserSummary: SafeMappable {
   
    var profile_picture:String = ""
    var face_picture:String = ""
    var last_name:String = ""
    var phone:String = ""
    var country:Int = 0
    var card:String = ""
    
    var mailing_address:String = ""
    
    
    
    init(_ map: [String : Any]) throws {
      
        profile_picture <- map.property("profile_picture")
        face_picture <- map.property("face_picture")
        last_name <- map.property("last_name")
        phone <- map.property("phone")
        card <- map.property("card")
        country <- map.property("country")
        mailing_address <- map.property("mailing_address")
        
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
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        roles <- map.property("roles")
        data <- map.relations("data")
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
struct UserRolesBase: SafeMappable {
    var roles = [Role]()
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        roles <- map.relations("roles")
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
//MARK: ************** Activate / Deactivate ********
struct MessageBase: SafeMappable {
    
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
struct CountryBase: SafeMappable {
    
    var roles = [String: String]()
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        message <- map.property("message")
        response <- map.property("response")
        roles <- map.property("roles")
        
    }
   
  
}
//MARK: ************** UNIT Card details ********
struct UnitCardBase: SafeMappable {
    
    var cards = [String: String]()
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        message <- map.property("message")
        response <- map.property("response")
        cards <- map.property("cards")
        
    }
   
  
}
//MARK: **************ASSIGNED UNIT details ********
struct AssignedUnitBase: SafeMappable {
    var user_units:[UnitAssigned] = []
    var roles = [String: String]()
    var buildings = [String: String]()
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        user_units <- map.relations("user_units")
        message <- map.property("message")
        response <- map.property("response")
        roles <- map.property("roles")
        buildings <- map.property("buildings")
        
    }
   
  
}

struct UnitAssigned: SafeMappable {
   
    var id:Int!
    var building_id = 0
    var unit_id = 0
    var building:String = ""
    var unit:String = ""
    var role:String = ""
    var primary_contact:String = ""
    var created_date:String = ""
    
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        building_id <- map.property("building_id")
        unit_id <- map.property("unit_id")
        building <- map.property("building")
        unit <- map.property("unit")
        role <- map.property("role")
        primary_contact <- map.property("primary_contact")
        created_date <- map.property("created_date")
        
    }
   
  
}
//MARK: ************** UNIT details ********
struct UnitBase: SafeMappable {
    var units:[Unit] = []
    var message:String = ""
    var response:Bool!
    
    init(_ map: [String : Any]) throws {
        units <- map.relations("units")
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
struct SearchUnitBase: SafeMappable {
    var units:[Unit] = []
    //= [String: String]()
    var message:String = ""
    var response:Bool!
    
    init(_ map: [String : Any]) throws {
        units <- map.relations("data")
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
    var role = ""
    var role_id  = 0
    var moreInfo:MoreInfo?
    var unit:Unit?
    var property:[Property] = []
    var available_properties:[AvailableProperty] = []
    var agent_assigned_property: [Int] = []
    var permissions:[Permissions] = []
    static var currentUser:Users? = nil
    var file_path: String!
    init(_ map: [String : Any]) throws {
        user <- map.relation("user")
        role <- map.property("role")
        role_id <- map.property("role_id")
        moreInfo <- map.relation("moreinfo")
        unit <- map.relation("unit")
        property <- map.relations("property")
        agent_assigned_property <- map.property("agent_assigned_property")
        available_properties <- map.relations("available_properties")
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
    var first_name:String!
    var last_name:String!
    var email:String!
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        account_id <- map.property("account_id")
        role_id <- map.property("role_id")
        unit_no <- map.property("unit_no")
        name <- map.property("name")
        first_name <- map.property("first_name")
        last_name <- map.property("last_name")
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
    var first_name:String!
    var phone:String!
    var postal_code:String!
    var unit_no:Int!
    var mailing_address:String!
    var company_name: String!
    var face_picture:String!
    var card_no = ""
    var country = 0
    var getuser: DoorRecordUser!
    init(_ map: [String : Any]) throws {
        user_id <- map.property("user_id")
        profile_picture <- map.property("profile_picture")
        last_name <- map.property("last_name")
        first_name <- map.property("first_name")
        phone <- map.property("phone")
        unit_no <- map.property("unit_no")
        mailing_address <- map.property("mailing_address")
        company_name <- map.property("company_name")
        face_picture <- map.property("face_picture")
        postal_code <- map.property("postal_code")
        card_no <- map.property("card_no")
        country <- map.property("country")
        getuser <- map.relation("getuser")
    }
}
struct Unit: SafeMappable {
    var id:Int = 0
    var account_id:Int = 0
    var unit:String = ""
    var size:String = ""
    var share_amount:String = ""
    var building_id:Int = 0
    var code:String = ""
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        building_id <- map.property("building_id")
        account_id <- map.property("account_id")
        unit <- map.property("unit")
        size <- map.property("size")
        share_amount <- map.property("share_amount")
        unit <- map.property("unit")
        code <- map.property("code")
    }
}
struct UnitListTypeBase: SafeMappable {
    var type = [String: String]()
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        
        type <- map.property("type")
        message <- map.property("message")
        response <- map.property("response")
        
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
struct AvailableProperty: SafeMappable {
    var id:Int = 0
    var prop_name:String = ""
    
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        prop_name <- map.property("prop_name")
       
        
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

struct KeyCollectionInfoBase: SafeMappable {
    var data:KeyCollectionModal!
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        data <- map.relation("booking_info")
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
    var options = [FeedbackOption]()
    var message:String = ""
    var response:Bool!
    
    init(_ map: [String : Any]) throws {
        options <- map.relations("options")
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
    var unit_no:Int = 0
    
    
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
        unit_no <- map.property("unit_no")
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
struct FacilityInfoBase: SafeMappable {
    var data: FacilityModal!
    var message:String = ""
    var response:Int = 0
    
    init(_ map: [String : Any]) throws {
        data <- map.relation("booking")
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
struct FacilityModal: SafeMappable {
    var submissions:FacilitySubmission!
    var type:FacilityOption?
    var option:FacilityOption?
    var user_info:User?
   
    
    
    
    init(_ map: [String : Any]) throws {
        submissions <- map.relation("submissions")
        type <- map.relation("type")
        option <- map.relation("option")
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
    var data:[UnitInfoDet]!
    var message:String = ""
    var response:Int!
    init(_ map: [String : Any]) throws {
        
        data <- map.relations("data")
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
struct UnitInfoDet: SafeMappable {
    var unit: UnitInfo!
    var building : Building!
   
    init(_ map: [String : Any]) throws {
        unit <- map.relation("unit")
        building <- map.relation("building")
        
        
    }
}
struct UnitInfo: SafeMappable {
    var id:Int = 0
    var unit:String = ""
    var size:String = ""
    var share_amount:String = ""
    
    
    var status:Int = 0
    var account_id:Int = 0
    var buildinginfo : Building!
   
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        account_id <- map.property("account_id")
        unit <- map.property("unit")
        size <- map.property("size")
        share_amount <- map.property("share_amount")
        status <- map.property("status")
        buildinginfo <- map.relation("buildinginfo")
        
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
struct MoveInOutInfoBase: SafeMappable {
    var details:MoveInOut!
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        
        details <- map.relation("details")
        
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
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
    var submitted_by:MoveInOutSubmittedBy?
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
    var id_type = 0
    var id_number = ""
    var status:Int = 0
    var workman:String = ""
    var nric:String = ""
    var permit_expiry:String = ""
  
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        id_type <- map.property("id_type")
        id_number <- map.property("id_number")
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
    
    var cheque_received_date:String = ""
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
        cheque_received_date <- map.property("cheque_received_date")
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
    var data:[RenovationSubmission]!
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        
        data <- map.relations("data")
        
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
struct RenovationInfoBase: SafeMappable {
    var details:Renovation!
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        
        details <- map.relation("details")
        
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
struct Renovation: SafeMappable {
    var submission:RenovationSubmission!
    var sub_con:[RenovationContractor]!
    var details:[RenovationDetails]!
    var submitted_by:RenovationSubmittedBy?
    var payment:RenovationPayment!
    var inspection:MoveInOutInspection!
    var defects:[MoveInOutDefects]!
    var unit: Unit!
   
  
    
    init(_ map: [String : Any]) throws {
        submission <- map.relation("submission")
        sub_con <- map.relations("sub_com")
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
    var cheque_received_date:String = ""
    
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
        cheque_received_date <- map.property("cheque_received_date")
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
    var unit: Unit!
    var submitted_by:RenovationSubmittedBy?
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
        
        unit <- map.relation("unit")
        submitted_by <- map.relation("submitted_by")
        
  }
}
struct RenovationContractor: SafeMappable {
    var id:Int = 0
    var id_type:Int = 0
    var id_number = ""
    var reno_id = 0
    var status:Int = 0
    var workman:String = ""
    var nric:String = ""
    var permit_expiry:String = ""
  
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        id_type <- map.property("id_type")
        id_number <- map.property("id_number")
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
    var data:[DoorAccessSubmission]!
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        
        data <- map.relations("data")
        
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
struct DoorAccessInfoBase: SafeMappable {
    var details:DoorAccess!
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        
        details <- map.relation("details")
        
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
struct DoorAccess: SafeMappable {
    var submission:DoorAccessSubmission!
    var submitted_by:DoorAccessSubmittedBy?
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
    var nominee_signature:String = ""
    
    var submitted_by:DoorAccessSubmittedBy?
    var unit: Unit!
  
    
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
        nominee_signature <- map.property("nominee_signature")
        
     
        submitted_by <- map.relation("submitted_by")
        unit <- map.relation("unit")
        
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
        signature <- map.property("owner_signature")
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
struct VehicleRegBase: SafeMappable {
    var data:VehicleReg!
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        
        data <- map.relation("details")
        
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
struct VehicleRegInfoBase: SafeMappable {
    var details:VehicleReg!
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        
        details <- map.relation("details")
        
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
struct VehicleReg: SafeMappable {
    var submission:VehicleRegSubmission!
    var submitted_by:DoorAccessSubmittedBy?
    var documents : [VehicleRegDocuments]?
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
struct UpdateAddressInfoSummaryBase: SafeMappable {
    var details:UpdateAddress!
    var message:String = ""
    var response:Int!
    var file_path = ""
    init(_ map: [String : Any]) throws {
        
        details <- map.relation("details")
        
        message <- map.property("message")
        response <- map.property("response")
        file_path <- map.property("file_path")
        
    }
}
struct UpdateAddress: SafeMappable {
    var submission:UpdateAddressSubmission!
     var submitted_by:UpdateAddressSubmittedBy?
    var unit: Unit!
   
  
    
    init(_ map: [String : Any]) throws {
        submission <- map.relation("submission")
        submitted_by <- map.relation("submitted_by")
        unit <- map.relation("unit")
      
       
        
  }
}
struct UpdateAddressSubmittedBy: SafeMappable {
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
    
    var user: CardInfo?
    
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
struct UpdateParticularsInfoBase: SafeMappable {
    var data:UpdateParticulars!
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        
        data <- map.relation("details")
        
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
    var user: CardInfo?
 
  
    
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
struct ResidentFileInfoBase: SafeMappable {
    var data:ResidentFileModal!
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        data <- map.relation("details")
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
struct ResidentFileModal: SafeMappable {
    var submission:ResidentFileSubmissionInfo!
    var data:ResidentFileSubmissionInfo!
    var cat:ResidentFileCategory?
    var unit: Unit!
    var user: CardInfo!
    var files: [ResidentFile]!
    
    init(_ map: [String : Any]) throws {
        submission <- map.relation("submission")
        data <- map.relation("data")
        unit <- map.relation("unit")
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
    var view_status = 0
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
        view_status <- map.property("view_status")
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
    var payment_info:PaymentInfo!
    var response:Int = 0
    var message:String = ""
   
    
    init(_ map: [String : Any]) throws {
        details <- map.relation("details")
        payment_info <- map.relation("payment_info")
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
    var dateObj = Date()
    var files = [CondoFiles]()
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        account_id <- map.property("account_id")
        docs_category <- map.property("docs_category")
        status <- map.property("status")
        created_at <- map.property("created_at")
        updated_at <- map.property("updated_at")
       
        files <- map.relations("files")
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date1 = formatter.date(from: created_at)
        dateObj = date1 ?? Date()
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
//MARK: ************** MANAGE BUILDING ********
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
//
struct ThinmooRecordBase: SafeMappable {
    var result:Int!
    var message:String = ""
    var code:Int!
    
    init(_ map: [String : Any]) throws {
        result <- map.property("result")
        message <- map.property("msg")
        code <- map.property("code")
        
    }
}
struct VisitorSummaryModalBase: SafeMappable {
    var data: [VisitorSummary]!
    var message:String = ""
    var response:Int = 0
    var purposes = [String: String]()
    
    init(_ map: [String : Any]) throws {
        data <- map.relations("data")
        message <- map.property("message")
        purposes <- map.property("purposes")
        response <- map.property("response")
        
    }
}
struct VisitorSummary: SafeMappable {
    var id:Int = 0
    var booking_type:Int = 0
    var visitor_count:Int = 0
   
    var ticket:String = ""
    var unit:String = ""
    var invited_by:String = ""
    var entry_date:String = ""
    var entry_time:String = ""
    var date_of_visit:String = ""
    var purpose:String = ""
    var status:String = ""
    var view_status:Int = 0
    
    
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        booking_type <- map.property("booking_type")
        visitor_count <- map.property("visitor_count")
        ticket <- map.property("ticket")
        unit <- map.property("unit")
        invited_by <- map.property("invited_by")
        entry_date <- map.property("entry_date")
        entry_time <- map.property("entry_time")
        date_of_visit <- map.property("date_of_visit")
        purpose <- map.property("purpose")
        status <- map.property("status")
        view_status <- map.property("view_status")
        
       
        
  }
}
struct VisitorInfoModalBase: SafeMappable {
    var details: VisitorDetailsBase!
    var message:String = ""
    var file_path:String = ""
    var response:Int = 0
    var purposes = [String: String]()
    
    init(_ map: [String : Any]) throws {
        details <- map.relation("details")
        message <- map.property("message")
        file_path <- map.property("file_path")
        purposes <- map.property("purposes")
        response <- map.property("response")
        
    }
}
struct VisitorAvaiabiltyBase: SafeMappable {
    
    var message:String = ""
    
    var slot_available:Int = 0
    var limit:Int = 0
    var id_required:Int = 0
    var response:Int = 0
    
    
    init(_ map: [String : Any]) throws {
        slot_available <- map.property("slot_available")
        message <- map.property("message")
        id_required <- map.property("id_required")
        limit <- map.property("limit")
        response <- map.property("response")
        
    }
}

struct VisitorFunctionBase: SafeMappable {
    var types = [VisitorFunctionInfoBase]()

   
    var message:String = ""
 
    var response:Int = 0
    
    init(_ map: [String : Any]) throws {
        types <- map.relations("types")
        message <- map.property("message")
        response <- map.property("response")
       
        
    }
}
struct VisitorFunctionInfoBase: SafeMappable {
    var type: VisitorFunctionInfo!

   
   
    
    init(_ map: [String : Any]) throws {
        type <- map.relation("type")
       
       
        
    }
}
struct VisitorFunctionInfo: SafeMappable {
    var id:Int = 0
    var account_id:Int = 0
    var visiting_purpose:String = ""
    var limit_set:Int = 0
    var compinfo_required:Int = 0
    var cat_dropdown:Int = 0
    var id_required:Int = 0
   
    var sub_category:String = ""
    var status:String = ""
    var created_at:String = ""
    var updated_at:String = ""
   
    var subcategory = [VisitorWalkinSubcategory]()
    
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
        created_at <- map.property("created_at")
       
        updated_at <- map.property("updated_at")
        subcategory <- map.relations("subcategory")
       
        
  }
}






struct VisitorDetailsBase: SafeMappable {
    var visitors = [VisitorInfo]()
    var id:Int = 0
    var account_id:Int = 0
    var booking_type:Int = 0
    var visitor_count:Int = 0
   
    var ticket:String = ""
    var unit:String = ""
    var invited_by:String = ""
    var entry_date:String = ""
    var comp_info:String = ""
    var visiting_date:String = ""
    var qrcode_file:String = ""
    
    var visiting_purpose:String = ""
    var sub_cat:Int = 0
    var status:Int = 0
    var view_status:Int = 0
    
    init(_ map: [String : Any]) throws {
        visitors <- map.relations("visitors")
        id <- map.property("id")
        account_id <- map.property("account_id")
        booking_type <- map.property("booking_type")
        visitor_count <- map.property("visitor_count")
        ticket <- map.property("ticket")
        unit <- map.property("unit_no")
        invited_by <- map.property("invited_by")
        entry_date <- map.property("entry_date")
        comp_info <- map.property("comp_info")
        visiting_date <- map.property("visiting_date")
        qrcode_file <- map.property("qrcode_file")
        visiting_purpose <- map.property("visiting_purpose")
        status <- map.property("status")
        sub_cat <- map.property("sub_cat")
        view_status <- map.property("view_status")
        
    }
}
struct VisitorInfo: SafeMappable {
    var id:Int = 0
    var book_id:Int = 0
    var visit_status:Int = 0
    var visit_count:Int = 0
   
    var name:String = ""
    var mobile:String = ""
    var vehicle_no:String = ""
    var id_number:String = ""
    var email:String = ""
    var qrcode_file:String = ""
    
    
    var entry_date:String = ""
    var entry_time:String = ""
       
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        book_id <- map.property("book_id")
        visit_status <- map.property("visit_status")
        visit_count <- map.property("visit_count")
        
        name <- map.property("name")
        mobile <- map.property("mobile")
        vehicle_no <- map.property("vehicle_no")
        id_number <- map.property("id_number")
        email <- map.property("email")
        qrcode_file <- map.property("qrcode_file")
       
        entry_date <- map.property("entry_date")
        entry_time <- map.property("entry_time")
       
        
  }
}
struct UpdateVisitorBase: SafeMappable {
    var data:VisitorSummary!
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        data <- map.relation("data")
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
struct WalkinVisitorBase: SafeMappable {
    var data:VisitorSummary!
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
        data <- map.relation("details")
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
struct VisitorWalkinSubcategory: SafeMappable {
   
    var sub_category:String = ""
    var id:Int = 0
    var account_id:Int = 0
    var type_id:Int = 0
    var status:Int = 0
    
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        account_id <- map.property("account_id")
        type_id <- map.property("type_id")
        sub_category <- map.property("sub_category")
        status <- map.property("status")
    
        
    }
}



struct DoorRecordsBase: SafeMappable {
    var data: [DoorRecord]!
    var message:String = ""
    var response:Int = 0
    var devices = [String: String]()
    var types = [String: String]()
    
    init(_ map: [String : Any]) throws {
        data <- map.relations("data")
        message <- map.property("message")
        devices <- map.property("devices")
        types <- map.property("types")
        response <- map.property("response")
        
    }
}
struct DoorRecord: SafeMappable {
   
    var id:String = ""
    var logId:String = ""
    var communityName:String = ""
    var communityUuid:String = ""
    var buildingName:String = ""
    var roomName:String = ""
    var doorName:String = ""
    var devSn:String = ""
    var devName:String = ""
    var deviceModelName:String = ""
    var number:String = ""
    var memo:String = ""
    var empUuid:String = ""
    var empPhone:String = ""
    var empName:String = ""
    var eventTypeName:String = ""
    var positionFullName:String = ""
    var eventTime:String = ""
    var extendDay:String = ""
    var createTime:String = ""
    var realCreateTime:String = ""
    
    
    
    
    
    var platformId:Int = 0
    var companyId:Int = 0
    var communityId:Int = 0
    var buildingId:Int = 0
    var devId:Int = 0
    var deviceModelValue:Int = 0
    var appUserId:Int = 0
    var empType:Int = 0
    var empId:Int = 0
    var eventType:Int = 0
    var relayIndex:Int = 0
    var inoutState:Int = 0
    var accInoutStatus:Int = 0
    var openStatus:Int = 0
    var terminalApplyType:Int = 0
    var terminalOsType:Int = 0
    var eventKinds:Int = 0
    var isHaveTestContent:Int = 0
    
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        logId <- map.property("logId")
        communityName <- map.property("communityName")
        communityUuid <- map.property("communityUuid")
        buildingName <- map.property("buildingName")
        roomName <- map.property("roomName")
        doorName <- map.property("doorName")
        devSn <- map.property("devSn")
        devName <- map.property("devName")
        deviceModelName <- map.property("deviceModelName")
        number <- map.property("number")
        memo <- map.property("memo")
        empUuid <- map.property("empUuid")
        empPhone <- map.property("empPhone")
        empName <- map.property("empName")
        eventTypeName <- map.property("eventTypeName")
        positionFullName <- map.property("positionFullName")
        eventTime <- map.property("eventTime")
        extendDay <- map.property("extendDay")
        createTime <- map.property("createTime")
        realCreateTime <- map.property("realCreateTime")
        
        
        
        
        platformId <- map.property("platformId")
        companyId <- map.property("companyId")
        communityId <- map.property("communityId")
        buildingId <- map.property("buildingId")
        
        devId <- map.property("devId")
        deviceModelValue <- map.property("deviceModelValue")
        appUserId <- map.property("appUserId")
        empType <- map.property("empType")
        empId <- map.property("empId")
        eventType <- map.property("eventType")
        relayIndex <- map.property("relayIndex")
        inoutState <- map.property("inoutState")
        accInoutStatus <- map.property("accInoutStatus")
        openStatus <- map.property("openStatus")
        terminalApplyType <- map.property("terminalApplyType")
        terminalOsType <- map.property("terminalOsType")
        eventKinds <- map.property("eventKinds")
        isHaveTestContent <- map.property("isHaveTestContent")
    
        
    }
}

struct BluetoothDoorRecordsBase: SafeMappable {
    var data: [BluetoothDoorRecordModal]!
    var message:String = ""
    var response:Int = 0
    var devices = [String: String]()
   
    
    init(_ map: [String : Any]) throws {
        data <- map.relations("data")
        message <- map.property("message")
        devices <- map.property("devices")
       
        response <- map.property("response")
        
    }
}
struct BluetoothDoorRecordModal: SafeMappable {
    
    var record:BluetoothDoorRecord!
    var unitinfo:String = ""
    var name:String = ""
    var action:String = ""
    var status:String = ""
    
    init(_ map: [String : Any]) throws {
        record <- map.relation("record")
        unitinfo <- map.property("unitinfo")
        name <- map.property("name")
        action <- map.property("action")
        status <- map.property("status")
      
    }
}
struct BluetoothDoorRecord: SafeMappable {
   
    var id:Int = 0
    var account_id:Int = 0
    var devMac:String = ""
    var call_date_time:String = ""
    var created_at:String = ""
    var updated_at:String = ""
    var eKey:String = ""
    var devSn:String = ""
    var devName:String = ""
   
    
    
    
    
    var user_id:Int = 0
    var devType:Int = 0
    var status:Int = 0
    var action_type:Int = 0
   
    var user: DoorRecordUser!
    
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        account_id <- map.property("account_id")
        user_id <- map.property("user_id")
        devMac <- map.property("devMac")
        devType <- map.property("devType")
        status <- map.property("status")
        action_type <- map.property("action_type")
        call_date_time <- map.property("call_date_time")
        created_at <- map.property("created_at")
        updated_at <- map.property("updated_at")
        eKey <- map.property("eKey")
        devSn <- map.property("devSn")
        devName <- map.property("devName")
      
        user <- map.relation("user")
    }
}
struct DoorRecordUser: SafeMappable {
    
    var id:Int = 0
    var account_id:Int = 0
    var role_id:Int = 0
    var building_no:Int = 0
    var unit_no:Int = 0
    
    var email:String = ""
    var name:String = ""
    var email_verified_at:String = ""
    var account_enabled:Int = 0
    var status:Int = 0
    var otp:Int = 0
    var deactivated_date:String = ""
   var primary_contact = 0
   
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        account_id <- map.property("account_id")
        role_id <- map.property("role_id")
        building_no <- map.property("building_no")
        unit_no <- map.property("unit_no")
        email_verified_at <- map.property("email_verified_at")
        account_enabled <- map.property("account_enabled")
        status <- map.property("status")
        otp <- map.property("otp")
        primary_contact <- map.property("primary_contact")
        deactivated_date <- map.property("deactivated_date")
       
        
        
        email <- map.property("email")
        name <- map.property("name")
       
      
    }
}

struct FailedDoorRecordsBase: SafeMappable {
    var data: [FailedDoorRecordModal]!
    var message:String = ""
    var response:Int = 0
    var devices = [String: String]()
   
    
    init(_ map: [String : Any]) throws {
        data <- map.relations("data")
        message <- map.property("message")
        devices <- map.property("devices")
       
        response <- map.property("response")
        
    }
}
struct FailedDoorRecordModal: SafeMappable {
    
    var record:FailedDoorRecord!
    var unitinfo:String = ""
    var name:String = ""
   
    init(_ map: [String : Any]) throws {
        record <- map.relation("record")
        unitinfo <- map.property("unitinfo")
        name <- map.property("name")
       
      
    }
}
struct FailedDoorRecord: SafeMappable {
   
    var id:Int = 0
    var account_id:Int = 0
    var user_id:Int = 0
    var empuuid:String = ""
    var empname:String = ""
    var empPhone:String = ""
    var empCardNo:String = ""
    var devId:Int = 0
    var devuuid:String = ""
    var devname:String = ""
    var devSn:String = ""
    var building_no:String = ""
    var buildingCode:String = ""
    var eventType:Int = 0
    var eventtime:String = ""
    var captureImageUrl:String = ""
    var faceAge:Int = 0
    
 
   
    
    
    
    
    var faceGender:Int = 0
    var faceMatchScore:Int = 0
    var bodyTemperature:Int = 0
    var created_at:String = ""
    var updated_at:String = ""
   
    
    
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        account_id <- map.property("account_id")
        user_id <- map.property("user_id")
        empuuid <- map.property("empuuid")
        empname <- map.property("empname")
        empPhone <- map.property("empPhone")
        empCardNo <- map.property("empCardNo")
        devId <- map.property("devId")
        created_at <- map.property("created_at")
        updated_at <- map.property("updated_at")
        devuuid <- map.property("devuuid")
        devname <- map.property("devname")
        devSn <- map.property("devSn")
        building_no <- map.property("building_no")
        buildingCode <- map.property("buildingCode")
        eventType <- map.property("eventType")
        eventtime <- map.property("eventtime")
        captureImageUrl <- map.property("captureImageUrl")
        faceAge <- map.property("faceAge")
        faceGender <- map.property("faceGender")
        faceMatchScore <- map.property("faceMatchScore")
        bodyTemperature <- map.property("bodyTemperature")
       
        
      
    }
}


struct CallUnitDoorRecordsBase: SafeMappable {
    var data: [CallUnitDoorRecordModal]!
    var message:String = ""
    var response:Int = 0
    var devices = [String: String]()
   
    
    init(_ map: [String : Any]) throws {
        data <- map.relations("data")
        message <- map.property("message")
        devices <- map.property("devices")
       
        response <- map.property("response")
        
    }
}
struct CallUnitDoorRecordModal: SafeMappable {
    
    var record:CallUnitDoorRecord!
    var unitinfo:String = ""
    var name:String = ""
   
    init(_ map: [String : Any]) throws {
        record <- map.relation("record")
        unitinfo <- map.property("unitinfo")
        name <- map.property("name")
       
      
    }
}
struct CallUnitDoorRecord: SafeMappable {
   
    var id:Int = 0
    var account_id:Int = 0
    var user_ids:String = ""
    var fcm_token:String = ""
    var devSn:String = ""
    var roomId:String = ""
    var roomuuid:String = ""
    var roomCode:Int = 0
    var building_no:Int = 0
    var buildingCode:Int = 0
    var eventType:Int = 0
    var eventtime:String = ""
    var captureImage:String = ""
    var created_at:String = ""
    var updated_at:String = ""
    
   
    var getunit: Unit!
   
    
    
    
  
   
    
    
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        account_id <- map.property("account_id")
        user_ids <- map.property("user_ids")
        fcm_token <- map.property("fcm_token")
        devSn <- map.property("devSn")
        roomId <- map.property("roomId")
        roomuuid <- map.property("roomuuid")
        roomCode <- map.property("roomCode")
        building_no <- map.property("building_no")
        buildingCode <- map.property("buildingCode")
        eventType <- map.property("eventType")
        eventtime <- map.property("eventtime")
        captureImage <- map.property("captureImage")
        
        created_at <- map.property("created_at")
        updated_at <- map.property("updated_at")
       
        getunit <- map.relation("getunit")
      
    }
}


struct QRCodeDoorRecordsBase: SafeMappable {
    var data: [QRCodeDoorRecordModal]!
    var message:String = ""
    var response:Int = 0
    var devices = [String: String]()
   
    
    init(_ map: [String : Any]) throws {
        data <- map.relations("data")
        message <- map.property("message")
        devices <- map.property("devices")
       
        response <- map.property("response")
        
    }
}
struct QRCodeDoorRecordModal: SafeMappable {
    
    var record:QRCodeDoorRecord!
    var booking_id:String = ""
    var name:String = ""
   
    init(_ map: [String : Any]) throws {
        record <- map.relation("record")
        booking_id <- map.property("booking_id")
        name <- map.property("name")
       
      
    }
}
struct QRCodeDoorRecord: SafeMappable {
   
    var id:Int = 0
    var account_id:Int = 0
    var booking_id:Int = 0
    var visitor_id:Int = 0
    
    var devSn:String = ""
    var dataType:Int = 0
    
    var message:String = ""
    var created_at:String = ""
    var updated_at:String = ""
    
  
    
   
    var booking_info: QRCodeDoorRecordBooingInfo!
   
    
    
    
  
   
    
    
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        account_id <- map.property("account_id")
        booking_id <- map.property("booking_id")
        visitor_id <- map.property("visitor_id")
        
        devSn <- map.property("devSn")
        dataType <- map.property("dataType")
        message <- map.property("message")
        created_at <- map.property("created_at")
        updated_at <- map.property("updated_at")
        
       
        
      
       
        booking_info <- map.relation("booking_info")
      
    }
}
struct QRCodeDoorRecordBooingInfo: SafeMappable {
   
    var id:Int = 0
    var account_id:Int = 0
    var booking_type:Int = 0
    var unit_no:Int = 0
    
    var ticket:String = ""
    var user_id:Int = 0
    var visiting_date:String = ""
    var visiting_purpose:Int = 0
    
    var qrcode_file:String = ""
    var entry_date:String = ""
    var comp_info:String = ""
    var sub_cat:String = ""
    var status:Int = 0
    var view_status:Int = 0
    var remarks:String = ""
    
    
    var created_at:String = ""
    var updated_at:String = ""
    
  
    
    var user: DoorRecordUser!
    
    
    
  
   
    
    
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        account_id <- map.property("account_id")
        booking_type <- map.property("booking_type")
        unit_no <- map.property("unit_no")
        
        ticket <- map.property("ticket")
        user_id <- map.property("user_id")
        visiting_date <- map.property("visiting_date")
        visiting_purpose <- map.property("visiting_purpose")
        qrcode_file <- map.property("qrcode_file")
        
        entry_date <- map.property("entry_date")
        comp_info <- map.property("comp_info")
        sub_cat <- map.property("sub_cat")
        status <- map.property("status")
        view_status <- map.property("view_status")
        remarks <- map.property("remarks")
      
        created_at <- map.property("created_at")
        updated_at <- map.property("updated_at")
        
        user <- map.relation("user")
      
       
      
      
    }
}
//MARK: ************** USER LIST TYPE ********
struct ContactInfoBase: SafeMappable {
    var data:[UserModal]!
    var message:String = ""
    var response:Bool!
    
    init(_ map: [String : Any]) throws {
        data <- map.relations("data")
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
struct CardInfoBase: SafeMappable {
    var data:[Card]!
    var message:String = ""
    var response:Bool!
    
    init(_ map: [String : Any]) throws {
        data <- map.relations("data")
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
struct ResidentMgmtBase: SafeMappable {
    var data: [ResidentMgmt]!
    var message:String = ""
    var response:Int = 0
    
    init(_ map: [String : Any]) throws {
        data <- map.relations("data")
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
struct ResidentMgmt: SafeMappable {

    
    var invoice_info:InvoiceInfo!
    var building:Building!
    var unit:Unit!
    var invoice_amount:Double = 0.0
    var status_lable:String = ""
        
   
  
    
    init(_ map: [String : Any]) throws {
        invoice_info <- map.relation("invoice_info")
        building <- map.relation("building")
        unit <- map.relation("unit")
        invoice_amount <- map.property("invoice_amount")
        status_lable <- map.property("status_lable")
       
       
        
  }
}
struct InvoiceInfo: SafeMappable {
    var id:Int = 0
    var account_id = 0
    var unit_no:Int = 0
    var info_id:Int = 0
    var unit_share = 0
    var active_status:Int = 0
    var reminder_status:Int = 0
    var balance_type = 0
    var status:Int = 0
    
    var invoice_date:String = ""
    var due_date:String = ""
    var batch_file_no:String = ""
    var invoice_no:String = ""
    var tax_percentage:String = ""
    var invoice_amount:String = ""
    var payable_amount:String = ""
    var balance_amount:Double = 0
    var notes:String = ""
    var remarks:String = ""
    var created_at:String = ""
    var updated_at:String = ""
        
    var advance_payment: AdvancePaymentInfo!
  
    
    init(_ map: [String : Any]) throws {
  
        id <- map.property("id")
        account_id <- map.property("account_id")
        unit_no <- map.property("unit_no")
        info_id <- map.property("info_id")
        unit_share <- map.property("unit_share")
        active_status <- map.property("active_status")
        reminder_status <- map.property("reminder_status")
        balance_type <- map.property("balance_type")
        unit_no <- map.property("unit_no")
        status <- map.property("status")
       
      
        invoice_date <- map.property("invoice_date")
        due_date  <- map.property("due_date")
        batch_file_no <- map.property("batch_file_no")
        invoice_no  <- map.property("invoice_no")
        tax_percentage <- map.property("tax_percentage")
        invoice_amount  <- map.property("invoice_amount")
        payable_amount <- map.property("payable_amount")
        balance_amount  <- map.property("balance_amount")
        notes <- map.property("notes")
        remarks  <- map.property("remarks")

        
        created_at <- map.property("created_at")
        updated_at  <- map.property("updated_at")
       
        
  }
}
struct AdvancePaymentInfo: SafeMappable {

    
    var id:Int = 0
    var account_id = 0
    var unit_no:Int = 0
    var invoice_id:Int = 0
    var payment_id = 0
        
   
    var amount:String = ""
    var payment_received_date:String = ""
    var created_at:String = ""
    var updated_at:String = ""
    
    init(_ map: [String : Any]) throws {
       
        id <- map.property("id")
        account_id <- map.property("account_id")
        unit_no <- map.property("unit_no")
        invoice_id <- map.property("invoice_id")
        payment_id <- map.property("payment_id")
        
        amount <- map.property("amount")
        payment_received_date <- map.property("payment_received_date")
        created_at <- map.property("created_at")
        updated_at <- map.property("updated_at")
       
       
        
  }
}
struct BatchSummaryBase: SafeMappable {
    var data: [BatchInfo]!
    var message:String = ""
    var file_path:String = ""
    var response:Int = 0
    var buildings = [String: String]()
    
    init(_ map: [String : Any]) throws {
        data <- map.relations("data")
        message <- map.property("message")
        response <- map.property("response")
        buildings <- map.property("buildings")
        file_path <- map.property("file_path")
        
    }
}
struct BatchInfo: SafeMappable {
    
    var batch_no:String = ""
    var created_by:String = ""
    var id:Int = 0
    var count = 0
    var created_date :String = ""
    
    init(_ map: [String : Any]) throws {
        created_by <- map.property("created_by")
        batch_no <- map.property("batch_no")
        id <- map.property("id")
        count <- map.property("count")
        created_date <- map.property("created_date")
        
    }
}
struct InvoiceSummaryBase: SafeMappable {
    var data: [InvoiceReportInfo]!
    var message:String = ""
    var file_path:String = ""
    var response:Int = 0
    var buildings = [String: String]()
    
    init(_ map: [String : Any]) throws {
        data <- map.relations("data")
        message <- map.property("message")
        response <- map.property("response")
        buildings <- map.property("buildings")
        file_path <- map.property("file_path")
        
    }
}
struct InvoiceReportInfo: SafeMappable {
    var invoice_info: InvoiceInfo!
    var status_lable:String = ""
    var invoice_amount:Double = 0.0
    var building : Building!
    var unit: Unit!
    
    init(_ map: [String : Any]) throws {
        invoice_info <- map.relation("invoice_info")
        status_lable <- map.property("status_lable")
        building <- map.relation("building")
        unit <- map.relation("unit")
        invoice_amount <- map.property("invoice_amount")
        
    }
}

struct InvoiceDataBase: SafeMappable {
    var data: InvoiceData!
    var message:String = ""
    var file_path:String = ""
    var response:Int = 0
  
    
    init(_ map: [String : Any]) throws {
        data <- map.relation("data")
        message <- map.property("message")
        response <- map.property("response")
       
        file_path <- map.property("file_path")
        
    }
}
struct InvoiceData: SafeMappable {
    var invoice_info: InvoiceInfo!
    var details:[InvoiceDetails]!
   var unit_info = ""
    var building_info = ""
    
    
    init(_ map: [String : Any]) throws {
        invoice_info <- map.relation("invoice")
        details <- map.relations("details")
        unit_info <- map.property("unit_info")
        building_info <- map.property("building_info")
        
    }
}

struct InvoiceDetails: SafeMappable {
    var id = 0
    var account_id = 0
    var unit_no = 0
    var invoice_id = 0
    var payment_id = 0
    var reference_type = 0
    var reference_no:String = ""
    var reference_invoice = 0
    var order = 0
    var display_order = 0
    var detail:String = ""
    var total_amount:String = ""
    var amount:String = ""
    var balance:String = ""
    var payment_received_date:String = ""
    var payment_status = 0
    var received_amount:String = ""
    var paid_by_credit = 0
    var status = 0
    
    var due_date:String = ""
    var created_at:String = ""
    var updated_at:String = ""
    
    
    init(_ map: [String : Any]) throws {
       
        id <- map.property("id")
        account_id <- map.property("account_id")
        unit_no <- map.property("unit_no")
        invoice_id <- map.property("invoice_id")
        payment_id <- map.property("payment_id")
        reference_type <- map.property("reference_type")
        reference_no <- map.property("reference_no")
        reference_invoice <- map.property("reference_invoice")
        order <- map.property("order")
        display_order <- map.property("display_order")
        detail <- map.property("detail")
        total_amount <- map.property("total_amount")
        amount <- map.property("amount")
        balance <- map.property("balance")
        payment_received_date <- map.property("payment_received_date")
        payment_status <- map.property("payment_status")
        received_amount <- map.property("received_amount")
        paid_by_credit <- map.property("paid_by_credit")
        status <- map.property("status")
        due_date <- map.property("due_date")
        created_at <- map.property("created_at")
        updated_at <- map.property("updated_at")
       
        
    }
}
//MARK: ************** ASSIGN DEVICE ********
    struct AssignDeviceBase: SafeMappable {
        var data:[AssignDevice]!
        var message:String = ""
        var type:String = ""
        var response:Int!
        
        init(_ map: [String : Any]) throws {
            
            data <- map.relations("data")
            message <- map.property("message")
            type <- map.property("type")
            response <- map.property("response")
            
        }
    }
    struct AssignDevice: SafeMappable {
        var id = 0
        var building_no = 0
        var unit_no = 0
        var building = ""
        var unit = ""
        var devices = [AssignDeviceData]()
       var receive_call = 0
        
        init(_ map: [String : Any]) throws {
            id <- map.property("id")
            receive_call <- map.property("receive_call")
            building_no <- map.property("building_no")
            building <- map.property("building")
            unit <- map.property("unit")
            unit_no <- map.property("unit_no")
            devices <- map.relations("devices")
        }
    }
struct AssignDeviceData: SafeMappable {
    var id = 0
    var user_bluethooth_checked_status = 0
    var user_remote_checked_status = 0
    var model = ""
    var location_id = ""
    var location = ""
    var device_name = ""
    var device_serial_no = ""
    
    
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        user_bluethooth_checked_status <- map.property("user_bluethooth_checked_status")
        user_remote_checked_status <- map.property("user_remote_checked_status")
        model <- map.property("model")
        location_id <- map.property("location_id")
        location <- map.property("location")
        device_name <- map.property("device_name")
        device_serial_no <- map.property("device_serial_no")
        
    }
}
struct LoginHistoryLog: SafeMappable {
    var message:String = ""
    var response:Bool!
    var data: LogDataModal!
    
    init(_ map: [String : Any]) throws {
        message <- map.property("message")
        response <- map.property("response")
        data <- map.relation("data")
        
    }
}
struct LogDataModal: SafeMappable {
    var user_id = ""
    var login_from = ""
    var device_info = ""
    
    init(_ map: [String : Any]) throws {
        user_id <- map.property("user_id")
        login_from <- map.property("login_from")
        device_info <- map.property("device_info")
        
    }
}
//MARK: ************** NOTIFICATION ********
struct NotificationBase: SafeMappable {
   
    var data:NotificationMessages!
    var message:String = ""
    var response:Int!
    
    init(_ map: [String : Any]) throws {
       
        data <- map.relation("data")
        message <- map.property("message")
        response <- map.property("response")
        
    }
}
struct NotificationMessages: SafeMappable {
   
    var messages:[NotificationDataModal] = []
    var types:[String : String] = [String : String]()
   
    
    init(_ map: [String : Any]) throws {
       
        messages <- map.relations("messages")
        types <- map.property("types")

        
    }
}
struct NotificationDataModal: SafeMappable {
 
    
    var booking_date:String = ""
    var booking_time:String = ""
   
    var created_at:String = ""
    var updated_at:String = ""
    var title:String = ""
    var message:String = ""
    var deleted:Int!
    var ref_id = 0
    var id:Int!
    var account_id = 0
    var user_id = 0
    var type = 0
    var status = 0
    var admin_view_status = 0
    var event_status = 0
    
    init(_ map: [String : Any]) throws {
       

        id <- map.property("id")
        account_id <- map.property("account_id")
        user_id <- map.property("user_id")
        type <- map.property("type")
        status <- map.property("status")
        admin_view_status <- map.property("admin_view_status")
        event_status <- map.property("event_status")
        deleted <- map.property("deleted")
        type <- map.property("type")
        ref_id <- map.property("ref_id")
        
        title <- map.property("title")
        message <- map.property("message")
       
        booking_date <- map.property("booking_date")
        booking_time <- map.property("booking_time")
        
        created_at <- map.property("created_at")
        updated_at <- map.property("updated_at")
    }
}
struct NotificationUpdateBase: SafeMappable {
  
    var data:NotificationUpdateModal!
    var msg:String = ""
    var code:Int!
    
    init(_ map: [String : Any]) throws {
       
        data <- map.relation("data")
        msg <- map.property("msg")
        code <- map.property("code")
        
    }
}
struct NotificationUpdateModal: SafeMappable {
 
  
   
    var title:String = ""
    var message:String = ""
    var status:Int!
    var ref_id:Int!
    var user_id:Int!
    var account_id:Int!
    var id:Int!
    
    init(_ map: [String : Any]) throws {
       

        id <- map.property("id")
        account_id <- map.property("account_id")
        user_id <- map.property("user_id")
        ref_id <- map.property("ref_id")
        status <- map.property("status")
       
        message <- map.property("message")
        title <- map.property("title")
       
        status <- map.property("status")
        
    }
}
