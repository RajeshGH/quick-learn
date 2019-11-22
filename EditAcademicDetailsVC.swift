//
//  EditAcademicDetailsVC.swift
//  QuickLearn
//
//  Created by Xtreem Solution on 27/02/19.
//  Copyright © 2019 XtreemSolution. All rights reserved.
//

import UIKit

class EditAcademicDetailsVC:  BaseViewController {
    
    // IBOutlets
    @IBOutlet weak var tblAcademicDetails: UITableView!
    
    
    @IBOutlet weak var imgCheckSchool: UIImageView!
    
    @IBOutlet weak var imgCheckUniversity: UIImageView!
    
    @IBOutlet weak var imgYearDropdown: UIImageView!
    @IBOutlet weak var txtSchoolName: SkyFloatingLabelTextField?
    @IBOutlet weak var txtYear: SkyFloatingLabelTextField?
    
    @IBOutlet weak var btnSchool: UIButton!
    @IBOutlet weak var btnUniversity: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var btnSelectSubject: UIButton!
    @IBOutlet weak var collectionSubject: UICollectionView!
    
    
    @IBOutlet weak var viewHiddenSubject: UIView!
    @IBOutlet weak var tblSubject: UITableView!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnCross: UIButton!
    
    var arrSubjectCode = [String]()
    var arrSelectedSubjectCode = [String]()
    var arrayCheckUnchek = [String]()// Will handle which button is selected or which is unselected
    var subjectList:Array = [SchoolSubjectList]()
    var schoolNameList:Array = [SchoolNameList]()
    var universityNameList:Array = [UniversityNameList]()
    var arrYears = [String]()
     var arrGrade = [String]()
    var arrSelectedSubject = [String]()
    
    let yearPicker = UIPickerView()
    let namePicker = UIPickerView()
    let gradePicker = UIPickerView()
    var userInfoPersonalDetails = [String : Any]()
    var strIsSchoolOrUniversity = ""
    var arrSelectedSubjectGrade = [String]()
    var selectedNameId = ""
     var indexGradeTxt:Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // To set UI of screen
        self.tblAcademicDetails.estimatedRowHeight = 54.0
        self.tblAcademicDetails.rowHeight = UITableView.automaticDimension
       
        self.btnUniversity.isSelected = false
        self.btnSchool.setCornerRadius(button: self.btnSchool, cornerRadius: 5)
        self.btnSchool.setBorder(button: self.btnSchool, color: CustomColor.borderGrayColor)
        self.btnUniversity.setCornerRadius(button: self.btnUniversity, cornerRadius: 5)
        self.btnUniversity.setBorder(button: self.btnUniversity, color: CustomColor.borderGrayColor)
        self.btnNext.setCornerRadius(button: self.btnNext, cornerRadius: 5)
        self.btnNext.setTitle("SAVE", for: .normal)
        
         self.arrYears = ["1","2","3","4","5","6","7","8","9","10","11","12","13"]
        self.arrGrade = ["0","1","2","3","4","5","6","7","8","9"]
        self.yearPicker.delegate = self
        self.txtYear?.inputView = self.yearPicker
        
        self.namePicker.delegate = self
        self.txtSchoolName?.inputView = self.namePicker
        
        self.txtYear?.delegate = self
        self.txtYear!.tag = 100
        self.txtSchoolName?.delegate = self
        
        self.gradePicker.delegate = self
        
