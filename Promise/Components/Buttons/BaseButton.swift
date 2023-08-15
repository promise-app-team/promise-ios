//
//  BaseButton.swift
//  Promise
//
//  Created by Sun on 2023/05/30.
//

import Foundation
import UIKit

open class BaseButton: UIButton {
   
    // MARK: - 버튼 타이틀
    private var title: String = ""
    
    // MARK: - 백그라운드 색상
    private var bgColor: UIColor = .black
    private var disabledBgColor: UIColor = UIColor(hexCode: "#F2F2F2")
    
    // MARK: - 텍스트 색상
    private var fontColor: UIColor = .white
    private var disabledFontColor: UIColor = UIColor(hexCode: "#CCCCCC")
    
    // MARK: - 테두리 색상
    private var borderColor: UIColor = .black
    private var disabledBorderColor: UIColor = UIColor(hexCode: "#F2F2F2")
    
    // MARK: - 모서리
    private let cornerRadius: CGFloat = 20
    
    // MARK: - 스케일
    private let scaleValue = 0.96
    
    // MARK: - 버튼 높이
    private let height = 40
    
    // MARK: - 아이콘 이름
    private var iconTitle = ""
    
    // MARK: - 버튼 활성화
    private var _isDisabled: Bool = false
    public var isDisabled: Bool {
        get {
            return _isDisabled
        }
        set {
            _isDisabled = newValue
            setupByActiveMode()
        }
    }
    
    // MARK: - 초기화
    
    open func initialize(title: String, bgColor: UIColor, borderColor: UIColor, fontColor: UIColor, iconTitle: String, disabled: Bool) {
        self.title = title
        self.bgColor = bgColor
        self.borderColor = borderColor
        self.fontColor = fontColor
        self.iconTitle = iconTitle
        self.isDisabled = disabled
        
        setup()
    }
    
    // MARK: - setup
    open func setup() {
        setupByActiveMode()
        
        titleLabel?.font = UIFont.pretendard(style: .B1_R)
        
        setTitle(self.title, for: .normal)
        setTitleColor(self.fontColor, for: .normal)
        setTitleColor(self.disabledFontColor, for: .disabled)
        
        layer.cornerRadius = self.cornerRadius
        layer.borderWidth = 1
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if !iconTitle.isEmpty {
            setImageOnBtn()
        }
    }
    
    private func setupByActiveMode(){
        backgroundColor = !self.isDisabled ? self.bgColor : self.disabledBgColor
        layer.borderColor = !self.isDisabled ? self.borderColor.cgColor : self.disabledBorderColor.cgColor
        isEnabled = !self.isDisabled
    }
    
    private func setImageOnBtn(){
        
        
        if let image = UIImage(named: iconTitle)?.withRenderingMode(.alwaysOriginal) {
            setImage(image, for: .normal)
            setImage(image, for: .highlighted) // 터치 시 아이콘 색상이 바뀌는 것을 막기 위한 설정
            setImage(image, for: .selected) // 선택된 상태에 대한 설정 (필요하다면)
        }
        
        // inset
        let intervalSpacing = 6.0
        let halfIntervalSpacing = intervalSpacing / 2
        
        //iOS15 이후부턴 Button Configuration 사용하면 됨...
        self.contentEdgeInsets = .init(top: 0, left: halfIntervalSpacing, bottom: 0, right: halfIntervalSpacing)
        self.imageEdgeInsets = .init(top: 0, left: -halfIntervalSpacing, bottom: 0, right: halfIntervalSpacing)
        self.titleEdgeInsets = .init(top: 0, left: halfIntervalSpacing, bottom: 0, right: -halfIntervalSpacing)
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
        if isDisabled { return }
        
        UIView.animate(withDuration: 0.1, delay: 0, options: [.allowUserInteraction, .curveEaseIn], animations: {
            self.transform = .init(scaleX: self.scaleValue, y: self.scaleValue)
        })
    }
    
    open func touchEnd(){
        if isDisabled { return }
        
        UIView.animate(withDuration: 0.1, delay: 0, options: [.allowUserInteraction, .curveEaseOut], animations: {
            self.transform = .identity
        })
    }
}

