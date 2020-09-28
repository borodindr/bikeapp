//
//  UnderlinedSegmentedControl.swift
//  bikeapp
//
//  Created by Dmitry Borodin on 21.09.2020.
//

import UIKit

@IBDesignable
class UnderlinedSegmentedControl: UIView {
    
    // MARK: - IB properties
    
    @IBInspectable
    var commaSeparatedImageNames: String = " " {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var selectedItemColor: UIColor = .black {
        didSet {
            underlineView.backgroundColor = selectedItemColor
            buttons.forEach({ $0.tintColor = selectedItemColor })
        }
    }
    
    
    // MARK: - UIElements
    
    lazy var underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = selectedItemColor
        return view
    }()
    
    
    // MARK: - Private properties
    
    private var buttons: [UIButton] = []
    private var selectedIndex = 0
    
    
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
        updateView()
    }
    
    private func updateView() {
        // Reset views
        buttons = []
        subviews.forEach({ $0.removeFromSuperview() })
        
        // Get components for image names
        let names = commaSeparatedImageNames.components(separatedBy: ",")
        
        // Create buttons from each name
        let buttons = names.enumerated()
            .map { index, name -> UIButton in
                let image = UIImage(named: name)
                let button = UIButton()
                button.setImage(image, for: .normal)
                button.tintColor = selectedItemColor
                button.tag = index
                button.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
                return button
            }
        self.buttons = buttons
        
        // Create stack view for buttons
        let stackView = newStackView(with: buttons)
        addStackView(stackView)
        
        addUnderlineView()
    }
    
    private func newStackView(with views: [UIView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        return stackView
    }
    
    private func addStackView(_ stackView: UIStackView) {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func addUnderlineView() {
        let underlineWidth = frame.width / CGFloat(buttons.count)
        let underlineHeight: CGFloat = 3
        let underlineY = frame.height - underlineHeight
        underlineView.layer.cornerRadius = underlineHeight / 2
        addSubview(underlineView)
        
        underlineView.frame = CGRect(x: 0, y: underlineY, width: underlineWidth, height: underlineHeight)
    }
    
    @objc
    private func handleButtonTap(_ sender: UIButton) {
        let currentFrame = underlineView.frame
        let selectedIndex = sender.tag
        let frameWidth = frame.width / CGFloat(buttons.count)
        let newX = frameWidth * CGFloat(selectedIndex)
        let newFrame = CGRect(x: newX, y: currentFrame.origin.y, width: frameWidth, height: currentFrame.height)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.underlineView.frame = newFrame
        } completion: { (_) in
            self.selectedIndex = sender.tag
        }

    }
    
}
