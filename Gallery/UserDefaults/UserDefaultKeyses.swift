//
//  UserDefaultKeyses.swift
//  Gallery
//
//  Created by Dmitriy Budanov on 29.04.2022.
//

import UIKit

class UserDefaultKeyses {
    
    public static var shared = UserDefaultKeyses()
    
    private init() { }
    
    var pictureName: [String] {
        get {
            UserDefaults.standard.array(forKey: UDKeys.name.rawValue) as? [String] ?? []
        }
        set (newName) {
            
            UserDefaults.standard.set(newName, forKey: UDKeys.name.rawValue)
        }
    }
    
    func deletePictureName() {
        UserDefaults.standard.removeObject(forKey: UDKeys.name.rawValue)
    }
    
    private enum UDKeys: String {
        case name
        
    }
}
