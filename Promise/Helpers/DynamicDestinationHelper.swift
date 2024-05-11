//
//  DynamicDestinationHelper.swift
//  Promise
//
//  Created by kwh on 4/20/24.
//

import Foundation

enum DynamicDestinationState {
    case notConfigurable
    case configurable
    case configured
    case newlyConfigurable
}

struct DynamicDestinationHelper {
    
    func getConfigurableState(
        promise: Components.Schemas.PromiseDTO
    ) -> DynamicDestinationState {
        
        let attendeesCount = promise.attendees.count
        
        let hasDepartureOfAttendeesCount = promise.attendees.filter { $0.hasStartLocation }.count
        
        let isLatestDestination = promise.isLatestDestination
        
        let destinationType = promise.destinationType
        let destination = promise.destination
        
        // MARK: notConfigurable
        guard 2 <= attendeesCount, 2 <= hasDepartureOfAttendeesCount else {
            return .notConfigurable
        }
        
        // MARK: configurable, notLatest
        guard destinationType == .DYNAMIC, isLatestDestination else {
            
            // MARK: configurable, 최초 중간장소가 없는 경우
            guard destinationType == .DYNAMIC, let _ = destination else {
                return .configurable
            }
            
            // MARK: newlyConfigurable, 출발지 변경사항이 있어서 새롭게 변경될 수 있는 경우
            return .newlyConfigurable
            
        }
        
        // MARK: configured, 더이상 출발지 변경사항이 없고 중간장소가 정해진 경우
        return .configured
    }
    
}
