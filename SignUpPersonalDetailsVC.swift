//
//  SignUpPersonalDetailsVC.swift
//  QuickLearn
//
//  Created by Xtreem Solution on 19/02/19.
//  Copyright © 2019 XtreemSolution. All rights reserved.
//

import UIKit

class SignUpPersonalDetailsVC: BaseViewController {

    // IBOutlets
    @IBOutlet weak var txtName: SkyFloatingLabelTextField?
    @IBOutlet weak var txtUserName: SkyFloatingLabelTextField?
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField?
    @IBOutlet weak var txtPhoneNumber: SkyFloatingLabelTextField?
    @IBOutlet weak var txtPassword: SkyFloatingLabelTextField?
    @IBOutlet weak var txtConfirmPassword: SkyFloatingLabelTextField?
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnSignIn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // To set UI of page
        self.btnNext.setCornerRadius(button: self.btnNext, cornerRadius: 5)
        // Do any additional setup after loading the view.
        self.txtName?.delegate = self
        self.txtUserName?.delegate = self
        self.txtEmail?.delegate = self
        self.txtPhoneNumber?.delegate = self
        self.txtPassword?.delegate = self
        self.txtConfirmPassword?.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // To hide Navigation bar
        self.hideNavigationBar()
    }
    // MARK: -  IBActions 
    @IBAction func btnSignIn_didSelect(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNext_didSelect(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "signUpAcademicDetailsVC") as? SignUpAcademicDetailsVC
        
        if self.checkValidation(){
            let deviceToken = AppHelper.getStringForKey(ServiceKeys.device_token)
            var userInfo = [String : Any]()
            userInfo["name"] = self.txtName!.text
            userInfo["username"] = self.txtUserName!.text
            userInfo["email"] = self.txtEmail!.text
            userInfo["contact_number"] = self.txtPhoneNumber!.text
            userInfo["password"] = self.txtPassword!.text
            userInfo["confirm_password"] = self.txtConfirmPassword!.text
            userInfo["device_type"] = "iOS"
            userInfo["device_token"] = deviceToken
            vc!.userInfoPersonalDetails = userInfo
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        
        
    }
   
     // MARK: -  Custom Methods 
    func checkValidation() -> Bool {
        self.view.endEditing(true)
        if(self.txtName!.text!.isBlank){
            
            self.txtName!.errorMessage = err_Name_Blank
            self.txtName!.errorColor = CustomColor.redColor
            return false
        }
        if(self.txtName!.text!.characters.count < 3 ){
            self.txtName!.errorColor = CustomColor.redColor
            self.txtName!.errorMessage = err_Name_Length
            return false
        }
        if(self.txtUserName!.text!.isBlank){
            
            self.txtUserName!.errorMessage = err_UserName_Blank
            self.txtUserName!.errorColor = CustomColor.redColor
            return false
        }
        if(self.txtUserName!.text!.characters.count < 3 ){
            self.txtUserName!.errorColor = CustomColor.redColor
            self.txtUserName!.errorMessage = err_UserName_Length
            return false
        }
        if(self.txtEmail!.text!.isBlank){
            
            self.txtEmail!.errorMessage = err_Email_Blank
            self.txtEmail!.errorColor = CustomColor.redColor
            return false
        }
      
        if(!self.txtEmail!.text!.isEmail)
        {
            self.txtEmail!.errorColor = CustomColor.redColor
            self.txtEmail!.errorMessage = err_valid_mail

            return false
        }
        if(self.txtPhoneNumber!.text!.isBlank){
            
            self.txtPhoneNumber!.errorMessage = err_phoneNumber_Blank
            self.txtPhoneNumber!.errorColor = CustomColor.redColor
            return false
        }
        if(self.txtPhoneNumber!.text!.characters.count < 9 ){
            self.txtPhoneNumber!.errorColor = CustomColor.redColor
            self.txtPhoneNumber!.errorMessage = err_phone_Length
            return false
        }
        if(self.txtPhoneNumber!.text!.characters.count > 14 ){
            self.txtPhoneNumber!.errorColor = CustomColor.redColor
            self.txtPhoneNumber!.errorMessage = err_phone_Max_Length
            return false
        }
        if(self.txtPassword!.text!.isBlank){
            //self.makeToast(txt_Enter_Password)
            self.txtPassword!.errorColor = CustomColor.redColor
            self.txtPassword!.errorMessage = err_Enter_Password
            return false
        }
        if(self.txtPassword!.text!.characters.count < 6 ){
            self.txtPassword!.errorColor = CustomColor.redColor
            self.txtPassword!.errorMessage = err_Password_Length           // makeToast(txt_Count_Password)
            return false
        }
        if(self.txtConfirmPassword!.text!.isBlank){
            
            self.txtConfirmPassword!.errorMessage = err_Enter_Confirm_Password
            self.txtConfirmPassword!.errorColor = CustomColor.redColor
            return false
        }
        if(self.txtPassword!.text! != self.txtConfirmPassword!.text!){
            
            self.txtConfirmPassword!.errorMessage = err_Confirm_Password_missmatch
            self.txtConfirmPassword!.errorColor = CustomColor.redColor
            return false
        }
        return  true
    }
}
extension SignUpPersonalDetailsVC:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let field = textField as! SkyFloatingLabelTextField
        field.errorMessage = ""
        field.errorColor = .clear
        return true
    }
}

