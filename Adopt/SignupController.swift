//
//  SignupController.swift
//  Adopt
//
//  Created by ESPRIT on 07/11/2018.
//  Copyright © 2018 ESPRIT. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON
import YPImagePicker




class SignupController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let url = URLs.signUp
    
    let token = helper.getApiToken()
    
    
    
    var config = YPImagePickerConfiguration()
    // [Edit configuration here ...]
    // Build a picker with your configuration
    
    
    
    
    @IBOutlet weak var _firstName: UITextField!
    @IBOutlet weak var _lastName: UITextField!
    @IBOutlet weak var _email: UITextField!
    @IBOutlet weak var _password: UITextField!
    @IBOutlet weak var _repassword: UITextField!
    @IBOutlet weak var _phone: UITextField!
    @IBOutlet weak var _imageView: UIImageView!
    
    

    let picker = YPImagePicker()
    var userImage: UIImage?
    
    @IBAction func selectPhoto(_ sender: UIButton) {
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                print(photo.fromCamera) // Image source (camera or library)
                print(photo.image) // Final image selected by the user
                print(photo.originalImage) // original image selected by the user, unfiltered
                print(photo.modifiedImage) // Transformed image, can be nil
                print(photo.exifMeta) // Print exif meta data of original image.
                self.userImage = photo.image
                self._imageView.image = photo.image
            }
            picker.dismiss(animated: true, completion: nil)
        }
        
        present(picker, animated: true, completion: nil)
        
    }
    
    
    @IBAction func _signUpAction(_ sender: Any) {
        guard let email = _email.text, !email.isEmpty && email.contains("@") else {return }
        guard let password = _password.text, !password.isEmpty else {return }
        guard let image = userImage else {return }
        guard let rePassword = _repassword.text, !password.isEmpty && password == rePassword else {
            let alert = UIAlertController(title: "Password & re-password must match!", message: "Verify your password!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            
            self.present(alert, animated: true)
            return
        }
        
        guard let firstName = _firstName.text, !firstName.isEmpty else {return }
        guard let lastName = _lastName.text, !lastName.isEmpty else {return }
        guard let phone = _phone.text, !phone.isEmpty else {return }

            //alamofire
        API.register(firstName: firstName, lastName: lastName, email: email, password: password, phone: phone, photo: image) { (error: Error?, success: Bool) in
            if success {
                self.performSegue(withIdentifier: "homeSegue", sender: self)
                print("Reigster succeed !! welcome to our small app :)")
            }
        }
    }
    

    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        _firstName.resignFirstResponder()
        _lastName.resignFirstResponder()
        _email.resignFirstResponder()
        _password.resignFirstResponder()
        _repassword.resignFirstResponder()
        _phone.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        _password.isSecureTextEntry = true
        _repassword.isSecureTextEntry = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        super.viewDidLoad()
        _imageView.layer.cornerRadius = _imageView.frame.size.width/2
        _imageView.clipsToBounds = true
        

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








