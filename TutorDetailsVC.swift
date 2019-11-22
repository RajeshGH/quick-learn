//
//  TutorDetailsVC.swift
//  QuickLearn
//
//  Created by Xtreem Solution on 22/02/19.
//  Copyright © 2019 XtreemSolution. All rights reserved.
//

import UIKit

class TutorDetailsVC: BaseViewController {

    @IBOutlet weak var tblProfileDetails: UITableView!
    @IBOutlet weak var btnRequest: UIButton!
    
    @IBOutlet weak var btnRating: UIButton!
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblTutorName: UILabel!
    @IBOutlet weak var lblTutorId: UILabel!
    
   
    @IBOutlet weak var lblRating: UILabel!
    
    @IBOutlet weak var lblStaticUniversityName: UILabel!
    
    @IBOutlet weak var lblUniversityName: UILabel!
    @IBOutlet weak var lblYear: UILabel!
    
    var tutorDetailssss : TutorList?
    var allSubject = ""
    var sub = [TutorSubject]()
    
    var strStudentId = ""
    var isComingFrom = ""
    var subject_detail : [[String:Any]] = []
    
    @IBOutlet weak var viewRequest: UIView!
    @IBOutlet weak var heightViewRequest: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.tblProfileDetails.delegate = self
        self.tblProfileDetails.dataSource = self
        self.tblProfileDetails.separatorStyle = .none
        
        self.lblStaticUniversityName.text = "School/University Name"
       
        self.lblTutorName.layer.shadowColor = UIColor.black.cgColor
        self.lblTutorName.layer.shadowRadius = 2.0
        self.lblTutorName.layer.shadowOpacity = 1.0
        self.lblTutorName.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.lblTutorName.layer.masksToBounds = false
        
        self.lblTutorId.layer.shadowColor = UIColor.black.cgColor
        self.lblTutorId.layer.shadowRadius = 2.0
        self.lblTutorId.layer.shadowOpacity = 1.0
        self.lblTutorId.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.lblTutorId.layer.masksToBounds = false
        
//        label.layer.shadowColor = UIColor.black.cgColor
//        label.layer.shadowRadius = 3.0
//        label.layer.shadowOpacity = 1.0
//        label.layer.shadowOffset = CGSize(width: 4, height: 4)
//        label.layer.masksToBounds = false
        
        if isComingFrom == "SearchTab"{
            self.setProfileDetails()
            self.heightViewRequest.constant = 100
            self.viewRequest.isHidden = false
        }else{
            self.callApiToGetTutorDetails()
            self.heightViewRequest.constant = 0
            self.viewRequest.isHidden = true
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //To Show Navigation controller
        self.showNavigationBar()
        self.setTitle(lblTitle: "Profile Detail")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.setTitle(lblTitle: "Profile Detail")
    }

    
    // MARK: -  IBActions 
    @IBAction func btnRating_didSelect(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ratingDetailsVC") as? RatingDetailsVC
        if isComingFrom == "SearchTab"{
            vc?.strUserId = (tutorDetailssss?.id)!
            vc?.strUserName = (tutorDetailssss?.name)!
        }else{
            vc?.strUserId = MyProfileDetails.shared.id
            vc?.strUserName = MyProfileDetails.shared.name
        }
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func btnRequest_didSelect(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "requestVC") as? RequestVC
        
        self.sub = (tutorDetailssss?.subject_detail)!
        var arrTutorSubject = [[String:String]]()
        for s in self.sub{
            let subjectName = s.name
            let subjectId = s.subject_id
            var subject = [String : String]()
            subject["subject_name"] = subjectName
            subject["subject_id"] = subjectId
            arrTutorSubject.append(subject)
        }
        print("Array without sorting = ",arrTutorSubject)
        arrTutorSubject = (arrTutorSubject as NSArray).sortedArray(using: [NSSortDescriptor(key: "subject_name", ascending: true)]) as! [[String:String]]
        print("Array with sorting = ",arrTutorSubject)
         vc!.strTutorName = (self.tutorDetailssss?.name)!
         vc!.arrSubject = arrTutorSubject
         vc!.strTutorHourlyRate = (self.tutorDetailssss?.hourly_rate)!
         vc!.strAdminCharge = (self.tutorDetailssss?.admin_commision)!
         vc!.strTutorId = (self.tutorDetailssss?.id)!
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func setProfileDetails(){
        
        self.lblTutorName.text = tutorDetailssss?.name
        let tutorId = (tutorDetailssss?.username)! + "   "
        self.lblTutorId.text = tutorId + ConstantKeys.euro_sign + " " + (tutorDetailssss?.hourly_rate)! + "/hr"
        self.lblUniversityName.text = tutorDetailssss?.education_name
        self.lblYear.text = tutorDetailssss?.year
        if tutorDetailssss?.avg_rating == ""{
            self.lblRating.text = "0.0"
        }else{
            self.lblRating.text  = tutorDetailssss?.avg_rating
        }
        
        self.sub = (tutorDetailssss?.subject_detail)!
        
        for s in self.sub{
            let subjectName = s.name
            if allSubject == ""{
                allSubject = allSubject + subjectName!
            }else{
                allSubject = allSubject +  "\n" + subjectName!
            }
            
        }
        let pictureBaseUrl = AppHelper.getStringForKey(ServiceKeys.keyPictureBaseURL)
        let imageUrl = pictureBaseUrl + (tutorDetailssss?.profile_image)!
        //Utilities.setImage(url: imageUrl, imageview: self.imgProfile)
        //self.imgProfile.contentMode = .scaleAspectFit
       
        self.imgProfile.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "no_image_available"))
        
