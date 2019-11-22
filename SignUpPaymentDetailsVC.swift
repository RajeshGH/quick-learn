//
//  SignUpPaymentDetailsVC.swift
//  QuickLearn
//
//  Created by Xtreem Solution on 19/02/19.
//  Copyright © 2019 XtreemSolution. All rights reserved.
//

import UIKit

class SignUpPaymentDetailsVC: BaseViewController {
    // IBOutlets
    @IBOutlet weak var txtRate: SkyFloatingLabelTextField?
    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var btnTermsAndCon: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    
     var userInfoPersonalAndAcademicData = [String : Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // To set UI of screen
        self.btnSignUp.setCornerRadius(button: self.btnSignUp, cornerRadius: 5)
        
        self.btnCheck.isSelected = false
        self.txtRate?.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //To Show Navigation controller
        self.showNavigationBar()
        self.setTitle(lblTitle: "Payment Details")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.setTitle(lblTitle: "Payment Details")
    }
    
    // MARK: -  IBActions 
    @IBAction func btnCheck_didSelect(_ sender: Any) {
        if btnCheck.isSelected == false{
            self.btnCheck.isSelected = true
            self.imgCheck.image = UIImage(named: "active_check_button")
        }else{
            self.btnCheck.isSelected = false
            self.imgCheck.image = UIImage(named: "check_button")
        }
    }
    @IBAction func btnTermsAndCon_didSelect(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "termsAndConditionVC") as? TermsAndConditionVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func btnSignUp_didSelect(_ sender: Any) {
        if self.checkValidation(){
            print("User personal,academic and payment details = ",self.userInfoPersonalAndAcademicData)
            self.userInfoPersonalAndAcademicData["hourly_rate"] = txtRate?.text
            self.callApiToRegister()
        }
        
    }
    
    // MARK: -  Custom Methods 
    func callApiToRegister() {
        self.hudShow()
        
        ServiceClass.sharedInstance.hitServiceForSignUp(self.userInfoPersonalAndAcademicData,  completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
            self.hudHide()
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                if(parseData["status"].stringValue == "success") {
                    AppHelper.showALertWithTag(0, title: "Alert", message: parseData["message"].string!, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }else {
                
                AppHelper.showALertWithTag(0, title: "Alert", message: (errorDict?[ServiceKeys.keyErrorMessage] as? String)!, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            }
        })
        
    }
    
    func checkValidation() -> Bool {
        self.view.endEditing(true)
        
        if(self.txtRate!.text!.isBlank){
            
            self.txtRate!.errorMessage = err_rate_blank
            self.txtRate!.errorColor = CustomColor.redColor
            return false
        }
        if self.btnCheck.isSelected == false{
             AppHelper.showALertWithTag(0, title: "Alert", message: err_termsNcondition_uncheck, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            return false
        }
        return  true
    }
}
extension SignUpPaymentDetailsVC:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let field = textField as! SkyFloatingLabelTextField
        field.errorMessage = ""
        field.errorColor = .clear
        return true
    }
}
