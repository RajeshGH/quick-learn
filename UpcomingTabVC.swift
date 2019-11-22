//
//  UpcomingTabVC.swift
//  QuickLearn
//
//  Created by Xtreem Solution on 21/02/19.
//  Copyright © 2019 XtreemSolution. All rights reserved.
//

import UIKit

class UpcomingTabVC: BaseViewController{
    @IBOutlet weak var tblUpcoming: UITableView!
    @IBOutlet weak var btnReceived: UIButton!
    @IBOutlet weak var btnSend: UIButton!
    
    @IBOutlet weak var viewHiddenNoList: UIView!
    var sendRequestList:Array = [RequstListForTutor]()
    var receivedRequestList:Array = [RequstListForTutor]()
    var comingFrom = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // To set UI of screen
        self.tblUpcoming.estimatedRowHeight = 54.0
        self.tblUpcoming.rowHeight = UITableView.automaticDimension
        self.tblUpcoming.estimatedSectionHeaderHeight = 44.0
        
        self.tblUpcoming.dataSource = self
        self.tblUpcoming.delegate = self
        
        if self.comingFrom == "Notificaion"{
            // Set UI of segmented button
            if self.btnReceived.isSelected == true{
                self.btnReceived.isSelected = true
                self.btnReceived.backgroundColor = CustomColor.borderThemeColor
                self.btnReceived.setTitleColor(.white, for: .selected)
                self.btnReceived.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 14)
                
                self.btnSend.isSelected = false
                self.btnSend.backgroundColor = CustomColor.borderGrayColor
                self.btnSend.setTitleColor(.darkGray, for: .normal)
                self.btnSend.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 14)
                
            }else{
                self.btnSend.isSelected = true
                self.btnSend.backgroundColor = CustomColor.borderThemeColor
                self.btnSend.setTitleColor(.white, for: .selected)
                self.btnSend.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 14)
                
                self.btnReceived.isSelected = false
                self.btnReceived.backgroundColor = CustomColor.borderGrayColor
                self.btnReceived.setTitleColor(.darkGray, for: .normal)
                self.btnReceived.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 14)
            }
          
        }else{
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
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //To Show Navigation controller
        self.viewHiddenNoList.isHidden = true
        if btnReceived.isSelected == true{
            self.callApiToGetTutorUpcomingRequestList()
        }else{
            self.callApiToGetTutorUpcomingSendtList()
        }
    }
    // MARK: -  IBActions 
    @IBAction func btnReceived_didSelect(_ sender: Any) {
        self.btnSend.isSelected = false
        self.btnSend.backgroundColor = CustomColor.borderGrayColor
        self.btnReceived.setTitleColor(.darkGray, for: .normal)
        self.btnSend.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        self.callApiToGetTutorUpcomingRequestList()
        if btnReceived.isSelected == true{
            
        }else{
            self.btnReceived.isSelected = true
            self.btnReceived.backgroundColor = CustomColor.borderThemeColor
            self.btnReceived.setTitleColor(.white, for: .selected)
            self.btnReceived.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 14)
            self.tblUpcoming.reloadData()
        }
        
    }
    
    @IBAction func btnSend_didSelect(_ sender: Any) {
        self.btnReceived.isSelected = false
        self.btnReceived.backgroundColor = CustomColor.borderGrayColor
        self.btnReceived.setTitleColor(.darkGray, for: .normal)
        self.btnReceived.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        self.callApiToGetTutorUpcomingSendtList()
        if btnSend.isSelected == true{
            
        }else{
            self.btnSend.isSelected = true
            self.btnSend.backgroundColor = CustomColor.borderThemeColor
            self.btnSend.setTitleColor(.white, for: .selected)
            self.btnSend.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 14)
            self.tblUpcoming.reloadData()
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
    @objc func btnSchedule_didSelect(sender: UIButton) {
        
        let alert = UIAlertController(title: "Alert", message: strCompleteRequestAlert, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            var userId = ""
            let tutorDetails = self.sendRequestList[sender.tag]
            userId = tutorDetails.id
            self.callApiToCompleteARequest(studentRequestId: userId, userId: tutorDetails.tutor_id, userName:tutorDetails.name)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            print("Click of cancel button")
        }))
        // show the alert
        self.present(alert, animated: true, completion: nil)
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
    func callApiToGetTutorUpcomingSendtList(){
        self.viewHiddenNoList.isHidden = true
        self.hudShow()
        let userInfo = [String : Any]()
        ServiceClass.sharedInstance.hitServiceToGetTutorUpcomingSendList(userInfo,  completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
            self.hudHide()
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                if(parseData["status"].stringValue == "success") {
                    self.sendRequestList.removeAll()
                    for  data in parseData["data"] as JSON {
                        let tutor = RequstListForTutor.init(fromJson: data.1)
                        self.sendRequestList.append(tutor)
                    }
                    if self.sendRequestList.count > 0{
                        self.tblUpcoming.reloadData()
                    }else{
                        self.viewHiddenNoList.isHidden = false
                    }
                   
                }
            }else {
                AppHelper.showALertWithTag(0, title: "Alert", message: (errorDict?[ServiceKeys.keyErrorMessage] as? String)!, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
                if (errorDict?[ServiceKeys.keyErrorMessage] as? String)! ==  "No sent request available."{
                    self.sendRequestList.removeAll()
                    self.tblUpcoming.reloadData()
                }
            }
        })
    }
    
    func callApiToGetTutorUpcomingRequestList(){
        self.viewHiddenNoList.isHidden = true
        self.hudShow()
        let userInfo = [String : Any]()
        ServiceClass.sharedInstance.hitServiceToGetTutorUpcomingReceivedList(userInfo,  completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
            self.hudHide()
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                if(parseData["status"].stringValue == "success") {
                    self.receivedRequestList.removeAll()
                    for  data in parseData["data"] as JSON {
                        let tutor = RequstListForTutor.init(fromJson: data.1)
                        self.receivedRequestList.append(tutor)
                    }
                    if self.receivedRequestList.count > 0{
                        self.tblUpcoming.reloadData()
                    }else{
                        self.viewHiddenNoList.isHidden = false
                    }
                    
                }
            }else {
                AppHelper.showALertWithTag(0, title: "Alert", message: (errorDict?[ServiceKeys.keyErrorMessage] as? String)!, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
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
                        self.callApiToGetTutorUpcomingRequestList()
                    }else{
                        self.callApiToGetTutorUpcomingSendtList()
                    }
                }
            }else {
                AppHelper.showALertWithTag(0, title: "Alert", message: (errorDict?[ServiceKeys.keyErrorMessage] as? String)!, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            }
        })
    }
    
    func callApiToCompleteARequest(studentRequestId:String,userId:String,userName:String){
        self.hudShow()
        var userInfo = [String : Any]()
        userInfo["student_request_id"] = studentRequestId
        ServiceClass.sharedInstance.hitServiceToCompleteRequest(userInfo,  completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
            self.hudHide()
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                if(parseData["status"].stringValue == "success") {
                    
                        let alert = UIAlertController(title: "Alert", message: parseData["message"].string!, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ratingVC") as? RatingVC
                            vc!.strStudentRequestId = studentRequestId
                            vc!.strUserId = userId
                            vc!.strUserName = userName
                            self.navigationController?.pushViewController(vc!, animated: true)
                        }))
                        // show the alert
                        self.present(alert, animated: true, completion: nil)
                   
                }
            }else {
                AppHelper.showALertWithTag(0, title: "Alert", message: (errorDict?[ServiceKeys.keyErrorMessage] as? String)!, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            }
        })
    }
}


