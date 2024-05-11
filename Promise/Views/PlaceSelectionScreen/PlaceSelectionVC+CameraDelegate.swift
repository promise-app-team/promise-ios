//
//  PlaceSelectionVC+NMFMapViewCameraDelegate.swift
//  Promise
//
//  Created by 신동오 on 4/10/24.
//

import Foundation
import NMapsMap

let clientId = "456s1eany5"
let clientSecret = "EgPNmYhiYfutCDIy9nAgexPDlFBKamwg8p4us87E"

// MARK: - NMFMapViewCameraDelegate

extension PlaceSelectionVC: NMFMapViewCameraDelegate {
    func mapView(
        _ mapView: NMFMapView,
        cameraDidChangeByReason reason: Int,
        animated: Bool
    ) {
        guard viewState == .idle else { return }
        debouncer.debounce(interval: 0.5) {
            let position = self.naverMapView.mapView.cameraPosition // 지도의 가운데 좌표
            self.reverseGeocode(from: position) { (data) in
                var city = ""
                var district = ""
                var roadName = ""
                var lotNumber = ""
                var building = ""
                
                guard !data.results.isEmpty else {
                    // 위도경도 reverse geocoding 결과가 없는 경우
                    self.currentPlace = PlaceSelection(buildingName: building,
                                                       lotNumberAddress: lotNumber,
                                                       roadNameAddress: roadName,
                                                       lat: position.target.lat,
                                                       lon: position.target.lng)
                    DispatchQueue.main.async {
                        self.confirmView.confirmButton.isDisabled = true
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.confirmView.confirmButton.isDisabled = false
                }
                
                let _ = data.results.filter { $0.name == "addr" }.map { addrData in
                    city = addrData.region.area1.name
                    district = addrData.region.area2.name
                    lotNumber = [addrData.region.area3.name,
                                 addrData.region.area4.name,
                                 addrData.land.number1]
                                .filter { $0 != ""}
                                .joined(separator: " ")
                    if addrData.land.number2 != "" {
                        lotNumber += "-\(addrData.land.number2)"
                    }
                }
                
                let _ = data.results.filter { $0.name == "roadaddr" }.map { roadaddrData in
                    building = roadaddrData.land.addition0.value
                    roadName = [roadaddrData.region.area1.name,
                                roadaddrData.region.area2.name,
                                roadaddrData.land.name ?? "",
                                roadaddrData.land.number1]
                        .filter { $0 != "" }
                        .joined(separator: " ")
                }
                DispatchQueue.main.async {
                    let address = self.confirmView.addressTextField.text ?? ""
                    let latitude = position.target.lat.truncated(toPlaces: 8)
                    let longitude = position.target.lng.truncated(toPlaces: 8)
                    self.currentPlace = PlaceSelection(
                        city: city,
                        district: district,
                        buildingName: building,
                        lotNumberAddress: lotNumber,
                        roadNameAddress: roadName,
                        userInputAddress: address,
                        lat: latitude,
                        lon: longitude)
                }
            }
        }
    }
}

// MARK: - Private Function

extension PlaceSelectionVC {
    private func reverseGeocode(
        from position: NMFCameraPosition,
        completion: @escaping (ReverseGeocodingMDL) -> Void
    ) {
        let endpoint = "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc"
        let coords = "\(position.target.lng),\(position.target.lat)"
        
        var urlComponents = URLComponents(string: endpoint)!
        urlComponents.queryItems = [
            URLQueryItem(name: "request", value: "coordsToaddr"),
            URLQueryItem(name: "coords", value: coords),
            URLQueryItem(name: "sourcecrs", value: "epsg:4326"),
            URLQueryItem(name: "output", value: "json"),
            URLQueryItem(name: "orders", value: "addr,roadaddr")
        ]
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        request.addValue(clientId, forHTTPHeaderField: "X-NCP-APIGW-API-KEY-ID")
        request.addValue(clientSecret, forHTTPHeaderField: "X-NCP-APIGW-API-KEY")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            do {
                let parsedData = try JSONDecoder().decode(ReverseGeocodingMDL.self, from: data)
                completion(parsedData)
                
                // MARK: - Test
                if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            // 디코딩한 JSON 데이터를 다시 JSON 형태의 문자열로 인코딩하여 프린트
                            if let jsonPrintData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
                               let jsonString = String(data: jsonPrintData, encoding: .utf8) {
                                print(jsonString)
                            }
                        }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}

class Debouncer {
    private let queue: DispatchQueue
    private var workItem: DispatchWorkItem?
    
    init(queue: DispatchQueue = DispatchQueue.main) {
        self.queue = queue
    }
    
    func debounce(interval: TimeInterval, action: @escaping (() -> Void)) {
        workItem?.cancel()
        workItem = DispatchWorkItem { action() }
        queue.asyncAfter(deadline: .now() + interval, execute: workItem!)
    }
}
