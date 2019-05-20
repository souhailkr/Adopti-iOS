//
//  SearchViewController.swift
//  Adopt
//
//  Created by SouhailKr on 12/12/18.
//  Copyright © 2018 ESPRIT. All rights reserved.
//

import UIKit
import Alamofire

class SearchViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet weak var genderView: UISegmentedControl!
    @IBOutlet weak var sizeView: UISegmentedControl!
    @IBOutlet weak var breedView: UIPickerView!
    @IBOutlet weak var typeView: UIPickerView!
    var type = String()
    var breed = String()
    var dogs:[Any] = []
    var cats:[Any] = []
    var birds:[Any] = []
    var reptiles:[Any] = []
    var small:[Any] = []
    
    let url1 = "http://api.petfinder.com/breed.list?key=1abbf326403e6d3d360d9b9a5ad90da1&animal="
    let url2 = "&format=json&fbclid=IwAR1jkUGO2w4nZU0eqAdmbSh3Ag7QUBTWV3DB8pvUqZX4ZUYR3ADrF8p_TFo"
    
    
    
    var Data: [String] = [String]()
    var selectedItemsArray : NSArray = []
    
    
    
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
                               //selectedItemsArray = []
                selectedItemsArray = cats as NSArray
                
            }
            breedView.reloadAllComponents()
            
            
            
            
        }
        breed = selectedItemsArray[row] as! String
        
    }
    
    @IBAction func search(_ sender: Any) {
        let size = sizeView.titleForSegment(at: sizeView.selectedSegmentIndex) as! String
        let gender = genderView.titleForSegment(at: genderView.selectedSegmentIndex) as! String
        print (type+breed+size+gender)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toResult"{
            if let destViewController : ResultViewController = segue.destination as! ResultViewController
            {
                //    destViewController.labelText = "test"  //**** this works
                //        destViewController.petImg = iconName  //**** this doesnt
                
                let sizo = sizeView.titleForSegment(at: sizeView.selectedSegmentIndex)
                let gendero = genderView.titleForSegment(at: genderView.selectedSegmentIndex)
                destViewController.siz = sizo as! String
                destViewController.gender = gendero as! String
                destViewController.type = type as String
                destViewController.breed = breed as String
            }
        }
        
    }
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        FetchData()
        
        
        
    }
    func FetchData()
    {
        let token: String? = helper.getApiToken()
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": "Bearer \(token!)"
        ]
        Alamofire.request(url1+"dog"+url2, headers: headers).responseJSON{
            
            
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
        
        Alamofire.request(url1+"cat"+url2, headers: headers).responseJSON{
            
            
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
        
        Alamofire.request(url1+"bird"+url2, headers: headers).responseJSON{
            
            
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
        
        Alamofire.request(url1+"reptile"+url2, headers: headers).responseJSON{
            
            
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
        
        Alamofire.request(url1+"smallfurry"+url2, headers: headers).responseJSON{
            
            
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
    
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


