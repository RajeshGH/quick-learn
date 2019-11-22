//
//  EditPaymentDetailsVC.swift
//  QuickLearn
//
//  Created by Xtreem Solution on 27/02/19.
//  Copyright © 2019 XtreemSolution. All rights reserved.
//

import UIKit

class EditPaymentDetailsVC: BaseViewController {
    @IBOutlet weak var txtRate: SkyFloatingLabelTextField?
   
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        self.txtRate?.delegate = self
        self.setProfileData()
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
    @IBAction func btnSave_didSelect(_ sender: Any) {
        if self.checkValidation(){
            self.callApiToUpdatePaymentDetails()
        }
    }
    @IBAction func btnCancel_didSelect(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: -  Custom Methods 
    
    func setProfileData() {
        // UserLoginData.shared.picture_url
        self.txtRate!.text = MyProfileDetails.shared.hourly_rate
    }
    
    func callApiToUpdatePaymentDetails() {
        self.hudShow()
        var userInfo = [String : Any]()
        userInfo["hourly_rate"] = self.txtRate!.text
        userInfo["update_step"] = "Three"
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
        
        if(self.txtRate!.text!.isBlank){
            
            self.txtRate!.errorMessage = err_rate_blank
            self.txtRate!.errorColor = CustomColor.redColor
            return false
        }
        return  true
    }
}
extension EditPaymentDetailsVC:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let field = textField as! SkyFloatingLabelTextField
        field.errorMessage = ""
        field.errorColor = .clear
        return true
    }
}
