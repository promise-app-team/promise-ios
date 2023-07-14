//
//  ViewModel.swift
//  Promise
//
//  Created by dylan on 2023/05/29.
//

import Foundation
import UIKit
import KakaoSDKUser

final class SignInVM {
    var signInStatus: Bool = false
    var loading: Bool = false
    
    var currentVC: UIViewController?
    
    private let userMDL = UserMDL()
    private let isAvailableKakaoTalkAuth: Bool = UserApi.isKakaoTalkLoginAvailable()
    
    private func getUserAuthToken(user: String, profileUrl: String, provider: Components.Schemas.InputCreateUser.providerPayload, providerId: String) async {
    
        do {
            let response = try await APIService.shared.client.login(.init(body: .json(Components.Schemas.InputCreateUser(user: user, profileUrl: profileUrl, provider: provider, providerId: providerId))))
            
            switch response {
            case .created(let createdResponse):
                switch createdResponse.body {
                case .json(let token):
                    #if DEBUG
                    print("accessToken: ", token.accessToken)
                    print("refreshToken: ", token.refreshToken)
                    #endif
                    
                    UserService.shared.setAccessToken(token.accessToken)
                    // TODO: refresh token 저장
                    // TODO: userMDL에도 저장????
                    
                    // 로그인/회원가입 완료 후 loading 종료
                    loading = false
                    signInStatus = true // TODO: 임시
                    
                    print("아아!")
                    // 로그인이 성공했으므로 메인 화면으로 이동
                    navigateMainScreen()
                }
            case .badRequest(let error):
                // TODO: 400일 때 badRequest 핸들러
                print("회원가입/로그인 실패", error)
                break
            default:
                print("예외 발생")
                // 서버에서 정의하지 않은(명세에 정의되지 않은) 응답 케이스를 처리, undocumented로 처리해도 됨. 하지만 어떤 네트워크 상태 코드를 던질지 모르기 때문에 default에서 처리
                break
            }
        } catch {
            // TODO: 앱 서버에 회원가입 및 로그인 실패시 핸들러
            print(error)
        }
    }
    
    private func getUserInfoFromKakao()  {
        UserApi.shared.me() { (user, error) in
            if let error = error {
                // TODO: 유저 정보 얻기 실패시 핸들러
                print("카카오 유저 정보 얻기 실패", error)
            } else {
                if let providerId = user?.id, let nickname = user?.kakaoAccount?.profile?.nickname, let profileUrl = user?.kakaoAccount?.profile?.profileImageUrl?.absoluteString {
                    
                    Task { [weak self] in
                        await self?.getUserAuthToken(user: nickname, profileUrl: profileUrl , provider: .KAKAO, providerId: String(providerId))
                    }
                }
                
            }
        }
    }
    
    private func getKakaoTalkAuth() {
        UserApi.shared.loginWithKakaoTalk {[weak self] (oauthToken, error) in
            if let error = error {
                // TODO: 카카오 로그인 실패시 핸들러 - 토스트 및 로그인 실패 액션(카카오 톡으로 이동 후 돌아 온 다음)
                print("카카오톡 인증 실패", error)
            } else {
                guard let _ = oauthToken?.accessToken else { return } // TODO: 토큰이 없을 경우 핸들러
                self?.getUserInfoFromKakao()
            }
        }
    }
    
    private func getKakaoAccountAuth() {
        UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
            if let error = error {
                // TODO: 카카오 로그인 실패시 핸들러 - 토스트 및 로그인 실패 액션(웹 뷰가 닫힌 후 다음)
                print("카카오 계정 인증 실패", error)
            } else {
                guard let _ = oauthToken?.accessToken else { return } // TODO: 토큰이 없을 경우 핸들러
                self?.getUserInfoFromKakao()
            }
        }
    }
    
    private func navigateMainScreen() {
        DispatchQueue.main.async {[weak self] in
            let mainVC = MainVC()
            self?.currentVC?.navigationController?.pushViewController(mainVC, animated: true)
        }
    }
    
    func handleKakaoSignIn(currentVC: UIViewController) {
        // 로그인/회원가입 핸들러 시작 로딩 세팅
        loading = true
        self.currentVC = currentVC
        
        if(isAvailableKakaoTalkAuth) {
            getKakaoTalkAuth()
        } else {
            getKakaoAccountAuth()
        }
    }
}
