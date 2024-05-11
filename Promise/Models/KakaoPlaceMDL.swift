//
//  KakaoPlace.swift
//  Promise
//
//  Created by 신동오 on 2024/01/11.
//

import Foundation

// MARK: - KakaoPlace
struct KakaoPlaceMDL: Codable {
    let meta: Meta?
    let documents: [Document]?
}

// MARK: - Document
struct Document: Codable {
    let addressName, categoryGroupCode, categoryGroupName, categoryName: String
    let distance, id, phone, placeName: String
    let placeURL: String
    let roadAddressName, x, y: String

    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case categoryGroupCode = "category_group_code"
        case categoryGroupName = "category_group_name"
        case categoryName = "category_name"
        case distance, id, phone
        case placeName = "place_name"
        case placeURL = "place_url"
        case roadAddressName = "road_address_name"
        case x, y
    }
}

// MARK: - Meta
struct Meta: Codable {
    let sameName: SameName?
    let pageableCount, totalCount: Int
    let isEnd: Bool

    enum CodingKeys: String, CodingKey {
        case sameName = "same_name"
        case pageableCount = "pageable_count"
        case totalCount = "total_count"
        case isEnd = "is_end"
    }
}

// MARK: - SameName
struct SameName: Codable {
    let region: [String]
    let keyword, selectedRegion: String

    enum CodingKeys: String, CodingKey {
        case region, keyword
        case selectedRegion = "selected_region"
    }
}

enum CategoryGroupCode: String {
    case 대형마트 = "MT1"
    case 편의점 = "CS2"
    case 어린이집, 유치원 = "PS3"
    case 학교 = "SC4"
    case 학원 = "AC5"
    case 주차장 = "PK6"
    case 주유소, 충전소 = "OL7"
    case 지하철역 = "SW8"
    case 은행 = "BK9"
    case 문화시설 = "CT1"
    case 중개업소 = "AG2"
    case 공공기관 = "PO3"
    case 관광명소 = "AT4"
    case 숙박 = "AD5"
    case 음식점 = "FD6"
    case 카페 = "CE7"
    case 병원 = "HP8"
    case 약국 = "PM9"
}
