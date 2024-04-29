//
//  DynamicDestinationSelectionVM.swift
//  Promise
//
//  Created by kwh on 4/29/24.
//

import Foundation

class DynamicDestinationSelectionVM: NSObject {
    // var middlePlaceList:
    
    var point: Components.Schemas.PointDTO? = nil {
        didSet {
            guard let point else { return }
            print("point: ", point)
        }
    }
    
    var promise: Components.Schemas.PromiseDTO? = nil
    
    var attendees: [SelectableAttendee] = [] {
        didSet {
            
            let selectedAttendeeIds = attendees.filter { $0.isSelected }.map { $0.info.id }
            guard 1 < selectedAttendeeIds.count else { return }
            
            getMiddleLocationWithDepartures(with: selectedAttendeeIds) { point in
                self.point = point
            }
            
        }
    }
    
    init(promise: Components.Schemas.PromiseDTO?) {
        self.promise = promise
        
        super.init()
        
        guard let promise else { return }
        self.attendees = promise.attendees.map { SelectableAttendee(info: $0, isSelected: $0.hasStartLocation) }
        
        let selectedAttendeeIds = self.attendees.filter { $0.isSelected }.map { $0.info.id }
        guard 1 < selectedAttendeeIds.count else { return }
        
        getMiddleLocationWithDepartures(with: selectedAttendeeIds) { point in
            self.point = point
        }
        
    }
    
    func getMiddleLocationWithDepartures(
        with attendeeIds: [Double],
        _ completion: @escaping ((Components.Schemas.PointDTO?) -> Void)
    ) {
        guard let id = promise?.pid else { return }
        let attendeeIdsQueryParams = attendeeIds.map { URLQueryItem(name: "attendeeIds", value: String(Int($0))) }
        
        Task {
            let result: Result<Components.Schemas.PointDTO, NetworkError> = await APIService.shared.fetch(
                method: .GET,
                path: "/promises/\(id)/middle-location",
                queryItems: attendeeIdsQueryParams
            )
            
            switch result {
            case .success(let point):
                completion(point)
            case .failure(let errorType):
                switch errorType {
                case .badRequest:
                    // TODO: 중간 위치 얻기 실패 에러 핸들링
                    break
                default:
                    // Other Error(Network, badUrl ...)
                    break
                }
            }
        }
    }
    
    func submit(_ completion: @escaping ((Components.Schemas.PromiseDTO?) -> Void)) {
        
    }
    
}
