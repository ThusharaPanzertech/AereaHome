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

var kCurrentPropertyId = 0
var kCurrentPropertyName = ""

let kAnnouncement = "Announcement"
let kKeyCollection = "Key Collection"
let kUnitTakeOver = "Appointment For Unit Take Over"
let kJointInspection = "Appointment For Joint Inspection"
let kDefectList = "Defects"
let kDefectInspection = "Defect Inspection"
let kFacilities = "Facility Booking"
let kFeedback = "Feedback"
let kCondoDocument = "Condo Document"
let kResidentsFileUpload = "Resident File Upload"
let kVisitorManagement = "Visitor Management"
let kDoorRecords = "Open Door Records"
let kUserManagement = "User Management"
let kSite = "Site Configurations"
let kModule = "Module Configuration"
let kDigitalAccess = "Digital Access"
let kStaffDigitalAccess = "Staff Digital Access"
let kMenu = "Menu Management"
let kCardAcess = "Access Card Management"
let kDeviceManagement = "Device Management"
let kBuildingManagement = "Building Management"
let kEformSettings = "E-form Settings"
let kEformSettings1 = "Eforms Settings"
let kPaymentSettings = "Payment Settings"
let kUploadFace = "Upload Face ID"
let kStaffDoorOpen = "Staff Door Open"
let kStaffRemoteDoorOpen = "Staff Remote Door Open"
let kStaffBluetoothDoorOpen = "Staff Bluetooth Door Open"
let kHolidaySettings = "Holiday Settings"
let kOthers = "Others"
let themeColor = UIColor(red: 143/255, green: 127/255, blue: 101/255, alpha: 1.0)

let kManageProperty = "Property Management"
let kManageRole = "Role Management"
let kManageUnit = "Unit Management"
let kManageUnitTakeOver = "Manage Unit Take Over"
let kManageJointInsp = "Manage Joint Inspection"
let kFeedbackOptions = "Feedback Options"
let kDefectLocation = "Defects Location"
let kFacilityType = "Facility Type"
let kManagePassword = "Manage Password"
let kEFormSubmission = "Eforms"
let kSettings = "Settings"

let kAppointmentSettings = "Inspection Appointment Settings"
let kVisitingPurpose = "Visiting Purpose"
let kAppDashboardSettings = "App Dashboard Menu Settings"

let kId = "Id"
let kDesc = "Description"
var kImage = "Image"
let isDevelopment = true
let kBaseUrl                = isDevelopment ? "https://aerea.panzerplayground.com/api/ops/" : "https://myaereahome.com/api/ops/"
var kImageFilePath          = isDevelopment ? "https://aerea.panzerplayground.com/storage/app/" :"https://myaereahome.com/storage/app/"


struct API {
    static let kHistoryLog = "loginHistoryLogs"
    static let kLogoutHistoryLogs = "logoutHistoryLogs"
    static let kLogin                   = "login"
    static let kVerifyOTP = "verifyotp"
    static let kResendOtp = "resendotp"
    static let kGetUserInfo = "logininfo"
    static let kGetDashboardInfo = "dashboardmenu"
    static let kGetAnnouncement = "announcements"
    static let kSearchAnnouncement = "searchannouncement"
    static let kCreateAnnouncement = "createannouncement"
    static let kDeleteAnnouncement = "deleteannouncement"
    static let kGetUserList = "usersummarylist"
    
    static let kGetSystemAccessList = "useraccess"
    static let kUpdateSystemAccess = "useraccessupdate"
    static let kGetUserAccessList = "bulkuseraccess"
    static let kSearchUserAccessList = "bulkuseraccesssearch"
    static let kSubmitUserAccess = "useraccessupdate"
    static let kGetUserData = "userinfo"
    static let kGetUnits = "unitlist"
    static let kGetUnitCard = "unitcards"
    static let kGetCountry = "countries"
    static let kGetAssignedUnits = "userunits"
    static let kAssignUnit = "assignunit"
    static let kDeleteAssignednUnit = "deleteunit"
    static let kSearchUnits = "unitsummarysearch"
    static let kGetUnitListType = "unitsummarytypes"
    static let kGetPropertyList = "getpropertylist"
    static let kSwitchProperty = "switchproperty"
    static let kGetRoles = "roleslist"
    static let kGetUserRoles = "userroles"
    static let kCreateUser = "createuser"
    static let kUpdateUser = "updateuser"
    static let kDeleteUser = "deleteuser"
    static let kSearchUser = "searchuser"
    
    static let kActivateUser = "activateuser"
    static let kDeactivateUser = "deactivateuser"
    
