//
//  Double.swift
//  Promise
//
//  Created by kwh on 2/25/24.
//

import Foundation

extension Double {
    func truncated(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return Double(Int(self * divisor)) / divisor
    }
    
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