extension UpcomingTabVC : UITableViewDelegate,UITableViewDataSource{
    
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
            receivedRequestCell.btnSchedule.addTarget(self, action: #selector(btnSchedule_didSelect), for: .touchUpInside)
            receivedRequestCell.btnSchedule.tag = indexPath.row
            receivedRequestCell.btnDetails.addTarget(self, action: #selector(btnDetails_didSelect), for: .touchUpInside)
            receivedRequestCell.btnDetails.tag = indexPath.row
            receivedRequestCell.btnSchedule.isUserInteractionEnabled = false
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

//            receivedRequestCell.imgTutor.image = UIImage(named: "no_image_available")
            let pictureBaseUrl = AppHelper.getStringForKey(ServiceKeys.keyPictureBaseURL)
            let imageUrl = pictureBaseUrl + tutorDetails.profile_image
//            Utilities.setImage(url: imageUrl, imageview: receivedRequestCell.imgTutor)
             receivedRequestCell.imgTutor.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "no_image_available"))
            
            
            return receivedRequestCell
        }else{
            let sentRequestCell = tableView.dequeueReusableCell(withIdentifier: "requestSendCell", for: indexPath) as! RequestTabTVCell
            sentRequestCell.selectionStyle = .none
            let tutorDetails = self.sendRequestList[indexPath.row]
            sentRequestCell.btnFavourite.addTarget(self, action: #selector(btnFavoutite_didSelect), for: .touchUpInside)
            sentRequestCell.btnFavourite.tag = indexPath.row
            sentRequestCell.btnSchedule.addTarget(self, action: #selector(btnSchedule_didSelect), for: .touchUpInside)
            sentRequestCell.btnSchedule.tag = indexPath.row
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
            if tutorDetails.avg_rating == ""{
                sentRequestCell.lblRating.text = "0.0 "
            }else{
                sentRequestCell.lblRating.text = tutorDetails.avg_rating
            }
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
            
            let pictureBaseUrl = AppHelper.getStringForKey(ServiceKeys.keyPictureBaseURL)
            let imageUrl = pictureBaseUrl + tutorDetails.profile_image
            sentRequestCell.imgTutor.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "no_image_available"))
            
            if tutorDetails.is_time_out == "Yes" {
                sentRequestCell.btnSchedule.isUserInteractionEnabled = true
                sentRequestCell.btnSchedule.setTitle("Close It", for: .normal)
                sentRequestCell.btnSchedule.backgroundColor = CustomColor.redColor
               // sentRequestCell.btnSchedule.setTitleColor(.white, for: .normal)
            }else{
                sentRequestCell.btnSchedule.isUserInteractionEnabled = false
                sentRequestCell.btnSchedule.setTitle("Scheduled", for: .normal)
                sentRequestCell.btnSchedule.backgroundColor = CustomColor.yellowColor
               // sentRequestCell.btnSchedule.setTitleColor(.white, for: .normal)
            }
            
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
