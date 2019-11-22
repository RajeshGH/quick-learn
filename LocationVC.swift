//
//  LocationVC.swift
//  QuickLearn
//
//  Created by Xtreem Solution on 19/03/19.
//  Copyright © 2019 XtreemSolution. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
protocol setLocationDelegate {
    func setLocation(strLat:String,strLong:String,address:String)
}

class LocationVC: BaseViewController {

    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    
    var zoomLevel: Float = 15.0
    
   
    // A default location to use when location permission is not granted.
    let defaultLocation = CLLocation(latitude: 26.96649, longitude: 75.772308)
    
    var selectedLatitude:String = ""
    var selectedLogitude:String = ""
    var selectedAddress:String = ""
    var arrLocation :Array = [[String:String]]()
    fileprivate var dataTask:URLSessionDataTask?
    var locationDelegate: setLocationDelegate?
    let marker = GMSMarker()
    
    var timer:Timer!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the location manager.
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
       
        // Create a map.
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        
        mapView.delegate = self
       // showMarker(position: camera.target)
        // Add the map to the view, hide it until we&#39;ve got a location update.
        view.addSubview(mapView)
        mapView.isHidden = true
        
     //   listLikelyPlaces()
        
        let circleView = UIImageView()
       // circleView.backgroundColor = UIColor.red.withAlphaComponent(0.5)
       
       
        view.addSubview(circleView)
        view.bringSubviewToFront(circleView)
        circleView.translatesAutoresizingMaskIntoConstraints = false

        let heightConstraint = NSLayoutConstraint(item: circleView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60)
        let widthConstraint = NSLayoutConstraint(item: circleView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60)
        let centerXConstraint = NSLayoutConstraint(item: circleView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        let centerYConstraint = NSLayoutConstraint(item: circleView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([heightConstraint, widthConstraint, centerXConstraint, centerYConstraint])
        circleView.image = UIImage(named: "location_marker")
        view.updateConstraints()
//        let imgMarker:UIImageView = UIImageView.init(frame: CGRect(x: circleView.frame.origin.x + 10, y: circleView.frame.origin.y + 10, width: 40, height: 40))
//        imgMarker.image = UIImage(named: "location_black")
//         circleView.addSubview(imgMarker)
        UIView.animate(withDuration: 1.0, animations: {
            self.view.layoutIfNeeded()
            circleView.layer.cornerRadius = circleView.frame.width/2//CGRect.width(circleView.frame)/2
            circleView.clipsToBounds = true
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //To Show Navigation controller
        self.showNavigationBar()
        self.setTitle(lblTitle: "Location")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.setTitle(lblTitle: "Location")
    }
    
    // Populate the array with the list of likely places.
//    func listLikelyPlaces() {
//        // Clean up from previous sessions.
//        likelyPlaces.removeAll()
//
//        placesClient.currentPlace(callback: { (placeLikelihoods, error) in
//            if let error = error {
//                // TODO: Handle the error.
//                print("Current Place error: \(error.localizedDescription)")
//                return
//            }
//            // Get likely places and add to the list.
//            if let likelihoodList = placeLikelihoods {
//                for likelihood in likelihoodList.likelihoods {
//                    let place = likelihood.place
//                    self.likelyPlaces.append(place)
//                }
//                print("Current Address =",self.likelyPlaces)
//            }
//        })
//    }
    
    // MARK: - Navigation

//    // Update the map once the user has made their selection.
//    @IBAction func unwindToMain(segue: UIStoryboardSegue) {
//        // Clear the map.
//        mapView.clear()
//
//        // Add a marker to the map.
//        if selectedPlace != nil {
//            let marker = GMSMarker(position: (self.selectedPlace?.coordinate)!)
//            marker.title = selectedPlace?.name
//            marker.snippet = selectedPlace?.formattedAddress
//            marker.map = mapView
//        }
//    //    listLikelyPlaces()
//    }

    // MARK: -  IBActions 
    @IBAction func btnCurrentLocationCLicked(_ sender: Any) {
        if(self.selectedLatitude.isEqualToString(find: "")) {
            //self.makeToast(NSLocalizedString("Cant find your location", comment: ""))
        }
        else {
            self.selectedAddress = self.getAddressForLatLng(latitude: self.selectedLatitude, longitude: self.selectedLogitude)
            self.hudShow()
            AppHelper.delay(2.0) {
                self.hudHide()
                self.navigationController?.popViewController(animated: true)
                self.locationDelegate?.setLocation(strLat: self.selectedLatitude, strLong: self.selectedLogitude, address: self.selectedAddress)
            }
            
        }
        
    }
    
//    // MARK: -  Custom Methods 
    @objc func getAddress()
    {
        print("FIRE!!!")
        self.selectedAddress = self.getAddressForLatLng(latitude: self.selectedLatitude, longitude: self.selectedLogitude)
        print("Selected Address =",self.selectedAddress)
        self.locationDelegate?.setLocation(strLat: self.selectedLatitude, strLong: self.selectedLogitude, address: self.selectedAddress)
        self.timer.invalidate()
    }
}
// Delegates to handle events for the location manager.
extension LocationVC: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")

        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
//        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
//       // let locationn: CLLocation = locations.last!
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
//        self.selectedLatitude = "\(locValue.latitude)"
//        self.selectedLogitude = "\(locValue.longitude)"
//
//       self.selectedAddress = self.getAddressForLatLng(latitude: self.selectedLatitude, longitude: self.selectedLogitude)
//        print("Selected Address =",self.selectedAddress)
//        self.locationDelegate?.setLocation(strLat: self.selectedLatitude, strLong: self.selectedLogitude, address: self.selectedAddress)
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}
extension LocationVC: GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D){
        marker.position = coordinate
         print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
    }
    //MARK - GMSMarker Dragging
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        print("didBeginDragging")
    }
    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
        print("didDrag")
    }
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        print("didEndDragging")
    }
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        //print("\(position.target.latitude) \(position.target.longitude)")
        self.selectedLatitude = "\(position.target.latitude)"
        self.selectedLogitude = "\(position.target.longitude)"
        if self.timer != nil
        {
            self.timer.invalidate()
            self.timer = nil
        }
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(getAddress), userInfo: nil, repeats: true)
        
        
//        AppHelper.delay(3) {
        
        }
//    }

}
