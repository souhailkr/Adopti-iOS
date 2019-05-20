//
//  UserViewController.swift
//  Adopt
//
//  Created by SouhailKr on 12/11/18.
//  Copyright © 2018 ESPRIT. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImage.layer.cornerRadius = userImage.frame.size.width/2
        userImage.clipsToBounds = true
        

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
