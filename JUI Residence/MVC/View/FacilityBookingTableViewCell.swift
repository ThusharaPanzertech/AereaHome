//
//  FacilityBookingTableViewCell.swift
//  JUI Residence
//
//  Created by Thushara Harish on 28/07/21.
//

import UIKit

class FacilityBookingTableViewCell: UITableViewCell {

    //Outlets
    @IBOutlet weak var lbl_IndexNo: UILabel!
    @IBOutlet weak var lbl_Date: UILabel!
    @IBOutlet weak var lbl_TimeSlot: UILabel!
    @IBOutlet weak var lbl_Unit: UILabel!
    @IBOutlet weak var btn_Edit: UIView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


class ServiceSummaryTableViewCell: UITableViewCell {

    //Outlets
    @IBOutlet weak var lbl_ServiceName: UILabel!
    @IBOutlet weak var lbl_ServiceIndex: UILabel!
    @IBOutlet weak var btn_Edit1: UIButton!
    @IBOutlet weak var btn_Edit2: UIButton!
    @IBOutlet weak var btn_Delete: UIButton!
    @IBOutlet weak var view_Outer: UIView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class ManageUnitTableViewCell: UITableViewCell {

    //Outlets
    @IBOutlet weak var lbl_UnitNo: UILabel!
    @IBOutlet weak var lbl_Index: UILabel!
    @IBOutlet weak var lbl_Size: UILabel!
    @IBOutlet weak var lbl_Share: UILabel!
    @IBOutlet weak var btn_Edit: UIButton!
    @IBOutlet weak var btn_Delete: UIButton!
    @IBOutlet weak var view_Outer: UIView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


class EditRoleTableViewCell: UITableViewCell {

    //Outlets
    @IBOutlet weak var lbl_RoleType: UILabel!
    @IBOutlet weak var btn_Delete: UIButton!
    @IBOutlet weak var btn_View: UIButton!
    @IBOutlet weak var btn_Add: UIButton!
    @IBOutlet weak var btn_Edit: UIButton!
    @IBOutlet weak var view_Outer: UIView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


class AddDefectsLocationTableViewCell: UITableViewCell {

    //Outlets
    @IBOutlet weak var lbl_Type: UILabel!
    @IBOutlet weak var txt_DefectType: UITextField!
   
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
