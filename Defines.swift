//
//  Defines.swift
//  Panther
//
//  Created by Manish Jangid on 7/27/17.
//  Copyright © 2017 Manish Jangid. All rights reserved.
//

import Foundation
import UIKit




// MARK : GLOBAL Functions
func print_debug <T> (_ object:T)
{
    print(object)
}

let DateFormat_yyyy_mm_dd_hh_mm_ss_sss = "yyyy-MM-dd HH:mm:ss"

let DateFormat_yyyy_mm_dd_hh_mm_ss_0000 = "yyyy-MM-dd HH:mm:ss +0000"
let output_format_HH_mm_ss = "HH:mm:ss  MMM dd yyy"
let appDelegate = UIApplication.shared.delegate as! AppDelegate

struct ConstantKeys {
    static let euro_sign = "\u{00A3}"
}

//MARK:- Service Keys

struct ServiceKeys{
 
    
    static let user_id = "id"
    static let name = "name"
    static let user_name = "username"
    static let keyContactNumber = "contact_number"
    static let keyEmail = "email"
    static let keyToken = "token"
    static let device_token = "device_token"
    static let available_wallet_balance = "available_wallet_balance"
    
    static let KeyAleradyLogin = "is_already_login"
    static let keyNoListAvailable = "No list available"
    static let keyPictureBaseURL = "picture_base_url"
    
    
    static let ischeckForClick = "ischeckForClick"
    static let isCheckForClockOut = "isCheckForClockOut"
     static let userIntrectionCheck =  "userIntrectionCheck"
    
    static let dateFormat = "date_formate"
    static let timeFormat = "time_formate"
    
    
    static let keyUserName = "user_name"
    //static let name = "name"
     static let key_employee_id = "employee_id"
         static let key_post = "post"
   
    static let profile_image = "profile_image"
    
    static let keyProfileImage = "image_url"
   
    static let keyErrorCode = "errorCode"
    static let keyErrorMessage = "errMessage"
    static let keyUserType = "user_type"
    
   
    
   
    static let keyContactEmail = "email"
    static let keyContactPhoneNumber = "phone_number"
      static let keyContactZip = "zip_code"
     static let keyContactDealer_id = "dealer_id"
    
  
    static let keyStatus =  "status"
    static let KeyAccountName = "account_name"
   
    static let address = "address"
   
    static let KeyPushNotificationDeviceToken = "KeyPushNotificationDeviceToken"
    static let KeyCarComparison = "KeyCarComparison"
    static let KeyCarFavourite = "KeyCarFavourite"
    static let KeyImageSlider = "KeyImageSlider"
    static let KeyImageSliderID = "KeyImageSliderID"
}

struct ServiceUrls
{
   // static let baseUrl = "http://192.168.1.61/qwik_learn/api/"

  // static let baseUrl = "http://xsdemo.com/qwiklearn/api/"
    static let baseUrl = "https://www.qwiklern.com/api/"

    static let signUp = "register/register"
 
    static let logIn = "users/login"
    static let logout = "users/logout"
    static let forgot_password = "users/forgot_password"
    static let change_password = "register/changePassword"
    static let contact_us = "contact_us/contact_us_form"
    static let get_my_profile = "users/profile"
    static let get_tutor_list = "users/tutor_list"
    static let get_wallet_history = "users/user_wallet_history"
    static let add_amount_in_wallet = "users/add_wallet_amount"
    static let withdraw_wallet_amount = "users/withdraw_wallet_amount"
    static let get_profile_details = "users/profile_detail"
    
    static let get_schoolName_List = "schools/school_list"
    static let get_UniversityName_List = "university/university_list"
    static let get_subjectName_List = "subject/subject_list"
    
    static let update_profile = "register/updateProfile"
    static let update_profile_image = "register/updateProfileImage"
    static let reuest_tutor = "tutors/send_tutor_request"
    
    static let get_received_request_list = "tutors/received_request"
    static let get_send_request_list = "tutors/send_request"
    
