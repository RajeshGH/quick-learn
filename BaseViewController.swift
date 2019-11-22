//
//  BaseViewController.swift
//  QuickLearn
//
//  Created by Xtreem Solution on 18/02/19.
//  Copyright © 2019 XtreemSolution. All rights reserved.
//

import UIKit
import MBProgressHUD
class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.currentNavigationController = self.navigationController
        
        // Do any additional setup after loading the view.
    }
    

    //hud show and hide
    
    func hudShow()  {
        
        self.showNetworkActivityIndicator()
        let hud =  MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "Loading..."
    }
    func hudHide()  {
        self.hideNetworkActivityIndicator()
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func showNetworkActivityIndicator() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    func hideNetworkActivityIndicator() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    // To Hide navegation bar
    func hideNavigationBar(){
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    // To Show navegation bar
    func showNavigationBar(){
        self.navigationController?.isNavigationBarHidden = false
    }
    //  Disable all option (copy, paste, delete.....etc)
   
    func setTitle(lblTitle: String){
        
        let backButton:UIBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "back_arrow"), style: .plain, target: self, action: #selector(btnBack_didSelect))
        backButton.tintColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1)
        
        
        let lbl = UILabel()
        lbl.frame = CGRect(x: 0, y: 0, width: (self.navigationController?.navigationBar.frame.width)! - 60, height: (self.navigationController?.navigationBar.frame.height)!)
      
        lbl.textColor = UIColor(red: 67.0/255.0, green: 49.0/255.0, blue: 185.0/255.0, alpha: 1)
        lbl.font = UIFont(name: "Montserrat-ExtraBold", size: 19)
        lbl.text = lblTitle
        lbl.tintColor = UIColor(red: 67.0/255.0, green: 49.0/255.0, blue: 185.0/255.0, alpha: 1)
        
        let titleButton:UIBarButtonItem = UIBarButtonItem.init(customView: lbl)
//        let titleButton:UIBarButtonItem = UIBarButtonItem.init(title: lblTitle, style: .plain, target: nil, action: nil)
//        titleButton.setTitleTextAttributes(
//            [
//                NSAttributedString.Key.font : UIFont(name: "Montserrat-ExtraBold", size: 19)!,
//                NSAttributedString.Key.foregroundColor :UIColor(red: 67.0/255.0, green: 49.0/255.0, blue: 185.0/255.0, alpha: 1),
//                ], for: .normal)
//        titleButton.tintColor = UIColor(red: 67.0/255.0, green: 49.0/255.0, blue: 185.0/255.0, alpha: 1)
    
        //NSArray *actionButtonItems = @[shareItem, cameraItem];
        
//        let titleButton = UIBarButtonItem()
//        titleButton.target = nil
//        titleButton.action = nil
//        titleButton.setTitleTextAttributes([
//            NSAttributedString.Key.font : UIFont(name: "Montserrat-ExtraBold", size: 19)!,
//            NSAttributedString.Key.foregroundColor : UIColor(red: 67.0/255.0, green: 49.0/255.0, blue: 185.0/255.0, alpha: 1),
//            ], for: .normal)
//        titleButton.title = lblTitle
//        titleButton.style = .plain
//        titleButton.isEnabled = false
        
        self.navigationItem.leftBarButtonItems = [backButton,titleButton]
    }
    @objc func btnBack_didSelect(){
        print("Back clicked")
        self.navigationController?.popViewController(animated: true)
    }
    
    func addRightBarButtonWithImage(strImageName:String){
        
        let btnRight = UIButton(frame: CGRect(x: self.view.frame.width, y: 0, width: 44, height: 44))
        btnRight.setImage(UIImage(named: strImageName), for: UIControl.State.normal)
        
        btnRight.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        btnRight.contentHorizontalAlignment = .left
        btnRight.contentMode = .scaleAspectFit
        btnRight.backgroundColor = UIColor.clear
        
        btnRight.addTarget(self, action: #selector(rightBarButton_didSelect), for: .touchUpInside)
        
        let barButton = UIBarButtonItem(customView: btnRight)
        self.navigationItem.rightBarButtonItem = barButton
    }
    @objc func rightBarButton_didSelect(){
        print("Right button clicked")
    }
    
    func getAddressForLatLng(latitude: String, longitude: String) -> String {
    let url = NSURL(string: "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(latitude),\(longitude)&key=AIzaSyCEOhGXvzgh4UlUDBggTIdnQgBvPng6-k0")
    let data = NSData(contentsOf: url! as URL)
    if data != nil {
    let json = try! JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
    if let result = json["results"] as? NSArray {
    if result.count > 0 {
    if let addresss:NSDictionary = result[0] as! NSDictionary {
    if let address = addresss["address_components"] as? NSArray {
    var newaddress = ""
    var number = ""
    var street = ""
    var city = ""
    var state = ""
    var zip = ""
    
    if(address.count > 1) {
    number = (address.object(at: 0) as! NSDictionary)["short_name"] as! String
    }
    if(address.count > 2) {
    street = (address.object(at: 1) as! NSDictionary)["short_name"] as! String
    }
    if(address.count > 3) {
    city = (address.object(at: 2) as! NSDictionary)["short_name"] as! String
    }
    if(address.count > 4) {
    state = (address.object(at: 4) as! NSDictionary)["short_name"] as! String
    }
    if(address.count > 6) {
    zip = (address.object(at: 6) as! NSDictionary)["short_name"] as! String
    }
    newaddress = "\(number) \(street), \(city), \(state) \(zip)"
    return newaddress
    }
    else {
    return ""
    }
    }
    } else {
    return ""
    }
    }
    else {
    return ""
    }
    
    } else {
    return ""
    }
    
    }
}
