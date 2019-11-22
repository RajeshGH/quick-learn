//
//  WalletVC.swift
//  QuickLearn
//
//  Created by Xtreem Solution on 11/03/19.
//  Copyright © 2019 XtreemSolution. All rights reserved.
//

import UIKit
import BraintreeDropIn
import Braintree

class WalletVC: BaseViewController{
    
    @IBOutlet weak var lblWalletBalance: UILabel!
    @IBOutlet weak var tblWallet: UITableView!
    @IBOutlet weak var btnAddAmount: UIButton!
    @IBOutlet weak var btnWithdraw: UIButton!
    @IBOutlet weak var ViewHiddenAddAmnt: UIView!
    @IBOutlet weak var btnAddAmnt: UIButton!
    @IBOutlet weak var btnCancelAmnt: UIButton!
    
    @IBOutlet weak var txtAmount: SkyFloatingLabelTextField!
    @IBOutlet weak var viewHiddenNoList: UIView!
    
    var arrTutors = [String]()
    var walletHistoryList:Array = [TutorWalletHistory]()
    
    var strPaymentToken = ""
    var comingFrom = ""
    var localTimeZoneName: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // To set UI of screen
        self.tblWallet.estimatedRowHeight = 54.0
        self.tblWallet.rowHeight = UITableView.automaticDimension
        self.tblWallet.estimatedSectionHeaderHeight = 44.0
        
        self.tblWallet.dataSource = self
        self.tblWallet.delegate = self
        self.txtAmount.delegate = self
        self.localTimeZoneName = TimeZone.current.identifier
        print("Local TimeZone =",localTimeZoneName)

    }
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
            //To Hide Navigation controller
            self.hideNavigationBar()
            self.ViewHiddenAddAmnt.isHidden = true
            self.viewHiddenNoList.isHidden = true
            let availableBalance = AppHelper.getStringForKey(ServiceKeys.available_wallet_balance)
            self.lblWalletBalance.text = ConstantKeys.euro_sign + " " + availableBalance
            self.callApiToGetWalletHistory()
        }
    //
    //    override func viewDidAppear(_ animated: Bool) {
    //        super.viewDidAppear(true)
    //        self.setTitle(lblTitle: "Favourites")
    //    }
    
    // MARK: -  IBActions 
    
    
    @IBAction func btnBack_didSelect(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddAmount_didSelect(_ sender: Any) {
        self.viewHiddenNoList.isHidden = true
        self.ViewHiddenAddAmnt.isHidden = false
    }
    
    @IBAction func btnWithdraw_didSelect(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "withdrawAmountVC") as? WithdrawAmountVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func btnAddAmnt_didSelect(_ sender: Any) {
        if self.checkValidation(){
            self.showDropIn(clientTokenOrTokenizationKey: braintree_tokenization_Key_production)
        }
    }
    
    @IBAction func btnCancelAmnt_didSelect(_ sender: Any) {
        self.ViewHiddenAddAmnt.isHidden = true
        self.txtAmount.text = ""
        if self.walletHistoryList.count > 0{
            //self.tblWallet.reloadData()
        }else{
            self.viewHiddenNoList.isHidden = false
        }
    }
    
    @IBAction func btnFilter_didSelect(_ sender: UIButton) {
        if sender.isSelected == true{
            sender.isSelected = false
            sender.setImage(UIImage(named: "favourite"), for: .normal)
        }else{
            sender.isSelected = true
            sender.setImage(UIImage(named: "favourite_selected"), for: .normal)
        }
    }
    
    // MARK: -  Custom Methods 
    
    func checkValidation() -> Bool {
        self.view.endEditing(true)
        if(self.txtAmount!.text!.isBlank){
            
            self.txtAmount!.errorMessage = err_amount_Blank
            self.txtAmount!.errorColor = CustomColor.redColor
            return false
        }
        return  true
    }
    
    func showDropIn(clientTokenOrTokenizationKey: String) {
        let request =  BTDropInRequest()
        let dropIn = BTDropInController(authorization: clientTokenOrTokenizationKey, request: request)
        { (controller, result, error) in
            if (error != nil) {
                print("ERROR")
                print("Error = ",error?.localizedDescription as Any)
            } else if (result?.isCancelled == true) {
                print("CANCELLED")
            } else if let nonce = result?.paymentMethod?.nonce {
                print("Result =",nonce)
                self.strPaymentToken = nonce
                // self.sendRequestPaymentToServer(nonce: nonce, amount: amount)
                
                self.callApiToAddWalletAmount()
                // Use the BTDropInResult properties to update your UI
                // result.paymentOptionType
                // result.paymentMethod
                // result.paymentIcon
                // result.paymentDescription
            }
            controller.dismiss(animated: true, completion: nil)
        }
        self.present(dropIn!, animated: true, completion: nil)
    }
    
    @objc func callApiToGetWalletHistory(){
        self.viewHiddenNoList.isHidden = true
        self.hudShow()
        var userInfo = [String : Any]()
        userInfo["timezone"] = self.localTimeZoneName
        ServiceClass.sharedInstance.hitServiceToGetWalletHistory(userInfo,  completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
            self.hudHide()
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                if(parseData["status"].stringValue == "success") {
                    self.walletHistoryList.removeAll()
                    AppHelper.setStringForKey(parseData["data"]["wallet_balance"].stringValue, key: ServiceKeys.available_wallet_balance)
                    self.lblWalletBalance.text = ConstantKeys.euro_sign + " " + parseData["data"]["wallet_balance"].stringValue
                    for  data in parseData["data"]["wallet_data"].arrayValue {
                        let record = TutorWalletHistory.init(fromJson: data)
                        self.walletHistoryList.append(record)
                    }
                    print("Wallet History List = ",self.walletHistoryList)
                    if self.walletHistoryList.count > 0{
                      self.tblWallet.reloadData()
                    }else{
//                        self.lblWalletBalance.text = ConstantKeys.euro_sign + " 0.0"
//                        AppHelper.setStringForKey("0.0", key: ServiceKeys.available_wallet_balance)
                        self.viewHiddenNoList.isHidden = false
                    }
                }
            }else {
                
                AppHelper.showALertWithTag(0, title: "Alert", message: (errorDict?[ServiceKeys.keyErrorMessage] as? String)!, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
//                if errorDict?[ServiceKeys.keyErrorMessage] as? String == "No wallet history available." {
//                    self.lblWalletBalance.text = ConstantKeys.euro_sign + " 0.0"
//                    AppHelper.setStringForKey("0.0", key: ServiceKeys.available_wallet_balance)
//                }
            }
        })
    }
    
    func callApiToAddWalletAmount(){
        self.hudShow()
        var userInfo = [String : Any]()
        userInfo["amount"] = self.txtAmount.text
        userInfo["payment_token"] = self.strPaymentToken
        ServiceClass.sharedInstance.hitServiceToAddAmountInWallet(userInfo,  completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
            self.hudHide()
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                if(parseData["status"].stringValue == "success") {
                    
                    AppHelper.showALertWithTag(0, title: "Alert", message: parseData["message"].string!, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
                    AppHelper.setStringForKey(parseData["data"]["available_balance"].stringValue, key: ServiceKeys.available_wallet_balance)
                    if self.comingFrom == "Request"{
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        self.ViewHiddenAddAmnt.isHidden = true
                        self.txtAmount.text = ""
                        self.callApiToGetWalletHistory()
                    }
                    
                    
                }
            }else {
                
                AppHelper.showALertWithTag(0, title: "Alert", message: (errorDict?[ServiceKeys.keyErrorMessage] as? String)!, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
                if errorDict?[ServiceKeys.keyErrorMessage] as? String == "No wallet history available." {
                    print("0")
                }
            }
        })
    }
    
}

