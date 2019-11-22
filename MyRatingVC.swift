//
//  MyRatingVC.swift
//  QuickLearn
//
//  Created by Xtreem Solution on 12/03/19.
//  Copyright © 2019 XtreemSolution. All rights reserved.
//

import UIKit

class MyRatingVC: BaseViewController{

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var collectionRatingButtons: UICollectionView!
    @IBOutlet weak var lblTotalNumber: UILabel!
    @IBOutlet weak var tblRating: UITableView!
    
    @IBOutlet weak var viewHiddenNoList: UIView!
    var selectedIndex:Int?
    
    var ratingHistoryList:Array = [TutorRatingHistoryList]()
    var strRating = ""
    var strUserId = ""
    var strUserName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // To set UI of screen
        // Do any additional setup after loading the view.
        self.collectionRatingButtons.dataSource = self
        self.collectionRatingButtons.delegate = self
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top:0,left:0,bottom:0,right:0)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .horizontal
       // layout.estimatedItemSize = CGSize(width: self.collectionRatingButtons.bounds.width/3 - 10, height: 36)
        self.collectionRatingButtons.collectionViewLayout = layout
       
        self.tblRating.estimatedRowHeight = 120.0
        self.tblRating.rowHeight = UITableView.automaticDimension
        self.tblRating.estimatedSectionHeaderHeight = 44.0
        
        self.tblRating.dataSource = self
        self.tblRating.delegate = self
        
        //self.selectedIndex = 0
        //self.strRating = "1"
        self.lblName.text = self.strUserName
        self.callApiToGetRatingHistoryList()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //To Show Navigation controller
        self.showNavigationBar()
        self.setTitle(lblTitle: "Rating")
        self.viewHiddenNoList.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.setTitle(lblTitle: "Rating")
    }
    // MARK: -  IBActions 
    
      // MARK: -  Custom Methods 
    @objc func callApiToGetRatingHistoryList(){
        self.viewHiddenNoList.isHidden = true
        self.hudShow()
        var userInfo = [String : Any]()
        userInfo["user_id"] = self.strUserId
        userInfo["rating"] = self.strRating
        ServiceClass.sharedInstance.hitServiceToGetTutorRatingList(userInfo,  completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
            self.hudHide()
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                if(parseData["status"].stringValue == "success") {
                    self.ratingHistoryList.removeAll()
                    if parseData["data"]["total_rating"].stringValue == ""{
                        self.ratingHistoryList.removeAll()
                        self.tblRating.reloadData()
                        self.lblTotalNumber.text = "0"
                        self.viewHiddenNoList.isHidden = false
                    }else{
                        self.lblTotalNumber.text = parseData["data"]["total_rating"].stringValue
                        for  data in parseData["data"]["rating_data"] as JSON {
                            let history = TutorRatingHistoryList.init(fromJson: data.1)
                            self.ratingHistoryList.append(history)
                        }
                        self.tblRating.reloadData()
                    }
                }
            }else {
                
                AppHelper.showALertWithTag(0, title: "Alert", message: (errorDict?[ServiceKeys.keyErrorMessage] as? String)!, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
                if errorDict?[ServiceKeys.keyErrorMessage] as? String == "No rating available."{
                    self.ratingHistoryList.removeAll()
                    self.tblRating.reloadData()
                    self.lblTotalNumber.text = "0"
                }
            }
            self.collectionRatingButtons.reloadData()
        })
    }
    
    @IBAction func btnRating_didSelect(_ sender: UIButton) {
        self.selectedIndex = sender.tag
        self.strRating = String(self.selectedIndex! + 1)
        self.callApiToGetRatingHistoryList()
    }
    
    
}

extension MyRatingVC : UITableViewDelegate,UITableViewDataSource{
    
    // MARK:   Table view delefgate and data source 
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ratingHistoryList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ratingCell = tableView.dequeueReusableCell(withIdentifier: "myRatingTVCell", for: indexPath) as! MyRatingTVCell
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

extension MyRatingVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    //MARK: -  UICollectionViewDataSource 
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let ratingCell = collectionView.dequeueReusableCell(withReuseIdentifier: "myRatingCollectionCell", for: indexPath as IndexPath) as! MyRatingCollectionCell
        
        ratingCell.layer.cornerRadius = 5
        ratingCell.layer.masksToBounds = true
       
        let title:Int = indexPath.row + 1
        ratingCell.btnRating.setTitle(String(title), for: .normal)
        ratingCell.btnRating.addTarget(self, action: #selector(btnRating_didSelect), for: .touchUpInside)
        ratingCell.btnRating.tag = indexPath.row
        if indexPath.item == self.selectedIndex {
            ratingCell.btnRating.backgroundColor = CustomColor.appThemeTopColor
            ratingCell.btnRating.setTitleColor(.white, for: .normal)
            ratingCell.btnRating.setImage(UIImage(named: "star_white"), for: .normal)
        }else{
            ratingCell.btnRating.backgroundColor = CustomColor.lightGrayColor
            ratingCell.btnRating.setTitleColor(.darkGray, for: .normal)
            ratingCell.btnRating.setImage(UIImage(named: "rating_gray"), for: .normal)
        }
        return ratingCell
    }
    
    //MARK: -  UICollectionViewDelegate 
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
        {
            
                return CGSize(width: 70, height: 45)
        }
    //
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
       // let index = indexPath.row
//        let ratingCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ratingCell", for: indexPath as IndexPath)
//        //        ratingCell.backgroundColor = CustomColor.appThemeTopColor
//        var btnRating: UIButton = UIButton()
//        btnRating = ratingCell.viewWithTag(1001) as! UIButton
//        btnRating.setTitleColor(.white, for: .normal)
//        btnRating.setImage(UIImage(named: "star_white"), for: .normal)
//        btnRating.backgroundColor = CustomColor.appThemeTopColor
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
//    {
//        // Do somthing...
//        let index = indexPath.row
//        let ratingCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ratingCell", for: indexPath as IndexPath)
////        ratingCell.backgroundColor = CustomColor.appThemeTopColor
//        var btnRating: UIButton = UIButton()
//        btnRating = ratingCell.viewWithTag(1001) as! UIButton
//        btnRating.setTitleColor(.white, for: .normal)
//        btnRating.setImage(UIImage(named: "star_white"), for: .normal)
//        btnRating.backgroundColor = CustomColor.appThemeTopColor
//    }
}
