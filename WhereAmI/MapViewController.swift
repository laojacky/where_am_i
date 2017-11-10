//
//  MapViewController.swift
//  WhereAmI
//
//  Created by Jacky Lao on 09/11/2017.
//  Copyright © 2017 jacky. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    private var locationManager = CLLocationManager()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.checkLocation()
    }
    
    func checkLocation() {
        //Check for Location Services
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .restricted, .denied:
                print("No access")
                let alertView = UIAlertController(title: "", message: "No Access", preferredStyle: .alert)
                let action = UIAlertAction(title: "Settings", style: .default, handler: { (alert) in
                    UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
                })
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertView.addAction(cancelAction)
                alertView.addAction(action)
                self.present(alertView, animated: true, completion: nil)
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
                print("Access")
            case .notDetermined:
                print("None")
            }
        } else {
            let alertView = UIAlertController(title: "", message: "Location services are not enabled", preferredStyle: .alert)
            let action = UIAlertAction(title: "Settings", style: .default, handler: { (alert) in
                UIApplication.shared.open(URL(string:"App-Prefs:root=Privacy&path=LOCATION")!, options: [:], completionHandler: nil)
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alertView.addAction(cancelAction)
            alertView.addAction(action)
            self.present(alertView, animated: true, completion: nil)
            print("Location services are not enabled")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Check current location
        mapView.delegate = self
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        
    
        locationManager.requestWhenInUseAuthorization()
        self.checkLocation()
        //Zoom to user location
        let noLocation = CLLocationCoordinate2D()
        let viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 200, 200)
        mapView.setRegion(viewRegion, animated: false)
        
        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        var region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        region.center = mapView.userLocation.coordinate
        mapView.setRegion(region, animated: true)
    }
}

