//
//  ProfileViewController.swift
//  Adopt
//
//  Created by SouhailKr on 12/11/18.
//  Copyright © 2018 ESPRIT. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class ProfileViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    
    
    
    @IBOutlet weak var userEmail: UILabel!
    
    @IBOutlet weak var postsLabel: UILabel!
    
    @IBOutlet weak var userImage: UIImageView!

    @IBOutlet weak var postsCollections: UICollectionView!
    
    
    var photoThumbnail: UIImage!
    var iconName = NSString()
    var id = Int()
    
    
    var imageArray = ["1","2","3","4"]
    var ima = [UIImage(named : "1"),UIImage(named : "2"),UIImage(named : "3"),UIImage(named : "4")]
    let user = helper.getUser()
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
    


    @IBAction func _editProfile(_ sender: Any) {
        performSegue(withIdentifier: "editProfileSegue", sender: self)
    }
    

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
            
            
            
            //let iconName = imageArray[indexPath.row]
            //cellule.imageView?.image = UIImage(named: iconName)
            
            
            
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
            
            
            if let destViewController : DetailsController = segue.destination as! DetailsController
            {
                
                destViewController.id = id
                print(id)
                
            }
        }
        
        
        
        
        if segue.identifier == "editProfileSegue"{
            if let destViewController : EditProfileController = (segue.destination as! EditProfileController)
            {
              
                destViewController.user = user

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
    
    private func setupNavigationBarItems(){
        let settings  = UIImage(named: "settings")
        let rightbarButton = UIButton(type: .system)
 rightbarButton.setImage(settings?.withRenderingMode(.alwaysOriginal), for: .normal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightbarButton)
    }

    func FetchData() {
        
        let url = URLs.profile + String(user["id"]!)
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
                if (String(id) == String(self.user["id"]!))
                {
                    print("------------------------------------")
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
                self.imageDict2 = user["photo"]!
                let image = self.urlImage+self.imageDict2
                self.userImage.af_setImage(withURL: URL(string: image)!)
                self.firstLastName.text = user["firstName"]! + " " + user["lastName"]!
                self.userEmail.text = user["email"]!
                self.postsLabel.text = String(self.cats.count)
                self.petShows = response.result.value as! NSArray
                self.postsCollections.reloadData()
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



//extention test collectionView
extension UICollectionView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "Avenir-Light", size: 18)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
    }
    
    func restore() {
        self.backgroundView = nil
    }
}
