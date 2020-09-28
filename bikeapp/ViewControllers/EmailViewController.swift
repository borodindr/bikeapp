//
//  EmailViewController.swift
//  bikeapp
//
//  Created by Dmitry Borodin on 21.09.2020.
//

import UIKit
import RxSwift
import RxCocoa

class EmailViewController: InputViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var emailTextField: MaterialTextField!
    
    
    // MARK: - Private properties
    
    private var viewModel = EmailViewModel()
    private let bag = DisposeBag()
    
    override var nextButtonDestinationSegueIdentifier: String {
        "toPassword"
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
        emailTextField.rx.text
            .orEmpty
            .bind(to: viewModel.emailSubject)
            .disposed(by: bag)
    }
    
    private func bindNextButtonIsEnabled() {
        viewModel.canGoNext
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: bag)
    }
    
}
