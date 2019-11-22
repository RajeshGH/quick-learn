//
//  WithdrawAmountVC.swift
//  QuickLearn
//
//  Created by Xtreem Solution on 20/03/19.
//  Copyright © 2019 XtreemSolution. All rights reserved.
//

import UIKit

class WithdrawAmountVC: BaseViewController {

    @IBOutlet weak var txtAmount: SkyFloatingLabelTextField?
    @IBOutlet weak var txtViewComment: UITextView!

    
    var arrTutors = [String]()
    var tutorList:Array = [TutorList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // To set UI of screen
        self.txtAmount?.delegate = self
        self.txtViewComment!.delegate = self
        self.txtViewComment!.text = "Please write your comment here..."
        self.txtViewComment!.textColor = .lightGray
        self.txtViewComment!.layer.cornerRadius = 5
        self.txtViewComment!.layer.borderWidth = 1
        self.txtViewComment!.layer.borderColor = UIColor(red: 206.0/255.0, green: 206.0/255.0, blue: 206.0/255.0, alpha: 1).cgColor
        self.txtViewComment!.layer.masksToBounds = true
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //To Show Navigation controller
        self.showNavigationBar()
        self.setTitle(lblTitle: "Withdraw Amount")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.setTitle(lblTitle: "Withdraw Amount")
    }
    
    // MARK: -  IBActions 
    
    @IBAction func btnWithdraw_didSelect(_ sender: Any) {
        if self.checkValidation() == true{
            self.callApiToWithdrawAmount()
        }
    }
    // MARK: -  Custom Methods 
    func callApiToWithdrawAmount(){
        self.hudShow()
        var userInfo = [String : Any]()
        userInfo["amount"] = self.txtAmount!.text
        userInfo["comment"] = self.txtViewComment.text
        
        ServiceClass.sharedInstance.hitServiceToWithdrawWalletAmount(userInfo,  completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
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
        
        if(self.txtAmount!.text!.isBlank){
            self.txtAmount!.errorMessage = err_amount_Blank
            self.txtAmount!.errorColor = CustomColor.redColor
            return false
        }
        if(self.txtViewComment!.text!.isBlank || self.txtViewComment!.text == "Please write your comment here..."){
            AppHelper.showALertWithTag(0, title: "Alert", message: err_comment_blank, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            return false
        }
        let availableBalance:Double = Double(AppHelper.getStringForKey(ServiceKeys.available_wallet_balance))!
        let requestAmount:Double = Double((self.txtAmount?.text)!)!
        if Double(availableBalance) < Double(requestAmount){
            AppHelper.showALertWithTag(0, title: "Alert", message: strHighWithdrawBalanceAlert, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            return false
        }
        return  true
    }
    
    //  Disable all option (copy, paste, delete.....etc)
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}

// MARK:- TextView Delegtes
extension WithdrawAmountVC : UITextViewDelegate {
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
            
            textView.text = "Please write your comment here..."
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
            textView.text = "Please write your comment here..."
            textView.textColor = UIColor.lightGray
        }
    }
}
extension WithdrawAmountVC:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let field = textField as! SkyFloatingLabelTextField
        field.errorMessage = ""
        field.errorColor = .clear
        
        //Only allow numbers. No Copy-Paste text values.
       
        
        var allowedCharacterSet :CharacterSet?
        if textField.text!.count > 0{
            if textField.text!.contains(".") && string == "."{
                allowedCharacterSet = CharacterSet.init(charactersIn: "0123456789")
            }else{
                allowedCharacterSet = CharacterSet.init(charactersIn: "0123456789.")
            }
            
        }else{
           allowedCharacterSet = CharacterSet.init(charactersIn: "0123456789")
        }
        let textCharacterSet = CharacterSet.init(charactersIn: textField.text! + string)
        if !allowedCharacterSet!.isSuperset(of: textCharacterSet) {
            return false
        }
        
        return true
    }
}
