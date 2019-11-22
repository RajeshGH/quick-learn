//
//  TermsAndConditionVC.swift
//  QuickLearn
//
//  Created by Xtreem Solution on 04/03/19.
//  Copyright © 2019 XtreemSolution. All rights reserved.
//

import UIKit

class TermsAndConditionVC: BaseViewController {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        webView.scrollView.bounces = false
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.backgroundColor = .white
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.getTermsAndConditionData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //To Show Navigation controller
        self.showNavigationBar()
        self.setTitle(lblTitle: "Terms and condition")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.setTitle(lblTitle: "Terms and condition")
    }
    func getTermsAndConditionData() {
        self.hudShow()
        var userInfo = [String : Any]()
        userInfo["slug"] = "terms-condition"
        ServiceClass.sharedInstance.hitserviceToGetTermsAndConditionData(userInfo,  completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
            self.hudHide()
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                //  self.makeToast(parseData["message"].string!)
                var description = parseData["description"].string!
                
                description = description.replacingOccurrences(of: "<ol>", with: "")
                description = description.replacingOccurrences(of: "</ol>", with: "")
                
                //description = description.replacingOccurrences(of: "<li>", with: "")
                // description = description.replacingOccurrences(of: "</li>", with: "")
                
                description = description.replacingOccurrences(of: "\n", with: "")
                description = description.replacingOccurrences(of: "\t", with: "")
                description = description.replacingOccurrences(of: "<li>", with: "<li style=\"list-style-type: none\"")
                
                
                description = description.replacingOccurrences(of: "<p", with: "<p style='text-align:left'")
                // description = description.replacingOccurrences(of: "&nbsp", with:"<>")
                
                for i in 0..<50 {
                    
                    let str = "<ol start=\"\(i)\">"
                    description = description.replacingOccurrences(of: str, with: "")
                }
                
                
                print(description)
                self.webView.loadHTMLString("<html><body style='text-align:left'>\(description)</body></html>",
                    baseURL: nil)
            } else {
                
                AppHelper.showALertWithTag(0, title: "Alert", message: (errorDict?[ServiceKeys.keyErrorMessage] as? String)!, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            }
        })
        
    }
//    func getTermsAndConditionData() {
//        var userInfo = [String : Any]()
//        userInfo["name"] = self.txtName!.text
//        userInfo["email"] = self.txtEmail.text
//        userInfo["phone_number"] = self.txtPhone.text
//        userInfo["message"] = self.txtViewMessage.text
//        self.hudShow()
//
//        ServiceClass.sharedInstance.hitserviceToGetTermsAndConditionData(userInfo,  completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
//            self.hudHide()
//            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
//                AppHelper.showALertWithTag(0, title: "Alert", message: parseData["message"].string!, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
//                self.navigationController?.popViewController(animated: true)
//            }else {
//                AppHelper.showALertWithTag(0, title: "Alert", message: (errorDict?[ServiceKeys.keyErrorMessage] as? String)!, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
//            }
//        })
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
