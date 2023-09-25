//
//  LocationService.swift
//  Promise
//
//  Created by 신동오 on 2023/08/04.
//

import CoreLocation

class LocationService {
    
    // MARK: - Static property
    
    static let shared = LocationService()
    
    // MARK: - Public property
    
    var authorizationStatus: CLAuthorizationStatus {
        if #available(iOS 14, *) {
            return manager.authorizationStatus
        }
        return CLLocationManager.authorizationStatus()
    }
    
    // MARK: - Private property
    
    private let manager = CLLocationManager()
    
    // MARK: - Initializer
    
    private init() {
        configureManager()
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
        identifier: String) {
            
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
    
    // MARK: - Private function
    
    private func configureManager() {
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        if authorizationStatus == .authorizedAlways {
            manager.pausesLocationUpdatesAutomatically = false
            manager.allowsBackgroundLocationUpdates = true
        }
    }
}
