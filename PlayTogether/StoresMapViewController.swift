//
//  StoresMapViewController.swift
//  PlayTogether
//
//  Created by mac on 1/10/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class StoreLocation: NSObject,MKAnnotation {
    
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
    
}

class StoresMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var storeLocations: [StoreLocation] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        
        StoresDataManager.getLocation(closure: { locations in mapView.addAnnotations(locations)})
        checkLocationAuthorizationStatus()
        
    }
    
    func checkLocationAuthorizationStatus(){
        if CLLocationManager.authorizationStatus() == .authorizedAlways{
            mapView.showsUserLocation = true
            locationManager.startMonitoringSignificantLocationChanges()
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            
            if let loc = locationManager.location{
                let point = loc.coordinate
                mapView.setCenter(point, animated: true)
                
                let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
                let region = MKCoordinateRegion(center: point, span: span)
                mapView.setRegion(region, animated: true)
            }
            
        } else{
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.first {
            let point = currentLocation.coordinate
            mapView.setCenter(point, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? StoreLocation{
            let identifier = "pin"
            var view: MKPinAnnotationView
            
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView{
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            }
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation as? StoreLocation{
            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDefault]
            let placeMark = MKPlacemark(coordinate: annotation.coordinate, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placeMark)
            
            mapItem.openInMaps(launchOptions: launchOptions)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
