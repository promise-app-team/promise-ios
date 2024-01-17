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
        
        Task {
            // Default Sleep for 3 seconds
            try await Task.sleep(seconds: 3)
            
            let token = UserService.shared.getAccessToken()
            if let token = token, !token.isEmpty {
                _ = await UserService.shared.setUser(accessToken: token)
                
                DispatchQueue.main.async {
                    // MARK: 기존 로그인 성공, 초대받은 약속 아이디가 있다면 참여자 플로우
                    if let invitedPromiseId {
                        completion(GuideAttendeeVC(promiseId: invitedPromiseId))
                    } else {
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
