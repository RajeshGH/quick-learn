//
//  RatingDetailsVC.swift
//  QuickLearn
//
//  Created by Xtreem Solution on 02/04/19.
//  Copyright © 2019 XtreemSolution. All rights reserved.
//

import UIKit

class RatingDetailsVC: BaseViewController {

    @IBOutlet weak var lblTutorName: UILabel!
    @IBOutlet weak var tblRating: UITableView!
    
    @IBOutlet weak var viewHiddenNoList: UIView!
    var ratingHistoryList:Array = [TutorRatingHistoryList]()
    
    var strUserId = ""
    var strUserName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblRating.estimatedRowHeight = 120.0
        self.tblRating.rowHeight = UITableView.automaticDimension
        self.tblRating.estimatedSectionHeaderHeight = 44.0
        
        self.tblRating.dataSource = self
        self.tblRating.delegate = self
        self.viewHiddenNoList.isHidden = true
        self.callApiToGetRatingHistoryList()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //To Show Navigation controller
        self.showNavigationBar()
        self.setTitle(lblTitle: "Rating")
        self.lblTutorName.text = self.strUserName
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.setTitle(lblTitle: "Rating")
    }
    
    // MARK: -  IBActions 
    
    
    // MARK: -  Custom Methods 
    @objc func callApiToGetRatingHistoryList(){
        self.hudShow()
        var userInfo = [String : Any]()
        userInfo["user_id"] = self.strUserId
        ServiceClass.sharedInstance.hitServiceToGetTutorRatingList(userInfo,  completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
            self.hudHide()
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                if(parseData["status"].stringValue == "success") {
                    self.ratingHistoryList.removeAll()
                    if parseData["data"]["total_rating"].stringValue == ""{
                        self.viewHiddenNoList.isHidden = false
                    }else{
                        for  data in parseData["data"]["rating_data"] as JSON {
                            let history = TutorRatingHistoryList.init(fromJson: data.1)
                            self.ratingHistoryList.append(history)
                        }
                        self.tblRating.reloadData()
                    }
                }
            }else {
                
                AppHelper.showALertWithTag(0, title: "Alert", message: (errorDict?[ServiceKeys.keyErrorMessage] as? String)!, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
                
            }
        })
    }
    
   
    
}

extension RatingDetailsVC : UITableViewDelegate,UITableViewDataSource{
    
    // MARK:   Table view delefgate and data source 
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ratingHistoryList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ratingCell = tableView.dequeueReusableCell(withIdentifier: "ratingDetailsCell", for: indexPath) as! MyRatingTVCell
        ratingCell.selectionStyle = .none
        let ratingDetails = self.ratingHistoryList[indexPath.row]
        ratingCell.viewRating.rating = Double(ratingDetails.rating)!
        ratingCell.lblUserName.text = ratingDetails.name
        ratingCell.lblDate.text = ratingDetails.add_date
        ratingCell.lblMessage.text = ratingDetails.description
        
        let pictureBaseUrl = AppHelper.getStringForKey(ServiceKeys.keyPictureBaseURL)
        let imageUrl = pictureBaseUrl + ratingDetails.profile_image
        ratingCell.imgUser.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "no_image_available"))
        return ratingCell
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

