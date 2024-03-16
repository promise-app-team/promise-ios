//
//  Float.swift
//  Promise
//
//  Created by kwh on 2/25/24.
//

import Foundation

extension Float {
    func truncated(toPlaces places: Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return Float(Int(self * divisor)) / divisor
    }
    
    func rounded(toPlaces places:Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}
