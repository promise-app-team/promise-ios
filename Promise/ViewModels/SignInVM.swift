//
//  ViewModel.swift
//  Promise
//
//  Created by dylan on 2023/05/29.
//

import Foundation
import KakaoSDKUser

final class SignInVM {
    private let UserMDL = UserMDL()
    private let isAvailableKakaoTalkAuth: Bool = UserApi.isKakaoTalkLoginAvailable()
    
    func getKakaoTalkAuth() {
        UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
            if let error = error {
                // TODO: 카카오 로그인 실패시 핸들러: 토스트 정도
                print(error)
            }
            else {
                print("loginWithKakaoTalk() success.")
                
                //do something
                _ = oauthToken
            }
        }
    }
    
    func getKakaoAccountAuth() {
        
    }
    
    func handleKakaoSignIn() {
        
    }
}
