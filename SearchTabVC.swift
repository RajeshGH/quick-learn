//
//  SearchTabVC.swift
//  QuickLearn
//
//  Created by Xtreem Solution on 21/02/19.
//  Copyright © 2019 XtreemSolution. All rights reserved.

import UIKit
import Alamofire
import SDWebImage
class SearchTabVC: BaseViewController ,UISearchControllerDelegate,UISearchBarDelegate{

    var searchController = UISearchController()
    var arrFiltered = [String]()
    
    var tutorList:Array = [TutorList]()
    var strRateFrom = ""
    var strRateTo = ""
    var strTopRated = ""
    var arrFilteredSubjectId = [String]()
    var timer:Timer!
    let timeInterval = 0.5
    var strSearchText = ""
    var sub = [TutorSubject]()
    
    @IBOutlet weak var tblSerach: UITableView!
    @IBOutlet weak var viewHiddenNoList: UIView!
    
    enum IntEnum :Int{
        case One = 11
        case Two
        case Three
        }
    
    enum ProfileType: String {
        case guest = "Guest" // default
        case host = "Host"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let currentProfile = ProfileType.guest
        let raw = currentProfile.rawValue
        print("raw value of string = \(raw)")
        // Tuple demo
        
        let errorCodeTuple = (code:200,message:"Success")
        print("Error code = \(errorCodeTuple.0)")
        print("Error message = \(errorCodeTuple.1)")
        print("Error code = \(errorCodeTuple.code)")
        print("Error message = \(errorCodeTuple.message)")
        
        var anotherTuple = errorCodeTuple
        print("errorCodeTuple = \(errorCodeTuple)")
        print("anotherTuple = \(anotherTuple)")
        anotherTuple.code = 500
        anotherTuple.message = "Server Error"
        
        print("errorCodeTuple = \(errorCodeTuple)")
        print("anotherTuple = \(anotherTuple)")
        
        var a = 10
        var b = 15
        
        a = a^b
        b = b^a
        a = a^b
        print("Value of a = \(a) and value of b = \(b)")
        
        
        struct Planet {
            let name: String
            let distanceFromSun: Double
        }
        
        let planets = [
            Planet(name: "Mercury", distanceFromSun: 0.387),
            Planet(name: "Venus", distanceFromSun: 0.722),
            Planet(name: "Earth", distanceFromSun: 1.0),
            Planet(name: "Mars", distanceFromSun: 1.52),
            Planet(name: "Jupiter", distanceFromSun: 5.20),
            Planet(name: "Saturn", distanceFromSun: 9.58),
            Planet(name: "Uranus", distanceFromSun: 19.2),
            Planet(name: "Neptune", distanceFromSun: 30.1)
        ]
        
        let result1 = planets.map { $0.name }
        let result2 = planets.reduce(0) { $0 + $1.distanceFromSun }

        
        // To set UI of screen
        self.tblSerach.estimatedRowHeight = 54.0
        self.tblSerach.rowHeight = UITableView.automaticDimension
        self.tblSerach.estimatedSectionHeaderHeight = 44.0
        
        // To Search controller on navigation bar
        self.tblSerach.dataSource = self
        self.tblSerach.delegate = self

        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.addRightBarButtonWithImage(strImageName:"filter_icon")

        self.searchController = UISearchController(searchResultsController: nil)
        
        navigationItem.searchController = self.searchController
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
       // self.callApiToGetTutorList()
    }
    
//    func passData(Name:String,dataPassed:@escaping completionHandler) -> String{
//        completionHandler()
//        return Name
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.viewHiddenNoList.isHidden = true
        self.callApiToGetTutorList()
        
        
        
//        self.setProfileDataa(strName: "Vikas") { (<#String#>, <#Int#>) -> String in
//            <#code#>
//        }
        
        
        
