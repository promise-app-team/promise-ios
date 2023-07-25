//
//  LocationService.swift
//  Promise
//
//  Created by 신동오 on 2023/07/24.
//

import Foundation
import CoreLocation
import UIKit

class LocationService {
    
    let mgr = CLLocationManager()
    private var location: CLLocationCoordinate2D?
    
    init() {
        mgr.requestAlwaysAuthorization()
        mgr.desiredAccuracy = kCLLocationAccuracyBest
        mgr.allowsBackgroundLocationUpdates = true
    }
    
    func start() {
        mgr.startUpdatingLocation()
    }
    
    func stop() {
        mgr.stopUpdatingLocation()
    }
    
}


