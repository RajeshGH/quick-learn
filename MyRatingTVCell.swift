//
//  MyRatingTVCell.swift
//  QuickLearn
//
//  Created by Xtreem Solution on 12/03/19.
//  Copyright © 2019 XtreemSolution. All rights reserved.
//

import UIKit
import Cosmos
class MyRatingTVCell: UITableViewCell {

    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var viewRating: CosmosView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
