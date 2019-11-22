//
//  SignUpAcademicDetailsTVCell.swift
//  QuickLearn
//
//  Created by Xtreem Solution on 20/02/19.
//  Copyright © 2019 XtreemSolution. All rights reserved.
//

import UIKit

class SignUpAcademicDetailsTVCell: UITableViewCell {

    // For Subject Table
    @IBOutlet weak var lblSubject: UILabel!
    @IBOutlet weak var btnSubject: UIButton!
    
    // For Result Table
    @IBOutlet weak var txtSelectedSubject: SkyFloatingLabelTextField!
    @IBOutlet weak var viewCGSEResult: UIView!
    @IBOutlet weak var txtCGSEResult: UITextField!
    @IBOutlet weak var btnRemoveSubject: UIButton!
    @IBOutlet weak var imgSubject: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
