//
//  BaseButton.swift
//  Promise
//
//  Created by Sun on 2023/05/30.
//

import Foundation
import UIKit

open class BaseButton: UIButton {
    
    // MARK: - 백그라운드 색상
    private var activeColor: UIColor = .black
    private var inactiveColor: UIColor = .black.withAlphaComponent(0.7)
    
    // MARK: - 텍스트 색상
    private var fontColor: UIColor = .white
    
    // MARK: - 모서리
    private let cornerRadius: CGFloat = 6
    
    // MARK: - 스케일
    private let scaleValue = 0.96
    
    // MARK: - 버튼 활성화
    private var _isActive: Bool = true
    public var isActive: Bool {
        get {
            return _isActive
        }
        set {
            _isActive = newValue
            setupByActiveMode()
        }
    }
    private var title: String = ""
    
    // MARK: - 생성자
    
    // 코드로 구현할 때 필수로 구현해야하는 지정 생성자
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // 스토리보드로 생성할 때 필수인 지정 생성자
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience public init(title: String, frame: CGRect, isActive: Bool) {
        self.init(frame: frame)
        
        self.title = title
        self.isActive = isActive
        
        setup()
    }
    
    public init(title: String, frame: CGRect, activeColor: UIColor, inactiveColor: UIColor, fontColor: UIColor, isActive: Bool){
        super.init(frame: frame)
        
        self.title = title
        self.isActive = isActive
        self.activeColor = activeColor
        self.inactiveColor = inactiveColor
        self.fontColor = fontColor
        
        setup()
    }
    
    // MARK: - setup
    open func setup() {
        setupByActiveMode()
        
        setTitle(self.title, for: .normal)
        layer.cornerRadius = self.cornerRadius
        titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
    }
    
    private func setupByActiveMode(){
        setTitleColor(isActive ? self.fontColor : self.fontColor.withAlphaComponent(0.7), for: .normal)
        backgroundColor = self.isActive ? self.activeColor : self.inactiveColor
        isEnabled = self.isActive
    }
    
    // MARK: - Override: Touch Event
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        touchIn()
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        touchEnd()
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        if !isTouchInside {
            touchEnd()
        }
    }
    
    open func touchIn(){
        if !isActive { return }
        
        UIView.animate(withDuration: 0.1, delay: 0, options: [.allowUserInteraction, .curveEaseIn], animations: {
            self.transform = .init(scaleX: self.scaleValue, y: self.scaleValue)
        })
    }
    
    open func touchEnd(){
        if !isActive { return }
        
        UIView.animate(withDuration: 0.1, delay: 0, options: [.allowUserInteraction, .curveEaseOut], animations: {
            self.transform = .identity
        })
    }
}
