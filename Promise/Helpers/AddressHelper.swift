//
//  AddressHelper.swift
//  Promise
//
//  Created by kwh on 5/10/24.
//

import Foundation

struct AddressHelper {
    /** 도로명 및 지번 주소를 모두 처리할 수 있는 정규 표현식 패턴
     
     >  아래 예시 커버 완료
     
     - "서울특별시 관악구 신림로 46-17 비전하우스 206호"
     - "서울특별시 관악구 신림동 231-36 비전하우스 206호"
     - "서울 관악구 신림로3가길 46-17 비전하우스 206"
     - "서울 관악구 신림로 339"
     - "경기 양평군 양평읍 양평시장길17번길 6 2층"
     - "부산광역시 해운대구 우동 1106 센텀파크아파트 101동 1504호"
     - "부산광역시 해운대구 센텀중앙로 97 11층"

    */
    let parseAddressPattern = "^(\\S+(?:시|도|광역시|특별시|특별자치시|특별자치도)?)\\s+(\\S+(?:구|군|시|읍|면))\\s+((?:\\S+로|\\S+길|\\S+동|\\S+리)\\s.*)$"
    
    func parseAddress(_ address: String) -> (city: String?, district: String?, address1: String?) {
        let regex = try! NSRegularExpression(pattern: parseAddressPattern, options: [])

        // 정규 표현식을 이용한 주소 분석
        if let match = regex.firstMatch(in: address, options: [], range: NSRange(location: 0, length: address.utf16.count)) {
            if let cityRange = Range(match.range(at: 1), in: address),
               let districtRange = Range(match.range(at: 2), in: address),
               let address1Range = Range(match.range(at: 3), in: address) {
                let city = String(address[cityRange])
                let district = String(address[districtRange])
                let address1 = String(address[address1Range])
                return (city, district, address1)
            }
        }
        
        // 주소 형식이 맞지 않을 경우 nil 반환
        return (nil, nil, nil)
    }
    
    func getDisplayAddressText(place: Components.Schemas.InputUpdatePromiseDTO.destinationPayload) -> String {
        var etcAddress = ""
        if let address2 = place.value1.address2, !address2.isEmpty {
            etcAddress = "(\(address2))"
        }
        
        return place.value1.city + " "
        + place.value1.district + " "
        + place.value1.address1 + " "
        + etcAddress
    }
    
    func getDisplayAddressText(place: Components.Schemas.PromiseDTO.destinationPayload) -> String {
        var etcAddress = ""
        if let address2 = place.value1.address2, !address2.isEmpty {
            etcAddress = "(\(address2))"
        }
        
        return place.value1.city + " "
        + place.value1.district + " "
        + place.value1.address1 + " "
        + etcAddress
    }
    
    func getDisplayAddressText(place: Components.Schemas.LocationDTO) -> String {
        var etcAddress = ""
        if let address2 = place.address2, !address2.isEmpty {
            etcAddress = "(\(address2))"
        }
        
        return place.city + " "
        + place.district + " "
        + place.address1 + " "
        + etcAddress
    }
    
    func getDisplayAddressText(place: Components.Schemas.InputLocationDTO) -> String {
        var etcAddress = ""
        if let address2 = place.address2, !address2.isEmpty {
            etcAddress = "(\(address2))"
        }
        
        return place.city + " "
        + place.district + " "
        + place.address1 + " "
        + etcAddress
    }
}
