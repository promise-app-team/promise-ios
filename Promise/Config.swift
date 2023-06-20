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
    
    static let apiURL: URL = {
        guard let baseURL = Config.infoDictionary[Keys.apiURL.rawValue] as? String else {
            fatalError("API URL not set in plist")
        }
        
        guard let url = URL(string: baseURL) else {
            fatalError("API URL is invalid")
        }
        
        return url
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
    }
}