extension WalletVC : UITableViewDelegate,UITableViewDataSource{
    
    // MARK:   Table view delefgate and data source 
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.walletHistoryList.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let record = self.walletHistoryList[section]
        let arrHistoryForRecord = record.wallet_record
        return arrHistoryForRecord!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let walletCell = tableView.dequeueReusableCell(withIdentifier: "walletTVCell", for: indexPath) as! WalletTVCell
        walletCell.selectionStyle = .none
        let record = self.walletHistoryList[indexPath.section]
        var historyDetails = [TutorWalletRecord]()
        historyDetails = record.wallet_record
        let history = historyDetails[indexPath.row]
        if history.is_withdraw == "Yes"{
            walletCell.lblStatus.isHidden = false
            walletCell.lblStatus.text = history.withdraw_status
            
            walletCell.imgReceivedOrWithdraw.image = UIImage(named: "withdraw_icon")
            walletCell.lblReceivedOrWithdraw.text = "Withdrew Funds"
            walletCell.lblAmount.text = ConstantKeys.euro_sign + " " + history.withdraw_amount
            walletCell.lblAmount.textColor = CustomColor.borderGrayColor
            walletCell.lblTime.text = history.transaction_time
        }else {
              walletCell.lblStatus.isHidden = true
            if history.is_withdraw == "Request Charge"{
                walletCell.imgReceivedOrWithdraw.image = UIImage(named: "withdraw_icon")
                walletCell.lblReceivedOrWithdraw.text = "Request Charge"
                walletCell.lblAmount.text = ConstantKeys.euro_sign + " " + history.withdraw_amount
                walletCell.lblAmount.textColor = CustomColor.borderGrayColor
                walletCell.lblTime.text = history.transaction_time
            }else{
                walletCell.imgReceivedOrWithdraw.image = UIImage(named: "fundrecived_icon")
                walletCell.lblReceivedOrWithdraw.text = "Fund Received"
                walletCell.lblAmount.text = ConstantKeys.euro_sign + " " + history.added_amount
                walletCell.lblAmount.textColor = CustomColor.greenColor
                walletCell.lblTime.text = history.transaction_time
            }
        }

            return walletCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "tutorDetailsVC") as? TutorDetailsVC
        //        let tutorDetails = self.tutorList[indexPath.row]
        //        vc!.tutorDetailssss = tutorDetails
        //        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 60
        }
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        return UITableView.automaticDimension
//    }
    //    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    //        return nil
    //    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let record = self.walletHistoryList[section]
        return record.transaction_date
       
    }
}

extension WalletVC:UITextFieldDelegate{
    // MARK:- UITextField Delegtes
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let field = textField as! SkyFloatingLabelTextField
        field.errorMessage = ""
        field.errorColor = .clear
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        let field = textField as! SkyFloatingLabelTextField
        field.errorMessage = ""
        field.errorColor = .clear
    }
    
}

    

