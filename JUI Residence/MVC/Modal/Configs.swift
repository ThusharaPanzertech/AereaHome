//
//  Configs.swift
//  JUI Residence
//
//  Created by Thushara Harish on 15/07/21.
//

import Foundation
import UIKit

let textColor = UIColor(red: 93/255, green: 93/255, blue: 93/255, alpha: 1.0)
let placeholderColor = UIColor(red: 162/255, green: 162/255, blue: 162/255, alpha: 1.0)
let kAppDelegate = UIApplication.shared.delegate as! AppDelegate
let kScreenSize = UIScreen.main.bounds.size
let kStoryBoardMain = UIStoryboard(name: "Main", bundle: nil)
let kStoryBoardMenu = UIStoryboard(name: "Menu", bundle: nil)
let kStoryBoardSettings = UIStoryboard(name: "Settings", bundle: nil)

let kAnnouncement = "Announcement"
let kKeyCollection = "Key Collection"
let kUnitTakeOver = "Appointment For Unit Take Over"
let kJointInspection = "Appointment For Joint Inspection"
let kDefectList = "Defect List"
let kDefectInspection = "Defects Inspection"
let kFacilities = "Facility Booking"
let kFeedback = "Feedback"
let kCondoDocument = "Condo Document"
let kResidentsFileUpload = "Residents File Upload"
let kVisitorManagement = "Visitor Management"
let kUserManagement = "User Management"
let kSite = "Site Configurations"
let kModule = "Module Configuration"

let kMenu = "Menu Management"
let themeColor = UIColor(red: 143/255, green: 127/255, blue: 101/255, alpha: 1.0)

let kManageProperty = "Manage Property"
let kManageRole = "Manage Role"
let kManageUnit = "Manage Unit"
let kManageUnitTakeOver = "Manage Unit Take Over"
let kManageJointInsp = "Manage Joint Inspection"
let kFeedbackOptions = "Feedback Options"
let kDefectLocation = "Defect Location"
let kFacilityType = "Facility Type"
let kManagePassword = "Manage Password"
let kEFormSubmission = "E-Form Submissions"


let kAppointmentSettings = "Appointment Settings"
let kVisitingPurpose = "Visiting Purpose"


let kDesc = "Description"
var kImage = "Image"
let isDevelopment = true
let kBaseUrl                = isDevelopment ? "https://aerea.panzerplayground.com/api/ops/" : "https://myaereahome.com/api/ops/"
var kImageFilePath          = isDevelopment ? "https://aerea.panzerplayground.com/storage/app/" :"https://myaereahome.com/storage/app/"


struct API {
    static let kLogin                   = "login"
    static let kVerifyOTP = "verifyotp"
    static let kResendOtp = "resendotp"
    static let kGetAnnouncement = "announcements"
    static let kSearchAnnouncement = "searchannouncement"
    static let kCreateAnnouncement = "createannouncement"
    static let kDeleteAnnouncement = "deleteannouncement"
    static let kGetUserList = "usersummarylist"
    static let kGetUserData = "userinfo"
    static let kGetUnits = "unitlist"
    static let kGetRoles = "roleslist"
    static let kCreateUser = "createuser"
    static let kUpdateUser = "updateuser"
    static let kDeleteUser = "deleteuser"
    static let kSearchUser = "searchuser"
    static let kKeyCollectionSummary = "keycollectionlist"
    static let kSearchKeyCollection = "searchkeycollection"
    static let kKeyCollectionSummaryNew = "keycollectionnewlist"
    static let kDeleteKeyCollection = "deletekeycollection"
    static let kEditKeyCollection = "editkeycollection"
    static let kApproveKeyCollection = "confirmkeycollection"
    static let kDeclineKeyCollection = "declinekeycollection"
    
    static let kGetFeedbackOptions = "feedbackoptions"
    static let kGetFeedbackSummary = "feedbacklist"
    static let kFeedbackSearch = "searchfeedback"
    static let kGetNewFeedback = "feedbacknewlist"
    static let kEditFeedback = "editfeedback"
    static let kDeleteFeedback = "deletefeedback"
    
    static let kGetFacilityOptions = "facilityoptions"
    static let kGetFacilitySummary = "facilitylist"
    static let kFacilitySearch = "searchfacility"
    static let kGetNewFacilities = "facilitynewlist"
    static let kEditFacility = "editfacility"
    static let kCancelFacility = "cancelfacility"
    static let kGetFacilityTimeSlots = "facilitytimeslot"
    
