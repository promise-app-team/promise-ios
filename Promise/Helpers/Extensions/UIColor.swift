//
//  UIColor.swift
//  Promise
//
//  Created by dylan on 2023/08/15.
//

import Foundation
import UIKit

extension UIColor {
    static func transition(from startColor: UIColor, to endColor: UIColor, with ratio: CGFloat) -> UIColor {
        var startRed: CGFloat = 0, startGreen: CGFloat = 0, startBlue: CGFloat = 0, startAlpha: CGFloat = 0
        startColor.getRed(&startRed, green: &startGreen, blue: &startBlue, alpha: &startAlpha)

        var endRed: CGFloat = 0, endGreen: CGFloat = 0, endBlue: CGFloat = 0, endAlpha: CGFloat = 0
        endColor.getRed(&endRed, green: &endGreen, blue: &endBlue, alpha: &endAlpha)

        let red = startRed + (endRed - startRed) * ratio
        let green = startGreen + (endGreen - startGreen) * ratio
        let blue = startBlue + (endBlue - startBlue) * ratio
        let alpha = startAlpha + (endAlpha - startAlpha) * ratio

        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}







