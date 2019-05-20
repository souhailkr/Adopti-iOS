//
//  AddPetViewController.swift
//  Adopt
//
//  Created by mmi on 14/01/2019.
//  Copyright © 2019 ESPRIT. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import AlamofireImage
import SwiftyJSON
import Foundation
import YPImagePicker
import CoreLocation

class AddPetViewController: UIViewController, CLLocationManagerDelegate,UIPickerViewDelegate,UIPickerViewDataSource {

    
    
    @IBOutlet weak var petDescriptionOutlet: UITextField!
    @IBOutlet weak var petNameOutlet: UITextField!
    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var typeView: UIPickerView!
    @IBOutlet weak var breedView: UIPickerView!
    @IBOutlet weak var petSizeOutlet: UISegmentedControl!
    @IBOutlet weak var petSexeOutlet: UISegmentedControl!
    @IBOutlet weak var ageOutlet: UITextField!
    
    //type & breed
    var type = String()
    var breed = String()
    var selectedItemsArray : NSArray = []
    var dogs:[Any] = []
    var cats:[Any] = []
    var birds:[Any] = []
    var reptiles:[Any] = []
    var small:[Any] = []
    
    let url1 = "http://api.petfinder.com/breed.list?key=1abbf326403e6d3d360d9b9a5ad90da1&animal="
    let url2 = "&format=json&fbclid=IwAR1jkUGO2w4nZU0eqAdmbSh3Ag7QUBTWV3DB8pvUqZX4ZUYR3ADrF8p_TFo"
    
    let pickerData = ["Cat", "Dog", "Bird", "Reptile", "Small&Furry"]
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == typeView
        {
            return pickerData.count
        }
        else if pickerView == breedView {
            return selectedItemsArray.count
        }
        return 0
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == typeView
        {
            return pickerData[row]
        }
        else if pickerView == breedView {
            return selectedItemsArray[row] as! String
        }
        return selectedItemsArray[row] as! String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == typeView {
            type = pickerData[row] as String
            
            switch row {
            case 0:
                selectedItemsArray = cats as NSArray
            case 1:
                selectedItemsArray = dogs as NSArray
            case 2:
                
                selectedItemsArray = birds as NSArray
            case 3:
                
                
                selectedItemsArray = reptiles as NSArray
                
                
            case 4:
                
                selectedItemsArray = small as NSArray
                
                
                
            default:
                //                selectedItemsArray = []
                selectedItemsArray = cats as NSArray
                
            }
            breedView.reloadAllComponents()
            
            
            
            
        }
        breed = selectedItemsArray[row] as! String
        
    }
    
    
    func FetchData()
    {
        
        Alamofire.request(url1+"dog"+url2).responseJSON{
            
            
            response in
            
            
            let array = response.result.value as! NSDictionary
            let petfinder = array["petfinder"] as! NSDictionary
            let breeds = petfinder["breeds"] as! NSDictionary
            let breed = breeds["breed"] as! [[String : Any]]
            
            for json in breed {
                let t = json["$t"] as! String
                
                self.dogs.append(t)
                
            }
            
        }
        
        Alamofire.request(url1+"cat"+url2).responseJSON{
            
            
            response in
            
            
            let array = response.result.value as! NSDictionary
            let petfinder = array["petfinder"] as! NSDictionary
            let breeds = petfinder["breeds"] as! NSDictionary
            let breed = breeds["breed"] as! [[String : Any]]
            
            for json in breed {
                let t = json["$t"] as! String
                
                self.cats.append(t)
                
            }
            
        }
        
        Alamofire.request(url1+"bird"+url2).responseJSON{
            
            
            response in
            
            
            let array = response.result.value as! NSDictionary
            let petfinder = array["petfinder"] as! NSDictionary
            let breeds = petfinder["breeds"] as! NSDictionary
            let breed = breeds["breed"] as! [[String : Any]]
            
            for json in breed {
                let t = json["$t"] as! String
                
                self.birds.append(t)
                
            }
            
        }
        
        Alamofire.request(url1+"reptile"+url2).responseJSON{
            
            
            response in
            
            
            let array = response.result.value as! NSDictionary
            let petfinder = array["petfinder"] as! NSDictionary
            let breeds = petfinder["breeds"] as! NSDictionary
            let breed = breeds["breed"] as! [[String : Any]]
            
            for json in breed {
                let t = json["$t"] as! String
                
                self.reptiles.append(t)
                
            }
            
        }
        
        Alamofire.request(url1+"smallfurry"+url2).responseJSON{
            
            
            response in
            
            
            let array = response.result.value as! NSDictionary
            let petfinder = array["petfinder"] as! NSDictionary
            let breeds = petfinder["breeds"] as! NSDictionary
            let breed = breeds["breed"] as! [[String : Any]]
            
            for json in breed {
                let t = json["$t"] as! String
                
                self.small.append(t)
                
            }
            
        }
    }
    
    
    //end type & breed
    var locationManager = CLLocationManager()
    let token = helper.getApiToken()
    var config = YPImagePickerConfiguration()
    let urlImage = URLs.image
    var longitude: Double = 0.0
    var latitude: Double = 0.0
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        determineMyCurrentLocation()
    }
    
    //location
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        // manager.stopUpdatingLocation()
        self.latitude = userLocation.coordinate.latitude
        self.longitude = userLocation.coordinate.longitude
