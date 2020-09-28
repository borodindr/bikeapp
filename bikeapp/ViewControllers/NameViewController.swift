//
//  NameViewController.swift
//  bikeapp
//
//  Created by Dmitry Borodin on 21.09.2020.
//

import UIKit
import RxSwift
import RxCocoa

class NameViewController: InputViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var firstNameTextField: MaterialTextField!
    @IBOutlet weak var lastNameTextField: MaterialTextField!
    
    
    // MARK: - Private properties
    
    private let viewModel = NameViewModel()
    private let bag = DisposeBag()
    
    override var nextButtonDestinationSegueIdentifier: String {
        "toEmail"
    }
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObservers()
    }
    
    
    // MARK: - Private methods
    
    override func prepareForNext() -> Driver<Bool> {
        viewModel.prepareForNext()
            .asDriver { [weak self] (error) in
                self?.showError(error)
                return Driver.just(false)
            }
    }
    
    private func addObservers() {
        bindTextFields()
        bindNextButtonIsEnabled()
    }
    
    private func bindTextFields() {
        firstNameTextField.rx.text
            .orEmpty
            .bind(to: viewModel.firstNameSubject)
            .disposed(by: bag)
        
        lastNameTextField.rx.text
            .orEmpty
            .bind(to: viewModel.lastNameSubject)
            .disposed(by: bag)
    }
    
    private func bindNextButtonIsEnabled() {
        viewModel.canGoNext
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: bag)
    }
    
}
