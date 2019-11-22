//
//  ServiceClass.swift
//  TradeInYourLease
//
//  Created by Ajay Vyas on 10/2/17.
//  Copyright © 2017 Ajay Vyas. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class ServiceClass: NSObject {

    static let sharedInstance = ServiceClass()
 
    enum ResponseType : Int {
        case  kResponseTypeFail = 0
        case  kresponseTypeSuccess
    }
    
    typealias completionBlockType = (ResponseType, JSON, AnyObject?) ->Void
    
    //MARK:- Common Get Webservice calling Method using SwiftyJSON and Alamofire
    func hitServiceWithUrlString( urlString:String, parameters:[String:AnyObject],headers:HTTPHeaders,completion:@escaping completionBlockType)
    {
        if Reachability.isConnectedToNetwork()
        {
            print(headers)
            Alamofire.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers : headers)
                .responseJSON { response in
                    
                    guard case .success(let rawJSON) = response.result else {
                        print("SomeThing wrong")
                        
                        var errorDict:[String:Any] = [String:Any]()
                        errorDict[ServiceKeys.keyErrorCode] = ErrorCodes.errorCodeFailed
                        errorDict[ServiceKeys.keyErrorMessage] = "SomeThing wrong"
                        completion(ResponseType.kResponseTypeFail,[],errorDict as AnyObject);
                        
                        return
                    }
                    if rawJSON is [String: Any] {
                        
                        let json = JSON(rawJSON)
                        print(json)
                        if  json["status"] == "error"{
                            var errorDict:[String:Any] = [String:Any]()
                            
//                            errorDict[ServiceKeys.keyErrorCode] = ErrorCodes.errorCodeFailed
//                            errorDict[ServiceKeys.keyErrorMessage] = json["error"].stringValue
                            errorDict[ServiceKeys.keyErrorCode] = ErrorCodes.errorCodeFailed
                            errorDict[ServiceKeys.keyErrorMessage] = json["message"].stringValue
                            print(json["error_code"].stringValue)
                            
                            
                            if json["error_code"].stringValue == "delete_user"{
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                               //tr MBProgressHUD.hide(for: self, animated: true)
                                appDelegate.logoutAlert(message: json["message"].stringValue)
                                
                            }else if json["error_code"].stringValue == "inactive_user"{
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                //tr MBProgressHUD.hide(for: self, animated: true)
                                appDelegate.logoutAlert(message: json["message"].stringValue)
                            }else {
                                completion(ResponseType.kResponseTypeFail,[],errorDict as AnyObject);
                            }
                        }
                        else {
                            completion(ResponseType.kresponseTypeSuccess,json,nil)
                        }
                    }
            }
        }
        else {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let errorDict = NSMutableDictionary()
                errorDict.setObject(ErrorCodes.errorCodeInternetProblem, forKey: ServiceKeys.keyErrorCode as NSCopying)
                errorDict.setObject("Check your internet connectivity", forKey: ServiceKeys.keyErrorMessage as NSCopying)
                completion(ResponseType.kResponseTypeFail,[],errorDict as NSDictionary)
            }
            
        }
        
    }
    func hitGetServiceWithUrlString( urlString:String, parameters:[String:Any],headers:HTTPHeaders,completion:@escaping completionBlockType)
    {
        if Reachability.isConnectedToNetwork()
        {
            let updatedUrl = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            let url = URL(string: updatedUrl!)!
            
            Alamofire.request(url, method: .get , encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                
                guard case .success(let rawJSON) = response.result else {
                    print("SomeThing wrong")
                    
                    print(response.result)
                    
                    var errorDict:[String:Any] = [String:Any]()
                    errorDict[ServiceKeys.keyErrorCode] = ErrorCodes.errorCodeFailed
                    errorDict[ServiceKeys.keyErrorMessage] = "SomeThing wrong"
                    
                    completion(ResponseType.kResponseTypeFail,[],errorDict as AnyObject);
                    
                    return
                }
                if rawJSON is [Any] {
                    
                    let json = JSON(rawJSON)
                    
                    if  json["status"] == "error"{
                        var errorDict:[String:Any] = [String:Any]()
                        
                        errorDict[ServiceKeys.keyErrorCode] = ErrorCodes.errorCodeFailed
                        errorDict[ServiceKeys.keyErrorMessage] = json["error"].stringValue
                        
                        completion(ResponseType.kResponseTypeFail,[],errorDict as AnyObject);
                    }
                    else {
                        completion(ResponseType.kresponseTypeSuccess,json,nil)
                    }
                }
                if rawJSON is [String : Any] {
                    
                    let json = JSON(rawJSON)
                    
                    if  json["status"] == "error"{
                        var errorDict:[String:Any] = [String:Any]()
                        print(json)
                        
                        errorDict[ServiceKeys.keyErrorCode] = ErrorCodes.errorCodeFailed
                        errorDict[ServiceKeys.keyErrorMessage] = json["message"].stringValue
                        if json["error_code"].stringValue == "delete_user"{
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                            SVProgressHUD.dismiss()
//                            appDelegate.logoutAlert(message: json["message"].stringValue)
                            
                        }else if json["error_code"].stringValue == "inactive_user"{
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            //tr MBProgressHUD.hide(for: self, animated: true)
                            appDelegate.logoutAlert(message: json["message"].stringValue)
                        }
                        else {
                            completion(ResponseType.kResponseTypeFail,[],errorDict as AnyObject);
                        }
                        
                    }
                    else {
                        completion(ResponseType.kresponseTypeSuccess,json,nil)
                    }
                }
            }
        }
            
        else  {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            let errorDict = NSMutableDictionary()
            errorDict.setObject(ErrorCodes.errorCodeInternetProblem, forKey: ServiceKeys.keyErrorCode as NSCopying)
            errorDict.setObject("Check your internet connectivity", forKey: ServiceKeys.keyErrorMessage as NSCopying)
            completion(ResponseType.kResponseTypeFail,[],errorDict as NSDictionary)
            
        }
        }
    }
    func imageUpload(_ urlString:String, params:[String : Any],data : Data,imageKey:String,headers:HTTPHeaders, completion:@escaping completionBlockType){
        
        if Reachability.isConnectedToNetwork()
        {
        print(urlString)
        print(params)
        Alamofire.upload(multipartFormData:{ multipartFormData in
            multipartFormData.append(data , withName: imageKey, fileName: "imageKey.jpg", mimeType: "image/jpg")
            
            for (key, value) in params {
                // let str = "\(value)"
                //multipartFormData.append(((str as AnyObject).data(using: String.Encoding.utf8.rawValue)!), withName: key)
                if let val = value as? Bool{
                    var str = "Yes"
                    if val {
                        multipartFormData.append(((str as AnyObject).data(using: String.Encoding.utf8.rawValue)!), withName: key)
                    }
                    else {
                        str = "No"
                        multipartFormData.append(((str as AnyObject).data(using: String.Encoding.utf8.rawValue)!), withName: key)
                    }
                }
                else {
                    let str = "\(value)"
                    multipartFormData.append(((str as AnyObject).data(using: String.Encoding.utf8.rawValue)!), withName: key)
                }
            }
        },
                         usingThreshold:UInt64.init(), to:urlString,method:.post,headers:headers,
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.responseJSON { response in
                                    
                                    guard case .success(let rawJSON) = response.result else {
                                        var errorDict:[String:Any] = [String:Any]()
                                        errorDict[ServiceKeys.keyErrorCode] = ErrorCodes.errorCodeFailed
                                        errorDict[ServiceKeys.keyErrorMessage] = "SomeThing wrong"
                                        
                                        completion(ResponseType.kResponseTypeFail,[],errorDict as AnyObject);
                                        
                                        return
                                    }
                                    print(rawJSON)
                                    if rawJSON is [String: Any] {
                                        
                                        let json = JSON(rawJSON)
                                        
                                        if json["status"] == "error"{
                                            var errorDict:[String:Any] = [String:Any]()
                                            
                                            errorDict[ServiceKeys.keyErrorCode] = ErrorCodes.errorCodeFailed
                                            errorDict[ServiceKeys.keyErrorMessage] = json["message"].stringValue
                                            
                                            completion(ResponseType.kResponseTypeFail,[],errorDict as AnyObject);
                                        }
                                        else {
                                            completion(ResponseType.kresponseTypeSuccess,json,nil)
                                        }
                                    }
                                    
                                }
                            case .failure(let encodingError):
                                print(encodingError)
                            }
        })
        }
            
        else  {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                
                let errorDict = NSMutableDictionary()
                errorDict.setObject(ErrorCodes.errorCodeInternetProblem, forKey: ServiceKeys.keyErrorCode as NSCopying)
                errorDict.setObject("Check your internet connectivity", forKey: ServiceKeys.keyErrorMessage as NSCopying)
                completion(ResponseType.kResponseTypeFail,[],errorDict as NSDictionary)
                
            }
        }
    }
    
    
    // For SignUp
    func hitServiceForSignUp(_ params:[String : Any], completion:@escaping completionBlockType)
    {
        let baseUrl = "\(ServiceUrls.baseUrl)\(ServiceUrls.signUp)"
        print(baseUrl)
           let headers: HTTPHeaders = [ "Content-Type" : "application/json"]
        print_debug(params)
        self.hitServiceWithUrlString(urlString: baseUrl, parameters: params as [String : AnyObject] , headers: headers, completion: completion)
    }
    
   
    func hitServiceForLogin(_ params:[String : Any], completion:@escaping completionBlockType)
    {
        let baseUrl = "\(ServiceUrls.baseUrl)\(ServiceUrls.logIn)"
        print(baseUrl)
        
        let headers: HTTPHeaders = [:]
        print_debug(params)
        
        self.hitServiceWithUrlString(urlString: baseUrl, parameters: params as [String : AnyObject] , headers: headers, completion: completion)
    }
    
    
    func hitServiceForForgotPassword(_ params:[String : Any], completion:@escaping completionBlockType)
    {
        let baseUrl = "\(ServiceUrls.baseUrl)\(ServiceUrls.forgot_password)"
        print(baseUrl)
        let headers: HTTPHeaders = [ : ]
        print_debug(params)
        self.hitServiceWithUrlString(urlString: baseUrl, parameters: params as [String : AnyObject] , headers: headers, completion: completion)
    }
    
    func hitServiceForChangePassword(_ params:[String : Any], completion:@escaping completionBlockType)
    {
        let baseUrl = "\(ServiceUrls.baseUrl)\(ServiceUrls.change_password)"
        print(baseUrl)
        let headers: HTTPHeaders = [ "token" : AppHelper.getStringForKey(ServiceKeys.keyToken)]
        print_debug(params)
        self.hitServiceWithUrlString(urlString: baseUrl, parameters: params as [String : AnyObject] , headers: headers, completion: completion)
    }
    
    func hitServiceForLogout(_ params:[String : Any], completion:@escaping completionBlockType)
    {
        let baseUrl = "\(ServiceUrls.baseUrl)\(ServiceUrls.logout)"
        print(baseUrl)
        let headers: HTTPHeaders = [ "token" : AppHelper.getStringForKey(ServiceKeys.keyToken)]
        print_debug(params)
        self.hitServiceWithUrlString(urlString: baseUrl, parameters: params as [String : AnyObject] , headers: headers, completion: completion)
    }
    
    func hitServiceForContactUs(_ params:[String : Any], completion:@escaping completionBlockType)
    {
        let baseUrl = "\(ServiceUrls.baseUrl)\(ServiceUrls.contact_us)"
        print(baseUrl)
        let headers: HTTPHeaders = [:]
        print_debug(params)
        self.hitServiceWithUrlString(urlString: baseUrl, parameters: params as [String : AnyObject] , headers: headers, completion: completion)
    }
    
    func hitServiceToGetProfileDetails(_ params:[String : Any], completion:@escaping completionBlockType)
    {
        let baseUrl = "\(ServiceUrls.baseUrl)\(ServiceUrls.get_my_profile)"
        print(baseUrl)
        let headers: HTTPHeaders = [ "token" : AppHelper.getStringForKey(ServiceKeys.keyToken)]
        print_debug(params)
        self.hitServiceWithUrlString(urlString: baseUrl, parameters: params as [String : AnyObject] , headers: headers, completion: completion)
    }
    func hitServiceToGetTutorList(_ params:[String : Any], completion:@escaping completionBlockType)
    {
        let baseUrl = "\(ServiceUrls.baseUrl)\(ServiceUrls.get_tutor_list)"
        print(baseUrl)
        let headers: HTTPHeaders = ["token" : AppHelper.getStringForKey(ServiceKeys.keyToken)]
        print_debug(params)
        self.hitServiceWithUrlString(urlString: baseUrl, parameters: params as [String : AnyObject] , headers: headers, completion: completion)
    }
    
    func hitServiceToUpdateProfile(_ params:[String : Any], completion:@escaping completionBlockType)
    {
        let baseUrl = "\(ServiceUrls.baseUrl)\(ServiceUrls.update_profile)"
        print(baseUrl)
        let headers: HTTPHeaders = ["token" : AppHelper.getStringForKey(ServiceKeys.keyToken)]
        print_debug(params)
        self.hitServiceWithUrlString(urlString: baseUrl, parameters: params as [String : AnyObject] , headers: headers, completion: completion)
    }
    func hitserviceToGetTermsAndConditionData(_ params:[String : Any], completion:@escaping completionBlockType)
    {
        let baseUrl = "\(ServiceUrls.baseUrl)\(ServiceUrls.terms_and_condition)"
        print(baseUrl)
        let headers: HTTPHeaders = [:]
        print_debug(params)
        self.hitServiceWithUrlString(urlString: baseUrl, parameters: params as [String : AnyObject] , headers: headers, completion: completion)
    }
    
    func hitServiceToGetFavouriteTutorList(_ params:[String : Any], completion:@escaping completionBlockType)
    {
        let baseUrl = "\(ServiceUrls.baseUrl)\(ServiceUrls.get_favourite_list)"
        print(baseUrl)
        let headers: HTTPHeaders = ["token" : AppHelper.getStringForKey(ServiceKeys.keyToken)]
        print_debug(params)
        self.hitServiceWithUrlString(urlString: baseUrl, parameters: params as [String : AnyObject] , headers: headers, completion: completion)
    }
    func hitServiceToRequestATutor(_ params:[String : Any], completion:@escaping completionBlockType)
    {
        let baseUrl = "\(ServiceUrls.baseUrl)\(ServiceUrls.reuest_tutor)"
        print(baseUrl)
        let headers: HTTPHeaders = ["token" : AppHelper.getStringForKey(ServiceKeys.keyToken)]
        print_debug(params)
        self.hitServiceWithUrlString(urlString: baseUrl, parameters: params as [String : AnyObject] , headers: headers, completion: completion)
    }
    
    func hitServiceToGetTutorRequestSendList(_ params:[String : Any], completion:@escaping completionBlockType)
    {
        let baseUrl = "\(ServiceUrls.baseUrl)\(ServiceUrls.get_send_request_list)"
        print(baseUrl)
        let headers: HTTPHeaders = ["token" : AppHelper.getStringForKey(ServiceKeys.keyToken)]
        print_debug(params)
        self.hitServiceWithUrlString(urlString: baseUrl, parameters: params as [String : AnyObject] , headers: headers, completion: completion)
    }
    func hitServiceToGetTutorRequestReceivedList(_ params:[String : Any], completion:@escaping completionBlockType)
    {
        let baseUrl = "\(ServiceUrls.baseUrl)\(ServiceUrls.get_received_request_list)"
        print(baseUrl)
        let headers: HTTPHeaders = ["token" : AppHelper.getStringForKey(ServiceKeys.keyToken)]
        print_debug(params)
        self.hitServiceWithUrlString(urlString: baseUrl, parameters: params as [String : AnyObject] , headers: headers, completion: completion)
    }
    
    func hitServiceToGetTutorUpcomingSendList(_ params:[String : Any], completion:@escaping completionBlockType)
    {
        let baseUrl = "\(ServiceUrls.baseUrl)\(ServiceUrls.get_send_upcoming_list)"
        print(baseUrl)
        let headers: HTTPHeaders = ["token" : AppHelper.getStringForKey(ServiceKeys.keyToken)]
        print_debug(params)
        self.hitServiceWithUrlString(urlString: baseUrl, parameters: params as [String : AnyObject] , headers: headers, completion: completion)
    }
    func hitServiceToGetTutorUpcomingReceivedList(_ params:[String : Any], completion:@escaping completionBlockType)
    {
        let baseUrl = "\(ServiceUrls.baseUrl)\(ServiceUrls.get_received_upcoming_list)"
        print(baseUrl)
        let headers: HTTPHeaders = ["token" : AppHelper.getStringForKey(ServiceKeys.keyToken)]
        print_debug(params)
        self.hitServiceWithUrlString(urlString: baseUrl, parameters: params as [String : AnyObject] , headers: headers, completion: completion)
    }
    
    func hitServiceToFavouriteATutor(_ params:[String : Any], completion:@escaping completionBlockType)
    {
        let baseUrl = "\(ServiceUrls.baseUrl)\(ServiceUrls.set_user_favourite_unfavourite)"
        print(baseUrl)
        let headers: HTTPHeaders = ["token" : AppHelper.getStringForKey(ServiceKeys.keyToken)]
        print_debug(params)
        self.hitServiceWithUrlString(urlString: baseUrl, parameters: params as [String : AnyObject] , headers: headers, completion: completion)
    }
    func hitServiceToAcceptOrRejectRequest(_ params:[String : Any], completion:@escaping completionBlockType)
    {
        let baseUrl = "\(ServiceUrls.baseUrl)\(ServiceUrls.request_accept_reject)"
        print(baseUrl)
        let headers: HTTPHeaders = ["token" : AppHelper.getStringForKey(ServiceKeys.keyToken)]
        print_debug(params)
        self.hitServiceWithUrlString(urlString: baseUrl, parameters: params as [String : AnyObject] , headers: headers, completion: completion)
    }
    func hitServiceToCancelSentRequest(_ params:[String : Any], completion:@escaping completionBlockType)
    {
        let baseUrl = "\(ServiceUrls.baseUrl)\(ServiceUrls.cancel_sent_reject)"
        print(baseUrl)
        let headers: HTTPHeaders = ["token" : AppHelper.getStringForKey(ServiceKeys.keyToken)]
        print_debug(params)
        self.hitServiceWithUrlString(urlString: baseUrl, parameters: params as [String : AnyObject] , headers: headers, completion: completion)
    }
    func hitServiceToGetSentRequestHistory(_ params:[String : Any], completion:@escaping completionBlockType)
    {
        let baseUrl = "\(ServiceUrls.baseUrl)\(ServiceUrls.get_sent_history)"
        print(baseUrl)
        let headers: HTTPHeaders = ["token" : AppHelper.getStringForKey(ServiceKeys.keyToken)]
        print_debug(params)
        self.hitServiceWithUrlString(urlString: baseUrl, parameters: params as [String : AnyObject] , headers: headers, completion: completion)
    }
    func hitServiceToGetReceivedRequestHistory(_ params:[String : Any], completion:@escaping completionBlockType)
    {
        let baseUrl = "\(ServiceUrls.baseUrl)\(ServiceUrls.get_received_history)"
        print(baseUrl)
        let headers: HTTPHeaders = ["token" : AppHelper.getStringForKey(ServiceKeys.keyToken)]
        print_debug(params)
        self.hitServiceWithUrlString(urlString: baseUrl, parameters: params as [String : AnyObject] , headers: headers, completion: completion)
    }
    func hitServiceToGetWalletHistory(_ params:[String : Any], completion:@escaping completionBlockType)
    {
        let baseUrl = "\(ServiceUrls.baseUrl)\(ServiceUrls.get_wallet_history)"
        print(baseUrl)
        let headers: HTTPHeaders = ["token" : AppHelper.getStringForKey(ServiceKeys.keyToken)]
        print_debug(params)
        self.hitServiceWithUrlString(urlString: baseUrl, parameters: params as [String : AnyObject] , headers: headers, completion: completion)
    }
    
    func hitServiceToCompleteRequest(_ params:[String : Any], completion:@escaping completionBlockType)
    {
        let baseUrl = "\(ServiceUrls.baseUrl)\(ServiceUrls.set_requst_complete)"
        print(baseUrl)
        let headers: HTTPHeaders = ["token" : AppHelper.getStringForKey(ServiceKeys.keyToken)]
        print_debug(params)
        self.hitServiceWithUrlString(urlString: baseUrl, parameters: params as [String : AnyObject] , headers: headers, completion: completion)
    }
    func hitServiceToGiveRating(_ params:[String : Any], completion:@escaping completionBlockType)
    {
        let baseUrl = "\(ServiceUrls.baseUrl)\(ServiceUrls.submit_rating)"
        print(baseUrl)
        let headers: HTTPHeaders = ["token" : AppHelper.getStringForKey(ServiceKeys.keyToken)]
        print_debug(params)
        self.hitServiceWithUrlString(urlString: baseUrl, parameters: params as [String : AnyObject] , headers: headers, completion: completion)
    }
    func hitServiceToGetTutorRatingList(_ params:[String : Any], completion:@escaping completionBlockType)
    {
        let baseUrl = "\(ServiceUrls.baseUrl)\(ServiceUrls.get_rating_list)"
        print(baseUrl)
        let headers: HTTPHeaders = ["token" : AppHelper.getStringForKey(ServiceKeys.keyToken)]
        print_debug(params)
        self.hitServiceWithUrlString(urlString: baseUrl, parameters: params as [String : AnyObject] , headers: headers, completion: completion)
    }
    func hitServiceToAddAmountInWallet(_ params:[String : Any], completion:@escaping completionBlockType)
    {
        let baseUrl = "\(ServiceUrls.baseUrl)\(ServiceUrls.add_amount_in_wallet)"
        print(baseUrl)
        let headers: HTTPHeaders = ["token" : AppHelper.getStringForKey(ServiceKeys.keyToken)]
        print_debug(params)
        self.hitServiceWithUrlString(urlString: baseUrl, parameters: params as [String : AnyObject] , headers: headers, completion: completion)
    }
    func hitServiceToWithdrawWalletAmount(_ params:[String : Any], completion:@escaping completionBlockType)
    {
        let baseUrl = "\(ServiceUrls.baseUrl)\(ServiceUrls.withdraw_wallet_amount)"
        print(baseUrl)
        let headers: HTTPHeaders = ["token" : AppHelper.getStringForKey(ServiceKeys.keyToken)]
        print_debug(params)
        self.hitServiceWithUrlString(urlString: baseUrl, parameters: params as [String : AnyObject] , headers: headers, completion: completion)
    }
    func hitServiceToGetTutorDetails(_ params:[String : Any], completion:@escaping completionBlockType)
    {
        let baseUrl = "\(ServiceUrls.baseUrl)\(ServiceUrls.get_profile_details)"
        print(baseUrl)
        let headers: HTTPHeaders = ["token" : AppHelper.getStringForKey(ServiceKeys.keyToken)]
        print_debug(params)
        self.hitServiceWithUrlString(urlString: baseUrl, parameters: params as [String : AnyObject] , headers: headers, completion: completion)
    }
    
    // MARK: -  Get Methods 
    
    func hitServiceToGetSchoolList(_ params:[String : Any], completion:@escaping completionBlockType)
    {
        let baseUrl = "\(ServiceUrls.baseUrl)\(ServiceUrls.get_schoolName_List)"
        print(baseUrl)
        
        let headers: HTTPHeaders = [ : ]
        print_debug(params)
        self.hitGetServiceWithUrlString(urlString: baseUrl, parameters: [:] , headers: headers, completion: completion)
    }
    
    func hitServiceToGetUniversityList(_ params:[String : Any], completion:@escaping completionBlockType)
    {
        let baseUrl = "\(ServiceUrls.baseUrl)\(ServiceUrls.get_UniversityName_List)"
        print(baseUrl)
        
        let headers: HTTPHeaders = [ : ]
        print_debug(params)
        self.hitGetServiceWithUrlString(urlString: baseUrl, parameters: [:] , headers: headers, completion: completion)
    }
    
    func hitServiceToGetSubjectList(_ params:[String : Any], completion:@escaping completionBlockType)
    {
        let baseUrl = "\(ServiceUrls.baseUrl)\(ServiceUrls.get_subjectName_List)"
        print(baseUrl)
        
        let headers: HTTPHeaders = [ : ]
        print_debug(params)
        self.hitGetServiceWithUrlString(urlString: baseUrl, parameters: [:] , headers: headers, completion: completion)
    }
    
  
   

// MARK: -  Image Update Methods 
    func hitServiceForUpdateProfileImage(_ params:[String : Any],data : Data?, completion:@escaping completionBlockType)
    {
        let baseUrl = "\(ServiceUrls.baseUrl)\(ServiceUrls.update_profile_image)"
        print(baseUrl)

        let headers: HTTPHeaders = [ "Content-Type" : "application/json",
                                     "token"        : AppHelper.getStringForKey(ServiceKeys.keyToken)]
       
        print_debug(params)
        print_debug(headers)
        self.imageUpload(baseUrl, params: params, data: data!, imageKey: "profile_image", headers: headers, completion: completion)
    }
//

    
 



}
