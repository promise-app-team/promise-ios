//
//  FontHelper.swift
//  Promise
//
//  Created by Sun on 2023/07/22.
//

import UIKit

extension UIFont {
    
    // H: Header, B: Body, C: Caption
    enum CustomStyle {
        case H1_B
        case H1_R
        case H2_B
        case H2_R
        case B1_B
        case B1_R
        case C_B
        case C_R
    }
    
    static func pretendard(style: UIFont.CustomStyle, isBigger: Bool = false) -> UIFont {
        let familyName = "Pretendard"
        
        var weightString: String
        var fontSize: CGFloat
        switch style {
        case .H1_B:
            weightString = "Bold"
            fontSize = isBigger ? 24 * 1.5 : 24
        case .H1_R:
            weightString = "Regular"
            fontSize = isBigger ? 24 * 1.5 : 24
        case .H2_B:
            weightString = "Bold"
            fontSize = isBigger ? 20 * 1.5 : 20
        case .H2_R:
            weightString = "Regular"
            fontSize = isBigger ? 20 * 1.5 : 20
        case .B1_B:
            weightString = "Bold"
            fontSize = isBigger ? 16 * 1.5 : 16
        case .B1_R:
            weightString = "Regular"
            fontSize = isBigger ? 16 * 1.5 : 16
        case .C_B:
            weightString = "Bold"
            fontSize = isBigger ? 12 * 1.5 : 12
        case .C_R:
            weightString = "Regular"
            fontSize = isBigger ? 12 * 1.5 : 12
        }

        return UIFont(name: "\(familyName)-\(weightString)", size: fontSize) ?? .systemFont(ofSize: fontSize, weight: .regular)
    }
}
