//
//  helper.swift
//  Adopt
//
//  Created by mmi on 23/12/2018.
//  Copyright © 2018 ESPRIT. All rights reserved.
//

import UIKit

class helper: NSObject {
    class func restartApp() {
        guard let window = UIApplication.shared.keyWindow else { return }
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        var vc: UIViewController
        if getApiToken() == nil {
            // go to auth screen
            vc = sb.instantiateInitialViewController()!
        } else {
            // go to main screen
            vc = sb.instantiateViewController(withIdentifier: "main")
        }
        
        window.rootViewController = vc
        
        UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromTop, animations: nil, completion: nil)
    }
    
//    class func saveUserId(id: Int) {
//        // save api token to UserDefaults
//        print(id)
//        let def = UserDefaults.standard
//        def.setValue(id, forKey: "userId")
//        def.synchronize()
//    }
//    class func getUserId() -> Int? {
//        let def = UserDefaults.standard
//        return def.object(forKey: "userId") as? Int
//    }
    
    class func deleteToken(){
        let def = UserDefaults.standard
        def.removeObject(forKey: "id")
        def.removeObject(forKey: "firstName")
        def.removeObject(forKey: "lastName")
        def.removeObject(forKey: "email")
        def.removeObject(forKey: "photo")
        
        def.removeObject(forKey: "token")
        def.synchronize()
    }
    
    
    class func saveApiToken(token: String) {
        // save api token to UserDefaults
        //print(token)
        let def = UserDefaults.standard
        def.setValue(token, forKey: "token")
        def.synchronize()
        
        //restartApp()
    }
    
    class func getUser() -> Dictionary<String, String>{
        let def = UserDefaults.standard
        let id = def.object(forKey: "id") as! String
        let firstName = def.object(forKey: "firstName") as! String
        let lastName = def.object(forKey: "lastName") as! String
        let email = def.object(forKey: "email") as! String
        let phone = def.object(forKey: "phone") as! String
        let photo = def.object(forKey: "photo") as! String
        
        var userOnline: [String : String] = [:]
        
        userOnline = ["id": id, "firstName": firstName, "lastName": lastName, "email": email, "phone": phone, "photo": photo]
        
        
        
        return userOnline
    }
    
//    class func updateUser(firstName: String, lastName: String, email: String, phone: String, photo: String){
//        let def = UserDefaults.standard
//        def.
//    }
//
    class func saveUser(id: String, firstName: String, lastName: String, email: String, phone: String, photo: String){
        let def = UserDefaults.standard
        def.setValue(id, forKey: "id")
        def.setValue(firstName, forKey: "firstName")
        def.setValue(lastName, forKey: "lastName")
        def.setValue(email, forKey: "email")
        def.setValue(phone, forKey: "phone")
        def.setValue(photo, forKey: "photo")
        def.synchronize()
        
    }
    
    class func getApiToken() -> String? {
        let def = UserDefaults.standard
        return def.object(forKey: "token") as? String
    }
    
    struct UserS: Codable {
        var id: String
        var firstName: String
        var lastName: String
        var email: String
        var phone: String
        var photo: String
    }
}
