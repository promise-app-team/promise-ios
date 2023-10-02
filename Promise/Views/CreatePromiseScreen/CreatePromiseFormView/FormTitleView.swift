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
            string: L10n.CreatePromise.promiseTItleInputPlaceholder,
            attributes: placeholderAttributes
        )
        
        textField.delegate = createPromiseVM
        textField.addTarget(createPromiseVM, action: #selector(createPromiseVM.onChangedTitle), for: .editingChanged)
        
        let container = UIStackView(arrangedSubviews: [textField])
        container.isLayoutMarginsRelativeArrangement = true
        container.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
        container.layer.cornerRadius = 8
        
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
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
