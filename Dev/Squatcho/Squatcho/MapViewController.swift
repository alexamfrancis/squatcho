//
//  MapViewController.swift
//  Squatcho
//
//  Created by Alexandra Francis on 7/19/17.
//  Copyright © 2017 Marlexa. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var menuButton:UIBarButtonItem!
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // Ask for Authorization from the User.
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }

        // Do any additional setup after loading the view.
    }
    
    override func loadView() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: 35.28710571680812, longitude: -120.66387176513672, zoom: 12.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        view = mapView

        // Create a rectangular path
        let bounds = GMSMutablePath()
        for coord in DummyData.sloCoords {
            let lat = coord[0]
            let long = coord[1]
            bounds.add(CLLocationCoordinate2D(latitude: lat, longitude: long))
        }
        
        // Create the polygon, and assign it to the map.
        let polygon = GMSPolygon(path: bounds)
        polygon.fillColor = UIColor(red: 250/255, green: 0, blue: 0, alpha: 0.05);
        polygon.strokeColor = UIColor(red: 245/255, green: 0, blue: 0, alpha: 1);
        polygon.strokeWidth = 2
        polygon.map = mapView
    }

    /* GET THE USERS CURRENT LOCATION */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        // do something with the updated location
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
