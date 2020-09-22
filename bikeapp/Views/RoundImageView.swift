//
//  RoundedCornerImageView.swift
//  bikeapp
//
//  Created by Dmitry Borodin on 21.09.2020.
//

import UIKit

@IBDesignable
class RoundedCornerImageView: UIImageView {
    
    @IBInspectable
    var cornerRadius: CGFloat = 0 {
        didSet {
            guard cornerRadius >= 0 else {
                layer.cornerRadius = frame.height / 2
                return
            }
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
}
