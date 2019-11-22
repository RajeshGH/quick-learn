//
//  ProfileTabVC.swift
//  QuickLearn
//
//  Created by Xtreem Solution on 21/02/19.
//  Copyright © 2019 XtreemSolution. All rights reserved.
//

import UIKit

class ProfileTabVC: BaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var viewProfilePhoto: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var viewRating: UIView!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var btnRating: UIButton!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblHourlyRate: UILabel!
    var isFromImageUpdate:Bool = false
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let objSearch = SearchTabVC()
        
        objSearch.setProfileDataa() { (nam, agg) -> String in
            let name = nam
            let age = agg
            print("Name = \(name) and age = \(age)")
            return name
        }
        // Do any additional setup after loading the view.
        // To set UI of screen
        self.hideNavigationBar()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
     //   self.lblHourlyRate.text = ConstantKeys.euro_sign + "20"
        self.imgProfile.cornerRadius = self.imgProfile.frame.height/2
        self.imgProfile.clipsToBounds = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.hideNavigationBar()
       
        self.imgProfile.cornerRadius = self.imgProfile.frame.height/2
        self.imgProfile.clipsToBounds = true
        if self.isFromImageUpdate == false{
             self.callApiToGetProfileDetails()
        }
    }

    // MARK: -  IBActions 
    @IBAction func btnEditPhoto_didSelect(_ sender: Any) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnLogout_didSelect(_ sender: Any) {
        
          let alert = UIAlertController(title: "Alert", message: strLogoutAlert, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Logout", style: .default, handler: { action in
            self.logout()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            print("Click of cancel button")
        }))
        // show the alert
        self.present(alert, animated: true, completion: nil)
     }
    @IBAction func btnRating_didSelect(_ sender: Any) {
        if Reachability.isConnectedToNetwork()
        {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "myRatingVC") as? MyRatingVC
            vc!.strUserName = MyProfileDetails.shared.name
            vc!.strUserId = MyProfileDetails.shared.id
            self.navigationController?.pushViewController(vc!, animated: true)
        }else{
            AppHelper.showALertWithTag(0, title: "Alert", message: "Check your internet connectivity", delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
        }
        
    }
    
    @IBAction func btnPersonalDetail_didSelect(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "editPersonalDetailsVC") as? EditPersonalDetailsVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func btnAcademicDetail_didSelect(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "editAcademicDetailsVC") as? EditAcademicDetailsVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func btnPaymentDetail_didSelect(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "editPaymentDetailsVC") as? EditPaymentDetailsVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func btnWallet_didSelect(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "walletVC") as? WalletVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func btnBookingHistory_didSelect(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "bookingHistoryVC") as? BookingHistoryVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func btnFavourite_didSelect(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "favouriteListVC") as? FavouriteListVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func btnResetPwd_didSelect(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "resetPassword") as? ResetPassword
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func btnContactUs_didSelect(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "contactUsVC") as? ContactUsVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    // #MARK: -  Custom Methods 
    func openCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func callApiToGetProfileDetails(){
        let userInfo = [String : Any]()
        self.hudShow()
        ServiceClass.sharedInstance.hitServiceToGetProfileDetails(userInfo,  completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
            self.hudHide()
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                var dictProfile:NSDictionary = NSDictionary()
                dictProfile = parseData["data"].dictionaryObject! as NSDictionary

                MyProfileDetails.shared.setProfileData(json: dictProfile as! [String : Any])
             //   print("Subject Count =", MyProfileDetails.shared.subject_detail.count)
                self.setProfileData()
            }else {
                
                AppHelper.showALertWithTag(0, title: "Alert", message: (errorDict?[ServiceKeys.keyErrorMessage] as? String)!, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            }
        })
    }

    func setProfileData() {
       // UserLoginData.shared.picture_url
        self.lblName.text = MyProfileDetails.shared.name
        self.lblEmail.text = MyProfileDetails.shared.email
        self.lblHourlyRate.text = ConstantKeys.euro_sign + " " + MyProfileDetails.shared.hourly_rate
       
        let pictureBaseUrl = AppHelper.getStringForKey(ServiceKeys.keyPictureBaseURL)
        let imageUrl = pictureBaseUrl + MyProfileDetails.shared.profile_image
        // Utilities.setImage(url: imageUrl, imageview: self.imgProfile)
        self.imgProfile.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "no_image_available"))
        
        guard let rating = MyProfileDetails.shared.avg_rating else {
            self.lblRating.text = "0.0 "
            return
        }
        self.lblRating.text = rating
    }
    
    func callApiToUpdateProfilePicture(){
        
        var userInfo = [String : Any]()
        self.hudShow()
         userInfo["profile_image"] = ""
        let imageData = self.imgProfile.image!.jpegData(compressionQuality: 0.5)
        ServiceClass.sharedInstance.hitServiceForUpdateProfileImage(userInfo, data: imageData,  completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
            self.hudHide()
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                var dictProfile:NSDictionary = NSDictionary()
                dictProfile = parseData["data"].dictionaryObject! as NSDictionary
                
                MyProfileDetails.shared.setProfileData(json: dictProfile as! [String : Any])
                AppHelper.showALertWithTag(0, title: "Alert", message: parseData["message"].string!, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
                self.callApiToGetProfileDetails()
                self.isFromImageUpdate = false
            }else {
                
               
                let alert = UIAlertController(title: "Alert", message: strImageUploadAlert, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { action in
                    self.callApiToUpdateProfilePicture()
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                    print("Click of cancel button")
                }))
                // show the alert
                self.present(alert, animated: true, completion: nil)
                AppHelper.showALertWithTag(0, title: "Alert", message: (errorDict?[ServiceKeys.keyErrorMessage] as? String)!, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            }
        })
    }
    
    func logout(){
        self.callApiToLogout()
    }
    func callApiToLogout(){
       
        let userInfo = [String : Any]()
        self.hudShow()
        
        ServiceClass.sharedInstance.hitServiceForLogout(userInfo,  completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
            self.hudHide()
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
            
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                if let window = appDelegate.window {
                    let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NavVC") as! UINavigationController
                    window.rootViewController = controller
                    window.makeKeyAndVisible()
                }
                let deviceToken = AppHelper.getStringForKey(ServiceKeys.device_token)
                let imageBaseURL = UserLoginData.shared.picture_url
                // To remove all UserDefaults 
                let domain = Bundle.main.bundleIdentifier!
                UserDefaults.standard.removePersistentDomain(forName: domain)
                UserDefaults.standard.synchronize()
                print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
                
                AppHelper.setStringForKey(deviceToken, key: ServiceKeys.device_token)
                AppHelper.setBoolForKey(false, key: ServiceKeys.KeyAleradyLogin)
                AppHelper.setStringForKey(imageBaseURL, key: ServiceKeys.keyPictureBaseURL)
                
                  AppHelper.showALertWithTag(0, title: "Alert", message: parseData["message"].string!, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            }else {
                
                AppHelper.showALertWithTag(0, title: "Alert", message: (errorDict?[ServiceKeys.keyErrorMessage] as? String)!, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            }
        })
    }
}

extension ProfileTabVC:UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage  = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imgProfile.image = pickedImage
         //   self.imgProfileee = pickedImage
//            if let data = UIImageJPEGRepresentation(imgProfile.image!, 0.25) {
//              let  str3 =  (data as AnyObject).base64EncodedString(options: .lineLength64Characters)
//            }
            self.isFromImageUpdate = true
            self.callApiToUpdateProfilePicture()
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

