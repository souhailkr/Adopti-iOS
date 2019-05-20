//
//  MapViewController.swift
//  Adopt
//
//  Created by SouhailKr on 12/11/18.
//  Copyright © 2018 ESPRIT. All rights reserved.
//

import UIKit
import MapKit
import Alamofire

class MapViewController: UIViewController,MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    let url = URLs.showPets
    var artworks: [Artwork] = []
    var list : [[String: Any]] = [[:]]
    var id = Int()
    
    
    
    
    
    let locationManager = CLLocationManager()
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        for p in list {
            let lat = p["altitude"] as! Double
            let long = p["longitude"] as! Double
            let testLocation = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))
            if testLocation.latitude == view.annotation!.coordinate.latitude && testLocation.longitude == view.annotation!.coordinate.longitude {
                id = p["id"] as! Int
                
                performSegue(withIdentifier: "toDetail", sender: p)
                print("aaa")
                
                
                break
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail"{
            
            
            if let destViewController : DetailsController = segue.destination as! DetailsController
            {
                //    destViewController.labelText = "test"  //**** this works
                //        destViewController.petImg = iconName  //**** this doesnt
                destViewController.id = id
                print(id)
                
                
            }
        }
        
    }
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.register(ArtworkView.self,
                              forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        
        
        
        
        FetchData()
        
        
        
        
        
        
    }
    
    func FetchData() {
        let token: String? = helper.getApiToken()
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": "Bearer \(token!)"
        ]
        Alamofire.request(url, headers: headers).responseJSON{
            
            response in
            
            print(response.result.value)
            print(response)
            
            self.list = response.result.value as! [[String: Any]]
            
            
            
            
            for json in self.list {
                let lat = json["altitude"] as! Double
                let long = json["longitude"] as! Double
                let img = json["type"] as! String
                let name = json["name"] as! String
                let ima = json["photo"] as! String
                
                let desc = json["description"] as! String
                
                
                
                
                
                
                let initialLocation = CLLocation(latitude: lat, longitude: long)
                
                let regionRadius: CLLocationDistance = 10000
                func centerMapOnLocation(location: CLLocation) {
                    let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                              latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
                    self.mapView.setRegion(coordinateRegion, animated: true)
                }
                
                centerMapOnLocation(location: initialLocation)
                
                
                
                
                
                let artwork = Artwork(title: name,
                                      locationName: desc,
                                      discipline: img,
                                      image: ima,
                                      
                                      coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
                artwork.coordinate = CLLocationCoordinate2D(latitude: lat,longitude: long)
                
                self.mapView.addAnnotation(artwork)
                
                
            }
            
            
            
            
        }
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