//        print("user latitude = \(userLocation.coordinate.latitude)")
//        print("user longitude = \(userLocation.coordinate.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    func emptyField(){
        let alert = UIAlertController(title: "Empty field!", message: "please check the form!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        
        self.present(alert, animated: true)
        return
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        petNameOutlet.resignFirstResponder()
        petDescriptionOutlet.resignFirstResponder()
        ageOutlet.resignFirstResponder()
        
    }
    
    @IBAction func addPetAction(_ sender: Any) {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.stopUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
        print("longitude")
        print(longitude)
        print("latitude")
        print(latitude)
        guard let petImageToInsert = self.petImageToInsert else {emptyField()
            return}
        let size = petSizeOutlet.titleForSegment(at: petSizeOutlet.selectedSegmentIndex)
        let sexe = petSexeOutlet.titleForSegment(at: petSexeOutlet.selectedSegmentIndex)
        guard let age = ageOutlet.text, !age.isEmpty else {emptyField()
            return}
        guard let petName = petNameOutlet.text, !petName.isEmpty else {emptyField()
            return}
        guard let petDescription = petDescriptionOutlet.text,!petDescription.isEmpty else {emptyField()
            return}
        
        
        
        API.addPet(size: size!, sexe: sexe!, photo: petImageToInsert, age: age, petName: petName, petDescription: petDescription, longitude: longitude, latitude: latitude, type: type, breed: breed  ) { (error: Error?, success: Bool) in
            if success {
                
                let alert = UIAlertController(title: "Pet Added!", message: "Congratulation you have added a pet!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler:
                    {(alert: UIAlertAction!) in
                        
                        self.performSegueToReturnBack()

                        print("ok pressed")
                }
                ))
                self.present(alert, animated: true, completion: nil)
//                self.performSegue(withIdentifier: "homeSegue", sender: self)
            } else {
                let alert = UIAlertController(title: "Pet not added!", message: "Make sure to use valid informations!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                return
                // say sorry to user and try again
            }
        }
        
        
    }
    
    
    @IBAction func cancelAction(_ sender: Any) {
        self.performSegueToReturnBack()
    }
    
    func performSegueToReturnBack()  {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    var petImageToInsert: UIImage?
    @objc func tappedMe()
    {
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                print(photo.fromCamera) // Image source (camera or library)
                print(photo.image) // Final image selected by the user
                print(photo.originalImage) // original image selected by the user, unfiltered
                print(photo.modifiedImage) // Transformed image, can be nil
                print(photo.exifMeta) // Print exif meta data of original image.
                self.petImageToInsert = photo.image
                self.petImage.image = photo.image
            }
            picker.dismiss(animated: true, completion: nil)
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        //roundCorners
        FetchData()
        petImage.layer.cornerRadius = petImage.frame.size.width/2
        petImage.layer.cornerRadius=50;
        petImage.layer.borderWidth=2.0;
        petImage.layer.masksToBounds = true;
        
        //onClick profile pic
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tappedMe))
        petImage.addGestureRecognizer(tap)
        petImage.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
        
        
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
