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
    var selfMaydayStatus:Bool = false
    var engageStatus:Bool = false
    
    var routePath:GMSPath?
    var routeLine:GMSPolyline?
    
    var selectedBoater:CLLocationCoordinate2D?
    var selectedBoaterInfo:Dictionary<String, Any>?
    
    var masterMarkerList:[GMSMarker]?
    
    
    // **** INITIALIZE UI ELEMENTS ****
    
    @IBOutlet weak var sizingView: UIView!
    
    @IBOutlet weak var MAYDAY: UIButton!
    @IBOutlet weak var ENGAGE: UIButton!
    
    @IBOutlet weak var boaterProfileButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    
    
    @IBOutlet weak var boaterInfoView: UIView!
    
    @IBOutlet weak var nudgeyBoi: UIButton!
    
    @IBOutlet weak var etaView: UIView!
    @IBOutlet weak var etaLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var boaterCoord: UILabel!
    @IBOutlet weak var boaterVessel: UILabel!
    @IBOutlet weak var boaterName: UILabel!
    var mapper: GMSMapView!
    // ********************************
    
    var curLat:Double!
    var curLong:Double!
    var curZoom:Float!
    
    var fakeLat:Double!
    var fakeLong:Double!
    
    
    // **** INIT LOCATION MANAGER ****
    var lManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    
    @IBAction func nudgePressed(_ sender: Any) {
        self.nudger()
    }
    
    
    @IBAction func boaterProfilePressed(_ sender: Any) {
        
        
        
    }
    
    @IBAction func chatPressed(_ sender: Any) {
        
        if let channelName = self.selectedBoaterInfo?["email"]{
            let cvc = ChannelsViewController(currentUser: Auth.auth().currentUser!)
            cvc.createChannel(channelName: channelName as! String)
            self.navigationController?.pushViewController(ChatViewController(user: Auth.auth().currentUser!, channel: Channel(name: channelName as! String, identifier: channelName as! String)), animated: true)
            //self.present(ChatViewController(user: Auth.auth().currentUser!, channel: Channel(name: channelName as! String, identifier: channelName as! String)), animated: true, completion: nil)
            
        }else{
            let channelName = self.selectedBoaterInfo?["name"] as! String
            let cvc = ChannelsViewController(currentUser: Auth.auth().currentUser!)
            cvc.createChannel(channelName: channelName)
          self.navigationController?.pushViewController(ChatViewController(user: Auth.auth().currentUser!, channel: Channel(name: channelName , identifier: channelName )), animated: true)
            //self.present(ChatViewController(user: Auth.auth().currentUser!, channel: Channel(name: channelName as! String, identifier: channelName as! String)), animated: true, completion: nil)
        }
    }
    
    @IBAction func engageTester(_ sender: Any) {
        
        if !engageStatus{
            
            //WE ARE NOW ENGAGED
            self.engageStatus = true
            
            if (self.selectedBoater != nil){
                
                self.ENGAGE.backgroundColor = .yellow
                self.ENGAGE.setTitle("Disengage", for: .normal)
                self.ENGAGE.setTitleColor(.black, for: .normal)
                
                self.boaterProfileButton.isHidden = false
                self.chatButton.isHidden = false
                
                
                let somePath = GMSMutablePath()
                somePath.add(CLLocationCoordinate2D(latitude: self.curLat, longitude: self.curLong))
                somePath.add(CLLocationCoordinate2D(latitude: selectedBoater!.latitude, longitude: self.selectedBoater!.longitude))
                
                
                self.routeLine = GMSPolyline(path: somePath)
                self.routeLine!.strokeWidth = 5.00
                self.routeLine!.map = mapper
                
                self.etaView.isHidden = false
                
                /*
                 let bounds = GMSCoordinateBounds(path: somePath)
                 self.mapper.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 5.0))
                 */
                
            }
            
        }else{
            
            // WE ARE NO LONGER ENGAGED
            self.engageStatus = false
            self.ENGAGE.backgroundColor = .red
            self.ENGAGE.setTitle("ENGAGE", for: .normal)
            self.ENGAGE.setTitleColor(.yellow, for: .normal)
            
            self.boaterProfileButton.isHidden = true
            self.chatButton.isHidden = true
            
            self.routeLine!.map = nil
            
            self.etaView.isHidden = true
            
            
            
        }
        
    }
    
    func updatePolyline(){
        
        self.routeLine!.map = nil
        
        
        let somePath = GMSMutablePath()
        somePath.add(CLLocationCoordinate2D(latitude: self.curLat, longitude: self.curLong))
        somePath.add(CLLocationCoordinate2D(latitude: selectedBoater!.latitude, longitude: self.selectedBoater!.longitude))
        
        
        self.routeLine = GMSPolyline(path: somePath)
        self.routeLine!.strokeWidth = 5.00
        self.routeLine!.map = mapper
    }
    
    
    
    @IBAction func maydayPressed(_ sender: Any) {
        if !self.selfMaydayStatus{
            
            self.selfMaydayStatus = true
            //Change appearance
            self.selfMarker!.icon = GMSMarker.markerImage(with: .red)
            self.MAYDAY.backgroundColor = .yellow
            self.MAYDAY.setTitle("Cancel", for: .normal)
            self.MAYDAY.setTitleColor(.black, for: .normal)
            
            // adjust status in DB
            let ref: DatabaseReference = Database.database().reference(withPath: "user_locations").child("\(String(describing: self.currentUser!))")
            ref.child("mayday").setValue("true")
        }
        else{
            self.selfMaydayStatus = false
            // Change appearance
            self.selfMarker!.icon = GMSMarker.markerImage(with: .yellow)
            self.MAYDAY.backgroundColor = .red
            self.MAYDAY.setTitle("MAYDAY", for: .normal)
            self.MAYDAY.setTitleColor(.yellow, for: .normal)
            
            // adjust status in DB
            let ref: DatabaseReference = Database.database().reference(withPath: "user_locations").child("\(String(describing: self.currentUser!))")
            ref.child("mayday").setValue("false")
        }
        
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        // In the case that the users own location marker is tapped
        guard let info = marker.userData as? Dictionary<String, Any> else{
            self.boaterInfoView.isHidden = true
            return true
        }
        self.selectedBoaterInfo = info
        self.selectedBoater = CLLocationCoordinate2D(latitude: info["lat"] as! Double, longitude: info["lon"] as! Double)
        
        self.boaterName.text = info["name"] as? String
        let roundLat = round((info["lat"] as! Double)*1000)/1000
        let roundLon = round((info["lon"] as! Double)*1000)/1000
        self.boaterCoord.text = "Lat: \(String(roundLat)) | Lon: \(String(roundLon))"
        
        if info["mayday"] as! String == "true"{
            self.boaterInfoView.isHidden = false
            self.ENGAGE.isHidden = false
        }
        else{
            self.boaterInfoView.isHidden = false
            self.ENGAGE.isHidden = true
        }
        
        return true
        
    }
    
    // This handles touches outside of markers to make ui elements diappear.
    // Only triggers when a non-marker locations are tapped
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        self.boaterInfoView.isHidden = true
        self.selectedBoater = nil
    }
    
    // Location update handler. Updates 'currentLocation' when changed;
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        
        self.curLat = location.coordinate.latitude
        self.curLong = location.coordinate.longitude
        
        self.fakeLat = self.curLat
        self.fakeLong = self.curLong
        
        
        
        var camera = GMSCameraPosition.camera(withLatitude: curLat,
                                              longitude: curLong,
                                              zoom: 10.00)
        if self.curZoom != nil{
            camera = GMSCameraPosition.camera(withLatitude: curLat,
                                              longitude: curLong,
                                              zoom: self.curZoom!)
        }
        
        
        
        selfMarker!.position = CLLocationCoordinate2D(latitude: curLat, longitude: curLong)
        selfMarker!.title = "Your Location"
        selfMarker!.snippet = "Lat: \(String(describing:self.curLat!)) Lon:\(String(describing:self.curLong!))"
        selfMarker!.map = mapper
        
        let projection = mapper.projection.visibleRegion()
        
        self.populateNearby(topLeft: projection.farLeft, topRight: projection.farRight, bottomLeft: projection.nearLeft, bottomRight: projection.nearRight)
        
        if self.locationSharing == true{
            let ref: DatabaseReference = Database.database().reference(withPath: "user_locations").child("\(String(describing: self.currentUser!))")
            selfMarker!.icon = GMSMarker.markerImage(with: .yellow)
            
            let lon = self.curLong!+360.0
            
            ref.child("lat").setValue(self.curLat!)
            ref.child("lon").setValue(lon)
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
        
        
        //SUBSECTION FOR UPDATING ETA
        if !self.etaView.isHidden{
            let speed = location.speed
            
            let somePath = GMSMutablePath()
            somePath.add(CLLocationCoordinate2D(latitude: self.curLat, longitude: self.curLong))
            somePath.add(CLLocationCoordinate2D(latitude: selectedBoater!.latitude, longitude: self.selectedBoater!.longitude))
            
            let coolLength = round(somePath.length(of: .geodesic))
            self.distanceLabel.text = "Distance \(coolLength) m"
            
            if speed < 0{
                self.etaLabel.text = "ETA: N/A"
            }
            else{
                let coolSpeed = round((coolLength/speed)/60)
                self.etaLabel.text = "ETA: \(coolSpeed)"
            }
            
        }
        
        // UPDATE POLYLINE IF ENGAGED IS TRUE
        // ALSO UPDATE TARGET BOATER'S INFORMATION
        if self.engageStatus{
            self.updatePolyline()
            
            
            
        }
        
        
    }
    
    func nudger(){
        self.fakeLat += 0.001
        self.fakeLong += 0.001
        let newestLocation = CLLocation(latitude: self.fakeLat, longitude: self.fakeLong)
        self.locationManager(self.lManager, didUpdateLocations: [newestLocation])
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
        
        
        //Defining Bounds in screen with LAT and LON
        let projection = mapView.projection.visibleRegion()
        
        self.populateNearby(topLeft: projection.farLeft, topRight: projection.farRight, bottomLeft: projection.nearLeft, bottomRight: projection.nearRight)
        
    }
    
    
    
    
    func populateNearby(topLeft: CLLocationCoordinate2D,topRight: CLLocationCoordinate2D,bottomLeft: CLLocationCoordinate2D,bottomRight: CLLocationCoordinate2D){
        
        // Now we fukkin
        
        
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
            
            let maybe = queryResult as? Dictionary<String,Dictionary<String,Any>>
            
            if maybe != nil{
                self.setMarkers(book: maybe!)
            }
            
            
        })
        
        
    }
    
    func setMarkers(book: Dictionary<String,Dictionary<String,Any>>){
        
        if let boobay = self.masterMarkerList{
            for marker in self.masterMarkerList!{
                marker.map = nil
            }
        }
        
        for entry in book{
            
            let stringedEmail = entry.value["Email"] as! String
            
            if !(stringedEmail == Auth.auth().currentUser?.email){
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: entry.value["lat"] as! CLLocationDegrees, longitude: entry.value["lon"] as! CLLocationDegrees)
                marker.title = entry.value["First_Name"] as! String
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
                self.masterMarkerList?.append(marker)
            }
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
        lManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
  override func viewWillAppear(_ animated: Bool) {
    
  }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentUser = Auth.auth().currentUser?.uid
        
        self.boaterInfoView.isHidden = true
        self.etaView.isHidden = true
        
        
        //***** LOCATION THINGS *****
        lManager.delegate = self
        lManager.desiredAccuracy = kCLLocationAccuracyBest
        lManager.requestWhenInUseAuthorization()
        lManager.distanceFilter = 50
        lManager.startUpdatingLocation()
        
        
        
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
        
        mapper.addSubview(self.MAYDAY)
        mapper.addSubview(self.boaterInfoView)
        mapper.addSubview(self.etaView)
        mapper.addSubview(self.nudgeyBoi)
        self.MAYDAY.isHidden = false
        self.boaterInfoView.isHidden = true
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
        let ref: DatabaseReference = Database.database().reference(withPath: "user_locations").child("\(String(describing: self.currentUser!))")
        
        ref.child("lat").setValue(self.curLat!)
        ref.child("lon").setValue(self.curLong!)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //nothing yet
        
    }
    
    
}
