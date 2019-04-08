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
    
    var locationSharing:Bool = true
    var selfMarker:GMSMarker?
    var currentUser:String?
    
    // **** INITIALIZE UI ELEMENTS ****
 
    @IBOutlet weak var sizingView: UIView!
    
    @IBOutlet weak var MAYDAY: UIButton!
    @IBOutlet weak var ENGAGE: UIButton!
    
    
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
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        var info = marker.userData as! Dictionary<String, Any>
        if info["mayday"] as! String == "true"{
            self.ENGAGE.isHidden = false
        }
        
        return true
        
    }
    
    // Location update handler. Updates 'currentLocation' when changed;
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        
        self.curLat = location.coordinate.latitude
        self.curLong = location.coordinate.longitude
        let camera = GMSCameraPosition.camera(withLatitude: curLat,
                                              longitude: curLong,
                                              zoom: 10.0)
        
        selfMarker = GMSMarker()
        selfMarker!.position = CLLocationCoordinate2D(latitude: curLat, longitude: curLong)
        selfMarker!.title = "Your Location"
        selfMarker!.snippet = "Lat: \(String(describing:self.curLat!)) Lon:\(String(describing:self.curLong!))"
        selfMarker!.map = mapper
        
        let projection = mapper.projection.visibleRegion()
        
        self.populateNearby(topLeft: projection.farLeft, topRight: projection.farRight, bottomLeft: projection.nearLeft, bottomRight: projection.nearRight)
        
        if self.locationSharing == true{
            let ref: DatabaseReference = Database.database().reference(withPath: "user_locations").child("\(String(describing: self.currentUser!))")
            selfMarker!.icon = GMSMarker.markerImage(with: .yellow)
            
            ref.child("lat").setValue(self.curLat!)
            ref.child("lon").setValue(self.curLong!)
        }
        else{
            selfMarker!.icon = GMSMarker.markerImage(with: .darkGray)
        }
        
        
        if mapper.isHidden {
            mapper.isHidden = false
            mapper.camera = camera
        } else {
            mapper.animate(to: camera)
        }
    }
    
    func negCoordConverter(coord: Double) -> Double {
        
        if coord < 0.0{
            
            return (coord + 360)
        }
        else{
            return coord
        }
        
        
    }
    
    
    func callThisOnceAndThenFuckingDeleteIt(){
        // start up that DB, BB
        let ref: DatabaseReference = Database.database().reference()
        
        
        var bobbysDic = Dictionary<String,Any>()
        bobbysDic["name"] = "Bobby Boater"
        bobbysDic["lat"] = 21.2327778
        bobbysDic["lon"] = self.negCoordConverter(coord: -157.82444)
        bobbysDic["mayday"] = "false"
        
        ref.child("user_locations").child("bobbyBoater").setValue(bobbysDic)
        
        var vicsDic = Dictionary<String,Any>()
        vicsDic["name"] = "Victor Vessel"
        vicsDic["lat"] = 21.1827778
        vicsDic["lon"] = self.negCoordConverter(coord: -157.82444)
        vicsDic["mayday"] = "false"
        ref.child("user_locations").child("victorVeseel").setValue(vicsDic)
        
        var sallysDic = Dictionary<String,Any>()
        sallysDic["name"] = "Sally Ship"
        sallysDic["lat"] = 21.2527778
        sallysDic["lon"] = self.negCoordConverter(coord: -157.92444)
        sallysDic["mayday"] = "false"
        
        ref.child("user_locations").child("sallyShip").setValue(sallysDic)
        
        var conradsDic = Dictionary<String,Any>()
        conradsDic["name"] = "Conrad Captain"
        conradsDic["lat"] = 21.2827778
        conradsDic["lon"] = self.negCoordConverter(coord: -157.72444)
        conradsDic["mayday"] = "true"
        
        ref.child("user_locations").child("conradsCaptain").setValue(conradsDic)
    }
 
    
    //Update changed zoomw when camera settles
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.curZoom = mapView.camera.zoom
        print(self.curZoom)
        
        print(mapView.camera.target)
        
        //Defining Bounds in screen with LAT and LON
        let projection = mapView.projection.visibleRegion()
    
        self.populateNearby(topLeft: projection.farLeft, topRight: projection.farRight, bottomLeft: projection.nearLeft, bottomRight: projection.nearRight)
        
    }
    
    func populateNearby(topLeft: CLLocationCoordinate2D,topRight: CLLocationCoordinate2D,bottomLeft: CLLocationCoordinate2D,bottomRight: CLLocationCoordinate2D){
    
        // Now we fukkin
        print(topLeft)
        print(topRight)
        print(bottomLeft)
        print(bottomRight)
        
        var top = self.negCoordConverter(coord: topLeft.latitude)
        var left = self.negCoordConverter(coord: topLeft.longitude)
        var bottom = self.negCoordConverter(coord: bottomRight.latitude)
        var right = self.negCoordConverter(coord: bottomRight.longitude)
        
        let ref: DatabaseReference = Database.database().reference(withPath: "user_locations")
        
        // coordinates suck, so lets fix it.
        
        // if the camera is positioned about the prime meridian near africa, some magic needs to happen. Otherwise, find all coords greater than left, less than right. Wow.
        
        if left > right{
            let coolQuery1 = ref.queryOrdered(byChild: "lon").queryStarting(atValue: left).queryEnding(atValue: 360.0)
            let coolQuery2 = ref.queryOrdered(byChild: "lon").queryStarting(atValue: 0.0).queryEnding(atValue: right)
        }
        
        let coolQuery = ref.queryOrdered(byChild: "lon").queryStarting(atValue: left).queryEnding(atValue: right)
        
        coolQuery.observe(.value, with:{ (snapshot: DataSnapshot) in
            let queryResult = snapshot.valueInExportFormat()
            print(queryResult!)
            let maybe = queryResult as? Dictionary<String,Dictionary<String,Any>>
            
            if maybe != nil{
                self.setMarkers(book: maybe!)
            }
            
            
        })
        
        
    }
    
    func setMarkers(book: Dictionary<String,Dictionary<String,Any>>){
        for entry in book{
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: entry.value["lat"] as! CLLocationDegrees, longitude: entry.value["lon"] as! CLLocationDegrees)
            marker.title = entry.value["name"] as! String
            marker.snippet = "Lat: \(String(describing:entry.value["lat"] as! CLLocationDegrees)) Lon:\(String(describing:entry.value["lon"] as! CLLocationDegrees))"
            if entry.value["mayday"] as! String == "false"{
                marker.icon = GMSMarker.markerImage(with: .green)
                marker.tracksInfoWindowChanges = true
            }
            else{
                marker.icon = GMSMarker.markerImage(with: .red)
                marker.tracksInfoWindowChanges = true
            }
            let userDatum = entry.value
            
            marker.userData = userDatum
            
            marker.map = mapper
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
        
        self.currentUser = Auth.auth().currentUser?.uid
    
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
        
        
        selfMarker = GMSMarker()
        selfMarker!.position = CLLocationCoordinate2D(latitude: 100.0, longitude: 100.0)
        selfMarker!.title = "Your Location"
        selfMarker!.map = mapper
        sizingView.addSubview(mapper)
        
        mapper.addSubview(self.ENGAGE)
        mapper.addSubview(self.MAYDAY)
        self.ENGAGE.isHidden = true
        self.MAYDAY.isHidden = true
        mapper.isHidden = true
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        turnOffLocation()
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        if self.locationSharing{
            selfMarker!.icon = GMSMarker.markerImage(with: .darkGray)
            selfMarker!.snippet = "Lat: N/A  Lon: N/A"
            selfMarker!.tracksInfoWindowChanges = true
            self.turnOffLocation()
        }else{
            selfMarker!.icon = GMSMarker.markerImage(with: .yellow)
            self.turnOnLocation()
        }
        return true
    }
    
    
    
    
    func turnOffLocation(){
        self.locationSharing = false
        let ref: DatabaseReference = Database.database().reference(withPath: "user_locations").child("\(String(describing: self.currentUser!))")
        
        ref.child("lat").setValue(1000.0)
        ref.child("lon").setValue(1000.0)
    }
    func turnOnLocation(){
        self.locationSharing = true
        selfMarker!.snippet = "Lat: \(String(describing:self.curLat!)) Lon:\(String(describing:self.curLong!))"
    }
    
}
