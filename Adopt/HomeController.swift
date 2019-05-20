//
//  HomeController.swift
//  Adopt
//
//  Created by ESPRIT on 07/11/2018.
//  Copyright © 2018 ESPRIT. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftKeychainWrapper

class HomeController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource  {
    
    @IBOutlet weak var recentCollection: UICollectionView!
    @IBOutlet weak var allsmall: UIButton!
    
    @IBOutlet weak var allreptiles: UIButton!
    @IBOutlet weak var allbirds: UIButton!
    @IBOutlet weak var alldogs: UIButton!
    @IBOutlet weak var allcats: UIButton!
    @IBOutlet weak var collectionViewf: UICollectionView!
    @IBOutlet weak var collectionViewe: UICollectionView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewd: UICollectionView!
    @IBOutlet weak var collectionViewc: UICollectionView!
    var photoThumbnail: UIImage!
    var iconName = NSString()
    var id = Int()
    
    
    var imageArray = ["1","2","3","4"]
    var ima = [UIImage(named : "1"),UIImage(named : "2"),UIImage(named : "3"),UIImage(named : "4")]
    let url = URLs.showPets
    let urlImage = URLs.image
    
    var movieId:Int?
    
    var petShows : NSArray = []
    var cats :[Dictionary<String,Any>] = []
    var dogs :[Dictionary<String,Any>] = []
    var birds :[Dictionary<String,Any>] = []
    var reptiles :[Dictionary<String,Any>] = []
    var small :[Dictionary<String,Any>] = []
    var pets :[Dictionary<String,Any>] = []
    
    
    
    
    @IBAction func allButtons (_ sender: Any) {
        performSegue(withIdentifier: "toAll", sender: sender)
    }
    
    
    
    
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        if collectionView == self.collectionView {
            return cats.count
            
            
        }
        else if
            collectionView == self.collectionViewc {
            return dogs.count
            
            
        }
        else if
            collectionView == self.collectionViewe {
            return reptiles.count
            
            
        }
        else if
            collectionView == self.collectionViewf {
            return small.count
            
            
        }
        else if
            collectionView == self.recentCollection {
            return pets.count
            
            
        }
        
        return birds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellule = collectionView.dequeueReusableCell(withReuseIdentifier: "celu", for: indexPath)  as! FirstCellController
        cellule.imageView.layer.cornerRadius = 5
        cellule.imageView.clipsToBounds = true
        cellule.title.layer.cornerRadius = 5
        cellule.title.clipsToBounds = true
        cellule.title.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        
        //cellule.imageView.layer.borderWidth = 3
        if (collectionView == self.collectionView)
        {
            
           
            //cellule.imageView.image = (imageArray [indexPath.row])
            let tvshow  = cats[ indexPath.item]
            let imageDict = tvshow["photo"] as! String
            let image = urlImage+imageDict
            let name = tvshow["name"] as! String
            
            let img = cellule.imageView
            
            
            img?.af_setImage(withURL: URL(string: image)!)
            cellule.title.text = name
            
            
            //let iconName = imageArray[indexPath.row]
            //cellule.imageView?.image = UIImage(named: iconName)
            
            
            return cellule
        }
        else if collectionView == self.collectionViewc
        {
            
            
            //cellule.imageView.image = (imageArray [indexPath.row])
            let tvshow  = dogs[ indexPath.item]
            let imageDict = tvshow["photo"] as! String
            let name = tvshow["name"] as! String
            
            let img = cellule.imageView
            let image = urlImage+imageDict
            
            
            
            img?.af_setImage(withURL: URL(string: image)!)
            cellule.title.text = name
            
            
            //let iconName = imageArray[indexPath.row]
            //cellule.imageView?.image = UIImage(named: iconName)
            
            
            
        }
        else if collectionView == self.collectionViewd
        {
            
            
            //cellule.imageView.image = (imageArray [indexPath.row])
            let tvshow  = birds[ indexPath.item]
            let imageDict = tvshow["photo"] as! String
            let name = tvshow["name"] as! String
            
            let img = cellule.imageView
            let image = urlImage+imageDict
            
            
            
            img?.af_setImage(withURL: URL(string: image)!)
            cellule.title.text = name
            
            
            //let iconName = imageArray[indexPath.row]
            //cellule.imageView?.image = UIImage(named: iconName) 
        }
            
        else if collectionView == self.collectionViewe
        {
            
            
            //cellule.imageView.image = (imageArray [indexPath.row])
            let tvshow  = reptiles[ indexPath.item]
            let imageDict = tvshow["photo"] as! String
            let name = tvshow["name"] as! String
            
            let img = cellule.imageView
            let image = urlImage+imageDict
            
            
            
            img?.af_setImage(withURL: URL(string: image)!)
            cellule.title.text = name
            
            
            
            
            
        }
            