    static let kSettings_PropertyInfo = "propertyinfo"
    static let kSettings_PropertyEdit = "propertyedit"
    
    static let kSettings_UnitsSummary = "unitsummarylist"
    static let kSettings_UnitInfo = "unitinfo"
    static let kSettings_DeleteUnit = "unitdelete"
    static let kSettings_EditUnit = "unitedit"
    static let kSettings_CreateUnit = "unitcreate"
    
    static let kSettings_RoleSummary = "rolessummarylist"
    static let kSettings_RoleInfo = "roleinfo"
    static let kSettings_DeleteRole = "roledelete"
    static let kSettings_EditRole = "roleedit"
    static let kSettings_CreateRole = "rolecreate"
    
    static let kSettings_FeedbackOption = "fboptionsummarylist"
    static let kSettings_FeedbackOptionInfo = "fboptioninfo"
    static let kSettings_DeleteFeedbackOption = "fboptiondelete"
    static let kSettings_EditFeedbackOption = "fboptionedit"
    static let kSettings_CreateFeedbackOption = "fboptioncreate"
    
    static let kSettings_DefectsLocList = "locationlist"
    static let kSettings_DefectsLocInfo = "locationinfo"
    static let kSettings_DeleteDefectsLoc = "locationdelete"
    static let kSettings_EditDefectsLoc = "locationedit"
    static let kSettings_CreateDefectsLoc = "locationcreate"
    
    static let kSettings_FacilityTypeList = "facilitytypelist"
    static let kSettings_FacilityTypeInfo = "facilitytypeinfo"
    static let kSettings_DeleteFacilityType = "facilitytypedelete"
    static let kSettings_EditFacilityType = "facilitytypeedit"
    static let kSettings_CreateFacilityType = "facilitytypecreate"
    
    static let kSettings_VisitingPurposeSummary = "visipurposelist"
    static let kSettings_VisitingPurposeInfo = "visipurposeinfo"
    static let kSettings_DeleteVisitingPurpose = "visipurposedelete"
    static let kSettings_EditVisitingPurpose = "visipurposeedit"
    static let kSettings_CreateVisitingPurpose = "visipurposecreate"
    
    
    
    static let kEForm_MoveInOutSummary = "moveinoutsummary"
    static let kEForm_MoveInOutSearch = "moveinoutsearch"
    static let kEForm_MoveInOutDelete = "moveinoutdelete"
    static let kEForm_MoveInOutUpdate = "moveinoutedit"
    static let kEForm_MoveInOutInspection = "moveinoutinspectionsave"
    static let kEForm_MoveInOutPayment = "moveinoutpaymentsave"
    
    static let kEForm_RenovationSummary = "renovationsummary"
    static let kEForm_RenovationSearch = "renovationsearch"
    static let kEForm_RenovationDelete = "renovationdelete"
    static let kEForm_RenovationUpdate = "renovationedit"
    static let kEForm_RenovationPayment = "renovationpaymentsave"
    static let kEForm_RenovationInspection = "renovationinspectionsave"
    
    static let kEForm_DoorAccessSummary = "dooraccesssummary"
    static let kEForm_DoorAccessSearch = "dooraccesssearch"
    static let kEForm_DoorAccessDelete = "dooraccessdelete"
    static let kEForm_DoorAccessUpdate = "dooraccessedit"
    
    static let kEForm_VehicleRegSummary = "regvehiclesummary"
    static let kEForm_VehicleRegSearch = "regvehiclesearch"
    static let kEForm_VehicleRegDelete = "regvehicledelete"
    static let kEForm_VehicleRegUpdate = "regvehicleedit"
    
    static let kEForm_UpdateAddressSummary = "changeaddresssummary"
    static let kEForm_UpdateAddressSearch = "changeaddresssearch"
    static let kEForm_UpdateAddressDelete = "changeaddressdelete"
    static let kEForm_UpdateAddressUpdate = "changeaddressedit"
    
    static let kEForm_UpdateParticularsSummary = "updateparticularsummary"
    static let kEForm_UpdateParticularsSearch = "updateparticularsearch"
    static let kEForm_UpdateParticularsDelete = "updateparticulardelete"
    static let kEForm_UpdateParticularsUpdate = "updateparticularedit"

}
enum Appointment{
    case keyCollection
    case defectInspection
    case facility
}
enum MenuType {
    case home
    case settings
    case logout
}
