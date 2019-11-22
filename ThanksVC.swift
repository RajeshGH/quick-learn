//
//  ThanksVC.swift
//  QuickLearn
//
//  Created by Xtreem Solution on 28/03/19.
//  Copyright © 2019 XtreemSolution. All rights reserved.
//

import UIKit

class ThanksVC: UIViewController {
@IBOutlet weak var btnCross: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: -  IBActions 
    
    @IBAction func btnCross_didSelect(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
