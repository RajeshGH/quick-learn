//
//  ContactUsVC.swift
//  QuickLearn
//
//  Created by Xtreem Solution on 22/02/19.
//  Copyright © 2019 XtreemSolution. All rights reserved.
//

import UIKit

class ContactUsVC: BaseViewController {

    
    @IBOutlet weak var txtName: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txtPhone: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var txtViewMessage: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
        
        self.setProfileData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //To Show Navigation controller
        self.showNavigationBar()
        self.setTitle(lblTitle: "Contact Us")
        
        self.txtViewMessage.delegate = self
        self.txtViewMessage.text = "Please write here..."
        self.txtViewMessage.textColor = .lightGray
        self.txtViewMessage.layer.cornerRadius = 5
        self.txtViewMessage.layer.borderWidth = 1
        self.txtViewMessage.layer.borderColor = UIColor(red: 206.0/255.0, green: 206.0/255.0, blue: 206.0/255.0, alpha: 1).cgColor
        self.txtViewMessage.layer.masksToBounds = true
        
        self.txtName.delegate = self
        self.txtPhone.delegate = self
        self.txtEmail.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.setTitle(lblTitle: "Contact Us")
    }
    
    // MARK: -  IBActions 
    @IBAction func btnSubmit_didSelect(_ sender: Any) {
       if self.checkValidation(){
            self.callApiToContactUs()
        }
    }
    
    // MARK: -  Custom Methods 
    
    func setProfileData() {
        // UserLoginData.shared.picture_url
        self.txtName.text = MyProfileDetails.shared.name
        self.txtEmail.text = MyProfileDetails.shared.email
        self.txtPhone.text = MyProfileDetails.shared.contact_number
    }
    
    func callApiToContactUs() {
        var userInfo = [String : Any]()
        userInfo["name"] = self.txtName!.text
        userInfo["email"] = self.txtEmail.text
        userInfo["phone_number"] = self.txtPhone.text
        userInfo["message"] = self.txtViewMessage.text
        self.hudShow()
        
        ServiceClass.sharedInstance.hitServiceForContactUs(userInfo,  completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
            self.hudHide()
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                //AppHelper.showALertWithTag(0, title: "Alert", message: parseData["message"].string!, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "thanksVC") as? ThanksVC
                self.present(vc!, animated: true, completion: nil)
               // self.navigationController?.popViewController(animated: true)
            }else {
                    AppHelper.showALertWithTag(0, title: "Alert", message: (errorDict?[ServiceKeys.keyErrorMessage] as? String)!, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
                }
        })
    }
    
    func checkValidation() -> Bool {
        self.view.endEditing(true)
        if(self.txtName!.text!.isBlank){
            self.txtName!.errorColor = CustomColor.redColor
            self.txtName!.errorMessage = err_Name_Blank
            return false
        }
        if(self.txtPhone!.text!.isBlank){
            self.txtPhone!.errorColor = CustomColor.redColor
            self.txtPhone!.errorMessage = err_phoneNumber_Blank
            return false
        }
        if(self.txtEmail!.text!.isBlank){
            self.txtEmail!.errorMessage = err_Email_Blank
            self.txtEmail!.errorColor = CustomColor.redColor
            return false
        }
        if(!self.txtEmail!.text!.isEmail){
            self.txtEmail!.errorColor = CustomColor.redColor
            self.txtEmail!.errorMessage = err_valid_mail
            
            return false
        }
        if(self.txtViewMessage!.text!.isBlank || self.txtViewMessage.text == "Please write here..."){
            AppHelper.showALertWithTag(0, title: "Alert", message: err_message, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            return false
        }
        return  true
    }

}
// MARK:- TextField Delegtes
extension ContactUsVC:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let field = textField as! SkyFloatingLabelTextField
        field.errorMessage = ""
        field.errorColor = .clear
        return true
    }
}

// MARK:- TextView Delegtes
extension ContactUsVC : UITextViewDelegate {
func textViewDidBeginEditing(_ textView: UITextView)
{
    if textView.textColor == .lightGray
    {
        textView.text = nil
        textView.textColor = .black
        
    }
}

func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    
    // Combine the textView text and the replacement text to
    // create the updated text string
    let currentText = textView.text!
    
    let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
    // If updated text view will be empty, add the placeholder
    // and set the cursor to the beginning of the text view
    if (updatedText.isEmpty) {
        
        textView.text = "Please write here..."
        textView.textColor = UIColor.lightGray
        
        textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        return false
    }
        
        // Else if the text view's placeholder is showing and the
        // length of the replacement string is greater than 0, clear
        // the text view and set its color to black to prepare for
        // the user's entry
    else if textView.textColor == .lightGray && !text.isEmpty {
        textView.text = nil
        textView.textColor = .black
    }
    
    return true
}

func textViewDidEndEditing(_ textView: UITextView)
{
    if textView.text.isEmpty {
        textView.text = "Please write here..."
        textView.textColor = UIColor.lightGray
    }
}
}