    static let kKeyCollectionSummary = "keycollectionlist"
    static let kKeyCollectionInfo = "keycollectioninfo"
    static let kSearchKeyCollection = "searchkeycollection"
    static let kKeyCollectionSummaryNew = "keycollectionnewlist"
    static let kDeleteKeyCollection = "deletekeycollection"
    static let kEditKeyCollection = "editkeycollection"
    static let kApproveKeyCollection = "confirmkeycollection"
    static let kDeclineKeyCollection = "cancelkeycollection"
    
    static let kGetFeedbackOptions = "feedbackoptions"
    static let kGetFeedbackSummary = "feedbacklist"
    static let kGetFeedbackDetail = "feedbackinfo"
    static let kFeedbackSearch = "searchfeedback"
    static let kGetNewFeedback = "feedbacknewlist"
    static let kEditFeedback = "editfeedback"
    static let kDeleteFeedback = "deletefeedback"
    
    static let kGetFacilityOptions = "facilityoptions"
    static let kGetFacilitySummary = "facilitylist"
    static let kGetFacilityInfo = "facilityinfo"
    static let kFacilitySearch = "searchfacility"
    static let kGetNewFacilities = "facilitynewlist"
    static let kEditFacility = "editfacility"
    static let kCancelFacility = "cancelfacility"
    static let kGetFacilityTimeSlots = "facilitytimeslot"
    static let kApproveFacility = "confirmfacility"
    static let kDeclineFacility  = "cancelfacility"
    
    static let kGetVisitorSummary = "visitorsummary"
    static let kSearchVisitorSummary = "visitorsearch"
    static let kGetVisitorInfo = "visitorinfo"
    static let kDeleteVisitorBooking = "visitordelete"
    static let kUpdateVisitorBooking = "visitoredit"
    static let kGetVisitorAvailability = "availability_check"
    static let kGetVisitorFunction = "visitor_types"
    static let kRegisterVisitorWalkin = "visitorwalkin"
    
    static let kGetDefectsSummary = "defectslist"
    static let kDefectSearch = "defectssearch"
    static let kDeleteDefect = "deletedefect"
    static let kGetDefectDetail          = "defectsinfo"
    static let kUpdateDefectInspectionSignature = "defectsupdate"
    static let kGetInspectionTimings = "defecttimeslot"
    static let kEditInspectionAppt = "defectsinspectionupdate"
    static let kCancelInspectionAppt = "defectscancelinspection"
    static let kUpdateHandoverSignature = "defectshandoverupdate"
    
    static let kGetResidentFileSummary = "resFileSummary"
    static let kGetResidentFileInfo = "resFileInfo"
    static let kGetResidentFileSummaryNew = "resFileSummaryNew"
    static let kResidentFileSearch = "resFileSearch"
    static let kGetNewResidentFileUploads = "resFileSummaryNew"
    static let kEditResidentFile = "resFileEdit"
    static let kDeleteResidentFileUpload = "resFileDelete"
    
    
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
    
    
    
    static let kEForm_SettingsInfo = "eformsettingsinfo"
    static let kEForm_MoveInOutSummary = "moveinoutsummary"
    static let kEForm_MoveInOutInfo = "moveinoutinfo"
    static let kEForm_MoveInOutSearch = "moveinoutsearch"
    static let kEForm_MoveInOutDelete = "moveinoutdelete"
    static let kEForm_MoveInOutUpdate = "moveinoutedit"
    static let kEForm_MoveInOutInspection = "moveinoutinspectionsave"
    static let kEForm_MoveInOutPayment = "moveinoutpaymentsave"
    
    static let kEForm_RenovationSummary = "renovationsummary"
    static let kEForm_RenovationInfo = "renovationinfo"
    static let kEForm_RenovationSearch = "renovationsearch"
    static let kEForm_RenovationDelete = "renovationdelete"
    static let kEForm_RenovationUpdate = "renovationedit"
    static let kEForm_RenovationPayment = "renovationpaymentsave"
    static let kEForm_RenovationInspection = "renovationinspectionsave"
    
    static let kEForm_DoorAccessSummary = "dooraccesssummary"
    static let kEForm_DoorAccessInfo = "dooraccessinfo"
    static let kEForm_DoorAccessSearch = "dooraccesssearch"
    static let kEForm_DoorAccessDelete = "dooraccessdelete"
    static let kEForm_DoorAccessUpdate = "dooraccessedit"
    static let kEForm_DoorAccessPayment = "dooraccesspaymentsave"
    static let kEForm_DoorAccessAcknowledgement = "dooracknowledgementsave"
    
    static let kEForm_VehicleRegSummary = "regvehiclesummary"
    static let kEForm_VehicleRegInfo = "regvehicleinfo"
    static let kEForm_VehicleRegSearch = "regvehiclesearch"
    static let kEForm_VehicleRegDelete = "regvehicledelete"
    static let kEForm_VehicleRegUpdate = "regvehicleedit"
    static let kEForm_VehicleRegDetails = "regvehicleinfo"
    