        self.setProfileDataa() { (Name, Age) -> String in
            print("Name =",Name)
            print("Age =",Age)
            return Name
        }
        self.requestForUserDataWith(["Index":"12"]) { (result, error) in
            print("Result = ",result)
            print("error  = ",error)
        }
    }
    
    typealias completionHandler = (String,Int) ->String
    func setProfileDataa(closure : completionHandler) {
        
        print("Function Called")
        var a = closure("Search Tab",5)
        print("Completion Handler Called and value of a =",a)
    }
    
    func requestForUserDataWith(_ parameters:[String:String], completionHandler:(_ result:[String:Any], _ error:Error) ->Void){
      
        
    }
    // MARK: -  IBActions 
    override func rightBarButton_didSelect() {
        print("Filter clicked")
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "tutorFilterVC") as? TutorFilterVC
        vc?.tutorFilterDelegate = self
        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func btnFavoutite_didSelect(_ sender: UIButton) {
        var userId = ""
        let tutorDetails = self.tutorList[sender.tag]
        userId = tutorDetails.id
        self.callApiToFavouriteATutor(strUserId: userId)
    }
    @IBAction func btnRequest_didSelect(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "requestVC") as? RequestVC
         let tutorDetails = self.tutorList[sender.tag]
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
      //  print("Array without sorting = ",arrTutorSubject)
        arrTutorSubject = (arrTutorSubject as NSArray).sortedArray(using: [NSSortDescriptor(key: "subject_name", ascending: true)]) as! [[String:String]]
        print("Array with sorting = ",arrTutorSubject)
        vc!.arrSubject = arrTutorSubject
        vc!.strTutorHourlyRate = (tutorDetails.hourly_rate)!
        vc!.strAdminCharge = (tutorDetails.admin_commision)!
        vc!.strTutorId = (tutorDetails.id)!
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func btnRating_didSelect(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ratingDetailsVC") as? RatingDetailsVC
        let tutorDetails = self.tutorList[sender.tag]
        vc?.strUserId = tutorDetails.id
        vc?.strUserName = tutorDetails.name
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    // MARK: -  Custom Methods 
    func didDismissSearchController(_ searchController: UISearchController) {
        print("Cancel clicked")
        self.arrFilteredSubjectId.removeAll()
        self.strRateFrom = ""
        self.strRateTo = ""
        self.strSearchText = ""
        self.strTopRated = ""
        self.searchController.searchBar.text = ""
        self.callApiToGetTutorList()
    }
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        print("Cancel clicked")
//        self.arrFilteredSubjectId.removeAll()
//        self.strRateFrom = ""
//        self.strRateTo = ""
//        self.strSearchText = ""
//        self.searchController.searchBar.text = ""
//        self.callApiToGetTutorList()
//    }

    
    func filterContentForSearch(searchString: String)  {
       
       if searchController.isActive && searchController.searchBar.text != "" {
        self.strSearchText = searchController.searchBar.text!
            if (self.timer != nil) {
                self.timer.invalidate()
            }
            
            self.timer = Timer.scheduledTimer(timeInterval: self.timeInterval, target: self, selector:#selector(self.callApiToGetTutorList), userInfo:nil, repeats: false)
        }
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
                    self.callApiToGetTutorList()
                }
            }else {
                AppHelper.showALertWithTag(0, title: "Alert", message: (errorDict?[ServiceKeys.keyErrorMessage] as? String)!, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            }
        })
    }
    
    @objc func callApiToGetTutorList(){
        self.hudShow()
        var userInfo = [String : Any]()
        userInfo["rate_from"] = self.strRateFrom
        userInfo["rate_to"] = self.strRateTo
        userInfo["subject_id"] = self.arrFilteredSubjectId
        userInfo["keyword"] = self.strSearchText
        userInfo["top_rated"] = self.strTopRated
        ServiceClass.sharedInstance.hitServiceToGetTutorList(userInfo,  completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
            self.hudHide()
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                if(parseData["status"].stringValue == "success") {
                    self.tutorList.removeAll()
                    for  data in parseData["data"] as JSON {
                        let tutor = TutorList.init(fromJson: data.1)
                        self.tutorList.append(tutor)
                    }
                    if self.tutorList.count > 0{
                        self.tblSerach.reloadData()
                    }else{
                        self.viewHiddenNoList.isHidden = false
                    }
                }
            }else {
                
                AppHelper.showALertWithTag(0, title: "Alert", message: (errorDict?[ServiceKeys.keyErrorMessage] as? String)!, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            }
        })
    }
    
    

    
}
extension SearchTabVC: UISearchResultsUpdating{
    
