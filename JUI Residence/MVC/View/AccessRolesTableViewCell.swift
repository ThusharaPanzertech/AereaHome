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
    @IBOutlet weak var lbl_LastName: UILabel!
    @IBOutlet weak var btn_Edit: UIButton!
    @IBOutlet weak var lbl_AssignedRole: UILabel!
    @IBOutlet weak var lbl_UnitNo: UILabel!
    @IBOutlet weak var lbl_Contact: UILabel!
    @IBOutlet weak var lbl_Password: UILabel!
    @IBOutlet weak var lbl_Email: UILabel!
    @IBOutlet weak var view_Outer: UIView!
    @IBOutlet weak var img_Arrow: UIImageView!
    @IBOutlet var arrViews: [UIView]!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        // corner radius
        view_Outer.layer.cornerRadius = 10
//
//        // border
//        view_Outer.layer.borderWidth = 1.0
//        view_Outer.layer.borderColor = UIColor.lightGray.cgColor
//
//        // shadow
//        view_Outer.layer.shadowColor = UIColor.black.cgColor
//        view_Outer.layer.shadowOffset = CGSize(width: 3, height: 3)
//        view_Outer.layer.shadowOpacity = 0.7
//        view_Outer.layer.shadowRadius = 4.0
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


