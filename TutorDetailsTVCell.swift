//
//  TutorDetailsTVCell.swift
//  QuickLearn
//
//  Created by Xtreem Solution on 22/02/19.
//  Copyright © 2019 XtreemSolution. All rights reserved.
//

import UIKit

class TutorDetailsTVCell: UITableViewCell {

    @IBOutlet weak var lbl_description: UILabel!
    @IBOutlet weak var lbl_heading: UILabel!
    @IBOutlet weak var view_line: UIView!
    
    @IBOutlet weak var lbl_count: UILabel!
    
    @IBOutlet weak var lbl_count_width_constraint: NSLayoutConstraint!
    
    @IBOutlet weak var lbl_count_leading_constraint: NSLayoutConstraint!
    
    @IBOutlet weak var heading_height_constraint: NSLayoutConstraint!
    @IBOutlet weak var heading_top_constraint: NSLayoutConstraint!
    @IBOutlet weak var description_top_constraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
