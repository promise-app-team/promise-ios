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
//        mgr.desiredAccuracy = .leastNormalMagnitude
        mgr.allowsBackgroundLocationUpdates = true
        mgr.pausesLocationUpdatesAutomatically = false
    }
    
    func start() {
        mgr.startUpdatingLocation()
        
        // 권한 요청
        mgr.requestAlwaysAuthorization()

        // 원형 영역 정의 (서울 시청을 중심으로 500 미터 반경의 원)
        let center = CLLocationCoordinate2D(latitude: 37.566680, longitude: 126.978414)
        let region = CLCircularRegion(center: center, radius: 500, identifier: "SeoulCityHall")
        
        // Region Monitoring 시작
        mgr.startMonitoring(for: region)
    }
    
    func stop() {
        mgr.stopUpdatingLocation()
    }
    
}


