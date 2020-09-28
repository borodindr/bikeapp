//
//  MaterialTextField.swift
//  bikeapp
//
//  Created by Dmitry Borodin on 25.09.2020.
//

import UIKit

@IBDesignable
class MaterialTextField: UIView {
    
    // MARK: - Outlets
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var revealPasswordButton: UIButton!
    
    
    // MARK: - IB properties
    
    @IBInspectable
    var placeholderText: String? = "placeholder" {
        didSet {
            placeholderLabel.text = placeholderText
        }
    }
    
    @IBInspectable
    var text: String? = nil {
        didSet {
            textField.text = text
        }
    }
    
    @IBInspectable
    var isEmailKeyboardType: Bool = false {
        didSet {
            textField.keyboardType = isEmailKeyboardType ? .emailAddress : .default
            textField.autocapitalizationType = isEmailKeyboardType ? .none : .sentences
            textField.autocorrectionType = isEmailKeyboardType ? .no : .default
        }
    }
    
    @IBInspectable
    var isPasswordContentType: Bool = false {
        didSet {
            textField.textContentType = isPasswordContentType ? .password : nil
            textField.isSecureTextEntry = isPasswordContentType
            revealPasswordButton.isHidden = !isPasswordContentType
            
        }
    }
    
    
    // MARK: - Private properties
    
    private var isPasswordRevealed = true
    
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    
    // MARK: - Private methods
    
    private func commonInit() {
        guard let bundle = Bundle(identifier: "borodindr.bikeapp") else { return }
        bundle.loadNibNamed("MaterialTextField", owner: self, options: nil)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
    }
    
    @IBAction func revealPasswordButtonTapped(_ sender: UIButton) {
        guard isPasswordContentType else { return }
        textField.isSecureTextEntry = isPasswordRevealed
        isPasswordRevealed.toggle()
    }
    

}
