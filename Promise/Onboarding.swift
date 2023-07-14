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
    
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) { [weak self] in
            let token = UserService.shared.getAccessToken()
        
            if let token = token, !token.isEmpty {
                completion(MainVC())
                self?.loading = false
                return
            }
            
            self?.loading = false
            completion(SignInVC())
        }
    }
}
