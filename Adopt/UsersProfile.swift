//
//  UsersProfile.swift
//  Adopt
//
//  Created by mmi on 14/01/2019.
//  Copyright © 2019 ESPRIT. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class UsersProfile: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource
{
    
    @IBOutlet weak var userEmail: UILabel!
    
    @IBOutlet weak var postsLabel: UILabel!
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var postsCollections: UICollectionView!
    
    
    var photoThumbnail: UIImage!
    var iconName = NSString()
    var id = Int()
    
    
    var imageArray = ["1","2","3","4"]
    var ima = [UIImage(named : "1"),UIImage(named : "2"),UIImage(named : "3"),UIImage(named : "4")]
    //change user source
    var user : Dictionary<String, Any> = [:]
    
    @IBOutlet weak var firstLastName: UILabel!
    
    let urlImage = URLs.image
    
    
    var movieId:Int?
    
    var petShows : NSArray = []
    var cats :[Dictionary<String,Any>] = []
    var dogs :[Dictionary<String,Any>] = []
    var others :[Dictionary<String,Any>] = []
    var list : [String: Any] = [:]
    
    var imageDict2 = String()
    
    
    //user to pass to edit
    var userOn: [Dictionary<String,Any>] = []
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        if (self.cats.count == 0) {
            self.postsCollections.setEmptyMessage("No data found")
        } else {
            self.postsCollections.restore()
        }
        return self.cats.count
        
        
        //return cats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellule = collectionView.dequeueReusableCell(withReuseIdentifier: "cellule", for: indexPath)  as! PostCollectionViewCell
        
        if (collectionView == self.postsCollections)
        {
            
            
            //cellule.imageView.image = (imageArray [indexPath.row])
            let pet  = cats[ indexPath.item]
            let imageDict = pet["photo"] as! String
            
            
            let img = cellule.imageView
            let image = urlImage+imageDict
            
            
            img?.af_setImage(withURL: URL(string: image)!)
            
            
   
        }
        
        
        return cellule
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        _ = collectionView.cellForItem(at: indexPath) as! PostCollectionViewCell
        
        
        if collectionView == self.postsCollections
        {
            
            let pet  = cats[ indexPath.item]
            id = pet["id"] as! Int
        }
        
        performSegue(withIdentifier: "toDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDetails"{
            
            
            if let destViewController : Details2ViewController = segue.destination as! Details2ViewController
            {
                
                destViewController.id = id
                print(id)
                
            }
        }
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    override func viewDidLoad() {
        //setupNavigationBarItems()
        userImage.layer.cornerRadius = userImage.frame.size.width/2
        userImage.clipsToBounds = true
        super.viewDidLoad()
        //user from UserDefaults
        FetchData()
        
        
        
        // Do any additional setup after loading the view.
    }
    

    
    func FetchData() {
        let id = self.user["id"] as! Int
        let idstring = String(id)
        let url = URLs.profile + idstring
        let token: String? = helper.getApiToken()
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": "Bearer \(token!)"
        ]
        
        Alamofire.request(url, headers:headers).responseJSON{
            response in
            let array = response.result.value as! [[String: Any]]
            for json in array {
                print(json)
                let id = json["UserId"] as! Int
                //hadhi lazem tetbadal
                if (String(id) == idstring)
                {
                    if(!array.isEmpty){
                        self.cats.append(json )
                    }else{
                        print("empty array")
                    }
                }
            }
            if(array.isEmpty){
                print("no user found")
            }else{
                self.list = array[0]
                let user = self.user
                self.userOn.append(user)
                //print(user)
                self.imageDict2 = user["photo"] as! String
                let image = self.urlImage+self.imageDict2
                self.userImage.af_setImage(withURL: URL(string: image)!)
                self.firstLastName.text = (user["firstName"] as! String)
                self.userEmail.text = user["email"] as? String
                self.postsLabel.text = String(self.cats.count)
                self.petShows = response.result.value as! NSArray
                self.postsCollections.reloadData()
            }
        }
    }
}


