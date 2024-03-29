//
//  Config.swift
//  Promise
//
//  Created by dylan on 2023/06/05.
//

import Foundation

public enum Config {
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist not found")
        }
        
        return dict
    }()
    
    static var apiURL: URL = {
        guard let baseURL = Config.infoDictionary[Keys.apiURL.rawValue] as? String else {
            fatalError("API URL not set in plist")
        }
        
        guard let url = URL(string: baseURL) else {
            fatalError("API URL is invalid")
        }
        
        return url
    }()
    
    static var apiDocURL: URL = {
        guard let url = Config.infoDictionary[Keys.apiDocUrl.rawValue] as? String else {
            fatalError("API DOC URL not set in plist")
        }
        
        guard let apiDocUrl = URL(string: url) else {
            fatalError("API DOC URL is invalid")
        }
        
        return apiDocUrl
    }()
    
    static let kakaoNativeAppKey: String = {
        guard let kakaoNativeAppKey = Config.infoDictionary[Keys.kakaoNativeAppKey.rawValue] as? String else {
            fatalError("KAKAO NATIVE APP KEY not set in plist")
        }
        
        return kakaoNativeAppKey
    }()
    
    static let universalLinkDomain: String = {
        guard let universalLinkDomain = Config.infoDictionary[Keys.universalLinkDomain.rawValue] as? String else {
            fatalError("UNIVEFRSAL LINK DOMAIN not set in plist")
        }
        
        return universalLinkDomain
    }()
    
    static let appENV: String = {
        guard let appENV = Config.infoDictionary[Keys.appENV.rawValue] as? String else {
            fatalError("APP ENV not set in plist")
        }
        
        return appENV
    }()
    
    static let buildENV: String = {
        #if DEBUG
            return "DEBUG"
        #elseif ADHOC
            return "ADHOC"
        #else
            return "RELEASE"
        #endif
    }()
    
    private enum Keys: String {
        case appENV = "APP_ENV"
        case apiURL = "API_URL"
        case apiDocUrl = "API_DOC_URL" // MARK: Build Script에서 사용
        case kakaoNativeAppKey = "KAKAO_NATIVE_APP_KEY"
        case universalLinkDomain = "UNIVERSAL_LINK_DOMAIN"
    }
}
