//
//  MapViewController.swift
//  WaterYouDrinking
//
//  Created by Noah Sutter on 4/23/17.
//  Copyright © 2017 Noah Sutter. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase
import FirebaseDatabase


class MapViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var locValue:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 40, longitude: -80)
    
    
    override func loadView() {
        GMSServices.provideAPIKey("AIzaSyCiFXhrDE7a0zSO-7bDvIR1unbW80XqySU")
        

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        locValue.latitude = locationManager.location!.coordinate.latitude
        locValue.longitude = locationManager.location!.coordinate.longitude
        let camera = GMSCameraPosition.camera(withLatitude: locValue.latitude, longitude: locValue.longitude, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        // Creates a marker in the center of the map.

        
        
        
        let ref = FIRDatabase.database().reference()

        ref.child("waterSourceReports").observeSingleEvent(of: .value, with: { snapshot in
            let enumerator = snapshot.children

            while let rest = enumerator.nextObject() {
                let lat = (rest as! FIRDataSnapshot).childSnapshot(forPath: "location/latitude").value
                let lon = (rest as! FIRDataSnapshot).childSnapshot(forPath: "location/longitude").value
                let cond = (rest as! FIRDataSnapshot).childSnapshot(forPath: "waterCondition").value as! String
                let type = (rest as! FIRDataSnapshot).childSnapshot(forPath: "waterType").value as! String
                let address = (rest as! FIRDataSnapshot).childSnapshot(forPath: "addressString").value as! String
                // Creates a marker in the center of the map.
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: lat as! CLLocationDegrees, longitude: lon as! CLLocationDegrees)
                marker.snippet = "Water Type: " + type + ",\n Water Condition: " + cond
                marker.title = address
                marker.map = mapView

            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locValue = manager.location!.coordinate
    }
    
    
}
