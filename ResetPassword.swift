//
//  ResetPassword.swift
//  QuickLearn
//
//  Created by Xtreem Solution on 22/02/19.
//  Copyright © 2019 XtreemSolution. All rights reserved.
//

import UIKit
class ResetPassword: BaseViewController {

    @IBOutlet weak var txtCurrentPwd: SkyFloatingLabelTextField!
    @IBOutlet weak var txtNewPwd: SkyFloatingLabelTextField!
    @IBOutlet weak var txtConfirmPwd: SkyFloatingLabelTextField!
    @IBOutlet weak var btnUpdate: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.txtCurrentPwd.delegate = self
        self.txtNewPwd.delegate = self
        self.txtConfirmPwd.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //To Show Navigation controller
        self.showNavigationBar()
        self.setTitle(lblTitle: "Reset Password")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.setTitle(lblTitle: "Reset Password")
    }
// MARK: -  IBActions 
    @IBAction func btnUpdate_didSelect(_ sender: Any) {
        if self.checkValidation(){
            self.callApiToResetPassword()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: -  Custom Methods 
    func callApiToResetPassword() {
        var userInfo = [String : Any]()
        userInfo["password"] = self.txtCurrentPwd!.text
        userInfo["new_password"] = self.txtNewPwd!.text
        self.hudShow()
        
        ServiceClass.sharedInstance.hitServiceForChangePassword(userInfo,  completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
            self.hudHide()
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                AppHelper.showALertWithTag(0, title: "Alert", message: parseData["message"].string!, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
                self.navigationController?.popViewController(animated: true)
            }else {
                
                AppHelper.showALertWithTag(0, title: "Alert", message: (errorDict?[ServiceKeys.keyErrorMessage] as? String)!, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            }
        })
        
    }
    
    
    func checkValidation() -> Bool {
        self.view.endEditing(true)

        if(self.txtCurrentPwd!.text!.isBlank){
            //self.makeToast(txt_Enter_Password)
            self.txtCurrentPwd!.errorColor = CustomColor.redColor
            self.txtCurrentPwd!.errorMessage = err_Enter_Password
            return false
        }
        if(self.txtCurrentPwd!.text!.characters.count < 6 ){
            self.txtCurrentPwd!.errorColor = CustomColor.redColor
            self.txtCurrentPwd!.errorMessage = err_Password_Length           // makeToast(txt_Count_Password)
            return false
        }
        if(self.txtNewPwd!.text!.isBlank){
            
            self.txtNewPwd!.errorMessage = err_Enter_New_Password
            self.txtNewPwd!.errorColor = CustomColor.redColor
            return false
        }
        if(self.txtNewPwd!.text!.characters.count < 6){
            
            self.txtNewPwd!.errorMessage = err_Password_Length
            self.txtNewPwd!.errorColor = CustomColor.redColor
            return false
        }
        if(self.txtConfirmPwd!.text!.isBlank){
            
            self.txtConfirmPwd!.errorMessage = err_Enter_Confirm_Password
            self.txtConfirmPwd!.errorColor = CustomColor.redColor
            return false
        }
        if(self.txtNewPwd!.text! != self.txtConfirmPwd!.text!){
            
            self.txtConfirmPwd!.errorMessage = err_Confirm_Password_missmatch
            self.txtConfirmPwd!.errorColor = CustomColor.redColor
            return false
        }
        
        return  true
    }
}
extension ResetPassword:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let field = textField as! SkyFloatingLabelTextField
        field.errorMessage = ""
        field.errorColor = .clear
        return true
    }
}
