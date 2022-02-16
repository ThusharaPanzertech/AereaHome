//
//  AnnouncementHistoryTableViewCell.swift
//  JUI Residence
//
//  Created by Thushara Harish on 26/07/21.
//

import UIKit

class AnnouncementHistoryTableViewCell: UITableViewCell {
    //Outlets
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_Date: UILabel!
    @IBOutlet weak var lbl_UserTypes: UILabel!
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
