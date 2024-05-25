//
//  FormTabMenu.swift
//  Promise
//
//  Created by dylan on 2023/09/26.
//

import Foundation
import UIKit

protocol FormTabMenuViewDelegate: UIView {
    func onTapLeftButton()
    func onTapRightButton()
}

class FormTabMenuView: UIView {
    enum FormTabMenuEnum {
        case LEFT
        case RIGHT
    }
    
    weak var delegate: FormTabMenuViewDelegate?
    
    var type = FormTabMenuEnum.LEFT
    
    var leftButtonTitle: String = ""
    var rightButtonTitle: String = ""
    
    private lazy var leftButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle(leftButtonTitle, for: .normal)
        button.setTitleColor(UIColor(red: 0.02, green: 0.75, blue: 0.62, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(font: FontFamily.Pretendard.regular, size: adjustedValue(16, .width))
        
        button.layer.borderWidth = adjustedValue(1, .width)
         button.layer.masksToBounds = true
        button.layer.cornerRadius = adjustedValue(8, .width)
        button.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMinXMaxYCorner)
        
        button.addTarget(self, action: #selector(onTapLeft), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var rightButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        button.setTitle(rightButtonTitle, for: .normal)
        button.setTitleColor(UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(font: FontFamily.Pretendard.regular, size: adjustedValue(16, .width))
        
        button.layer.borderWidth = adjustedValue(1, .width)
         button.layer.masksToBounds = true
        button.layer.cornerRadius = adjustedValue(8, .width)
        button.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMaxXMinYCorner, .layerMaxXMaxYCorner)
        
        button.addTarget(self, action: #selector(onTapRight), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var wrapper = {
        let stackView = UIStackView(arrangedSubviews: [
            leftButton,
            rightButton
        ])
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        stackView.layer.masksToBounds = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    public func updateUIForSelectedTab(tab: FormTabMenuEnum) {
        switch tab {
        case .LEFT:
            
            leftButton.backgroundColor = .white
            leftButton.setTitleColor(UIColor(red: 0.02, green: 0.75, blue: 0.62, alpha: 1), for: .normal)
            leftButton.layer.borderColor = UIColor(red: 0.02, green: 0.75, blue: 0.62, alpha: 1).cgColor

            rightButton.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
            rightButton.setTitleColor(UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1), for: .normal)
            rightButton.layer.borderColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1).cgColor
            
        case .RIGHT:
            
            leftButton.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
            leftButton.setTitleColor(UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1), for: .normal)
            leftButton.layer.borderColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1).cgColor
            
            rightButton.backgroundColor = .white
            rightButton.setTitleColor(UIColor(red: 0.02, green: 0.75, blue: 0.62, alpha: 1), for: .normal)
            rightButton.layer.borderColor = UIColor(red: 0.02, green: 0.75, blue: 0.62, alpha: 1).cgColor
            
        }
        
        layoutIfNeeded()
    }
    
    @objc public func onTapLeft() {
        KeyboardManager.shared.hideKeyboard()
        delegate?.onTapLeftButton()
        updateUIForSelectedTab(tab: .LEFT)
    }
    
    @objc public func onTapRight() {
        KeyboardManager.shared.hideKeyboard()
        delegate?.onTapRightButton()
        updateUIForSelectedTab(tab: .RIGHT)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        isUserInteractionEnabled = false
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        isUserInteractionEnabled = true
    }
    
    init(leftButtonTitle: String, rightButtonTitle: String) {
        self.leftButtonTitle = leftButtonTitle
        self.rightButtonTitle = rightButtonTitle
        super.init(frame: .null)
        configure()
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        leftButton.layer.borderColor = UIColor(red: 0.02, green: 0.75, blue: 0.62, alpha: 1).cgColor
        rightButton.layer.borderColor = UIColor.clear.cgColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func render() {
        [wrapper].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            wrapper.topAnchor.constraint(equalTo: topAnchor),
            wrapper.leadingAnchor.constraint(equalTo: leadingAnchor),
            wrapper.trailingAnchor.constraint(equalTo: trailingAnchor),
            wrapper.bottomAnchor.constraint(equalTo: bottomAnchor),
            wrapper.heightAnchor.constraint(equalToConstant: adjustedValue(40, .height))
        ])
    }
}
