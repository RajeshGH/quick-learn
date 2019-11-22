//
//  RequestVC.swift
//  QuickLearn
//
//  Created by Xtreem Solution on 12/03/19.
//  Copyright © 2019 XtreemSolution. All rights reserved.
//

import UIKit
import GooglePlaces
import BraintreeDropIn
import Braintree
class RequestVC: BaseViewController,setLocationDelegate {
    
    // IBOutlets
    @IBOutlet weak var txtDate: SkyFloatingLabelTextField?
    @IBOutlet weak var txtStartTime: SkyFloatingLabelTextField?
    @IBOutlet weak var txtEndTime: SkyFloatingLabelTextField?
    @IBOutlet weak var txtLocation: SkyFloatingLabelTextField?
    @IBOutlet weak var txtSubjectName: SkyFloatingLabelTextField?
    @IBOutlet weak var txtAmount: SkyFloatingLabelTextField?
    @IBOutlet weak var txtViewMessage: UITextView?
    @IBOutlet weak var btnPay: UIButton!
    @IBOutlet weak var btnLocation: UIButton!
    
    // String to hold navigation Title
    var strTutorName = ""
    // Array to show subject list of tutor
    var arrSubject = [[String:String]]()
    var arrSelectedSubjectCode = [String]()
    var strTutorId = ""
    var strTutorHourlyRate = ""
    var strAdminCharge = ""
    var strSelectedLatitude = ""
    var strSelectedLongitude = ""
    var totalAmount:Float = 0.0
    
    // Date picker to pick date
    var pickerDate = UIDatePicker()
    let pickerSubject = UIPickerView()
    let pickerStartTime = UIPickerView()
    let pickerEndTime = UIPickerView()
    
    var arrTime = [String]()
    var arrTimeSlot = [String]()
    var selectedStartTime: String = ""
    var selectedStartIndex:String = ""
    var selectedEndTime: String = ""
    var selectedEndIndex:String = ""
    var selectedHours:Float = 0.0
    var strPaymentToken = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // To set UI of page
        
        self.txtDate?.delegate = self
        self.txtStartTime?.delegate = self
        self.txtEndTime?.delegate = self
        self.txtLocation?.delegate = self
        self.txtSubjectName?.delegate = self
        self.txtAmount?.delegate = self
        self.txtAmount?.isUserInteractionEnabled = false
        self.txtViewMessage!.delegate = self
        self.txtViewMessage!.text = "Please write here..."
        self.txtViewMessage!.textColor = .lightGray
        self.txtViewMessage!.layer.cornerRadius = 5
        self.txtViewMessage!.layer.borderWidth = 1
        self.txtViewMessage!.layer.borderColor = UIColor(red: 206.0/255.0, green: 206.0/255.0, blue: 206.0/255.0, alpha: 1).cgColor
        self.txtViewMessage!.layer.masksToBounds = true
        
        //self.txtAmount?.text = ConstantKeys.euro_sign + " " + "100"

//        self.txtDate?.inputView = self.pickerDate
//        self.pickerDate.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControl.Event.valueChanged)
        self.pickerStartTime.delegate = self
        self.pickerEndTime.delegate = self
        self.txtStartTime?.inputView = self.pickerStartTime
        self.txtEndTime?.inputView = self.pickerEndTime
        
        self.pickerSubject.delegate = self
        self.txtSubjectName?.inputView = self.pickerSubject
        
