//
//  HomeViewController.swift
//  bikeapp
//
//  Created by Dmitry Borodin on 21.09.2020.
//

import UIKit
import RxSwift
import RxCocoa
import GoogleMaps

class HomeViewController: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var profileImageView: RoundedCornerImageView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var currentLocationButton: RoundedCornerButton!
    
    
    // MARK: - Private properties
    
    private let viewModel = HomeViewModel()
    private let bag = DisposeBag()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        addObservers()
        prepareMapView()
    }
    
    
    // MARK: - Private methods
    
    private func addObservers() {
        bindFullName()
        bindProfileImageView()
        bindCurrentLocationButton()
    }
    
    private func bindFullName() {
        viewModel.fullName
            .bind(to: fullNameLabel.rx.text)
            .disposed(by: bag)
    }
    
    private func bindProfileImageView() {
        viewModel.profileImageData
            .compactMap({ $0 })
            .map { UIImage(data: $0) }
            .bind(to: profileImageView.rx.image)
            .disposed(by: bag)
    }
    
    private func bindCurrentLocationButton() {
        currentLocationButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.centerMapToCurrentPosition()
            })
            .disposed(by: bag)
    }
    
    private func prepareMapView() {
        // Show current user location
        mapView.isMyLocationEnabled = true
        // Center map on first launch
        centerMapToCurrentPosition()
    }
    
    private func centerMapToCurrentPosition() {
        viewModel.camera
            .take(1)
            .subscribe(onNext: { [weak self] camera in
                self?.mapView.animate(to: camera)
            })
            .disposed(by: bag)
    }
    
}
