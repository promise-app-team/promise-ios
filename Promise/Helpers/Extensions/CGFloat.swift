//
//  CGFloat.swift
//  Promise
//
//  Created by kwh on 2/25/24.
//

import Foundation

extension CGFloat {
    func truncated(toPlaces places: Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
        return CGFloat(Int(self * divisor)) / divisor
    }
    
    func rounded(toPlaces places: Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
        return (self * divisor).rounded() / divisor
    }
}
