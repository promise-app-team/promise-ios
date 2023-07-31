//
//  PaddingLabel.swift
//  Promise
//
//  Created by zzee22su on 2023/06/27.
//

import UIKit

//토스트 메시지의 왼쪽, 오른쪽 여백을 주기 위해 만든 클래스
class PaddingLabel: UILabel {
    
    private let left: CGFloat = 10
    private let right: CGFloat = 10
    private var sum: CGFloat {
        return left + right
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: left, bottom: 0, right: right)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        let width = size.width + sum
        return CGSize(width: width, height: size.height)
    }
}
