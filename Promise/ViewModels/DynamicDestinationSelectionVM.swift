//
//  DynamicDestinationSelectionVM.swift
//  Promise
//
//  Created by kwh on 4/29/24.
//

import Foundation
import NMapsMap

class DynamicDestinationSelectionVM: NSObject {
    let size = 15
    
    var detailAddress = ""
    var getRecommendedPlaceByPointLoading = false
    
    // var recommendedPlaceMarkers
    
    var recommendedPlaceListInfoDidChange: ((KakaoPlaceMDL) -> Void)?
    var recommendedPlaceListInfo: KakaoPlaceMDL? = nil {
        didSet {
            if let recommendedPlaceListInfo {
                recommendedPlaceListInfoDidChange?(recommendedPlaceListInfo)
            }
        }
    }
    
    var middlePointDidChange: ((Components.Schemas.PointDTO) -> Void)?
    var middlePoint: Components.Schemas.PointDTO? = nil {
        didSet {
            guard let middlePoint else { return }
            
            middlePointDidChange?(middlePoint)
            
            Task {
                let result = await getRecommendedPlaceByPoint(with: middlePoint)
                
                switch result {
                case .success(let recommendedPlaceListInfo):
                    self.recommendedPlaceListInfo = recommendedPlaceListInfo
                case .failure(let errorType):
                    switch errorType {
                    case .badRequest:
                        // TODO: 추천 장소 정보 얻기 실패 에러 처리
                        break
                    default:
                        // Other Error(Network, badUrl ...)
                        break
                    }
                }
            }
            
        }
    }
    
    var promise: Components.Schemas.PromiseDTO? = nil
    
    var attendees: [SelectableAttendee] = [] {
        didSet {
            
            let selectedAttendeeIds = attendees.filter { $0.isSelected }.map { $0.info.id }
            guard 1 < selectedAttendeeIds.count else { return }
            
            getMiddlePointWithDepartures(with: selectedAttendeeIds) { middlePoint in
                self.middlePoint = middlePoint
            }
            
        }
    }
    
    init(promise: Components.Schemas.PromiseDTO?) {
        self.promise = promise
        
        super.init()
        
        guard let promise else { return }
        self.attendees = promise.attendees.map {
            SelectableAttendee(info: $0, isSelected: $0.hasStartLocation)
        }
        
        let selectedAttendeeIds = self.attendees.filter { $0.isSelected }.map { $0.info.id }
        guard 1 < selectedAttendeeIds.count else { return }
        
        getMiddlePointWithDepartures(with: selectedAttendeeIds) { middlePoint in
            self.middlePoint = middlePoint
        }
        
    }
    
    func getMiddlePointWithDepartures(
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
            case .success(let middlePoint):
                completion(middlePoint)
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
    
    func getRecommendedPlaceByPoint(with point: Components.Schemas.PointDTO ) async -> Result<KakaoPlaceMDL, NetworkError> {
        
        getRecommendedPlaceByPointLoading = true
        defer {
            getRecommendedPlaceByPointLoading = false
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let url = Config.kakaoLocalSearchApiUrl
            
            // let path = ""
            // url.appendPathComponent(path)
            
            guard var urlComponents = URLComponents(string: url.absoluteString) else {
                return .failure(.badUrl)
            }
            
            
            urlComponents.queryItems = [
                URLQueryItem(name: "category_group_code", value: CategoryGroupCode.음식점.rawValue),
                URLQueryItem(name: "x", value: String(point.longitude)),
                URLQueryItem(name: "y", value: String(point.latitude)),
                URLQueryItem(name: "radius", value: "20000"),
                URLQueryItem(name: "rect", value: ""),
                URLQueryItem(name: "page", value: "1"),
                URLQueryItem(name: "size", value: String(size)),
                URLQueryItem(name: "sort", value: "distance"),
            ]
            
            guard let requestUrl = urlComponents.url else {
                return .failure(.badUrl)
            }
            
            var request = URLRequest(url: requestUrl)
            let appKey = Config.kakaoRestAppKey
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type") // 요청타입: JSON
            request.setValue("application/json", forHTTPHeaderField: "Accept") // 응답타입: JSON
            request.setValue( "KakaoAK \(appKey)", forHTTPHeaderField: "Authorization") // REST APP KEY 설정
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if (response as? HTTPURLResponse)?.statusCode == 401 {
                return .failure(.notAuthenticated)
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                
                if let errorResponse = try? decoder.decode(ErrorResponse.self, from: data) {
                    return .failure(.badRequest(BadRequestError(data: data, errorResponse: errorResponse)))
                }
                return .failure(.badRequest(BadRequestError(data: data, errorResponse: nil)))
                
            }
            
            guard let parsedData = try? decoder.decode(KakaoPlaceMDL.self, from: data) else {
                return .failure(.decodingError)
            }
            
            return .success(parsedData)
        } catch {
            return .failure(.networkError(error))
        }
        
    }
    
    func onChangedDetailAddress(_ textField: UITextField) {
        self.detailAddress = textField.text ?? ""
    }

}
