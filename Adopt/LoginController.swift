//
//  LoginController.swift
//  Adopt
//
//  Created by ESPRIT on 07/11/2018.
//  Copyright © 2018 ESPRIT. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FacebookLogin
import FacebookCore
import Alamofire
import AlamofireObjectMapper
import SwiftyJSON
import Foundation


class LoginController: UIViewController {

    
   
    @IBOutlet weak var emailOutlet: UITextField!
    @IBOutlet weak var passwordOutlet: UITextField!
    
    
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        guard let email = emailOutlet.text, !email.isEmpty && email.contains("@") else {return }
        guard let password = passwordOutlet.text, !password.isEmpty else {return }
        
        API.login(email: email, password: password) { (error: Error?, success: Bool) in
            if success {
                // say welcome to user
                self.performSegue(withIdentifier: "homeSegue", sender: self)
            } else {
                let alert = UIAlertController(title: "User not Found!", message: "Make sure to use valid credentiels!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                return
                // say sorry to user and try again
            }
        }
        //self.performSegue(withIdentifier: "homeSegue", sender: self)
}
    
    var dict : [String : AnyObject]!

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        passwordOutlet.isSecureTextEntry = true
        print(URLs.login)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        passwordOutlet.resignFirstResponder()
        emailOutlet.resignFirstResponder()
    }
    
    
    @IBAction func Auth(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile], viewController : self) { loginResult in
            
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in!")
                  self.getFBUserData()
            }
        }
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    print(result!)
                    print(self.dict)
                    let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let secondView =  storyboard.instantiateViewController(withIdentifier: "Home") as UIViewController
                    self.present(secondView, animated: true, completion: nil)
                }
            })
        }
    }
 
    
    //function is fetching the user data
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
