//
//  UserService.swift
//  Promise
//
//  Created by dylan on 2023/07/10.
//

import Foundation
import UIKit
import JWTDecode

final class UserService {
    private init() {}
    static let shared = UserService()
    
    private var user: UserMDL? = nil
    
    public var invitedPromiseId: String? = nil
    
    func getUser() -> UserMDL? {
        return user
    }
    
    func setUser(accessToken: String, refreshToken: String? = nil) async -> Bool {
        UserService.shared.setAccessToken(accessToken)
        UserService.shared.setRefreshToken(refreshToken)
        
        do {
            let jwt = try decode(jwt: accessToken)
            let userId = jwt.claim(name: "id").string
            guard let userId = userId else { return false }
            
            let result: Result<Components.Schemas.UserEntity, NetworkError> = await APIService.shared.fetch(.GET, "/user/profile")
            
            switch result {
            case .success(let userInfo):
                user = UserMDL(userId: userId, nickname: userInfo.username, profileUrl: userInfo.profileUrl)
                return true
            case .failure(let error):
                print("Get user data error: ", error)
            }
        } catch {
            print("User Info Setting Failed: ", error)
        }
        
        return false
    }
    
    func setAccessToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: UserDefaultConstants.User.ACCESS_TOKEN)
    }
    
    func getAccessToken() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultConstants.User.ACCESS_TOKEN)
    }
    
    func setRefreshToken(_ token: String?) {
        guard let token = token else { return }
        UserDefaults.standard.set(token, forKey: UserDefaultConstants.User.REFRESH_TOKEN)
    }
    
    func getRefreshToken() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultConstants.User.REFRESH_TOKEN)
    }
    
    // Clear Tokens
    func clearTokens() {
        UserDefaults.standard.removeObject(forKey: UserDefaultConstants.User.ACCESS_TOKEN)
        UserDefaults.standard.removeObject(forKey: UserDefaultConstants.User.REFRESH_TOKEN)
    }
    
    func signOut(currentVC: UIViewController) {
        clearTokens()
        user = nil
        currentVC.navigationController?.pushViewController(SignInVC(), animated: true)
    }
}
