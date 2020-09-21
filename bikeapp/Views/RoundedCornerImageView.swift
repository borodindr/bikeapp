//
//  RoundedCornerImageView.swift
//  bikeapp
//
//  Created by Dmitry Borodin on 21.09.2020.
//

import UIKit

class RoundeImageView: UIImageView {
    @IBInspectable
    var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
}
