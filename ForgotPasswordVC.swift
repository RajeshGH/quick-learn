//
//  ForgotPasswordVC.swift
//  QuickLearn
//
//  Created by Xtreem Solution on 19/02/19.
//  Copyright © 2019 XtreemSolution. All rights reserved.
//

import UIKit

class ForgotPasswordVC: BaseViewController {
    // IBOutlets
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField?
    @IBOutlet weak var btnReset: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // To set UI of screen
        self.btnReset.setCornerRadius(button: self.btnReset, cornerRadius: 5)
        txtEmail?.delegate = self
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //To Show Navigation controller
        self.showNavigationBar()
        self.setTitle(lblTitle: "Forgot Password")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.setTitle(lblTitle: "Forgot Password")
    }
    
   // MARK: -  IBActions 
    @IBAction func btnReset_didSelect(_ sender: Any) {
        if (checkValidationforForgotPassword()) {
            self.callApiForForgotPassword(emailText: (txtEmail?.text!)!)
        }
    }
    
    // MARK: -  Custom Method 

    // To check for blank and valid email
    func checkValidationforForgotPassword() -> Bool {
        if(txtEmail!.text!.isBlank){
           // self.makeToast(txtEmail)
            self.txtEmail!.errorMessage = err_Email_Blank
            self.txtEmail!.errorColor = CustomColor.redColor
           // AppHelper.showALertWithTag(0, title: "Alert", message: err_Email_Blank, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            return false
        }
        if(!txtEmail!.text!.isEmail)
        {
          self.txtEmail!.errorMessage = err_valid_mail
          self.txtEmail!.errorColor = CustomColor.redColor
         // AppHelper.showALertWithTag(0, title: "Alert", message: err_valid_mail, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            return false
        }
        return true
    }
 
    func callApiForForgotPassword(emailText : String) {
        var parms = [String : String]()
        parms["email"] = emailText
        self.hudShow()
        ServiceClass.sharedInstance.hitServiceForForgotPassword( parms, completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
            print_debug("response: \(parseData)")
            self.hudHide()
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                self.txtEmail!.text = ""
                AppHelper.showALertWithTag(0, title: "Alert", message: parseData["message"].string!, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
               // self.makeToast(parseData["message"].string!)
                self.navigationController?.popViewController(animated: true)
            }else {
                AppHelper.showALertWithTag(0, title: "Alert", message: (errorDict?[ServiceKeys.keyErrorMessage] as? String)!, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
               // self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
            }
        })
    }

}

extension ForgotPasswordVC:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let field = textField as! SkyFloatingLabelTextField
        field.errorMessage = ""
        field.errorColor = .clear
        return true
    }
}
