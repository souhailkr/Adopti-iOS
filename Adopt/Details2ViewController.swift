//
//  DetailsController.swift
//  Adopt
//
//  Created by SouhailKr on 11/13/18.
//  Copyright © 2018 ESPRIT. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import AlamofireImage
import SwiftKeychainWrapper
import MessageUI

class Details2ViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    
    @IBOutlet weak var desc: UILabel!
    
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var size: UILabel!
    @IBOutlet weak var breed: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    var labelText = String()
    var myImage: UIImage!
    var imageDict = String()
    var imageDict2 = String()
    var phonenumber = String()
    var useremail = String()
    var petDetails : NSArray = []
    var id = Int()
    let url = URLs.pet
    let urlImage = URLs.image
    
    var lat = Double()
    var long = Double()
    
    var pet :  [AnyObject] = []
    var list : [String: Any] = [:]
    let btn1 = UIButton(type: .custom)
    let btn2 = UIButton(type: .custom)
    var otherUser: Dictionary<String, Any> = [:]
    var idUser: Int?
    
    
    
    var userOn: Dictionary<String,String> = helper.getUser()
    
    
    
    
    
    @IBAction func sendMail(_ sender: Any) {
        let mailComposeViewController = configureMailController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            showMailError()
        }
        
    }
    
    
    func configureMailController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients([self.useremail])
        mailComposerVC.setSubject("Adopti Application")
        mailComposerVC.setMessageBody("", isHTML: false)
        
        return mailComposerVC
    }
    
    func showMailError() {
        let sendMailErrorAlert = UIAlertController(title: "Could not send email", message: "Your device could not send email", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func callUser(_ sender: UIButton) {
        guard let number = URL(string: "tel://" + self.phonenumber) else { return }
        UIApplication.shared.open(number)
        
        //        UIApplication.shared.open(number, options: [:], completionHandler: nil)
    }
    
    @objc func tappedMe()
    {
        performSegueToReturnBack()
    }
    
    func performSegueToReturnBack()  {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //delete Pet
    @objc func deletePet(){
        let alert = UIAlertController(title: "Warning!", message: "Do you wanna delete this post?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            //            print("Handle Ok logic here")
            API.delete(id: self.id) { (error: Error?, success: Bool) in
                if success {
                    // say welcome to user
                    self.performSegueToReturnBack()
                    
                } else {
                    debugPrint(error)
                    return
                    // say sorry to user and try again
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        
        //barButton
        
        self.btn2.setImage(UIImage(named: "bookmark"), for: .normal)
        self.btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        self.btn2.addTarget(self, action: #selector(self.addFavourite(_:)), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: self.btn2)
        
        self.navigationItem.setRightBarButtonItems([item2], animated: true)
        //end barButton
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        FetchData()
        super.viewDidLoad()
        userImage.layer.cornerRadius = userImage.frame.size.width/2
        userImage.clipsToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tappedMe))
        userImage.addGestureRecognizer(tap)
        userImage.isUserInteractionEnabled = true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toUser"{
            if let destViewController : DetailsController = segue.destination as? DetailsController
            {
                //    destViewController.labelText = "test"  //**** this works
                //        destViewController.petImg = iconName  //**** this doesnt
                destViewController.id = id
                
                
            }
        }else if segue.identifier == "toMapDetails"{
            
            
            if let destViewController : DetailsMapViewController = segue.destination as! DetailsMapViewController
            {
                
                destViewController.lat = lat
                destViewController.long = long
                
                print(id)
                
            }
        }else if segue.identifier == "toProfile"{
            
            
            if let destViewController : UsersProfile = segue.destination as! UsersProfile
            {
                //el user
                destViewController.user = otherUser
                
            }
        }
    }
    
    
    
    
    
    @IBAction func addFavourite(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistantContainer = appDelegate.persistentContainer
        
        let context = persistantContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Pet")
        
        request.predicate = NSPredicate(format: "petName == %@", name.text!)
        
        
        
        do {
            let resultArray = try context.fetch(request)
            if resultArray.count == 0 {
                let movieDesc = NSEntityDescription.entity(forEntityName: "Pet", in: context)
                
                var newMovie = NSManagedObject (entity: movieDesc!, insertInto: context)
                
                newMovie.setValue(imageDict, forKey: "petImage")
                newMovie.setValue(name.text, forKey: "petName")
                newMovie.setValue(desc.text, forKey: "petDesc")
                newMovie.setValue(id, forKey: "petId")
                
                
                do {
                    try context.save()
                    print ("Pet Saved !!")
                    let alertController = UIAlertController(title: "Information Alert", message:
                        "Pet saved in your favourites", preferredStyle: UIAlertController.Style.alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
                    
                    self.present(alertController, animated: true, completion: nil)
                } catch {
                    print("Error !")
                }
            }else{
                let alert = UIAlertController(title: "Duplication", message: "Pet exists in your favourites", preferredStyle: .alert)
                let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert,animated: true,completion: nil)
            }
        } catch {
            print("error")
        }
    }
    
    
    func FetchData() {
        let token: String? = helper.getApiToken()
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": "Bearer \(token!)"
        ]
        let sa = String(id)
        Alamofire.request(url+sa, headers:headers).responseJSON{
            
            response in
            
            //print(response)
            
            //print(response.result.value!)
            
            self.list = response.result.value as! [String: Any]
            let user = self.list["User"] as! Dictionary<String,Any>
            //the others
            self.otherUser = user
            
            self.phonenumber = user["num_tel"] as! String
            self.useremail = user["email"] as! String
            //addd Dlete button if it's your pet
            
            let idUserOn = self.userOn["id"]
            self.idUser = self.list["UserId"] as? Int
            let idUserString = String(self.idUser!)
            print(response.result.value!)
            print(idUserOn!)
            print(idUserString)
            if(idUserOn == idUserString){
                //barButton
                //        self.btn1 = UIButton(type: .custom)
                self.btn1.setImage(UIImage(named: "delete"), for: .normal)
                self.btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                self.btn1.addTarget(self, action: #selector(self.deletePet), for: .touchUpInside)
                let item1 = UIBarButtonItem(customView: self.btn1)
                
                
                //let btn2 = UIButton(type: .custom)
                self.btn2.setImage(UIImage(named: "bookmark"), for: .normal)
                self.btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                self.btn2.addTarget(self, action: #selector(self.addFavourite(_:)), for: .touchUpInside)
                let item2 = UIBarButtonItem(customView: self.btn2)
                
                self.navigationItem.setRightBarButtonItems([item2, item1], animated: true)
                //end barButton
            }
            
            
            //print(user)
            //self.userName = user
            //let tes = user["email"] as! String
            print(user["firstName"] as! String )
            self.userName.text = (user["firstName"] as! String)
            let profilePic = URLs.image+(user["photo"] as! String)
            self.userImage.af_setImage(withURL: URL(string: profilePic)!)
            
            self.name.text = self.list["name"] as? String
            self.desc.text = self.list["description"] as? String
            self.breed.text = self.list["breed"] as? String
            self.size.text = self.list["size"] as? String
            self.gender.text = self.list["sexe"] as? String
            let age = self.list["age"] as! Int
            self.age.text = String(age)+" Months"
            self.imageDict = self.list["photo"] as! String
            let image = self.urlImage+self.imageDict
            self.imageView.af_setImage(withURL: URL(string: image)!)
            //map
            self.lat = self.list["altitude"] as! Double
            self.long = self.list["longitude"] as! Double
        }
    }
}
