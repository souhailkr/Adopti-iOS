//
//  ViewController.swift
//  Adopt
//
//  Created by ESPRIT on 07/11/2018.
//  Copyright © 2018 ESPRIT. All rights reserved.
//

import UIKit


class ViewController: UIViewController {


    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+3){
            self.performSegue(withIdentifier: "toLoginSegue", sender: nil)
        }
        
    }
   
    
    

}