        else if collectionView == self.collectionViewf
        {
            
            
            //cellule.imageView.image = (imageArray [indexPath.row])
            let tvshow  = small[ indexPath.item]
            let imageDict = tvshow["photo"] as! String
            let name = tvshow["name"] as! String
            
            let img = cellule.imageView
            let image = urlImage+imageDict
            
            
            
            img?.af_setImage(withURL: URL(string: image)!)
            cellule.title.text = name
            
            
            
            
            
            
        }
            
        else if collectionView == self.recentCollection
        {
            
            
            //cellule.imageView.image = (imageArray [indexPath.row])
            let tvshow  = pets[ indexPath.item]
            let imageDict = tvshow["photo"] as! String
            let name = tvshow["name"] as! String
            
            let img = cellule.imageView
            cellule.imageView.layer.cornerRadius = cellule.imageView.frame.height / 2
            cellule.imageView.clipsToBounds = true
            let image = urlImage+imageDict
            img?.af_setImage(withURL: URL(string: image)!)
            cellule.title.text = name
        }
        return cellule
    }
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! FirstCellController
        
        
        if collectionView == self.collectionView
        {
            
            let pet  = cats[ indexPath.item]
            id = pet["id"] as! Int
        }
        else if collectionView == self.collectionViewc
        {
            
            let pet  = dogs[ indexPath.item]
            id = pet["id"] as! Int
        }
        else if collectionView == self.collectionViewd
        {
            
            let pet  = birds[ indexPath.item]
            id = pet["id"] as! Int
        }
        else if collectionView == self.collectionViewe
        {
            
            let pet  = reptiles[ indexPath.item]
            id = pet["id"] as! Int
        }
        else if collectionView == self.collectionViewf
        {
            
            let pet  = small[ indexPath.item]
            id = pet["id"] as! Int
        }
        else if collectionView == self.recentCollection
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
        
        if let button = sender as? UIButton,
            let controller = segue.destination as? ViewallController,
            segue.identifier == "toAll" {
            
            let str: String
            let tit: String
            
            
            switch button {
            case allcats: str = "Cat" ; tit = "Cats"
            case alldogs:      str = "Dog" ; tit = "Dogs"
            case allbirds:   str = "Bird" ; tit = "Birds"
            case allreptiles:   str = "Reptile" ; tit = "Reptiles"
            case allsmall:   str = "SmallFurry" ; tit = "Small&Furry"
                
                
            default: str = "" ; tit = ""
            }
            
            controller.type = str
            controller.name = tit
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewLoadSetup()
        
    }
    
    
    func viewLoadSetup(){
        self.cats.removeAll()
        self.dogs.removeAll()
        self.birds.removeAll()
        self.reptiles.removeAll()
        self.small.removeAll()
        self.pets.removeAll()
        FetchData()
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        FetchData()
//    }
    
    
    
    func FetchData() {
        self.cats.removeAll()
        self.dogs.removeAll()
        self.birds.removeAll()
        self.reptiles.removeAll()
        self.small.removeAll()
        self.pets.removeAll()
        let token: String? = helper.getApiToken()
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": "Bearer \(token!)"
        ]
        Alamofire.request(url, headers: headers).responseJSON{
            
            response in
            
//            print(response.result.value)
//            print(response)
            
            let array = response.result.value as! [[String: Any]]
            print(array)
            
            
            
            
            for json in array {
                self.pets.append(json)
                let image = json["type"] as! String
                if (image == "Cat")
                {
                    self.cats.append(json )
                }
                else if (image == "Dog")
                {
                    self.dogs.append(json )
                }
                else if (image == "Bird")
                {
                    self.birds.append(json )
                }
                else if (image == "Reptile")
                {
                    self.reptiles.append(json )
                }
                else
                {
                    self.small.append(json )
                }
                //
            }
            
            self.petShows = response.result.value as! NSArray
            
            self.collectionView.reloadData()
            self.collectionViewc.reloadData()
            self.collectionViewd.reloadData()
            self.collectionViewe.reloadData()
            self.collectionViewf.reloadData()
            self.recentCollection.reloadData()
            
            
            
            
            
        }
        
    }
}









