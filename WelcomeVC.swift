//
//  WelcomeVC.swift
//  QuickLearn
//
//  Created by Xtreem Solution on 19/02/19.
//  Copyright © 2019 XtreemSolution. All rights reserved.
//

import UIKit

class WelcomeVC: BaseViewController {

    // IBOutlets
    @IBOutlet weak var imgLogo: UIImageView!
    
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnSingUp: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // To set UI of screen
        self.view.applyGradient(colours: [CustomColor.appThemeTopColor,CustomColor.appThemeBottomColor])
        self.btnSignIn.setCornerRadius(button: self.btnSignIn, cornerRadius: 5)
        self.btnSingUp.setCornerRadius(button: self.btnSingUp, cornerRadius: 5)
        self.btnSingUp.setBorder(button: self.btnSingUp, color: UIColor.white)
        // Do any additional setup after loading the view.
        self.hudHide()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // To hide Navigation bar
        self.hideNavigationBar()
    }
    
    // MARK: -  IBActions 
    @IBAction func btnSignIn_didSelect(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "loginVC") as? LoginVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func btnSignUp_didSelect(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "signUpPersonalDetailsVC") as? SignUpPersonalDetailsVC
        self.navigationController?.pushViewController(vc!, animated: true)
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
