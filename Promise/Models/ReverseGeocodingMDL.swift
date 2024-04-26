//
//  ReverseGeocodingMDL.swift
//  Promise
//
//  Created by 신동오 on 4/12/24.
//

import Foundation

// MARK: - ReverseGeocodingMDL
struct ReverseGeocodingMDL: Codable {
    let status: ReverseGeocodingStatus
    let results: [ReverseGeocodingResult]
//    let address: ReverseGeocodingAddress?
}

// MARK: - Status
struct ReverseGeocodingStatus: Codable {
    let code: Int
    let name, message: String
}

//// MARK: - Address
//struct ReverseGeocodingAddress: Codable {
//    let jibunAddress: String?
//    let roadAddress: String
//}

// MARK: - Result
struct ReverseGeocodingResult: Codable {
    let name: String
    let code: ReverseGeocodingCode
    let region: ReverseGeocodingRegion
    let land: ReverseGeocodingLand
}

// MARK: - Code
struct ReverseGeocodingCode: Codable {
    let id, type, mappingID: String
    
    enum CodingKeys: String, CodingKey {
        case id, type
        case mappingID = "mappingId"
    }
}

// MARK: - Region
struct ReverseGeocodingRegion: Codable {
    let area0, area1, area2, area3, area4: ReverseGeocodingArea
}

struct ReverseGeocodingArea: Codable {
    let name: String
    let coords: ReverseGeocodingCoords
}

struct ReverseGeocodingCoords: Codable {
    let center: ReverseGeocodingCenter
}

struct ReverseGeocodingCenter: Codable {
    let crs: String
    let x, y: Double
}

// MARK: - Land
struct ReverseGeocodingLand: Codable {
    let type, number1, number2: String
    let addition0, addition1, addition2, addition3, addition4: ReverseGeocodingAddition
    let coords: ReverseGeocodingCoords
    let name: String?
}

// MARK: - Addition
struct ReverseGeocodingAddition: Codable {
    let type: String
    let value: String
}

//enum ReverseGeocodingValue: String, Codable {
//    case empty = ""
//    case the06062 = "06062"
//    case the116802122001 = "116802122001"
//}
//
//enum CRS: String, Codable {
//    case empty = ""
//    case epsg4326 = "EPSG:4326"
//}
