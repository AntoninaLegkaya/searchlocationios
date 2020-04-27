//
//  ViewController.swift
//  SearchLocation
//
//  Created by User on 27.04.2020.
//  Copyright © 2020 User. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController {
    var showMapRoute = false
    var stepCounter = 0
    let locationDistance : Double = 500
    var steps : [MKRoute.Step] = []
    // var route : MKRoute
    var  resultSearchController : UISearchController? = nil
    
  
    @IBOutlet weak var mapView: MKMapView!
    lazy var locationManager: CLLocationManager = {
        let locationManger = CLLocationManager()
        
        if CLLocationManager.locationServicesEnabled(){
            
            print("Location is enable->")
            locationManger.delegate = self
            locationManger.desiredAccuracy = kCLLocationAccuracyBest
        }
        else {
            print("Location services are not enabled")
            
        }
         return locationManger
    }()
    
    fileprivate func handleAuthorizationStatus(locationManager: CLLocationManager, status: CLAuthorizationStatus){
        switch status {
       
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            break
        case .denied:
            break
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            // view current location if we have coordinates
            if let center = locationManager.location?.coordinate{
                centerViewToUserLocation(center: center)
            }
            break
        @unknown default:
            break
        }
        
        
    }
    fileprivate func centerViewToUserLocation(center: CLLocationCoordinate2D){
        // set current location
        let region = MKCoordinateRegion(center: center, latitudinalMeters: locationDistance, longitudinalMeters: locationDistance)
        self.mapView.setRegion(region, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
            // whant see user location
            mapView.delegate = self
            mapView.mapType = .standard
            mapView.showsCompass = true
            mapView.showsScale = true
            mapView.showsUserLocation = true
        
        let locationSearchTable = storyboard!.instantiateViewController(identifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable as UISearchResultsUpdating
            
        //setup search bar
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        // navigation Bar disappears when the search results are shown if false-> searchBar accessible all time
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        // gives the modal overlay a semi-transparent background when the search bar is selected
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        
        // start get/update location
        locationManager.startUpdatingLocation()
    }

    }
fileprivate func getMapRoute(){
   
}

extension ViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // updated user location if if showMapRoute = false
        if !showMapRoute {
            if let location = locations.last {
                let center  = location.coordinate
                centerViewToUserLocation(center: center)
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // handle if change authorization status
        handleAuthorizationStatus(locationManager: locationManager, status: status)
    }
    
     func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        stepCounter += 1
        
      
        
        
    }
    
    
}
extension ViewController: MKMapViewDelegate{
    
    
}

