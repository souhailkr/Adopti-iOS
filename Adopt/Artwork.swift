//
//  Artwork.swift
//  Adopt
//
//  Created by SouhailKr on 12/6/18.
//  Copyright © 2018 ESPRIT. All rights reserved.
//

import Foundation

import MapKit
import Contacts

class Artwork: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    var discipline: String
    var image: String
    var coordinate: CLLocationCoordinate2D
    var imageName: String? {
        if discipline == "Dog" { return "dog" }
        if discipline == "Cat" { return "cat" }
        if discipline == "Bird" { return "bird" }
        if discipline == "Reptile" { return "turtle" }
        return "hamster"
    }
    
    var markerTintColor: UIColor  {
        switch discipline {
        case "Monument":
            return .red
        case "Mural":
            return .cyan
        case "Plaque":
            return .blue
        case "Sculpture":
            return .purple
        default:
            return .green
        }
    }
    
    
    
    
    init(title: String, locationName: String, discipline: String, image: String,coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.image = image
        self.coordinate = coordinate
        
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
}

