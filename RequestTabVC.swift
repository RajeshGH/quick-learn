//
//  RequestTabVC.swift
//  QuickLearn
//
//  Created by Xtreem Solution on 21/02/19.
//  Copyright © 2019 XtreemSolution. All rights reserved.
//

import UIKit

class RequestTabVC: BaseViewController{
    @IBOutlet weak var tblRequest: UITableView!
    @IBOutlet weak var btnReceived: UIButton!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var viewHiddenNoList: UIView!
    
    var sendRequestList:Array = [RequstListForTutor]()
    var receivedRequestList:Array = [RequstListForTutor]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // To set UI of screen
        self.tblRequest.estimatedRowHeight = 54.0
        self.tblRequest.rowHeight = UITableView.automaticDimension
        self.tblRequest.estimatedSectionHeaderHeight = 44.0
        
        self.tblRequest.dataSource = self
        self.tblRequest.delegate = self
        
        // Set UI of segmented button
        self.btnReceived.isSelected = true
        self.btnReceived.backgroundColor = CustomColor.borderThemeColor
        self.btnReceived.setTitleColor(.white, for: .selected)
        self.btnReceived.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 14)
       
        self.btnSend.isSelected = false
        self.btnSend.backgroundColor = CustomColor.borderGrayColor
        self.btnSend.setTitleColor(.darkGray, for: .normal)
        self.btnSend.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        //  self.callApiToGetFavouriteTutorList()Montserrat-SemiBold 14.0
       
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //To Show Navigation controller
        self.viewHiddenNoList.isHidden = true
        if btnReceived.isSelected == true{
            self.callApiToGetTutorReceivedRequestList()
        }else{
            self.callApiToGetTutorSendRequestList()
        }
    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
