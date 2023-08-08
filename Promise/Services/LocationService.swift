//
//  LocationService.swift
//  Promise
//
//  Created by 신동오 on 2023/08/04.
//

import CoreLocation

class LocationService {
    
    static let shared = LocationService()
    
    private let manager = CLLocationManager()
    
    init() {
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = false
    }
    
    func start() {
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
    }
    
    func startMonitoring(lat latitude: CLLocationDegrees, lon longitude: CLLocationDegrees, radius: CLLocationDistance, identifier: String) {
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = CLCircularRegion(center: center, radius: radius, identifier: identifier)
        manager.startMonitoring(for: region)
    }
    
    func stop() {
        manager.stopUpdatingLocation()
    }
}
