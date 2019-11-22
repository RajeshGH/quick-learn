//
//  RatingVC.swift
//  QuickLearn
//
//  Created by Xtreem Solution on 18/03/19.
//  Copyright © 2019 XtreemSolution. All rights reserved.
//

import UIKit
import Cosmos

class RatingVC: BaseViewController{
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblTotalNumber: UILabel!
    @IBOutlet weak var tblRating: UITableView!
    @IBOutlet weak var txtViewComment: UITextView!
    @IBOutlet weak var viewRating: CosmosView!
    
    @IBOutlet weak var viewHiddenNoList: UIView!
    var ratingHistoryList:Array = [TutorRatingHistoryList]()
    
    var strStudentRequestId = ""
    var strUserId = ""
    var strUserName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // To set UI of screen
        self.viewRating.rating = 0
        self.viewRating.settings.fillMode = .half
        self.viewRating.didTouchCosmos = { rating in
            // Change the UI based on the `rating`
        }
        self.viewRating.didFinishTouchingCosmos = { rating in
            //
        }
        self.txtViewComment!.delegate = self
        self.txtViewComment!.text = "Please write here..."
        self.txtViewComment!.textColor = .lightGray
        self.txtViewComment!.layer.cornerRadius = 5
        self.txtViewComment!.layer.borderWidth = 1
        self.txtViewComment!.layer.borderColor = UIColor(red: 206.0/255.0, green: 206.0/255.0, blue: 206.0/255.0, alpha: 1).cgColor
        self.txtViewComment!.layer.masksToBounds = true
        // Do any additional setup after loading the view.
        
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
        
        self.lblName.text = self.strUserName
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.setTitle(lblTitle: "Rating")
    }
    
    // MARK: -  IBActions 
    
    @IBAction func btnSubmit_didSelect(_ sender: Any) {
        if self.checkValidation() == true{
            self.callApiToGiveRating()
        }
    }
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
                self.lblTotalNumber.text = "0"
            }
        })
    }
    
    @objc func callApiToGiveRating(){
        self.hudShow()
        var userInfo = [String : Any]()
        userInfo["rating"] = String(self.viewRating.rating)
        userInfo["comment"] = self.txtViewComment.text
        userInfo["student_request_id"] = self.strStudentRequestId
        ServiceClass.sharedInstance.hitServiceToGiveRating(userInfo,  completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
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
        if (self.viewRating.rating == 0) {
            AppHelper.showALertWithTag(0, title: "Alert", message: err_Rating_Blank, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            return false
        }
        if(self.txtViewComment!.text!.isBlank || self.txtViewComment!.text == "Please write here..."){
            AppHelper.showALertWithTag(0, title: "Alert", message: err_comment_blank, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            return false
        }
        
        return  true
    }
}

extension RatingVC : UITableViewDelegate,UITableViewDataSource{
    
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
// MARK:- TextView Delegtes
extension RatingVC : UITextViewDelegate {
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
            
            textView.text = "Please write here..."
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
            textView.text = "Please write here..."
            textView.textColor = UIColor.lightGray
        }
    }
}
