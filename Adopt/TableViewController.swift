//
//  TableViewController.swift
//  Adopt
//
//  Created by ESPRIT on 07/11/2018.
//  Copyright © 2018 ESPRIT. All rights reserved.
//

import UIKit

class TableViewController: UIViewController,UITableViewDataSource,UITableViewDelegate  {

    
  
    @IBOutlet weak var tableV: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    let petsImg = ["1","2","3","4","5","6"]
    let petsGenre = ["Cat","Dog","Mouse","Turtoise","Bird","Rabbit"]
    let locations = ["Tunis","Ariana","Sousse","Monastir","Bizerte"]
    let petNames = ["Pet 1","Pet 2","Pet 3","Pet 4","Pet 5", "Pet 6"]
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Pets")
        let contentView = cell?.viewWithTag(0)
        let petImg = contentView?.viewWithTag(1) as! UIImageView
        let petName = contentView?.viewWithTag(2) as! UILabel
        let petGenre = contentView?.viewWithTag(3) as! UILabel
        let location = contentView?.viewWithTag(4) as! UILabel
        petImg.image = UIImage(named:petsImg[indexPath.item])
        petName.text = petNames[indexPath.item]
        petGenre.text = petsGenre[indexPath.item]
        location.text = locations[indexPath.item]
        return cell!
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
        
    }
    
    
    
    
    
    
    
    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