        self.collectionSubject.dataSource = self
        self.collectionSubject.delegate = self
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top:0,left:0,bottom:0,right:0)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: self.collectionSubject.bounds.width/3 - 10, height: 36)
        self.collectionSubject.collectionViewLayout = layout
        
        // *****************
        self.viewHiddenSubject.isHidden = true
        self.tblSubject.estimatedRowHeight = 54.0
        self.tblSubject.rowHeight = UITableView.automaticDimension
        self.tblSubject.delegate = self
        self.tblSubject.dataSource = self
        
        // To get school subject List
        self.callApiToGetSubjectList()
        self.arrSubjectCode = ["1","2","3","4","5","6","7","8","9","10","11","12","13"]
        setProfileData()
        // **************
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //To Show Navigation controller
        self.showNavigationBar()
        self.setTitle(lblTitle: "Academic Portfolio")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.setTitle(lblTitle: "Academic Portfolio")
    }
    
    
    
    func setProfileData() {
        // UserLoginData.shared.picture_url
        self.txtSchoolName!.text = MyProfileDetails.shared.education_name
        self.txtYear!.text = MyProfileDetails.shared.year
        if let my_pro =  MyProfileDetails.shared.study_type {
        self.strIsSchoolOrUniversity = my_pro
        } else {
              self.strIsSchoolOrUniversity = "School"
        }
        
         let arr = MyProfileDetails.shared.subject_detail
        if self.strIsSchoolOrUniversity == "School" {
            self.arrYears = ["1","2","3","4","5","6","7","8","9","10","11","12","13"]
            if let id =   MyProfileDetails.shared.school_id {
            self.selectedNameId = id
                self.btnSchool.isSelected = true
                if self.btnSchool.isSelected == true {
                    self.btnSchool.setBorder(button: self.btnSchool, color: CustomColor.borderThemeColor)
                    self.imgCheckSchool.image = UIImage(named: "radio_button_Checked")
                    self.strIsSchoolOrUniversity = "School"
                }
            }
        } else {
            self.arrYears = ["1","2","3"]
            self.btnUniversity.isSelected = true
            if self.btnUniversity.isSelected == true{
                self.btnUniversity.setBorder(button: self.btnUniversity, color: CustomColor.borderThemeColor)
                self.imgCheckUniversity.image = UIImage(named: "radio_button_Checked")
                self.strIsSchoolOrUniversity = "University"
            }
            
            
            if let id =   MyProfileDetails.shared.university_id {
                self.selectedNameId = id
            }
        }
        print(arr)
        arrSelectedSubject.removeAll()
        arrSelectedSubjectCode.removeAll()
        for selected_sub in arr {
            arrSelectedSubject.append(selected_sub["name"] as! String)
            arrSelectedSubjectCode.append(selected_sub["subject_id"] as! String)
           
            if (self.txtYear?.text == "12" || self.txtYear?.text == "13") && self.strIsSchoolOrUniversity == "School"{
                if let mygrade:String = selected_sub["grade"] as? String {
                    self.arrSelectedSubjectGrade.append(mygrade)
                }else{
                    self.arrSelectedSubjectGrade.append("0")
                }
                
            }
            else{
                self.arrSelectedSubjectGrade.append("0")
            }
        }
        for var i in 0..<subjectList.count {
             let arrSub = self.subjectList[i]
            if arrSelectedSubjectCode.contains(arrSub.id)
            {
                self.arrayCheckUnchek[i] = "Check"
            } else {
                self.arrayCheckUnchek[i] = "Uncheck"
            }
            
        }
        self.tblSubject.reloadData()
        collectionSubject.reloadData()
        if self.txtYear!.text == "12" || self.txtYear!.text == "13" {
//        tblAcademicDetails.reloadData()
            self.tblAcademicDetails.delegate = self
            self.tblAcademicDetails.dataSource = self
        }
        
    }

    
    // MARK: -  IBActions 
    @IBAction func btnSchool_didSelect(_ sender: Any) {
        //self.arrYears = ["1","2","3","4","5","6","7","8","9","10","11","12","13"]
        
        self.txtSchoolName?.resignFirstResponder()
        self.txtYear?.resignFirstResponder()
        self.arrSelectedSubject.removeAll()
        self.arrSelectedSubjectCode.removeAll()
        self.collectionSubject.reloadData()
        self.tblAcademicDetails.reloadData()
        for var i in 0..<self.subjectList.count{
            self.arrayCheckUnchek[i] = "Uncheck"
        }
        self.tblSubject.reloadData()
        
        if self.btnSchool.isSelected == true{
            self.btnUniversity.isSelected = false
            self.btnUniversity.setBorder(button: self.btnUniversity, color: CustomColor.borderGrayColor)
            self.imgCheckUniversity.image = UIImage(named: "radio_button_unCheck")
        }else{
            self.btnSchool.isSelected = true
            self.btnUniversity.isSelected = false
            self.btnSchool.setBorder(button: self.btnSchool, color: CustomColor.borderThemeColor)
            self.btnUniversity.setBorder(button: self.btnUniversity, color: CustomColor.borderGrayColor)
            self.imgCheckUniversity.image = UIImage(named: "radio_button_unCheck")
            self.imgCheckSchool.image = UIImage(named: "radio_button_Checked")
            self.resetSubjectData()
        }
        self.strIsSchoolOrUniversity = "School"
        self.txtSchoolName?.text = ""
    }
    @IBAction func btnUniversity_didSelect(_ sender: Any) {
       // self.arrYears = ["1","2","3"]
        self.txtSchoolName?.resignFirstResponder()
        self.txtYear?.resignFirstResponder()
        self.arrSelectedSubject.removeAll()
        self.arrSelectedSubjectCode.removeAll()
        self.collectionSubject.reloadData()
        self.tblAcademicDetails.reloadData()
        for var i in 0..<self.subjectList.count{
            self.arrayCheckUnchek[i] = "Uncheck"
        }
        self.tblSubject.reloadData()
        if self.btnUniversity.isSelected == true{
            self.btnSchool.isSelected = false
            self.btnSchool.setBorder(button: self.btnSchool, color: CustomColor.borderGrayColor)
            self.imgCheckSchool.image = UIImage(named: "radio_button_unCheck")
        }else{
            self.btnUniversity.isSelected = true
            self.btnSchool.isSelected = false
            self.btnUniversity.setBorder(button: self.btnUniversity, color: CustomColor.borderThemeColor)
            self.btnSchool.setBorder(button: self.btnSchool, color: CustomColor.borderGrayColor)
            self.imgCheckSchool.image = UIImage(named: "radio_button_unCheck")
            self.imgCheckUniversity.image = UIImage(named: "radio_button_Checked")
            self.resetSubjectData()
        }
        self.strIsSchoolOrUniversity = "University"
        self.txtSchoolName?.text = ""
    }
    func resetSubjectData(){
        if self.btnUniversity.isSelected == true{
            self.arrYears = ["1","2","3"]
        }else{
            self.arrYears = ["1","2","3","4","5","6","7","8","9","10","11","12","13"]
        }
        self.txtSchoolName?.resignFirstResponder()
        self.txtYear?.resignFirstResponder()
        self.txtSchoolName?.text = ""
        self.txtYear?.text = ""
        self.arrSelectedSubject.removeAll()
        self.arrSelectedSubjectCode.removeAll()
        self.collectionSubject.reloadData()
        self.tblAcademicDetails.reloadData()
        for var i in 0..<self.subjectList.count{
            self.arrayCheckUnchek[i] = "Uncheck"
        }
        self.tblSubject.reloadData()
    }
    func resetData(){
        self.arrSelectedSubject.removeAll()
        self.arrSelectedSubjectCode.removeAll()
        self.collectionSubject.reloadData()
        self.tblAcademicDetails.reloadData()
        for var i in 0..<self.subjectList.count{
            self.arrayCheckUnchek[i] = "Uncheck"
        }
        self.tblSubject.reloadData()
    }
    @IBAction func btnSelectSubject_didSelect(_ sender: Any) {
        
        //        if self.txtYear?.text != "12" || self.txtYear?.text != "13"{
        //            self.arrSelectedSubject.removeAll()
        //            self.arrSelectedSubjectCode.removeAll()
        //            self.tblAcademicDetails.reloadData()
        //            self.collectionSubject.reloadData()
        //        }
        self.viewHiddenSubject.isHidden = false
        
    }
    
    @IBAction func btnNext_didSelect(_ sender: Any) {
        if checkValidation() == true{
            self.callApiToUpdate()
        }
    }
    
    
    @IBAction func btnCancel_didSelect(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
    
    @IBAction func btnCross_didSelect(_ sender: Any) {
        self.viewHiddenSubject.isHidden = true
        
        
    }
    @IBAction func btnDone_didSelect(_ sender: Any) {
        self.viewHiddenSubject.isHidden = true
        self.collectionSubject.reloadData()
        self.collectionSubject.layoutIfNeeded()
        self.arrSelectedSubjectGrade.removeAll()
        if (self.txtYear?.text == "12" || self.txtYear?.text == "13") && self.strIsSchoolOrUniversity == "School"{
            for i in 0..<self.arrSelectedSubjectCode.count{
                self.arrSelectedSubjectGrade.insert("0", at: i)
            }
            self.tblAcademicDetails.reloadData()
        }
    }
    
    @objc func btnSubject_didSelect(_sender : UIButton)
    {
        let index = _sender.tag
        let indexPath = IndexPath(row: index, section: 0)
        let cell = self.tblSubject.cellForRow(at:indexPath ) as! SignUpAcademicDetailsTVCell
        let arrSub = self.subjectList[indexPath.row]
        if arrayCheckUnchek[index] == "Uncheck"
        {
            cell.btnSubject.setImage(UIImage(named: "active_check_button"), for: .normal)
            arrayCheckUnchek[index] = "Check"
            self.arrSelectedSubject.append(arrSub.name)
            self.arrSelectedSubjectCode.append(arrSub.id)
            print("Selected Subject code = ",self.arrSelectedSubjectCode)
        }else
        {
            cell.btnSubject.setImage(UIImage(named: "check_button"), for: .normal)
            arrayCheckUnchek[index] = "Uncheck"
            
            if arrSelectedSubjectCode.contains(arrSub.id)
            {
                let n = self.arrSelectedSubjectCode.index(of:arrSub.id)
                self.arrSelectedSubject.remove(at: n!)
                self.arrSelectedSubjectCode.remove(at: n!)
                print("Selected Subjects = ",self.arrSelectedSubject)
            }
        }
        self.tblSubject.reloadData()
    }
    
    @objc func btnRemoveSubject_didSelect(_sender : UIButton)
    {
        let index = _sender.tag
        let indexPath = IndexPath(row: index, section: 0)
        //let cell = self.tblAcademicDetails.cellForRow(at:indexPath ) as! SignUpAcademicDetailsTVCell
        //let arrSub = self.subjectList[indexPath.row]
        
        self.arrSelectedSubject.remove(at: indexPath.row)
        self.arrSelectedSubjectCode.remove(at: indexPath.row)
        self.arrSelectedSubjectGrade.remove(at: indexPath.row)
        
        self.tblAcademicDetails.reloadData()
        self.collectionSubject.reloadData()
        
        for i in 0..<(self.subjectList.count)
        {
            let arrSub = self.subjectList[i]
            if arrSelectedSubjectCode.contains(arrSub.id){
                arrayCheckUnchek[i] = "Check"
            }else{
                arrayCheckUnchek[i] = "Uncheck"
            }
        }
        
        self.tblSubject.reloadData()
    }
    // MARK:-  Custom Methods 
    
    func callApiToGetSubjectList(){
        
        let userInfo = [String : Any]()
        self.hudShow()
        
        ServiceClass.sharedInstance.hitServiceToGetSubjectList(userInfo,  completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
            self.hudHide()
            self.callApiToGetSchoolList()
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                if(parseData["status"].stringValue == "success") {
                    for  data in parseData["data"] as JSON {
                        let subject = SchoolSubjectList.init(fromJson: data.1)
                        self.subjectList.append(subject)
                    }
                }
                if self.subjectList.count > 0 {
                    for i in 0..<(self.subjectList.count)
                    {
                        self.arrayCheckUnchek.append("Uncheck")
                    }
                    self.tblSubject.reloadData()
                }
            }else {
                
                AppHelper.showALertWithTag(0, title: "Alert", message: (errorDict?[ServiceKeys.keyErrorMessage] as? String)!, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            }
        })
    }
    
    func callApiToGetSchoolList(){
        
        let userInfo = [String : Any]()
        self.hudShow()
        
        ServiceClass.sharedInstance.hitServiceToGetSchoolList(userInfo,  completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
            self.hudHide()
            self.callApiToGetUniversityList()
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                //                var dictSubject:NSDictionary = NSDictionary()
                //                dictSubject = parseData["data"].dictionaryObject! as NSDictionary
                if(parseData["status"].stringValue == "success") {
                    for  data in parseData["data"] as JSON {
                        let school = SchoolNameList.init(fromJson: data.1)
                        self.schoolNameList.append(school)
                    }
                }
                //                if self.self.schoolNameList.count > 0 {
                //                    for i in 0..<(self.self.schoolNameList.count)
                //                    {
                //                        self.arrayCheckUnchek.append("Uncheck")
                //                    }
                //                    self.tblSubject.reloadData()
                //                }
            }else {
                AppHelper.showALertWithTag(0, title: "Alert", message: (errorDict?[ServiceKeys.keyErrorMessage] as? String)!, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            }
        })
    }
    
    func callApiToGetUniversityList(){
        
        let userInfo = [String : Any]()
        self.hudShow()
        ServiceClass.sharedInstance.hitServiceToGetUniversityList(userInfo,  completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
            self.hudHide()
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                if(parseData["status"].stringValue == "success") {
                    for  data in parseData["data"] as JSON {
                        let university = UniversityNameList.init(fromJson: data.1)
                        self.universityNameList.append(university)
                    }
                }
                
                for var i in 0..<self.subjectList.count {
                    let arrSub = self.subjectList[i]
                    if self.arrSelectedSubjectCode.contains(arrSub.id)
                    {
                        self.arrayCheckUnchek[i] = "Check"
                    } else {
                        self.arrayCheckUnchek[i] = "Uncheck"
                    }
                    
                }
                self.tblSubject.reloadData()
                //                if self.universityNameList.count > 0 {
                //                    for i in 0..<(self.universityNameList.count)
                //                    {
                //                        self.arrayCheckUnchek.append("Uncheck")
                //                    }
                //                    self.tblSubject.reloadData()
                //                }
            }else {
                AppHelper.showALertWithTag(0, title: "Alert", message: (errorDict?[ServiceKeys.keyErrorMessage] as? String)!, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            }
        })
    }
    
    func checkValidation() -> Bool {
        self.view.endEditing(true)
        if(self.txtSchoolName!.text!.isBlank){
            
            self.txtSchoolName!.errorMessage = err_School_Blank
            self.txtSchoolName!.errorColor = CustomColor.redColor
            return false
        }
        if(self.txtYear!.text!.isBlank){
            
            self.txtYear!.errorMessage = err_year_blank
            self.txtYear!.errorColor = CustomColor.redColor
            return false
        }
        if self.arrSelectedSubject.count == 0{
            AppHelper.showALertWithTag(0, title: "Alert", message: err_subject_blank, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            return false
        }
        return  true
    }
    
    /*
     study_type
     university_id
     university_id
     update_step:Three
     name:Testing
     username:testing007
     contact_number:98754548976
     study_type:School
     school_id:1
     :1
     year:12
     subject_id[0]:2
     subject_id[1]:3
     subject_grade[2]:8
     //subject_grade[3]:7
     hourly_rate:17
     
     */
    
    func callApiToUpdate() {
        self.hudShow()
        var userInfo = [String : Any]()
        userInfo["study_type"] = self.strIsSchoolOrUniversity
        if self.strIsSchoolOrUniversity == "School" {
            userInfo["school_id"] = self.selectedNameId
        } else {
            userInfo["university_id"] = self.selectedNameId
        }
        userInfo["year"] = self.txtYear!.text
        
        userInfo["update_step"] = "Two"
        
        userInfo["subject_id"] = self.arrSelectedSubjectCode
       
        if (self.txtYear?.text == "12" || self.txtYear?.text == "13") && self.strIsSchoolOrUniversity == "School"{
            var arrSubWithGrade = [String:Any]()
            for var i in 0..<self.arrSelectedSubjectCode.count{
                let subjectCode = self.arrSelectedSubjectCode[i]
                let subjectGrade = self.arrSelectedSubjectGrade[i]
                arrSubWithGrade[subjectCode] = subjectGrade
            }
            userInfo["subject_grade"] = arrSubWithGrade
        }
        
        ServiceClass.sharedInstance.hitServiceToUpdateProfile(userInfo,  completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
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
    
}
extension EditAcademicDetailsVC : UITableViewDelegate,UITableViewDataSource{
    
    // MARK:   Table view delefgate and data source 
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblAcademicDetails{
            if self.arrSelectedSubject.count > 0 {
                return self.arrSelectedSubject.count
            }
            return 0
        }else{
            if self.subjectList.count > 0 {
                return subjectList.count
            }
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if tableView == tblAcademicDetails{
            let resultCell = tableView.dequeueReusableCell(withIdentifier: "GCSECell", for: indexPath) as! SignUpAcademicDetailsTVCell
            resultCell.selectionStyle = .none
            resultCell.txtCGSEResult.delegate = self
            resultCell.txtCGSEResult.inputView = self.gradePicker
            resultCell.txtCGSEResult.textAlignment = .center
            resultCell.txtSelectedSubject.text = arrSelectedSubject[indexPath.row]
            resultCell.txtCGSEResult.text = "0"
            if self.arrSelectedSubjectGrade.count > 0{
                resultCell.txtCGSEResult.text = self.arrSelectedSubjectGrade[indexPath.row]
            }
            
            resultCell.txtCGSEResult.tag = indexPath.row
            resultCell.btnRemoveSubject.addTarget(self, action: #selector(btnRemoveSubject_didSelect), for: .touchUpInside)
            resultCell.btnRemoveSubject.tag = indexPath.row
            
            return resultCell
        }else{
            let subjectCell = tableView.dequeueReusableCell(withIdentifier: "SubjectCell", for: indexPath) as! SignUpAcademicDetailsTVCell
            subjectCell.selectionStyle = .none
            let arrSub = self.subjectList[indexPath.row]
            subjectCell.lblSubject.text = arrSub.name
            subjectCell.btnSubject.addTarget(self, action: #selector(btnSubject_didSelect), for: .touchUpInside)
            subjectCell.btnSubject.tag = indexPath.row
            if arrayCheckUnchek[indexPath.row] == "Uncheck"
            {
                subjectCell.btnSubject.setImage(UIImage(named: "check_button"), for: .normal)
            }
            else
            {
                subjectCell.btnSubject.setImage(UIImage(named: "active_check_button"), for: .normal)
            }
            return subjectCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //         if tableView == tblAcademicDetails{
        //         }else{
        //
        //        }
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
extension EditAcademicDetailsVC : UITextViewDelegate {
    // MARK:-  TextViewDelegates 
    func textViewDidBeginEditing(_ textView: UITextView) {
        //        self.txtTypeOfMassage.errorMessage = ""
        //        self.txtTypeOfMassage.errorColor = UIColor.lightGray
        //        if textView.textColor == UIColor.lightGray {
        //            textView.text = nil
        //            textView.textColor = UIColor.black
        //        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        //        if textView.text.isEmpty {
        //            textView.text = "Specify Massage Type"
        //            textView.textColor = UIColor.lightGray
        //        }else{
        //        }
    }
    
    
    
}

extension EditAcademicDetailsVC: UIPickerViewDelegate, UIPickerViewDataSource{
    // MARK:-  UIPickerViewDataSource,UIPickerViewDelegate 
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.yearPicker{
            return self.arrYears.count
        }else if pickerView == self.namePicker{
            if self.strIsSchoolOrUniversity == "School"{
                return self.schoolNameList.count
            }else{
                return self.universityNameList.count
            }
            }else{
                return self.arrGrade.count
            }
    }
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.yearPicker{
            return self.arrYears[row]
        }else if pickerView == self.namePicker{
            if self.strIsSchoolOrUniversity == "School"{
                var arrSchoolName = [String]()
                
                for i in 0..<(self.schoolNameList.count)
                {
                    let dictSchool = self.schoolNameList[i]
                    arrSchoolName.append(dictSchool.name)
                }
                return arrSchoolName[row]
            }else{
                var arrUniversityName = [String]()
                for i in 0..<(self.universityNameList.count)
                {
                    let dictUniversity = self.universityNameList[i]
                    arrUniversityName.append(dictUniversity.name)
                }
                return arrUniversityName[row]
            }
        }else{
            return arrGrade[row]
        }
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == self.yearPicker{
            self.txtYear?.text = self.arrYears[row]
            if (self.txtYear?.text == "12" || self.txtYear?.text == "13") && self.strIsSchoolOrUniversity == "School"{
                self.tblAcademicDetails.reloadData()
            }else{
                if self.strIsSchoolOrUniversity == "School"{
                    self.resetData()
                }
            }
        }else if pickerView == self.namePicker{
            if self.strIsSchoolOrUniversity == "School"{
                
                let dictSchool = self.schoolNameList[row]
                self.txtSchoolName?.text = dictSchool.name
                self.selectedNameId = dictSchool.id
            }else{
                let dictUniversity = self.universityNameList[row]
                self.txtSchoolName?.text = dictUniversity.name
                self.selectedNameId = dictUniversity.id
            }
        }else{
            
            let index = self.indexGradeTxt
            let indexPath = IndexPath(row: index, section: 0)
            let cell = self.tblAcademicDetails.cellForRow(at:indexPath ) as! SignUpAcademicDetailsTVCell
            cell.txtCGSEResult.text = self.arrGrade[row]
            self.arrSelectedSubjectGrade[index] = cell.txtCGSEResult.text!
           // self.tblAcademicDetails.reloadData()
        }
    }
}
extension EditAcademicDetailsVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    //MARK: -  UICollectionViewDataSource 
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrSelectedSubject.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let subjectCell = collectionView.dequeueReusableCell(withReuseIdentifier: "subjectCell", for: indexPath as IndexPath)
        var lbl: UILabel = UILabel()
        lbl = subjectCell.viewWithTag(1001) as! UILabel
        lbl.text = arrSelectedSubject[indexPath.row]
        
        return subjectCell
        
        
    }
    
    //MARK: -  UICollectionViewDelegate 
    
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    //    {
    //            let yourWidth = collectionView.bounds.width/3.0 - 10
    //            let yourHeight = collectionView.frame.height/2 - 4
    //            return CGSize(width: yourWidth, height: yourHeight)
    //    }
    //
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        // Do somthing...
    }
}
//MARK: -  UITextField Delegate 
extension EditAcademicDetailsVC:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let field = textField as! SkyFloatingLabelTextField
        field.errorMessage = ""
        field.errorColor = .clear
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag != 100 || textField.tag != 101{
            self.indexGradeTxt = textField.tag
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
       
        if textField.tag == 100 || textField.tag == 101{
            let field = textField as! SkyFloatingLabelTextField
            field.errorMessage = ""
            field.errorColor = .clear
            if self.txtYear?.text == "12" || self.txtYear?.text == "13"{
                self.tblAcademicDetails.delegate = self
                self.tblAcademicDetails.dataSource = self
                self.tblAcademicDetails.reloadData()
            } else {
                self.tblAcademicDetails.delegate = nil
                self.tblAcademicDetails.dataSource = nil
                 self.tblAcademicDetails.reloadData()
            }
        }
     
        
    }
}

