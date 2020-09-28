//
//  UIViewController+Extension.swift
//  bikeapp
//
//  Created by Dmitry Borodin on 28.09.2020.
//

import UIKit

extension UIViewController {
    /// Shows alert with error
    func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
