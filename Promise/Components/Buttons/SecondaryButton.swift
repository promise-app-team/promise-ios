//
//  SecondaryButton.swift
//  CommonButton
//
//  Created by Sun on 2023/05/16.
//

import Foundation
import UIKit


final class SecondaryButton : BaseButton {
    
    public let windowWidth = UIScreen.main.bounds.size.width
    public let windowHeight = UIScreen.main.bounds.size.height
    
    
    // MARK: - 백그라운드 색상
    private let activeColor: UIColor = UIColor(cgColor: CGColor(red: 0, green: 192/255, blue: 135/255, alpha: 1))
    private let inactiveColor: UIColor = UIColor(cgColor: CGColor(red: 0, green: 192/255, blue: 135/255, alpha: 0.7))
    
    // MARK: - 폰트 색상
    private let fontColor: UIColor = .white
    
    // MARK: - 생성자
    init(title: String, frame: CGRect, isActive: Bool = true){
        super.init(title: title, frame: frame, activeColor: activeColor, inactiveColor: inactiveColor, fontColor: fontColor, isActive: isActive)
    }
    
    init(title:String, point: CGPoint, isActive: Bool = true){
        let width = windowWidth - (point.x) * 2
        let height = width / 6
        
        super.init(title: title, frame: CGRect(origin: point, size: CGSize(width: width, height: height)), activeColor: activeColor, inactiveColor: inactiveColor, fontColor: fontColor, isActive: isActive)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