        self.arrTimeSlot = ["AM","PM"]
        self.arrTime = ["12:00","12:30","1:00","1:30","2:00","2:30","3:00","3:30","4:00","4:30","5:00","5:30","6:00","6:30","7:00","7:30","8:00","8:30","9:00","9:30","10:00","10:30","11:00","11:30"]
        
      
        
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //To Show Navigation controller
        self.showNavigationBar()
        self.setTitle(lblTitle: strTutorName)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.setTitle(lblTitle: strTutorName)
    }
    // MARK: -  IBActions 
    @IBAction func btnLocation_didSelect(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "locationVC") as? LocationVC
        vc?.locationDelegate = self
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func btnPay_didSelect(_ sender: Any) {
      
        if self.checkValidation(){
            
            let availableBalance:Double = Double(AppHelper.getStringForKey(ServiceKeys.available_wallet_balance))!
            let requestAmount:Double = Double((self.txtAmount?.text)!)!
            if Double(availableBalance) >= Double(requestAmount){
                self.callApiToRequestTutor()
            }else{
                let alert = UIAlertController(title: "Alert", message: strLowBalanceAlert, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Add Amount", style: .default, handler: { action in
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "walletVC") as? WalletVC
                    vc!.comingFrom = "Request"
                    self.navigationController?.pushViewController(vc!, animated: true)
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                    print("Cancel button Clicked.")
                }))
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        
        
    }
   // MARK: -  Custom Location Delegate 
    func setLocation(strLat: String, strLong: String, address: String) {
        self.strSelectedLatitude = strLat
        self.strSelectedLongitude = strLong
        self.txtLocation?.text = address
    }
    
    // MARK: -  Custom Methods 
    
    func showDropIn(clientTokenOrTokenizationKey: String) {
        let request =  BTDropInRequest()
        let dropIn = BTDropInController(authorization: clientTokenOrTokenizationKey, request: request)
        { (controller, result, error) in
            if (error != nil) {
                print("ERROR")
                print("Error = ",error?.localizedDescription as Any)
            } else if (result?.isCancelled == true) {
                print("CANCELLED")
            } else if let nonce = result?.paymentMethod?.nonce, let amount = self.txtAmount!.text {
                print("Result =",nonce)
                self.strPaymentToken = nonce
               // self.sendRequestPaymentToServer(nonce: nonce, amount: amount)
                
                self.callApiToRequestTutor()
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
    
//    func sendRequestPaymentToServer(nonce: String, amount: String) {
//        let paymentURL = URL(string: "http://localhost/braintree/pay.php")!
//        var request = URLRequest(url: paymentURL)
//        request.httpBody = "payment_method_nonce=\(nonce)&amount=\(amount)".data(using: String.Encoding.utf8)
//        request.httpMethod = "POST"
//
//        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) -> Void in
//            guard let data = data else {
//                print(error!.localizedDescription)
//                return
//            }
//
//            guard let result = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let success = result?["success"] as? Bool, success == true else {
//                print("Transaction failed. Please try again.")
//                return
//            }
//
//            print("Successfully charged. Thanks So Much :)")
//            }.resume()
//    }
    
    func checkValidation() -> Bool {
        self.view.endEditing(true)
        if(self.txtDate!.text!.isBlank){
            self.txtDate!.errorMessage = err_Date_Blank
            self.txtDate!.errorColor = CustomColor.redColor
            return false
        }
       
        if(self.txtStartTime!.text!.isBlank){
            self.txtStartTime!.errorMessage = err_StartTime_Blank
            self.txtStartTime!.errorColor = CustomColor.redColor
            return false
        }

        if(self.txtEndTime!.text!.isBlank){
            self.txtEndTime!.errorMessage = err_EndTime_Blank
            self.txtEndTime!.errorColor = CustomColor.redColor
            return false
        }
        if !self.compareStartTimeAndEndTime(strStartTime: self.txtStartTime!.text!, strEndTime: self.txtEndTime!.text!){
           AppHelper.showALertWithTag(0, title: "Alert", message: err_Time_Compare, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            return false
        }
        
        
        if(self.txtLocation!.text!.isBlank){

            self.txtLocation!.errorMessage = err_Location_Blank
            self.txtLocation!.errorColor = CustomColor.redColor
            return false
        }
        if(self.txtSubjectName!.text!.isBlank){
            //self.makeToast(txt_Enter_Password)
            self.txtSubjectName!.errorColor = CustomColor.redColor
            self.txtSubjectName!.errorMessage = err_subject_blank
            return false
        }
//        if(self.txtAmount!.text!.isBlank){
//
//            self.txtAmount!.errorMessage = err_Enter_Confirm_Password
//            self.txtAmount!.errorColor = CustomColor.redColor
//            return false
//        }
        if(self.txtViewMessage!.text!.isBlank || self.txtViewMessage!.text == "Please write here..."){
            AppHelper.showALertWithTag(0, title: "Alert", message: err_message, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            return false
        }
        
        return  true
    }
    func compareStartTimeAndEndTime(strStartTime:String, strEndTime:String) ->Bool{
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "h:mm a"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "h:mm a"
        
        
        
        guard let startTimeDate = dateFormatterGet.date(from: strStartTime) else {
            print("There was an error decoding the string")
            return false
        }
        guard let endTimeDate = dateFormatterGet.date(from: strEndTime) else {
            print("There was an error decoding the string")
            return false
        }
        
        print(dateFormatterPrint.string(from: startTimeDate))
        print(dateFormatterPrint.string(from: endTimeDate))
        if endTimeDate <= startTimeDate{
            return false
        }else{
            let timeInterval = startTimeDate.timeIntervalSince(endTimeDate)
            self.selectedHours = Float(timeInterval)
            print("Time interval = ",timeInterval)
            print("Time interval = ",self.selectedHours)
            let str = timeInterval.stringFromTimeInterval()
            let hours = timeInterval.floatFromTimeInterval()
            print("Time interval 22 = ",str)
            print("Time interval in hours = ",hours)
            return true
        }
        
    }
    
//    func stringFromTimeInterval(interval: TimeInterval) -> NSString {
//
//        let ti = NSInteger(interval)
//
//        let ms = Int((interval % 1) * 1000)
//
//        let seconds = ti % 60
//        let minutes = (ti / 60) % 60
//        let hours = (ti / 3600)
//
//        return NSString(format: "%0.2d:%0.2d:%0.2d.%0.3d",hours,minutes,seconds,ms)
//    }

    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.txtDate!.text = dateFormatter.string(from: sender.date)
    }
    /*
    tutor_id:
    study_date:
    start_time:
    end_time:
    address:
    latitude:
    longitude:
    message:
    hours:
    subject_id[]:
    */
    func callApiToRequestTutor() {
        self.hudShow()
        
        let startTime = (self.txtDate?.text)! + " " + (self.txtStartTime?.text)!
        let endTime = (self.txtDate?.text)! + " " + (self.txtEndTime?.text)!
        let totalTime:Float = self.getTimeDuration(strStartDate: startTime, strEndDate: endTime)
        var userInfo = [String : Any]()
        userInfo["tutor_id"] =  self.strTutorId
        userInfo["study_date"] = self.txtDate!.text
        userInfo["start_time"] = self.txtStartTime!.text
        userInfo["end_time"] = self.txtEndTime!.text
        userInfo["address"] = self.txtLocation!.text
        userInfo["latitude"] = self.strSelectedLatitude
        userInfo["longitude"] = self.strSelectedLongitude
        userInfo["message"] = self.txtViewMessage!.text
        userInfo["hours"] = totalTime
        userInfo["subject_id"] = self.arrSelectedSubjectCode
        
        
        ServiceClass.sharedInstance.hitServiceToRequestATutor(userInfo,  completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
            self.hudHide()
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                if(parseData["status"].stringValue == "success") {
                    AppHelper.showALertWithTag(0, title: "Alert", message: parseData["message"].string!, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
                    AppHelper.setStringForKey(parseData["data"]["available_balance"].stringValue, key: ServiceKeys.available_wallet_balance)
                    self.navigationController?.popViewController(animated: true)
                }
            }else {
                AppHelper.showALertWithTag(0, title: "Alert", message: (errorDict?[ServiceKeys.keyErrorMessage] as? String)!, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            }
        })
        
    }
    
    func getTimeDuration(strStartDate:String,strEndDate:String)->Float{
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd h:mm a"
        
        let startTo = dateformatter.date(from: strStartDate)
        let endTo = dateformatter.date(from: strEndDate)
        print("Date = ",startTo!)
        print("Date = ",endTo!)
//
//
        let dateComponentsFormatter = DateComponentsFormatter()
        dateComponentsFormatter.allowedUnits = [.hour,.minute]
        dateComponentsFormatter.unitsStyle = .full
        
        let difference = dateComponentsFormatter.string(from: startTo!, to: endTo!)
        let arr = difference?.components(separatedBy: ",")
        let hours = arr![0].components(separatedBy: " ")
        let strHours = hours[0]
        print("Hours = ",strHours)
        var strMinutes = ""
        if (arr?.count)! > 1{
            let minutes = arr![1].components(separatedBy: " ")
            strMinutes = minutes[1]
            print("Minutes = ",Float(strMinutes)!)
        }
       
        
        print("Array =",arr!)
        print("difference = ",difference!)
        
        if strMinutes == ""{
            if strHours == "30"{
                let hour = Float(strHours)!
                let actualHours = hour/60
                 print("Total Time =", Float(strHours)!)
                return actualHours
            }else{
                 print("Total Time =", Float(strHours)!)
                return Float(strHours)!
            }
           
        }else{
             print("Total Time =", Float(strHours)! + (Float(strMinutes)!/60))
            return Float(strHours)! + (Float(strMinutes)!/60)
            
        }
        
    }
    
}
extension RequestVC:UITextFieldDelegate{
    // MARK:- UITextField Delegtes
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.txtDate{
            self.pickerDate = UIDatePicker()
            self.pickerDate.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControl.Event.valueChanged)
            self.pickerDate.datePickerMode = .date
            self.pickerDate.minimumDate = Date()
            textField.inputView = self.pickerDate
            if textField.text == ""{
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = DateFormatter.Style.medium
                dateFormatter.timeStyle = DateFormatter.Style.none
                dateFormatter.dateFormat = "yyyy-MM-dd"
                textField.text = dateFormatter.string(from: Date())
            }
            
        }else if textField == self.txtStartTime{
            if(self.txtDate!.text!.isBlank){
                self.txtDate!.errorMessage = err_Date_Blank
                self.txtDate!.errorColor = CustomColor.redColor
                textField.resignFirstResponder()
            }else{
                if textField.text == ""{
                    textField.text = arrTime[0] + " " + arrTimeSlot[0]
                    self.selectedStartTime = arrTime[0]
                    self.selectedStartIndex = arrTimeSlot[0]
                }
            }
            
        }else if textField == self.txtEndTime{
            if(self.txtDate!.text!.isBlank){
                self.txtDate!.errorMessage = err_Date_Blank
                self.txtDate!.errorColor = CustomColor.redColor
                textField.resignFirstResponder()
            }else{
                if textField.text == ""{
                    textField.text = arrTime[0] + " " + arrTimeSlot[0]
                    self.selectedEndTime = arrTime[0]
                    self.selectedEndIndex = arrTimeSlot[0]
                }
            }
           
        }else if textField == self.txtSubjectName{
            textField.inputView = self.pickerSubject
            if textField.text == ""{
                self.arrSelectedSubjectCode.removeAll()
                let dictSub = self.arrSubject[0]
                self.arrSelectedSubjectCode.append(dictSub["subject_id"]!)
                textField.text = dictSub["subject_name"]!
                print("Selected Subject Code =",self.arrSelectedSubjectCode)
            }
        }
        else if textField == self.txtLocation{
            textField.resignFirstResponder()
            let acController = GMSAutocompleteViewController()
            acController.delegate = self
            present(acController, animated: true, completion: nil)
        }
    }
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
        
        if textField == self.txtStartTime{
            if self.txtEndTime?.text == ""{
                self.txtAmount?.text = ""
                self.totalAmount = 0.0
            }else{
                if !self.compareStartTimeAndEndTime(strStartTime: self.txtStartTime!.text!, strEndTime: self.txtEndTime!.text!){
                    AppHelper.showALertWithTag(0, title: "Alert", message: err_Time_Compare, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
                    self.txtAmount?.text = ""
                    self.totalAmount = 0.0
                }else{
                    self.totalAmount = 0.0
                    let startTime = (self.txtDate?.text)! + " " + (self.txtStartTime?.text)!
                    let endTime = (self.txtDate?.text)! + " " + (self.txtEndTime?.text)!
                    let totalTime:Float = self.getTimeDuration(strStartDate: startTime, strEndDate: endTime)
                    
                    self.totalAmount = totalTime * Float(strTutorHourlyRate)! + Float(strAdminCharge)!
                    self.txtAmount?.text = String(self.totalAmount)
                }
            }
        }
        if textField == self.txtEndTime{
            if self.txtStartTime?.text == ""{
                self.txtAmount?.text = ""
                self.totalAmount = 0.0
            }else{
                if !self.compareStartTimeAndEndTime(strStartTime: self.txtStartTime!.text!, strEndTime: self.txtEndTime!.text!){
                    AppHelper.showALertWithTag(0, title: "Alert", message: err_Time_Compare, delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
                    self.txtAmount?.text = ""
                    self.totalAmount = 0.0
                }else{
                    self.totalAmount = 0.0
                    let startTime = (self.txtDate?.text)! + " " + (self.txtStartTime?.text)!
                    let endTime = (self.txtDate?.text)! + " " + (self.txtEndTime?.text)!
                    let totalTime:Float = self.getTimeDuration(strStartDate: startTime, strEndDate: endTime)

                    
                    self.totalAmount = totalTime * Float(strTutorHourlyRate)! + Float(strAdminCharge)!
                    self.txtAmount?.text = String(self.totalAmount)
                }
                
            }
           
        }
    }
    
}
// MARK:- TextView Delegtes
extension RequestVC : UITextViewDelegate {
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
extension RequestVC: UIPickerViewDelegate, UIPickerViewDataSource{
    // MARK:-  UIPickerViewDataSource,UIPickerViewDelegate 
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == self.pickerSubject{
            return 1
        }else{
            return 2
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.pickerSubject{
            return self.arrSubject.count
        }else if pickerView == self.pickerStartTime{
            //var row = pickerStartTime.selectedRow(inComponent: 0)
           // print("this is the pickerView\(row)")
            if component == 0 {
                return arrTime.count
            }else {
                return arrTimeSlot.count
            }
        }else if pickerView == self.pickerEndTime{
           // var row = pickerEndTime.selectedRow(inComponent: 0)
           // print("this is the pickerView\(row)")
            if component == 0 {
                return arrTime.count
            }else {
                return arrTimeSlot.count
            }
        }
        else{
            return 0
        }
    }
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.pickerSubject{
            
                var arrSubjectName = [String]()
                
                for i in 0..<(self.arrSubject.count)
                {
                    let dictSub = self.arrSubject[i]
                    arrSubjectName.append(dictSub["subject_name"]!)
                }
                return arrSubjectName[row]
        }else if pickerView == self.pickerStartTime{
            if component == 0 {
                return arrTime[row]
            }else {
                return arrTimeSlot[row]
            }
        }else if pickerView == self.pickerEndTime{
            if component == 0 {
                return arrTime[row]
            }else {
                return arrTimeSlot[row]
            }
        }else{
            return nil
        }
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       // recievedTimeString
         if pickerView == self.pickerSubject{
            var arrSubjectName = [String]()
            self.arrSelectedSubjectCode.removeAll()
            for i in 0..<(self.arrSubject.count)
            {
                let dictSub = self.arrSubject[i]
                arrSubjectName.append(dictSub["subject_name"]!)
                
            }
            let dictS = self.arrSubject[row]
            self.arrSelectedSubjectCode.append(dictS["subject_id"]!)
            self.txtSubjectName?.text = arrSubjectName[row]
        }else if pickerView == self.pickerStartTime{
            if component == 0 {
                let selected = self.arrTime[row]
                self.selectedStartTime = selected
            }else {
                let am = self.arrTimeSlot[row]
                self.selectedStartIndex = am
            }
            
            self.txtStartTime!.text = self.selectedStartTime + " " + self.selectedStartIndex
         }else if pickerView == self.pickerEndTime{
            if component == 0 {
                let selected = self.arrTime[row]
                self.selectedEndTime = selected
            }else {
                let am = self.arrTimeSlot[row]
                self.selectedEndIndex = am
            }
            self.txtEndTime!.text = self.selectedEndTime + " " + self.selectedEndIndex
        }
    }
    
}
extension RequestVC: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // Get the place name from 'GMSAutocompleteViewController'
        // Then display the name in textField
        self.txtLocation!.text = place.name
        self.strSelectedLatitude = String(place.coordinate.latitude)
        self.strSelectedLongitude = String(place.coordinate.longitude)
        // Dismiss the GMSAutocompleteViewController when something is selected
        dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // Handle the error
        print("Error: ", error.localizedDescription)
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        // Dismiss when the user canceled the action
        dismiss(animated: true, completion: nil)
    }
}
extension TimeInterval{
    
    func stringFromTimeInterval() -> String {
        
        let time = NSInteger(self)
        
        let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        print("Hours = ",Float(hours))
        return String(format: "%0.2d:%0.2d:%0.2d.%0.3d",hours,minutes,seconds,ms)
        
    }
    func floatFromTimeInterval() -> Float {
        
        let time = NSInteger(self)
        
        let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        print("Hours = ",Float(hours))
        return  Float(hours)//String(format: "%0.2d:%0.2d:%0.2d.%0.3d",hours,minutes,seconds,ms)
        
    }
}
