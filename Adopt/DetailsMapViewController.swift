//
//  DetailsMapViewController.swift
//  Adopt
//
//  Created by SouhailKr on 12/6/18.
//  Copyright © 2018 ESPRIT. All rights reserved.
//

import UIKit
import MapKit

class DetailsMapViewController: UIViewController,MKMapViewDelegate  {
    @IBOutlet weak var map: MKMapView!
    var lat = Double()
    var long = Double()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let initialLocation = CLLocation(latitude: lat, longitude: long)
        
        let regionRadius: CLLocationDistance = 1000
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                      latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            map.setRegion(coordinateRegion, animated: true)
        }
        
        centerMapOnLocation(location: initialLocation)
        // Do any additional setup after loading the view.
        
        let artwork = Artwork(title: "Adopt",
                              locationName: "Waikiki Gateway Park",
                              discipline: "Sculpture",
                              image: "" ,
                              coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
        map.addAnnotation(artwork)
        map.delegate = self
        
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let coordinate = CLLocationCoordinate2DMake(lat,long)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = "Target location"
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
    
}
