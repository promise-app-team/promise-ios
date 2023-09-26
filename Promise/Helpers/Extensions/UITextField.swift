//
//  UITextField.swift
//  Promise
//
//  Created by Sun on 2023/09/16.
//

import UIKit

extension UITextField {
    
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    
    func addSearchIconPadding() {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .regular, scale: .medium)
        guard let leftImage = UIImage(systemName: "magnifyingglass", withConfiguration: imageConfig)?.withTintColor(UIColor.gray, renderingMode: .alwaysOriginal) else { return }
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: self.frame.height))
        
        let imageView = UIImageView()
        containerView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 8),
            imageView.heightAnchor.constraint(equalToConstant: 8)
        ])
        imageView.image = leftImage
        imageView.contentMode = .center
        self.leftView = containerView
        self.leftViewMode = ViewMode.always
    }
    
    func addClearButton(){
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .semibold, scale: .medium)
        guard let image = UIImage(systemName: "xmark", withConfiguration: imageConfig)?.withTintColor(UIColor.gray, renderingMode: .alwaysOriginal) else { return }
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: self.frame.height))
        
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(image, for: .normal)
        clearButton.contentMode = .scaleAspectFit
        clearButton.addTarget(self, action: #selector(clearTextField), for: .touchUpInside)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(clearButton)
        
        NSLayoutConstraint.activate([
            clearButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            clearButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 4),
            clearButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            clearButton.widthAnchor.constraint(equalToConstant: 12),
            clearButton.heightAnchor.constraint(equalToConstant: 12),
        ])
        
        // UITextField 오른쪽 뷰로 버튼을 설정합니다.
        rightView = containerView
        rightViewMode = .never
    }
    
    @objc func clearTextField() {
        text = ""
        rightViewMode = .never
        
    }
}
