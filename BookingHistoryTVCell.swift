//
//  BookingHistoryTVCell.swift
//  QuickLearn
//
//  Created by Xtreem Solution on 11/03/19.
//  Copyright © 2019 XtreemSolution. All rights reserved.
//

import UIKit

class BookingHistoryTVCell: UITableViewCell {

    @IBOutlet weak var imgTutor: UIImageView!
    @IBOutlet weak var lblTutorName: UILabel!
    @IBOutlet weak var lblTutorId: UILabel!
    @IBOutlet weak var lblTutorPrice: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var lblEndTime: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblSubject: UILabel!
    @IBOutlet weak var viewRating: UIView!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var btnFavourite: UIButton!
    @IBOutlet weak var btnRequestStatus: UIButton!
    @IBOutlet weak var btnRequestTotalPrice: UIButton!
    @IBOutlet weak var btnRebook: UIButton!
    
    @IBOutlet weak var btnDetails: UIButton!
    @IBOutlet weak var btnRating: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
