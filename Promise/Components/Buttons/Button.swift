//
//  Button.swift
//  Promise
//
//  Created by DewBook on 2023/07/23.
//

import UIKit

class Button : BaseButton {
    
    public static let Height: CGFloat = 36
    
    enum Style {
        case primary
        case secondary
        case outline
    }
    
    // MARK: - 버튼 초기화
    func initialize(title: String, style: Button.Style, iconTitle: String = "", disabled: Bool = false) {
        
        super.initialize(title: title,
                         bgColor: getBackgroundColor(style: style),
                         borderColor: getBorderColor(style: style),
                         fontColor: getFontColor(style: style),
                         iconTitle: iconTitle,
                         disabled: disabled)
    }
    
    private func getBackgroundColor(style: Button.Style) -> UIColor {
        switch style {
        case .primary :
            return UIColor(hexCode: "#06BF9E")
        case .secondary :
            return UIColor(hexCode: "#E5E5E5")
        case .outline :
            return .white
        }
    }
    
    private func getFontColor(style: Button.Style) -> UIColor {
        switch style {
        case .primary :
            return .white
        case .secondary :
            return UIColor(hexCode: "#666666")
        case .outline :
            return UIColor(hexCode: "#06BF9E")
        }
    }
    
    private func getBorderColor(style: Button.Style) -> UIColor {
        switch style {
        case .primary :
            return UIColor(hexCode: "#06BF9E")
        case .secondary :
            return UIColor(hexCode: "#E5E5E5")
        case .outline :
            return UIColor(hexCode: "#06BF9E")
        }
    }
    
}
