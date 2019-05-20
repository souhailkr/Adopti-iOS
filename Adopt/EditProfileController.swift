//
//  EditProfileController.swift
//  Adopt
//
//  Created by mmi on 05/01/2019.
//  Copyright © 2019 ESPRIT. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import AlamofireImage
import SwiftyJSON
import Foundation
import YPImagePicker


class EditProfileController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    let token = helper.getApiToken()
    var config = YPImagePickerConfiguration()
    let urlImage = URLs.image
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var _firstName: UITextField!
    @IBOutlet weak var _lastName: UITextField!
    @IBOutlet weak var _email: UITextField!
    @IBOutlet weak var _phone: UITextField!
    @IBOutlet weak var _password: UITextField!
    @IBOutlet weak var _rePassword: UITextField!
    
    //old infos
    var picture: String!
    var first: String!
    var second: String!
    var emailOld: String!
    var phoneOld: String!
    var user: Dictionary <String,String> = [ : ]

    
    
    
    
    @IBAction func editProfileAction(_ sender: Any) {
        
        
        
        guard let email = _email.text, !email.isEmpty && email.contains("@") else {return
            let alert = UIAlertController(title: "Wrong Email!", message: "Verify your Email please!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            
            self.present(alert, animated: true)
            
        }
        guard let password = _password.text, !password.isEmpty else {return }
        guard let rePassword = _rePassword.text, !password.isEmpty && password == rePassword else {
            let alert = UIAlertController(title: "Password & re-password must match!", message: "Verify your password!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            
            self.present(alert, animated: true)
            return
        }
        
        guard let firstName = _firstName.text, !firstName.isEmpty else {return }
        guard let lastName = _lastName.text, !lastName.isEmpty else {return }
        guard let phone = _phone.text, !phone.isEmpty else {return }
        
        
        if(email.isEmpty || first.isEmpty || second.isEmpty || phone.isEmpty || password.isEmpty || rePassword.isEmpty){
            let alert = UIAlertController(title: "Empty Field!", message: "Please insert all informations!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            
            self.present(alert, animated: true)
            
        }
        
        
        
        //alamofire
        API.updateProfile(firstName: firstName, lastName: lastName, email: email, password: password, phone: phone, photo: profileImage.image!) { (error: Error?, success: Bool) in
            if success {
                let alert = UIAlertController(title: "Profile Update!", message: "Congratulation you have updated your profile!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler:
                {(alert: UIAlertAction!) in
                    
                    self.performSegueToReturnBack()
                    helper.saveUser(id: self.user["id"]!, firstName: firstName, lastName: lastName, email: email, phone: phone, photo: firstName.trim() + ".jpg")
                    print(helper.getUser())
                    print(self.user)
                    print("ok pressed")
                }
                ))
                self.present(alert, animated: true, completion: nil)
              
            }
        }
        
        
    }
    @IBAction func cancelEdit(_ sender: Any) {
        self.performSegueToReturnBack()
    }
    
    func performSegueToReturnBack()  {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        _firstName.resignFirstResponder()
        _lastName.resignFirstResponder()
        _email.resignFirstResponder()
        _password.resignFirstResponder()
        _rePassword.resignFirstResponder()
        _phone.resignFirstResponder()
    }
    
    var userImage: UIImage?
    @objc func tappedMe()
    {
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                print(photo.fromCamera) // Image source (camera or library)
                print(photo.image) // Final image selected by the user
                print(photo.originalImage) // original image selected by the user, unfiltered
                print(photo.modifiedImage) // Transformed image, can be nil
                print(photo.exifMeta) // Print exif meta data of original image.
                self.userImage = photo.image
                self.profileImage.image = photo.image
            }
            picker.dismiss(animated: true, completion: nil)
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    @objc func backAction(){
        //print("Back Button Clicked")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        helper.deleteToken()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"Login") 
        self.present(viewController, animated: true)
        
        
        
    }
    
    
    
    override func viewDidLoad() {
        _password.isSecureTextEntry = true
        _rePassword.isSecureTextEntry = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backAction))
        
        
        
        first = user["firstName"] as! String
        second = user["lastName"] as! String
        emailOld = user["email"] as! String
        phoneOld = user["phone"] as! String
        picture = user["photo"] as! String
        
        let image = urlImage+picture
        _firstName.text = first
        _lastName.text = second
        _email.text = emailOld
        _phone.text = phoneOld
        profileImage.af_setImage(withURL: URL(string: image)!)
        
        //onClick profile pic
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tappedMe))
        profileImage.addGestureRecognizer(tap)
        profileImage.isUserInteractionEnabled = true

        
        
        //print(user)
        
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
        
        //dismissKeyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        
        super.viewDidLoad()

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


