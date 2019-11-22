//
//  FavouriteListVC.swift
//  QuickLearn
//
//  Created by Xtreem Solution on 11/03/19.
//  Copyright © 2019 XtreemSolution. All rights reserved.
//

import UIKit

class FavouriteListVC: BaseViewController{

    var sub = [TutorSubject]()
    var favouritTutorList:Array = [FavouriteTutorList]()
   
    @IBOutlet weak var viewHiddenNoList: UIView!
    @IBOutlet weak var tblFavourite: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // To set UI of screen
        self.tblFavourite.estimatedRowHeight = 54.0
        self.tblFavourite.rowHeight = UITableView.automaticDimension
        self.tblFavourite.estimatedSectionHeaderHeight = 44.0
        
        self.tblFavourite.dataSource = self
        self.tblFavourite.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //To Show Navigation controller
        self.showNavigationBar()
        self.setTitle(lblTitle: "Favourites")
        self.viewHiddenNoList.isHidden = true
        self.callApiToGetFavouriteTutorList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.setTitle(lblTitle: "Favourites")
    }
    
    // MARK: -  IBActions 
    
    @IBAction func btnFavoutite_didSelect(_ sender: UIButton) {
        var userId = ""
        let tutorDetails = self.favouritTutorList[sender.tag]
        userId = tutorDetails.id
        self.callApiToFavouriteATutor(strUserId: userId)
    }
    @IBAction func btnRequest_didSelect(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "requestVC") as? RequestVC
        let tutorDetails = self.favouritTutorList[sender.tag]
        self.sub = (tutorDetails.subject_detail)!
        var arrTutorSubject = [[String:String]]()
        for s in self.sub{
            let subjectName = s.name
            let subjectId = s.subject_id
            var subject = [String : String]()
            subject["subject_name"] = subjectName
            subject["subject_id"] = subjectId
            arrTutorSubject.append(subject)
        }
        vc!.strTutorName = (tutorDetails.name)!
        vc!.arrSubject = arrTutorSubject
        vc!.strTutorHourlyRate = (tutorDetails.hourly_rate)!
        vc!.strAdminCharge = (tutorDetails.admin_commision)!
        vc!.strTutorId = (tutorDetails.id)!
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    @objc func btnDetails_didSelect(sender: UIButton) {
        let tutorDetails = self.favouritTutorList[sender.tag]
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "tutorDetailsVC") as? TutorDetailsVC
        vc!.isComingFrom = "FavouriteList"
        vc!.strStudentId = tutorDetails.id
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    @IBAction func btnRating_didSelect(_ sender: UIButton) {
        
        let tutorDetails = self.favouritTutorList[sender.tag]
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ratingDetailsVC") as? RatingDetailsVC
        vc?.strUserId = tutorDetails.id
        vc?.strUserName = tutorDetails.name
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
// MARK: -  Custom Methods 
    
    @objc func callApiToGetFavouriteTutorList(){
        self.hudShow()
        self.viewHiddenNoList.isHidden = true
        let userInfo = [String : Any]()
        ServiceClass.sharedInstance.hitServiceToGetFavouriteTutorList(userInfo,  completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
            self.hudHide()
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                if(parseData["status"].stringValue == "success") {
                    self.favouritTutorList.removeAll()
                    for  data in parseData["data"] as JSON {
                        let tutor = FavouriteTutorList.init(fromJson: data.1)
                        self.favouritTutorList.append(tutor)
                    }
                    if self.favouritTutorList.count > 0{
                        self.tblFavourite.reloadData()
                    }else{
                        self.viewHiddenNoList.isHidden = false
                    }
                }
            }else {
                
                AppHelper.showALertWithTag(0, title: "Alert", message: (errorDict?[ServiceKeys.keyErrorMessage] as? String)!, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
                if (errorDict?[ServiceKeys.keyErrorMessage] as? String)! ==  "No record available."{
                    self.favouritTutorList.removeAll()
                    self.tblFavourite.reloadData()
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
                    self.callApiToGetFavouriteTutorList()
                }
            }else {
                AppHelper.showALertWithTag(0, title: "Alert", message: (errorDict?[ServiceKeys.keyErrorMessage] as? String)!, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            }
        })
    }
}

extension FavouriteListVC : UITableViewDelegate,UITableViewDataSource{
    
    // MARK:   Table view delefgate and data source 
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.favouritTutorList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let favouriteCell = tableView.dequeueReusableCell(withIdentifier: "favouriteListTVCell", for: indexPath) as! FavouriteListTVCell
        favouriteCell.selectionStyle = .none
        favouriteCell.btnFavourite.isSelected = true
        favouriteCell.btnFavourite.setImage(UIImage(named: "favourite_selected"), for: .selected)
        favouriteCell.btnFavourite.addTarget(self, action: #selector(btnFavoutite_didSelect), for: .touchUpInside)
         favouriteCell.btnFavourite.tag = indexPath.row
        favouriteCell.btnRequest.addTarget(self, action: #selector(btnRequest_didSelect), for: .touchUpInside)
        favouriteCell.btnRequest.tag = indexPath.row
        favouriteCell.btnDetails.addTarget(self, action: #selector(btnDetails_didSelect), for: .touchUpInside)
        favouriteCell.btnDetails.tag = indexPath.row
        favouriteCell.btnRating.addTarget(self, action: #selector(btnRating_didSelect), for: .touchUpInside)
        favouriteCell.btnRating.tag = indexPath.row
//        if MyProfileDetails.shared.year <
        
        
        let tutorDetails = self.favouritTutorList[indexPath.row]
        favouriteCell.lblTutorName.text = tutorDetails.name
        favouriteCell.lblTutorId.text = tutorDetails.username
        favouriteCell.lblTutorPrice.text = ConstantKeys.euro_sign + " " + tutorDetails.hourly_rate + "/hr"
        if tutorDetails.avg_rating == ""{
            favouriteCell.lblRating.text = "0.0 "
        }else{
            favouriteCell.lblRating.text = tutorDetails.avg_rating
        }
        let loggedUserYear : Int = Int(MyProfileDetails.shared.year)!
        let tutorYear : Int = Int(tutorDetails.year)!
        if tutorYear > loggedUserYear{
            favouriteCell.btnRequest.isHidden = false
        }else{
            favouriteCell.btnRequest.isHidden = true
        }
        var sub = [TutorSubject]()
        sub = tutorDetails.subject_detail
        var allSubject = ""
        for s in sub{
            let subjectName = s.name
            if allSubject == ""{
                allSubject = allSubject + subjectName!
            }else{
                allSubject = allSubject +  ", " + subjectName!
            }
            
        }
        favouriteCell.lblAddress.text = allSubject

          //  favouriteCell.imgTutor.image = UIImage(named: "no_image_available")
            let pictureBaseUrl = AppHelper.getStringForKey(ServiceKeys.keyPictureBaseURL)
            let imageUrl = pictureBaseUrl + tutorDetails.profile_image
           // Utilities.setImage(url: imageUrl, imageview: favouriteCell.imgTutor)
            favouriteCell.imgTutor.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "no_image_available"))
        return favouriteCell
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