    static let kEForm_UpdateAddressSummary = "changeaddresssummary"
    static let kEForm_UpdateAddressSearch = "changeaddresssearch"
    static let kEForm_UpdateAddressInfo = "changeaddressinfo"
    static let kEForm_UpdateAddressDelete = "changeaddressdelete"
    static let kEForm_UpdateAddressUpdate = "changeaddressedit"
    
    static let kEForm_UpdateParticularsSummary = "updateparticularsummary"
    static let kEForm_UpdateParticularInfo = "updateparticularinfo"
    static let kEForm_UpdateParticularsSearch = "updateparticularsearch"
    static let kEForm_UpdateParticularsDelete = "updateparticulardelete"
    static let kEForm_UpdateParticularsUpdate = "updateparticularedit"
    
    static let kGetCardSummary = "cardsummarylist"
    static let kSearchCardSummary = "searchcard"
    static let kDeleteCard = "deletecard"
    static let kAddCard = "createcard"
    static let kEditCard = "editcard"

    static let kGetDeviceSummary = "devicesummarylist"
    static let kSearchDeviceSummary = "searchdevice"
    static let kGetDeviceLocation = "getlocation"
    static let kAddDevice = "createdevice"
    static let kEditDevice = "editdevice"
    static let kDeleteDevice = "deletedevice"
    static let kRestarteDevice = "restartdevice"
    
    static let kGetCondoCategory = "docsCatSummary"
    static let kGetCondoDetail = "docsCatInfo"
    static let kCreateCondoDoc = "docsCatCreate"
    static let kEditCondoDoc = "docsCatEdit"
    static let kDeleteCondoDoc = "docsCatDelete"
    static let kDeleteCondoFiles = "docsDeleteFile"
    
    
    static let kGetPaymentInfo = "paymentinfo"
    static let kSubmitPaymentInfo = "paymentedit"
    
    static let kGetHolidayInfo = "holidayinfo"
    static let kSubmitHolidayInfo = "holidayedit"
    
    static let kAssignDeviceList = "userdevicelists"
    static let kUpdateAssignDevice = "userdeviceupdate"
    
    static let kGetFaceIds = "stafffaceids"
    static let kDeleteFaceId = "faceiddelete"
    static let kGetStaffRolesList = "getroleslist"
    static let kGetBuildingSummaryList = "buildingsummarylist"
    static let kCreateBuildingList = "buildingcreate"
    static let kEditBuildingList = "buildingedit"
    static let kDeleteBuildingList = "buildingdelete"
    static let kGetBuildingUnitsList = "unitsearch"
    static let kGetFaceOptions = "uploadoptions"
    static let kGetUserByRole = "getstafflist"
    static let kUploadStaffFace = "uploadstafffaceid"
    
    static let kGetBluetoothDevices = "staffbluetoothdevices"
    static let kGetRemoteDevices = "staffremotedevices"
    static let kGetThinmooToken = "getaccesstoken"
    static let kInsertThinmooRecord = "InsertBluetoothOpenRecord"
    
    static let kGetNormalDoorRecord = "dooropen"
    static let kSearchNormalDoorRecord  = "searchdooropen"
    static let kGetBluetoothDoorRecord = "bluetoothdooropen"
    static let kSearchBluetoothDoorRecord = "searchbluetoothdooropen"
    static let kGetFailedDoorRecord = "dooropenfailed"
    static let kSearchFailedDoorRecord = "searchdooropenfailed"
    static let kGetCallUnitDoorRecord = "callunit"
    static let kSearchCallUnitDoorRecord = "searchcallunit"
    static let kGetQRCodeDoorRecord = "qropenrecords"
    static let kSearchQRCodeDoorRecord = "searchqropenrecords"
    
    static let kGetUnitListTypeSummary = "unitsummary"
    
    static let kGetInvoiceSummary = "invoice_report"
    static let kSearchInvoiceSummary = "report_search"
    static let kGetBatchInvoiceSummary = "batches"//batch_invoices
    static let kGetInvoiceDetail = "invoiceview"
    static let kSearchBatchInvoiceSummary = "batchesearch"
    static let kDeleteBatchInvoice = "batchdelete"
    static let kUpdateInvoicePayment = "paymentsave"
    
    static let kGetNotification = "manager_notifications"
    static let kUpdateNotification = "update_notification"
    
}
enum Appointment{
    case keyCollection
    case defectInspection
    case facility
}
enum MenuType {
    case home
    case notifiation
    case settings
    case logout
}
extension String {
    var trimmingTrailingSpaces: String {
        if let range = rangeOfCharacter(from: .whitespacesAndNewlines, options: [.anchored, .backwards]) {
            return String(self[..<range.lowerBound]).trimmingTrailingSpaces
        }
        return self
    }
}
