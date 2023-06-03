//
//  SecondaryButton.swift
//  Promise
//
//  Created by DewBook on 2023/05/30.
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
    
    // 버튼 이름, 버튼이 생성될 위치 및 크기, 활성화 여부를 생성자로 받아옵니다.
    init(title: String, frame: CGRect, isActive: Bool = true){
        super.init(title: title, frame: frame, activeColor: activeColor, inactiveColor: inactiveColor, fontColor: fontColor, isActive: isActive)
    }
    
    // 버튼 이름, 버튼의 위치, 부모뷰, 활성화 여부를 생성자로 받아옵니다.
    // 버튼의 크기를 임의로 정하기 위해서 부모뷰를 파라미터로 받습니다. 
    // 버튼의 크기는 디폴트로 버튼을 붙일 뷰의 크기를 따라갑니다.
    init(title:String, point: CGPoint, superView: UIView, isActive: Bool = true){
        let width = windowWidth - (point.x) * 2
        let height = width / 6
        
        super.init(title: title, frame: CGRect(origin: point, size: CGSize(width: width, height: height)), activeColor: activeColor, inactiveColor: inactiveColor, fontColor: fontColor, isActive: isActive)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
