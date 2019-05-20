//
//  ViewallController.swift
//  Adopt
//
//  Created by SouhailKr on 1/4/19.
//  Copyright © 2019 ESPRIT. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage


class ViewallController: UICollectionViewController {
    
    @IBOutlet var viewAll: UICollectionView!
    
    let url = URLs.getPetsByType
    let urlImage = URLs.image
    var pets :[Dictionary<String,Any>] = []
    var type = String()
    var name = String()
    var id = Int()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FetchData()
        self.navigationItem.title = name
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        
        // Do any additional setup after loading the view.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return pets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Configure the cell
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellule", for: indexPath)
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        let name = cell.viewWithTag(2) as! UILabel
        let breed = cell.viewWithTag(3) as! UILabel
        
        
        let tvshow  = pets[ indexPath.item]
        let imageDict = tvshow["photo"] as! String
        let nameValue = tvshow["name"] as! String
        let breedValue = tvshow["breed"] as! String
        
        let image = urlImage+imageDict
        name.text = nameValue
        breed.text = breedValue
        
        
        
        
        imageView.af_setImage(withURL: URL(string: image)!)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellule", for: indexPath)
        
        
        if collectionView == self.collectionView
        {
            
            let pet  = pets[ indexPath.item]
            id = pet["id"] as! Int
        }
        
        
        
        performSegue(withIdentifier: "toDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDetails"{
            
            
            if let destViewController : DetailsController = segue.destination as! DetailsController
            {
                
                destViewController.id = id
                print(id)
                
            }
        }
    }
    
    
    
    func FetchData() {
        let token: String? = helper.getApiToken()
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": "Bearer \(token!)"
        ]

        Alamofire.request(url+type, headers:headers).responseJSON{
            
            response in
            print(response.result.value)
            print(response)
            let array = response.result.value as! [[String: Any]]
            print(array)
            for json in array {
                self.pets.append(json)
                //
            }
            self.viewAll.reloadData()
        }
        
    }
    
    
    
}