        self.imgProfile.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        self.imgProfile.contentMode = .scaleAspectFill
 
//        var image:UIImage = UIImage()
//        image = self.imgProfile.image!
//        let size = self.imgProfile.contentClippingRect
//        let rect:CGSize = CGSize.init(width: size.width, height: size.height)
//
//       self.imgProfile.image = self.cropToBounds(image: image, width: Double(size.width), height: Double(size.height))
//
////        image = image.resizeImageUsingVImage(size: rect)!
//        self.imgProfile.contentMode = .scaleAspectFit
//        self.imgProfile.image = image
        self.tblProfileDetails.reloadData()
    }

    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        
        let cgimage = image.cgImage!
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = cgimage.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
    
    
    @objc func callApiToGetTutorDetails(){
        self.hudShow()
        var userInfo = [String : Any]()
        userInfo["user_id"] = self.strStudentId
        ServiceClass.sharedInstance.hitServiceToGetTutorDetails(userInfo,  completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
            self.hudHide()
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                if(parseData["status"].stringValue == "success") {
                    //self.tutorDetailssss.removeAll()
                    var dictProfile:NSDictionary = NSDictionary()
                    dictProfile = parseData["data"].dictionaryObject! as NSDictionary
                    
                    MyProfileDetails.shared.setProfileData(json: dictProfile as! [String : Any])
                    self.setTutorDetails()
                }
            }else {

                AppHelper.showALertWithTag(0, title: "Alert", message: (errorDict?[ServiceKeys.keyErrorMessage] as? String)!, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            }
        })
    }
//
    func setTutorDetails() {
         
        self.lblTutorName.text = MyProfileDetails.shared.name
        self.lblTutorId.text = MyProfileDetails.shared.username
        let tutorId = MyProfileDetails.shared.username + "   "
        self.lblTutorId.text = tutorId + ConstantKeys.euro_sign + " " + MyProfileDetails.shared.hourly_rate + "/hr"
       
        let pictureBaseUrl = AppHelper.getStringForKey(ServiceKeys.keyPictureBaseURL)
        let imageUrl = pictureBaseUrl + MyProfileDetails.shared.profile_image
        // Utilities.setImage(url: imageUrl, imageview: self.imgProfile)
        self.imgProfile.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "no_image_available"))
        
        guard let rating = MyProfileDetails.shared.avg_rating else {
            self.lblRating.text = "0.0 "
            return
        }
        self.lblRating.text = rating
        self.lblUniversityName.text = MyProfileDetails.shared.education_name
        self.lblYear.text = MyProfileDetails.shared.year
        
        self.subject_detail = MyProfileDetails.shared.subject_detail
        for s in self.subject_detail{
            let subjectName = s["name"] as! String
            if allSubject == ""{
                allSubject = allSubject + subjectName
            }else{
                allSubject = allSubject +  "\n" + subjectName
            }
        }
        self.tblProfileDetails.reloadData()
    }
    
}
extension TutorDetailsVC : UITableViewDelegate,UITableViewDataSource{

// MARK:   Table view delefgate and data source 
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isComingFrom == "SearchTab"{
            return self.sub.count + 1
        }else{
            return self.subject_detail.count + 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tutorDetailsTVCell", for: indexPath) as! TutorDetailsTVCell
        cell.selectionStyle = .none
        let row =  indexPath.row
        if row == 0 {
            cell.lbl_heading.text = "Subject"
            
            let attributedString = NSMutableAttributedString(string: allSubject)
            
            // *** Create instance of `NSMutableParagraphStyle`
            let paragraphStyle = NSMutableParagraphStyle()
            
            // *** set LineSpacing property in points ***
            paragraphStyle.lineSpacing = 10 // Whatever line spacing you want in points
            
            // *** Apply attribute to string ***
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
            
            
            
            cell.lbl_description.attributedText = attributedString//NSAttributedString(string: " ")
            cell.lbl_count_leading_constraint.constant = 0
            cell.lbl_count.isHidden = true
            cell.lbl_count_width_constraint.constant = 0
            if isComingFrom == "SearchTab"{
                
            }else{
                
            }
            
        } else {
            
            cell.lbl_count_leading_constraint.constant = 14
            cell.lbl_count.isHidden = false
            cell.lbl_count_width_constraint.constant = 31
            
            if row == 1 {

                cell.lbl_heading.text = "GCSE Result"
                cell.lbl_heading.isHidden = false
                cell.view_line.isHidden = false
                cell.heading_height_constraint.constant = 15
                cell.heading_top_constraint.constant = 12
                cell.description_top_constraint.constant = 8
                
            } else {

                cell.lbl_heading.isHidden = true
                cell.view_line.isHidden = true
                cell.heading_height_constraint.constant = 0
                cell.heading_top_constraint.constant = 0
                cell.description_top_constraint.constant = 0
            }
            
            if isComingFrom == "SearchTab"{
                let s = self.sub[indexPath.row - 1]
                cell.lbl_description.text = s.name
                cell.lbl_count.text = s.grade
            }else{
                let s = self.subject_detail[indexPath.row - 1]
                cell.lbl_description.text = s["name"] as? String
                cell.lbl_count.text = s["grade"] as? String
            }
            
           
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 100
        } else {
            if indexPath.row == 1 {
                return 100
            } else {
                return 40
            }
            
        }
    }
    
}

