//
//  AppDelegate.swift
//  QuickLearn
//
//  Created by Ajay Vyas on 14/02/19.
//  Copyright © 2019 XtreemSolution. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import Braintree
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var currentNavigationController: UINavigationController?
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if AppHelper.getStringForKey(ServiceKeys.device_token) == ""{
            AppHelper.setStringForKey("123456", key: ServiceKeys.device_token)
        }
        // For push notification
        self.registerForPushNotifications()
        UNUserNotificationCenter.current().delegate = self
        
        // To change the text position in UITabBar
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5)
        
        // Add url Scheme to enable payment with paypal
         BTAppSwitch.setReturnURLScheme("com.QwikLearn.com.QwikLearn.paypalPayment")
        // Set the Google Place API's autocomplete UI control
        GMSPlacesClient.provideAPIKey(google_Places_Api_Key)
        
        // Set the google map api key
        GMSServices.provideAPIKey(google_Places_Api_Key)
        
        // To give delay in launch
        Thread.sleep(forTimeInterval: 2.0)
        
        // To enable IQKeyboardManager
        IQKeyboardManager.shared.enable = true
       
        
        // Check if launched from notification
        let notificationOption = launchOptions?[.remoteNotification]
        
        // 1
        if let notification = notificationOption as? [String: AnyObject],
            let aps = notification["aps"] as? [String: AnyObject] {
            
            // 2
            //NewsItem.makeNewsItem(aps)
             print("Notification payload with launch = ",aps)
            // 3
            (window?.rootViewController as? UITabBarController)?.selectedIndex = 1
        }
        
        
        if AppHelper.getBoolForKey(ServiceKeys.KeyAleradyLogin) == true {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "tabBarVC") as! TabBarVC
            self.window?.rootViewController = controller
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "NavVC") as! UINavigationController
            self.window?.rootViewController = controller
        }
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        if url.scheme?.localizedCaseInsensitiveCompare("com.QwikLearn.com.QwikLearn.paypalPayment") == .orderedSame {
            return BTAppSwitch.handleOpen(url, options: options)
        }
        return false
    }
    
    // If you support iOS 8, add the following method.
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if url.scheme?.localizedCaseInsensitiveCompare("com.QwikLearn.com.QwikLearn.paypalPayment") == .orderedSame {
            return BTAppSwitch.handleOpen(url, sourceApplication: sourceApplication)
        }
        return false
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        
        AppHelper.setStringForKey(token, key: ServiceKeys.device_token)
        
    }
    // This function will be called right after user tap on the notification
    func application(_ application: UIApplication,didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler:@escaping (UIBackgroundFetchResult) -> Void
        ) {
        guard let aps = userInfo["aps"] as? [String: AnyObject] else {
            completionHandler(.failed)
            return
        }
       // NewsItem.makeNewsItem(aps)
        //completionHandler(.newData)
        print("Notification payload with background = ",aps)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("User info = ",userInfo)
    }

    
    func logoutAlert(message:String) {
        let alertController = UIAlertController(title: "QwikLearn", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
            UIAlertAction in
            
            // Redirect to login screen
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "NavVC") as! UINavigationController
            self.window?.rootViewController = controller
            
            let deviceToken = AppHelper.getStringForKey(ServiceKeys.device_token)
            // To remove all UserDefaults
            let domain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
            print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
            
            AppHelper.setStringForKey(deviceToken, key: ServiceKeys.device_token)
            AppHelper.setBoolForKey(false, key: ServiceKeys.KeyAleradyLogin)
            
        }
        alertController.addAction(cancelAction)
        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }

    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound]) {
                [weak self] granted, error in
                
                print("Permission granted: \(granted)")
                guard granted else { return }
                self?.getNotificationSettings()
        }
    }
    func getNotificationSettings() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    func application(_ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void) {

        let userInfo = response.notification.request.content.userInfo
        let aps = userInfo["aps"] as? [String: AnyObject]

        print("Notification payload with foreground = ",aps!)
        
        var notificationType = ""
        if (aps?.count)! > 0{
            notificationType = aps!["type"] as! String
            if notificationType == "withdraw_request_cancel" || notificationType == "withdraw_request_complete"  {
                // Redirect to wallet history  tab
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "tabBarVC") as! TabBarVC
                controller.selectedIndex = 3
                self.window?.rootViewController = controller
                AppHelper.delay(0.3) {
                    // To push to specific view controller
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let walletVC = storyboard.instantiateViewController(withIdentifier: "walletVC") as! WalletVC
                    self.currentNavigationController?.pushViewController(walletVC, animated: true)
                }
            } else if notificationType == "request_complete"{
                // Redirect to booking history received tab
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "tabBarVC") as! TabBarVC
                controller.selectedIndex = 3
                self.window?.rootViewController = controller
                AppHelper.delay(0.3) {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let walletVC = storyboard.instantiateViewController(withIdentifier: "bookingHistoryVC") as! BookingHistoryVC
                    self.currentNavigationController?.pushViewController(walletVC, animated: true)
                }
            }else if notificationType == "request_accept"{
                // Redirect to upcoming tab
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "tabBarVC") as! TabBarVC
                controller.selectedIndex = 2
                self.window?.rootViewController = controller
                AppHelper.delay(0.3) {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "upcomingTabVC") as! UpcomingTabVC
                    vc.comingFrom = "Notificaion"
                    self.currentNavigationController?.pushViewController(vc, animated: true)
                }
            }else if notificationType == "request_reject"{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "tabBarVC") as! TabBarVC
                controller.selectedIndex = 3
                AppHelper.delay(0.3) {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let bookingVC = storyboard.instantiateViewController(withIdentifier: "bookingHistoryVC") as! BookingHistoryVC
                    bookingVC.comingFrom = "Notificaion"
                    self.currentNavigationController?.pushViewController(bookingVC, animated: true)
                }
                self.window?.rootViewController = controller
            }else if notificationType == "study_request"{
                 // Redirect to search tab
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "tabBarVC") as! TabBarVC
                controller.selectedIndex = 1
                self.window?.rootViewController = controller
            }
        }
        switch UIApplication.shared.applicationState {
        case .active:
            print("\n Status = Active")
            //app is currently active, can update badges count here
            break
        case .inactive:
            print("\n Status = Inactive")
            //app is transitioning from background to foreground (user taps notification), do what you need when user taps here
            break
        case .background:
            print("\n Status = Background")
            //app is in background, if content-available key of your notification is set to 1, poll to your backend to retrieve data and update your interface here
            break
        default:
            break
        }
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
        
    }
    
    
}

