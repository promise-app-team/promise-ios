//
//  LocationService.swift
//  Promise
//
//  Created by 신동오 on 2023/08/04.
//

import CoreLocation
import UIKit

protocol LocationServiceDelegate: AnyObject {
    func onDidChangeAuthorization(manager: CLLocationManager)
    func onDidChangeLocationServiceOnDeivce(isEnabled: Bool)
    func onDidUpdatedUserLocation(location: CLLocation)
}

final class LocationService: NSObject {
    
    // MARK: - Static property
    
    static let shared = LocationService()
    
    // MARK: - Public property
    
    weak var delegate: LocationServiceDelegate?
    
    var authorizationStatus: CLAuthorizationStatus {
        return manager.authorizationStatus
    }
    
    var isEnabledLocationServiceOnDevice = false {
        didSet {
            delegate?.onDidChangeLocationServiceOnDeivce(isEnabled: isEnabledLocationServiceOnDevice)
        }
    }
    
    // MARK: - Private property
    
    private let manager = CLLocationManager()
    
    // MARK: - Initializer
    
    private override init() {
        super.init()
        configureManager()
        // listenAppState()
    }
    
    // MARK: - Public function
    
    func start() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func startMonitoring(
        _ latitude: CLLocationDegrees,
        _ longitude: CLLocationDegrees,
        radius: CLLocationDistance,
        identifier: String
    ) {
        
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = CLCircularRegion(center: center, radius: radius, identifier: identifier)
        manager.startMonitoring(for: region)
    }
    
    func stop() {
        manager.stopUpdatingLocation()
    }
    
    func backgroundUpdateOn() {
        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = false
    }
    
    func backgroundUpdateOff() {
        manager.allowsBackgroundLocationUpdates = false
        manager.pausesLocationUpdatesAutomatically = true
    }
    
    func checkStateForLocationServiceOnDevice() {
        Task {
            isEnabledLocationServiceOnDevice = CLLocationManager.locationServicesEnabled() && (authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways)
        }
    }
    
    // MARK: - Private function
    
    private func configureManager() {
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        
        if authorizationStatus == .authorizedAlways {
            manager.pausesLocationUpdatesAutomatically = false
            manager.allowsBackgroundLocationUpdates = true
        }

    }
    
//    private func listenAppState() {
//        NotificationCenter.default.addObserver(forName: UIScene.willEnterForegroundNotification, object: nil, queue: nil) { [weak self] _ in
//            guard let self else { return }
//            appWillEnterForeground()
//        }
//        
//        NotificationCenter.default.addObserver(forName: UIScene.didEnterBackgroundNotification, object: nil, queue: nil) { [weak self] _ in
//            guard let self else { return }
//            appDidEnterBackground()
//        }
//    }
//    
//    private func appWillEnterForeground() {
//        checkStateForLocationServiceOnDevice()
//    }
//    
//    private func appDidEnterBackground() {
//        
//    }
}

extension LocationService: CLLocationManagerDelegate {
    // TODO: 테스트
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkStateForLocationServiceOnDevice()
        delegate?.onDidChangeAuthorization(manager: manager)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        delegate?.onDidUpdatedUserLocation(location: location)
    }
}
