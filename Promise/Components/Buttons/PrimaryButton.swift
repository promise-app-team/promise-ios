//
//  PrimaryButton.swift
//  CommonButton
//
//  Created by Sun on 2023/05/15.
//

import Foundation
import UIKit


final class PrimaryButton : BaseButton {
    
    public let windowWidth = UIScreen.main.bounds.size.width
    public let windowHeight = UIScreen.main.bounds.size.height
    
    // MARK: - 백그라운드 색상
    private let activeColor: UIColor = UIColor(cgColor: CGColor(red: 255/255, green: 200/255, blue: 6/255, alpha: 1))
    private let inactiveColor: UIColor = UIColor(cgColor: CGColor(red: 255/255, green: 200/255, blue: 6/255, alpha: 0.5))
    
    // MARK: - 폰트 색상
    private let fontColor: UIColor = .black
    
    // MARK: - 생성자
    init(title: String, frame: CGRect, isActive: Bool = true){
        super.init(title: title, frame: frame, activeColor: activeColor, inactiveColor: inactiveColor, fontColor: .black, isActive: isActive)
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
