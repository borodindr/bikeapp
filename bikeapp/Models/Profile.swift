//
//  Profile.swift
//  bikeapp
//
//  Created by Dmitry Borodin on 27.09.2020.
//

import Foundation
import UIKit

// Registered user model
struct Profile: Codable {
    var firstName: String
    var lastName: String
    var email: String
    var password: String
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
    
    var imageData: Data? {
        let image: UIImage = #imageLiteral(resourceName: "ProfileImage")
        return image.pngData()
    }
}

extension Profile: Equatable { }

// Profile model used during registration
struct TempProfile {
    var firstName: String
    var lastName: String
    var email: String?
    var password: String?
    
    init(firstName: String, lastName: String, email: String?, password: String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.password = password
    }
    
    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = nil
        self.password = nil
    }
    
}