//        self.setTitle(lblTitle: "Favourites")
//    }
    
    // MARK: -  IBActions 
    @IBAction func btnReceived_didSelect(_ sender: Any) {
        self.btnSend.isSelected = false
        self.btnSend.backgroundColor = CustomColor.borderGrayColor
        self.btnReceived.setTitleColor(.darkGray, for: .normal)
        self.btnSend.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        self.callApiToGetTutorReceivedRequestList()
        if btnReceived.isSelected == true{
            
        }else{
            self.btnReceived.isSelected = true
            self.btnReceived.backgroundColor = CustomColor.borderThemeColor
            self.btnReceived.setTitleColor(.white, for: .selected)
            self.btnReceived.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 14)
            self.tblRequest.reloadData()
        }
        
    }
    
    @IBAction func btnSend_didSelect(_ sender: Any) {
        self.btnReceived.isSelected = false
        self.btnReceived.backgroundColor = CustomColor.borderGrayColor
        self.btnReceived.setTitleColor(.darkGray, for: .normal)
        self.btnReceived.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        self.callApiToGetTutorSendRequestList()
        if btnSend.isSelected == true{
            
        }else{
            self.btnSend.isSelected = true
            self.btnSend.backgroundColor = CustomColor.borderThemeColor
            self.btnSend.setTitleColor(.white, for: .selected)
            self.btnSend.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 14)
            self.tblRequest.reloadData()
        }
        
    }
    
    @objc func btnFavoutite_didSelect(sender: UIButton) {
//        if sender.isSelected == true{
//            sender.isSelected = false
//            sender.setImage(UIImage(named: "favourite"), for: .normal)
//        }else{
//            sender.isSelected = true
//            sender.setImage(UIImage(named: "favourite_selected"), for: .normal)
//        }
        var userId = ""
        if btnReceived.isSelected == true{
            let tutorDetails = self.receivedRequestList[sender.tag]
            userId = tutorDetails.user_id
        }else{
            let tutorDetails = self.sendRequestList[sender.tag]
            userId = tutorDetails.user_id
        }
        self.callApiToFavouriteATutor(strUserId: userId)
    }
    @objc func btnEdit_didSelect(sender: UIButton) {

//        var userId = ""
//        if btnReceived.isSelected == true{
//            let tutorDetails = self.receivedRequestList[sender.tag]
//            userId = tutorDetails.user_id
//        }else{
//            let tutorDetails = self.receivedRequestList[sender.tag]
//            userId = tutorDetails.user_id
//        }
//        self.callApiToFavouriteATutor(strUserId: userId)
    }
    @objc func btnAccept_didSelect(sender: UIButton) {
        
        var userId = ""
        if btnReceived.isSelected == true{
            let tutorDetails = self.receivedRequestList[sender.tag]
            userId = tutorDetails.id
        }else{
            let tutorDetails = self.sendRequestList[sender.tag]
            userId = tutorDetails.id
        }
        let alert = UIAlertController(title: "Alert", message: strAcceptAlert, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            self.callApiToAcceptOrRejectRequest(strRequestId: userId, strAction: "Accept")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            print("Click of cancel button")
        }))
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    @objc func btnReject_didSelect(sender: UIButton) {
       
        var userId = ""
        if btnReceived.isSelected == true{
            let tutorDetails = self.receivedRequestList[sender.tag]
            userId = tutorDetails.id
        }else{
            let tutorDetails = self.sendRequestList[sender.tag]
            userId = tutorDetails.id
        }
        let alert = UIAlertController(title: "Alert", message: strRejectAlert, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            self.callApiToAcceptOrRejectRequest(strRequestId: userId, strAction: "Reject")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            print("Click of cancel button")
        }))
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    @objc func btnCancelRequest_didSelect(sender: UIButton) {
        
        var userId = ""
        if btnReceived.isSelected == true{
            let tutorDetails = self.receivedRequestList[sender.tag]
            userId = tutorDetails.id
        }else{
            let tutorDetails = self.sendRequestList[sender.tag]
            userId = tutorDetails.id
        }
        let alert = UIAlertController(title: "Alert", message: strCanceltAlert, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            self.callApiToCancelSentRequest(strRequestId: userId)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            print("Click of cancel button")
        }))
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    @objc func btnDetails_didSelect(sender: UIButton) {
        
        var userId = ""
        if btnReceived.isSelected == true{
            let tutorDetails = self.receivedRequestList[sender.tag]
            userId = tutorDetails.student_id
        }else{
            let tutorDetails = self.sendRequestList[sender.tag]
            userId = tutorDetails.user_id
        }
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "tutorDetailsVC") as? TutorDetailsVC
        vc!.isComingFrom = "RequestTab"
        vc!.strStudentId = userId
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    @IBAction func btnRating_didSelect(_ sender: UIButton) {
        
        var userId = ""
        var userName = ""
        if btnReceived.isSelected == true{
            let tutorDetails = self.receivedRequestList[sender.tag]
            userId = tutorDetails.student_id
            userName = tutorDetails.name
        }else{
            let tutorDetails = self.sendRequestList[sender.tag]
            userId = tutorDetails.user_id
            userName = tutorDetails.name
        }
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ratingDetailsVC") as? RatingDetailsVC
        vc?.strUserId = userId
        vc?.strUserName = userName
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    // MARK: -  Custom methods   
     func callApiToGetTutorSendRequestList(){
        self.viewHiddenNoList.isHidden = true
        self.hudShow()
        let userInfo = [String : Any]()
        ServiceClass.sharedInstance.hitServiceToGetTutorRequestSendList(userInfo,  completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
            self.hudHide()
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                if(parseData["status"].stringValue == "success") {
                    self.sendRequestList.removeAll()
                    
                    for  data in parseData["data"] as JSON {
                        let tutor = RequstListForTutor.init(fromJson: data.1)
                        self.sendRequestList.append(tutor)
                    }
                    if self.sendRequestList.count > 0{
                        self.tblRequest.reloadData()
                    }else{
                        self.viewHiddenNoList.isHidden = false
                    }
                }
            }else {
                AppHelper.showALertWithTag(0, title: "Alert", message: (errorDict?[ServiceKeys.keyErrorMessage] as? String)!, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
                if (errorDict?[ServiceKeys.keyErrorMessage] as? String)! ==  "No sent request available."{
                    self.sendRequestList.removeAll()
                    self.tblRequest.reloadData()
                }
            }
        })
    }
    
    func callApiToGetTutorReceivedRequestList(){
        self.viewHiddenNoList.isHidden = true
        self.hudShow()
        let userInfo = [String : Any]()
        ServiceClass.sharedInstance.hitServiceToGetTutorRequestReceivedList(userInfo,  completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
            self.hudHide()
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                if(parseData["status"].stringValue == "success") {
                    self.receivedRequestList.removeAll()
                    for  data in parseData["data"] as JSON {
                        let tutor = RequstListForTutor.init(fromJson: data.1)
                        self.receivedRequestList.append(tutor)
                    }
                    if self.receivedRequestList.count > 0{
                        self.tblRequest.reloadData()
                    }else{
                        self.viewHiddenNoList.isHidden = false
                    }
                }
            }else {
                AppHelper.showALertWithTag(0, title: "Alert", message: (errorDict?[ServiceKeys.keyErrorMessage] as? String)!, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
                if (errorDict?[ServiceKeys.keyErrorMessage] as? String)! ==  "No request available."{
                    self.receivedRequestList.removeAll()
                    self.tblRequest.reloadData()
                }
            }
        })
    }
    
    func callApiToFavouriteATutor(strUserId:String){
        self.hudShow()
        var userInfo = [String : Any]()
        userInfo["user_id"] = strUserId
        ServiceClass.sharedInstance.hitServiceToFavouriteATutor(userInfo,  completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
            self.hudHide()
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                if(parseData["status"].stringValue == "success") {
                    
                    AppHelper.showALertWithTag(0, title: "Alert", message: parseData["message"].string!, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
                    if self.btnReceived.isSelected == true{
                         self.callApiToGetTutorReceivedRequestList()
                    }else{
                         self.callApiToGetTutorSendRequestList()
                    }
                }
            }else {
                AppHelper.showALertWithTag(0, title: "Alert", message: (errorDict?[ServiceKeys.keyErrorMessage] as? String)!, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            }
        })
    }
    
    func callApiToAcceptOrRejectRequest(strRequestId:String,strAction:String){
        self.hudShow()
        var userInfo = [String : Any]()
        userInfo["request_id"] = strRequestId
        userInfo["action"] = strAction
        ServiceClass.sharedInstance.hitServiceToAcceptOrRejectRequest(userInfo,  completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
            self.hudHide()
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                if(parseData["status"].stringValue == "success") {
                    
                    AppHelper.showALertWithTag(0, title: "Alert", message: parseData["message"].string!, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
                    if self.btnReceived.isSelected == true{
                        self.callApiToGetTutorReceivedRequestList()
                    }else{
                        self.callApiToGetTutorSendRequestList()
                    }
                }
            }else {
                AppHelper.showALertWithTag(0, title: "Alert", message: (errorDict?[ServiceKeys.keyErrorMessage] as? String)!, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            }
        })
    }
    
    func callApiToCancelSentRequest(strRequestId:String){
        self.hudShow()
        var userInfo = [String : Any]()
        userInfo["request_id"] = strRequestId
        ServiceClass.sharedInstance.hitServiceToCancelSentRequest(userInfo,  completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
            self.hudHide()
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                if(parseData["status"].stringValue == "success") {
                    
                    AppHelper.showALertWithTag(0, title: "Alert", message: parseData["message"].string!, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
                    AppHelper.setStringForKey(parseData["data"]["available_balance"].stringValue, key: ServiceKeys.available_wallet_balance)
                    if self.btnReceived.isSelected == true{
                        self.callApiToGetTutorReceivedRequestList()
                    }else{
                        self.callApiToGetTutorSendRequestList()
                    }
                }
            }else {
                AppHelper.showALertWithTag(0, title: "Alert", message: (errorDict?[ServiceKeys.keyErrorMessage] as? String)!, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            }
        })
    }
}

