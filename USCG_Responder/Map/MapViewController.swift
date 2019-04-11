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
import Firebase

class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    

    // **** INITIALIZE UI ELEMENTS ****
    @IBOutlet weak var LatLabel: UILabel!
    @IBOutlet weak var LongLabel: UILabel!
    @IBOutlet weak var swipUpView: UIView!
    
    @IBOutlet weak var sizingView: UIView!
    
    var mapper: GMSMapView!
    // ********************************
    
    var curLat:Double!
    var curLong:Double!
    var curZoom:Float!
    
    
    // **** INIT LOCATION MANAGER ****
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    // fake location for init purposes
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
                                              zoom: 10.0)
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: curLat, longitude: curLong)
        marker.title = "Your Location"
        marker.map = mapper
        
        
        self.populateNearby()
        
        
        if mapper.isHidden {
            mapper.isHidden = false
            mapper.camera = camera
        } else {
            mapper.animate(to: camera)
        }
    }
    
    func populateNearby(){
        
        
        let bobbyBoater = GMSMarker()
        bobbyBoater.position = CLLocationCoordinate2D(latitude: curLat+0.1, longitude: curLong)
        bobbyBoater.title = "bobbyBoater"
        bobbyBoater.map = mapper
        
        let victorVessel = GMSMarker()
        victorVessel.position = CLLocationCoordinate2D(latitude: curLat-0.1, longitude: curLong)
        victorVessel.title = "victorVessel"
        victorVessel.map = mapper
        
        let sallyShip = GMSMarker()
        sallyShip.position = CLLocationCoordinate2D(latitude: curLat, longitude: curLong+0.1)
        sallyShip.title = "sallyShip"
        sallyShip.map = mapper
        
        let conradCaptain = GMSMarker()
        conradCaptain.position = CLLocationCoordinate2D(latitude: curLat, longitude: curLong-0.1)
        conradCaptain.title = "conradCaptain"
        conradCaptain.map = mapper
        
        
        
    }
    
    /*
    func callThisOnceAndThenFuckingDeleteIt(){
        // start up that DB, BB
        let ref: DatabaseReference = Database.database().reference()
        
        
        var bobbysDic = Dictionary<String,String>()
        bobbysDic["name"] = "Bobby Boater"
        bobbysDic["lat"] = "21.2327778"
        bobbysDic["lon"] = "-157.824444"
        
        ref.child("user_locations").child("bobbyBoater").setValue(bobbysDic)
        
        var vicsDic = Dictionary<String,String>()
        vicsDic["name"] = "Victor Vessel"
        vicsDic["lat"] = "21.1827778"
        vicsDic["lon"] = "-157.824444"
        
        ref.child("user_locations").child("victorVeseel").setValue(vicsDic)
        
        var sallysDic = Dictionary<String,String>()
        sallysDic["name"] = "Sally Ship"
        sallysDic["lat"] = "21.2527778"
        sallysDic["lon"] = "-157.924444"
        
        ref.child("user_locations").child("sallyShip").setValue(sallysDic)
        
        var conradsDic = Dictionary<String,String>()
        conradsDic["name"] = "Conrad Captain"
        conradsDic["lat"] = "21.2827778"
        conradsDic["lon"] = "-157.724444"
        
        ref.child("user_locations").child("conradsCaptain").setValue(conradsDic)
    }
 */
    
    //Update changed zoomw when camera settles
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.curZoom = mapView.camera.zoom
        print(self.curZoom)
        
        print(mapView.camera.target)
        
        //Defining Bounds in screen with LAT and LON
        let projection = mapView.projection.visibleRegion()
        
        let topLeftCorner: CLLocationCoordinate2D = projection.farLeft
        let topRightCorner: CLLocationCoordinate2D = projection.farRight
        let bottomLeftCorner: CLLocationCoordinate2D = projection.nearLeft
        let bottomRightCorner: CLLocationCoordinate2D = projection.nearRight
        
        
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
        
        
        
        let camera = GMSCameraPosition.camera(withLatitude: 100.0,
                                              longitude: 100.0,
                                              zoom: 6.0)
        mapper = GMSMapView.map(withFrame: sizingView.bounds, camera: camera)
        mapper.mapType = .satellite
        mapper.settings.myLocationButton = true
        mapper.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapper.delegate = self
        
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 100.0, longitude: 100.0)
        marker.title = "Your Location"
        marker.map = mapper
        sizingView.addSubview(mapper)
        mapper.isHidden = true
        
    }
    
    /****************MAP MARKER******************/
    
    
    func loadMarkersFromDB() {
        let userID = Auth.auth().currentUser?.uid
        
        let ref: DatabaseReference = Database.database().reference(withPath: "user_locations").child(userID!)
        /*
        ref.observe(.childAdded, with: { (snapshot) in
            if snapshot.value as? [String : AnyObject] != nil {
                self.mapper.clear()
                guard let user = snapshot.value as? [String : String] else {
                    return
                }
                // Get coordinate values from DB
                let latitude = user["latitude"]
                let longitude = user["longitude"]
               
                DispatchQueue.main.async(execute: {
                    let marker = GMSMarker()
                    // Assign custom image for each marker
                    let markerImage = self.resizeImage(image: UIImage.init(named: "ParkSpaceLogo")!, newWidth: 30).withRenderingMode(.alwaysTemplate)
                    let markerView = UIImageView(image: markerImage)
                    // Customize color of marker here:
                    markerView.tintColor = rented ? .lightGray : UIColor(hexString: "19E698")
                    marker.iconView = markerView
                    marker.position = CLLocationCoordinate2D(latitude: latitude as! CLLocationDegrees, longitude: longitude as! CLLocationDegrees)
                    marker.map = self.gMapView
                    // *IMPORTANT* Assign all the spots data to the marker's userData property
                    marker.userData = spot
                })
            }
        }, withCancel: nil)
        */
    }
}
