//
//  InputViewController.swift
//  bikeapp
//
//  Created by Dmitry Borodin on 27.09.2020.
//

import UIKit
import RxSwift
import RxCocoa

class InputViewController: UIViewController {
    
    // MARK: - UI elements
    
    lazy var nextButton: UIButton = {
        let button = RoundedCornerButton()
        button.setTitle(nil, for: .normal)
        button.setImage(#imageLiteral(resourceName: "Arrow"), for: .normal)
        button.cornerRadius = 38 / 2
        button.borderWidth = 2
        let color = UIColor(named: "AppTintColor") ?? .black
        button.borderColor = color
        button.tintColor = color
        return button
    }()
    
    /// You must override this property to provide identifier for segue on Next button tap
    var nextButtonDestinationSegueIdentifier: String {
        fatalError("`nextButtonDestinationSegueIdentifier` was not set")
    }
    
    
    // MARK: - Private properties
    
    // Constraint to change on keyboard appear/disappear
    private var nextButtonBottomToSuperviewBottomConstraint: NSLayoutConstraint!
    private let bag = DisposeBag()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(true, animated: false)
        addNextButton()
        bindNextButtonAction()
        subscribeOnKeyboardAppear()
        subscribeOnKeyboardDisappear()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    /// Override this method to make additional preparation on next button tap and tell if segue can be performed. Default returns true
    func prepareForNext() -> Driver<Bool> {
        Driver.just(true)
    }
    
    private func addNextButton() {
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nextButton)
        nextButtonBottomToSuperviewBottomConstraint = NSLayoutConstraint(item: nextButton,
                                                                         attribute: .bottom,
                                                                         relatedBy: .equal,
                                                                         toItem: view.safeAreaLayoutGuide,
                                                                         attribute: .bottom,
                                                                         multiplier: 1,
                                                                         constant: -11)
        NSLayoutConstraint.activate([
            nextButton.widthAnchor.constraint(equalToConstant: 38),
            nextButton.heightAnchor.constraint(equalToConstant: 38),
            nextButtonBottomToSuperviewBottomConstraint,
            nextButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16)
        ])
    }
    
    private func bindNextButtonAction() {
        nextButton.rx.tap
            // Check if segue can be be performed
            .flatMap { [weak self] _ -> Driver<Bool> in
                guard let self = self else {
                    return Driver.just(false)
                }
                return self.prepareForNext()
            }
            .bind { [weak self] canPerform in
                guard let self = self, canPerform else { return }
                self.performSegue(withIdentifier: self.nextButtonDestinationSegueIdentifier, sender: self)
            }
            .disposed(by: bag)
    }
    
    private func subscribeOnKeyboardAppear() {
        let center = NotificationCenter.default
        center.addObserver(self,
                           selector: #selector(handleKeyboardAppear),
                           name: UIResponder.keyboardWillShowNotification,
                           object: nil)
    }
    
    private func subscribeOnKeyboardDisappear() {
        let center = NotificationCenter.default
        center.addObserver(self,
                           selector: #selector(handleKeyboardDisappear),
                           name: UIResponder.keyboardWillHideNotification,
                           object: nil)
    }
    
    
    @objc
    private func handleKeyboardAppear(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardBeginFrame = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect,
            let keyboardEndFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            keyboardBeginFrame != keyboardEndFrame else { return }
        
        // Change constraint of Next button
        let bottomSafeAreaHeight = view.safeAreaInsets.bottom
        let newConstant = keyboardEndFrame.height + 11 - bottomSafeAreaHeight
        nextButtonBottomToSuperviewBottomConstraint.constant = -newConstant
        view.layoutIfNeeded()
    }
    
    @objc
    private func handleKeyboardDisappear(_ notification: Notification) {
        // Reset constraint of Next button
        let newConstant: CGFloat = -11
        if nextButtonBottomToSuperviewBottomConstraint.constant != newConstant {
            nextButtonBottomToSuperviewBottomConstraint.constant = newConstant
            view.layoutIfNeeded()
        }
    }
}
