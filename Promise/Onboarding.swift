//
//  Onboarding.swift
//  Promise
//
//  Created by dylan on 2023/07/14.
//

import UIKit

final class Onboarding {
    var loading = false
    
    func ready(invitedPromiseId: String?, _ completion: @escaping (UIViewController) -> Void) {
        loading = true
        
        #if DEBUG
        // UserDefaults에 저장된 모든 키와 값 출력(시스템에서 자동으로 추가된 것 제외, 직접 추가한 것만 출력)
        print("============ UserDefaults ============")
        for key in UserDefaultConstants.allKeys {
            if let value = UserDefaults.standard.value(forKey: key) {
                print("\(key): \(value)")
            } else {
                print("\(key): nil")
            }
        }
        print("======================================")
        #endif
        
        
        Task {
            // Default Sleep for 3 seconds
            try await Task.sleep(seconds: 3)
            
            let token = UserService.shared.getAccessToken()
            if let token = token, !token.isEmpty {
                _ = await UserService.shared.setUser(accessToken: token)
                
                DispatchQueue.main.async {
                    
                    if let invitedPromiseId {
                        // MARK: 기존 로그인 성공, 초대받은 약속 아이디가 있다면 최초 참여자 플로우
                        
                        let hasSeenGuideAttendee = UserDefaults.standard.bool(forKey: UserDefaultConstants.Attendee.HAS_SEEN_GUIDE_ATTENDEE)
                        if hasSeenGuideAttendee {
                            // MARK: 기존 로그인 성공, HAS_SEEN_GUIDE_ATTENDEE가 true면 메인화면으로 이동, invitedPromiseId injection
                            
                            completion(MainVC(invitedPromiseId: invitedPromiseId))
                            
                        } else {
                            // MARK: UserDefaults에 HAS_SEEN_GUIDE_ATTENDEE가 false면 참여자 가이드 화면으로 이동, promiseId injection
                            
                            completion(GuideAttendeeVC(promiseId: invitedPromiseId))
                        }
                        
                    } else {
                        // MARK: 기존 로그인 성공, 초대받은 약속 아이디가 없으면 메인화면이 최초화면
                        
                        completion(MainVC())
                    }
                }
                
            } else {
                DispatchQueue.main.async {
                    if let invitedPromiseId {
                        // MARK: 초대받은 약속 아이디가 있다면 싱글톤 UserSercie에 우선 저장후 로그인 성공후 이동
                        UserService.shared.invitedPromiseId = invitedPromiseId
                    }
                    
                    completion(SignInVC())
                }
            }
            
            self.loading = false
        }
    }
}
