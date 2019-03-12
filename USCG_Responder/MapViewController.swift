//
//  MapViewController.swift
//  USCG_Responder
//
//  Created by Patrick Flynn on 2/20/19.
//  Copyright © 2019 Patrick Flynn. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    

    // **** INITIALIZE UI ELEMENTS ****
    @IBOutlet weak var LatLabel: UILabel!
    @IBOutlet weak var LongLabel: UILabel!
    @IBOutlet weak var swipUpView: UIView!
    
    @IBOutlet weak var sizingView: UIView!
    
    var mapper: GMSMapView!
    // ********************************
    
    var curLat:Double!
    var curLong:Double!
    
    
    // **** INIT LOCATION MANAGER ****
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    // *******************************
    
    
    // Location update handler. Updates 'currentLocation' when changed;
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        LatLabel.text = "Lat: \(location.coordinate.latitude)"
        LongLabel.text = "Long: \(location.coordinate.longitude)"
        self.curLat = location.coordinate.latitude
        self.curLong = location.coordinate.longitude
        print(curLat)
        print(curLong)
        let camera = GMSCameraPosition.camera(withLatitude: curLat,
                                              longitude: curLong,
                                              zoom: 6.0)
        if mapper.isHidden {
            mapper.isHidden = false
            mapper.camera = camera
        } else {
            mapper.animate(to: camera)
        }
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapper.isHidden = false
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //***** VIEW THINGS *****
        sizingView.bringSubview(toFront: swipUpView)
        
        
        //***** LOCATION THINGS *****
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        
        let camera = GMSCameraPosition.camera(withLatitude: curLat,
                                              longitude: curLong,
                                              zoom: 6.0)
        mapper = GMSMapView.map(withFrame: sizingView.bounds, camera: camera)
        mapper.mapType = .satellite
        mapper.settings.myLocationButton = true
        mapper.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: curLat, longitude: curLong)
        marker.title = "Your Location"
        marker.map = mapper
        sizingView.addSubview(mapper)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
