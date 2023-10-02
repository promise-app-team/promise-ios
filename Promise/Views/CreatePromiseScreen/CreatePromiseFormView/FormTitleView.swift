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
        label.text = L10n.CreatePromise.formTitleLabel
        label.font = UIFont(font: FontFamily.Pretendard.bold, size: 12)
        label.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var promiseTitleInput = {
        let textField = UITextField()
        
        textField.font = UIFont(font: FontFamily.Pretendard.regular, size: 16)
        
        let placeholderAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1),
            NSAttributedString.Key.font: UIFont(font: FontFamily.Pretendard.regular, size: 16) ?? UIFont.systemFont(ofSize: 16)
        ]
        
        textField.attributedPlaceholder = NSAttributedString(
            string: L10n.CreatePromise.promiseTitleInputPlaceholder,
            attributes: placeholderAttributes
        )
        
        textField.delegate = self
        textField.addTarget(self, action: #selector(onChangedTitle), for: .editingChanged)
        
        let container = UIStackView(arrangedSubviews: [textField])
        container.isLayoutMarginsRelativeArrangement = true
        container.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
        container.layer.cornerRadius = 8
        
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    @objc private func onChangedTitle(_ textField: UITextField) {
        createPromiseVM.onChangedTitle(textField)
    }
    
    private func updatePromiseTitleInput(isFocused: Bool) {
        let animationColor = isFocused
        ? UIColor(red: 0.02, green: 0.75, blue: 0.62, alpha: 1).cgColor
        : UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
        
        let borderColorAnimation = CABasicAnimation(keyPath: "borderColor")
        borderColorAnimation.fromValue = promiseTitleInput.layer.borderColor
        borderColorAnimation.toValue = animationColor
        borderColorAnimation.duration = 0.1
        promiseTitleInput.layer.add(borderColorAnimation, forKey: "borderColor")
        promiseTitleInput.layer.borderColor = animationColor
    }
    
    init(vm: CreatePromiseVM) {
        createPromiseVM = vm
        super.init(frame: .null)
        configureFormTitleView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureFormTitleView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        [label, promiseTitleInput].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            promiseTitleInput.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            promiseTitleInput.leadingAnchor.constraint(equalTo: leadingAnchor),
            promiseTitleInput.trailingAnchor.constraint(equalTo: trailingAnchor),
            promiseTitleInput.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            promiseTitleInput.heightAnchor.constraint(equalToConstant: 45)
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