extension RequestTabVC : UITableViewDelegate,UITableViewDataSource{
    
    // MARK:   Table view delefgate and data source 
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if btnReceived.isSelected == true{
            return self.receivedRequestList.count
        }else{
            return self.sendRequestList.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if btnReceived.isSelected == true{
            let receivedRequestCell = tableView.dequeueReusableCell(withIdentifier: "requestReceivedCell", for: indexPath) as! RequestTabTVCell
            receivedRequestCell.selectionStyle = .none
            let tutorDetails = self.receivedRequestList[indexPath.row]
            receivedRequestCell.btnFavourite.addTarget(self, action: #selector(btnFavoutite_didSelect), for: .touchUpInside)
            receivedRequestCell.btnFavourite.tag = indexPath.row
            receivedRequestCell.btnAccept.addTarget(self, action: #selector(btnAccept_didSelect), for: .touchUpInside)
            receivedRequestCell.btnAccept.tag = indexPath.row
            receivedRequestCell.btnReject.addTarget(self, action: #selector(btnReject_didSelect), for: .touchUpInside)
            receivedRequestCell.btnReject.tag = indexPath.row
            receivedRequestCell.btnDetails.addTarget(self, action: #selector(btnDetails_didSelect), for: .touchUpInside)
            receivedRequestCell.btnDetails.tag = indexPath.row
            receivedRequestCell.btnRating.addTarget(self, action: #selector(btnRating_didSelect), for: .touchUpInside)
            receivedRequestCell.btnRating.tag = indexPath.row
            
            if tutorDetails.is_favourite == "No" {
                receivedRequestCell.btnFavourite.isSelected = false
                receivedRequestCell.btnFavourite.setImage(UIImage(named: "favourite"), for: .normal)
            }else{
                receivedRequestCell.btnFavourite.isSelected = true
                receivedRequestCell.btnFavourite.setImage(UIImage(named: "favourite_selected"), for: .normal)
            }
            if tutorDetails.avg_rating == ""{
                receivedRequestCell.lblRating.text = "0.0 "
            }else{
                receivedRequestCell.lblRating.text = tutorDetails.avg_rating
            }
            //receivedRequestCell.lblRating.text = "0.0"
            receivedRequestCell.lblTutorName.text = tutorDetails.name
            receivedRequestCell.lblTutorId.text = tutorDetails.username
            receivedRequestCell.lblTutorPrice.text = ConstantKeys.euro_sign + " " + tutorDetails.hourly_rate + "/hr"
            
            let hourlyRate:Float = Float(tutorDetails.tutor_fee_per_hour)!
            let totalHours:Float = Float(tutorDetails.hours)!
            let adminCommision:Float = Float(tutorDetails.admin_commision)!
            let lotalPrice = String((hourlyRate * totalHours) + adminCommision)
            receivedRequestCell.btnRequestPrice.setTitle(ConstantKeys.euro_sign + " " + lotalPrice, for: .normal)
            
            var sub = [TutorStudySubject]()
            sub = tutorDetails.study_subjects
            var allSubject = ""
            for s in sub{
                let subjectName = s.name
                if allSubject == ""{
                    allSubject = allSubject + subjectName!
                }else{
                    allSubject = allSubject +  ", " + subjectName!
                }
                
            }
            receivedRequestCell.lblSubject.text = allSubject
            receivedRequestCell.lblStartTime.text = tutorDetails.start_time
            receivedRequestCell.lblEndTime.text = tutorDetails.end_time
            receivedRequestCell.lblDate.text = tutorDetails.study_date
            receivedRequestCell.lblAddress.text = tutorDetails.address

//                receivedRequestCell.imgTutor.image = UIImage(named: "no_image_available")
                let pictureBaseUrl = AppHelper.getStringForKey(ServiceKeys.keyPictureBaseURL)
                let imageUrl = pictureBaseUrl + tutorDetails.profile_image
//                Utilities.setImage(url: imageUrl, imageview: receivedRequestCell.imgTutor)
                receivedRequestCell.imgTutor.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "no_image_available"))
            
            
            return receivedRequestCell
        }else{
            let sentRequestCell = tableView.dequeueReusableCell(withIdentifier: "requestSendCell", for: indexPath) as! RequestTabTVCell
            sentRequestCell.selectionStyle = .none
            let tutorDetails = self.sendRequestList[indexPath.row]
            sentRequestCell.btnFavourite.addTarget(self, action: #selector(btnFavoutite_didSelect), for: .touchUpInside)
            sentRequestCell.btnFavourite.tag = indexPath.row
            sentRequestCell.btnEdit.addTarget(self, action: #selector(btnEdit_didSelect), for: .touchUpInside)
            sentRequestCell.btnEdit.tag = indexPath.row
            sentRequestCell.btnCancelRequest.addTarget(self, action: #selector(btnCancelRequest_didSelect), for: .touchUpInside)
            sentRequestCell.btnCancelRequest.tag = indexPath.row
            sentRequestCell.btnDetails.addTarget(self, action: #selector(btnDetails_didSelect), for: .touchUpInside)
            sentRequestCell.btnDetails.tag = indexPath.row
            sentRequestCell.btnRating.addTarget(self, action: #selector(btnRating_didSelect), for: .touchUpInside)
            sentRequestCell.btnRating.tag = indexPath.row
            
            if tutorDetails.is_favourite == "No" {
                sentRequestCell.btnFavourite.isSelected = false
                sentRequestCell.btnFavourite.setImage(UIImage(named: "favourite"), for: .normal)
            }else{
                sentRequestCell.btnFavourite.isSelected = true
                sentRequestCell.btnFavourite.setImage(UIImage(named: "favourite_selected"), for: .normal)
            }
            if tutorDetails.request_status == "Accept"{
                sentRequestCell.btnCancelRequest.setImage(UIImage(named: "accepted_green"), for: .normal)
                sentRequestCell.btnCancelRequest.isUserInteractionEnabled = false
            }else{
                sentRequestCell.btnCancelRequest.setImage(UIImage(named: "rejected_icon"), for: .normal)
                sentRequestCell.btnCancelRequest.isUserInteractionEnabled = true
            }
            if tutorDetails.avg_rating == ""{
                sentRequestCell.lblRating.text = "0.0 "
            }else{
                sentRequestCell.lblRating.text = tutorDetails.avg_rating
            }
            //sentRequestCell.lblRating.text = "0.0"
            sentRequestCell.lblTutorName.text = tutorDetails.name
            sentRequestCell.lblTutorId.text = tutorDetails.username
            sentRequestCell.lblTutorPrice.text = ConstantKeys.euro_sign + " " + tutorDetails.hourly_rate + "/hr"
            
            let hourlyRate:Float = Float(tutorDetails.hourly_rate)!
            let totalHours:Float = Float(tutorDetails.hours)!
            let adminCommision:Float = Float(tutorDetails.admin_commision)!
            let lotalPrice = String((hourlyRate * totalHours) + adminCommision)
            sentRequestCell.btnRequestPrice.setTitle(ConstantKeys.euro_sign + " " + lotalPrice, for: .normal)
            
            var sub = [TutorStudySubject]()
            sub = tutorDetails.study_subjects
            var allSubject = ""
            for s in sub{
                let subjectName = s.name
                if allSubject == ""{
                    allSubject = allSubject + subjectName!
                }else{
                    allSubject = allSubject +  ", " + subjectName!
                }
                
            }
            sentRequestCell.lblSubject.text = allSubject
            sentRequestCell.lblStartTime.text = tutorDetails.start_time
            sentRequestCell.lblEndTime.text = tutorDetails.end_time
            sentRequestCell.lblDate.text = tutorDetails.study_date
            sentRequestCell.lblAddress.text = tutorDetails.address

//                sentRequestCell.imgTutor.image = UIImage(named: "no_image_available")
                let pictureBaseUrl = AppHelper.getStringForKey(ServiceKeys.keyPictureBaseURL)
                let imageUrl = pictureBaseUrl + tutorDetails.profile_image
//                Utilities.setImage(url: imageUrl, imageview: sentRequestCell.imgTutor)
            sentRequestCell.imgTutor.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "no_image_available"))
            
            return sentRequestCell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "tutorDetailsVC") as? TutorDetailsVC
//        let tutorDetails = self.tutorList[indexPath.row]
//        vc!.tutorDetailssss = tutorDetails
//        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 60
    //    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    //    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    //        return nil
    //    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
}