//class HomeController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource  {
//
//    //token from keychain
//
//
//    @IBOutlet weak var collectionViewd: UICollectionView!
//    @IBOutlet weak var collectionViewc: UICollectionView!
//    @IBOutlet weak var collectionView: UICollectionView!
//    var photoThumbnail: UIImage!
//    var iconName = NSString()
//    var id = Int()
//
//
//    var imageArray = ["1","2","3","4"]
//    var ima = [UIImage(named : "1"),UIImage(named : "2"),UIImage(named : "3"),UIImage(named : "4")]
//
//    //urls
//    let url = URLs.showPets
//    let urlImage = URLs.image
//
//    var movieId:Int?
//
//    var petShows : NSArray = []
//    var cats :[Dictionary<String,Any>] = []
//    var dogs :[Dictionary<String,Any>] = []
//    var others :[Dictionary<String,Any>] = []
//
//
//
//
//
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//
//        if collectionView == self.collectionView {
//            return cats.count
//
//
//        }
//        else if
//            collectionView == self.collectionViewc {
//            return dogs.count
//
//
//        }
//
//        return others.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//          let cellule = collectionView.dequeueReusableCell(withReuseIdentifier: "celu", for: indexPath)  as! FirstCellController
//        cellule.imageView.layer.cornerRadius = 5
//         cellule.imageView.clipsToBounds = true
//         //cellule.imageView.layer.borderWidth = 3
//       if (collectionView == self.collectionView)
//       {
//
//
//        //cellule.imageView.image = (imageArray [indexPath.row])
//        let pet  = cats[ indexPath.item]
//        let imageDict = pet["photo"] as! String
//        let image = urlImage+imageDict
//        let name = pet["name"] as! String
//
//        let img = cellule.imageView
//
//
//        img?.af_setImage(withURL: URL(string: image)!)
//        cellule.title.text = name
//
//
//        //let iconName = imageArray[indexPath.row]
//        //cellule.imageView?.image = UIImage(named: iconName)
//
//
//        return cellule
//        }
//        else if collectionView == self.collectionViewc
//        {
//
//
//        //cellule.imageView.image = (imageArray [indexPath.row])
//        let pet  = dogs[ indexPath.item]
//        let imageDict = pet["photo"] as! String
//        let name = pet["name"] as! String
//
//        let img = cellule.imageView
//            let image = urlImage+imageDict
//
//
//
//        img?.af_setImage(withURL: URL(string: image)!)
//        cellule.title.text = name
//
//
//        //let iconName = imageArray[indexPath.row]
//        //cellule.imageView?.image = UIImage(named: iconName)
//
//
//
//        }
//       else if collectionView == self.collectionViewd
//       {
//
//
//        //cellule.imageView.image = (imageArray [indexPath.row])
//        let pet  = others[ indexPath.item]
//        let imageDict = pet["photo"] as! String
//        let name = pet["name"] as! String
//
//        let img = cellule.imageView
//        let image = urlImage+imageDict
//
//
//
//        img?.af_setImage(withURL: URL(string: image)!)
//        cellule.title.text = name
//
//
//        //let iconName = imageArray[indexPath.row]
//        //cellule.imageView?.image = UIImage(named: iconName)
//
//
//
//        }
//        return cellule
//
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        let cell = collectionView.cellForItem(at: indexPath) as! FirstCellController
//
//
//         if collectionView == self.collectionView
//        {
//
//        let pet  = cats[ indexPath.item]
//        id = pet["id"] as! Int
//         }
//            else if collectionView == self.collectionViewc
//            {
//
//                let pet  = dogs[ indexPath.item]
//                id = pet["id"] as! Int
//        }
//         else if collectionView == self.collectionViewd
//         {
//
//            let pet  = others[ indexPath.item]
//            id = pet["id"] as! Int
//        }
//
//
//
//
//            performSegue(withIdentifier: "toDetails", sender: self)
//        }
//
//override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//    if segue.identifier == "toDetails"{
//
//
//        if let destViewController : DetailsController = segue.destination as? DetailsController
//    {
////    destViewController.labelText = "test"  //**** this works
////        destViewController.petImg = iconName  //**** this doesnt
//        destViewController.id = id
//
//
//    }
//    }
//
//}
//
//
//
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//
//    //getUserFromUserDefaults
//    func getUserOnline(){
//        let defaults = UserDefaults.standard
//        let test = defaults.object(forKey: "token") as? String
//        print(test!)
//        if let savedPerson = defaults.object(forKey: "SavedUser") as? Data {
//            let decoder = JSONDecoder()
//            if let loadedPerson = try? decoder.decode(helper.UserS.self, from: savedPerson) {
//                print(loadedPerson)
//            }
//        }
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        //getUserFromUserDefaults
//        getUserOnline()
//
//         FetchData()
//    }
//
//
//
//    func FetchData() {
//
//        let token: String? = helper.getApiToken()
//        //print(token!)
//        let headers = [
//            "Content-Type": "application/x-www-form-urlencoded",
//            "Authorization": "Bearer \(token!)"
//        ]
//
//        Alamofire.request(url, headers:headers).responseJSON{
//
//            response in
//
//                let array = response.result.value as! [[String: Any]]
//
//
//
//
//
//            for json in array {
//                let type = json["type"] as! String
//                if (type == "Cat")
//                {
//                self.cats.append(json )
//                }
//                else if (type == "Dog")
//                {
//                    self.dogs.append(json )
//                }
//                else
//                {
//                    self.others.append(json )
//                }
//
//            }
//
//            self.petShows = response.result.value as! NSArray
//
//            self.collectionView.reloadData()
//            self.collectionViewc.reloadData()
//            self.collectionViewd.reloadData()
//
//
//        }
//
//    }
//}
