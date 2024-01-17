//
//  ViewModel.swift
//  Promise
//
//  Created by dylan on 2023/05/29.
//

import Foundation
import UIKit

import KakaoSDKUser
import GoogleSignIn
import AuthenticationServices

final class SignInVM: NSObject {
    var loading: Bool = false
    
    var currentVC: UIViewController?
    
    private let isAvailableKakaoTalkAuth: Bool = UserApi.isKakaoTalkLoginAvailable()
    
    init(currentVC: UIViewController? = nil) {
        self.currentVC = currentVC
    }
    
    private func getUserAuthToken(
        username: String,
        profileUrl: String,
        provider: Components.Schemas.InputCreateUser.providerPayload,
        providerId: String)
    async {
        
        let result: Result<Components.Schemas.AuthToken, NetworkError> = await APIService.shared.fetch(.POST, "/auth/login", nil, Components.Schemas.InputCreateUser(username: username, profileUrl: profileUrl, provider: provider, providerId: providerId))
        
        switch result {
        case .success(let token):
            #if DEBUG
            print("accessToken: ", token.accessToken)
            print("refreshToken: ", token.refreshToken)
            #endif
            
            // 유저 세팅
            let result = await UserService.shared.setUser(accessToken: token.accessToken, refreshToken: token.refreshToken)
            if result {
                // 로그인 or 회원가입 프로세스가 끝났음(loading 종료)
                loading = false
                
                // MARK: 로그인 성공, 초대받은 약속 아이디가 있다면 참여자 플로우
                if let invitedPromiseId = UserService.shared.invitedPromiseId {
                    navigateGuideAttendeeScreen(promiseId: invitedPromiseId)
                    
                    // 약속 참여 플로우 진입 이후 리셋
                    UserService.shared.invitedPromiseId = nil
                    break
                }
                
                // MARK: 로그인이 성공, 메인 화면으로 이동
                navigateMainScreen()
            }
        case .failure(let errorType):
            switch errorType {
            case .badRequest:
                // TODO: Toast error.message
                print("회원가입/로그인 실패")
                break
            default:
                // Other Error(Network, badUrl ...)
                break
            }
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
                        await self?.getUserAuthToken(username: nickname, profileUrl: profileUrl , provider: .KAKAO, providerId: String(providerId))
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
    
    private func getGoogleAuth() {
        guard let presentedVC = self.currentVC else { return }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentedVC) { signInResult, error in
            guard error == nil else {
                // TODO: 구글 인증 실패시 핸들러 - 토스트 및 로그인 실패 액션(웹 뷰가 닫힌 후 다음)
                return
            }
            
            guard let user = signInResult?.user else {
                // TODO: 구글 인증결과에서 유저 정보가 없을시 핸들러
                return
            }
            
            // user.userID = jwtToken's sub
            if let providerId = user.userID, let nickname = user.profile?.name, let profileUrl = user.profile?.imageURL(withDimension: 320)?.absoluteString {
                
                Task { [weak self] in
                    await self?.getUserAuthToken(username: nickname, profileUrl: profileUrl , provider: .GOOGLE, providerId: providerId)
                }
            }
        }
    }
    
    private func getAppleAuth() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName] // MARK: 유저로 부터 알 수 있는 정보는 name과 email만 요청가능
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func navigateMainScreen() {
        DispatchQueue.main.async {[weak self] in
            let mainVC = MainVC()
            self?.currentVC?.navigationController?.pushViewController(mainVC, animated: true)
        }
    }
    
    private func navigateGuideAttendeeScreen(promiseId: String) {
        DispatchQueue.main.async {[weak self] in
            let guideAttendeeVC = GuideAttendeeVC(promiseId: promiseId)
            self?.currentVC?.navigationController?.pushViewController(guideAttendeeVC, animated: true)
        }
    }
    
    func handleSignIn(method: Components.Schemas.InputCreateUser.providerPayload) {
        loading = true
        
        switch method {
        case .KAKAO:
            if(isAvailableKakaoTalkAuth) {
                getKakaoTalkAuth()
            } else {
                getKakaoAccountAuth()
            }
        case .GOOGLE:
            getGoogleAuth()
        case .APPLE:
            getAppleAuth()
            break
        }
    }
}

extension SignInVM: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            let providerId = appleIDCredential.user // userIdentifier(= jwtToken's sub)
            let fullName = appleIDCredential.fullName
            let totalName = "\(fullName?.familyName ?? "") \(fullName?.givenName ?? "")"
            let trimmedNickname = totalName.trimmingCharacters(in: .whitespaces)
            let nickname = trimmedNickname.isEmpty ? "" : totalName
            let profileUrl = ""
            
            Task { [weak self] in
                await self?.getUserAuthToken(username: nickname, profileUrl: profileUrl , provider: .APPLE, providerId: providerId)
            }
            
            if  let authorizationCode = appleIDCredential.authorizationCode,
                let identityToken = appleIDCredential.identityToken,
                let authCodeString = String(data: authorizationCode, encoding: .utf8),
                let identifyTokenString = String(data: identityToken, encoding: .utf8) {
                
                // unsued
                _ = identityToken
                _ = authCodeString
                _ = identifyTokenString
            }
        case let passwordCredential as ASPasswordCredential:
            // sign in using an existing iCloud Keychain credential.
            let _ = passwordCredential.user
            let _ = passwordCredential.password
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // TODO: Apple 로그인 인증 실패 처리
    }
}

extension SignInVM: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let window = self.currentVC?.view.window else {
            fatalError("No Window Available")
        }
        return window
    }
}


