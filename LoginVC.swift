//
//  LoginVC.swift
//  QuickLearn
//
//  Created by Xtreem Solution on 19/02/19.
//  Copyright © 2019 XtreemSolution. All rights reserved.
//

import UIKit
import LocalAuthentication
class LoginVC: BaseViewController {

    // IBOutlets
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField?
    @IBOutlet weak var txtPassword: SkyFloatingLabelTextField?
    
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var btnCreateAcc: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // To set UI of page
        self.btnSignIn.setCornerRadius(button: self.btnSignIn, cornerRadius: 5)
        // Do any additional setup after loading the view.
        self.txtEmail?.delegate = self
        self.txtPassword?.delegate = self
        
        // For testing
//        self.txtEmail?.text = "rahulkumar@mailinator.com"
//        self.txtPassword?.text = "123456"

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // To hide Navigation bar
        self.hideNavigationBar()
    }
    // MARK: -  IBActions 
    @IBAction func btnSignIn_didSelect(_ sender: Any) {
        
       // self.authenticateUserTouchID()
        if checkValidation(){
            callApiToLogin()
        }
    }
    
    @IBAction func btnForgotPassword_didSelect(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "forgotPasswordVC") as? ForgotPasswordVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func btnCreateAcc_didSelect(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "signUpPersonalDetailsVC") as? SignUpPersonalDetailsVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    // MARK: -  Custom Methods 
    // To authenticate fingerprient
    
    func authenticateUserTouchID() {
        let context : LAContext = LAContext()
        // Declare a NSError variable.
        let myLocalizedReasonString = "Authentication is needed to access your Home ViewController."
        var authError: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) {
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: myLocalizedReasonString) { success, evaluateError in
                if success // IF TOUCH ID AUTHENTICATION IS SUCCESSFUL, NAVIGATE TO NEXT VIEW CONTROLLER
                {
                    DispatchQueue.main.async{
                        print("Authentication success by the system")
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        if let window = appDelegate.window {
                            let controller = self.storyboard?.instantiateViewController(withIdentifier: "tabBarVC") as! TabBarVC
                            window.rootViewController = controller
                            window.makeKeyAndVisible()
                        }
                    }
                }
                else // IF TOUCH ID AUTHENTICATION IS FAILED, PRINT ERROR MSG
                {
                    if let error = authError {
                        let message = self.showErrorMessageForLAErrorCode(errorCode: error.code)
                        print(message)
                    }
                }
            }
        }
    }
    
    func showErrorMessageForLAErrorCode( errorCode:Int ) -> String{
        
        var message = ""
        
        switch errorCode {
            
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.biometryLockout.rawValue:
            message = "Too many failed attempts."
            
        case LAError.biometryNotAvailable.rawValue:
            message = "TouchID is not available on the device"
            
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = "Did not find error code on LAError object"
        }
        
        return message
        
    }
    
    func callApiToLogin() {
        let deviceToken = AppHelper.getStringForKey(ServiceKeys.device_token)
        var userInfo = [String : Any]()
        userInfo["login_id"] = self.txtEmail!.text
        userInfo["password"] = self.txtPassword!.text
        userInfo["device_token"] = deviceToken
        userInfo["device_type"] = "iOS"
        self.hudShow()
        
        ServiceClass.sharedInstance.hitServiceForLogin(userInfo,  completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
            self.hudHide()
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                var dictProfile:NSDictionary = NSDictionary()
                dictProfile = parseData["data"].dictionaryObject! as NSDictionary
                
                UserLoginData.shared.setData(json: dictProfile as! [String : Any] )
           //     UserProfile.shared.setData(json: self.dictProfile as! [String : Any])
              
                print("User id = ",UserLoginData.shared.id)
                AppHelper.setStringForKey(UserLoginData.shared.token, key: ServiceKeys.keyToken)
                AppHelper.setBoolForKey(true, key: ServiceKeys.KeyAleradyLogin)
                AppHelper.setStringForKey(UserLoginData.shared.picture_url, key: ServiceKeys.keyPictureBaseURL)
                AppHelper.setStringForKey(UserLoginData.shared.available_balance, key: ServiceKeys.available_wallet_balance)

                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                if let window = appDelegate.window {
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "tabBarVC") as! TabBarVC
                    window.rootViewController = controller
                    window.makeKeyAndVisible()
                }
                
               //  AppHelper.showALertWithTag(0, title: "Alert", message: parseData["message"].string!, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            }else {
                
                 AppHelper.showALertWithTag(0, title: "Alert", message: (errorDict?[ServiceKeys.keyErrorMessage] as? String)!, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            }
        })
    }
    
    func checkValidation() -> Bool {
        self.view.endEditing(true)
        
        if(self.txtEmail!.text!.isBlank){
            
            self.txtEmail!.errorMessage = err_Email_UserId_Blank
            self.txtEmail!.errorColor = CustomColor.redColor
            return false
        }
        if(self.txtEmail!.text!.count < 3)
        {
            self.txtEmail!.errorColor = CustomColor.redColor
            self.txtEmail!.errorMessage = err_Email_UserId_valid
            
            return false
        }
        if(self.txtPassword!.text!.isBlank){
            //self.makeToast(txt_Enter_Password)
            self.txtPassword!.errorColor = CustomColor.redColor
            self.txtPassword!.errorMessage = err_Enter_Password
            return false
        }
        if(self.txtPassword!.text!.count < 6 ){
            self.txtPassword!.errorColor = CustomColor.redColor
            self.txtPassword!.errorMessage = err_Password_Length           // makeToast(txt_Count_Password)
            return false
        }
        return  true
    }
}
extension LoginVC:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let field = textField as! SkyFloatingLabelTextField
        field.errorMessage = ""
        field.errorColor = .clear
        return true
    }
}
