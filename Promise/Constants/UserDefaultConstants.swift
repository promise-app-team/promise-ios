//
//  UserDefaultConstants.swift
//  Promise
//
//  Created by kwh on 1/20/24.
//

import Foundation

// MARK: 각 feature에 맞는 Key-Value를 추가할 경우 allKeys에 반드시 추가해주세요!

struct UserDefaultConstants {
    private init() {}

    static let allKeys = [
        // MARK: User
        User.ACCESS_TOKEN,
        User.REFRESH_TOKEN,
        
        // MARK: Attendee
        Attendee.HAS_SEEN_GUIDE_ATTENDEE
        
        // ...Others
    ]
    
    struct User {
        static let ACCESS_TOKEN = "ACCESS_TOKEN"
        static let REFRESH_TOKEN = "REFRESH_TOKEN"
    }

    struct Attendee {
        static let HAS_SEEN_GUIDE_ATTENDEE = "HAS_SEEN_GUIDE_ATTENDEE"
    }
    
    // ...Others
}