    static let get_received_upcoming_list = "tutors/upcoming_received_request"
    static let get_send_upcoming_list = "tutors/upcoming_send_request"
    static let set_requst_complete = "tutors/complete_job"
    static let submit_rating = "rating/submit_rating"
    static let get_rating_list = "rating/user_rating_list"
    static let get_favourite_list = "user_favourite/favourite_list"
    static let set_user_favourite_unfavourite = "user_favourite/favourite_user"
    static let request_accept_reject = "tutors/request_action"
    static let cancel_sent_reject = "tutors/cancel_request"
    
    static let get_sent_history = "tutors/send_history"
    static let get_received_history = "tutors/received_history"
    
    static let terms_and_condition = "content/getStaticContent"
//    static let get_new_car = "car/get_new_car"
//    static let get_electric_cars = "car/get_electric_cars"
//    static let get_type_detail = "car/get_type_detail"
    static let get_type_images = "car/get_type_images"
//    static let get_manufacturer = "car/get_manufacturer"
//    static let get_model = "car/get_model"
//    static let get_types = "car/get_types"
//    static let getFavouriteCars = "car/getFavouriteCars"
//    static let get_car_comparison = "car/get_car_comparison"
//    static let get_car_slider = "car/get_car_slider"
//    static let get_concept_cars = "car/get_concept_cars"
//    static let ask_me = "car/ask_me"
//    static let body_design = "car/body_design"
//    static let car_configuration = "car/car_configuration_one"
//    static let fuel_list = "car/fuel_list"
//    static let transmission_list = "car/transmission_list"
//    static let get_configuration_manufacturer = "car/get_configuration_manufacturer"
//    static let get_configuration_youngtimer = "car/get_configuration_youngtimer"
//    static let getMaxKwAndPs = "car/getMaxKwAndPs"
}
struct ErrorCodes
{
    static let    errorCodeInternetProblem = -1 //Unable to update use
    
    static let    errorCodeSuccess = 1 // 'Process successfully.'
    static let    errorCodeFailed = 2 // 'Process failed.
}


struct CustomColor{
        
    static let appThemeTopColor = UIColor(red: 93.0/255.0, green: 75.0/255.0, blue: 229.0/255.0, alpha: 1)
    static let appThemeBottomColor = UIColor(red: 114.0/255.0, green: 76.0/255.0, blue: 221.0/255.0, alpha: 1.0)
    
    static let borderThemeColor = UIColor(red: 107.0/255.0, green: 75.0/255.0, blue: 224.0/255.0, alpha: 1.0)
    static let borderGrayColor = UIColor(red: 194.0/255.0, green: 192.0/255.0, blue: 192.0/255.0, alpha: 1.0)
    
    static let greenColor = UIColor(red: 42.0/255.0, green: 154.0/255.0, blue: 16.0/255.0, alpha: 1.0)
    //    static let menuselectedColor = UIColor(red: 66.0/255.0, green: 66.0/255.0, blue: 66.0/255.0, alpha: 0.8)
    static let redColor = UIColor(red: 139.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    
    static let lightGrayColor = UIColor(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1.0)
    
    static let yellowColor = UIColor(red: 255.0/255.0, green: 162.0/255.0, blue: 15.0/255.0, alpha: 1.0)
//    static let menuselectedColor = UIColor.lightGray
//    static let blackThemeColor = UIColor(red: 88.0/255.0, green: 88.0/255.0, blue: 88.0/255.0, alpha: 1.0)
//    //static let borderThemeColor = UIColor(red: 88.0/255.0, green: 88.0/255.0, blue: 88.0/255.0, alpha: 0.5)
//    static let blackBgColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.8)
//    static let appThemeColor = UIColor(red: 255.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
//    static let appThemeColorAlpha = UIColor(red: 133.0/255.0, green: 28.0/255.0, blue: 60.0/255.0, alpha: 0.2)
//    static let darkTextColorTheme = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)
//    static let text_Color_White = UIColor.white
//       static let nav_color = UIColor.white
//static let appThemeColorAlpha2 = UIColor(red: 132.0/255.0, green: 28.0/255.0, blue: 31.0/255.0, alpha: 0.6)
    
}


struct CustomFont {
    static let boldfont13 = UIFont(name: "Montserrat-Bold", size: 13)!
    static let boldfont18 =  UIFont(name: "Montserrat-Bold", size: 18)!
    
}






