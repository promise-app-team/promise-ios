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
            // MARK: 온보딩 Default 대기 시간
            try await Task.sleep(seconds: 1)
            
            let token = UserService.shared.getAccessToken()
            if let token = token, !token.isEmpty {
                _ = await UserService.shared.setUser(accessToken: token)
                
                DispatchQueue.main.async {
                    
                    if let invitedPromiseId {
                        
                        Task {
                            let attendanceHelper = AttendanceHelper()
                            
                            let (isAbleToAttend, promise, error) = await attendanceHelper.checkAbleToAttend(promiseId: invitedPromiseId)
                            
                            if isAbleToAttend {
                                // MARK: 기존 로그인 성공, 초대받은 약속 아이디가 있다면 최초 참여자 플로우
                                
                                let hasSeenGuideAttendee = AttendanceHelper().checkHasSeenGuideAttendee()
                                if hasSeenGuideAttendee {
                                    // MARK: 기존 로그인 성공, HAS_SEEN_GUIDE_ATTENDEE가 true면 메인화면으로 이동, invitedPromiseId injection
                                    
                                    completion(MainVC(invitedPromise: promise))
                                    
                                } else {
                                    // MARK: UserDefaults에 HAS_SEEN_GUIDE_ATTENDEE가 false면 참여자 가이드 화면으로 이동, promiseId injection
                                    
                                    if let promise {
                                        completion(GuideAttendeeVC(promise: promise))
                                    }
                                    
                                }
                                
                            } else {
                                // MARK: 기존 로그인 성공, 초대장에 참여가 불가능한 상태일때(해당 초대장이 내 약속일 경우)
                                let mainVC = MainVC(shouldFocusPromiseId: invitedPromiseId)
                                completion(mainVC)
                                
                                // MARK: 기존 로그인 성공, 초대장에 참여가 불가능한 상태인데(약속이 없거나 약속 정보를 불러오는데 실패한 경우)
                                if let _ = error {
                                    try await Task.sleep(seconds: 0.5)
                                    mainVC.showPopUp(
                                        title: L10n.InvitationPopUp.IsNotAbleToPromise.title,
                                        message: L10n.InvitationPopUp.IsNotAbleToPromise.description
                                    )
                                }
                            }
                        }
                        
                        
                    } else {
                        // MARK: 기존 로그인 성공, 초대받은 약속 아이디가 없으면 메인 화면이 최초화면
                        
                        completion(MainVC())
                    }
                    
                }
                
            } else {
                // MARK: 로그인이 필요한 경우
                
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
