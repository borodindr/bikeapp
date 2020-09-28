//
//  String+Extension.swift
//  bikeapp
//
//  Created by Dmitry Borodin on 27.09.2020.
//

import Foundation

extension String {
    /// Checks if string is valid password
    var isPassword: Bool {
        count > 6
    }
    
    /// Checks if string is valid email
    var isEmail: Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
}
