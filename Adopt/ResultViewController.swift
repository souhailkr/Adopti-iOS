//
//  ResultViewController.swift
//  Adopt
//
//  Created by SouhailKr on 12/13/18.
//  Copyright © 2018 ESPRIT. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ResultViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var type: String!
    var breed: String!
    var siz: String!
    var gender: String!
    var results :[Dictionary<String,Any>] = []
    let urlImage = URLs.image
    let url = URLs.showPets
    var id = Int()
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return results.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "pet")
        
        let contentView = cell?.viewWithTag(0)
        
        let Img = contentView?.viewWithTag(1) as! UIImageView
        
        let Name = contentView?.viewWithTag(2) as! UILabel
        
        let pet  = results[ indexPath.item]
        let imageDict = pet["photo"] as! String
        let name = pet["name"] as! String
        id = pet["id"] as! Int
        
        
        let image = urlImage+imageDict
        
        
        
        Img.af_setImage(withURL: URL(string: image)!)
        Name.text = name
        
        
        
        
        return cell!
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "toDetails", sender: indexPath)
        
        
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
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FetchData()
        
        // Do a!ny ad!ditional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func FetchData() {
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
            
            
            
            
            
            for json in array {
                let typo = json["type"] as! String
                let sizo = json["size"] as! String
                let gendero = json["sexe"] as! String
                let breedo = json["breed"] as! String
                if ((typo == self.type!) && (sizo == self.siz!) && (gendero == self.gender!) && (breedo == self.breed!))
                {
                    self.results.append(json )
                    print("found")
                    
                }
                else if ((typo == self.type!) && ("Any" == self.siz!) && (gendero == self.gender!) && (breedo == self.breed!))
                    
                {
                    self.results.append(json )
                    print("found")
                    
                }
                else if ((typo == self.type!) && ("Any" == self.siz!) && ("Any" == self.gender!) && (breedo == self.breed!))
                    
                {
                    self.results.append(json )
                    print("found")
                    
                }
                    
                else if ((typo == self.type!) && (sizo == self.siz!) && ("Any" == self.gender!) && (breedo == self.breed!))
                    
                {
                    self.results.append(json )
                    print("found")
                    
                }
                else{
                    print("not found")
                }
                self.tableView.reloadData()
            }
            
        }
        
    }
}
