//
//  Onboarding.swift
//  Promise
//
//  Created by dylan on 2023/07/14.
//

import UIKit

final class Onboarding {
    var loading = false
    
    func ready(_ completion: @escaping (UIViewController) -> Void) {
        loading = true
        
        Task {
            // Default Sleep for 3 seconds
            try await Task.sleep(seconds: 3)
            
            let token = UserService.shared.getAccessToken()
            if let token = token, !token.isEmpty {
                _ = await UserService.shared.setUser(accessToken: token)
                
                DispatchQueue.main.async {
                    completion(MainVC())
                }
                
            } else {
                DispatchQueue.main.async {
                    completion(SignInVC())
                }
            }
            
            self.loading = false
        }
    }
}
