//
//  ArtworkViews.swift
//  Adopt
//
//  Created by SouhailKr on 1/1/19.
//  Copyright © 2019 ESPRIT. All rights reserved.
//


import Foundation
import MapKit
import AlamofireImage

class ArtworkMarkerView: MKMarkerAnnotationView {
    
    
    override var annotation: MKAnnotation? {
        willSet {
            guard let artwork = newValue as? Artwork else { return }
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            //markerTintColor = artwork.markerTintColor
            //      glyphText = String(artwork.discipline.first!)
            if let imageName = artwork.imageName {
                glyphImage = UIImage(named: imageName)
                print(imageName)
            } else {
                glyphImage = nil
            }
        }
    }
    
}





class ArtworkView: MKAnnotationView {
    let urlImage = URLs.image
    
    
    override var annotation: MKAnnotation? {
        willSet {
            guard let artwork = newValue as? Artwork else {return}
            
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero,
                                                    size: CGSize(width: 30, height: 30)))
            mapsButton.setBackgroundImage(UIImage(named: "info"), for: UIControl.State())
            rightCalloutAccessoryView = mapsButton
            let i = UIButton(frame: CGRect(origin: CGPoint.zero,
                                           size: CGSize(width: 80, height: 80)))
            
            
            let ima = artwork.image
            let ur = urlImage+ima
            let url = NSURL(string: ur)
            
            let data = NSData(contentsOf: url as! URL)
            
            i.setBackgroundImage(UIImage(data: data as! Data), for: UIControl.State())
            leftCalloutAccessoryView = i
            
            //      rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            
            
            
            if let imageName = artwork.imageName {
                image = UIImage(named: imageName)
                print(imageName)
            } else {
                image = nil
            }
            
            let detailLabel = UILabel()
            detailLabel.numberOfLines = 0
            detailLabel.font = detailLabel.font.withSize(12)
            detailLabel.text = artwork.subtitle
            detailCalloutAccessoryView = detailLabel
        }
    }
    
}

