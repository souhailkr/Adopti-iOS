//
//  API.swift
//  Adopt
//
//  Created by mmi on 29/12/2018.
//  Copyright © 2018 ESPRIT. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class API: NSObject {
    
    
    var window: UIWindow?
    
    class func login(email: String, password: String, completion: @escaping (_ error: Error?, _ success: Bool)->Void) {
        let url = URLs.login
        
        let parameters = [
            "email": email,
            "password": password
        ]
        
        Alamofire.request(url, method:.post, parameters:parameters, headers:nil)
                    .validate(statusCode: 200..<300)
                    .responseObject { (response: DataResponse<UserResponse>) in
                    switch response.result {
                    case .success(let data):
        
                        
                        print("-------------------------------------------------------------------")
                        let userResponse = response.result.value
                        
                        print(userResponse!.toJSONString()!)
                        
                        let token = userResponse?.token

                        helper.saveApiToken(token: token as! String)
        
                        if let user = userResponse!.user{
                            let id = userResponse?.user?.id
                            let phone = userResponse?.user?.phone
                            
                            print(id!)
                            print(user.lastName! )
                            print(user.firstName! )
                            print(user.email! )
                            print(phone!)
                            print(user.photo! )
                            
                            helper.saveUser(id: String(user.id!), firstName: user.firstName!, lastName: user.lastName!, email: user.email!, phone: String(user.phone!), photo: user.photo!)
                            
                            
                            
                            //print(user.id)
                            completion(nil, true)
                        }else {
                            completion(nil, false)
                            print("user NOT found!! login")
                            return
                            
                        }

                        print("-------------------------------------------------------------------")
        
                    case .failure(let error):
                        completion(error, false)
                        print("lalalaalalaalalalaalalaalalalaalal")
                        print(error)
                    }
        
            }
    }
    
    class func register(firstName: String, lastName: String, email: String, password: String, phone: String, photo: UIImage , completion: @escaping (_ error: Error?, _ success: Bool)->Void) {
        let url = URLs.signUp

        
        let parameters = [
            "firstName":firstName,
            "lastName":lastName,
            "num_tel":phone,
            "email":email,
            "password":password,
            ]

        Alamofire.upload(
            multipartFormData: {
                multipartFormData in
               
                
                 let imageData = photo.jpegData(compressionQuality: 0.2)
                
                let imageName = firstName.trim()
                
                //badel nom mta3 teswira
                multipartFormData.append(imageData!, withName: "photo", fileName: imageName + ".jpg", mimeType: "image/jpg")
        
                
                for (key, value) in parameters {
                    
                    if let data = value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                        multipartFormData.append(data, withName: key)
                        
                    }
                }
        }, to: url,method: .post)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                //print(result)
                print("uploading")
                upload.uploadProgress(closure: { (progress) in
                    
                    print(progress)
                })
                
                upload.responseString { response in
                    //print response.result
                    //print("the image name is:")
                    //print(response);
                    let userResponse = response.result.value
                    print(userResponse!)
                }
                
            case .failure(let encodingError):
                print(encodingError);
            }
        }
    }
    
    //addPet
    class func addPet(size: String, sexe: String, photo: UIImage, age: String, petName: String, petDescription: String, longitude: Double, latitude: Double, type: String, breed: String, completion: @escaping (_ error: Error?, _ success: Bool)->Void) {
        let url = URLs.addPet
        
        let token: String? = helper.getApiToken()
        //print(token!)
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": "Bearer \(token!)"
        ]
        let long:String = String(format:"%5f", longitude)
        let lat:String = String(format:"%5f", latitude)
        let parameters = [
            "name":petName,
            "description":petDescription,
            "sexe":sexe,
            "size":size,
            "age":age,
            "breed":breed,
            "type":type,
            "longitude":long,
            "altitude":lat
            ] 
        
        Alamofire.upload(
            multipartFormData: {
                multipartFormData in
                
                
                let imageData = photo.jpegData(compressionQuality: 0.2)
                
                let imageName = petName.trim()
                
                //badel nom mta3 teswira
                multipartFormData.append(imageData!, withName: "petImage", fileName: imageName + ".jpg", mimeType: "image/jpg")
                
                
                for (key, value) in parameters {
                    
                    if let data = value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                        multipartFormData.append(data, withName: key)
                        
                    }
                }
        }, to: url,method: .post, headers: headers)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                //print(result)
                print("uploading")
                upload.uploadProgress(closure: { (progress) in
                    
                    print(progress)
                })
                
                upload.responseString { response in
                    //print response.result
                    //print("the image name is:")
                    //print(response);
                    let userResponse = response.result.value
                    print(userResponse!)
                }
                completion(nil, true)
            case .failure(let encodingError):
                
                print(encodingError);
            }
        }
    }
    
    
    
    //delete Pet
    class func delete(id: Int, completion: @escaping (_ error: Error?, _ success: Bool)->Void) {
        let url = URLs.deletePet
        let token: String? = helper.getApiToken()
        //print(token!)
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": "Bearer \(token!)"
        ]
        let parameters = [
            "id": id,
        ]
        
        Alamofire.request(url, method:.post, parameters:parameters, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success( _):
                        print("pet deleted")
                        completion(nil, true)

                case .failure(let error):
                    print("failed")
                    completion(nil, true)
                    print(error)
                }
                
        }
    }
    
    
    
    
    
    
    
    class func updateProfile(firstName: String, lastName: String, email: String, password: String, phone: String, photo: UIImage , completion: @escaping (_ error: Error?, _ success: Bool)->Void) {
        
        let url = URLs.update
        
        let token: String? = helper.getApiToken()
        //print(token!)
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": "Bearer \(token!)"
        ]
        
        let parameters = [
            "firstName":firstName,
            "lastName":lastName,
            "num_tel":phone,
            "email":email,
            "password":password,
            ]
        
        Alamofire.upload(
            multipartFormData: {
                multipartFormData in
                
                
                let imageData = photo.jpegData(compressionQuality: 0.2)
                
                let imageName = firstName.trim()
                
                print(imageName)
                
                multipartFormData.append(imageData!, withName: "photo", fileName: imageName + ".jpg", mimeType: "image/jpg")
                
                
                for (key, value) in parameters {
                    
                    if let data = value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                        multipartFormData.append(data, withName: key)
                        
                    }
                }
        }, to: url,method: .post, headers: headers)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    
                    print(progress)
                    
                })
                
                upload.responseString { response in
                    
                    completion(nil, true)
                    //print(response);
                    let userResponse = response.result.value
                    //print(userResponse)
                }
                
            case .failure(let encodingError):
                print(encodingError);
            }
        }
    }
    
    
    
    }
    

