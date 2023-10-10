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
        button.titleLabel?.font = UIFont(font: FontFamily.Pretendard.regular, size: 16)
        
        // button.layer.masksToBounds = true -> 설정하면 안됨. mini 대응
        button.layer.cornerRadius = 6.5
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
        button.titleLabel?.font = UIFont(font: FontFamily.Pretendard.regular, size: 16)
        
        // button.layer.masksToBounds = true -> 설정하면 안됨. mini 대응
        button.layer.cornerRadius = 6.5
        button.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMaxXMinYCorner, .layerMaxXMaxYCorner)
        
        button.addTarget(self, action: #selector(onTapRight), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var wrapper = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.02, green: 0.75, blue: 0.62, alpha: 1)
        
        // view.layer.masksToBounds = true -> 설정하면 안됨. mini 대응
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.white.cgColor
        view.clipsToBounds = true
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // mini 대응
    var leftButtonTopConstraint: NSLayoutConstraint?
    var leftButtonLeadingConstraint: NSLayoutConstraint?
    var leftButtonTrailingConstraint: NSLayoutConstraint?
    var leftButtonBottomConstraint: NSLayoutConstraint?
    
    // mini 대응
    var rightButtonTopConstraint: NSLayoutConstraint?
    var rightButtonLeadingConstraint: NSLayoutConstraint?
    var rightButtonTrailingConstraint: NSLayoutConstraint?
    var rightButtonBottomConstraint: NSLayoutConstraint?
    
    @objc private func onTapLeft() {
        KeyboardManager.shared.hideKeyboard()
        delegate?.onTapLeftButton()
        
        leftButtonTopConstraint?.constant = 1.5
        leftButtonLeadingConstraint?.constant = 1.5
        leftButtonTrailingConstraint?.constant = -1.2
        leftButtonBottomConstraint?.constant = -1.8
        
        leftButton.backgroundColor = .white
        leftButton.setTitleColor(UIColor(red: 0.02, green: 0.75, blue: 0.62, alpha: 1), for: .normal)
        
        rightButtonTopConstraint?.constant = 0
        rightButtonLeadingConstraint?.constant = 0
        rightButtonTrailingConstraint?.constant = 0.5
        rightButtonBottomConstraint?.constant = 0.5
        
        rightButton.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        rightButton.setTitleColor(UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1), for: .normal)
        
        layoutIfNeeded()
    }
    
    @objc private func onTapRight() {
        KeyboardManager.shared.hideKeyboard()
        delegate?.onTapRightButton()
        
        self.leftButtonTopConstraint?.constant = 0
        self.leftButtonLeadingConstraint?.constant = 0
        self.leftButtonTrailingConstraint?.constant = 0
        self.leftButtonBottomConstraint?.constant = 0.5
        
        self.leftButton.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        self.leftButton.setTitleColor(UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1), for: .normal)
        
        self.rightButtonTopConstraint?.constant = 1.5
        self.rightButtonLeadingConstraint?.constant = 1.4
        self.rightButtonTrailingConstraint?.constant = -1.8
        self.rightButtonBottomConstraint?.constant = -1.8
        
        self.rightButton.backgroundColor = .white
        self.rightButton.setTitleColor(UIColor(red: 0.02, green: 0.75, blue: 0.62, alpha: 1), for: .normal)
        
        self.layoutIfNeeded()
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
        configureFormTabMenuView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureFormTabMenuView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        leftButtonTopConstraint = leftButton.topAnchor.constraint(equalTo: wrapper.topAnchor, constant: 1.5)
        leftButtonLeadingConstraint = leftButton.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor, constant: 1.5)
        leftButtonTrailingConstraint = leftButton.trailingAnchor.constraint(equalTo: wrapper.centerXAnchor, constant: -1.2)
        leftButtonBottomConstraint = leftButton.bottomAnchor.constraint(equalTo: wrapper.bottomAnchor, constant: -1.8)
        
        rightButtonTopConstraint = rightButton.topAnchor.constraint(equalTo: wrapper.topAnchor, constant: 0)
        rightButtonLeadingConstraint = rightButton.leadingAnchor.constraint(equalTo: wrapper.centerXAnchor, constant: 0)
        rightButtonTrailingConstraint = rightButton.trailingAnchor.constraint(equalTo: wrapper.trailingAnchor, constant: 0)
        rightButtonBottomConstraint = rightButton.bottomAnchor.constraint(equalTo: wrapper.bottomAnchor, constant: 0)
        
        [leftButton, rightButton].forEach { wrapper.addSubview($0) }
        
        NSLayoutConstraint.activate([
            leftButtonTopConstraint!,
            leftButtonLeadingConstraint!,
            leftButtonTrailingConstraint!,
            leftButtonBottomConstraint!,
            
            rightButtonTopConstraint!,
            rightButtonLeadingConstraint!,
            rightButtonTrailingConstraint!,
            rightButtonBottomConstraint!
        ])
        
        [wrapper].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            wrapper.topAnchor.constraint(equalTo: topAnchor),
            wrapper.leadingAnchor.constraint(equalTo: leadingAnchor),
            wrapper.trailingAnchor.constraint(equalTo: trailingAnchor),
            wrapper.bottomAnchor.constraint(equalTo: bottomAnchor),
            wrapper.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
