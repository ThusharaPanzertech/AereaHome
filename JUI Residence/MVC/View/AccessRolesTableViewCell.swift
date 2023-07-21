//
//  AccessRolesTableViewCell.swift
//  JUI Residence
//
//  Created by Thushara Harish on 24/07/21.
//

import UIKit

class AccessRolesTableViewCell: UITableViewCell {
    //Outlets
    @IBOutlet weak var lbl_FirstName: UILabel!
    @IBOutlet weak var lbl_Phone: UILabel!
    @IBOutlet weak var lbl_StartDate: UILabel!
    @IBOutlet weak var lbl_EndDate: UILabel!
    @IBOutlet weak var lbl_LastName: UILabel!
    @IBOutlet weak var btn_Edit: UIButton!
    @IBOutlet weak var btn_Activate: UIButton!
    @IBOutlet weak var btn_UnitInfo: UIButton!
    @IBOutlet weak var btn_AssignDevices: UIButton!
    @IBOutlet weak var btn_SystemAccess: UIButton!
    @IBOutlet weak var btn_Delete: UIButton!
    @IBOutlet weak var lbl_AssignedRole: UILabel!
    @IBOutlet weak var lbl_UnitNo: UILabel!
    @IBOutlet weak var lbl_Contact: UILabel!
    @IBOutlet weak var lbl_Password: UILabel!
    @IBOutlet weak var lbl_Email: UILabel!
    @IBOutlet weak var view_Outer: UIView!
    @IBOutlet weak var img_Arrow: UIImageView!
    @IBOutlet weak var img_Phone: UIImageView!
    @IBOutlet weak var btn_Space: NSLayoutConstraint!
    @IBOutlet var arrViews: [UIView]!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        view_Outer.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
class PropertyTableViewCell: UITableViewCell {
    //Outlets
    @IBOutlet weak var lbl_ProperyName: UILabel!
    @IBOutlet weak var view_Outer: UIView!
 
    @IBOutlet weak var btn_Checkbox: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
class EditUserAccessTableViewCell: UITableViewCell {
    //Outlets
    @IBOutlet weak var lbl_RoleName: UILabel!
    @IBOutlet weak var view_Outer: UIView!
 
    @IBOutlet weak var btn_Checkbox: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


class UserListTableViewCell: UITableViewCell {
    //Outlets
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_UserRole: UILabel!
    @IBOutlet weak var lbl_UserUnit: UILabel!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
       
    }

   

}
class AssignDeviceHeaderTableViewCell: UITableViewCell {
    //Outlets
    @IBOutlet weak var lbl_Building: UILabel!
    @IBOutlet weak var lbl_Unit: UILabel!
    @IBOutlet weak var lbl_UnitTitle: UILabel!
    
    @IBOutlet weak var btn_CheckAll: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
       
    }

   

}
class DeviceCallTableViewCell: UITableViewCell {
    //Outlets
    @IBOutlet weak var txt_ReceiveCall: UITextField!
    @IBOutlet weak var btn_ReceiveCall: UIButton!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
       
    }

   

}
class DeviceTableViewCell: UITableViewCell {
    //Outlets
    @IBOutlet weak var lbl_DeviceName: UILabel!
    @IBOutlet weak var lbl_SerialNo: UILabel!
    @IBOutlet weak var lbl_Location: UILabel!
 
    @IBOutlet weak var btn_Bluetooth: UIButton!
    @IBOutlet weak var btn_Remote: UIButton!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
       
    }

   

}

class ModuleListTableViewCell1: UITableViewCell {
    //Outlets
    @IBOutlet weak var collectionViewModule: UICollectionView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let layout1 =  UICollectionViewFlowLayout()
        layout1.minimumLineSpacing = 0
        layout1.minimumInteritemSpacing = 0
        layout1.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let ht = collectionViewModule.tag == 0 ? 50 : 80
        let size1 = CGSize(width: 130, height: ht)
        layout1.itemSize = size1
        layout1.scrollDirection = .horizontal
    collectionViewModule.collectionViewLayout = layout1
       
    }

   

}
class ModuleListTableViewCell: UITableViewCell {
    //Outlets
    @IBOutlet weak var collectionViewModule: UICollectionView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let layout1 =  UICollectionViewFlowLayout()
        layout1.minimumLineSpacing = 0
        layout1.minimumInteritemSpacing = 0
        layout1.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
       
        let size1 = CGSize(width: 130, height: 80)
        layout1.itemSize = size1
        layout1.scrollDirection = .horizontal
    collectionViewModule.collectionViewLayout = layout1
       
    }

   

}

class ModuleColllectionViewCell: UICollectionViewCell {
    //Outlets
    @IBOutlet weak var lbl_ModuleName: UILabel!
    @IBOutlet weak var btn_Checkbox: UIButton!
    @IBOutlet weak var btn_Check: UIButton!
    @IBOutlet weak var btn_AccessCheckbox: UIButton!
    @IBOutlet weak var centerX: NSLayoutConstraint!
 
    

   

}
class AssignedUnitsTableViewCell: UITableViewCell {
    //Outlets
    @IBOutlet weak var btn_Delete: UIButton!
    @IBOutlet weak var lbl_Building: UILabel!
    @IBOutlet weak var lbl_Unit: UILabel!
    @IBOutlet weak var lbl_Role: UILabel!
    @IBOutlet weak var lbl_PrimaryContact: UILabel!
    @IBOutlet weak var lbl_AssignedDate: UILabel!
    @IBOutlet weak var view_Outer: UIView!
 
    @IBOutlet weak var btn_Checkbox: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


class SystemAccessTableViewCell: UITableViewCell {
    //Outlets
    @IBOutlet weak var collectionViewAccess: UICollectionView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let layout1 =  UICollectionViewFlowLayout()
        layout1.minimumLineSpacing = 0
        layout1.minimumInteritemSpacing = 0
        layout1.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
       
        let size1 = CGSize(width: 130, height: 95)
        layout1.itemSize = size1
        layout1.scrollDirection = .horizontal
        collectionViewAccess.collectionViewLayout = layout1
       
    }

   

}
class SystemAccessColllectionViewCell: UICollectionViewCell {
    //Outlets
    @IBOutlet weak var lbl_Access: UILabel!
    @IBOutlet weak var btn_Checkbox: UIButton!
   
    

   

}
