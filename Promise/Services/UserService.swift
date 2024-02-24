//
//  UserService.swift
//  Promise
//
//  Created by dylan on 2023/07/10.
//

import Foundation
import UIKit
import JWTDecode
import KakaoSDKUser
import GoogleSignIn

final class UserService {
    static let shared = UserService()
    
    private let accessTokenKey = "accessToken"
    private let refreshTokenKey = "refreshToken"
    
    public var user: UserMDL? = nil
    
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
                user = UserMDL(userId: userId, nickname: userInfo.username, profileUrl: userInfo.profileUrl, loginMethod: userInfo.provider?.rawValue)
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
        UserDefaults.standard.set(token, forKey: accessTokenKey)
    }
    
    func getAccessToken() -> String? {
        return UserDefaults.standard.string(forKey: accessTokenKey)
    }
    
    func setRefreshToken(_ token: String?) {
        guard let token = token else { return }
        UserDefaults.standard.set(token, forKey: refreshTokenKey)
    }
    
    func getRefreshToken() -> String? {
        return UserDefaults.standard.string(forKey: refreshTokenKey)
    }
    
    // Clear Tokens
    func clearTokens() {
        UserDefaults.standard.removeObject(forKey: accessTokenKey)
        UserDefaults.standard.removeObject(forKey: refreshTokenKey)
    }
    
    private func logoutKakao(currentVC: UIViewController) {
        UserApi.shared.logout { error in
            if let error = error {
                print("Kakao logout error:", error)
            } else {
                print("Kakao logout success")
                currentVC.navigationController?.pushViewController(SignInVC(), animated: true)
            }
        }
    }
    
    private func logoutGoogle() {
        GIDSignIn.sharedInstance.signOut()
        print("Google logout success")
    }
    
    func signOut(currentVC: UIViewController) {
        
        if let loginMethod = user?.loginMethod {
            switch loginMethod {
            case "kakao":
                logoutKakao(currentVC: currentVC)
                break
            case "google":
                 logoutGoogle()
                break
            case "apple":
                // logoutApple()
                break
            default:
                break
            }
        }
        
        clearTokens()
        user = nil
        currentVC.navigationController?.pushViewController(SignInVC(), animated: true)
    }
}
