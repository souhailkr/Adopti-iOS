//
//  Config.swift
//  webservicesDemo
//
//  Created by GHAIEB Mohamed Sahbi on 01/01/19.
//  Copyright © 2019 Mohamed Sahbi GHIEB. All rights reserved.
//

import Foundation


struct URLs {
    
    static let main = "http://192.168.1.6:3000/"
    //static let main = "http://192.168.43.240:3000/"
    
    /// POST {email, password}
    static let login = main + "login"
    //POST{firstName,lastName,email,password,phone,photo}
    static let signUp = main + "signUp"
    //POST ShowAllPets
    static let showPets = main + "showallpets"
    //photos
    static let image = main + "uploads/"
    //Profile
    static let profile = main + "getPetsByUser/"
    //pet detail
    static let pet = main + "getpet/"
    //update profile
    static let update = main + "update"
    //addPet
    static let addPet = main + "addpet"
    //getPets by type
    static let getPetsByType = main + "getpets/"
    //delete pet
    static let deletePet = main + "deletepet"
}



extension String {
    func trim() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}


