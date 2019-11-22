//
//  TutorFilterVC.swift
//  QuickLearn
//
//  Created by Xtreem Solution on 21/02/19.
//  Copyright © 2019 XtreemSolution. All rights reserved.
//

import UIKit

protocol FilterDelegate {
    func sendFilteredData(arrData  : [String],strFromRate:String,strToRate:String,strTopRated:String)
}

class TutorFilterVC: BaseViewController {
    
    var tutorFilterDelegate : FilterDelegate?
    
    @IBOutlet weak var btnCross: UIButton!
    @IBOutlet weak var tblSubject: UITableView!
    @IBOutlet weak var btnTopRated: UIButton!
    @IBOutlet weak var lblEuroFrom: UILabel!
    @IBOutlet weak var txtFromRate: UITextField!
    @IBOutlet weak var txtToRate: UITextField!
    @IBOutlet weak var lblEuroToSign: UILabel!
    @IBOutlet weak var btnApply: UIButton!

    var arrSelectedSubjectCode = [String]()
    var arrayCheckUnchek = [String]()// Will handle which button is selected or which is unselected
    var subjectList:Array = [SchoolSubjectList]()
    var strTopRate = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         // To set UI of screen
        self.btnTopRated.isSelected = false
        self.tblSubject.delegate = self
        self.tblSubject.dataSource = self
        self.tblSubject.estimatedRowHeight = 54.0
        self.tblSubject.rowHeight = UITableView.automaticDimension
        self.lblEuroFrom.text = "\u{00A3}"
        self.lblEuroToSign.text = "\u{00A3}"
        self.callApiToGetSubjectList()
    }

    // MARK: -  IBActions 
    @IBAction func btnTopRated_didSelect(_ sender: Any) {
        if self.btnTopRated.isSelected == true{
            self.btnTopRated.isSelected = false
            self.btnTopRated.setImage(UIImage(named: "check_button"), for: .normal)
            self.strTopRate = "No"
        }else{
            self.btnTopRated.isSelected = true
           self.btnTopRated.setImage(UIImage(named: "active_check_button"), for: .normal)
            self.strTopRate = "Yes"
        }
    }
    @IBAction func btnCross_didSelect(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnApply_didSelect(_ sender: Any) {
        //let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "tutorFilterVC") as? TutorFilterVC
       // vc?.tutorFilterDelegate = self as? FilterDelegate
        if tutorFilterDelegate != nil {
            tutorFilterDelegate?.sendFilteredData(arrData: self.arrSelectedSubjectCode, strFromRate: self.txtFromRate.text!, strToRate: self.txtToRate.text!, strTopRated: self.strTopRate)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func btnSubject_didSelect(_sender : UIButton)
    {
        let index = _sender.tag
        let indexPath = IndexPath(row: index, section: 0)
        let cell = self.tblSubject.cellForRow(at:indexPath ) as! TutorFilterTVCell
        let arrSub = self.subjectList[indexPath.row]
        if arrayCheckUnchek[index] == "Uncheck"
        {
            cell.btnSubject.setImage(UIImage(named: "active_check_button"), for: .normal)
            arrayCheckUnchek[index] = "Check"
            
            self.arrSelectedSubjectCode.append(arrSub.id)
            print("Selected Subject code = ",self.arrSelectedSubjectCode)
        }
        else
        {
            cell.btnSubject.setImage(UIImage(named: "check_button"), for: .normal)
            arrayCheckUnchek[index] = "Uncheck"
            
            if arrSelectedSubjectCode.contains(arrSub.id)
            {
                let n = self.arrSelectedSubjectCode.index(of:arrSub.id)
                arrSelectedSubjectCode.remove(at: n!)
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
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                //                var dictSubject:NSDictionary = NSDictionary()
                //                dictSubject = parseData["data"].dictionaryObject! as NSDictionary
                if(parseData["status"].stringValue == "success") {
                    self.subjectList.removeAll()
                    for  data in parseData["data"] as JSON {
                        let subject = SchoolSubjectList.init(fromJson: data.1)
                        self.subjectList.append(subject)
                    }
                }
                
                if self.subjectList.count > 0 {
                    for i in 0..<(self.subjectList.count)
                    {
                        self.arrayCheckUnchek.append("Uncheck")
                        if i == self.subjectList.count - 1{
                            self.tblSubject.reloadData()
                        }
                    }
                    
                }
            }else {
                
                AppHelper.showALertWithTag(0, title: "Alert", message: (errorDict?[ServiceKeys.keyErrorMessage] as? String)!, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            }
        })
    }
    
}
extension TutorFilterVC : UITableViewDelegate,UITableViewDataSource{
    
    // MARK:   Table view delefgate and data source 
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.subjectList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchCell = tableView.dequeueReusableCell(withIdentifier: "tutorFilterTVCell", for: indexPath) as! TutorFilterTVCell
        searchCell.selectionStyle = .none
        let subject = self.subjectList[indexPath.row]
        searchCell.lblSubject.text = subject.name
        searchCell.btnSubject.addTarget(self, action: #selector(btnSubject_didSelect), for: .touchUpInside)
        searchCell.btnSubject.tag = indexPath.row
        if arrayCheckUnchek[indexPath.row] == "Uncheck"
        {
            searchCell.btnSubject.setImage(UIImage(named: "check_button"), for: .normal)
        }
        else
        {
            searchCell.btnSubject.setImage(UIImage(named: "active_check_button"), for: .normal)
        }
       
        return searchCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
