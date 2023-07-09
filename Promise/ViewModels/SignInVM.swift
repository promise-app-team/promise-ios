//
//  ViewModel.swift
//  Promise
//
//  Created by dylan on 2023/05/29.
//

import Foundation
import KakaoSDKUser

final class SignInVM {
    private let userMDL = UserMDL()
    private let isAvailableKakaoTalkAuth: Bool = UserApi.isKakaoTalkLoginAvailable()
    
    func getUserAuthToken() {
        // TODO: 수집된 토큰, 닉네임, 프로필 이미지와 함께 서버에 회원가입(jwt) 토큰 발급 요청
    }
    
    func getUserInfoFromKakao() {
        // TODO: 엑세스 토큰을 이용해 유저 정보 얻기
    }
    
    func getKakaoTalkAuth() {
        UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
            if let error = error {
                // TODO: 카카오 로그인 실패시 핸들러 - 토스트 및 로그인 실패 액션(카카오 톡으로 이동 후 돌아 온 다음)
                print(error)
            } else {
                print("loginWithKakaoTalk() success.")
                guard let accessToken = oauthToken?.accessToken else { return } // TODO: 토큰이 없을 경우 핸들러
                
                print("엑세스 토큰!: \(accessToken)")
            }
        }
    }
    
    func getKakaoAccountAuth() {
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error = error {
                // TODO: 카카오 로그인 실패시 핸들러 - 토스트 및 로그인 실패 액션(웹 뷰가 닫힌 후 다음)
                print(error)
            } else {
                print("loginWithKakaoAccount() success.")
                guard let accessToken = oauthToken?.accessToken else { return } // TODO: 토큰이 없을 경우 핸들러
                
                print("엑세스 토큰!: \(accessToken)")
            }
        }
    }
    
    func handleKakaoSignIn() {
        if(isAvailableKakaoTalkAuth) {
            getKakaoTalkAuth()
        } else {
            getKakaoAccountAuth()
        }
    }
}
