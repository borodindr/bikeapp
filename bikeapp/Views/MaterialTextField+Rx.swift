//
//  MaterialTextField+Rx.swift
//  bikeapp
//
//  Created by Dmitry Borodin on 27.09.2020.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: MaterialTextField {
    var text: ControlProperty<String?> {
        base.textField.rx.text
    }
}