    // MARK:-  UISearchResultsUpdating Delegate 
    
    func updateSearchResults(for searchController: UISearchController) {
        self.filterContentForSearch(searchString: searchController.searchBar.text!)
    }
}

//extension SearchTabVC: UISearchControllerDelegate{
//
//}
extension SearchTabVC : UITableViewDelegate,UITableViewDataSource{
    
    // MARK:   Table view delefgate and data source 
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != ""
        {
            return self.tutorList.count
        }
        else
        {
            return self.tutorList.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchCell = tableView.dequeueReusableCell(withIdentifier: "searchTabTVCell", for: indexPath) as! SearchTabTVCell
        searchCell.selectionStyle = .none
        let tutorDetails = self.tutorList[indexPath.row]
        searchCell.btnFavourite.addTarget(self, action: #selector(btnFavoutite_didSelect), for: .touchUpInside)
        searchCell.btnFavourite.tag = indexPath.row
        searchCell.btnRequest.addTarget(self, action: #selector(btnRequest_didSelect), for: .touchUpInside)
        searchCell.btnRequest.tag = indexPath.row
       
        searchCell.btnRating.addTarget(self, action: #selector(btnRating_didSelect), for: .touchUpInside)
        searchCell.btnRating.tag = indexPath.row
        
        if tutorDetails.is_favourite == "No" {
            searchCell.btnFavourite.isSelected = false
            searchCell.btnFavourite.setImage(UIImage(named: "favourite"), for: .normal)
        }else{
            searchCell.btnFavourite.isSelected = true
            searchCell.btnFavourite.setImage(UIImage(named: "favourite_selected"), for: .normal)
        }
        
        if tutorDetails.avg_rating == ""{
            searchCell.lblRating.text = "0.0 "
        }else{
            searchCell.lblRating.text = tutorDetails.avg_rating
        }
//        if searchController.isActive && searchController.searchBar.text != ""{
//           // searchCell.lblTutorName.text = arrFiltered[indexPath.row]
//            print("Search result")
//        }
//        else{
        
        
            searchCell.lblTutorName.text = tutorDetails.name
            searchCell.lblTutorId.text = tutorDetails.username
            searchCell.lblTutorPrice.text = ConstantKeys.euro_sign + " " + tutorDetails.hourly_rate + "/hr"
            
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
            searchCell.lblAddress.text = allSubject
//            searchCell.imgTutor.image = UIImage(named: "no_image_available")
            let pictureBaseUrl = AppHelper.getStringForKey(ServiceKeys.keyPictureBaseURL)
            let imageUrl = pictureBaseUrl + tutorDetails.profile_image
           // Utilities.setImage(url: imageUrl, imageview: searchCell.imgTutor)
            searchCell.imgTutor.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "no_image_available"))
//        }
        
        return searchCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "tutorDetailsVC") as? TutorDetailsVC
        let tutorDetails = self.tutorList[indexPath.row]
        vc!.isComingFrom = "SearchTab"
        //vc!.strStudentId = tutorDetails.id
        
        vc!.tutorDetailssss = tutorDetails
        self.navigationController?.pushViewController(vc!, animated: true)
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
extension SearchTabVC: FilterDelegate{
    func sendFilteredData(arrData: [String], strFromRate: String, strToRate: String,strTopRated:String) {
         print("Filterde Array = ",arrData)
        self.arrFilteredSubjectId = arrData
        self.strRateFrom = strFromRate
        self.strRateTo = strToRate
        self.strTopRated = strTopRated
        self.callApiToGetTutorList()
    }
    
    
}
