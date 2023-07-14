//
//  UserService.swift
//  Promise
//
//  Created by dylan on 2023/07/10.
//

import Foundation

final class UserService {
    static let shared = UserService()
    
    private var userId: String? = nil
    private var nickname: String? = nil
    
    // TODO: accessToken이 set되거나 변경되면 userId, nickname 변경하는 옵저버 계산 속성으로 변경
    private var accessToken: String? = nil
    
    public func setAccessToken(_ accessToken: String) {
        // class의 맴버에 저장
        self.accessToken = accessToken
        
        // TODO: info.plist 혹은 keychain에 token 저장
    }
    
    public func getAccessToken() -> String? {
        return accessToken
    }
}
