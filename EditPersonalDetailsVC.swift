//
//  EditPersonalDetailsVC.swift
//  QuickLearn
//
//  Created by Xtreem Solution on 27/02/19.
//  Copyright © 2019 XtreemSolution. All rights reserved.
//

import UIKit

class EditPersonalDetailsVC: BaseViewController {

    @IBOutlet weak var txtName: SkyFloatingLabelTextField?
    @IBOutlet weak var txtUserName: SkyFloatingLabelTextField?
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField?
    @IBOutlet weak var txtPhoneNumber: SkyFloatingLabelTextField?
    @IBOutlet weak var txtPassword: SkyFloatingLabelTextField?
    @IBOutlet weak var txtConfirmPassword: SkyFloatingLabelTextField?
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.txtName?.delegate = self
        self.txtUserName?.delegate = self
        self.txtEmail?.delegate = self
        self.txtPhoneNumber?.delegate = self
        self.txtPassword?.delegate = self
        self.txtConfirmPassword?.delegate = self
        
        self.setProfileData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //To Show Navigation controller
        self.showNavigationBar()
        self.setTitle(lblTitle: "Personal Details")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.setTitle(lblTitle: "Personal Details")
    }
    
    // MARK: -  IBActions 
    
    @IBAction func btnSave_didSelect(_ sender: Any) {
        if self.checkValidation(){
            self.callApiToUpdate()
        }
    }
    @IBAction func btnCancel_didSelect(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    func setProfileData() {
        // UserLoginData.shared.picture_url
//        self.txtEmail!.isUserInteractionEnabled = false
        self.txtName!.text = MyProfileDetails.shared.name
        self.txtEmail!.text = MyProfileDetails.shared.email
        self.txtUserName!.text = MyProfileDetails.shared.username//ConstantKeys.euro_sign + MyProfileDetails.shared.hourly_rate
        self.txtPhoneNumber!.text = MyProfileDetails.shared.contact_number
    }
    
    

    // MARK: -  Custom Methods 
    
    func callApiToUpdate() {
        self.hudShow()
        var userInfo = [String : Any]()
        userInfo["name"] = self.txtName!.text
        userInfo["username"] = self.txtUserName!.text
        userInfo["contact_number"] = self.txtPhoneNumber!.text
        userInfo["email"] = self.txtEmail!.text
        userInfo["update_step"] = "One"
        ServiceClass.sharedInstance.hitServiceToUpdateProfile(userInfo,  completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
            self.hudHide()
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                if(parseData["status"].stringValue == "success") {
                    AppHelper.showALertWithTag(0, title: "Alert", message: parseData["message"].string!, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
                    self.navigationController?.popViewController(animated: true)
                }
            }else {
                
                AppHelper.showALertWithTag(0, title: "Alert", message: (errorDict?[ServiceKeys.keyErrorMessage] as? String)!, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            }
        })
        
    }
    
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
        return  true
    }

    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}
extension EditPersonalDetailsVC:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let field = textField as! SkyFloatingLabelTextField
        field.errorMessage = ""
        field.errorColor = .clear
        return true
    }
}
