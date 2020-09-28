//
//  HomeViewModel.swift
//  bikeapp
//
//  Created by Dmitry Borodin on 21.09.2020.
//

import Foundation
import RxSwift
import RxCocoa
import GoogleMaps

class HomeViewModel: NSObject {
    
    // MARK: - Public properties
    
    var fullName: Observable<String> {
        currentProfile
            .map { $0.fullName }
    }
    
    var profileImageData: Observable<Data?> {
        currentProfile
            .map { $0.imageData }
    }
    
    let camera = ReplaySubject<GMSCameraPosition>.create(bufferSize: 1)
    
    
    // MARK: - Private properties
    
    private var currentProfile: Observable<Profile> {
        Observable.just(ProfileManager.shared.currentProfile)
            .compactMap({ $0 })
    }
    private let locationManager: CLLocationManager
    private var currentLocation: CLLocation?
    private var preciseLocationZoomLevel: Float = 15.0
    private var approximateLocationZoomLevel: Float = 10.0
    
    
    // MARK: - Initializer
    
    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
}

// CL Manager Delegate
extension HomeViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        
        let zoomLevel = locationManager.accuracyAuthorization == .fullAccuracy ? preciseLocationZoomLevel : approximateLocationZoomLevel
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        self.camera.onNext(camera)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined, .restricted, .denied:
            print("Access to location is restricted.")
            // Show location of Moscow
            let zoomLevel = locationManager.accuracyAuthorization == .fullAccuracy ? preciseLocationZoomLevel : approximateLocationZoomLevel
            let camera = GMSCameraPosition.camera(withLatitude: 55.775875,
                                                  longitude: 37.627144,
                                                  zoom: zoomLevel)
            self.camera.onNext(camera)
        
        case .authorizedAlways, .authorizedWhenInUse:
            print("Location status is OK.")
        @unknown default:
            fatalError()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Location manager error: \(error)")
    }
}
