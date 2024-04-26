//
//  FormTitleView.swift
//  Promise
//
//  Created by dylan on 2023/08/28.
//

import Foundation
import UIKit

class FormTitleView: UIView {
    var createPromiseVM: CreatePromiseVM
    
    private let label = {
        let label = UILabel()
        label.text = L10n.CreatePromise.Form.titleLabel
        label.font = UIFont(font: FontFamily.Pretendard.bold, size: adjustedValue(12, .width))
        label.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var promiseTitleInput = {
        let textField = UITextField()
        
        textField.font = UIFont(font: FontFamily.Pretendard.regular, size: adjustedValue(16, .width))
        
        let placeholderAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1),
            NSAttributedString.Key.font: UIFont(font: FontFamily.Pretendard.regular, size: adjustedValue(16, .width)) ?? UIFont.systemFont(ofSize: adjustedValue(16, .width))
        ]
        
        textField.attributedPlaceholder = NSAttributedString(
            string: L10n.CreatePromise.Form.titleInputPlaceholder,
            attributes: placeholderAttributes
        )
        
        textField.delegate = self
        textField.addTarget(self, action: #selector(onChangedTitle), for: .editingChanged)
        
        return textField
    }()
    
    private lazy var promiseTitleInputWrapper = {
        let container = UIStackView(arrangedSubviews: [promiseTitleInput])
        container.isLayoutMarginsRelativeArrangement = true
        container.layoutMargins = UIEdgeInsets(
            top: adjustedValue(8, .height),
            left: adjustedValue(16, .width),
            bottom: adjustedValue(8, .height),
            right: adjustedValue(16, .width)
        )
        
        container.layer.borderWidth = adjustedValue(1, .width)
        container.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
        container.layer.cornerRadius = adjustedValue(8, .width)
        
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    @objc private func onChangedTitle(_ textField: UITextField) {
        createPromiseVM.onChangedTitle(textField)
    }
    
    private func assignTitleDidChange() {
        createPromiseVM.titleDidChange = { title in
            DispatchQueue.main.async { [weak self, title] in
                self?.promiseTitleInput.text = title
            }
        }
    }
    
    private func updatePromiseTitleInput(isFocused: Bool) {
        let animationColor = isFocused
        ? UIColor(red: 0.02, green: 0.75, blue: 0.62, alpha: 1).cgColor
        : UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
        
        let borderColorAnimation = CABasicAnimation(keyPath: "borderColor")
        borderColorAnimation.fromValue = promiseTitleInputWrapper.layer.borderColor
        borderColorAnimation.toValue = animationColor
        borderColorAnimation.duration = 0.1
        promiseTitleInputWrapper.layer.add(borderColorAnimation, forKey: "borderColor")
        promiseTitleInputWrapper.layer.borderColor = animationColor
    }
    
    init(vm: CreatePromiseVM) {
        createPromiseVM = vm
        super.init(frame: .null)
        configure()
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        assignTitleDidChange()
    }
    
    private func render() {
        [label, promiseTitleInputWrapper].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            promiseTitleInputWrapper.topAnchor.constraint(equalTo: label.bottomAnchor, constant: adjustedValue(8, .height)),
            promiseTitleInputWrapper.leadingAnchor.constraint(equalTo: leadingAnchor),
            promiseTitleInputWrapper.trailingAnchor.constraint(equalTo: trailingAnchor),
            promiseTitleInputWrapper.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            promiseTitleInputWrapper.heightAnchor.constraint(equalToConstant: adjustedValue(45, .height))
        ])
    }
}

extension FormTitleView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updatePromiseTitleInput(isFocused: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updatePromiseTitleInput(isFocused: false)
    }
}
