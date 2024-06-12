//
//  PlaceLocationMDL.swift
//  Promise
//
//  Created by 신동오 on 5/11/24.
//

import Foundation

struct PlaceLocationMDL {
    var city: String // 00시
    var district: String // 00구
    var address1: String // 도로명 ?? 지번
    var name: String? // 건물 이름, 장소 이름 등
    var address2: String? // 사용자 입력 주소
    var latitude: String
    var longitude: String
}
