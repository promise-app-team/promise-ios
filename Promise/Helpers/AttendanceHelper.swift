//
//  AttendanceHelper.swift
//  Promise
//
//  Created by kwh on 1/23/24.
//

import Foundation

struct AttendanceHelper {
    let urlRegex = "^/(share/)?([^/]+)(/|$)"
    
    func parsePromiseId(path: String) -> String? {
        let regex = try! NSRegularExpression(pattern: urlRegex, options: [])
        let nsRange = NSRange(path.startIndex..<path.endIndex, in: path)
        
        if let match = regex.firstMatch(in: path, options: [], range: nsRange) {
            return (path as NSString).substring(with: match.range(at: 2))
        }
        
        return nil
    }
    
    func setHasSeenGuideAttendee() {
        UserDefaults.standard.set(true, forKey: UserDefaultConstants.Attendee.HAS_SEEN_GUIDE_ATTENDEE)
    }
    
    func checkHasSeenGuideAttendee() -> Bool {
        return UserDefaults.standard.bool(forKey: UserDefaultConstants.Attendee.HAS_SEEN_GUIDE_ATTENDEE)
    }
    
    // MARK: 로그인 이후 메모리에 User Data가 있어야 함수가 제대로 동작함.
    func checkAbleToAttend(promiseId: String) async -> (Bool, Components.Schemas.PromiseDTO?, error: NetworkError?) {
        let result: Result<Components.Schemas.PromiseDTO, NetworkError> = await APIService.shared.fetch(.GET, "/promises/\(promiseId)")
        
        switch result {
        case .success(let promise):
            if let user = UserService.shared.getUser() {
                let userId = user.userId
                if(userId == String(Int(promise.host.id))) {
                    return (false, promise, nil)
                }
                
                return (true, promise, nil)
            }
        case .failure(let errorType):
            switch errorType {
            case .badRequest:
                return (false, nil, errorType)
            default:
                // Other Error(Network, badUrl ...)
                return (false, nil, errorType)
            }
        }
        
        return (false, nil, nil)
    }
}
