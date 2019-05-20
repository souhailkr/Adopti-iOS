//
//  FavouriteController.swift
//  Adopt
//
//  Created by SouhailKr on 11/14/18.
//  Copyright © 2018 ESPRIT. All rights reserved.
//

import UIKit
import CoreData
import AlamofireImage

class FavouriteController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let urlImage = URLs.image
    
    
    
    var petsArray: [NSManagedObject] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petsArray.count
    }
    
    @IBOutlet weak var tableView: UITableView!
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pet") as! UITableViewCell
        let content = cell.viewWithTag(0)
        let petImg = content!.viewWithTag(1) as! UIImageView
        let petLabel = content!.viewWithTag(2) as! UILabel
        let petDesc = content!.viewWithTag(3) as! UITextView
        
        let pet = petsArray[indexPath.row]
        //petImg.image = UIImage(named: pet.value(forKey: "petImage") as! String)
        
        let image = pet.value(forKey: "petImage") as! String
        petImg.af_setImage(withURL: URL(string: urlImage+image)!)
        
        petLabel.text = pet.value(forKey: "petName") as! String
        petDesc.text = pet.value(forKey: "petDesc") as! String
        let petId = pet.value(forKey: "petId") as! Int
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "toDetails", sender: indexPath)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let index = sender as? NSIndexPath
        
        if segue.identifier == "toDetails"{
            
            if let destinationViewController =  segue.destination as? DetailsController{
                var selectedItem: NSManagedObject = petsArray[index!.item] as NSManagedObject
                destinationViewController.id =  selectedItem.value(forKey: "petId") as! Int
            }
        }
    }
    
    
    func fetchMovies() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject> (entityName: "Pet")
        
        do {
            petsArray = try context.fetch(request)
            tableView.reloadData()
        } catch  {
            print ("Error!")
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMovies()
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let petToDelete =  petsArray[indexPath.row]
            context.delete(petToDelete)
            
            do{
                try context.save()
                petsArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                //tableView.reloadData()
            }catch{
                print("Error")
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
